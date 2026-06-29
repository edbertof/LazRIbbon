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
$tick = [char]96

function Join-SourcePath {
  param([Parameter(Mandatory = $true)][string]$RelativePath)
  return Join-Path $root $RelativePath
}

function Read-SourceText {
  param([Parameter(Mandatory = $true)][string]$RelativePath)

  $path = Join-SourcePath $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Required readiness input not found: $RelativePath"
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

function Get-Metric {
  param(
    [Parameter(Mandatory = $true)][string]$Text,
    [Parameter(Mandatory = $true)][string]$Label
  )

  $pattern = '(?m)^-\s+' + [regex]::Escape($Label) + ':\s+(?<Value>\d+)'
  $match = [regex]::Match($Text, $pattern)
  if ($match.Success) {
    return [int]$match.Groups['Value'].Value
  }
  return 0
}

function Count-SectionBullets {
  param(
    [Parameter(Mandatory = $true)][string]$Text,
    [Parameter(Mandatory = $true)][string]$Heading
  )

  $pattern = '(?ms)^##\s+' + [regex]::Escape($Heading) + '\s*(?<Body>.*?)(?=^##\s+|\z)'
  $match = [regex]::Match($Text, $pattern)
  if (-not $match.Success) {
    return 0
  }

  return ([regex]::Matches($match.Groups['Body'].Value, '(?m)^-\s+`')).Count
}

function Test-SourcePath {
  param([Parameter(Mandatory = $true)][string]$RelativePath)
  return (Test-Path -LiteralPath (Join-SourcePath $RelativePath))
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
    [Parameter(Mandatory = $true)][string]$Gate,
    [Parameter(Mandatory = $true)][string]$Status,
    [Parameter(Mandatory = $true)][string]$Evidence
  )

  $script:gates.Add([pscustomobject]@{
    Gate = $Gate
    Status = $Status
    Evidence = $Evidence
  }) | Out-Null
}

$publicApiAudit = Read-SourceText 'docs/quality/PUBLIC_API_AUDIT_2_0.md'
$propertyMatrix = Read-SourceText 'docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md'
$surfaceSnapshot = Read-SourceText 'docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md'
$redundancyAudit = Read-SourceText 'docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md'
$designSkipAudit = Read-SourceText 'docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md'
$demoMatrix = Read-SourceText 'docs/release/DEMO_VALIDATION_MATRIX.md'
$roadmap = Read-SourceText 'docs/release/ROADMAP_2_0.md'

$runtimeVersion = Get-PackageVersion 'packages/LazRibbonRuntime.lpk'
$designVersion = Get-PackageVersion 'packages/LazRibbonDesign.lpk'
$stableCandidateCount = Count-SectionBullets -Text $publicApiAudit -Heading 'Stable API Candidates'
$snapshotPropertyCount = ([regex]::Matches($surfaceSnapshot, '(?m)^-\s+`[^`]+`:\s+`property')).Count
$publishedScanned = Get-Metric -Text $redundancyAudit -Label 'Published properties scanned'
$repeatedNames = Get-Metric -Text $redundancyAudit -Label 'Repeated published property names reviewed'
$unclassifiedNames = Get-Metric -Text $redundancyAudit -Label 'Unclassified repeated property names'
$skipRules = Get-Metric -Text $designSkipAudit -Label 'RegisterPropertyToSkip rules'
$nilHideRules = Get-Metric -Text $designSkipAudit -Label 'Nil property-editor hide rules'
$skipComponents = Get-Metric -Text $designSkipAudit -Label 'Components with hidden design-time properties'
$buildTargetPattern = [regex]::Escape($tick) + '(packages|tools|demos)/[^' + [regex]::Escape($tick) + ']+\.lp[ki]' + [regex]::Escape($tick)
$buildTargetCount = ([regex]::Matches($demoMatrix, $buildTargetPattern)).Count
$screenshotPaths = @(
  'docs/assets/screenshots/showcase-main.png',
  'docs/assets/screenshots/showcase-backstage.png',
  'docs/assets/screenshots/showcase-skins.png',
  'docs/assets/screenshots/skin-editor.png'
)
$screenshotFilesReady = $true
foreach ($screenshotPath in $screenshotPaths) {
  $fullScreenshotPath = Join-SourcePath $screenshotPath
  if (-not (Test-Path -LiteralPath $fullScreenshotPath)) {
    $screenshotFilesReady = $false
  }
  elseif ((Get-Item -LiteralPath $fullScreenshotPath).Length -lt 5000) {
    $screenshotFilesReady = $false
  }
}
$screenshotCaptureScriptReady = Test-SourcePath 'tools/capture_release_screenshots.ps1'
$screenshotEvidence = if ($screenshotFilesReady -and $screenshotCaptureScriptReady) {
  '4 public screenshot PNG assets and the capture script are present.'
}
else {
  'One or more public screenshot assets or the capture script is missing.'
}

$script:gates = New-Object System.Collections.Generic.List[object]
Add-Gate 'Package metadata aligned' ($(if ($runtimeVersion -eq $designVersion -and $runtimeVersion -notmatch '<missing>') { 'Ready' } else { 'Review' })) "Runtime $runtimeVersion; design $designVersion."
Add-Gate 'Public API audit exists' ($(if ($stableCandidateCount -gt 0) { 'Ready' } else { 'Review' })) "$stableCandidateCount stable API candidates listed."
Add-Gate 'Component property matrix exists' ($(if ($propertyMatrix -match 'Release Gate') { 'Ready' } else { 'Review' })) 'Release gate section is present.'
Add-Gate 'Object Inspector surface snapshot exists' ($(if ($snapshotPropertyCount -gt 0) { 'Ready' } else { 'Review' })) "$snapshotPropertyCount direct published property declarations listed."
Add-Gate 'Repeated property names classified' ($(if ($unclassifiedNames -eq 0 -and $repeatedNames -gt 0) { 'Ready' } else { 'Review' })) "$repeatedNames repeated names; $unclassifiedNames unclassified."
Add-Gate 'Design-time hidden properties documented' ($(if ($skipRules -gt 0 -and $nilHideRules -gt 0 -and $skipComponents -gt 0) { 'Ready' } else { 'Review' })) "$skipRules skip rules; $nilHideRules nil property-editor hide rules; $skipComponents component classes."
Add-Gate 'Build matrix documented' ($(if ($buildTargetCount -ge 18) { 'Ready' } else { 'Review' })) "$buildTargetCount package/tool/demo targets listed."
Add-Gate 'Release preflight script exists' ($(if (Test-SourcePath 'tools/verify_release_candidate.ps1') { 'Ready' } else { 'Review' })) 'One-command preflight script is present.'
Add-Gate 'Release ZIP hygiene script exists' ($(if (Test-SourcePath 'tools/check_release_zip.ps1') { 'Ready' } else { 'Review' })) 'ZIP audit script is present.'
Add-Gate 'GitHub publishing guide exists' ($(if (Test-SourcePath 'docs/release/GITHUB_PUBLISHING.md') { 'Ready' } else { 'Review' })) 'Public repository/release guidance is present.'
Add-Gate 'Clean checkout install validation' ($(if ((Test-SourcePath 'tools/verify_clean_checkout.ps1') -and (Test-SourcePath 'docs/release/CLEAN_CHECKOUT_VALIDATION.md')) { 'Ready' } else { 'Manual' })) 'Clean checkout validation script and guide are present.'
Add-Gate 'Screenshot assets for public release' ($(if ($screenshotFilesReady -and $screenshotCaptureScriptReady) { 'Ready' } else { 'Review' })) $screenshotEvidence
Add-Gate '2.0 final release notes exist' ($(if (Test-SourcePath 'docs/release/RELEASE_2_0_0.md') { 'Ready' } else { 'Review' })) 'Final 2.0 release notes are staged.'

$readyCount = @($gates | Where-Object { $_.Status -eq 'Ready' }).Count
$manualCount = @($gates | Where-Object { $_.Status -eq 'Manual' }).Count
$reviewCount = @($gates | Where-Object { $_.Status -eq 'Review' }).Count

$out = New-Object System.Collections.Generic.List[string]
$out.Add('# LazRibbon 2.0 API Freeze Readiness')
$out.Add('')
$out.Add('Generated by ' + (ConvertTo-InlineCode 'tools/export_2_0_api_freeze_readiness.ps1') + ' from the current release, quality and validation documents.')
$out.Add('This is a compact release-facing view of the API freeze path; the lower-level source of truth remains the individual audits and the release preflight.')
$out.Add('')
$out.Add('Regenerate after changing package metadata, API audits, Object Inspector reports or release gates:')
$out.Add('')
$out.Add((ConvertTo-InlineCode 'powershell -ExecutionPolicy Bypass -File tools/export_2_0_api_freeze_readiness.ps1 -OutputPath docs/release/API_FREEZE_READINESS_2_0.md'))
$out.Add('')
$out.Add('## Summary')
$out.Add('')
$out.Add(('- Package version: {0}' -f $runtimeVersion))
$out.Add(('- Stable API candidates listed: {0}' -f $stableCandidateCount))
$out.Add(('- Direct published property declarations listed: {0}' -f $snapshotPropertyCount))
$out.Add(('- Repeated published property names reviewed: {0}' -f $repeatedNames))
$out.Add(('- Unclassified repeated property names: {0}' -f $unclassifiedNames))
$out.Add(('- Design-time property skip rules: {0}' -f $skipRules))
$out.Add(('- Nil property-editor hide rules: {0}' -f $nilHideRules))
$out.Add(('- Package/tool/demo build targets listed: {0}' -f $buildTargetCount))
$out.Add(('- Gates ready: {0}' -f $readyCount))
$out.Add(('- Gates requiring manual RC validation: {0}' -f $manualCount))
$out.Add(('- Gates needing review: {0}' -f $reviewCount))
$out.Add('')
$out.Add('## Gate Status')
$out.Add('')
$out.Add('| Gate | Status | Evidence |')
$out.Add('| --- | --- | --- |')
foreach ($gate in $gates) {
  $out.Add('| ' + (ConvertTo-MarkdownTableText $gate.Gate) + ' | ' + (ConvertTo-MarkdownTableText $gate.Status) + ' | ' + (ConvertTo-MarkdownTableText $gate.Evidence) + ' |')
}
$out.Add('')
$out.Add('## Current Conclusion')
$out.Add('')
if ($reviewCount -eq 0) {
  $manualGateNames = @($gates | Where-Object { $_.Status -eq 'Manual' } | ForEach-Object { $_.Gate })
  if ($manualGateNames.Count -eq 0) {
    if ($runtimeVersion -eq '2.0.0') {
      $out.Add('The API freeze artifacts are ready for the stable 2.0 release, and no tracked gate currently needs review or manual validation.')
    }
    else {
      $out.Add('The 2.0 API freeze artifacts remain ready and are being used as the baseline for the current 2.x release work. No tracked gate currently needs review or manual validation.')
    }
  }
  else {
    $out.Add('The API freeze artifacts are ready for continued release work. Remaining manual release gates: ' + ($manualGateNames -join '; ') + '.')
  }
}
else {
  $out.Add('Some generated or documented API freeze gates still need review before stable release work continues.')
}
$out.Add('')
$out.Add('## Source Documents')
$out.Add('')
foreach ($path in @(
  'docs/quality/PUBLIC_API_AUDIT_2_0.md',
  'docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md',
  'docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md',
  'docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md',
  'docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md',
  'docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md',
  'docs/release/DEMO_VALIDATION_MATRIX.md',
  'docs/release/CLEAN_CHECKOUT_VALIDATION.md',
  'docs/release/ROADMAP_2_0.md',
  'docs/release/RELEASE_2_0_0.md',
  'docs/assets/screenshots/README.md'
)) {
  $out.Add('- ' + (ConvertTo-InlineCode $path))
}

$text = $out -join "`n"

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
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($resolvedOutput, $text + "`n", $utf8NoBom)
  Write-Host "2.0 API freeze readiness report written to $resolvedOutput"
}
