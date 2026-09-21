[CmdletBinding()]
param(
  [string]$SourceRoot = '',
  [string]$Version = '2.1.18',
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
$tick = [char]96

function Join-SourcePath {
  param([Parameter(Mandatory = $true)][string]$RelativePath)
  return Join-Path $root $RelativePath
}

function Read-SourceText {
  param([Parameter(Mandatory = $true)][string]$RelativePath)

  $path = Join-SourcePath $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Required API governance input not found: $RelativePath"
  }
  return Get-Content -LiteralPath $path -Raw
}

function Get-PackageVersion {
  param([Parameter(Mandatory = $true)][string]$RelativePath)

  $path = Join-SourcePath $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    return '<missing>'
  }

  [xml]$xml = Get-Content -LiteralPath $path -Raw
  $versionNode = $xml.SelectSingleNode('/CONFIG/Package/Version[@Major]')
  if ($null -eq $versionNode) {
    return '<missing>'
  }
  return ('{0}.{1}.{2}' -f $versionNode.Major, $versionNode.Minor, $versionNode.Release)
}

function ConvertTo-InlineCode {
  param([string]$Value)
  return $tick + $Value + $tick
}

function ConvertTo-MarkdownTableText {
  param([string]$Value)
  return (($Value -replace '\|', '\|') -replace "`r?`n", ' ').Trim()
}

function Test-AllTextContains {
  param(
    [Parameter(Mandatory = $true)][string]$Text,
    [Parameter(Mandatory = $true)][string[]]$Required
  )

  foreach ($item in $Required) {
    if ($Text -notmatch [regex]::Escape($item)) {
      return $false
    }
  }
  return $true
}

function Import-ObjectInspectorSnapshot {
  param([Parameter(Mandatory = $true)][string]$RelativePath)

  $path = Join-SourcePath $RelativePath
  $components = [ordered]@{}
  $currentLayer = ''
  $currentClass = ''

  foreach ($line in (Get-Content -LiteralPath $path)) {
    if ($line -match '^##\s+(.+)$') {
      $heading = $matches[1].Trim()
      if ($heading -notin @('Summary', 'Gate Status', 'Current Conclusion', 'Source Documents')) {
        $currentLayer = $heading
      }
      continue
    }

    if ($line -match '^###\s+(.+)$') {
      $currentClass = $matches[1].Trim()
      $components[$currentClass] = [pscustomobject]@{
        Layer = $currentLayer
        ClassName = $currentClass
        Source = ''
        Properties = New-Object System.Collections.Generic.List[object]
      }
      continue
    }

    if ([string]::IsNullOrWhiteSpace($currentClass)) {
      continue
    }

    if ($line -match '^Source:\s+`([^`]+)`') {
      $components[$currentClass].Source = $matches[1]
      continue
    }

    if ($line -match '^- `(?<Name>[^`]+)`:\s+`(?<Declaration>.+)`$') {
      $components[$currentClass].Properties.Add([pscustomobject]@{
        Name = $matches['Name']
        Declaration = $matches['Declaration']
      }) | Out-Null
    }
  }

  return $components
}

function Get-PropertyNames {
  param(
    [Parameter(Mandatory = $true)]$Components,
    [Parameter(Mandatory = $true)][string]$ClassName
  )

  if (-not $Components.Contains($ClassName)) {
    return @()
  }
  $propertyList = $Components[$ClassName].PSObject.Properties['Properties'].Value
  return @($propertyList | ForEach-Object { $_.Name })
}

function Test-ComponentHasProperty {
  param(
    [Parameter(Mandatory = $true)]$Components,
    [Parameter(Mandatory = $true)][string]$ClassName,
    [Parameter(Mandatory = $true)][string]$PropertyName
  )

  $names = @(Get-PropertyNames -Components $Components -ClassName $ClassName)
  return ($names -contains $PropertyName)
}

function New-Role {
  param(
    [Parameter(Mandatory = $true)][string]$Layer,
    [Parameter(Mandatory = $true)][string]$ClassName,
    [Parameter(Mandatory = $true)][string]$Role,
    [Parameter(Mandatory = $true)][string]$ConnectThrough,
    [Parameter(Mandatory = $true)][string]$ConfigureFirst,
    [Parameter(Mandatory = $true)][string]$Rule,
    [string[]]$Required = @(),
    [string[]]$Forbidden = @()
  )

  [pscustomobject]@{
    Layer = $Layer
    ClassName = $ClassName
    Role = $Role
    ConnectThrough = $ConnectThrough
    ConfigureFirst = $ConfigureFirst
    Rule = $Rule
    Required = $Required
    Forbidden = $Forbidden
  }
}

function Add-Gate {
  param(
    [Parameter(Mandatory = $true)][string]$Area,
    [Parameter(Mandatory = $true)][string]$Gate,
    [Parameter(Mandatory = $true)][string]$Status,
    [Parameter(Mandatory = $true)][string]$Evidence,
    [string]$NextStep = ''
  )

  if ([string]::IsNullOrWhiteSpace($NextStep)) {
    $NextStep = 'Keep under routine consistency validation.'
  }

  $script:gates.Add([pscustomobject]@{
    Area = $Area
    Gate = $Gate
    Status = $Status
    Evidence = $Evidence
    NextStep = $NextStep
  }) | Out-Null
}

$snapshotPath = 'docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md'
$redundancyPath = 'docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md'
$designSkipPath = 'docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md'
$matrixPath = 'docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md'
$manualPath = 'docs/manual/LAZRIBBON_MANUAL.md'
$referencePath = 'docs/manual/LAZRIBBON_COMPONENT_REFERENCE.md'
$roadmapPath = 'docs/release/ROADMAP_2_1.md'
$releaseNotesPath = 'docs/release/RELEASE_' + ($Version -replace '\.', '_') + '.md'

$snapshot = Read-SourceText $snapshotPath
$redundancy = Read-SourceText $redundancyPath
$designSkip = Read-SourceText $designSkipPath
$matrix = Read-SourceText $matrixPath
$readme = Read-SourceText 'README.md'
$manual = Read-SourceText $manualPath
$reference = Read-SourceText $referencePath
$roadmap = Read-SourceText $roadmapPath
$components = Import-ObjectInspectorSnapshot -RelativePath $snapshotPath

$roles = @(
  (New-Role 'Shell' 'TLazRibbonForm' 'Ribbon-aware form and optional Office-like title bar.' 'Ribbon, SkinManager' 'UseCustomTitleBar, TitleBarHeight, ShowSystemButtons, ShowTitleIcon' 'The form only connects the application shell to the Ribbon and skin source.' @('Ribbon', 'SkinManager') @()),
  (New-Role 'Shell' 'TLazRibbon' 'Main Ribbon root and owner of the top-level command surface.' 'ApplicationButton, QuickAccessToolBar, BackstageView, SkinManager' 'AppearanceSource, RibbonMinimized, ShowMinimizeRibbonButton, ShowKeyTips, tab metrics' 'The root exposes composition objects and global Ribbon behavior, while complete visual styling is delegated to SkinManager.' @('ApplicationButton', 'QuickAccessToolBar', 'BackstageView', 'AppearanceSource', 'SkinManager', 'RibbonMinimized', 'ShowMinimizeRibbonButton') @('Appearance', 'RibbonAppearance', 'ShowCollapseButton', 'CollapseRibbonHint', 'ExpandRibbonHint')),
  (New-Role 'Shell' 'TLazRibbonApplicationButton' 'Office File/Application button behavior.' 'Menu or owner TLazRibbon.BackstageView' 'Caption, Visible, Mode, Style, Glyph, ImageIndex, ScreenTip fields, OnClick' 'The button configures button behavior only; BackStage composition belongs to TLazRibbon.BackstageView.' @('Caption', 'Visible', 'Mode', 'Style', 'Menu', 'OnClick') @('BackstageView')),
  (New-Role 'Shell' 'TLazRibbonQuickAccessToolBar' 'Quick Access Toolbar command surface and customization entry point.' 'Items, CustomizeActionList' 'Position, Visible, ButtonFrameStyle, Allow*, Show* menu flags' 'Allow* properties decide behavior; Show* properties decide which customization commands are visible.' @('Items', 'AllowCustomizing', 'AllowPositionChange', 'AllowMinimizeRibbon', 'ShowCustomizeButton') @()),
  (New-Role 'Shell' 'TLazRibbonQuickAccessItem' 'Single Quick Access Toolbar command entry.' 'Action, LinkedItem' 'Caption, ImageIndex, Enabled, Visible, KeyTip, ScreenTip fields' 'A QAT item either delegates to a command/action or links to an existing Ribbon item.' @('Caption', 'Action', 'LinkedItem', 'ImageIndex', 'Enabled', 'Visible') @()),

  (New-Role 'Ribbon Structure' 'TLazRibbonTab' 'Ribbon page/tab.' 'Panes collection on the tab object' 'Caption, KeyTip, Visible, contextual-tab fields' 'Tabs organize panes and may carry contextual metadata, but do not own commands directly.' @('Caption', 'KeyTip', 'Contextual', 'Visible') @()),
  (New-Role 'Ribbon Structure' 'TLazRibbonPane' 'Command group inside a tab.' 'Items collection on the pane object' 'Caption, ShowDialogLauncher, DialogLauncherStyle, OnDialogLauncherClick' 'Panes group commands and optionally expose the Office Dialog Launcher pattern.' @('Caption', 'ShowDialogLauncher', 'DialogLauncherStyle', 'OnDialogLauncherClick') @()),
  (New-Role 'Ribbon Structure' 'TLazRibbonCustomRibbonExtItem' 'Base visible Ribbon item behavior.' 'Owner pane item collection' 'Caption, DisplayMode, ImageIndex, LargeImageIndex, Width, OnClick' 'Shared visible item vocabulary remains small and command-oriented.' @('Caption', 'DisplayMode', 'ImageIndex', 'LargeImageIndex', 'Width', 'OnClick') @()),
  (New-Role 'Ribbon Structure' 'TLazRibbonControlHostItem' 'Hosted Lazarus control inside a Ribbon pane.' 'Control' 'Control' 'Hosted controls are connected by object reference; legacy string metadata stays hidden.' @('Control') @('ControlName', 'ControlClassName')),
  (New-Role 'Ribbon Structure' 'TLazRibbonGalleryItem' 'Generic gallery/grid Ribbon item.' 'Gallery item collection' 'Columns, ItemWidth, ItemHeight, PopupMode, PopupWidth, PopupHeight' 'Generic galleries use ItemWidth and ItemHeight; skin galleries use IconWidth and IconHeight.' @('Columns', 'ItemWidth', 'ItemHeight') @('IconWidth', 'IconHeight')),
  (New-Role 'Ribbon Structure' 'TLazRibbonSkinGalleryItem' 'Ribbon skin selector gallery item.' 'SkinManager' 'SelectedSkinName, ShowHints, IconWidth, IconHeight, MaxVisibleItems, OverflowMode' 'Skin selection uses name-based selection so built-in and external skins share one API.' @('SkinManager', 'SelectedSkinName', 'IconWidth', 'IconHeight', 'OnSkinSelected') @('SelectedSkin', 'ItemWidth', 'ItemHeight', 'ShowCaptions')),

  (New-Role 'BackStage' 'TLazRibbonBackstageButton' 'BackStage navigation, command or separator entry.' 'Page, Action, LinkedItem' 'Kind, Section, Caption, Page, CloseBackstageOnClick, OnExecute' 'BackStage navigation is represented by button entries; pages remain content containers.' @('Kind', 'Section', 'Caption', 'Page', 'CloseBackstageOnClick', 'OnExecute') @('ItemKind')),
  (New-Role 'BackStage' 'TLazRibbonBackstagePage' 'BackStage content page.' 'Normal child controls placed on the page' 'Caption and ordinary layout/control properties' 'A page is a content container; navigation and commands belong to TLazRibbonBackstageView.Buttons.' @('Caption') @('Action', 'Command', 'CloseBackstageOnClick', 'ItemKind', 'OnExecute')),
  (New-Role 'BackStage' 'TLazRibbonBackstageRecentList' 'Recent document/file list.' 'Items, SkinManager or linked appearance source' 'AppearanceSource, CloseBackstageOnClick, ItemHeight, MaxRecentItems, SelectionStyle, StorageSection, OnItemClick' 'Recent-list data and storage are kept on the list; visuals come from the selected appearance source; selection returns to the main screen by default.' @('AppearanceSource', 'CloseBackstageOnClick', 'Items', 'SkinManager', 'StorageSection', 'OnItemClick') @('UseToolbarAppearance', 'UseSkinManager')),
  (New-Role 'BackStage' 'TLazRibbonBackstageView' 'Office-like BackStage overlay.' 'Buttons, LinkedToolbar, SkinManager, pages' 'AppearanceSource, OverlayMode, BackButtonVisible, NavigationStyle, PageButtonVisualMode' 'The BackStage view owns overlay/navigation behavior; linked toolbar or SkinManager owns visuals.' @('Buttons', 'AppearanceSource', 'OverlayMode', 'BackButtonVisible', 'LinkedToolbar', 'SkinManager') @('ShowCloseButton', 'UseToolbarAppearance', 'UseSkinManager')),

  (New-Role 'Skin System' 'TLazRibbonSkinManager' 'Skin repository and active skin source.' 'Assigned to Ribbon, BackStage, skin gallery or skin selector' 'SkinFolder, ActiveSkinName, Appearance, General, Accent, Backstage, RecentList, Ribbon' 'The manager is the canonical visual source for new projects and owns the complete Appearance model.' @('SkinFolder', 'ActiveSkinName', 'Appearance', 'General', 'Accent', 'Backstage', 'RecentList', 'Ribbon') @('ActiveSkin', 'BackColor', 'NavigationColor', 'HotColor', 'RecentOddColor')),
  (New-Role 'Skin System' 'TLazRibbonSkinGeneralColors' 'General skin palette branch.' 'Owned by TLazRibbonSkinManager.General' 'BackColor, TextColor, MutedTextColor, BorderColor' 'Palette subobjects expose low-level color slots only inside their semantic branch.' @('BackColor', 'TextColor', 'MutedTextColor', 'BorderColor') @()),
  (New-Role 'Skin System' 'TLazRibbonSkinAccentColors' 'Accent skin palette branch.' 'Owned by TLazRibbonSkinManager.Accent' 'NavigationColor, ActiveColor, HotColor' 'Palette subobjects expose low-level color slots only inside their semantic branch.' @('NavigationColor', 'ActiveColor', 'HotColor') @()),
  (New-Role 'Skin System' 'TLazRibbonSkinBackstageColors' 'BackStage skin palette branch.' 'Owned by TLazRibbonSkinManager.Backstage' 'NavigationColor, TextColor, MutedTextColor, HotColor, selected colors' 'BackStage-specific palette state is grouped away from the top-level manager.' @('NavigationColor', 'TextColor', 'SelectedColor', 'SelectedFrameColor') @('ActiveColor', 'FrameColor')),
  (New-Role 'Skin System' 'TLazRibbonSkinRecentListColors' 'Recent-list skin palette branch.' 'Owned by TLazRibbonSkinManager.RecentList' 'OddColor, HoverColor, SelectedColor, SelectedFrameColor, TitleColor' 'Recent-list-specific palette state is grouped away from the top-level manager.' @('OddColor', 'HoverColor', 'SelectedColor', 'SelectedFrameColor', 'TitleColor') @()),
  (New-Role 'Skin System' 'TLazRibbonSkinRibbonColors' 'Ribbon strip skin palette branch.' 'Owned by TLazRibbonSkinManager.Ribbon' 'TopColor, BottomColor, TabActiveColor, TabHotColor, GroupColor, GroupFrameColor' 'Ribbon-strip palette state is grouped away from the top-level manager.' @('TopColor', 'BottomColor', 'TabActiveColor', 'TabHotColor', 'GroupColor', 'GroupFrameColor') @()),
  (New-Role 'Skin System' 'TLazRibbonSkinDefinition' 'Serializable skin identity and visual definition.' 'Owned by SkinManager or loaded from .skin XML' 'Name, DisplayName, GroupName, Author, Description, Icon*Data, Appearance' 'Distributable skins embed identity and icon data in the skin XML, with file-name fields kept out of the normal workflow.' @('Name', 'DisplayName', 'GroupName', 'Author', 'Description', 'Icon16Data', 'Icon24Data', 'Icon32Data', 'Appearance') @('Icon16FileName', 'Icon24FileName', 'Icon32FileName')),
  (New-Role 'Skin System' 'TLazRibbonSkinSelector' 'Standalone skin selector control.' 'SkinManager' 'SelectedSkinName, Columns, IconWidth, IconHeight, ShowCaptions' 'The selector uses the same SelectedSkinName contract as the Ribbon skin gallery.' @('SkinManager', 'SelectedSkinName', 'IconWidth', 'IconHeight', 'Columns') @('SelectedSkin', 'ItemWidth', 'ItemHeight'))
)

$missingComponents = New-Object System.Collections.Generic.List[string]
$missingCanonical = New-Object System.Collections.Generic.List[string]
$forbiddenVisible = New-Object System.Collections.Generic.List[string]
$canonicalTotal = 0

foreach ($role in $roles) {
  if (-not $components.Contains($role.ClassName)) {
    $missingComponents.Add($role.ClassName) | Out-Null
    continue
  }

  foreach ($property in $role.Required) {
    $canonicalTotal++
    if (-not (Test-ComponentHasProperty -Components $components -ClassName $role.ClassName -PropertyName $property)) {
      $missingCanonical.Add("$($role.ClassName).$property") | Out-Null
    }
  }

  foreach ($property in $role.Forbidden) {
    if (Test-ComponentHasProperty -Components $components -ClassName $role.ClassName -PropertyName $property) {
      $forbiddenVisible.Add("$($role.ClassName).$property") | Out-Null
    }
  }
}

$propertyCount = 0
foreach ($component in $components.Values) {
  $propertyList = $component.PSObject.Properties['Properties'].Value
  $propertyCount += $propertyList.Count
}

$appearanceOwners = @()
foreach ($component in $components.Values) {
  $propertyList = $component.PSObject.Properties['Properties'].Value
  $names = @($propertyList | ForEach-Object { $_.Name })
  if ($names -contains 'Appearance') {
    $appearanceOwners += $component.ClassName
  }
}
$appearanceOwners = @($appearanceOwners | Sort-Object)
$allowedAppearanceOwners = @('TLazRibbonSkinDefinition', 'TLazRibbonSkinManager')
$unexpectedAppearanceOwners = @($appearanceOwners | Where-Object { $_ -notin $allowedAppearanceOwners })

$selectedSkinLegacyVisible = @()
foreach ($className in @('TLazRibbonSkinGalleryItem', 'TLazRibbonSkinSelector')) {
  if (Test-ComponentHasProperty -Components $components -ClassName $className -PropertyName 'SelectedSkin') {
    $selectedSkinLegacyVisible += "$className.SelectedSkin"
  }
}

$designSkipRequired = @(
  'TLazRibbon',
  'RibbonAppearance',
  'TLazRibbonBackstagePage',
  'Action',
  'Command',
  'TLazRibbonControlHostItem',
  'ControlName',
  'ControlClassName',
  'TLazRibbonSkinManager',
  'ActiveSkin',
  'TLazRibbonSkinSelector',
  'SelectedSkin'
)

$docsRequired = @(
  'First Ribbon Form',
  'TLazRibbonForm',
  'TLazRibbon.BackstageView',
  'TLazRibbonSkinManager',
  'AppearanceSource'
)

$script:gates = New-Object System.Collections.Generic.List[object]
$runtimeVersion = Get-PackageVersion 'packages/LazRibbonRuntime.lpk'
$designVersion = Get-PackageVersion 'packages/LazRibbonDesign.lpk'

Add-Gate 'Versioning' 'Package metadata aligned' ($(if (($runtimeVersion -eq $Version) -and ($designVersion -eq $Version)) { 'Ready' } else { 'Review' })) "Runtime $runtimeVersion; design $designVersion; expected $Version." 'Keep runtime and design package versions synchronized before tagging.'
Add-Gate 'Inventory' 'Object Inspector snapshot parsed' ($(if (($components.Count -ge 24) -and ($propertyCount -ge 300)) { 'Ready' } else { 'Review' })) "$($components.Count) components and $propertyCount effective properties were parsed from the snapshot." 'Regenerate OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md after published property changes.'
Add-Gate 'Inventory' 'Component roles mapped' ($(if ($missingComponents.Count -eq 0) { 'Ready' } else { 'Review' })) "$($roles.Count - $missingComponents.Count) of $($roles.Count) governed component roles are present." 'Add new public components to this governance map before release.'
Add-Gate 'Canonical API' 'Required composition properties present' ($(if ($missingCanonical.Count -eq 0) { 'Ready' } else { 'Review' })) "$($canonicalTotal - $missingCanonical.Count) of $canonicalTotal required composition properties are present." 'A missing canonical property usually means the component model drifted from the documented workflow.'
Add-Gate 'Canonical API' 'Forbidden visible properties absent' ($(if ($forbiddenVisible.Count -eq 0) { 'Ready' } else { 'Review' })) "Forbidden visible properties present: $($forbiddenVisible.Count)." 'Hide, rename or document role-inappropriate properties before release.'
Add-Gate 'Canonical API' 'Appearance ownership remains clear' ($(if (($unexpectedAppearanceOwners.Count -eq 0) -and ($appearanceOwners -join ',') -eq ($allowedAppearanceOwners -join ',')) { 'Ready' } else { 'Review' })) "Appearance owners: $($appearanceOwners -join ', ')." 'Keep complete appearance editing on TLazRibbonSkinManager and TLazRibbonSkinDefinition.'
Add-Gate 'Canonical API' 'Skin selection uses name-based properties' ($(if ($selectedSkinLegacyVisible.Count -eq 0) { 'Ready' } else { 'Review' })) "Legacy SelectedSkin properties visible: $($selectedSkinLegacyVisible.Count)." 'Use SelectedSkinName in Object Inspector surfaces.'
Add-Gate 'Design-time filtering' 'Compatibility-only properties are hidden' ($(if (Test-AllTextContains $designSkip $designSkipRequired) { 'Ready' } else { 'Review' })) 'Design-time skip audit covers RibbonAppearance, BackStage page command aliases, hosted-control metadata and skin selection aliases.' 'Keep design-time hide rules documented when compatibility aliases remain public.'
Add-Gate 'Redundancy' 'Repeated names remain classified' ($(if (Test-AllTextContains $redundancy @('Unclassified repeated property names: 0', 'No unclassified repeated property names were found.')) { 'Ready' } else { 'Review' })) 'The repeated-name audit has zero unclassified names.' 'Classify or rename any new repeated property name.'
Add-Gate 'Documentation' 'Developer docs explain the composition model' ($(if ((Test-AllTextContains $readme $docsRequired) -and (Test-AllTextContains $manual $docsRequired) -and (Test-AllTextContains $matrix @('TLazRibbon.BackstageView', 'TLazRibbonSkinManager', 'AppearanceSource', 'Object Inspector')) -and (Test-AllTextContains $reference @('TLazRibbonSkinManager', 'SelectedSkinName', 'BackButtonVisible'))) { 'Ready' } else { 'Review' })) 'README/manual/reference documentation use the same shell-to-skin composition vocabulary.' 'Update docs together with any public Object Inspector change.'
Add-Gate 'Release' 'Current release notes exist' ($(if (Test-Path -LiteralPath (Join-SourcePath $releaseNotesPath)) { 'Ready' } else { 'Review' })) "$releaseNotesPath is the expected release note document for $Version." 'Create release notes before running the release candidate preflight.'
Add-Gate 'Release' 'Roadmap tracks API governance' ($(if (Test-AllTextContains $roadmap @('Object Inspector', 'professional readiness', 'component API governance')) { 'Ready' } else { 'Review' })) 'The 2.1 roadmap keeps API clarity tied to professional readiness.' 'Keep future public API changes tied to a generated governance report.'

$readyCount = @($gates | Where-Object { $_.Status -eq 'Ready' }).Count
$reviewCount = @($gates | Where-Object { $_.Status -eq 'Review' }).Count
$manualCount = @($gates | Where-Object { $_.Status -eq 'Manual' }).Count

$out = New-Object System.Collections.Generic.List[string]
$out.Add('# LazRibbon 2.1 Component API Governance')
$out.Add('')
$out.Add('Generated by ' + (ConvertTo-InlineCode 'tools/export_component_api_governance_2_1.ps1') + ' from the effective Object Inspector snapshot, redundancy audit, design-time hide audit and package documentation.')
$out.Add('This report records how the public LazRibbon components are intended to connect into an Office-like interface, and it turns property clarity into a repeatable release gate.')
$out.Add('')
$out.Add('Regenerate after adding, removing, renaming, publishing or hiding component properties:')
$out.Add('')
$out.Add((ConvertTo-InlineCode 'powershell -ExecutionPolicy Bypass -File tools/export_component_api_governance_2_1.ps1 -OutputPath docs/quality/COMPONENT_API_GOVERNANCE_2_1.md'))
$out.Add('')
$out.Add('## Summary')
$out.Add('')
$out.Add(('- Target version: {0}' -f $Version))
$out.Add(('- Runtime package version: {0}' -f $runtimeVersion))
$out.Add(('- Design-time package version: {0}' -f $designVersion))
$out.Add(('- Components inventoried: {0}' -f $components.Count))
$out.Add(('- Effective Object Inspector properties inventoried: {0}' -f $propertyCount))
$out.Add(('- Component roles mapped: {0}/{1}' -f ($roles.Count - $missingComponents.Count), $roles.Count))
$out.Add(('- Canonical property checks ready: {0}/{1}' -f ($canonicalTotal - $missingCanonical.Count), $canonicalTotal))
$out.Add(('- Forbidden visible properties present: {0}' -f $forbiddenVisible.Count))
$out.Add(('- Unexpected Appearance owners: {0}' -f $unexpectedAppearanceOwners.Count))
$out.Add(('- Legacy SelectedSkin properties visible: {0}' -f $selectedSkinLegacyVisible.Count))
$out.Add(('- Gates ready: {0}' -f $readyCount))
$out.Add(('- Gates requiring manual validation: {0}' -f $manualCount))
$out.Add(('- Gates needing review: {0}' -f $reviewCount))
$out.Add('')
$out.Add('## Composition Flow')
$out.Add('')
$out.Add('A new application should read the component model from top to bottom:')
$out.Add('')
$out.Add('1. ' + (ConvertTo-InlineCode 'TLazRibbonForm') + ' connects the form shell to ' + (ConvertTo-InlineCode 'TLazRibbon') + ' and an optional ' + (ConvertTo-InlineCode 'TLazRibbonSkinManager') + '.')
$out.Add('2. ' + (ConvertTo-InlineCode 'TLazRibbon') + ' owns the Office surface: Application Button, Quick Access Toolbar, tabs, BackStage link and global Ribbon behavior.')
$out.Add('3. Tabs contain panes; panes contain commands, galleries, skin galleries, separators or hosted controls.')
$out.Add('4. BackStage is linked through ' + (ConvertTo-InlineCode 'TLazRibbon.BackstageView') + '; navigation and commands live in ' + (ConvertTo-InlineCode 'TLazRibbonBackstageView.Buttons') + ', while pages are content containers.')
$out.Add('5. Skins are owned by ' + (ConvertTo-InlineCode 'TLazRibbonSkinManager') + '; controls connect to the manager through ' + (ConvertTo-InlineCode 'SkinManager') + ' and select skins with name-based properties.')
$out.Add('')
$out.Add('## Gate Status')
$out.Add('')
$out.Add('| Area | Gate | Status | Evidence | Next step |')
$out.Add('| --- | --- | --- | --- | --- |')
foreach ($gate in $gates) {
  $out.Add('| ' + (ConvertTo-MarkdownTableText $gate.Area) + ' | ' + (ConvertTo-MarkdownTableText $gate.Gate) + ' | ' + (ConvertTo-MarkdownTableText $gate.Status) + ' | ' + (ConvertTo-MarkdownTableText $gate.Evidence) + ' | ' + (ConvertTo-MarkdownTableText $gate.NextStep) + ' |')
}
$out.Add('')
$out.Add('## Component Governance Map')
$out.Add('')
$out.Add('| Layer | Component | Role | Connect through | Configure first | Effective properties | Governance rule |')
$out.Add('| --- | --- | --- | --- | --- | --- | --- |')
foreach ($role in $roles) {
  $propertyTotal = 0
  if ($components.Contains($role.ClassName)) {
    $propertyTotal = $components[$role.ClassName].PSObject.Properties['Properties'].Value.Count
  }
  $out.Add('| ' + (ConvertTo-MarkdownTableText $role.Layer) + ' | ' + (ConvertTo-InlineCode $role.ClassName) + ' | ' + (ConvertTo-MarkdownTableText $role.Role) + ' | ' + (ConvertTo-MarkdownTableText $role.ConnectThrough) + ' | ' + (ConvertTo-MarkdownTableText $role.ConfigureFirst) + ' | ' + $propertyTotal + ' | ' + (ConvertTo-MarkdownTableText $role.Rule) + ' |')
}
$out.Add('')
$out.Add('## Watch List')
$out.Add('')
if ($reviewCount -eq 0) {
  $out.Add('- No blocking public API inconsistency is currently visible in the governed Object Inspector surface.')
}
else {
  foreach ($item in @($missingComponents + $missingCanonical + $forbiddenVisible + $unexpectedAppearanceOwners + $selectedSkinLegacyVisible)) {
    $out.Add('- Review ' + (ConvertTo-InlineCode $item) + '.')
  }
}
$out.Add('- Keep ' + (ConvertTo-InlineCode 'RibbonAppearance') + ' hidden from the Object Inspector; detailed skin work belongs to ' + (ConvertTo-InlineCode 'TLazRibbonSkinManager.Appearance') + ' and the Skin Editor.')
$out.Add('- Keep BackStage navigation on ' + (ConvertTo-InlineCode 'TLazRibbonBackstageView.Buttons') + '; pages should stay content containers.')
$out.Add('- Keep skin selection name-based with ' + (ConvertTo-InlineCode 'SelectedSkinName') + ' and ' + (ConvertTo-InlineCode 'ActiveSkinName') + ' so built-in and external skins behave the same way.')
$out.Add('- Add every new package-facing component to this report before publishing it on the Lazarus palette.')
$out.Add('')
$out.Add('## Source Documents')
$out.Add('')
foreach ($path in @(
  'README.md',
  $snapshotPath,
  $redundancyPath,
  $designSkipPath,
  $matrixPath,
  $manualPath,
  $referencePath,
  $roadmapPath
)) {
  $out.Add('- ' + (ConvertTo-InlineCode $path))
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  $out
}
else {
  if (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $root $OutputPath
  }
  $parent = Split-Path -Parent $OutputPath
  if (-not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent | Out-Null
  }
  [System.IO.File]::WriteAllLines($OutputPath, [string[]]$out, [System.Text.Encoding]::UTF8)
}
