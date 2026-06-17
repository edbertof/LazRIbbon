# LazRibbon Public API Audit for 2.0

This audit records the current public Object Inspector/API surface that should be
stabilized before the 2.0 release. It focuses on names visible to Lazarus
developers, not on private implementation details.

## Scope

Reviewed runtime units:

- `source/runtime/LazRibbon_Core.pas`
- `source/runtime/LazRibbon_Form.pas`
- `source/runtime/LazRibbon_Groups.pas`
- `source/runtime/LazRibbon_Tabs.pas`
- `source/runtime/LazRibbon_Backstage.pas`
- `source/runtime/LazRibbon_RibbonExtItems.pas`
- `source/runtime/LazRibbon_SkinManager.pas`
- `source/runtime/LazRibbon_SkinDefinition.pas`
- `source/runtime/LazRibbon_SkinSelector.pas`

## Stable API Candidates

These names are already Office-like enough and should be treated as 2.0 freeze
candidates:

- `TLazRibbon.ApplicationButton`
- `TLazRibbon.QuickAccessToolBar`
- `TLazRibbon.BackstageView`
- `TLazRibbon.RibbonAppearance`
- `TLazRibbon.AppearanceSource`
- `TLazRibbon.SkinManager`
- `TLazRibbon.RibbonMinimized`
- `TLazRibbon.ShowMinimizeRibbonButton`
- `TLazRibbon.MinimizeRibbonHint`
- `TLazRibbon.RestoreRibbonHint`
- `TLazRibbon.ShowKeyTips`
- `TLazRibbon.ShowContextualGroupHeaders`
- `TLazRibbon.TabCaptionHorizontalPadding`
- `TLazRibbon.TabCaptionSpacing`
- `TLazRibbon.MinTabCaptionWidth`
- `TLazRibbon.OnTabChanging`
- `TLazRibbon.OnTabChanged`
- `TLazRibbon.OnRibbonMinimizedChanged`
- `TLazRibbonPane.ShowDialogLauncher`
- `TLazRibbonPane.DialogLauncherStyle`
- `TLazRibbonPane.OnDialogLauncherClick`
- `TLazRibbonGalleryItem.ItemWidth`
- `TLazRibbonGalleryItem.ItemHeight`
- `TLazRibbonSkinGalleryItem.IconWidth`
- `TLazRibbonSkinGalleryItem.IconHeight`
- `TLazRibbonSkinGalleryItem.SelectedSkinName`
- `TLazRibbonSkinSelector.SelectedSkinName`
- `TLazRibbonBackstageView.OverlayMode`
- `TLazRibbonBackstageView.BackButtonVisible`
- `TLazRibbonBackstageView.NavigationStyle`
- `TLazRibbonBackstageView.PageButtonVisualMode`
- `TLazRibbonSkinManager.General`
- `TLazRibbonSkinManager.Accent`
- `TLazRibbonSkinManager.Backstage`
- `TLazRibbonSkinManager.RecentList`
- `TLazRibbonSkinManager.Ribbon`
- `TLazRibbonSkinManager.SkinFolder`
- `TLazRibbonSkinManager.ActiveSkinName`

## Rename Or Consolidation Candidates

These names work today, but should be reviewed before the 2.0 API freeze.

| Current API | Proposed 2.0 direction | Reason |
| --- | --- | --- |
| `TLazRibbonBackstageView.UseToolbarAppearance` and `UseSkinManager` | Consider replacing with `AppearanceSource`-only behavior | `AppearanceSource`, `LinkedToolbar`, and `SkinManager` already describe the same source decision more clearly. |
| `TLazRibbonSkinDefinition.Icon16FileName`, `Icon24FileName`, `Icon32FileName` | Keep for compatibility, document `Icon16Data`, `Icon24Data`, `Icon32Data` as preferred | Embedded icon data is the practical distribution model for shared skin files. |

## Accepted Legacy Names

These names look inherited from the original visual model, but are still useful
and should not be removed before 2.0:

- `TLazRibbonSkinManager.Appearance`: the skin manager owns the complete skin
  appearance model, so this name is appropriate even though `TLazRibbon` exposes
  the same visual model as `RibbonAppearance`.
- Internal `Appearance` properties on tabs, panes, item collections and popup
  helpers: these are not the main Object Inspector API and are still needed for
  rendering inheritance.
- `TLazRibbon.Style`: this remains a simple built-in style selector for projects
  that do not use a skin manager.

## Object Inspector Readiness

Before 2.0, every visible property should satisfy one of these conditions:

- It matches the Office-like public vocabulary.
- It is a normal Lazarus/LCL inherited property.
- It is a clearly documented compatibility property.
- It is intentionally hidden by the design-time package when a narrower
  component needs a simpler surface.

## Completed API Cleanup

- `TLazRibbon.ShowMinimizeRibbonButton`, `MinimizeRibbonHint` and
  `RestoreRibbonHint` are now the canonical Office-like names for the Ribbon
  minimize/restore control.
- `TLazRibbonBackstageView.BackButtonVisible` is now the single published
  Office-like property for the BackStage return button. The older
  `ShowCloseButton` duplicate was removed from the package API and resources.
- `TLazRibbonGalleryItem` now uses only `ItemWidth` and `ItemHeight` for generic
  gallery cells. `TLazRibbonSkinGalleryItem` publishes `IconWidth` and
  `IconHeight` for skin icons while hiding the inherited generic names at
  design time and keeping legacy streaming readers.
- `TLazRibbonSkinGalleryItem.SelectedSkinName` and
  `TLazRibbonSkinSelector.SelectedSkinName` are now the canonical Object
  Inspector properties for skin selection. `SelectedSkin` remains available as a
  public built-in-skin convenience and legacy `.lfm` reader.

## Recommended Next API Pass

The next code pass should start with skin identity icon fields:

1. Document `Icon16Data`, `Icon24Data` and `Icon32Data` as the preferred
   distribution fields for shared `.skin` files.
2. Decide whether `Icon16FileName`, `Icon24FileName` and `Icon32FileName`
   should remain visible compatibility properties or be hidden before 2.0.
3. Ensure the Skin Editor UI leads users toward embedded icon data while still
   allowing files to be chosen for import.
4. Extend `tools/check_project_consistency.ps1` if old file-name fields are
   hidden from the Object Inspector.

This keeps distributed skins self-contained and avoids implying that extra icon
files must travel beside the `.skin` file.
