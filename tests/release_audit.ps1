[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$OutputDirectory = ''
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($SourceRoot)) { $SourceRoot = Split-Path -Parent $PSScriptRoot }
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) { $OutputDirectory = Join-Path $SourceRoot '.tools\release-audit-tests' }
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$cases = @(
  @{ Name = 'source'; Entry = 'LazRibbon/source/runtime/example.pas'; Expected = 0 },
  @{ Name = 'compiler-output'; Entry = 'LazRibbon/lib/example.ppu'; Expected = 1 },
  @{ Name = 'local-tools'; Entry = 'LazRibbon/.tools/private.txt'; Expected = 1 },
  @{ Name = 'git-metadata'; Entry = 'LazRibbon/.git/config'; Expected = 1 },
  @{ Name = 'ide-profile'; Entry = 'LazRibbon/.lazarus-pcp/environmentoptions.xml'; Expected = 1 },
  @{ Name = 'windows-path'; Entry = 'LazRibbon\.tools\private.txt'; Expected = 1 }
)
foreach ($case in $cases) {
  $zipPath = Join-Path $OutputDirectory ($case.Name + '.zip')
  $file = [System.IO.File]::Open($zipPath, [System.IO.FileMode]::Create)
  $archive = New-Object System.IO.Compression.ZipArchive($file, [System.IO.Compression.ZipArchiveMode]::Create)
  try {
    $entryStream = $archive.CreateEntry($case.Entry).Open()
    $entryStream.Dispose()
  }
  finally {
    $archive.Dispose()
    $file.Dispose()
  }
  $result = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $SourceRoot 'tools\check_release_zip.ps1') $zipPath 2>&1
  if ($LASTEXITCODE -ne $case.Expected) {
    $result | Write-Output
    throw "Unexpected ZIP audit result for $($case.Name): expected $($case.Expected), got $LASTEXITCODE."
  }
  Write-Host "PASS release archive: $($case.Name)"
}
Write-Host 'Release archive audit: 6 cases passed.'
