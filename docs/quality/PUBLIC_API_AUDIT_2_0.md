# LazRibbon Public API Audit for 2.0

This audit records the current public Object Inspector/API surface that should be
stabilized before the 2.0 release. It focuses on names visible to Lazarus
developers, not on private implementation details.

The generated direct `published` property snapshot lives in
`docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` and is produced by
`tools/export_object_inspector_snapshot.ps1`. The consistency audit regenerates
that snapshot and fails when it drifts from source.

The generated repeated-name audit lives in
`docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` and is produced by
`tools/export_object_inspector_redundancy_audit.ps1`. It classifies shared
published property names so normal Lazarus vocabulary and command vocabulary are
not confused with real API redundancy.

The generated design-time hide audit lives in
`docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` and is produced by
`tools/export_design_time_property_skip_audit.ps1`. It records the
`RegisterPropertyToSkip` and nil property-editor rules that keep obsolete,
compatibility-only or role-inappropriate properties out of the Object Inspector.

The generated freeze readiness report lives in
`docs/release/API_FREEZE_READINESS_2_0.md` and is produced by
`tools/export_2_0_api_freeze_readiness.ps1`. It summarizes package metadata,
API audit coverage, generated Object Inspector reports and release workflow
gates before the first 2.0 release candidate.

The clean checkout validation guide lives in
`docs/release/CLEAN_CHECKOUT_VALIDATION.md` and is executed by
`tools/verify_clean_checkout.ps1`. It proves the package can be built from an
extracted release-style source tree rather than from the developer working
directory.

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
- `TLazRibbonControlHostItem.Control`
- `TLazRibbonGalleryItem.ItemWidth`
- `TLazRibbonGalleryItem.ItemHeight`
- `TLazRibbonSkinGalleryItem.IconWidth`
- `TLazRibbonSkinGalleryItem.IconHeight`
- `TLazRibbonSkinGalleryItem.SelectedSkinName`
- `TLazRibbonSkinSelector.SelectedSkinName`
- `TLazRibbonSkinDefinition.Icon16Data`
- `TLazRibbonSkinDefinition.Icon24Data`
- `TLazRibbonSkinDefinition.Icon32Data`
- `TLazRibbonBackstageView.AppearanceSource`
- `TLazRibbonBackstageView.LinkedToolbar`
- `TLazRibbonBackstageView.SkinManager`
- `TLazRibbonBackstageView.OverlayMode`
- `TLazRibbonBackstageView.BackButtonVisible`
- `TLazRibbonBackstageView.NavigationStyle`
- `TLazRibbonBackstageView.PageButtonVisualMode`
- `TLazRibbonBackstageRecentList.AppearanceSource`
- `TLazRibbonBackstageRecentList.SkinManager`
- `TLazRibbonSkinManager.General`
- `TLazRibbonSkinManager.Accent`
- `TLazRibbonSkinManager.Backstage`
- `TLazRibbonSkinManager.RecentList`
- `TLazRibbonSkinManager.Ribbon`
- `TLazRibbonSkinManager.SkinFolder`
- `TLazRibbonSkinManager.ActiveSkinName`

## Rename Or Consolidation Candidates

No active duplicate public Object Inspector names remain from the current audit
pass. The companion `COMPONENT_PROPERTY_MATRIX_2_0.md` document records the
expected role of each visible component group so future properties can be judged
against the same model.

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
- `TLazRibbonSkinManager.ActiveSkinName` is now the canonical Object Inspector
  property for the active skin. `ActiveSkin` remains available as a public
  built-in-skin convenience and legacy `.lfm` reader.
- `TLazRibbonSkinDefinition.Icon16Data`, `Icon24Data` and `Icon32Data` are now
  the canonical published skin identity icon fields. `Icon16FileName`,
  `Icon24FileName` and `Icon32FileName` remain public for editor import/source
  compatibility, and new `.skin` XML writes those legacy tags only when embedded
  icon data is absent.
- `TLazRibbonBackstageView` and `TLazRibbonBackstageRecentList` now use
  `AppearanceSource` as the single published decision for internal,
  linked-toolbar or SkinManager visuals. The old `UseToolbarAppearance` and
  `UseSkinManager` switches were removed from package API/resources.
- `TLazRibbon.BackstageView` is now the canonical published BackStage
  composition property. `TLazRibbonApplicationButton.BackstageView` remains only
  as a public source-compatibility delegate and is no longer streamed by package
  resources.
- `TLazRibbonSeparator` is treated as a structural pane item at design time; the
  design package hides inherited command and ScreenTip properties such as
  `Action`, `Caption`, `Enabled`, `Hint`, `KeyTip`, `ShowScreenTip`,
  `ScreenTip*` and `OnClick`.
- `TLazRibbonBackstagePage` is treated as a BackStage content container at
  design time and at runtime RTTI level; page-level command/navigation
  properties `Action`, `Command`, `CloseBackstageOnClick`, `ItemKind` and
  `OnExecute` are public source-level compatibility only and are no longer
  published. `TLazRibbonBackstageView.Buttons` is the preferred public model for
  BackStage page links, commands and separators.
- `docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md` records the current
  duplicate/redundant property decisions for visible palette components and
  design-time item classes.
- `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` classifies repeated
  published property names and currently reports no unclassified redundancies.
- `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` records the current
  design-time property hiding rules for compatibility-only, obsolete and
  role-inappropriate inherited properties.
- `docs/release/API_FREEZE_READINESS_2_0.md` consolidates the API freeze gates
  and currently reports no generated/documented gate needing review.
- `TLazRibbonControlHostItem.Control` is the canonical hosted-control reference
  for new forms. `Caption` is the fallback placeholder text when no control is
  assigned. Legacy `ControlName` and `ControlClassName` strings are hidden from
  the Object Inspector, retained publicly for source compatibility, and accepted
  through legacy `.lfm` readers.

## Recommended Next API Pass

The next API pass should move from visible duplicate cleanup to release-candidate
readiness:

1. Keep `OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` regenerated whenever a
   package-facing `published` property changes.
2. Keep `OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` regenerated after the
   snapshot and require every repeated published name to be classified.
3. Keep `DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` regenerated when design-time
   property hiding changes.
4. Keep `API_FREEZE_READINESS_2_0.md` regenerated when API freeze gates,
   generated audits or release validation docs change.
5. Keep `README.md`, `INSTALL.md` and the first Ribbon form example synchronized
   with the final Object Inspector names.
6. Keep `COMPONENT_PROPERTY_MATRIX_2_0.md` synchronized with any new published
   component property.
7. Keep `docs/release/DEMO_VALIDATION_MATRIX.md` synchronized with the demos
   and `tools/build_all_projects.ps1`.
8. Prepare screenshot guidance/assets for the main Ribbon, BackStage, Skin
   Gallery and Skin Editor.
9. Run `tools/verify_release_candidate.ps1` before tagging
   `2.0.0-rc2`.

This keeps the public API surface quiet while shifting the remaining work toward
shareable documentation and release proof.
