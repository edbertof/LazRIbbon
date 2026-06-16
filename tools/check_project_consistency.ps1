[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$ExpectedVersion = '1.2.22'
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
    if ($normalized -match '(^|/)(\.git|\.tools|lib|bin|obj|backup)(/|$)') {
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
    if (($parts.Count -gt 0) -and ($parts[0] -eq '.tools')) {
      return
    }
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

function Test-RibbonAppearanceStreaming {
  Get-ChildItem -LiteralPath $SourceRoot -Recurse -File -Filter '*.lfm' | ForEach-Object {
    $relative = Get-RelativePath -Path $_.FullName
    $objectStack = New-Object System.Collections.Generic.List[object]
    $lineNumber = 0

    Get-Content -LiteralPath $_.FullName | ForEach-Object {
      $lineNumber++
      $line = $_

      if ($line -match '^(\s*)(object|inherited|inline)\s+([^:]+):\s*(\S+)') {
        $objectStack.Add([pscustomobject]@{
          Indent = $matches[1].Length
          Name = $matches[3].Trim()
          Type = $matches[4]
        }) | Out-Null
      }
      elseif ($line -match '^(\s*)end\s*$') {
        $indent = $matches[1].Length
        if (($objectStack.Count -gt 0) -and ($objectStack[$objectStack.Count - 1].Indent -eq $indent)) {
          $objectStack.RemoveAt($objectStack.Count - 1)
        }
      }

      $currentObject = if ($objectStack.Count -gt 0) { $objectStack[$objectStack.Count - 1] } else { $null }
      $currentType = if ($null -ne $currentObject) { $currentObject.Type } else { '<none>' }
      $currentName = if ($null -ne $currentObject) { $currentObject.Name } else { '<none>' }

      if (($line -match '^\s*Appearance\.') -and ($currentType -eq 'TLazRibbon')) {
        Add-Failure "Legacy TLazRibbon Appearance streaming found in ${relative}:${lineNumber}; use RibbonAppearance.*."
      }

      if (($line -match '^\s*(ApplicationButtonCaption|ApplicationButtonVisible|ApplicationButtonMode|ApplicationMenu|OnApplicationButtonClick|MenuButtonCaption|MenuButtonDropdownMenu|MenuButtonStyle|ShowMenuButton|OnMenuButtonClick)\s*=') -and ($currentType -eq 'TLazRibbon')) {
        Add-Failure "Legacy TLazRibbon Application/Menu Button streaming found in ${relative}:${lineNumber}; use ApplicationButton.*."
      }

      if (($line -match '^\s*(ShowCollapseButton|CollapseRibbonHint|ExpandRibbonHint)\s*=') -and ($currentType -eq 'TLazRibbon')) {
        Add-Failure "Legacy TLazRibbon minimize-button streaming found in ${relative}:${lineNumber}; use ShowMinimizeRibbonButton, MinimizeRibbonHint or RestoreRibbonHint."
      }

      if (($line -match '^\s*ShowCloseButton\s*=') -and ($currentType -eq 'TLazRibbonBackstageView')) {
        Add-Failure "Legacy TLazRibbonBackstageView back-button streaming found in ${relative}:${lineNumber}; use BackButtonVisible."
      }

      if (($line -match '^\s*(BackColor|NavigationColor|ActiveColor|HotColor|FrameColor|TextColor|MutedTextColor|RecentOddColor|RecentHoverColor|RecentSelectedColor|RecentSelectedFrameColor|RecentTitleColor)\s*=') -and ($currentType -eq 'TLazRibbonSkinManager')) {
        Add-Failure "Legacy TLazRibbonSkinManager flat palette streaming found in ${relative}:${lineNumber}; use General.*, Accent.* or RecentList.*."
      }

      if (($line -match '^\s*Backstage\.(ActiveColor|FrameColor)\s*=') -and ($currentType -eq 'TLazRibbonSkinManager')) {
        Add-Failure "Legacy TLazRibbonSkinManager Backstage color alias found in ${relative}:${lineNumber}; use Backstage.SelectedColor or Backstage.SelectedFrameColor."
      }

      if (($line -match '^\s*RibbonAppearance\.') -and ($currentType -ne 'TLazRibbon')) {
        Add-Failure "RibbonAppearance streaming found in ${relative}:${lineNumber} on ${currentType} ${currentName}; only TLazRibbon supports RibbonAppearance.*."
      }
    }
  }
}

function Test-BackstageOverlayDefault {
  $path = Join-Path $SourceRoot 'source/runtime/LazRibbon_Backstage.pas'
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure 'Missing BackStage runtime unit.'
    return
  }

  $content = Get-Content -LiteralPath $path -Raw
  if ($content -notmatch 'property\s+OverlayMode:\s+TLazRibbonBackstageOverlayMode\s+read\s+FOverlayMode\s+write\s+SetOverlayMode\s+default\s+bomCoverClientArea;') {
    Add-Failure 'TLazRibbonBackstageView.OverlayMode must default to bomCoverClientArea.'
  }
  if ($content -notmatch 'FOverlayMode\s*:=\s*bomCoverClientArea;') {
    Add-Failure 'TLazRibbonBackstageView constructor must initialize FOverlayMode to bomCoverClientArea.'
  }
}

function Test-BackstageBackButtonOfficeApi {
  $path = Join-Path $SourceRoot 'source/runtime/LazRibbon_Backstage.pas'
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure 'Missing BackStage runtime unit.'
    return
  }

  $content = Get-Content -LiteralPath $path -Raw
  foreach ($required in @(
    'property BackButtonVisible: Boolean read FBackButtonVisible write SetBackButtonVisible default True;',
    'procedure TLazRibbonBackstageView.SetBackButtonVisible'
  )) {
    if ($content -notmatch [regex]::Escape($required)) {
      Add-Failure "TLazRibbonBackstageView back-button API must include $required."
    }
  }

  $legacyPattern = '\b(ShowCloseButton|FShowCloseButton|SetShowCloseButton)\b'
  $scanRoots = @('source', 'tools', 'demos', 'packages') | ForEach-Object {
    Join-Path $SourceRoot $_
  }
  foreach ($root in $scanRoots) {
    if (-not (Test-Path -LiteralPath $root)) {
      continue
    }

    Get-ChildItem -LiteralPath $root -Recurse -File |
      Where-Object { $_.Extension -in @('.pas', '.lfm', '.lpk', '.lpr') } |
      ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw
        if ($content -match $legacyPattern) {
          $relative = Get-RelativePath -Path $_.FullName
          Add-Failure "Legacy TLazRibbonBackstageView back-button API name found in ${relative}; use BackButtonVisible."
        }
      }
  }
}

function Test-RibbonMinimizedHeightAdjustment {
  $path = Join-Path $SourceRoot 'source/runtime/LazRibbon_Core.pas'
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure 'Missing Ribbon runtime unit.'
    return
  }

  $content = Get-Content -LiteralPath $path -Raw
  if ($content -notmatch 'FExpandedRibbonHeight:\s+Integer;') {
    Add-Failure 'TLazRibbon must remember expanded height while minimized.'
  }
  if ($content -notmatch 'if\s+\(TargetHeight\s+>\s+0\)\s+and\s+\(Height\s+<>\s+TargetHeight\)\s+then\s+Height\s*:=\s*TargetHeight;') {
    Add-Failure 'TLazRibbon.SetRibbonMinimized must resize the control to the minimized/expanded height.'
  }
}

function Test-RibbonMinimizeOfficeApi {
  $corePath = Join-Path $SourceRoot 'source/runtime/LazRibbon_Core.pas'
  if (-not (Test-Path -LiteralPath $corePath)) {
    Add-Failure 'Missing Ribbon runtime unit.'
    return
  }

  $core = Get-Content -LiteralPath $corePath -Raw
  foreach ($required in @(
    'property ShowMinimizeRibbonButton',
    'property MinimizeRibbonHint',
    'property RestoreRibbonHint',
    'SetShowMinimizeRibbonButton',
    'SetMinimizeRibbonHint',
    'SetRestoreRibbonHint'
  )) {
    if ($core -notmatch [regex]::Escape($required)) {
      Add-Failure "TLazRibbon minimize API must include $required."
    }
  }

  $legacyPattern = '\b(ShowCollapseButton|CollapseRibbonHint|ExpandRibbonHint|FShowCollapseButton|FCollapseRibbonHint|FExpandRibbonHint|SetShowCollapseButton|SetCollapseRibbonHint|SetExpandRibbonHint)\b'
  $scanRoots = @('source', 'tools', 'demos', 'packages') | ForEach-Object {
    Join-Path $SourceRoot $_
  }
  foreach ($root in $scanRoots) {
    if (-not (Test-Path -LiteralPath $root)) {
      continue
    }

    Get-ChildItem -LiteralPath $root -Recurse -File |
      Where-Object { $_.Extension -in @('.pas', '.lfm', '.lpk', '.lpr') } |
      ForEach-Object {
      $content = Get-Content -LiteralPath $_.FullName -Raw
      if ($content -match $legacyPattern) {
        $relative = Get-RelativePath -Path $_.FullName
        Add-Failure "Legacy TLazRibbon minimize API name found in ${relative}; use Office-like minimize/restore names."
      }
    }
  }
}

function Test-SkinEditorPreviewMinimizeSync {
  $pasPath = Join-Path $SourceRoot 'tools/LazRibbonSkinEditor/uSkinEditorMain.pas'
  $lfmPath = Join-Path $SourceRoot 'tools/LazRibbonSkinEditor/uSkinEditorMain.lfm'
  if (-not (Test-Path -LiteralPath $pasPath)) {
    Add-Failure 'Missing Skin Editor main unit.'
    return
  }
  if (-not (Test-Path -LiteralPath $lfmPath)) {
    Add-Failure 'Missing Skin Editor form resource.'
    return
  }

  $pas = Get-Content -LiteralPath $pasPath -Raw
  $lfm = Get-Content -LiteralPath $lfmPath -Raw
  if ($pas -notmatch 'PreviewToolbar\.Align\s*:=\s*alTop;') {
    Add-Failure 'Skin Editor PreviewToolbar must use alTop so minimized height is not stretched by pnlLivePreview.'
  }
  if ($pas -notmatch 'PreviewToolbar\.OnRibbonMinimizedChanged\s*:=\s*@PreviewToolbarRibbonMinimizedChanged;') {
    Add-Failure 'Skin Editor must sync pnlLivePreview when PreviewToolbar is minimized/restored.'
  }
  if ($pas -notmatch 'not\s+PreviewToolbar\.RibbonMinimized') {
    Add-Failure 'Skin Editor live preview height sync must not enforce the expanded minimum while Ribbon is minimized.'
  }
  if ($lfm -notmatch 'object\s+PreviewToolbar:\s+TLazRibbon[\s\S]*?Align\s*=\s*alTop') {
    Add-Failure 'Skin Editor PreviewToolbar must stream Align = alTop.'
  }
}

function Test-SkinEditorAppearanceModeDetection {
  $pasPath = Join-Path $SourceRoot 'tools/LazRibbonSkinEditor/uSkinEditorMain.pas'
  if (-not (Test-Path -LiteralPath $pasPath)) {
    Add-Failure 'Missing Skin Editor main unit.'
    return
  }

  $pas = Get-Content -LiteralPath $pasPath -Raw
  if ($pas -notmatch 'function\s+TfrmLazRibbonSkinEditor\.SkinAppearanceMatchesPalette') {
    Add-Failure 'Skin Editor must detect whether a skin Appearance still matches the simple palette.'
  }
  if ($pas -notmatch 'procedure\s+TfrmLazRibbonSkinEditor\.RefreshFullAppearanceEditedFromCurrentSkin') {
    Add-Failure 'Skin Editor must centralize the full-Appearance edit state detection.'
  }
  if ($pas -match 'procedure\s+TfrmLazRibbonSkinEditor\.btnNewFromBaseClick[\s\S]*?FFullAppearanceEdited\s*:=\s*True;[\s\S]*?procedure\s+TfrmLazRibbonSkinEditor\.btnOpenClick') {
    Add-Failure 'New-from-base must not blindly mark Appearance as manually edited.'
  }
  if ($pas -match 'procedure\s+TfrmLazRibbonSkinEditor\.btnOpenClick[\s\S]*?FFullAppearanceEdited\s*:=\s*True;[\s\S]*?procedure\s+TfrmLazRibbonSkinEditor\.btnRefreshValidationClick') {
    Add-Failure 'Opening a skin must detect Appearance mode instead of blindly marking it manually edited.'
  }
  if ($pas -notmatch 'procedure\s+TfrmLazRibbonSkinEditor\.btnNewFromBaseClick[\s\S]*?RefreshFullAppearanceEditedFromCurrentSkin;') {
    Add-Failure 'New-from-base must refresh the Appearance edit state from the copied skin.'
  }
  if ($pas -notmatch 'procedure\s+TfrmLazRibbonSkinEditor\.btnOpenClick[\s\S]*?RefreshFullAppearanceEditedFromCurrentSkin;') {
    Add-Failure 'Opening a skin must refresh the Appearance edit state from file contents.'
  }
}

function Test-TwoPointZeroPlanningDocs {
  $auditPath = Join-Path $SourceRoot 'docs/quality/PUBLIC_API_AUDIT_2_0.md'
  $roadmapPath = Join-Path $SourceRoot 'docs/release/ROADMAP_2_0.md'

  if (-not (Test-Path -LiteralPath $auditPath)) {
    Add-Failure 'Missing public API audit for the 2.0 freeze.'
  }
  else {
    $audit = Get-Content -LiteralPath $auditPath -Raw
    foreach ($required in @(
      'ShowMinimizeRibbonButton',
      'BackButtonVisible',
      'SelectedSkinName',
      'Icon16Data'
    )) {
      if ($audit -notmatch [regex]::Escape($required)) {
        Add-Failure "Public API audit must mention $required."
      }
    }
  }

  if (-not (Test-Path -LiteralPath $roadmapPath)) {
    Add-Failure 'Missing LazRibbon 2.0 roadmap.'
  }
  else {
    $roadmap = Get-Content -LiteralPath $roadmapPath -Raw
    foreach ($required in @(
      'API Freeze Pass',
      'Skin Editor Finish Pass',
      'Release Candidate',
      'Definition Of Done'
    )) {
      if ($roadmap -notmatch [regex]::Escape($required)) {
        Add-Failure "LazRibbon 2.0 roadmap must include $required."
      }
    }
  }
}

if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
  $scriptPath = if (-not [string]::IsNullOrWhiteSpace($PSCommandPath)) {
    $PSCommandPath
  }
  elseif (-not [string]::IsNullOrWhiteSpace($MyInvocation.MyCommand.Path)) {
    $MyInvocation.MyCommand.Path
  }
  else {
    Join-Path (Get-Location).Path 'tools\check_project_consistency.ps1'
  }
  $SourceRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
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
Test-RibbonAppearanceStreaming
Test-BackstageOverlayDefault
Test-BackstageBackButtonOfficeApi
Test-RibbonMinimizedHeightAdjustment
Test-RibbonMinimizeOfficeApi
Test-SkinEditorPreviewMinimizeSync
Test-SkinEditorAppearanceModeDetection
Test-TwoPointZeroPlanningDocs
Test-ForbiddenFiles

if ($failures.Count -eq 0) {
  Write-Host "Project consistency audit passed for LazRibbon $ExpectedVersion."
  exit 0
}

Write-Host "Project consistency audit failed:"
$failures | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
exit 1
