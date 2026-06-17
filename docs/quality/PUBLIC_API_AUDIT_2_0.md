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
- `TLazRibbonSkinDefinition.Icon16Data`
- `TLazRibbonSkinDefinition.Icon24Data`
- `TLazRibbonSkinDefinition.Icon32Data`
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
- `TLazRibbonSkinDefinition.Icon16Data`, `Icon24Data` and `Icon32Data` are now
  the canonical published skin identity icon fields. `Icon16FileName`,
  `Icon24FileName` and `Icon32FileName` remain public for editor import/source
  compatibility, and new `.skin` XML writes those legacy tags only when embedded
  icon data is absent.

## Recommended Next API Pass

The next code pass should review BackStage appearance-source configuration:

1. Decide whether `TLazRibbonBackstageView.UseToolbarAppearance` and
   `UseSkinManager` should remain public compatibility switches or give way to
   `AppearanceSource`.
2. Keep `AppearanceSource`, `LinkedToolbar` and `SkinManager` as the readable
   Office-like configuration path for new projects.
3. Ensure existing demos and the Skin Editor stream the final BackStage
   appearance-source names.
4. Extend `tools/check_project_consistency.ps1` if legacy BackStage
   appearance-source properties are hidden or removed.

This keeps the BackStage visual-source API from exposing multiple switches for
the same decision before the 2.0 Object Inspector surface is frozen.
