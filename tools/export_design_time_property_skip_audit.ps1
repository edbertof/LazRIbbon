[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$OutputPath = ''
)

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
  $SourceRoot = Split-Path -Parent $scriptRoot
}

$sourceItem = Get-Item -LiteralPath $SourceRoot
if (-not $sourceItem.PSIsContainer) {
  Write-Error "SourceRoot must be a directory: $SourceRoot"
  exit 2
}

$root = $sourceItem.FullName
$registerPath = Join-Path $root 'source/design/LazRibbon_Register.pas'
if (-not (Test-Path -LiteralPath $registerPath)) {
  Write-Error "Design registration unit not found: $registerPath"
  exit 2
}

$content = Get-Content -LiteralPath $registerPath -Raw
$tick = [char]96

function ConvertTo-InlineCode {
  param([string]$Value)
  return $tick + $Value + $tick
}

function ConvertTo-MarkdownTableText {
  param([string]$Value)
  return (($Value -replace '\|', '\|') -replace "`r?`n", ' ').Trim()
}

$constants = @{}
[regex]::Matches($content, "(?ms)^\s*(?<Name>[A-Za-z_][A-Za-z0-9_]*)\s*=\s*'(?<Value>(?:''|[^'])*)';") |
  ForEach-Object {
    $constants[$_.Groups['Name'].Value] = ($_.Groups['Value'].Value -replace "''", "'")
  }

function Resolve-Reason {
  param([string]$RawReason)

  $reason = $RawReason.Trim()
  if ($reason -match "^'(?<Value>(?:''|[^'])*)'$") {
    return ($matches['Value'] -replace "''", "'")
  }
  if ($constants.ContainsKey($reason)) {
    return $constants[$reason]
  }
  if ($reason -match "'(?<Value>(?:''|[^'])*)'") {
    return ($matches['Value'] -replace "''", "'")
  }
  return $reason
}

$entries = New-Object System.Collections.Generic.List[object]

$skipPattern = "(?ms)RegisterPropertyToSkip\s*\(\s*(?<Component>[A-Za-z_][A-Za-z0-9_]*)\s*,\s*'(?<Property>[^']+)'\s*,\s*(?<Reason>.*?)\s*,\s*''\s*\)"
[regex]::Matches($content, $skipPattern) | ForEach-Object {
  $entries.Add([pscustomobject]@{
    Component = $_.Groups['Component'].Value
    Property = $_.Groups['Property'].Value
    Mechanism = 'RegisterPropertyToSkip'
    Reason = Resolve-Reason $_.Groups['Reason'].Value
  }) | Out-Null
}

$nilEditorPattern = "(?ms)RegisterPropertyEditor\s*\(\s*TypeInfo\((?<Type>[^)]+)\)\s*,\s*(?<Component>[A-Za-z_][A-Za-z0-9_]*)\s*,\s*'(?<Property>[^']*)'\s*,\s*nil\s*\)"
[regex]::Matches($content, $nilEditorPattern) | ForEach-Object {
  $entries.Add([pscustomobject]@{
    Component = $_.Groups['Component'].Value
    Property = $_.Groups['Property'].Value
    Mechanism = 'Nil property editor'
    Reason = 'Reliable hide path for inherited properties when RegisterPropertyToSkip alone is not enough in some Lazarus versions.'
  }) | Out-Null
}

$sortedEntries = @($entries | Sort-Object Component, Property, Mechanism)
$skipCount = @($entries | Where-Object { $_.Mechanism -eq 'RegisterPropertyToSkip' }).Count
$nilEditorCount = @($entries | Where-Object { $_.Mechanism -eq 'Nil property editor' }).Count
$componentCount = @($entries | Select-Object -ExpandProperty Component -Unique).Count

$out = New-Object System.Collections.Generic.List[string]
$out.Add('# LazRibbon Design-Time Property Skip Audit for 2.0')
$out.Add('')
$out.Add('Generated from ' + (ConvertTo-InlineCode 'source/design/LazRibbon_Register.pas') + ' by ' + (ConvertTo-InlineCode 'tools/export_design_time_property_skip_audit.ps1') + '.')
$out.Add('It records design-time Object Inspector hiding rules so compatibility-only, structural or obsolete properties stay out of the new-project workflow.')
$out.Add('')
$out.Add('Regenerate after changing design-time property hiding:')
$out.Add('')
$out.Add((ConvertTo-InlineCode 'powershell -ExecutionPolicy Bypass -File tools/export_design_time_property_skip_audit.ps1 -OutputPath docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md'))
$out.Add('')
$out.Add('## Summary')
$out.Add('')
$out.Add(('- RegisterPropertyToSkip rules: {0}' -f $skipCount))
$out.Add(('- Nil property-editor hide rules: {0}' -f $nilEditorCount))
$out.Add(('- Components with hidden design-time properties: {0}' -f $componentCount))
$out.Add('')
$out.Add('## Hidden Object Inspector Properties')
$out.Add('')
$out.Add('| Component | Property | Mechanism | Reason |')
$out.Add('| --- | --- | --- | --- |')
foreach ($entry in $sortedEntries) {
  $out.Add('| ' + (ConvertTo-InlineCode $entry.Component) + ' | ' + (ConvertTo-InlineCode $entry.Property) + ' | ' + (ConvertTo-MarkdownTableText $entry.Mechanism) + ' | ' + (ConvertTo-MarkdownTableText $entry.Reason) + ' |')
}
$out.Add('')
$out.Add('## Component Summary')
$out.Add('')
$out.Add('| Component | Hidden properties |')
$out.Add('| --- | --- |')
$sortedEntries |
  Group-Object Component |
  Sort-Object Name |
  ForEach-Object {
    $properties = ($_.Group | Sort-Object Property -Unique | ForEach-Object { ConvertTo-InlineCode $_.Property }) -join ', '
    $out.Add('| ' + (ConvertTo-InlineCode $_.Name) + ' | ' + $properties + ' |')
  }
$out.Add('')
$out.Add('## Release Gate')
$out.Add('')
$out.Add('Before `2.0.0`, any design-time hidden property should satisfy one of these rules:')
$out.Add('')
$out.Add('- It is obsolete and has a clearer replacement in the Object Inspector.')
$out.Add('- It is compatibility-only for old source or old `.lfm` resources.')
$out.Add('- It is inherited from a broader base class but does not match the narrower component role.')
$out.Add('- It is documented in this generated audit and protected by the consistency audit.')

$text = $out -join [Environment]::NewLine

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  Write-Output $text
}
else {
  $resolvedOutput = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath
  }
  else {
    Join-Path $root $OutputPath
  }
  $outputDir = Split-Path -Parent $resolvedOutput
  if (-not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
  }
  Set-Content -LiteralPath $resolvedOutput -Value $text -Encoding UTF8
  Write-Host "Design-time property skip audit written to $resolvedOutput"
}
