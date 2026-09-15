[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$Version = '2.1.13',
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
$tick = [char]96
$script:gates = New-Object System.Collections.Generic.List[object]

function Join-SourcePath {
  param([Parameter(Mandatory = $true)][string]$RelativePath)
  return Join-Path $root $RelativePath
}

function Test-SourcePath {
  param([Parameter(Mandatory = $true)][string]$RelativePath)
  return (Test-Path -LiteralPath (Join-SourcePath $RelativePath))
}

function Test-FileReady {
  param(
    [Parameter(Mandatory = $true)][string]$RelativePath,
    [int64]$MinimumBytes = 1
  )

  $path = Join-SourcePath $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    return $false
  }
  $item = Get-Item -LiteralPath $path
  return ((-not $item.PSIsContainer) -and ($item.Length -ge $MinimumBytes))
}

function Read-SourceText {
  param([Parameter(Mandatory = $true)][string]$RelativePath)

  $path = Join-SourcePath $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    return ''
  }
  return Get-Content -LiteralPath $path -Raw
}

function Get-PackageVersion {
  param([Parameter(Mandatory = $true)][string]$RelativePath)

  $path = Join-SourcePath $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    return '<missing>'
  }

  [xml]$xml = Get-Content -LiteralPath $path -Raw
  $versionNode = $xml.SelectSingleNode('/CONFIG/Package/Version[@Major]')
  if ($null -eq $versionNode) {
    return '<missing>'
  }
  return ('{0}.{1}.{2}' -f $versionNode.Major, $versionNode.Minor, $versionNode.Release)
}

function ConvertTo-InlineCode {
  param([string]$Value)
  return $tick + $Value + $tick
}

function ConvertTo-MarkdownTableText {
  param([string]$Value)
  return (($Value -replace '\|', '\|') -replace "`r?`n", ' ').Trim()
}

function Add-Gate {
  param(
    [Parameter(Mandatory = $true)][string]$Area,
    [Parameter(Mandatory = $true)][string]$Gate,
    [Parameter(Mandatory = $true)][string]$Status,
    [Parameter(Mandatory = $true)][string]$Evidence,
    [string]$NextStep = ''
  )

  if ([string]::IsNullOrWhiteSpace($NextStep)) {
    $NextStep = 'Keep under routine release validation.'
  }

  $script:gates.Add([pscustomobject]@{
    Area = $Area
    Gate = $Gate
    Status = $Status
    Evidence = $Evidence
    NextStep = $NextStep
  }) | Out-Null
}

function Test-AllTextContains {
  param(
    [Parameter(Mandatory = $true)][string]$Text,
    [Parameter(Mandatory = $true)][string[]]$Required
  )

  foreach ($item in $Required) {
    if ($Text -notmatch [regex]::Escape($item)) {
      return $false
    }
  }
  return $true
}

$runtimeVersion = Get-PackageVersion 'packages/LazRibbonRuntime.lpk'
$designVersion = Get-PackageVersion 'packages/LazRibbonDesign.lpk'
$readme = Read-SourceText 'README.md'
$install = Read-SourceText 'INSTALL.md'
$changelog = Read-SourceText 'CHANGELOG.md'
$status = Read-SourceText 'STATUS.md'
$roadmap21 = Read-SourceText 'docs/release/ROADMAP_2_1.md'
$apiReadiness = Read-SourceText 'docs/release/API_FREEZE_READINESS_2_0.md'
$demoMatrix = Read-SourceText 'docs/release/DEMO_VALIDATION_MATRIX.md'
$skinCoverage = Read-SourceText 'docs/quality/SKIN_EDITOR_APPEARANCE_COVERAGE_2_1.md'
$accelerationAudit = Read-SourceText 'docs/quality/LAZRIBBON_2_1_ACCELERATION_AUDIT.md'

$demoRoot = Join-SourcePath 'demos'
$demoProjectCount = 0
if (Test-Path -LiteralPath $demoRoot) {
  $demoProjectCount = @(Get-ChildItem -LiteralPath $demoRoot -Recurse -File -Filter '*.lpi').Count
}

$screenshotPaths = @(
  'docs/assets/screenshots/showcase-main.png',
  'docs/assets/screenshots/showcase-backstage.png',
  'docs/assets/screenshots/showcase-skins.png',
  'docs/assets/screenshots/skin-editor.png'
)
$screenshotReadyCount = 0
foreach ($path in $screenshotPaths) {
  if (Test-FileReady $path 5000) {
    $screenshotReadyCount++
  }
}

$githubTemplatePaths = @(
  '.github/ISSUE_TEMPLATE/bug_report.md',
  '.github/ISSUE_TEMPLATE/feature_request.md',
  '.github/ISSUE_TEMPLATE/lazarus_compatibility.md',
  '.github/PULL_REQUEST_TEMPLATE.md'
)
$githubTemplateReadyCount = 0
foreach ($path in $githubTemplatePaths) {
  if (Test-FileReady $path 100) {
    $githubTemplateReadyCount++
  }
}

$releaseScriptPaths = @(
  'tools/check_project_consistency.ps1',
  'tools/build_all_projects.ps1',
  'tools/build_release_zip.ps1',
  'tools/check_release_zip.ps1',
  'tools/verify_clean_checkout.ps1',
  'tools/verify_release_candidate.ps1'
)
$releaseScriptReadyCount = 0
foreach ($path in $releaseScriptPaths) {
  if (Test-FileReady $path 100) {
    $releaseScriptReadyCount++
  }
}

$qualityReportPaths = @(
  'docs/quality/PUBLIC_API_AUDIT_2_0.md',
  'docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md',
  'docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md',
  'docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md',
  'docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md',
  'docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md',
  'docs/quality/SKIN_EDITOR_APPEARANCE_COVERAGE_2_1.md',
  'docs/quality/LAZRIBBON_2_1_ACCELERATION_AUDIT.md',
  'docs/release/API_FREEZE_READINESS_2_0.md'
)
$qualityReportReadyCount = 0
foreach ($path in $qualityReportPaths) {
  if (Test-FileReady $path 500) {
    $qualityReportReadyCount++
  }
}

$manualPaths = @(
  'docs/manual/LAZRIBBON_MANUAL.md',
  'docs/manual/LAZRIBBON_MANUAL.docx',
  'docs/manual/LAZRIBBON_COMPONENT_REFERENCE.md',
  'docs/manual/LAZRIBBON_COMPONENT_REFERENCE.docx'
)
$manualReadyCount = 0
foreach ($path in $manualPaths) {
  if (Test-FileReady $path 1000) {
    $manualReadyCount++
  }
}

$repositoryHealthPaths = @(
  'README.md',
  'LICENSE.txt',
  'CHANGELOG.md',
  'STATUS.md',
  'CONTRIBUTING.md',
  'SUPPORT.md',
  'SECURITY.md'
)
$repositoryHealthReadyCount = 0
foreach ($path in $repositoryHealthPaths) {
  if (Test-FileReady $path 100) {
    $repositoryHealthReadyCount++
  }
}

$releaseNotesPath = 'docs/release/RELEASE_' + ($Version -replace '\.', '_') + '.md'

Add-Gate 'Repository trust' 'Package metadata aligned' `
  ($(if (($runtimeVersion -eq $Version) -and ($designVersion -eq $Version)) { 'Ready' } else { 'Review' })) `
  "Runtime $runtimeVersion; design $designVersion; expected $Version." `
  'Keep runtime and design package versions synchronized before tagging.'

Add-Gate 'Repository trust' 'Public identity files present' `
  ($(if ($repositoryHealthReadyCount -eq $repositoryHealthPaths.Count) { 'Ready' } else { 'Review' })) `
  "$repositoryHealthReadyCount of $($repositoryHealthPaths.Count) README/license/changelog/status/contribution/support/security files are present." `
  'Keep the top-level repository readable before a user opens Lazarus.'

Add-Gate 'Repository trust' 'GitHub collaboration templates present' `
  ($(if ($githubTemplateReadyCount -eq $githubTemplatePaths.Count) { 'Ready' } else { 'Review' })) `
  "$githubTemplateReadyCount of $($githubTemplatePaths.Count) GitHub templates are present." `
  'Keep bug, feature, Lazarus compatibility and pull-request intake structured.'

Add-Gate 'Developer onboarding' 'README explains the normal composition model' `
  ($(if (Test-AllTextContains $readme @('First Ribbon Form', 'TLazRibbonForm', 'TLazRibbonSkinManager', 'TLazRibbon.BackstageView', 'tools/verify_release_candidate.ps1')) { 'Ready' } else { 'Review' })) `
  'README covers first form creation, SkinManager styling, BackStage linking and release validation.' `
  'Keep first-use instructions aligned with the Object Inspector model.'

Add-Gate 'Developer onboarding' 'Installation guide present' `
  ($(if ((Test-FileReady 'INSTALL.md' 500) -and (Test-AllTextContains $install @('Lazarus', 'LazRibbonRuntime.lpk', 'LazRibbonDesign.lpk'))) { 'Ready' } else { 'Review' })) `
  'INSTALL.md explains runtime and design-time package installation.' `
  'Keep install steps updated for supported Lazarus/FPC versions.'

Add-Gate 'Developer onboarding' 'Manual and component reference available' `
  ($(if ($manualReadyCount -eq $manualPaths.Count) { 'Ready' } else { 'Review' })) `
  "$manualReadyCount of $($manualPaths.Count) manual/reference artifacts are present." `
  'Regenerate Markdown and DOCX references after workflow or API changes.'

Add-Gate 'Developer onboarding' 'Public screenshots available' `
  ($(if ($screenshotReadyCount -eq $screenshotPaths.Count) { 'Ready' } else { 'Review' })) `
  "$screenshotReadyCount of $($screenshotPaths.Count) public screenshot assets are present." `
  'Refresh screenshots after visible UI changes.'

Add-Gate 'Technical planning' 'API and property governance reports present' `
  ($(if ($qualityReportReadyCount -eq $qualityReportPaths.Count) { 'Ready' } else { 'Review' })) `
  "$qualityReportReadyCount of $($qualityReportPaths.Count) API, Object Inspector, Skin Editor and release readiness reports are present." `
  'Regenerate reports whenever published properties, design-time hides or Skin Editor coverage change.'

Add-Gate 'Technical planning' 'API freeze readiness remains green' `
  ($(if (Test-AllTextContains $apiReadiness @('Gates needing review: 0', 'Unclassified repeated property names: 0', 'Package/tool/demo build targets listed')) { 'Ready' } else { 'Review' })) `
  'The API readiness report has no review gates and no unclassified repeated property names.' `
  'Do not add published properties without updating the governed Object Inspector reports.'

Add-Gate 'Skin authoring' 'Skin Editor workflow is documented and covered' `
  ($(if ((Test-FileReady 'tools/LazRibbonSkinEditor/LazRibbonSkinEditor.lpi' 100) -and (Test-AllTextContains $skinCoverage @('Standalone RTTI inspector', 'Published properties', 'Tab', 'MenuButton', 'Pane', 'Element', 'Popup')) -and (Test-AllTextContains $accelerationAudit @('Skin Editor workflow', 'Ajuste avancado', 'validation page', 'Base x skin atual'))) { 'Ready' } else { 'Review' })) `
  'The standalone Skin Editor has full Appearance coverage and documented workflow improvements.' `
  'Keep workflow language, preview states and validation behavior aligned.'

Add-Gate 'Demos and examples' 'Demo matrix reflects real adoption paths' `
  ($(if (($demoProjectCount -ge 16) -and (Test-AllTextContains $demoMatrix @('Workbench CRUD', 'Showcase', 'Skin Editor Sample', 'Popup Menu', 'TLazRibbonForm', 'TLazRibbonSkinManager'))) { 'Ready' } else { 'Review' })) `
  "$demoProjectCount demo projects found and the matrix names the main adoption scenarios." `
  'Add focused demos only when they teach a distinct composition pattern.'

Add-Gate 'Release automation' 'Release scripts present' `
  ($(if ($releaseScriptReadyCount -eq $releaseScriptPaths.Count) { 'Ready' } else { 'Review' })) `
  "$releaseScriptReadyCount of $($releaseScriptPaths.Count) release and validation scripts are present." `
  'Keep release validation executable from a clean checkout.'

Add-Gate 'Release automation' 'Current release notes staged' `
  ($(if (Test-FileReady $releaseNotesPath 500) { 'Ready' } else { 'Review' })) `
  "$releaseNotesPath is the expected release note document for $Version." `
  'Create release notes before building the public ZIP.'

Add-Gate 'Release automation' '2.1 roadmap tracks professional readiness' `
  ($(if (Test-AllTextContains $roadmap21 @('Release Goal', 'Distribution Polish', 'Definition Of Done For 2.1', 'professional readiness')) { 'Ready' } else { 'Review' })) `
  'The 2.1 roadmap links workflow quality, distribution polish and readiness criteria.' `
  'Keep the roadmap focused on developer adoption rather than ad hoc feature growth.'

$readyCount = @($gates | Where-Object { $_.Status -eq 'Ready' }).Count
$manualCount = @($gates | Where-Object { $_.Status -eq 'Manual' }).Count
$reviewCount = @($gates | Where-Object { $_.Status -eq 'Review' }).Count

$out = New-Object System.Collections.Generic.List[string]
$out.Add('# LazRibbon 2.1 Professional Readiness')
$out.Add('')
$out.Add('Generated by ' + (ConvertTo-InlineCode 'tools/export_professional_readiness_2_1.ps1') + ' from repository, documentation, quality and release workflow files.')
$out.Add('This report turns "professional and adoption-ready" into repeatable checks. It complements the API freeze reports by looking at the full package experience: trust, onboarding, Skin Editor workflow, demos and release automation.')
$out.Add('')
$out.Add('Regenerate after changing package metadata, docs, screenshots, GitHub templates, demos, release scripts or quality reports:')
$out.Add('')
$out.Add((ConvertTo-InlineCode 'powershell -ExecutionPolicy Bypass -File tools/export_professional_readiness_2_1.ps1 -OutputPath docs/quality/PROFESSIONAL_READINESS_2_1.md'))
$out.Add('')
$out.Add('## Summary')
$out.Add('')
$out.Add(('- Target version: {0}' -f $Version))
$out.Add(('- Runtime package version: {0}' -f $runtimeVersion))
$out.Add(('- Design-time package version: {0}' -f $designVersion))
$out.Add(('- Demo projects discovered: {0}' -f $demoProjectCount))
$out.Add(('- Screenshot assets ready: {0}/{1}' -f $screenshotReadyCount, $screenshotPaths.Count))
$out.Add(('- GitHub templates ready: {0}/{1}' -f $githubTemplateReadyCount, $githubTemplatePaths.Count))
$out.Add(('- Repository health files ready: {0}/{1}' -f $repositoryHealthReadyCount, $repositoryHealthPaths.Count))
$out.Add(('- Manual/reference artifacts ready: {0}/{1}' -f $manualReadyCount, $manualPaths.Count))
$out.Add(('- Quality reports ready: {0}/{1}' -f $qualityReportReadyCount, $qualityReportPaths.Count))
$out.Add(('- Release scripts ready: {0}/{1}' -f $releaseScriptReadyCount, $releaseScriptPaths.Count))
$out.Add(('- Gates ready: {0}' -f $readyCount))
$out.Add(('- Gates requiring manual validation: {0}' -f $manualCount))
$out.Add(('- Gates needing review: {0}' -f $reviewCount))
$out.Add('')
$out.Add('## Gate Status')
$out.Add('')
$out.Add('| Area | Gate | Status | Evidence | Next step |')
$out.Add('| --- | --- | --- | --- | --- |')
foreach ($gate in $gates) {
  $out.Add('| ' + (ConvertTo-MarkdownTableText $gate.Area) + ' | ' + (ConvertTo-MarkdownTableText $gate.Gate) + ' | ' + (ConvertTo-MarkdownTableText $gate.Status) + ' | ' + (ConvertTo-MarkdownTableText $gate.Evidence) + ' | ' + (ConvertTo-MarkdownTableText $gate.NextStep) + ' |')
}
$out.Add('')
$out.Add('## Current Conclusion')
$out.Add('')
if ($reviewCount -eq 0) {
  $out.Add('The project has a professional adoption baseline: the public API is governed, the Skin Editor workflow is documented, demos cover the main composition paths, GitHub intake files exist and release validation is repeatable from a clean source tree.')
}
else {
  $out.Add('The package is close, but one or more professional-readiness gates need review before the next public release should be tagged.')
}
$out.Add('')
$out.Add('## Source Documents')
$out.Add('')
foreach ($path in @(
  'README.md',
  'INSTALL.md',
  'CONTRIBUTING.md',
  'SUPPORT.md',
  'SECURITY.md',
  'CHANGELOG.md',
  'STATUS.md',
  'docs/manual/LAZRIBBON_MANUAL.md',
  'docs/manual/LAZRIBBON_COMPONENT_REFERENCE.md',
  'docs/quality/PUBLIC_API_AUDIT_2_0.md',
  'docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md',
  'docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md',
  'docs/quality/SKIN_EDITOR_APPEARANCE_COVERAGE_2_1.md',
  'docs/quality/LAZRIBBON_2_1_ACCELERATION_AUDIT.md',
  'docs/release/API_FREEZE_READINESS_2_0.md',
  'docs/release/DEMO_VALIDATION_MATRIX.md',
  'docs/release/ROADMAP_2_1.md'
)) {
  $out.Add('- ' + (ConvertTo-InlineCode $path))
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  $out
}
else {
  if (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $root $OutputPath
  }
  $parent = Split-Path -Parent $OutputPath
  if (-not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent | Out-Null
  }
  [System.IO.File]::WriteAllLines($OutputPath, [string[]]$out, [System.Text.Encoding]::UTF8)
}
