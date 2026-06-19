[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$LazarusDir = 'C:\lazarus',
  [string]$LazBuild = '',
  [switch]$CleanArtifacts
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
if ([string]::IsNullOrWhiteSpace($LazBuild)) {
  $LazBuild = Join-Path $LazarusDir 'lazbuild.exe'
}
if (-not (Test-Path -LiteralPath $LazBuild)) {
  Write-Error "lazbuild not found: $LazBuild"
  exit 2
}

$packages = @(
  'packages\LazRibbonRuntime.lpk',
  'packages\LazRibbonDesign.lpk'
)

$projects = @(
  'tools\LazRibbonSkinEditor\LazRibbonSkinEditor.lpi',
  'demos\showcase\project1.lpi',
  'demos\ribbon_form\project1.lpi',
  'demos\basic\Project1.lpi',
  'demos\runtime\project1.lpi',
  'demos\application_button\project1.lpi',
  'demos\quick_access_toolbar\project1.lpi',
  'demos\backstage\project1.lpi',
  'demos\backstage_recent_files\project1.lpi',
  'demos\skins_gallery\project1.lpi',
  'demos\skin_editor_sample\project1.lpi',
  'demos\actions\project1.lpi',
  'demos\actions_hidpi\project1.lpi',
  'demos\styles\project1.lpi',
  'demos\lclscaling\project1.lpi',
  'demos\popup_menu\project1.lpi'
)

function Invoke-LazBuild {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RelativePath
  )

  $fullPath = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $fullPath)) {
    Write-Error "Build target not found: $RelativePath"
    exit 2
  }

  Write-Host "BUILD $RelativePath"
  & $LazBuild --lazarusdir=$LazarusDir --build-all $fullPath
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

function Remove-GeneratedArtifacts {
  $relativeTargets = @(
    'packagefiles.xml',
    'lib',
    'tools\LazRibbonSkinEditor\bin',
    'tools\LazRibbonSkinEditor\obj',
    'tools\LazRibbonSkinEditor\LazRibbonSkinEditor.res',
    'demos\actions\bin',
    'demos\actions\lib',
    'demos\actions\project1.res',
    'demos\actions_hidpi\bin',
    'demos\actions_hidpi\lib',
    'demos\actions_hidpi\project1.res',
    'demos\application_button\bin',
    'demos\application_button\lib',
    'demos\application_button\project1.res',
    'demos\backstage\bin',
    'demos\backstage\lib',
    'demos\backstage\project1.res',
    'demos\backstage_recent_files\bin',
    'demos\backstage_recent_files\lib',
    'demos\backstage_recent_files\project1.res',
    'demos\basic\bin',
    'demos\basic\lib',
    'demos\basic\Project1.res',
    'demos\lclscaling\lib',
    'demos\lclscaling\project1.exe',
    'demos\lclscaling\project1.res',
    'demos\popup_menu\bin',
    'demos\popup_menu\lib',
    'demos\popup_menu\project1.res',
    'demos\quick_access_toolbar\bin',
    'demos\quick_access_toolbar\lib',
    'demos\quick_access_toolbar\project1.res',
    'demos\ribbon_form\bin',
    'demos\ribbon_form\lib',
    'demos\ribbon_form\project1.res',
    'demos\runtime\bin',
    'demos\runtime\lib',
    'demos\runtime\project1.res',
    'demos\showcase\bin',
    'demos\showcase\lib',
    'demos\showcase\project1.res',
    'demos\skin_editor_sample\bin',
    'demos\skin_editor_sample\lib',
    'demos\skin_editor_sample\project1.exe',
    'demos\skin_editor_sample\project1.res',
    'demos\skins_gallery\bin',
    'demos\skins_gallery\lib',
    'demos\skins_gallery\project1.res',
    'demos\styles\bin',
    'demos\styles\lib',
    'demos\styles\project1.exe',
    'demos\styles\project1.res'
  )

  foreach ($relative in $relativeTargets) {
    $path = Join-Path $root $relative
    if (Test-Path -LiteralPath $path) {
      $resolved = (Resolve-Path -LiteralPath $path).Path
      if (-not ($resolved.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase))) {
        throw "Refusing to remove outside SourceRoot: $resolved"
      }
      Remove-Item -LiteralPath $resolved -Recurse -Force
    }
  }
}

foreach ($package in $packages) {
  Invoke-LazBuild -RelativePath $package
}

foreach ($project in $projects) {
  Invoke-LazBuild -RelativePath $project
}

if ($CleanArtifacts) {
  Remove-GeneratedArtifacts
}

Write-Host 'All LazRibbon packages, tools and demos built successfully.'
