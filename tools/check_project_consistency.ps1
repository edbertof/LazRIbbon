[CmdletBinding()]
param(
  [string]$SourceRoot = (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)),
  [string]$ExpectedVersion = '1.2.4'
)

$ErrorActionPreference = 'Stop'
$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
  param([string]$Message)
  $failures.Add($Message) | Out-Null
}

function Get-XmlFile {
  param([Parameter(Mandatory = $true)][string]$Path)
  [xml](Get-Content -LiteralPath $Path -Raw)
}

function Get-RelativePath {
  param([Parameter(Mandatory = $true)][string]$Path)
  $root = (Get-Item -LiteralPath $SourceRoot).FullName
  return $Path.Substring($root.Length).TrimStart('\', '/')
}

function Test-PackageVersion {
  param(
    [Parameter(Mandatory = $true)][string]$RelativePath,
    [Parameter(Mandatory = $true)][string]$ExpectedVersion
  )

  $path = Join-Path $SourceRoot $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure "Missing package: $RelativePath"
    return
  }

  $xml = Get-XmlFile -Path $path
  $versionNode = $xml.SelectSingleNode('/CONFIG/Package/Version[@Major]')
  if ($null -eq $versionNode) {
    Add-Failure "Package has no version node: $RelativePath"
    return
  }

  $actual = ('{0}.{1}.{2}' -f $versionNode.Major, $versionNode.Minor, $versionNode.Release)
  if ($actual -ne $ExpectedVersion) {
    Add-Failure "Package version mismatch in ${RelativePath}: expected $ExpectedVersion, got $actual"
  }
}

function Test-DemoGraphicApplication {
  $demoRoot = Join-Path $SourceRoot 'demos'
  if (-not (Test-Path -LiteralPath $demoRoot)) {
    Add-Failure 'Missing demos directory.'
    return
  }

  Get-ChildItem -LiteralPath $demoRoot -Recurse -File -Filter '*.lpi' | Sort-Object FullName | ForEach-Object {
    $projectFile = $_
    $relative = Get-RelativePath -Path $projectFile.FullName
    try {
      $xml = Get-XmlFile -Path $projectFile.FullName
      $node = $xml.SelectSingleNode('//GraphicApplication')
      $value = if ($null -ne $node) { $node.GetAttribute('Value') } else { '' }
      if ($value -ne 'True') {
        Add-Failure "Demo project is not marked as a GUI application: $relative"
      }
    }
    catch {
      Add-Failure "Cannot parse demo project XML: $relative -- $($_.Exception.Message)"
    }
  }
}

function Test-LocalEnvironmentArtifacts {
  $localPathRegex = '([A-Za-z]:[\\/](Users|Documents and Settings)[\\/]|/home/[^\s/]+/|/Users/[^\s/]+/|[A-Za-z]:[\\/].*LazRibbon)'

  Get-ChildItem -LiteralPath $SourceRoot -Recurse -File | ForEach-Object {
    $relative = Get-RelativePath -Path $_.FullName
    $normalized = $relative -replace '\\','/'
    if ($normalized -match '(^|/)(\.git|lib|bin|obj|backup)(/|$)') {
      return
    }
    if ($normalized -match '^docs/archive/') {
      return
    }
    if ($normalized -eq 'tools/check_project_consistency.ps1') {
      return
    }

    $ext = $_.Extension.ToLowerInvariant()
    if (@('.png','.ico','.jpg','.jpeg','.gif','.bmp') -contains $ext) {
      return
    }

    $content = Get-Content -LiteralPath $_.FullName -Raw -ErrorAction SilentlyContinue
    if ($content -match $localPathRegex) {
      Add-Failure "Local environment path found in $relative"
    }
  }
}

function Test-ForbiddenFiles {
  $forbiddenNames = @('packagefiles.xml')
  $forbiddenExtensions = @('.exe','.dll','.ppu','.o','.obj','.a','.or','.res','.rsj','.compiled','.dbg','.lps','.bak','.tmp','.log','.zip')
  $forbiddenDirectories = @('lib','bin','obj','backup')

  Get-ChildItem -LiteralPath $SourceRoot -Recurse -Force | ForEach-Object {
    $relative = Get-RelativePath -Path $_.FullName
    $parts = $relative -replace '\\','/' -split '/' | Where-Object { $_ -ne '' }
    for ($index = 0; $index -lt $parts.Count; $index++) {
      $part = $parts[$index]
      if ($forbiddenDirectories -contains $part) {
        $generatedDir = ($parts[0..$index] -join '/')
        Add-Failure "Forbidden generated directory in source tree: $generatedDir"
        return
      }
    }

    if (-not $_.PSIsContainer) {
      $leaf = $_.Name.ToLowerInvariant()
      if ($forbiddenNames -contains $leaf) {
        Add-Failure "Forbidden local Lazarus file found: $relative"
      }
      if ($forbiddenExtensions -contains $_.Extension.ToLowerInvariant()) {
        Add-Failure "Forbidden generated file found: $relative"
      }
    }
  }
}

if (-not (Test-Path -LiteralPath $SourceRoot)) {
  Write-Error "SourceRoot not found: $SourceRoot"
  exit 2
}

$SourceRoot = (Get-Item -LiteralPath $SourceRoot).FullName

Test-PackageVersion -RelativePath 'packages/LazRibbonRuntime.lpk' -ExpectedVersion $ExpectedVersion
Test-PackageVersion -RelativePath 'packages/LazRibbonDesign.lpk' -ExpectedVersion $ExpectedVersion
Test-DemoGraphicApplication
Test-LocalEnvironmentArtifacts
Test-ForbiddenFiles

if ($failures.Count -eq 0) {
  Write-Host "Project consistency audit passed for LazRibbon $ExpectedVersion."
  exit 0
}

Write-Host "Project consistency audit failed:"
$failures | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
exit 1
