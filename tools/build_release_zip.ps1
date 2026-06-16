[CmdletBinding()]
param(
  [string]$Version = '1.2.19',
  [string]$SourceRoot,
  [string]$OutputDirectory,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $SourceRoot) {
  $SourceRoot = Split-Path -Parent $scriptRoot
}

$sourceItem = Get-Item -LiteralPath $SourceRoot
if (-not $sourceItem.PSIsContainer) {
  Write-Error "SourceRoot must be a directory: $SourceRoot"
  exit 2
}

if (-not $OutputDirectory) {
  $OutputDirectory = 'D:\Ribbon4Lazarus'
}

if (-not (Test-Path -LiteralPath $OutputDirectory)) {
  New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
}

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$zipPath = Join-Path $OutputDirectory ("LazRibbon_{0}_source_{1}.zip" -f $Version, $stamp)

if ((Test-Path -LiteralPath $zipPath) -and (-not $Force)) {
  Write-Error "Output already exists: $zipPath. Use -Force to replace it."
  exit 2
}

if (Test-Path -LiteralPath $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}

$excludedDirectories = @(
  '.git',
  '.lazarus-pcp',
  'lib',
  'bin',
  'obj',
  'backup'
)

$excludedFileNames = @(
  'packagefiles.xml'
)

$excludedExtensions = @(
  '.exe',
  '.dll',
  '.ppu',
  '.o',
  '.obj',
  '.a',
  '.or',
  '.res',
  '.rsj',
  '.compiled',
  '.dbg',
  '.lps',
  '.bak',
  '.tmp',
  '.log',
  '.zip'
)

function Test-ReleaseEntry {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RelativePath
  )

  $parts = $RelativePath -replace '\\', '/' -split '/' | Where-Object { $_ -ne '' }
  foreach ($part in $parts) {
    if ($excludedDirectories -contains $part) {
      return $false
    }
  }

  $leaf = [System.IO.Path]::GetFileName($RelativePath).ToLowerInvariant()
  if ($excludedFileNames -contains $leaf) {
    return $false
  }

  $extension = [System.IO.Path]::GetExtension($RelativePath).ToLowerInvariant()
  return -not ($excludedExtensions -contains $extension)
}


$consistencyScript = Join-Path $scriptRoot 'check_project_consistency.ps1'
if (Test-Path -LiteralPath $consistencyScript) {
  & powershell -ExecutionPolicy Bypass -File $consistencyScript -SourceRoot $sourceItem.FullName -ExpectedVersion $Version
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$rootFullName = $sourceItem.FullName.TrimEnd('\', '/')
$rootFolderName = Split-Path -Leaf $rootFullName

$zip = [System.IO.Compression.ZipFile]::Open($zipPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  Get-ChildItem -LiteralPath $rootFullName -Recurse -Force -File | ForEach-Object {
    $relativePath = $_.FullName.Substring($rootFullName.Length).TrimStart('\', '/')
    if (Test-ReleaseEntry -RelativePath $relativePath) {
      $entryName = $rootFolderName + '/' + ($relativePath -replace '\\', '/')
      [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $entryName, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
  }
}
finally {
  $zip.Dispose()
}

$checkScript = Join-Path $scriptRoot 'check_release_zip.ps1'
& powershell -ExecutionPolicy Bypass -File $checkScript $zipPath
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $zipPath).Hash
Write-Host "Release ZIP created:"
Write-Host "  $zipPath"
Write-Host "SHA256:"
Write-Host "  $hash"
