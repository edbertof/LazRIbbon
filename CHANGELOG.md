## Unreleased

- Adds `docs/manual/LAZRIBBON_MANUAL.md`, a first installation and component usage manual covering the package component model, published properties and events.

## 2.0.0-rc1 - API freeze candidate

- Promotes runtime and design-time package metadata to 2.0.0 for the first 2.0 release candidate.
- Uses `2.0.0-rc1` as the public release/ZIP/tag label through the `-ReleaseVersion` workflow introduced in 1.2.42.
- Refreshes the 2.0 API freeze readiness report against the RC package metadata.
- Updates release, install and publishing documentation so the RC command path is the primary validation flow.

## 1.2.42 - Release label support

- Adds `-ReleaseVersion` support to the release ZIP, clean checkout and release-candidate preflight scripts, separating numeric Lazarus package metadata from public ZIP/tag labels such as `2.0.0-rc1`.
- Adds `docs/release/RELEASE_2_0_0_RC1.md` as the draft release notes for the first 2.0 release candidate.
- Refreshes `docs/release/RELEASE_CANDIDATE_PREP.md` for the current 2.0 RC workflow and marks older RC notes as historical.
- Updates the generated 2.0 API freeze readiness report so the 2.0 RC1 notes draft is tracked as a ready gate.
- Updates runtime and design-time package versions to 1.2.42.

## 1.2.41 - Public screenshot assets

- Adds `tools/capture_release_screenshots.ps1` to build the screenshot targets, open the GUI applications, capture release PNGs and clean generated artifacts.
- Adds public screenshots under `docs/assets/screenshots/` for the Showcase, BackStage, Skin Gallery and Skin Editor.
- Updates `README.md` with a screenshot section for GitHub-facing project presentation.
- Updates the generated 2.0 API freeze readiness report so screenshot assets are a ready gate when the PNGs and capture script are present.
- Updates runtime and design-time package versions to 1.2.41.

## 1.2.40 - Clean checkout validation

- Adds `tools/verify_clean_checkout.ps1` to create a release-style source ZIP, extract it into a temporary clean tree, run consistency checks, register the local packages in a temporary Lazarus profile and build the package/tool/demo matrix there.
- Adds `docs/release/CLEAN_CHECKOUT_VALIDATION.md` to document the clean source tree gate for the 2.0 release path.
- Extends `tools/verify_release_candidate.ps1` with a clean checkout installation validation step, a temporary Lazarus profile for the main build matrix and `-SkipCleanCheckout` for fast local iteration.
- Updates the generated 2.0 API freeze readiness report so clean checkout validation is tracked as a ready gate when the script and guide are present.
- Updates runtime and design-time package versions to 1.2.40.

## 1.2.39 - 2.0 API freeze readiness report

- Adds `tools/export_2_0_api_freeze_readiness.ps1` to generate a compact readiness view from the current API, Object Inspector and release validation documents.
- Adds `docs/release/API_FREEZE_READINESS_2_0.md`, currently reporting 10 ready gates, 2 manual release-candidate validation gates and 0 gates needing review.
- Extends the consistency audit to regenerate and compare the 2.0 API freeze readiness report.
- Updates README, INSTALL, roadmap, release notes and publishing guidance to make the readiness report part of the 2.0 release path.
- Updates runtime and design-time package versions to 1.2.39.

## 1.2.38 - Design-time property skip audit

- Adds `tools/export_design_time_property_skip_audit.ps1` to generate a report from `LazRibbon_Register.pas` design-time Object Inspector hiding rules.
- Adds `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md`, currently documenting 29 `RegisterPropertyToSkip` rules, 4 nil property-editor hide rules and 8 affected component classes.
- Normalizes the checkbox `GroupBehaviour` property-skip spelling to match the radio button rule.
- Extends the consistency audit to regenerate and compare the design-time skip audit so hidden compatibility/obsolete properties stay documented.
- Updates runtime and design-time package versions to 1.2.38.

## 1.2.37 - Object Inspector redundancy audit

- Adds `tools/export_object_inspector_redundancy_audit.ps1` to classify repeated direct published property names from the generated Object Inspector snapshot.
- Adds `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md`, currently reviewing 48 repeated property names with no unclassified redundancy.
- Extends the consistency audit to regenerate and compare the redundancy audit so new repeated Object Inspector names must be justified before 2.0.
- Updates README, INSTALL, the 2.0 roadmap and API/property docs to make the redundancy audit part of the 2.0 API-freeze workflow.
- Updates runtime and design-time package versions to 1.2.37.

## 1.2.36 - Release candidate preflight workflow

- Adds `tools/verify_release_candidate.ps1` as a single release-candidate preflight that runs consistency audits, the full build matrix and the release ZIP audit.
- Documents the preflight workflow in `README.md`, `INSTALL.md`, the 2.0 roadmap and release audit notes.
- Extends the consistency audit to require the preflight script so the 2.0 release path stays explicit.
- Updates runtime and design-time package versions to 1.2.36.

## 1.2.35 - Object Inspector surface snapshot

- Adds `tools/export_object_inspector_snapshot.ps1` to extract direct `published` properties from the main package-facing classes.
- Adds `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` as the current generated snapshot of the Object Inspector/runtime RTTI surface.
- Extends the consistency audit to regenerate and compare the snapshot so published-property changes cannot silently drift from the 2.0 docs.
- Updates the 2.0 roadmap and API/property audits to make the snapshot part of the pre-freeze workflow.
- Updates runtime and design-time package versions to 1.2.35.

## 1.2.34 - Accelerated 2.0 validation workflow

- Adds `tools/build_all_projects.ps1` to compile runtime, design-time, Skin Editor and every demo in one release-check command.
- Adds `docs/release/DEMO_VALIDATION_MATRIX.md` so each demo has a clear validation purpose before the 2.0 release candidate.
- Adds a compact first Ribbon form guide to `README.md`.
- Updates installation docs to run the full build matrix before creating a release ZIP.
- Extends the consistency audit to require the full-build script and demo validation matrix.
- Updates runtime and design-time package versions to 1.2.34.

## 1.2.33 - ControlHost direct control API

- Adds `TLazRibbonControlHostItem.Control` as the canonical published hosted-control reference for new forms.
- Keeps `Caption` as fallback placeholder text when no hosted control is assigned.
- Keeps legacy `ControlName` and `ControlClassName` public/source compatibility and legacy `.lfm` readers, but hidden from the Object Inspector.
- Hides hosted controls from inactive tabs by clearing inactive tab item rectangles during Ribbon metric validation.
- Updates the 2.0 component matrix, composition model, Object Inspector audit and consistency checks for the direct hosted-control API.
- Updates runtime and design-time package versions to 1.2.33.

## 1.2.32 - SkinManager ActiveSkinName cleanup

- Makes `TLazRibbonSkinManager.ActiveSkinName` the only published Object Inspector property for choosing the active skin.
- Keeps `TLazRibbonSkinManager.ActiveSkin` as a public built-in-skin compatibility shortcut and adds a legacy `.lfm` reader for old `ActiveSkin = sbs...` resources.
- Updates demos and Skin Editor code to use the name-based skin API for built-in and external skins.
- Extends the consistency audit to reject new `TLazRibbonSkinManager.ActiveSkin` streaming and require the compatibility reader.
- Updates runtime and design-time package versions to 1.2.32.

## 1.2.31 - BackStage page Object Inspector cleanup

- Moves `TLazRibbonBackstagePage` command/navigation properties out of the published Object Inspector surface while keeping them public for source-level compatibility.
- Keeps `TLazRibbonBackstageView.Buttons` as the canonical model for BackStage navigation entries, commands and separators.
- Adds `docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md` to track redundant/repeated property decisions for the 2.0 freeze.
- Extends the consistency audit to reject a published BackStage page command surface and require the new Object Inspector audit.
- Updates runtime and design-time package versions to 1.2.31.

## 1.2.30 - Component property matrix

- Adds `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md` as the practical Object Inspector map for component roles, canonical properties and compatibility-only names.
- Documents intentional similar property pairs, including QAT allow/show pairs and gallery item/icon sizing.
- Links the public API audit and component composition model to the property matrix for the 2.0 freeze.
- Extends the consistency audit to require the property matrix and key canonical API names.
- Updates runtime and design-time package versions to 1.2.30.

## 1.2.29 - ControlHost metadata cleanup

- Keeps `TLazRibbonControlHostItem.Caption` as the visible placeholder text for hosted-control items.
- Moves legacy `ControlName` and `ControlClassName` metadata out of the Object Inspector surface while keeping them public for source compatibility.
- Adds legacy `.lfm` readers for `ControlName` and `ControlClassName` so old forms can still open and migrate to `Caption`.
- Extends the consistency audit to reject new `ControlName` and `ControlClassName` streaming on `TLazRibbonControlHostItem`.
- Updates the 2.0 component composition model, public API audit, roadmap and release notes.
- Updates runtime and design-time package versions to 1.2.29.

## 1.2.28 - BackStage page composition cleanup

- Treats `TLazRibbonBackstagePage` as a BackStage content container in the design-time API.
- Hides page-level command/navigation properties `Action`, `Command`, `CloseBackstageOnClick`, `ItemKind` and `OnExecute` from the Object Inspector.
- Keeps `TLazRibbonBackstageView.Buttons` as the explicit public model for BackStage page links, commands and separators.
- Extends the consistency audit to reject command/navigation streaming on `TLazRibbonBackstagePage` resources.
- Updates the 2.0 composition model, public API audit, roadmap and release notes.
- Updates runtime and design-time package versions to 1.2.28.

## 1.2.27 - Component composition API audit

- Adds a 2.0 component composition model that documents how developers should connect Ribbon, BackStage, QAT, panes, items and skin components.
- Makes `TLazRibbon.BackstageView` the canonical published BackStage composition property and moves `ApplicationButton.BackstageView` out of the Object Inspector surface.
- Updates package demos and the Skin Editor to stream/use `TLazRibbon.BackstageView` instead of `ApplicationButton.BackstageView`.
- Hides inherited command and ScreenTip properties from `TLazRibbonSeparator` at design time, keeping separators as structural pane items.
- Extends the consistency audit to protect the component composition model, BackStage composition streaming and separator design-time cleanup.
- Updates runtime and design-time package versions to 1.2.27.

## 1.2.26 - BackStage AppearanceSource consolidation

- Removes the duplicated BackStage appearance-source booleans `UseToolbarAppearance` and `UseSkinManager` from the package API and resources.
- Keeps `AppearanceSource`, `LinkedToolbar` and `SkinManager` as the single readable configuration path for BackStage visual source decisions.
- Preserves automatic `AppearanceSource = asSkinManager` selection when a `SkinManager` is assigned.
- Updates the 2.0 public API audit and roadmap to mark the BackStage appearance-source cleanup as complete.
- Extends the consistency audit to reject legacy BackStage appearance-source API names and streaming.
- Updates runtime and design-time package versions to 1.2.26.

## 1.2.25 - Skin identity embedded icon API

- Keeps `Icon16Data`, `Icon24Data` and `Icon32Data` as the canonical published skin identity icon fields.
- Moves `Icon16FileName`, `Icon24FileName` and `Icon32FileName` out of the published RTTI surface while keeping them public for editor import/source compatibility.
- Changes new `.skin` XML output to write legacy `Icon*FileName` tags only when the matching embedded `Icon*Data` field is empty.
- Bumps saved skin XML `FormatVersion` and root `Version` to 6 for the self-contained icon identity format.
- Updates the 2.0 public API audit and roadmap to mark the embedded icon identity pass as complete.
- Extends the consistency audit to protect the embedded icon API and XML-writing behavior.
- Updates runtime and design-time package versions to 1.2.25.

## 1.2.24 - Skin selection API consolidation

- Keeps `SelectedSkinName` as the canonical Object Inspector property for `TLazRibbonSkinGalleryItem` and `TLazRibbonSkinSelector`.
- Moves `SelectedSkin` out of the published design-time surface while keeping it as a public built-in-skin convenience property.
- Adds legacy `SelectedSkin` streaming readers so old `.lfm` files can still be opened and saved with `SelectedSkinName`.
- Updates the design-time registration to hide/de-emphasize `SelectedSkin` on skin selection controls.
- Updates the 2.0 public API audit and roadmap to mark the skin selection naming pass as complete.
- Extends the consistency audit to reject `SelectedSkin` streaming in package resources.
- Updates runtime and design-time package versions to 1.2.24.

## 1.2.23 - Gallery size API consolidation

- Keeps `TLazRibbonGalleryItem.ItemWidth` and `ItemHeight` as the canonical generic gallery cell-size properties.
- Moves `IconWidth` and `IconHeight` to `TLazRibbonSkinGalleryItem`, where they describe the visible skin icon/swatch size.
- Keeps legacy `IconWidth`/`IconHeight` streaming readers for exact generic gallery items.
- Migrates package `.lfm` resources so SkinGallery items stream `IconWidth`/`IconHeight` and no longer stream obsolete `ShowCaptions`.
- Updates the 2.0 public API audit and roadmap to mark the gallery size naming pass as complete.
- Extends the consistency audit to reject mixed generic-gallery and skin-gallery size names in package resources.
- Updates runtime and design-time package versions to 1.2.23.

## 1.2.22 - BackStage BackButtonVisible API consolidation

- Removes the duplicated published `TLazRibbonBackstageView.ShowCloseButton` API.
- Keeps `TLazRibbonBackstageView.BackButtonVisible` as the single Office-like property for the BackStage return button.
- Migrates package `.lfm` resources to the canonical BackStage back-button property name.
- Updates the 2.0 public API audit and roadmap to mark the BackStage naming pass as complete.
- Extends the consistency audit to reject the old `ShowCloseButton` BackStage API name in package sources/resources.
- Updates runtime and design-time package versions to 1.2.22.

## 1.2.21 - Office-like Ribbon minimize API names

- Renames the public `TLazRibbon` minimize button API to Office-like names: `ShowMinimizeRibbonButton`, `MinimizeRibbonHint` and `RestoreRibbonHint`.
- Migrates package demos and the standalone Skin Editor `.lfm` resources to the new streamed property names.
- Updates the design-time quick creation helper to use `ShowMinimizeRibbonButton`.
- Updates the 2.0 public API audit and roadmap to mark the Ribbon minimize naming pass as complete.
- Extends the consistency audit to reject the old `ShowCollapseButton`, `CollapseRibbonHint` and `ExpandRibbonHint` names in package sources/resources.
- Updates runtime and design-time package versions to 1.2.21.

## 1.2.20 - LazRibbon 2.0 API audit and roadmap

- Adds `docs/quality/PUBLIC_API_AUDIT_2_0.md` with the current public Object Inspector/API review for the 2.0 freeze.
- Adds `docs/release/ROADMAP_2_0.md` with the release gates, planned work and definition of done for LazRibbon 2.0.
- Identifies the first post-audit API cleanup candidates, including Office-like Ribbon minimize naming and BackStage back/close button consolidation.
- Updates the consistency audit to require the 2.0 planning documents and key API decisions.
- Updates runtime and design-time package versions to 1.2.20.

## 1.2.19 - Skin Editor Appearance mode detection

- Improves `LazRibbonSkinEditor` new/open skin workflow so the editor detects whether the stored `Appearance` still matches the simple palette.
- Changes `Arquivo > Nova skin pela base` to avoid blindly marking every copied skin as manually edited; palette-derived skins remain in palette-driven mode.
- Changes skin file opening to detect the same mode from file contents, preserving detailed `Appearance` only when it really differs from the palette-derived model.
- Updates the consistency audit to protect the Skin Editor Appearance mode detection.
- Updates runtime and design-time package versions to 1.2.19.

## 1.2.18 - Skin Editor minimized preview height fix

- Fixes the standalone `LazRibbonSkinEditor` live preview so the collapse/expand button changes the preview panel height.
- Changes the Skin Editor `PreviewToolbar` to `Align = alTop`, preventing `pnlLivePreview` from stretching a minimized Ribbon back to the expanded preview height.
- Hooks `PreviewToolbar.OnRibbonMinimizedChanged` so `pnlLivePreview` follows the minimized/restored Ribbon height immediately.
- Updates the consistency audit to protect the Skin Editor preview minimize behavior.
- Updates runtime and design-time package versions to 1.2.18.

## 1.2.17 - Ribbon minimize height fix

- Fixes the collapse/expand button so `TLazRibbon.RibbonMinimized` reduces the Ribbon control height instead of only hiding panes.
- Restores the previous expanded height when the Ribbon is expanded again, preserving taller hosted previews such as the Skin Editor preview.
- Normalizes minimized height after `.lfm` loading when a Ribbon is persisted with `RibbonMinimized = True`.
- Updates the consistency audit to protect the minimize-height behavior.
- Updates runtime and design-time package versions to 1.2.17.

## 1.2.16 - Office-style BackStage default

- Changes `TLazRibbonBackstageView.OverlayMode` default from `bomCoverRibbonArea` to `bomCoverClientArea`.
- Keeps `bomCoverRibbonArea` available for applications that explicitly want the older tab-preserving BackStage layout.
- Updates the project consistency audit to protect the new Office-style BackStage default.
- Updates runtime and design-time package versions to 1.2.16.

## 1.2.15 - SkinManager palette API consolidation

- Adds `TLazRibbonSkinManager.Accent` for the generic navigation/active/hot palette colors used by command, popup and highlight surfaces.
- Keeps `TLazRibbonSkinManager.Appearance` as the complete skin appearance model, but removes the published flat palette aliases from `TLazRibbonSkinManager`.
- Removes the `TLazRibbonSkinManager.Backstage.ActiveColor` and `Backstage.FrameColor` aliases; use `Backstage.SelectedColor` and `Backstage.SelectedFrameColor`.
- Migrates package demos and tools to stream `General.*`, `Accent.*` and `RecentList.*` palette groups.
- Updates the consistency audit to reject legacy flat SkinManager palette streaming.
- Updates runtime and design-time package versions to 1.2.15.

## 1.2.14 - ApplicationButton API consolidation

- Adds `TLazRibbon.ApplicationButton.Style` so the Application Button caption/dropdown style lives on the Office-like persistent subobject.
- Removes the published flattened `TLazRibbon` Application/Menu Button aliases: `ApplicationButtonCaption`, `ApplicationButtonVisible`, `ApplicationButtonMode`, `ApplicationMenu`, `OnApplicationButtonClick`, `MenuButtonCaption`, `MenuButtonDropdownMenu`, `MenuButtonStyle`, `ShowMenuButton` and `OnMenuButtonClick`.
- Migrates package demos, tools and design resources to stream and use `ApplicationButton.*`.
- Updates the consistency audit to reject legacy Application/Menu Button streaming in `TLazRibbon` resources.
- Updates runtime and design-time package versions to 1.2.14.

## 1.2.13 - TLazRibbon Appearance alias removal

- Removes the published `TLazRibbon.Appearance` legacy alias from the runtime component API.
- Keeps `TLazRibbon.RibbonAppearance` as the only public Object Inspector property for Ribbon visual styling.
- Keeps `TLazRibbonSkinManager.Appearance` unchanged, because the skin manager owns and streams a skin appearance model.
- Updates runtime and design-time package versions to 1.2.13.

## 1.2.12 - SkinManager LFM streaming fix

- Restores `TLazRibbonSkinManager.Appearance.*` streaming in the standalone Skin Editor and `demos/ribbon_form`, fixing the 1.2.11 `Unknown property: "RibbonAppearance"` load error.
- Keeps `TLazRibbon.RibbonAppearance.*` streaming for actual Ribbon controls.
- Tightens the project consistency audit so it rejects `RibbonAppearance.*` on non-`TLazRibbon` resources and legacy `Appearance.*` on `TLazRibbon`.
- Updates runtime and design-time package versions to 1.2.12.

## 1.2.11 - LFM RibbonAppearance migration

- Migrates the package's own Lazarus form resources from the legacy `Appearance.*` streaming name to `RibbonAppearance.*`.
- Updates demos, the standalone Skin Editor and the design-time Appearance editor form resource so project examples exercise the Office-like property name.
- Adds a project consistency audit that rejects new `.lfm` files containing legacy `Appearance.*` TLazRibbon streaming lines.
- Updates runtime and design-time package versions to 1.2.11.

## 1.2.10 - Compact Skin Editor layout

- Reduces the standalone `LazRibbonSkinEditor` initial window size from 1180x820 to 1060x700.
- Tightens the Identity, Ribbon Colors, BackStage, Validation and Advanced editor layouts so controls sit closer together without changing the live Ribbon preview height.
- Keeps pane captions and Dialog Launcher validation visible in the Skin Editor preview while using a smaller editor surface.
- Updates runtime and design-time package versions to 1.2.10.

## 1.2.9 - RibbonAppearance design-time API

- Adds `TLazRibbon.RibbonAppearance` as the official published Object Inspector property for the Ribbon visual model.
- Keeps `TLazRibbon.Appearance` as a legacy alias for older `.lfm` files, but hides it from the Lazarus designer and prevents new forms from streaming the old name.
- Registers the full visual appearance editor on `RibbonAppearance`.
- Updates runtime and design-time package versions to 1.2.9.

## 1.2.8 - Design-time pane refresh fix

- Improves design-time refresh for `TLazRibbonTab`, `TLazRibbonPane` and Ribbon items when captions, structure or Appearance values are edited in the Lazarus IDE.
- Registers a Ribbon-aware `Caption` property editor for tabs, panes, buttons and extended Ribbon items so Object Inspector changes force the parent Ribbon to repaint.
- Updates the contents editor to call `ForceRepaint` after adding, removing, moving or renaming tabs, panes and items.
- Notifies the parent Ribbon after tabs and panes finish loading in design-time mode, so pane captions and Dialog Launchers appear when a form is opened in the designer.
- Changes the release ZIP default output folder to `D:\Ribbon4Lazarus`.
- Updates runtime and design-time package versions to 1.2.8.

## 1.2.7 - Pane caption buffer height fix

- Fixes the remaining Skin Editor live preview case where pane captions were still clipped when the Ribbon control was taller than the calculated default toolbar height.
- Sizes the Ribbon back buffer to the actual control height when it is larger than `CalcToolbarHeight`, so pane layout and painting use the same vertical range.
- Clips active tab contents explicitly before drawing panes, preventing tab-header clipping state from leaking into pane rendering.
- Keeps the direct pane caption drawing and canvas-drawn Dialog Launcher glyph from 1.2.6/1.2.5.
- Updates runtime and design-time package versions to 1.2.7.

## 1.2.6 - Pane caption text rendering fix

- Replaces the pane caption `Canvas.TextRect` rendering path with the package's direct fit-width text routine.
- Keeps pane captions vertically centered inside the caption band while avoiding widgetset-dependent `TTextStyle.Layout` behavior.
- Fixes the Skin Editor live Ribbon preview case where pane captions were assigned but not painted.
- Updates runtime and design-time package versions to 1.2.6.

## 1.2.5 - Skin Editor pane preview height and launcher fix

- Increases and synchronizes the Skin Editor live Ribbon preview height so pane captions and the Dialog Launcher are not clipped.
- Enables `ShowDialogLauncher` on the Skin Editor `Estilos` pane and routes it to the complete Appearance editor on the Pane section.
- Replaces the font-dependent Dialog Launcher glyph with canvas-drawn Office-style lines.
- Keeps `TLazRibbon.Appearance` as the active low-level visual model used by internal styles and `TLazRibbonSkinManager` in this version; the later 1.2.9 build exposes the public Ribbon property as `RibbonAppearance`.
- Updates runtime and design-time package versions to 1.2.5.

## 1.2.4 - Pane captions paint order fix

- Fixes `TLazRibbonPane` drawing so pane captions are rendered above pane items.
- Centers pane captions inside the caption band and clips them with ellipsis when space is tight.
- Keeps the Dialog Launcher visible on top of the caption band.
- Fixes the Skin Editor live Ribbon preview when pane captions were not visible.
- Updates runtime and design-time package versions to 1.2.4.

## 1.2.3 - Skin Editor Appearance differences filter

- Marks Appearance inspector rows that differ from the focused base skin with `[alterado]`.
- Shows the corresponding base value inline for changed Appearance properties.
- Adds `Somente diferentes da base` to the Skin Editor complete Appearance inspector.
- Keeps the per-property restore workflow from 1.2.2 and the validation/comparison report from 1.2.1.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.3.

## 1.2.2 - Skin Editor restore Appearance property from base

- Adds `Restaurar da base` to the Skin Editor complete Appearance inspector.
- The action copies the selected published `Appearance` property from the focused base skin into the current skin.
- Supports colors, numbers, enums, booleans, sets, strings, characters and fonts through the same RTTI model used by the inspector.
- Refreshes the live preview, Appearance inspector and validation/comparison report after restoring or editing an Appearance property.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.2.

## 1.2.1 - Skin Editor base comparison report

- Extends the `LazRibbonSkinEditor` validation report with a comparison against the focused base skin.
- The comparison reports changes in identity metadata, icon file/data state, palette colors and published `Appearance` properties.
- Limits detailed difference output so heavily changed skins remain readable while still showing the full difference count.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.1.

## 1.2.0 - Skin Editor validation report

- Adds a validation report to the standalone `LazRibbonSkinEditor`.
- The report audits skin identity, optional metadata, icon file/data state, Appearance editing mode and key contrast pairs before saving.
- Adds design-time visible validation controls to the Skin Editor `.lfm` instead of creating them only at run time.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.0.

## 1.1.78 - Unified component palette icons

- Replaces the visible LazRibbon component palette icons with a unified Office-like visual family.
- Adds 24 px, 36 px and 48 px PNG variants for the palette components so Lazarus can use sharper icons at normal, 150% and 200% scales.
- Regenerates the component `.lrs` resources with `ClassName`, `ClassName_150` and `ClassName_200` entries.
- Updates `source/design/icons/make_res.bat` so future icon resource regeneration follows the current Lazarus high-DPI pattern.
- Keeps runtime UI behavior unchanged.
- Updates runtime and design-time package versions to 1.1.78.

## 1.1.77 - Office-like tab spacing controls

- Adds `TLazRibbon.TabCaptionHorizontalPadding`, `TabCaptionSpacing` and `MinTabCaptionWidth` so developers can tune Ribbon tab geometry from the Object Inspector.
- Changes the default tab caption metrics to a more Office-like layout: 10 px horizontal padding, 2 px spacing between tabs and 40 px minimum caption width.
- Applies the same metrics to contextual-tab header width calculations so contextual groups continue to size coherently.
- Keeps skin color/font behavior unchanged; tab geometry is now controlled by the new Ribbon properties rather than by skin selection.
- Updates runtime and design-time package versions to 1.1.77.

## 1.1.76 - Office-style Dialog Launcher rename

- Renames the `TLazRibbonPane` More Options API to Office-style Dialog Launcher naming: `ShowDialogLauncher`, `DialogLauncherStyle` and `OnDialogLauncherClick`.
- Renames the related runtime types and constants to `TLazRibbonDialogLauncherState`, `TLazRibbonDialogLauncherStyle` and `PaneDialogLauncherWidth`.
- Changes the default `DialogLauncherStyle` to `dlsArrow`, matching the Office Dialog Box Launcher glyph.
- Updates the active demos to use the new property, event and enum names.
- Intentionally removes the old More Options names; this build is not source-compatible with the earlier unfinished API.
- Updates runtime and design-time package versions to 1.1.76.

## 1.1.75 - Skin Editor Appearance inspector pass

- Expands the standalone `LazRibbonSkinEditor` Appearance inspector with an all-sections view for Tab, MenuButton, Pane, Element and Popup.
- Adds a filter box so Skin Editor users can search published Appearance properties by section, property name, type or current value.
- Shows the RTTI type beside each listed Appearance property.
- Extends direct property editing to cover floats, strings, characters and sets in addition to the existing colors, fonts, integers, booleans and enums.
- Keeps runtime UI behavior unchanged.
- Updates runtime and design-time package versions to 1.1.75.

## 1.1.74 - GitHub readiness pass

- Adds `CONTRIBUTING.md` with Lazarus 4.8 setup, change discipline and release hygiene expectations.
- Adds `docs/quality/VALIDATION_LAZARUS_4_8.md` as the active public validation checklist.
- Adds `docs/release/GITHUB_PUBLISHING.md` with repository, release-note and screenshot guidance.
- Adds `.github` issue and pull-request templates for public collaboration.
- Adds `docs/assets/screenshots/README.md` as the placeholder and guidance folder for public screenshots.
- Keeps runtime UI behavior unchanged.
- Updates runtime and design-time package versions to 1.1.74.

## 1.1.73 - Lazarus 4.8 validation baseline

- Moves the active documentation and validation baseline from Lazarus 4.6 to Lazarus 4.8.
- Keeps Lazarus 4.6 references in older historical release notes, but updates README, INSTALL, STATUS and the 1.1 roadmap to use Lazarus 4.8 as the current target.
- Preserves runtime UI behavior from 1.1.70 and the release-hygiene/palette-icon work from 1.1.72.
- Updates runtime and design-time package versions to 1.1.73.

## 1.1.72 - Release hygiene and palette icons pass

- Fixes `tools/check_project_consistency.ps1` so demo `.lpi` files are filtered correctly and `GraphicApplication Value="True"` is read from the XML attribute.
- Normalizes source-audit reporting for generated directories, generated files and local-environment path checks.
- Adds missing Lazarus palette icon resources for `TLazRibbonPopupMenu`, `TLazRibbonSkinManager` and `TLazRibbonSkinSelector`.
- Keeps runtime UI behavior unchanged; this release focuses on distribution quality and design-time polish.
- Updates runtime and design-time package versions to 1.1.72.

## 1.1.71 - Stability and regression audit pass

- Adds `tools/check_project_consistency.ps1` to audit package versions, GUI demo configuration, local-environment paths and generated artifacts before release packaging.
- Updates `tools/build_release_zip.ps1` so the consistency audit runs before the ZIP is created.
- Adds `docs/quality/STABILITY_REGRESSION_PASS_1_1_71.md` as the current stabilization checklist for packages, showcase runtime, KeyTips, contextual tabs, BackStage, skins and design-time verbs.
- Does not change runtime UI behavior; the 1.1.70 Backspace, resize, minimize/restore, contextual-tab and KeyTips behavior is preserved.
- Updates runtime and design-time package versions to 1.1.71.

## 1.1.70 - TLazRibbonForm KeyTips Backspace capture fix

- Adds a public `TLazRibbon.ProcessKeyTipsBackspace` wrapper so host controls can route Backspace into the KeyTip prefix editor safely.
- Makes `TLazRibbonForm` handle `VK_BACK` in `KeyDown` and `#8` in `KeyPress` while KeyTips are visible, because the focused client control can consume Backspace before `TLazRibbon` receives it.
- Enables `KeyPreview` at run time for `TLazRibbonForm` when it uses the custom title bar and has an associated Ribbon, so Backspace reaches the form-level KeyTips handler.
- Leaves the staged/multi-character KeyTips model, resize/minimize behavior, contextual tabs and design-time verbs unchanged.
- Updates runtime and design-time package versions to 1.1.70.

## 1.1.69 - KeyTips Backspace delivery hotfix

- Adds a shared `HandleKeyTipsBackspace` runtime helper so Backspace behavior is consistent across `KeyDown` and `KeyPress`.
- Handles `#8` in `KeyPress` for Lazarus/LCL widgetsets that deliver Backspace as a character event rather than only as `VK_BACK`.
- Keeps the staged, multi-character KeyTips model introduced in 1.1.66 and refined in 1.1.68.
- Updates runtime and design-time package versions to 1.1.69.

## 1.1.68 - KeyTips mouse cancellation and prefix backspace refinement

- Closes the KeyTips overlay on any mouse click inside `TLazRibbon` before the normal click action is processed.
- Closes the KeyTips overlay when the user clicks the `TLazRibbonForm` custom title bar, title-bar QAT or system buttons.
- Adds `Backspace` support while typing multi-character KeyTips, allowing the user to remove the last typed prefix character without leaving the KeyTips session.
- Keeps the 1.1.66 multi-character KeyTips and the 1.1.67 design-time validator hotfix unchanged.
- Updates runtime and design-time package versions to 1.1.68.

## 1.1.67 - Design-time System.Copy qualification hotfix

- Fixes LazRibbonDesign compilation under Lazarus/FPC where unqualified `Copy` inside `LazRibbon_Editor.pas` resolved to `TComponentEditor.Copy` instead of the string-copy routine.
- Qualifies the two prefix-ambiguity checks as `System.Copy(...)`.
- Keeps the 1.1.66 multi-character KeyTips runtime behavior unchanged.
- Updates runtime and design-time package versions to 1.1.67.

## 1.1.66 - Multi-character KeyTips support

- Adds incremental KeyTips prefix handling for root-level and command-level overlays.
- Supports multi-character KeyTips such as `EX`, `PR`, `RV` and `HP`, closer to the Office Ribbon model.
- Redraws matching KeyTips with the already typed prefix removed, so after typing `E` a command key `EX` is shown as `X`.
- Updates the design-time `Validate KeyTips` verb to report prefix ambiguities such as `B` versus `BA` inside the same overlay scope.
- Updates the showcase demo with multi-character command KeyTips.
- Updates runtime and design-time package versions to 1.1.66.

## 1.1.65 - KeyTips hide before command execution

- Refines the staged KeyTips flow so command-level KeyTips are closed before executing a command selected by KeyTip.
- This matches the Office behavior more closely: choosing a tab KeyTip is navigation and advances to the command stage, but choosing a command KeyTip ends the current KeyTip session.
- Prevents command KeyTips from remaining visible while a command handler, modal dialog or dropdown action runs.
- Keeps the 1.1.64 root-overlay/command-overlay split unchanged.
- Updates runtime and design-time package versions to 1.1.65.

## 1.1.64 - Staged Office-like KeyTips navigation

- Changes runtime KeyTips to a staged Office-like model: pressing Alt first shows only the root overlay (Application Button, visible tabs and QAT).
- Pressing a tab KeyTip selects that tab and advances the overlay to the selected tab's command KeyTips, instead of showing all command KeyTips immediately.
- QAT KeyTips hosted in `TLazRibbonForm` title bar now appear only in the root overlay, not during the active-tab command stage.
- Pressing Esc from the command stage returns to the root overlay; pressing Esc again hides KeyTips.
- Updates the design-time `Validate KeyTips` verb so command KeyTips are checked per tab as second-stage scopes, not against root-level QAT/tab/Application KeyTips.
- Updates runtime and design-time package versions to 1.1.64.

## 1.1.63 - Design-time KeyTip validation verb

- Adds a new `TLazRibbon` component-editor verb, `Validate KeyTips`, for design-time auditing in the Lazarus IDE.
- The validator checks visible Application Button, tabs, QAT entries and visible commands inside each tab for duplicated or missing KeyTips in the currently supported overlay model.
- QAT entries without explicit KeyTips are validated using the same numeric fallback convention (`1`, `2`, `3`, ...) used by the title-bar QAT overlay.
- Keeps runtime behavior unchanged: no changes to `TLazRibbonForm`, resize/minimize, contextual tabs, QAT painting or KeyTip execution.
- Updates runtime and design-time package versions to 1.1.63.

## 1.1.62 - Design-time starter layout BaseItem dependency hotfix

- Fixes the Lazarus design package compilation error in `LazRibbon_Editor.pas` by importing `LazRibbon_BaseItem`, where `TLazRibbonBaseItem` is declared.
- Keeps the `Add starter Ribbon layout` verb and all runtime behavior unchanged.
- Updates runtime and design-time package versions to 1.1.62.

## 1.1.61 - Design-time starter Ribbon layout verb

- Adds a third `TLazRibbon` component-editor scaffold action: `Add starter Ribbon layout`.
- The new verb creates a more complete Office-like starter structure with Application Button, title-bar QAT, Home/Insert/View tabs, a contextual Image tab, panes, commands, KeyTips and ScreenTips.
- QAT starter entries are linked to the generated `Novo`, `Abrir` and `Salvar` commands and receive numeric KeyTips `1`, `2`, `3`.
- Keeps runtime behavior unchanged: no changes to `TLazRibbonForm`, custom resize/minimize, contextual-tab rendering, KeyTips execution or demo projects.
- Updates runtime and design-time package versions to 1.1.61.

## 1.1.60 - GUI demo subsystem and custom minimize restoration pass

- Sets all demo projects to Windows GUI application mode (`GraphicApplication=True`) so running demos from Lazarus/Windows does not create an extra console/DOS window.
- Changes the custom title-bar minimize button to post the native Windows `SC_MINIMIZE` system command instead of only assigning `WindowState := wsMinimized`. This keeps minimize/restore on the normal Windows taskbar path for `TLazRibbonForm`.
- Keeps the 1.1.54 custom-chrome resize strategy and the 1.1.57 KeyTips fix unchanged.
- Updates runtime and design-time package versions to 1.1.60.

## 1.1.59 - Design-time Designer.Modified hotfix

- Fixes Lazarus design-time package compilation by replacing the invalid local `IDesigner` declaration in `TLazRibbonEditor.MarkDesignerModified` with the existing `TComponentEditor.Designer` property.
- Keeps the 1.1.58 quick creation verbs unchanged.
- Updates runtime and design-time package versions to 1.1.59.

## 1.1.58 - Design-time quick creation verbs

- Adds two `TLazRibbon` component-editor verbs in the Lazarus IDE: `Add basic tab` and `Add contextual tab`.
- `Add basic tab` creates a starter tab with one pane, one large command and one small command, including default KeyTips and ScreenTip metadata.
- `Add contextual tab` creates a contextual tab with group caption, contextual color, one pane and a starter contextual command.
- Keeps runtime behavior unchanged: no changes to `TLazRibbonForm` resize handling, contextual-tab drawing, KeyTips execution or BackStage.
- Updates runtime and design-time package versions to 1.1.58.

## 1.1.57 - Title-bar QAT KeyTips duplicate overlay fix

- Fixes duplicate/overlapped QAT KeyTips when `QuickAccessToolBar.Position = qapTitleBar`.
- `TLazRibbon` no longer draws QAT KeyTips for title-bar-hosted QAT items; those are drawn exclusively by `TLazRibbonTitleBar`.
- Adds a defensive valid-rectangle check before drawing Ribbon-hosted QAT KeyTips.
- Keeps the 1.1.54 `TLazRibbonForm` resize strategy and the 1.1.56 multi-contextual-group showcase behavior unchanged.
- Updates runtime and design-time package versions to 1.1.57.

## 1.1.56 - Multiple contextual groups sanity pass

- Updates the showcase demo to exercise two independent contextual tab groups: `Ferramentas de Imagem` and `Ferramentas de Tabela`.
- Adds a small layout gap between adjacent visible contextual groups so two groups do not visually merge into a single band.
- Updates the showcase workflow with `Selecionar imagem`, `Selecionar tabela` and `Limpar contexto` buttons for manual contextual-tab regression testing.
- Keeps the `TLazRibbonForm` custom-chrome resize strategy from 1.1.54 unchanged.
- Updates runtime and design-time package versions to 1.1.56.

## 1.1.55 - Contextual tabs visual refinement

- Refines contextual group header styling to be lighter and less boxy, closer to the visual behavior of modern Office contextual tabs.
- Removes the heavy framed-label look from contextual headers and replaces it with a pale contextual band, subtle accent lines, centered clipped text and softer typography.
- Softens contextual tab borders, fills and accent bars so contextual tabs do not look visually heavier than normal Ribbon tabs.
- Keeps the 1.1.54 `TLazRibbonForm` resize strategy unchanged because it restored reliable window resizing.
- Updates runtime and design-time package versions to 1.1.55.

## 1.1.54 - Custom chrome resize strategy correction

- Changes `TLazRibbonForm` custom chrome on Windows so it no longer depends on a pure `BorderStyle = bsNone` top-level window for sizeable forms.
- Keeps the original LCL border policy (`bsSizeable`/`bsSizeToolWin`) and removes only the native Windows caption style, preserving a real sizing frame while the LazRibbon client title bar paints the visible chrome.
- Keeps `WM_NCHITTEST` support for the custom title bar/top edge.
- Makes `demos/showcase` explicitly `BorderStyle = bsSizeable` to validate resize behavior.
- Updates runtime and design-time package versions to 1.1.54.
