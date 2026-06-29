[CmdletBinding()]
param(
  [string]$SourceRoot,
  [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
  $SourceRoot = Split-Path -Parent $scriptRoot
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  $OutputPath = Join-Path $SourceRoot 'docs/quality/SKIN_EDITOR_APPEARANCE_COVERAGE_2_1.md'
}

$runtimePath = Join-Path $SourceRoot 'source/runtime/LazRibbon_Appearance.pas'
$nativeEditorPath = Join-Path $SourceRoot 'source/design/LazRibbon_AppearanceEditor.pas'
$nativeEditorLfmPath = Join-Path $SourceRoot 'source/design/LazRibbon_AppearanceEditor.lfm'
$standaloneEditorPath = Join-Path $SourceRoot 'tools/LazRibbonSkinEditor/uSkinEditorMain.pas'
$standaloneEditorLfmPath = Join-Path $SourceRoot 'tools/LazRibbonSkinEditor/uSkinEditorMain.lfm'

foreach ($requiredPath in @($runtimePath, $nativeEditorPath, $nativeEditorLfmPath, $standaloneEditorPath, $standaloneEditorLfmPath)) {
  if (-not (Test-Path -LiteralPath $requiredPath)) {
    throw "Required file not found: $requiredPath"
  }
}

function Get-Text {
  param([string]$Path)
  return Get-Content -LiteralPath $Path -Raw
}

function ConvertTo-NormalizedToken {
  param([string]$Value)
  if ($null -eq $Value) {
    return ''
  }
  return ($Value.ToLowerInvariant() -replace '[^a-z0-9]', '')
}

function Test-NormalizedMention {
  param(
    [string]$NormalizedHaystack,
    [string]$Needle
  )

  $normalizedNeedle = ConvertTo-NormalizedToken $Needle
  if ([string]::IsNullOrWhiteSpace($normalizedNeedle)) {
    return $false
  }
  return $NormalizedHaystack.Contains($normalizedNeedle)
}

function Get-PublishedAppearanceProperties {
  param(
    [string]$Text,
    [string]$ClassName
  )

  $escapedClassName = [regex]::Escape($ClassName)
  $classPattern = "(?ms)^\s*$escapedClassName\s*=\s*class\s*\(TPersistent\)(?<Body>.*?)^\s*end;"
  $match = [regex]::Match($Text, $classPattern)
  if (-not $match.Success) {
    throw "Appearance class not found: $ClassName"
  }

  $body = $match.Groups['Body'].Value
  $publishedIndex = $body.ToLowerInvariant().IndexOf('published')
  if ($publishedIndex -lt 0) {
    return @()
  }

  $publishedText = $body.Substring($publishedIndex)
  $propertyMatches = [regex]::Matches($publishedText, '(?m)^\s*property\s+(?<Name>[A-Za-z_][A-Za-z0-9_]*)\s*:\s*(?<Type>[^;]+?)\s+read\s+')
  $result = New-Object System.Collections.Generic.List[object]
  foreach ($propertyMatch in $propertyMatches) {
    $result.Add([pscustomobject]@{
      Name = $propertyMatch.Groups['Name'].Value
      Type = ($propertyMatch.Groups['Type'].Value -replace '\s+', ' ').Trim()
    })
  }
  return $result.ToArray()
}

$runtimeText = Get-Text $runtimePath
$nativeEditorText = (Get-Text $nativeEditorPath) + "`n" + (Get-Text $nativeEditorLfmPath)
$standaloneEditorText = (Get-Text $standaloneEditorPath) + "`n" + (Get-Text $standaloneEditorLfmPath)
$nativeEditorNormalized = ConvertTo-NormalizedToken $nativeEditorText
$standaloneEditorNormalized = ConvertTo-NormalizedToken $standaloneEditorText

$sections = @(
  [pscustomobject]@{ Name = 'Tab'; ClassName = 'TLazRibbonTabAppearance' },
  [pscustomobject]@{ Name = 'MenuButton'; ClassName = 'TLazRibbonMenuButtonAppearance' },
  [pscustomobject]@{ Name = 'Pane'; ClassName = 'TLazRibbonPaneAppearance' },
  [pscustomobject]@{ Name = 'Element'; ClassName = 'TLazRibbonElementAppearance' },
  [pscustomobject]@{ Name = 'Popup'; ClassName = 'TLazRibbonPopupMenuAppearance' }
)

$rows = New-Object System.Collections.Generic.List[object]
foreach ($section in $sections) {
  $properties = Get-PublishedAppearanceProperties -Text $runtimeText -ClassName $section.ClassName
  foreach ($property in $properties) {
    $rows.Add([pscustomobject]@{
      Section = $section.Name
      Property = $property.Name
      Type = $property.Type
      NativeVisualMention = (Test-NormalizedMention -NormalizedHaystack $nativeEditorNormalized -Needle $property.Name)
      StandaloneDirectMention = (Test-NormalizedMention -NormalizedHaystack $standaloneEditorNormalized -Needle $property.Name)
    })
  }
}

$standaloneHasGenericInspector =
  ($standaloneEditorText -match 'GetPropList') -and
  ($standaloneEditorText -match 'AddAppearanceSectionProperties') -and
  ($standaloneEditorText -match 'EditAppearanceProperty')

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('# Skin Editor Appearance Coverage For 2.1')
$lines.Add('')
$lines.Add('This generated report compares the published `TLazRibbonToolbarAppearance` section properties with the current appearance-editing surfaces.')
$lines.Add('')
$lines.Add('- Source model: `source/runtime/LazRibbon_Appearance.pas`')
$lines.Add('- Native visual editor: `source/design/LazRibbon_AppearanceEditor.pas` and `.lfm`')
$lines.Add('- Standalone Skin Editor: `tools/LazRibbonSkinEditor/uSkinEditorMain.pas` and `.lfm`')
$lines.Add('- Generator: `tools/export_skin_editor_2_1_coverage.ps1`')
$lines.Add('')
$lines.Add('## Summary')
$lines.Add('')
$lines.Add('| Section | Published properties | Native visual mentions | Standalone direct mentions | Standalone RTTI inspector |')
$lines.Add('| --- | ---: | ---: | ---: | --- |')

foreach ($section in $sections) {
  $sectionRows = @($rows | Where-Object { $_.Section -eq $section.Name })
  $nativeCount = @($sectionRows | Where-Object { $_.NativeVisualMention }).Count
  $standaloneDirectCount = @($sectionRows | Where-Object { $_.StandaloneDirectMention }).Count
  $genericText = if ($standaloneHasGenericInspector) { 'Yes' } else { 'No' }
  $lines.Add(('| {0} | {1} | {2} | {3} | {4} |' -f $section.Name, $sectionRows.Count, $nativeCount, $standaloneDirectCount, $genericText))
}

$lines.Add('')
$lines.Add('## Interpretation')
$lines.Add('')
$lines.Add('- The native visual appearance editor remains the reference visual editor for detailed `Appearance` tuning.')
$lines.Add('- The standalone Skin Editor has generic RTTI coverage when `GetPropList`, `AddAppearanceSectionProperties` and `EditAppearanceProperty` are present; this means every published property can be listed and edited even when it has no dedicated visual control.')
$lines.Add('- For 2.1, dedicated standalone controls should be added only where they improve workflow: base comparison, common color groups, reset/apply actions, preview states and high-frequency skin edits.')
$lines.Add('- If a new published `Appearance` property is added, regenerate this report and check whether it deserves a native visual control, a standalone direct helper, or generic RTTI-only coverage.')
$lines.Add('')
$lines.Add('## Property Detail')
$lines.Add('')
$lines.Add('| Property | Type | Native visual mention | Standalone direct mention | Standalone coverage | 2.1 follow-up |')
$lines.Add('| --- | --- | --- | --- | --- | --- |')

foreach ($row in $rows) {
  $nativeText = if ($row.NativeVisualMention) { 'Yes' } else { 'No' }
  $directText = if ($row.StandaloneDirectMention) { 'Yes' } else { 'No' }
  $coverageText = if ($standaloneHasGenericInspector) { 'RTTI inspector' } else { 'Missing' }
  $followUp = if ($row.StandaloneDirectMention) {
    'Keep direct helper synchronized.'
  } else {
    'Use RTTI editor; consider visual helper only if this becomes a common skin workflow.'
  }
  $lines.Add(('| {0}.{1} | `{2}` | {3} | {4} | {5} | {6} |' -f $row.Section, $row.Property, $row.Type, $nativeText, $directText, $coverageText, $followUp))
}

$lines.Add('')
$lines.Add('## 2.1 Decision')
$lines.Add('')
$lines.Add('The first 2.1 Skin Editor pass should improve workflow around the existing complete RTTI inspector instead of duplicating every `Appearance` property with a hand-built control. The editor should make the full model visible, searchable, comparable against a base skin and easy to preview, while reserving custom controls for operations that are hard to express as single-property edits.')

$outputDirectory = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
  New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}

Set-Content -LiteralPath $OutputPath -Value $lines -Encoding ASCII
Write-Host "Skin Editor 2.1 coverage report written to $OutputPath"
