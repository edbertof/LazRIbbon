[CmdletBinding()]
param(
  [string]$Version = '1.2.39',
  [string]$SourceRoot = '',
  [string]$OutputDirectory = '',
  [string]$LazarusDir = 'C:\lazarus',
  [string]$LazBuild = '',
  [switch]$SkipBuild,
  [switch]$SkipZip
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
$zipScript = Join-Path $scriptRoot 'build_release_zip.ps1'

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

Invoke-PreflightStep -Name 'Consistency audit before build' -Action {
  Invoke-PowerShellScript -ScriptPath $consistencyScript -Arguments @(
    '-SourceRoot', $root,
    '-ExpectedVersion', $Version
  )
}

if (-not $SkipBuild) {
  Invoke-PreflightStep -Name 'Full package, tool and demo build matrix' -Action {
    $buildArgs = @(
      '-SourceRoot', $root,
      '-LazarusDir', $LazarusDir,
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
