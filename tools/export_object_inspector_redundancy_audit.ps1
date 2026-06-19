[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$SnapshotPath = '',
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

if ([string]::IsNullOrWhiteSpace($SnapshotPath)) {
  $SnapshotPath = Join-Path $root 'docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md'
}
elseif (-not [System.IO.Path]::IsPathRooted($SnapshotPath)) {
  $SnapshotPath = Join-Path $root $SnapshotPath
}

if (-not (Test-Path -LiteralPath $SnapshotPath)) {
  Write-Error "Object Inspector surface snapshot not found: $SnapshotPath"
  exit 2
}

$tick = [char]96
$linesIn = Get-Content -LiteralPath $SnapshotPath
$properties = New-Object System.Collections.Generic.List[object]
$currentClass = ''

foreach ($line in $linesIn) {
  if ($line -match '^###\s+(.+)$') {
    $currentClass = $matches[1].Trim()
    continue
  }

  $prefix = '- ' + $tick
  if (-not $line.StartsWith($prefix)) {
    continue
  }

  $remaining = $line.Substring($prefix.Length)
  $nameEnd = $remaining.IndexOf($tick)
  if ($nameEnd -lt 1) {
    continue
  }

  $propertyName = $remaining.Substring(0, $nameEnd)
  $afterName = $remaining.Substring($nameEnd + 1)
  $marker = ': ' + $tick
  $declaration = ''
  $declarationStart = $afterName.IndexOf($marker)
  if ($declarationStart -ge 0) {
    $declaration = $afterName.Substring($declarationStart + $marker.Length)
    if ($declaration.EndsWith($tick)) {
      $declaration = $declaration.Substring(0, $declaration.Length - 1)
    }
  }

  if ([string]::IsNullOrWhiteSpace($currentClass)) {
    throw "Property $propertyName was found before a class heading in $SnapshotPath."
  }

  $properties.Add([pscustomobject]@{
    ClassName = $currentClass
    Name = $propertyName
    Declaration = $declaration
  }) | Out-Null
}

function New-Rule {
  param(
    [Parameter(Mandatory = $true)][string]$Category,
    [Parameter(Mandatory = $true)][string]$Rationale
  )

  [pscustomobject]@{
    Category = $Category
    Rationale = $Rationale
  }
}

$rules = @{}

foreach ($name in @(
  'Align',
  'Anchors',
  'BorderSpacing',
  'Color',
  'Constraints',
  'Font',
  'ParentColor',
  'ParentFont',
  'ParentShowHint',
  'PopupMenu',
  'ShowHint',
  'Visible'
)) {
  $rules[$name] = New-Rule -Category 'Inherited LCL surface' -Rationale 'Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components.'
}

foreach ($name in @('Enabled', 'Hint', 'OnClick', 'OnResize')) {
  $rules[$name] = New-Rule -Category 'Inherited LCL and command state' -Rationale 'Normal Lazarus interaction vocabulary that remains meaningful on visible controls and command entries.'
}

foreach ($name in @(
  'Action',
  'ImageIndex',
  'LargeImageIndex',
  'LinkedItem',
  'ScreenTipFooter',
  'ScreenTipShortcut',
  'ScreenTipText',
  'ScreenTipTitle',
  'ShowScreenTip'
)) {
  $rules[$name] = New-Rule -Category 'Command surface vocabulary' -Rationale 'Shared command metadata used by Ribbon, QAT and BackStage command entries.'
}

$rules['Caption'] = New-Rule -Category 'Display text vocabulary' -Rationale 'Visible text for tabs, panes, buttons and command-like items. This is the expected Pascal/LCL name for a label shown to the user.'
$rules['KeyTip'] = New-Rule -Category 'Office keyboard vocabulary' -Rationale 'Office-like keyboard hint used by Application Button, tabs and command entries.'

foreach ($name in @('Images', 'LargeImages', 'Ribbon', 'SkinManager')) {
  $rules[$name] = New-Rule -Category 'Component link vocabulary' -Rationale 'Reference to an external image list, owner Ribbon or skin manager used to connect components in the documented object graph.'
}

foreach ($name in @('Items', 'StorageSection')) {
  $rules[$name] = New-Rule -Category 'Owned collection/list vocabulary' -Rationale 'Owner-owned item/list storage. The name is acceptable when a component exposes a single primary collection or persisted list.'
}

foreach ($name in @('Appearance', 'AppearanceSource', 'Style')) {
  $rules[$name] = New-Rule -Category 'Visual source and appearance vocabulary' -Rationale 'Visual model or source decision. This is acceptable only where the component owns or chooses its own appearance model.'
}

foreach ($name in @('Columns', 'IconHeight', 'IconWidth', 'ItemHeight', 'SelectedSkinName', 'OnSkinSelected')) {
  $rules[$name] = New-Rule -Category 'Selector and gallery vocabulary' -Rationale 'Grid, icon or selection setting shared by gallery-like controls and skin selector surfaces.'
}

foreach ($name in @(
  'HotColor',
  'MutedTextColor',
  'NavigationColor',
  'SelectedColor',
  'SelectedFrameColor',
  'TextColor'
)) {
  $rules[$name] = New-Rule -Category 'Skin palette vocabulary' -Rationale 'Low-level color slot inside skin palette subobjects, not a first-level component decision.'
}

function ConvertTo-InlineCode {
  param([string]$Value)
  return $tick + $Value + $tick
}

function ConvertTo-MarkdownTableText {
  param([string]$Value)
  return (($Value -replace '\|', '\|') -replace "`r?`n", ' ').Trim()
}

$sharedGroups = $properties |
  Group-Object Name |
  Where-Object { $_.Count -gt 1 } |
  Sort-Object Name

$unclassified = @($sharedGroups | Where-Object { -not $rules.ContainsKey($_.Name) })

$categoryRows = @(
  [pscustomobject]@{ Category = 'Inherited LCL surface'; Meaning = 'Properties inherited from standard Lazarus control/component behavior.' },
  [pscustomobject]@{ Category = 'Inherited LCL and command state'; Meaning = 'Common interaction state that is meaningful on controls and command entries.' },
  [pscustomobject]@{ Category = 'Command surface vocabulary'; Meaning = 'Command metadata shared by Ribbon, QAT and BackStage commands.' },
  [pscustomobject]@{ Category = 'Display text vocabulary'; Meaning = 'Visible user-facing labels.' },
  [pscustomobject]@{ Category = 'Office keyboard vocabulary'; Meaning = 'Office-like keyboard navigation hints.' },
  [pscustomobject]@{ Category = 'Component link vocabulary'; Meaning = 'References that connect components into the Ribbon object graph.' },
  [pscustomobject]@{ Category = 'Owned collection/list vocabulary'; Meaning = 'A component-owned primary collection or persisted list.' },
  [pscustomobject]@{ Category = 'Visual source and appearance vocabulary'; Meaning = 'Visual model or source-selection properties.' },
  [pscustomobject]@{ Category = 'Selector and gallery vocabulary'; Meaning = 'Gallery/grid and skin-selection sizing or selection properties.' },
  [pscustomobject]@{ Category = 'Skin palette vocabulary'; Meaning = 'Low-level color slots inside skin palette subobjects.' }
)

$out = New-Object System.Collections.Generic.List[string]
$out.Add('# LazRibbon Object Inspector Redundancy Audit for 2.0')
$out.Add('')
$out.Add('Generated from ' + (ConvertTo-InlineCode 'docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md') + ' by ' + (ConvertTo-InlineCode 'tools/export_object_inspector_redundancy_audit.ps1') + '.')
$out.Add('It classifies repeated direct ' + (ConvertTo-InlineCode 'published') + ' property names so intentional shared vocabulary is separated from suspicious redundancy before the 2.0 API freeze.')
$out.Add('')
$out.Add('Regenerate after refreshing the Object Inspector surface snapshot:')
$out.Add('')
$out.Add((ConvertTo-InlineCode 'powershell -ExecutionPolicy Bypass -File tools/export_object_inspector_redundancy_audit.ps1 -OutputPath docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md'))
$out.Add('')
$out.Add('## Summary')
$out.Add('')
$out.Add(('- Published properties scanned: {0}' -f $properties.Count))
$out.Add(('- Repeated published property names reviewed: {0}' -f $sharedGroups.Count))
$out.Add(('- Unclassified repeated property names: {0}' -f $unclassified.Count))
if ($unclassified.Count -eq 0) {
  $out.Add('- No unclassified repeated property names were found.')
}
else {
  $out.Add('- Unclassified names require a new rule or an API cleanup before the 2.0 freeze.')
}
$out.Add('')
$out.Add('## Classification Rules')
$out.Add('')
$out.Add('| Category | Meaning |')
$out.Add('| --- | --- |')
foreach ($row in $categoryRows) {
  $out.Add('| ' + (ConvertTo-MarkdownTableText $row.Category) + ' | ' + (ConvertTo-MarkdownTableText $row.Meaning) + ' |')
}
$out.Add('')
$out.Add('## Shared Property Names')
$out.Add('')
$out.Add('| Property | Category | Components | Rationale |')
$out.Add('| --- | --- | --- | --- |')
foreach ($group in $sharedGroups) {
  $rule = if ($rules.ContainsKey($group.Name)) { $rules[$group.Name] } else { New-Rule -Category 'Unclassified' -Rationale 'Needs review before the 2.0 API freeze.' }
  $components = ($group.Group | Sort-Object ClassName -Unique | ForEach-Object { ConvertTo-InlineCode $_.ClassName }) -join ', '
  $out.Add('| ' + (ConvertTo-InlineCode $group.Name) + ' | ' + (ConvertTo-MarkdownTableText $rule.Category) + ' | ' + $components + ' | ' + (ConvertTo-MarkdownTableText $rule.Rationale) + ' |')
}
$out.Add('')
$out.Add('## Watch List For Future Changes')
$out.Add('')
$out.Add('| Property | Future rule |')
$out.Add('| --- | --- |')
$out.Add('| ' + (ConvertTo-InlineCode 'Items') + ' | Accept only for a single primary owned collection/list. If a component gains more than one list, prefer a specific name. |')
$out.Add('| ' + (ConvertTo-InlineCode 'Style') + ' | Accept only when the type is local and obvious. Prefer explicit names for new visual decisions. |')
$out.Add('| ' + (ConvertTo-InlineCode 'Columns') + ' | Accept only for gallery or selector grid layout. |')
$out.Add('| ' + (ConvertTo-InlineCode 'Appearance') + ' | Accept only where the component owns a complete appearance model. Top-level Ribbon uses ' + (ConvertTo-InlineCode 'RibbonAppearance') + '. |')
$out.Add('| ' + (ConvertTo-InlineCode 'SkinManager') + ' | Accept as a component link. Do not duplicate it beside another property that answers the same visual-source question. |')
$out.Add('')
$out.Add('## Release Gate')
$out.Add('')
$out.Add('Before `2.0.0`, a newly repeated published property name must satisfy one of these checks:')
$out.Add('')
$out.Add('- It fits an existing category in this audit.')
$out.Add('- It is added to this audit with a clear rationale.')
$out.Add('- It is renamed, hidden from the Object Inspector or moved to compatibility-only API if it duplicates another developer decision.')
$out.Add('- The regenerated audit still reports: No unclassified repeated property names were found.')

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
  Write-Host "Object Inspector redundancy audit written to $resolvedOutput"
}
