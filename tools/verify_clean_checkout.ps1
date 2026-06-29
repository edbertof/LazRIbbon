[CmdletBinding()]
param(
  [string]$Version = '2.1.0',
  [string]$ReleaseVersion = '',
  [string]$SourceRoot = '',
  [string]$WorkRoot = '',
  [string]$LazarusDir = 'C:\lazarus',
  [string]$LazBuild = '',
  [switch]$SkipBuild,
  [switch]$KeepWorkspace
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
if ([string]::IsNullOrWhiteSpace($WorkRoot)) {
  $WorkRoot = [System.IO.Path]::GetTempPath()
}
if ([string]::IsNullOrWhiteSpace($ReleaseVersion)) {
  $ReleaseVersion = $Version
}

$workBase = (Get-Item -LiteralPath $WorkRoot).FullName
$safeReleaseVersion = $ReleaseVersion -replace '[^0-9A-Za-z_.-]', '_'
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$sessionRoot = Join-Path $workBase ("LazRibbon_clean_checkout_{0}_{1}" -f $safeReleaseVersion, $stamp)
$zipDirectory = Join-Path $sessionRoot 'zip'
$extractRoot = Join-Path $sessionRoot 'extract'
$primaryConfigPath = Join-Path $sessionRoot 'lazarus-pcp'

$zipScript = Join-Path $root 'tools\build_release_zip.ps1'
$consistencyScript = Join-Path $root 'tools\check_project_consistency.ps1'

function Invoke-CleanCheckoutStep {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Action
  )

  Write-Host ''
  Write-Host "== $Name =="
  & $Action
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

function Invoke-PowerShellScript {
  param(
    [Parameter(Mandatory = $true)]
    [string]$ScriptPath,
    [string[]]$Arguments = @()
  )

  if (-not (Test-Path -LiteralPath $ScriptPath)) {
    Write-Error "Required script not found: $ScriptPath"
    exit 2
  }

  & powershell -ExecutionPolicy Bypass -File $ScriptPath @Arguments
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

function Remove-SessionRoot {
  if ($KeepWorkspace) {
    return
  }
  if (-not (Test-Path -LiteralPath $sessionRoot)) {
    return
  }

  $resolvedSession = (Resolve-Path -LiteralPath $sessionRoot).Path
  $resolvedBase = (Resolve-Path -LiteralPath $workBase).Path
  if (-not $resolvedSession.StartsWith($resolvedBase, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to remove outside WorkRoot: $resolvedSession"
  }
  Remove-Item -LiteralPath $resolvedSession -Recurse -Force
}

try {
  New-Item -ItemType Directory -Path $zipDirectory -Force | Out-Null
  New-Item -ItemType Directory -Path $extractRoot -Force | Out-Null
  New-Item -ItemType Directory -Path $primaryConfigPath -Force | Out-Null

  Invoke-CleanCheckoutStep -Name 'Release-style source ZIP from current tree' -Action {
    Invoke-PowerShellScript -ScriptPath $zipScript -Arguments @(
      '-Version', $Version,
      '-ReleaseVersion', $ReleaseVersion,
      '-SourceRoot', $root,
      '-OutputDirectory', $zipDirectory
    )
  }

  $zipPath = Get-ChildItem -LiteralPath $zipDirectory -Filter ("LazRibbon_{0}_source_*.zip" -f $ReleaseVersion) |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
  if ($null -eq $zipPath) {
    Write-Error "Clean checkout source ZIP was not created for LazRibbon $ReleaseVersion."
    exit 2
  }

  Invoke-CleanCheckoutStep -Name 'Extract clean source tree' -Action {
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath.FullName, $extractRoot)
  }

  $checkoutRoots = @(Get-ChildItem -LiteralPath $extractRoot -Directory)
  if ($checkoutRoots.Count -ne 1) {
    Write-Error "Expected one extracted source root, found $($checkoutRoots.Count)."
    exit 2
  }
  $cleanRoot = $checkoutRoots[0].FullName
  $cleanTools = Join-Path $cleanRoot 'tools'
  $cleanConsistencyScript = Join-Path $cleanTools 'check_project_consistency.ps1'
  $cleanBuildAllScript = Join-Path $cleanTools 'build_all_projects.ps1'
  $cleanRuntimePackage = Join-Path $cleanRoot 'packages\LazRibbonRuntime.lpk'
  $cleanDesignPackage = Join-Path $cleanRoot 'packages\LazRibbonDesign.lpk'

  Invoke-CleanCheckoutStep -Name 'Consistency audit in clean checkout' -Action {
    Invoke-PowerShellScript -ScriptPath $cleanConsistencyScript -Arguments @(
      '-SourceRoot', $cleanRoot,
      '-ExpectedVersion', $Version
    )
  }

  if (-not $SkipBuild) {
    Invoke-CleanCheckoutStep -Name 'Register local packages in temporary Lazarus profile' -Action {
      if ([string]::IsNullOrWhiteSpace($LazBuild)) {
        $LazBuild = Join-Path $LazarusDir 'lazbuild.exe'
      }
      & $LazBuild "--pcp=$primaryConfigPath" "--lazarusdir=$LazarusDir" '--add-package-link' $cleanRuntimePackage
      if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
      }
      & $LazBuild "--pcp=$primaryConfigPath" "--lazarusdir=$LazarusDir" '--add-package-link' $cleanDesignPackage
      if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
      }
    }

    Invoke-CleanCheckoutStep -Name 'Full build in clean checkout' -Action {
      $buildArgs = @(
        '-SourceRoot', $cleanRoot,
        '-LazarusDir', $LazarusDir,
        '-PrimaryConfigPath', $primaryConfigPath,
        '-CleanArtifacts'
      )
      if (-not [string]::IsNullOrWhiteSpace($LazBuild)) {
        $buildArgs += @('-LazBuild', $LazBuild)
      }
      Invoke-PowerShellScript -ScriptPath $cleanBuildAllScript -Arguments $buildArgs
    }
  }
  else {
    Write-Host ''
    Write-Host '== Full build in clean checkout =='
    Write-Host 'Skipped by -SkipBuild.'
  }

  Invoke-CleanCheckoutStep -Name 'Post-build cleanup audit in clean checkout' -Action {
    Invoke-PowerShellScript -ScriptPath $cleanConsistencyScript -Arguments @(
      '-SourceRoot', $cleanRoot,
      '-ExpectedVersion', $Version
    )
  }

  Write-Host ''
  Write-Host "Clean checkout validation passed for LazRibbon $ReleaseVersion."
  Write-Host "Validated source ZIP:"
  Write-Host "  $($zipPath.FullName)"
  if ($KeepWorkspace) {
    Write-Host "Clean checkout workspace kept at:"
    Write-Host "  $sessionRoot"
  }
}
finally {
  Remove-SessionRoot
}
