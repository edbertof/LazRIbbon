[CmdletBinding()]
param(
  [string]$Version = '1.2.40',
  [string]$SourceRoot = '',
  [string]$OutputDirectory = '',
  [string]$LazarusDir = 'C:\lazarus',
  [string]$LazBuild = '',
  [switch]$SkipBuild,
  [switch]$SkipCleanCheckout,
  [switch]$SkipZip,
  [switch]$KeepPrimaryConfigPath
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
$consistencyScript = Join-Path $scriptRoot 'check_project_consistency.ps1'
$buildAllScript = Join-Path $scriptRoot 'build_all_projects.ps1'
$cleanCheckoutScript = Join-Path $scriptRoot 'verify_clean_checkout.ps1'
$zipScript = Join-Path $scriptRoot 'build_release_zip.ps1'
$safeVersion = $Version -replace '[^0-9A-Za-z_.-]', '_'
$primaryConfigPath = Join-Path ([System.IO.Path]::GetTempPath()) ("LazRibbon_preflight_pcp_{0}_{1}" -f $safeVersion, (Get-Date -Format 'yyyyMMdd_HHmmss'))

function Invoke-PreflightStep {
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

function Register-LocalPackageLinks {
  if ([string]::IsNullOrWhiteSpace($LazBuild)) {
    $LazBuild = Join-Path $LazarusDir 'lazbuild.exe'
  }
  if (-not (Test-Path -LiteralPath $LazBuild)) {
    Write-Error "lazbuild not found: $LazBuild"
    exit 2
  }

  New-Item -ItemType Directory -Path $primaryConfigPath -Force | Out-Null
  foreach ($relativePackage in @('packages\LazRibbonRuntime.lpk', 'packages\LazRibbonDesign.lpk')) {
    $packagePath = Join-Path $root $relativePackage
    & $LazBuild "--pcp=$primaryConfigPath" "--lazarusdir=$LazarusDir" '--add-package-link' $packagePath
    if ($LASTEXITCODE -ne 0) {
      exit $LASTEXITCODE
    }
  }
}

function Remove-PrimaryConfigPath {
  if ($KeepPrimaryConfigPath) {
    return
  }
  if (-not (Test-Path -LiteralPath $primaryConfigPath)) {
    return
  }

  $resolvedPath = (Resolve-Path -LiteralPath $primaryConfigPath).Path
  $tempRoot = [System.IO.Path]::GetTempPath()
  if (-not $resolvedPath.StartsWith($tempRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to remove primary config path outside temp: $resolvedPath"
  }
  Remove-Item -LiteralPath $resolvedPath -Recurse -Force
}

try {
  Invoke-PreflightStep -Name 'Consistency audit before build' -Action {
    Invoke-PowerShellScript -ScriptPath $consistencyScript -Arguments @(
      '-SourceRoot', $root,
      '-ExpectedVersion', $Version
    )
  }

  if (-not $SkipBuild) {
    Invoke-PreflightStep -Name 'Register local packages in temporary Lazarus profile' -Action {
      Register-LocalPackageLinks
    }

    Invoke-PreflightStep -Name 'Full package, tool and demo build matrix' -Action {
      $buildArgs = @(
        '-SourceRoot', $root,
        '-LazarusDir', $LazarusDir,
        '-PrimaryConfigPath', $primaryConfigPath,
        '-CleanArtifacts'
      )
      if (-not [string]::IsNullOrWhiteSpace($LazBuild)) {
        $buildArgs += @('-LazBuild', $LazBuild)
      }
      Invoke-PowerShellScript -ScriptPath $buildAllScript -Arguments $buildArgs
    }
  }
  else {
    Write-Host ''
    Write-Host '== Full package, tool and demo build matrix =='
    Write-Host 'Skipped by -SkipBuild.'
  }

  Invoke-PreflightStep -Name 'Consistency audit after build cleanup' -Action {
    Invoke-PowerShellScript -ScriptPath $consistencyScript -Arguments @(
      '-SourceRoot', $root,
      '-ExpectedVersion', $Version
    )
  }

  if (-not $SkipCleanCheckout) {
    Invoke-PreflightStep -Name 'Clean checkout installation validation' -Action {
      $cleanArgs = @(
        '-Version', $Version,
        '-SourceRoot', $root,
        '-LazarusDir', $LazarusDir
      )
      if (-not [string]::IsNullOrWhiteSpace($LazBuild)) {
        $cleanArgs += @('-LazBuild', $LazBuild)
      }
      if ($SkipBuild) {
        $cleanArgs += '-SkipBuild'
      }
      Invoke-PowerShellScript -ScriptPath $cleanCheckoutScript -Arguments $cleanArgs
    }
  }
  else {
    Write-Host ''
    Write-Host '== Clean checkout installation validation =='
    Write-Host 'Skipped by -SkipCleanCheckout.'
  }

  if (-not $SkipZip) {
    Invoke-PreflightStep -Name 'Release ZIP and ZIP audit' -Action {
      $zipArgs = @(
        '-Version', $Version,
        '-SourceRoot', $root
      )
      if (-not [string]::IsNullOrWhiteSpace($OutputDirectory)) {
        $zipArgs += @('-OutputDirectory', $OutputDirectory)
      }
      Invoke-PowerShellScript -ScriptPath $zipScript -Arguments $zipArgs
    }
  }
  else {
    Write-Host ''
    Write-Host '== Release ZIP and ZIP audit =='
    Write-Host 'Skipped by -SkipZip.'
  }

  Write-Host ''
  Write-Host "LazRibbon $Version release-candidate preflight passed."
}
finally {
  Remove-PrimaryConfigPath
}
