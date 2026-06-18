[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$ExpectedVersion = '1.2.32'
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

      if (($line -match '^\s*(IconWidth|IconHeight)\s*=') -and ($currentType -eq 'TLazRibbonGalleryItem')) {
        Add-Failure "Legacy TLazRibbonGalleryItem icon-size streaming found in ${relative}:${lineNumber}; use ItemWidth or ItemHeight for generic galleries."
      }

      if (($line -match '^\s*(ItemWidth|ItemHeight|ShowCaptions)\s*=') -and ($currentType -eq 'TLazRibbonSkinGalleryItem')) {
        Add-Failure "Legacy TLazRibbonSkinGalleryItem streaming found in ${relative}:${lineNumber}; use IconWidth, IconHeight and ShowHints."
      }

      if (($line -match '^\s*SelectedSkin\s*=') -and ($currentType -in @('TLazRibbonSkinGalleryItem', 'TLazRibbonSkinSelector'))) {
        Add-Failure "Legacy skin selection streaming found in ${relative}:${lineNumber}; use SelectedSkinName."
      }

      if (($line -match '^\s*ActiveSkin\s*=') -and ($currentType -eq 'TLazRibbonSkinManager')) {
        Add-Failure "Legacy TLazRibbonSkinManager ActiveSkin streaming found in ${relative}:${lineNumber}; use ActiveSkinName."
      }

      if (($line -match '^\s*ShowCloseButton\s*=') -and ($currentType -eq 'TLazRibbonBackstageView')) {
        Add-Failure "Legacy TLazRibbonBackstageView back-button streaming found in ${relative}:${lineNumber}; use BackButtonVisible."
      }

      if (($line -match '^\s*ApplicationButton\.BackstageView\s*=') -and ($currentType -eq 'TLazRibbon')) {
        Add-Failure "Duplicate BackStage composition streaming found in ${relative}:${lineNumber}; use TLazRibbon.BackstageView."
      }

      if (($line -match '^\s*(UseToolbarAppearance|UseSkinManager)\s*=') -and ($currentType -in @('TLazRibbonBackstageView', 'TLazRibbonBackstageRecentList'))) {
        Add-Failure "Legacy BackStage appearance-source streaming found in ${relative}:${lineNumber}; use AppearanceSource."
      }

      if (($line -match '^\s*(Action|Caption|Enabled|Hint|KeyTip|ShowScreenTip|ScreenTipTitle|ScreenTipText|ScreenTipShortcut|ScreenTipFooter|OnClick)\s*=') -and ($currentType -eq 'TLazRibbonSeparator')) {
        Add-Failure "Command or ScreenTip streaming found on TLazRibbonSeparator in ${relative}:${lineNumber}; separators are structural items."
      }

      if (($line -match '^\s*(Action|Command|CloseBackstageOnClick|ItemKind|OnExecute)\s*=') -and ($currentType -eq 'TLazRibbonBackstagePage')) {
        Add-Failure "BackStage command/navigation streaming found on TLazRibbonBackstagePage in ${relative}:${lineNumber}; use TLazRibbonBackstageView.Buttons."
      }

      if (($line -match '^\s*(ControlName|ControlClassName)\s*=') -and ($currentType -eq 'TLazRibbonControlHostItem')) {
        Add-Failure "Legacy hosted-control metadata streaming found on TLazRibbonControlHostItem in ${relative}:${lineNumber}; use Caption for placeholder text."
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

function Test-BackstageAppearanceSourceApi {
  $path = Join-Path $SourceRoot 'source/runtime/LazRibbon_Backstage.pas'
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure 'Missing BackStage runtime unit.'
    return
  }

  $content = Get-Content -LiteralPath $path -Raw
  foreach ($required in @(
    'property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asLinkedToolbar;',
    'property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asInternalStyle;',
    'property LinkedToolbar: TLazRibbon read FLinkedToolbar write SetLinkedToolbar;',
    'property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;'
  )) {
    if ($content -notmatch [regex]::Escape($required)) {
      Add-Failure "BackStage appearance-source API must include $required."
    }
  }

  $legacyPattern = '\b(UseToolbarAppearance|UseSkinManager|FUseToolbarAppearance|FUseSkinManager|SetUseToolbarAppearance|SetUseSkinManager)\b'
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
        $fileContent = Get-Content -LiteralPath $_.FullName -Raw
        if ($fileContent -match $legacyPattern) {
          $relative = Get-RelativePath -Path $_.FullName
          Add-Failure "Legacy BackStage appearance-source API name found in ${relative}; use AppearanceSource."
        }
      }
  }
}

function Test-ComponentCompositionApi {
  $corePath = Join-Path $SourceRoot 'source/runtime/LazRibbon_Core.pas'
  $backstagePath = Join-Path $SourceRoot 'source/runtime/LazRibbon_Backstage.pas'
  $extItemsPath = Join-Path $SourceRoot 'source/runtime/LazRibbon_RibbonExtItems.pas'
  $registerPath = Join-Path $SourceRoot 'source/design/LazRibbon_Register.pas'
  $compositionDocPath = Join-Path $SourceRoot 'docs/quality/COMPONENT_COMPOSITION_MODEL_2_0.md'

  foreach ($path in @($corePath, $backstagePath, $extItemsPath, $registerPath, $compositionDocPath)) {
    if (-not (Test-Path -LiteralPath $path)) {
      Add-Failure "Missing component composition audit input: $(Get-RelativePath -Path $path)"
      return
    }
  }

  $core = Get-Content -LiteralPath $corePath -Raw
  $appButtonMatch = [regex]::Match($core, 'TLazRibbonApplicationButton\s*=\s*class\(TPersistent\)([\s\S]*?)\bend;')
  if (-not $appButtonMatch.Success) {
    Add-Failure 'Could not inspect TLazRibbonApplicationButton declaration.'
  }
  else {
    $appButtonBlock = $appButtonMatch.Value
    $published = [regex]::Match($appButtonBlock, 'published[\s\S]*$')
    if ($published.Success -and ($published.Value -match 'property\s+BackstageView\s*:')) {
      Add-Failure 'TLazRibbonApplicationButton must not publish BackstageView; use TLazRibbon.BackstageView for composition.'
    }
    if ($appButtonBlock -notmatch 'property\s+BackstageView:\s+TLazRibbonCustomBackstageView\s+read\s+GetBackstageView\s+write\s+SetBackstageView;') {
      Add-Failure 'TLazRibbonApplicationButton should keep public BackstageView only as a source compatibility delegate.'
    }
  }

  if ($core -notmatch 'property\s+BackstageView:\s+TLazRibbonCustomBackstageView\s+read\s+FBackstageView\s+write\s+SetBackstageView;') {
    Add-Failure 'TLazRibbon must publish BackstageView as the canonical BackStage composition property.'
  }

  $register = Get-Content -LiteralPath $registerPath -Raw
  foreach ($separatorProperty in @(
    'Action',
    'Caption',
    'Enabled',
    'Hint',
    'KeyTip',
    'ShowScreenTip',
    'ScreenTipTitle',
    'ScreenTipText',
    'ScreenTipShortcut',
    'ScreenTipFooter',
    'OnClick'
  )) {
    $pattern = "RegisterPropertyToSkip\(TLazRibbonSeparator,\s+'$separatorProperty'"
    if ($register -notmatch $pattern) {
      Add-Failure "TLazRibbonSeparator design-time API should hide inherited $separatorProperty."
    }
  }

  foreach ($backstagePageProperty in @(
    'Action',
    'Command',
    'CloseBackstageOnClick',
    'ItemKind',
    'OnExecute'
  )) {
    $pattern = "RegisterPropertyToSkip\(TLazRibbonBackstagePage,\s+'$backstagePageProperty'"
    if ($register -notmatch $pattern) {
      Add-Failure "TLazRibbonBackstagePage design-time API should hide command/navigation property $backstagePageProperty."
    }
  }

  $backstage = Get-Content -LiteralPath $backstagePath -Raw
  $backstagePageMatch = [regex]::Match($backstage, 'TLazRibbonBackstagePage\s*=\s*class\(TCustomControl\)([\s\S]*?)\bend;')
  if (-not $backstagePageMatch.Success) {
    Add-Failure 'Could not inspect TLazRibbonBackstagePage declaration.'
  }
  else {
    $backstagePageBlock = $backstagePageMatch.Value
    $published = [regex]::Match($backstagePageBlock, 'published[\s\S]*$')
    if ($published.Success -and ($published.Value -match 'property\s+(Action|Command|CloseBackstageOnClick|ItemKind|OnExecute)\b')) {
      Add-Failure 'TLazRibbonBackstagePage must not publish command/navigation properties; use TLazRibbonBackstageView.Buttons.'
    }
    foreach ($required in @(
      'property Action;',
      'property Command: TLazRibbonCommand read FCommand write SetCommand;',
      'property CloseBackstageOnClick: Boolean read FCloseBackstageOnClick write FCloseBackstageOnClick default True;',
      'property ItemKind: TLazRibbonBackstagePageKind read FItemKind write SetItemKind default bpkPage;',
      'property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;'
    )) {
      if ($backstagePageBlock -notmatch [regex]::Escape($required)) {
        Add-Failure "TLazRibbonBackstagePage should keep source compatibility member $required."
      }
    }
  }

  foreach ($controlHostProperty in @('ControlName', 'ControlClassName')) {
    $pattern = "RegisterPropertyToSkip\(TLazRibbonControlHostItem,\s+'$controlHostProperty'"
    if ($register -notmatch $pattern) {
      Add-Failure "TLazRibbonControlHostItem design-time API should hide legacy metadata property $controlHostProperty."
    }
  }

  $extItems = Get-Content -LiteralPath $extItemsPath -Raw
  $controlHostMatch = [regex]::Match($extItems, 'TLazRibbonControlHostItem\s*=\s*class\(TLazRibbonCustomRibbonExtItem\)([\s\S]*?)\bend;')
  if (-not $controlHostMatch.Success) {
    Add-Failure 'Could not inspect TLazRibbonControlHostItem declaration.'
  }
  else {
    $controlHostBlock = $controlHostMatch.Value
    $published = [regex]::Match($controlHostBlock, 'published[\s\S]*$')
    if ($published.Success -and ($published.Value -match 'property\s+(ControlName|ControlClassName)\s*:')) {
      Add-Failure 'TLazRibbonControlHostItem must not publish legacy ControlName/ControlClassName metadata.'
    }
    foreach ($required in @(
      'property ControlName: String read FControlName write SetControlName;',
      'property ControlClassName: String read FControlClassName write SetControlClassName;',
      'procedure DefineProperties(Filer: TFiler); override;',
      'procedure ReadLegacyControlName(Reader: TReader);',
      'procedure ReadLegacyControlClassName(Reader: TReader);'
    )) {
      if ($controlHostBlock -notmatch [regex]::Escape($required)) {
        Add-Failure "TLazRibbonControlHostItem should keep compatibility member $required."
      }
    }
  }
  if ($extItems -notmatch "Filer\.DefineProperty\('ControlName',\s*ReadLegacyControlName,\s*nil,\s*False\);") {
    Add-Failure 'TLazRibbonControlHostItem must read legacy ControlName streaming via DefineProperties.'
  }
  if ($extItems -notmatch "Filer\.DefineProperty\('ControlClassName',\s*ReadLegacyControlClassName,\s*nil,\s*False\);") {
    Add-Failure 'TLazRibbonControlHostItem must read legacy ControlClassName streaming via DefineProperties.'
  }

  $scanRoots = @('source/design', 'tools', 'demos') | ForEach-Object {
    Join-Path $SourceRoot $_
  }
  foreach ($root in $scanRoots) {
    if (-not (Test-Path -LiteralPath $root)) {
      continue
    }
    Get-ChildItem -LiteralPath $root -Recurse -File |
      Where-Object { $_.Extension -in @('.pas', '.lfm') } |
      ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw
        if ($content -match '\bApplicationButton\.BackstageView\b') {
          $relative = Get-RelativePath -Path $_.FullName
          Add-Failure "Package sources/resources must use TLazRibbon.BackstageView instead of ApplicationButton.BackstageView in ${relative}."
        }
        if ($_.Extension -eq '.pas') {
          $previousAssignment = $null
          $lineNumber = 0
          foreach ($line in (Get-Content -LiteralPath $_.FullName)) {
            $lineNumber++
            $trimmed = $line.Trim()
            if ($trimmed -match '\.BackstageView\s*:=') {
              if ($trimmed -eq $previousAssignment) {
                $relative = Get-RelativePath -Path $_.FullName
                Add-Failure "Duplicate consecutive BackStage assignment found in ${relative}:${lineNumber}; keep one TLazRibbon.BackstageView link."
              }
              $previousAssignment = $trimmed
            }
            elseif ($trimmed -ne '') {
              $previousAssignment = $null
            }
          }
        }
      }
  }

  $compositionDoc = Get-Content -LiteralPath $compositionDocPath -Raw
  foreach ($required in @(
    'Composition Rules',
    'Primary Object Graph',
    'Canonical Connections',
    'Current Cleanup Decisions',
    'TLazRibbon.BackstageView',
    'TLazRibbonSeparator',
    'TLazRibbonBackstageView.Buttons',
    'TLazRibbonBackstagePage',
    'TLazRibbonControlHostItem'
  )) {
    if ($compositionDoc -notmatch [regex]::Escape($required)) {
      Add-Failure "Component composition model must include $required."
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

function Test-GallerySizeOfficeApi {
  $path = Join-Path $SourceRoot 'source/runtime/LazRibbon_RibbonExtItems.pas'
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure 'Missing Ribbon extended items unit.'
    return
  }

  $content = Get-Content -LiteralPath $path -Raw
  $baseMatch = [regex]::Match($content, 'TLazRibbonGalleryItem\s*=\s*class[\s\S]*?\{\s*TLazRibbonSkinGalleryItem\s*\}')
  if (-not $baseMatch.Success) {
    Add-Failure 'Could not inspect TLazRibbonGalleryItem declaration.'
  }
  else {
    $baseBlock = $baseMatch.Value
    foreach ($required in @(
      'property ItemWidth: Integer read FItemWidth write SetItemWidth default 22;',
      'property ItemHeight: Integer read FItemHeight write SetItemHeight default 22;'
    )) {
      if ($baseBlock -notmatch [regex]::Escape($required)) {
        Add-Failure "TLazRibbonGalleryItem must publish $required"
      }
    }
    if ($baseBlock -match 'property\s+Icon(Width|Height)\b') {
      Add-Failure 'TLazRibbonGalleryItem must not publish IconWidth/IconHeight aliases; use ItemWidth/ItemHeight.'
    }
  }

  $skinMatch = [regex]::Match($content, 'TLazRibbonSkinGalleryItem\s*=\s*class[\s\S]*?implementation')
  if (-not $skinMatch.Success) {
    Add-Failure 'Could not inspect TLazRibbonSkinGalleryItem declaration.'
  }
  else {
    $skinBlock = $skinMatch.Value
    foreach ($required in @(
      'property IconWidth: Integer read FItemWidth write SetItemWidth default 22;',
      'property IconHeight: Integer read FItemHeight write SetItemHeight default 22;'
    )) {
      if ($skinBlock -notmatch [regex]::Escape($required)) {
        Add-Failure "TLazRibbonSkinGalleryItem must publish $required"
      }
    }
  }

  foreach ($required in @(
    'procedure TLazRibbonGalleryItem.DefineProperties',
    'ReadLegacyIconWidth',
    'ReadLegacyIconHeight'
  )) {
    if ($content -notmatch [regex]::Escape($required)) {
      Add-Failure "TLazRibbonGalleryItem must keep legacy streaming support through $required."
    }
  }
}

function Test-SkinSelectionNameApi {
  $targets = @(
    @{
      Path = 'source/runtime/LazRibbon_RibbonExtItems.pas'
      ClassName = 'TLazRibbonSkinGalleryItem'
      EndPattern = '\{\s*TLazRibbonSkinGalleryItem\s*\}'
    },
    @{
      Path = 'source/runtime/LazRibbon_SkinSelector.pas'
      ClassName = 'TLazRibbonSkinSelector'
      EndPattern = 'implementation'
    }
  )

  foreach ($target in $targets) {
    $path = Join-Path $SourceRoot $target.Path
    if (-not (Test-Path -LiteralPath $path)) {
      Add-Failure "Missing skin selection unit: $($target.Path)"
      continue
    }

    $content = Get-Content -LiteralPath $path -Raw
    $className = $target.ClassName
    $match = [regex]::Match($content, "$className\s*=\s*class[\s\S]*?$($target.EndPattern)")
    if (-not $match.Success) {
      Add-Failure "Could not inspect $className declaration."
      continue
    }

    $block = $match.Value
    if ($block -notmatch 'property\s+SelectedSkinName:\s+String\s+read\s+GetSelectedSkinName\s+write\s+SetSelectedSkinName;') {
      Add-Failure "$className must publish SelectedSkinName as the canonical skin selection API."
    }

    $publishedMatch = [regex]::Match($block, 'published[\s\S]*$')
    if ($publishedMatch.Success -and ($publishedMatch.Value -match 'property\s+SelectedSkin\s*:')) {
      Add-Failure "$className must not publish SelectedSkin; keep SelectedSkinName in the Object Inspector."
    }

    if ($content -notmatch [regex]::Escape("Filer.DefineProperty('SelectedSkin', ReadLegacySelectedSkin, nil, False);")) {
      Add-Failure "$className must keep legacy SelectedSkin streaming support."
    }
    $readerPattern = 'procedure\s+' + [regex]::Escape($className) + '\.ReadLegacySelectedSkin'
    if ($content -notmatch $readerPattern) {
      Add-Failure "$className must implement ReadLegacySelectedSkin."
    }
  }
}

function Test-SkinManagerActiveSkinNameApi {
  $path = Join-Path $SourceRoot 'source/runtime/LazRibbon_SkinManager.pas'
  $registerPath = Join-Path $SourceRoot 'source/design/LazRibbon_Register.pas'
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure 'Missing skin manager unit.'
    return
  }
  if (-not (Test-Path -LiteralPath $registerPath)) {
    Add-Failure 'Missing LazRibbon design registration unit.'
    return
  }

  $content = Get-Content -LiteralPath $path -Raw
  $match = [regex]::Match($content, 'TLazRibbonSkinManager\s*=\s*class\(TComponent\)([\s\S]*?)\bend;')
  if (-not $match.Success) {
    Add-Failure 'Could not inspect TLazRibbonSkinManager declaration.'
    return
  }

  $block = $match.Value
  if ($block -notmatch 'property\s+ActiveSkinName:\s+String\s+read\s+FActiveSkinName\s+write\s+SetActiveSkinName;') {
    Add-Failure 'TLazRibbonSkinManager must publish ActiveSkinName as the canonical active skin API.'
  }

  $publishedMatch = [regex]::Match($block, 'published[\s\S]*$')
  if ($publishedMatch.Success -and ($publishedMatch.Value -match 'property\s+ActiveSkin\s*:')) {
    Add-Failure 'TLazRibbonSkinManager must not publish ActiveSkin; keep ActiveSkinName in the Object Inspector.'
  }

  foreach ($required in @(
    'property ActiveSkin: TLazRibbonBuiltInSkin read FActiveSkin write SetActiveSkin default sbsOfficeBlue;',
    'procedure DefineProperties(Filer: TFiler); override;',
    'procedure ReadLegacyActiveSkin(Reader: TReader);',
    "Filer.DefineProperty('ActiveSkin', ReadLegacyActiveSkin, nil, False);",
    'procedure TLazRibbonSkinManager.ReadLegacyActiveSkin'
  )) {
    if ($content -notmatch [regex]::Escape($required)) {
      Add-Failure "TLazRibbonSkinManager should keep compatibility member $required."
    }
  }

  $register = Get-Content -LiteralPath $registerPath -Raw
  if ($register -notmatch "RegisterPropertyToSkip\(TLazRibbonSkinManager,\s+'ActiveSkin'") {
    Add-Failure 'TLazRibbonSkinManager design-time API should hide ActiveSkin in favor of ActiveSkinName.'
  }
}

function Test-SkinIdentityIconDataApi {
  $path = Join-Path $SourceRoot 'source/runtime/LazRibbon_SkinDefinition.pas'
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Failure 'Missing skin definition unit.'
    return
  }

  $content = Get-Content -LiteralPath $path -Raw
  $match = [regex]::Match($content, 'TLazRibbonSkinDefinition\s*=\s*class[\s\S]*?function\s+LazBuiltInSkinCount')
  if (-not $match.Success) {
    Add-Failure 'Could not inspect TLazRibbonSkinDefinition declaration.'
    return
  }

  $block = $match.Value
  $publishedMatch = [regex]::Match($block, 'published[\s\S]*$')
  if (-not $publishedMatch.Success) {
    Add-Failure 'TLazRibbonSkinDefinition must expose published skin identity data fields.'
    return
  }

  foreach ($required in @('Icon16Data', 'Icon24Data', 'Icon32Data')) {
    if ($publishedMatch.Value -notmatch "property\s+$required\s*:\s+String") {
      Add-Failure "TLazRibbonSkinDefinition must publish $required as the canonical embedded icon field."
    }
  }

  foreach ($legacy in @('Icon16FileName', 'Icon24FileName', 'Icon32FileName')) {
    if ($publishedMatch.Value -match "property\s+$legacy\s*:") {
      Add-Failure "TLazRibbonSkinDefinition must not publish $legacy; use embedded Icon*Data in the Object Inspector/RTTI surface."
    }
    if ($block -notmatch "property\s+$legacy\s*:\s+String") {
      Add-Failure "TLazRibbonSkinDefinition must keep public $legacy for import/source compatibility."
    }
  }

  foreach ($required in @(
    'WriteLegacyIconFileNameIfNeeded',
    "Root.Parameters['Version', True].Value := '6';",
    "FFormatVersion := '6';"
  )) {
    if ($content -notmatch [regex]::Escape($required)) {
      Add-Failure "TLazRibbonSkinDefinition SaveToFile must include $required."
    }
  }

  foreach ($legacyWrite in @(
    "Info['Icon16FileName', True].Text := FIcon16FileName;",
    "Info['Icon24FileName', True].Text := FIcon24FileName;",
    "Info['Icon32FileName', True].Text := FIcon32FileName;"
  )) {
    if ($content -match [regex]::Escape($legacyWrite)) {
      Add-Failure "TLazRibbonSkinDefinition must not unconditionally write legacy icon file-name tags."
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
  $matrixPath = Join-Path $SourceRoot 'docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md'
  $objectInspectorAuditPath = Join-Path $SourceRoot 'docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md'
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
      'ActiveSkinName',
      'Icon16Data',
      'No active duplicate public Object Inspector names remain',
      'COMPONENT_PROPERTY_MATRIX_2_0.md',
      'OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md'
    )) {
      if ($audit -notmatch [regex]::Escape($required)) {
        Add-Failure "Public API audit must mention $required."
      }
    }
  }

  if (-not (Test-Path -LiteralPath $matrixPath)) {
    Add-Failure 'Missing component property matrix for the 2.0 freeze.'
  }
  else {
    $matrix = Get-Content -LiteralPath $matrixPath -Raw
    foreach ($required in @(
      'Component Property Matrix',
      'Top-Level Shell',
      'Ribbon Structure',
      'Command Surfaces',
      'BackStage',
      'Skin Components',
      'Visual Appearance',
      'Intentional Similar Pairs',
      'Compatibility-Only Names',
      'TLazRibbon.BackstageView',
      'TLazRibbonBackstageView.Buttons',
      'TLazRibbonQuickAccessToolBar',
      'TLazRibbonControlHostItem',
      'SelectedSkinName',
      'ActiveSkinName',
      'Icon16Data',
      'ControlName',
      'Release Gate'
    )) {
      if ($matrix -notmatch [regex]::Escape($required)) {
        Add-Failure "Component property matrix must mention $required."
      }
    }
  }

  if (-not (Test-Path -LiteralPath $objectInspectorAuditPath)) {
    Add-Failure 'Missing Object Inspector property audit for the 2.0 freeze.'
  }
  else {
    $objectInspectorAudit = Get-Content -LiteralPath $objectInspectorAuditPath -Raw
    foreach ($required in @(
      'Object Inspector Property Audit',
      'Palette Components Reviewed',
      'Current Object Inspector Rules',
      'Cleaned Published Properties',
      'BackStage Page Decision',
      'Intentional Shared Names',
      'Remaining Watch List',
      'TLazRibbonBackstagePage',
      'TLazRibbonBackstageView.Buttons',
      'Action',
      'SelectedSkinName',
      'ActiveSkinName',
      'Icon16Data'
    )) {
      if ($objectInspectorAudit -notmatch [regex]::Escape($required)) {
        Add-Failure "Object Inspector property audit must mention $required."
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
Test-BackstageAppearanceSourceApi
Test-ComponentCompositionApi
Test-RibbonMinimizedHeightAdjustment
Test-RibbonMinimizeOfficeApi
Test-GallerySizeOfficeApi
Test-SkinSelectionNameApi
Test-SkinManagerActiveSkinNameApi
Test-SkinIdentityIconDataApi
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
