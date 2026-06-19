# LazRibbon 2.0 Roadmap

The 2.0 release should mark the first API-freeze line for the package. The
current 1.2.x series remains the stabilization and pre-freeze cleanup line.

## Release Goal

Deliver a Lazarus 4.8 package that can be installed from a public repository and
used to build Office-like applications with:

- Ribbon tabs, panes and command items;
- Office Application Button and BackStage;
- Quick Access Toolbar;
- Ribbon-aware form chrome;
- skin manager and standalone Skin Editor;
- design-time creation/editing tools;
- examples and installation documentation.

## Pre-2.0 Gates

The following gates must be complete before `2.0.0`:

- Public API names reviewed against `docs/quality/PUBLIC_API_AUDIT_2_0.md`.
- Component property roles reviewed against
  `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md`.
- Object Inspector redundancies reviewed against
  `docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md`.
- Generated Object Inspector surface snapshot kept current in
  `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md`.
- Remaining confusing or duplicate Object Inspector names either renamed, hidden
  or documented as compatibility-only.
- `tools/check_project_consistency.ps1` rejects known pre-2.0 legacy streaming
  names.
- `README.md`, `INSTALL.md` and demos describe the final 2.0 names.
- `LazRibbonRuntime.lpk` and `LazRibbonDesign.lpk` compile with Lazarus 4.8.
- `tools/LazRibbonSkinEditor/LazRibbonSkinEditor.lpi` compiles and opens.
- `demos/ribbon_form/project1.lpi` compiles and demonstrates the main workflow.
- `tools/build_all_projects.ps1 -CleanArtifacts` compiles the packages, Skin
  Editor and every demo listed in `docs/release/DEMO_VALIDATION_MATRIX.md`.
- Release ZIP audit passes with no generated build artifacts.

## Planned Work

### 1. API Freeze Pass

- Keep the Ribbon minimize button properties on the Office-like
  `ShowMinimizeRibbonButton`, `MinimizeRibbonHint` and `RestoreRibbonHint`
  names.
- Keep the BackStage return button on the Office-like `BackButtonVisible` name.
- Keep generic gallery cell metrics on `ItemWidth`/`ItemHeight` and skin-gallery
  icon metrics on `IconWidth`/`IconHeight`.
- Keep `SelectedSkinName` as the canonical skin selection property for visual
  skin selector controls, including external skins.
- Keep `TLazRibbonSkinManager.ActiveSkinName` as the canonical active-skin
  selector for built-in and external skins; `ActiveSkin` remains compatibility
  only for built-in-skin source code and legacy `.lfm` files.
- Keep skin identity icons on embedded `Icon16Data`, `Icon24Data` and
  `Icon32Data`; file-name fields remain public import/source compatibility only.
- Keep BackStage visual-source selection on `AppearanceSource`, with
  `LinkedToolbar` and `SkinManager` as the source objects for new projects.
- Keep BackStage component composition on `TLazRibbon.BackstageView`; the
  Application Button configures the button/menu behavior itself.
- Keep structural pane items, such as `TLazRibbonSeparator`, free of command and
  ScreenTip noise in the design-time surface.
- Keep BackStage page components as content containers. Navigation entries,
  commands and separators belong to the clearer
  `TLazRibbonBackstageView.Buttons` collection; page-level command properties
  are source compatibility only, not published Object Inspector API.
- Keep hosted controls on `TLazRibbonControlHostItem.Control`; `Caption` is the
  fallback placeholder text and legacy `ControlName`/`ControlClassName`
  metadata stays compatibility-only.
- Keep the component property matrix synchronized with new published properties
  so the Object Inspector remains easy to understand.
- Regenerate `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` after any
  package-facing `published` property changes.

### 2. Skin Editor Finish Pass

- Keep the simple palette flow and detailed `Appearance` flow visually distinct.
- Make validation messages more actionable before saving.
- Keep the live Ribbon preview as the primary proof that pane captions, Dialog
  Launchers and minimize/restore behavior work.
- Ensure exported `.skin` files are self-contained when icons are selected.
- Keep icon file pickers as import helpers while saving embedded icon data as
  the distributable skin identity.

### 3. Documentation And Demos

- Keep the short first Ribbon form example in `README.md` synchronized with the
  final Object Inspector names.
- Keep the component property matrix as the quick Object Inspector guide for
  developers.
- Keep `docs/release/DEMO_VALIDATION_MATRIX.md` synchronized with the demos and
  release validation script.
- Add screenshots for the main Ribbon, BackStage, Skin Gallery and Skin Editor.
- Review docs for outdated names after the API freeze pass.
- Prepare public release notes for the first `2.0.0-rc1`.

### 4. Release Candidate

- Publish `2.0.0-rc1` after the API freeze pass.
- Run the Lazarus 4.8 validation checklist from a clean checkout.
- Install the design-time package in Lazarus and verify component palette icons.
- Compile and run the Skin Editor and the main Ribbon form demo.
- Generate a source ZIP and verify its SHA256.

## Definition Of Done For 2.0.0

`2.0.0` is ready when the public Object Inspector surface is stable, the core
demos run without manual fixes, the Skin Editor can create and save a usable
skin, and a developer can install the package from GitHub using only the
repository documentation.
