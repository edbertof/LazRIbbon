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

$targets = @(
  [pscustomobject]@{ Group = 'Top-Level Shell'; ClassName = 'TLazRibbonForm'; UnitPath = 'source/runtime/LazRibbon_Form.pas' },
  [pscustomobject]@{ Group = 'Top-Level Shell'; ClassName = 'TLazRibbon'; UnitPath = 'source/runtime/LazRibbon_Core.pas' },
  [pscustomobject]@{ Group = 'Top-Level Shell'; ClassName = 'TLazRibbonApplicationButton'; UnitPath = 'source/runtime/LazRibbon_Core.pas' },
  [pscustomobject]@{ Group = 'Top-Level Shell'; ClassName = 'TLazRibbonQuickAccessToolBar'; UnitPath = 'source/runtime/LazRibbon_Core.pas' },
  [pscustomobject]@{ Group = 'Top-Level Shell'; ClassName = 'TLazRibbonQuickAccessItem'; UnitPath = 'source/runtime/LazRibbon_Core.pas' },

  [pscustomobject]@{ Group = 'Command Surfaces'; ClassName = 'TLazRibbonPopupMenu'; UnitPath = 'source/runtime/LazRibbon_Popup.pas' },

  [pscustomobject]@{ Group = 'Ribbon Structure'; ClassName = 'TLazRibbonTab'; UnitPath = 'source/runtime/LazRibbon_Tabs.pas' },
  [pscustomobject]@{ Group = 'Ribbon Structure'; ClassName = 'TLazRibbonPane'; UnitPath = 'source/runtime/LazRibbon_Groups.pas' },
  [pscustomobject]@{ Group = 'Ribbon Structure'; ClassName = 'TLazRibbonCustomRibbonExtItem'; UnitPath = 'source/runtime/LazRibbon_RibbonExtItems.pas' },
  [pscustomobject]@{ Group = 'Ribbon Structure'; ClassName = 'TLazRibbonControlHostItem'; UnitPath = 'source/runtime/LazRibbon_RibbonExtItems.pas' },
  [pscustomobject]@{ Group = 'Ribbon Structure'; ClassName = 'TLazRibbonGalleryItem'; UnitPath = 'source/runtime/LazRibbon_RibbonExtItems.pas' },
  [pscustomobject]@{ Group = 'Ribbon Structure'; ClassName = 'TLazRibbonSkinGalleryItem'; UnitPath = 'source/runtime/LazRibbon_RibbonExtItems.pas' },

  [pscustomobject]@{ Group = 'BackStage'; ClassName = 'TLazRibbonBackstageButton'; UnitPath = 'source/runtime/LazRibbon_Backstage.pas' },
  [pscustomobject]@{ Group = 'BackStage'; ClassName = 'TLazRibbonBackstagePage'; UnitPath = 'source/runtime/LazRibbon_Backstage.pas' },
  [pscustomobject]@{ Group = 'BackStage'; ClassName = 'TLazRibbonBackstageRecentList'; UnitPath = 'source/runtime/LazRibbon_Backstage.pas' },
  [pscustomobject]@{ Group = 'BackStage'; ClassName = 'TLazRibbonBackstageView'; UnitPath = 'source/runtime/LazRibbon_Backstage.pas' },

  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinManager'; UnitPath = 'source/runtime/LazRibbon_SkinManager.pas' },
  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinGeneralColors'; UnitPath = 'source/runtime/LazRibbon_SkinManager.pas' },
  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinAccentColors'; UnitPath = 'source/runtime/LazRibbon_SkinManager.pas' },
  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinBackstageColors'; UnitPath = 'source/runtime/LazRibbon_SkinManager.pas' },
  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinRecentListColors'; UnitPath = 'source/runtime/LazRibbon_SkinManager.pas' },
  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinRibbonColors'; UnitPath = 'source/runtime/LazRibbon_SkinManager.pas' },
  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinDefinition'; UnitPath = 'source/runtime/LazRibbon_SkinDefinition.pas' },
  [pscustomobject]@{ Group = 'Skin Components'; ClassName = 'TLazRibbonSkinSelector'; UnitPath = 'source/runtime/LazRibbon_SkinSelector.pas' }
)

function Get-ClassDeclarationBlock {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Content,
    [Parameter(Mandatory = $true)]
    [string]$ClassName,
    [Parameter(Mandatory = $true)]
    [string]$RelativePath
  )

  $pattern = '(?ms)^\s*' + [regex]::Escape($ClassName) + '\s*=\s*class(?!\s*;)[^\r\n]*(?<Body>.*?^\s*end;)'
  $match = [regex]::Match($Content, $pattern)
  if (-not $match.Success) {
    throw "Could not find class declaration for $ClassName in $RelativePath."
  }
  return $match.Value
}

function Get-PublishedPropertyDeclarations {
  param(
    [Parameter(Mandatory = $true)]
    [string]$ClassBlock
  )

  $publishedMatch = [regex]::Match(
    $ClassBlock,
    '(?ms)^\s*published\s*(?<Published>.*?)(?=^\s*(private|protected|public|published)\b|^\s*end;)'
  )

  if (-not $publishedMatch.Success) {
    return @()
  }

  $properties = @()
  $current = ''

  foreach ($line in ($publishedMatch.Groups['Published'].Value -split "`r?`n")) {
    $trimmed = $line.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
      continue
    }
    if ($trimmed.StartsWith('{') -or $trimmed.StartsWith('//')) {
      continue
    }

    if ($trimmed -match '^property\s+') {
      $current = $trimmed
    }
    elseif (-not [string]::IsNullOrWhiteSpace($current)) {
      $current = "$current $trimmed"
    }
    else {
      continue
    }

    if ($trimmed.Contains(';')) {
      $declaration = (($current -replace '\s+', ' ').Trim())
      if ($declaration -match '^property\s+([A-Za-z_][A-Za-z0-9_]*)') {
        $properties += [pscustomobject]@{
          Name = $matches[1]
          Declaration = $declaration
        }
      }
      $current = ''
    }
  }

  return $properties
}

function Get-DesignTimeHiddenProperties {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Root
  )

  $hidden = @{}
  $registerPath = Join-Path $Root 'source/design/LazRibbon_Register.pas'
  if (-not (Test-Path -LiteralPath $registerPath)) {
    return $hidden
  }

  $content = Get-Content -LiteralPath $registerPath -Raw
  $patterns = @(
    "(?ms)RegisterPropertyToSkip\s*\(\s*(?<Component>[A-Za-z_][A-Za-z0-9_]*)\s*,\s*'(?<Property>[^']+)'",
    "(?ms)RegisterPropertyEditor\s*\(\s*TypeInfo\([^)]+\)\s*,\s*(?<Component>[A-Za-z_][A-Za-z0-9_]*)\s*,\s*'(?<Property>[^']*)'\s*,\s*nil\s*\)"
  )

  foreach ($pattern in $patterns) {
    [regex]::Matches($content, $pattern) | ForEach-Object {
      $component = $_.Groups['Component'].Value
      $property = $_.Groups['Property'].Value
      if (-not ([string]::IsNullOrWhiteSpace($component) -or [string]::IsNullOrWhiteSpace($property))) {
        if (-not $hidden.ContainsKey($component)) {
          $hidden[$component] = New-Object 'System.Collections.Generic.HashSet[string]'
        }
        [void]$hidden[$component].Add($property)
      }
    }
  }

  return $hidden
}

function Test-DesignTimePropertyHidden {
  param(
    [hashtable]$HiddenProperties,
    [string]$ClassName,
    [string]$PropertyName
  )

  return $HiddenProperties.ContainsKey($ClassName) -and
    $HiddenProperties[$ClassName].Contains($PropertyName)
}

$markdownCodeDelimiter = [char]96
$markdownFence = $markdownCodeDelimiter.ToString() * 3
$hiddenProperties = Get-DesignTimeHiddenProperties -Root $root

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('# LazRibbon Object Inspector Surface Snapshot for 2.0')
$lines.Add('')
$lines.Add('Generated from runtime source by ' + $markdownCodeDelimiter + 'tools/export_object_inspector_snapshot.ps1' + $markdownCodeDelimiter + '.')
$lines.Add('It lists direct ' + $markdownCodeDelimiter + 'published' + $markdownCodeDelimiter + ' property declarations that remain visible in the effective package-facing Object Inspector surface.')
$lines.Add('Compatibility-only, structural and obsolete properties hidden through design-time rules are excluded here and documented in ' + $markdownCodeDelimiter + 'DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md' + $markdownCodeDelimiter + '.')
$lines.Add('')
$lines.Add('Regenerate after changing published properties or design-time hiding rules:')
$lines.Add('')
$lines.Add($markdownFence + 'powershell')
$lines.Add('powershell -ExecutionPolicy Bypass -File tools/export_object_inspector_snapshot.ps1 -OutputPath docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md')
$lines.Add($markdownFence)
$lines.Add('')

$currentGroup = ''
foreach ($target in $targets) {
  if ($target.Group -ne $currentGroup) {
    $currentGroup = $target.Group
    $lines.Add("## $currentGroup")
    $lines.Add('')
  }

  $fullPath = Join-Path $root $target.UnitPath
  if (-not (Test-Path -LiteralPath $fullPath)) {
    throw "Snapshot source file not found: $($target.UnitPath)"
  }

  $content = Get-Content -LiteralPath $fullPath -Raw
  $block = Get-ClassDeclarationBlock -Content $content -ClassName $target.ClassName -RelativePath $target.UnitPath
  $properties = @(Get-PublishedPropertyDeclarations -ClassBlock $block |
    Where-Object { -not (Test-DesignTimePropertyHidden -HiddenProperties $hiddenProperties -ClassName $target.ClassName -PropertyName $_.Name) })

  $lines.Add("### $($target.ClassName)")
  $lines.Add('')
  $lines.Add('Source: ' + $markdownCodeDelimiter + $target.UnitPath + $markdownCodeDelimiter)
  $lines.Add('')

  if ($properties.Count -eq 0) {
    $lines.Add('- No direct published properties.')
  }
  else {
    foreach ($property in $properties) {
      $lines.Add('- ' + $markdownCodeDelimiter + $property.Name + $markdownCodeDelimiter + ': ' + $markdownCodeDelimiter + $property.Declaration + $markdownCodeDelimiter)
    }
  }
  $lines.Add('')
}

$text = $lines -join [Environment]::NewLine

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
  Set-Content -LiteralPath $resolvedOutput -Value $text -Encoding UTF8
  Write-Host "Object Inspector snapshot written to $resolvedOutput"
}
