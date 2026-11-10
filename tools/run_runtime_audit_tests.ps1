[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$LazarusDir = 'C:\lazarus',
  [string]$OutputDirectory = ''
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
  $SourceRoot = Split-Path -Parent $PSScriptRoot
}
$SourceRoot = (Get-Item -LiteralPath $SourceRoot).FullName
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
  $OutputDirectory = Join-Path $SourceRoot '.tools\runtime-audit-tests'
}
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$OutputDirectory = (Get-Item -LiteralPath $OutputDirectory).FullName
$compiler = Get-ChildItem -LiteralPath (Join-Path $LazarusDir 'fpc') -Filter fpc.exe -Recurse -File |
  Where-Object { $_.Directory.Name -eq 'x86_64-win64' } |
  Sort-Object FullName -Descending | Select-Object -First 1
if ($null -eq $compiler) {
  throw 'Bundled Windows x64 Free Pascal compiler not found.'
}
$units = Join-Path $OutputDirectory 'units'
New-Item -ItemType Directory -Path $units -Force | Out-Null
$arguments = @('-B', '-MObjFPC', '-Sh', '-O1', '-Cr', '-Co', '-gl', "-FU$units", "-FE$OutputDirectory")
foreach ($relativePath in @('lcl\units\x86_64-win64\win32', 'lcl\units\x86_64-win64', 'components\lazutils\lib\x86_64-win64', 'packager\units\x86_64-win64')) {
  $arguments += '-Fu' + (Join-Path $LazarusDir $relativePath)
}
$arguments += '-Fu' + (Join-Path $SourceRoot 'source\runtime')
$arguments += Join-Path $SourceRoot 'tests\runtime_audit.lpr'
$buildLog = Join-Path $OutputDirectory 'build.log'
& $compiler.FullName @arguments *> $buildLog
if ($LASTEXITCODE -ne 0) {
  Get-Content -LiteralPath $buildLog -Tail 40
  exit $LASTEXITCODE
}
$failedGroups = 0
foreach ($group in @('geometry', 'colors', 'collections', 'xml', 'skins', 'streaming', 'controls')) {
  $log = Join-Path $OutputDirectory ($group + '.log')
  & (Join-Path $OutputDirectory 'runtime_audit.exe') $group (Join-Path $OutputDirectory 'fixtures') *> $log
  if ($LASTEXITCODE -ne 0) { $failedGroups++ }
  Get-Content -LiteralPath $log
}
if ($failedGroups -ne 0) { exit 1 }
Write-Host 'All runtime audit regression groups passed.'
