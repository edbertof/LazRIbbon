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
- `TLazRibbonBackstageView.OverlayMode`
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
| `TLazRibbon.ShowCollapseButton` | Prefer `ShowMinimizeRibbonButton` | Office UI calls this command "Minimize the Ribbon"; "collapse" describes implementation, not the user-facing action. |
| `TLazRibbon.CollapseRibbonHint` | Prefer `MinimizeRibbonHint` | Aligns with `RibbonMinimized` and the Office command name. |
| `TLazRibbon.ExpandRibbonHint` | Prefer `RestoreRibbonHint` | "Restore Ribbon" pairs better with "Minimize Ribbon" and avoids the vague "expand". |
| `TLazRibbonBackstageView.BackButtonVisible` and `ShowCloseButton` | Keep one canonical property, preferably `BackButtonVisible` | Both map to the same field. In Office-style BackStage, the visible element behaves as a back button rather than a close button. |
| `TLazRibbonBackstageView.UseToolbarAppearance` and `UseSkinManager` | Consider replacing with `AppearanceSource`-only behavior | `AppearanceSource`, `LinkedToolbar`, and `SkinManager` already describe the same source decision more clearly. |
| `TLazRibbonGalleryItem.ItemWidth`/`ItemHeight` and `IconWidth`/`IconHeight` | Keep `ItemWidth`/`ItemHeight` canonical unless icon drawing becomes independent | The current aliases point to the same fields, which is confusing in the Object Inspector. |
| `TLazRibbonSkinGalleryItem.SelectedSkin` | Keep as built-in convenience, but document `SelectedSkinName` as canonical | External skins cannot be represented by the built-in enum. |
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

## Recommended Next API Pass

The next code pass should start with the low-risk Ribbon minimize naming cleanup:

1. Add Office-like property names for the minimize button and hints.
2. Migrate package `.lfm` files to the new names.
3. Remove or hide the old names before 2.0, because the package is still
   pre-adoption in this project.
4. Extend `tools/check_project_consistency.ps1` to reject the old streamed names.

The BackStage duplicate `BackButtonVisible`/`ShowCloseButton` should be the
second pass, because it affects fewer demos but can confuse developers in the
Object Inspector.
