[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [string]$Path = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

$artifactFileNames = @(
  'packagefiles.xml'
)

$artifactExtensions = @(
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
  '.zip',
  '.lps',
  '.bak'
)

$artifactDirectories = @(
  'lib',
  'bin',
  'obj',
  'backup'
)

$ignoredDirectories = @(
  '.git',
  '.lazarus-pcp'
)

function Test-ArtifactPath {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RelativePath
  )

  $parts = $RelativePath -replace '\\', '/' -split '/' | Where-Object { $_ -ne '' }

  foreach ($part in $parts) {
    if ($ignoredDirectories -contains $part) {
      return $false
    }
  }

  foreach ($part in $parts) {
    if ($artifactDirectories -contains $part) {
      return $true
    }
  }

  $leaf = if ($parts.Count -gt 0) { $parts[$parts.Count - 1] } else { $RelativePath }
  $leafLower = $leaf.ToLowerInvariant()
  if ($artifactFileNames -contains $leafLower) {
    return $true
  }

  $extension = [System.IO.Path]::GetExtension($leaf).ToLowerInvariant()
  return $artifactExtensions -contains $extension
}

function Get-DirectoryViolations {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Root
  )

  $rootFullName = (Get-Item -LiteralPath $Root).FullName.TrimEnd('\', '/')
  $violations = New-Object System.Collections.Generic.List[string]

  Get-ChildItem -LiteralPath $rootFullName -Recurse -Force | ForEach-Object {
    $relativePath = $_.FullName.Substring($rootFullName.Length).TrimStart('\', '/')
    if (Test-ArtifactPath -RelativePath $relativePath) {
      $violations.Add($relativePath)
    }
  }

  return $violations
}

function Get-ZipViolations {
  param(
    [Parameter(Mandatory = $true)]
    [string]$ZipPath
  )

  Add-Type -AssemblyName System.IO.Compression.FileSystem

  $violations = New-Object System.Collections.Generic.List[string]
  $zip = [System.IO.Compression.ZipFile]::OpenRead((Get-Item -LiteralPath $ZipPath).FullName)
  try {
    foreach ($entry in $zip.Entries) {
      $name = $entry.FullName.TrimEnd('/')
      if ($name -and (Test-ArtifactPath -RelativePath $name)) {
        $violations.Add($entry.FullName)
      }
    }
  }
  finally {
    $zip.Dispose()
  }

  return $violations
}

if (-not (Test-Path -LiteralPath $Path)) {
  Write-Error "Path not found: $Path"
  exit 2
}

$item = Get-Item -LiteralPath $Path
if ($item.PSIsContainer) {
  $violations = Get-DirectoryViolations -Root $item.FullName
}
else {
  $violations = Get-ZipViolations -ZipPath $item.FullName
}

if ($violations.Count -eq 0) {
  Write-Host "Release ZIP audit passed: no generated build artifacts found."
  exit 0
}

Write-Host "Release ZIP audit failed: generated build artifacts were found."
$violations | Sort-Object | ForEach-Object { Write-Host "  $_" }
exit 1
