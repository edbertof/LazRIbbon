# LazRibbon Component Property Matrix for 2.0

This matrix complements `COMPONENT_COMPOSITION_MODEL_2_0.md` and
`PUBLIC_API_AUDIT_2_0.md`. Its purpose is practical: when a developer selects a
component in the Lazarus Object Inspector, the visible properties should follow
a clear mental model.

## Reading The Matrix

- `Connect through` lists component references or collections that build the
  interface structure.
- `Configure with` lists the primary public properties developers should reach
  for first.
- `Compatibility only` names are preserved for old code or old `.lfm` files, but
  should not be part of the normal new-project workflow.

## Top-Level Shell

| Component | Role | Connect through | Configure with |
| --- | --- | --- | --- |
| `TLazRibbonForm` | Ribbon-aware form shell and optional custom title bar. | `Ribbon`, `SkinManager` | `UseCustomTitleBar`, `TitleBarHeight`, `ShowSystemButtons`, `ShowTitleIcon`, `TitleIcon`, `TitleAlignment` |
| `TLazRibbon` | Main Ribbon root and owner of the top-level Office-like model. | `ApplicationButton`, `QuickAccessToolBar`, `BackstageView`, `Tabs`, `SkinManager` | `AppearanceSource`, `RibbonAppearance`, `RibbonMinimized`, `ShowMinimizeRibbonButton`, `MinimizeRibbonHint`, `RestoreRibbonHint`, `ShowKeyTips`, `ShowContextualGroupHeaders`, `TabCaptionHorizontalPadding`, `TabCaptionSpacing`, `MinTabCaptionWidth` |
| `TLazRibbonApplicationButton` | Office File/Application button behavior. | `Menu` when the selected mode uses a popup menu; BackStage is linked through owner `TLazRibbon.BackstageView` | `Caption`, `Visible`, `Mode`, `Style`, `Glyph`, `ImageIndex`, `ScreenTip*`, `OnClick` |
| `TLazRibbonQuickAccessToolBar` | Quick Access Toolbar command surface. | `Items`, `CustomizeActionList` | `Position`, `Visible`, `ButtonFrameStyle`, `AllowCustomizing`, `ShowCustomizeButton`, `AllowPositionChange`, `ShowPositionMenuItem`, `AllowMinimizeRibbon`, `ShowMinimizeRibbonMenuItem` |

## Ribbon Structure

| Component | Role | Connect through | Configure with |
| --- | --- | --- | --- |
| `TLazRibbonTab` | A Ribbon page/tab. | `Panes` | `Caption`, `Visible`, `Enabled`, `KeyTip`, `Contextual`, `ContextualGroup`, `ContextualColor` |
| `TLazRibbonPane` | A group inside a tab. | `Items` | `Caption`, `ShowDialogLauncher`, `DialogLauncherStyle`, `OnDialogLauncherClick` |
| `TLazRibbonSeparator` | Structural separator between pane items. | None | No command properties in new forms; inherited command and ScreenTip properties are hidden at design time. |
| `TLazRibbonControlHostItem` | Hosted-control item inside a pane. | `Control` | `Control`, `Caption` as fallback placeholder text. |

## Command Surfaces

| Component | Role | Connect through | Configure with |
| --- | --- | --- | --- |
| `TLazRibbonLargeButton` and `TLazRibbonSmallButton` | Primary Ribbon commands. | Optional standard `Action` | `Caption`, `Enabled`, `ImageIndex`, `Glyph`, `KeyTip`, `ShowScreenTip`, `ScreenTipTitle`, `ScreenTipText`, `ScreenTipShortcut`, `ScreenTipFooter`, `OnClick` |
| `TLazRibbonQuickAccessItem` | QAT command entry. | `Action`, `LinkedItem` | `Caption`, `ImageIndex`, `Glyph`, `Enabled`, `ScreenTip*`, `OnClick` |
| `TLazRibbonGalleryItem` | Generic gallery/grid command item. | Gallery items collection | `ItemWidth`, `ItemHeight` |
| `TLazRibbonSkinGalleryItem` | Skin gallery command item. | `SkinManager` | `SelectedSkinName`, `IconWidth`, `IconHeight` |

## BackStage

| Component | Role | Connect through | Configure with |
| --- | --- | --- | --- |
| `TLazRibbonBackstageView` | Office-like BackStage overlay. | `Buttons`, BackStage pages, `LinkedToolbar`, `SkinManager` | `AppearanceSource`, `OverlayMode`, `BackButtonVisible`, `NavigationStyle`, `PageButtonVisualMode` |
| `TLazRibbonBackstagePage` | BackStage content page. | Normal child controls placed on the page | Content layout properties only; navigation and commands belong to `TLazRibbonBackstageView.Buttons`. |
| `TLazRibbonBackstageButtons` and button items | BackStage navigation/command list. | Page links or command handlers | Page target, command kind, captions, images and click behavior. |
| `TLazRibbonBackstageRecentList` | Recent-file/document list. | `SkinManager` or linked appearance source | `AppearanceSource`, `SkinManager`, recent item data and click events. |

## Skin Components

| Component | Role | Connect through | Configure with |
| --- | --- | --- | --- |
| `TLazRibbonSkinManager` | Skin repository and active skin source. | Assigned to `TLazRibbon.SkinManager`, BackStage, skin selector or skin gallery | `SkinFolder`, `ActiveSkinName`, `General`, `Accent`, `Backstage`, `RecentList`, `Ribbon`, `Appearance` |
| `TLazRibbonSkinDefinition` | A serializable skin identity and visual definition. | Owned by the skin manager or loaded from `.skin` XML | `Name`, `DisplayName`, `Author`, `Description`, `Group`, `Icon16Data`, `Icon24Data`, `Icon32Data`, `Appearance` |
| `TLazRibbonSkinSelector` | Standalone skin selector control. | `SkinManager` | `SelectedSkinName`, icon/display settings |
| `TLazRibbonSkinGalleryItem` | Ribbon gallery skin selector. | `SkinManager` | `SelectedSkinName`, `IconWidth`, `IconHeight` |

## Visual Appearance

- `TLazRibbon.RibbonAppearance` is the detailed local appearance model for a
  Ribbon that is not taking its visuals from a skin manager.
- `TLazRibbonSkinManager.Appearance` is the complete appearance model owned by a
  skin. The grouped palette properties `General`, `Accent`, `Backstage`,
  `RecentList` and `Ribbon` are the higher-level color API.
- `TLazRibbonBackstageView.AppearanceSource` and
  `TLazRibbonBackstageRecentList.AppearanceSource` decide whether BackStage
  visuals come from internal defaults, a linked toolbar or a `SkinManager`.

## Intentional Similar Pairs

These pairs are not duplicates; each side answers a different design question.

| Pair | Meaning |
| --- | --- |
| `AllowCustomizing` / `ShowCustomizeButton` | Whether customization is allowed versus whether the UI button is visible. |
| `AllowPositionChange` / `ShowPositionMenuItem` | Whether position changes are allowed versus whether that menu command is shown. |
| `AllowMinimizeRibbon` / `ShowMinimizeRibbonMenuItem` | Whether minimizing is allowed versus whether that menu command is shown. |
| `ApplicationButton.Menu` / `ApplicationButton.OnClick` | Popup-menu behavior versus event behavior, selected by `ApplicationButton.Mode`. |
| `ItemWidth` / `IconWidth` | Generic gallery cell width versus skin-icon width. |

## Compatibility-Only Names

- `TLazRibbonApplicationButton.BackstageView` remains public as a source-level
  delegate, but new forms should use `TLazRibbon.BackstageView`.
- `TLazRibbonBackstagePage.Action`, `Command`, `CloseBackstageOnClick`,
  `ItemKind` and `OnExecute` remain public source-level compatibility for the
  older page-as-command model, but are no longer published. New forms should use
  `TLazRibbonBackstageView.Buttons`.
- `TLazRibbonControlHostItem.Control` is the canonical hosted-control reference.
  `TLazRibbonControlHostItem.ControlName` and `ControlClassName` remain public
  and readable from legacy `.lfm` resources, but new forms should assign the
  hosted Lazarus control through `Control`. `Caption` is only fallback
  placeholder text when no control is assigned.
- `TLazRibbonSkinGalleryItem.SelectedSkin` and
  `TLazRibbonSkinSelector.SelectedSkin` remain public built-in-skin helpers;
  new Object Inspector work should use `SelectedSkinName`.
- `TLazRibbonSkinManager.ActiveSkin` remains a public built-in-skin helper and
  is readable from legacy `.lfm` resources, but new Object Inspector work should
  use `ActiveSkinName`.
- `TLazRibbonSkinDefinition.Icon16FileName`, `Icon24FileName` and
  `Icon32FileName` remain import/source compatibility fields; distributable
  skins should use embedded icon data.

## Release Gate

Before `2.0.0`, a new published property should be accepted only when it fits one
of these roles:

- It connects components in the documented object graph.
- It configures the selected component's own visual or behavioral role.
- It is a standard inherited Lazarus property that remains meaningful.
- It is documented as compatibility-only and hidden from the Object Inspector
  when it would confuse new projects.
