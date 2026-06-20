## 1.2.42 check

- Package metadata updated to 1.2.42.
- `tools/build_release_zip.ps1`, `tools/verify_clean_checkout.ps1` and `tools/verify_release_candidate.ps1` support `-ReleaseVersion` so public ZIP/tag labels can differ from numeric Lazarus package metadata.
- `docs/release/RELEASE_2_0_0_RC1.md` stages the first 2.0 release-candidate notes.
- `docs/release/RELEASE_CANDIDATE_PREP.md` documents the current `2.0.0-rc1` flow and the `-Version`/`-ReleaseVersion` split.
- The generated API freeze readiness report now tracks the 2.0 RC1 release notes draft as a ready gate.

## 1.2.41 check

- Package metadata updated to 1.2.41.
- `tools/capture_release_screenshots.ps1` generates the public README screenshot set from the Showcase, BackStage, Skin Gallery and Skin Editor.
- `docs/assets/screenshots/showcase-main.png`, `showcase-backstage.png`, `showcase-skins.png` and `skin-editor.png` are included as public-facing assets.
- The generated API freeze readiness report now tracks screenshot assets as a ready gate when the PNG files and capture script are present.
- README, installation and publishing docs reference the screenshot workflow.

## 1.2.40 check

- Package metadata updated to 1.2.40.
- `tools/verify_clean_checkout.ps1` validates the package from an extracted release-style source tree with a temporary Lazarus profile.
- `docs/release/CLEAN_CHECKOUT_VALIDATION.md` documents the clean checkout release gate.
- `tools/verify_release_candidate.ps1` includes clean checkout installation validation by default, uses a temporary Lazarus profile for the main build matrix and exposes `-SkipCleanCheckout` for fast local iteration.
- The generated API freeze readiness report now tracks clean checkout validation as a ready gate when the script and guide are present.

## 1.2.39 check

- Package metadata updated to 1.2.39.
- `tools/export_2_0_api_freeze_readiness.ps1` generates the compact 2.0 API freeze readiness report.
- `docs/release/API_FREEZE_READINESS_2_0.md` consolidates package versions, API audits, Object Inspector reports and release workflow gates.
- The readiness report currently shows 10 ready gates, 2 manual release-candidate validation gates and 0 gates needing review.
- The consistency audit regenerates the readiness report and fails if it drifts from source documents.

## 1.2.38 check

- Package metadata updated to 1.2.38.
- `tools/export_design_time_property_skip_audit.ps1` generates the current design-time Object Inspector hiding report from `LazRibbon_Register.pas`.
- `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` documents 29 `RegisterPropertyToSkip` rules, 4 nil property-editor hide rules and 8 affected component classes.
- Checkbox `GroupBehaviour` property-skip spelling is normalized to match the radio button rule.
- The consistency audit regenerates the design-time property skip audit and fails if it drifts from source.

## 1.2.37 check

- Package metadata updated to 1.2.37.
- `tools/export_object_inspector_redundancy_audit.ps1` classifies repeated direct published property names from the generated Object Inspector snapshot.
- `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` records the current repeated-name classification and reports zero unclassified redundancies.
- The consistency audit regenerates the redundancy audit and fails if it drifts from source or introduces unclassified repeated names.
- README, INSTALL, roadmap and API/property docs include the redundancy audit in the 2.0 freeze workflow.

## 1.2.36 check

- Package metadata updated to 1.2.36.
- `tools/verify_release_candidate.ps1` runs the release-candidate preflight in one command.
- The preflight runs consistency before build, full build matrix with cleanup, consistency after cleanup and release ZIP audit.
- `README.md`, `INSTALL.md` and the 2.0 roadmap document the preflight command.
- The consistency audit requires the preflight script to keep the 2.0 release path explicit.

## 1.2.35 check

- Package metadata updated to 1.2.35.
- `tools/export_object_inspector_snapshot.ps1` generates the current direct published-property snapshot.
- `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` records the current package-facing Object Inspector/runtime RTTI surface.
- The consistency audit regenerates the snapshot and fails when it drifts from source.
- The 2.0 roadmap and API/property audit docs include the snapshot in the pre-freeze workflow.

## 1.2.34 check

- Package metadata updated to 1.2.34.
- `tools/build_all_projects.ps1` compiles runtime, design-time, Skin Editor and every demo in one command.
- `docs/release/DEMO_VALIDATION_MATRIX.md` documents what each demo validates for the 2.0 release path.
- `README.md` includes a compact first Ribbon form guide using current API names.
- `INSTALL.md` points release validation to the full build script before creating the source ZIP.
- The consistency audit requires the full-build script, demo matrix and first Ribbon form documentation.

## 1.2.33 check

- Package metadata updated to 1.2.33.
- `TLazRibbonControlHostItem.Control` is the canonical published hosted-control reference.
- `Caption` remains fallback placeholder text when no hosted control is assigned.
- Legacy `ControlName` and `ControlClassName` metadata remains hidden from the Object Inspector and readable from old `.lfm` resources.
- Inactive tab rectangles are cleared during Ribbon metric validation so hosted controls from inactive tabs are hidden.
- The consistency audit requires the direct ControlHost API and rejects legacy hosted-control metadata streaming.

## 1.2.32 check

- Package metadata updated to 1.2.32.
- `TLazRibbonSkinManager.ActiveSkinName` is the only published Object Inspector active-skin selector.
- `TLazRibbonSkinManager.ActiveSkin` remains public source compatibility only and is accepted through a legacy `.lfm` reader.
- Demos and tools stream `ActiveSkinName` instead of `ActiveSkin`.
- The consistency audit rejects new `TLazRibbonSkinManager.ActiveSkin` streaming.

## 1.2.31 check

- Package metadata updated to 1.2.31.
- `TLazRibbonBackstagePage` no longer publishes command/navigation properties in the Object Inspector surface.
- Page-level `Action`, `Command`, `CloseBackstageOnClick`, `ItemKind` and `OnExecute` remain public source-level compatibility only.
- `TLazRibbonBackstageView.Buttons` remains the canonical model for BackStage navigation entries, commands and separators.
- `docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md` records redundant/repeated property decisions for the 2.0 freeze.
- The consistency audit rejects a published BackStage page command surface.

## 1.2.30 check

- Package metadata updated to 1.2.30.
- `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md` documents the Object Inspector property model for the main components.
- The matrix records canonical composition links, visual settings, skin properties and compatibility-only names.
- Intentional similar pairs are documented so QAT allow/show properties and gallery item/icon sizes are not treated as duplicates.
- The consistency audit requires the property matrix and key canonical API names.

## 1.2.29 check

- Package metadata updated to 1.2.29.
- `TLazRibbonControlHostItem.Caption` is the visible placeholder text for hosted-control items.
- Legacy `ControlName` and `ControlClassName` metadata is hidden from the Object Inspector and retained only for source/streaming compatibility.
- Legacy `.lfm` readers accept `ControlName` and `ControlClassName`; new package resources must not stream them.
- The consistency audit rejects new `ControlName` and `ControlClassName` streaming on `TLazRibbonControlHostItem`.

## 1.2.28 check

- Package metadata updated to 1.2.28.
- `TLazRibbonBackstagePage` is treated as a content container in the design-time API.
- `TLazRibbonBackstageView.Buttons` remains the explicit public model for BackStage page links, commands and separators.
- Page-level command/navigation properties `Action`, `Command`, `CloseBackstageOnClick`, `ItemKind` and `OnExecute` are hidden from the Object Inspector.
- The consistency audit rejects command/navigation streaming on `TLazRibbonBackstagePage` resources.

## 1.2.27 check

- Package metadata updated to 1.2.27.
- `docs/quality/COMPONENT_COMPOSITION_MODEL_2_0.md` documents the intended
  Ribbon, BackStage, QAT, pane/item and skin-component composition model.
- `TLazRibbon.BackstageView` is the canonical published BackStage composition
  property; package sources/resources no longer stream
  `ApplicationButton.BackstageView`.
- `TLazRibbonSeparator` hides inherited command and ScreenTip properties at
  design time so it behaves as a structural item.
- The consistency audit protects BackStage composition streaming, separator
  design-time cleanup and the composition model document.

## 1.2.26 check

- Package metadata updated to 1.2.26.
- `TLazRibbonBackstageView` and `TLazRibbonBackstageRecentList` use
  `AppearanceSource` as the canonical published visual-source decision.
- Legacy BackStage appearance-source booleans `UseToolbarAppearance` and
  `UseSkinManager` are removed from package API/resources.
- Assigning a BackStage `SkinManager` still selects `AppearanceSource =
  asSkinManager` automatically.
- The consistency audit rejects legacy BackStage appearance-source API names and
  streaming.

## 1.2.25 check

- Package metadata updated to 1.2.25.
- `TLazRibbonSkinDefinition` publishes `Icon16Data`, `Icon24Data` and
  `Icon32Data` as the canonical embedded skin identity icon fields.
- `Icon16FileName`, `Icon24FileName` and `Icon32FileName` remain public
  import/source compatibility fields but are no longer published.
- New `.skin` XML writes legacy icon file-name tags only when the matching
  embedded icon data field is empty.
- The consistency audit protects the embedded icon identity API and XML-writing
  behavior.

## 1.2.24 check

- Package metadata updated to 1.2.24.
- `TLazRibbonSkinGalleryItem` and `TLazRibbonSkinSelector` publish `SelectedSkinName` as the canonical skin selection property.
- `SelectedSkin` remains available as a public built-in-skin convenience and legacy streaming reader.
- Package `.lfm` resources use `SelectedSkinName` instead of the enum-only `SelectedSkin`.
- The consistency audit rejects `SelectedSkin` streaming in package resources.

## 1.2.23 check

- Package metadata updated to 1.2.23.
- Generic `TLazRibbonGalleryItem` controls publish `ItemWidth` and `ItemHeight` without the duplicated `IconWidth`/`IconHeight` aliases.
- `TLazRibbonSkinGalleryItem` publishes `IconWidth` and `IconHeight` for skin swatches and keeps legacy readers where needed.
- Package `.lfm` resources use the canonical gallery size property names.
- The consistency audit rejects mixed generic-gallery and skin-gallery size names in package resources.

## 1.2.22 check

- Package metadata updated to 1.2.22.
- `TLazRibbonBackstageView` publishes `BackButtonVisible` as the single BackStage return-button visibility property.
- Package `.lfm` resources use the canonical BackStage back-button property name.
- The consistency audit rejects the legacy `ShowCloseButton` BackStage API name in package sources/resources.

## 1.2.21 check

- Package metadata updated to 1.2.21.
- `TLazRibbon` publishes `ShowMinimizeRibbonButton`, `MinimizeRibbonHint` and `RestoreRibbonHint`.
- Package `.lfm` resources use the new Ribbon minimize/restore property names.
- The consistency audit rejects legacy `ShowCollapseButton`, `CollapseRibbonHint` and `ExpandRibbonHint` names in package sources/resources.

## 1.2.20 check

- Package metadata updated to 1.2.20.
- `docs/quality/PUBLIC_API_AUDIT_2_0.md` documents the public API freeze candidates and cleanup targets.
- `docs/release/ROADMAP_2_0.md` defines pre-2.0 gates and the 2.0 definition of done.
- The consistency audit protects the presence and key content of the 2.0 planning documents.

## 1.2.19 check

- Package metadata updated to 1.2.19.
- The Skin Editor detects whether `Appearance` still matches the simple palette.
- New-from-base and open-file workflows refresh the full-Appearance edit state from the skin contents.
- The consistency audit protects the Skin Editor Appearance mode detection.

## 1.2.18 check

- Package metadata updated to 1.2.18.
- The Skin Editor live preview toolbar streams and sets `Align = alTop`.
- The Skin Editor live preview panel synchronizes after `OnRibbonMinimizedChanged`.
- The consistency audit protects the Skin Editor preview minimize behavior.

## 1.2.17 check

- Package metadata updated to 1.2.17.
- `TLazRibbon.RibbonMinimized` now resizes the control to the minimized tab/QAT height.
- Expanding restores a previously taller Ribbon height when hosted previews need it.
- The consistency audit protects the minimize-height behavior.

## 1.2.16 check

- Package metadata updated to 1.2.16.
- `TLazRibbonBackstageView.OverlayMode` now defaults to `bomCoverClientArea`.
- `bomCoverRibbonArea` remains available only as an explicit older tab-preserving layout choice.
- The consistency audit protects the Office-style BackStage default.

## 1.2.15 check

- Package metadata updated to 1.2.15.
- `TLazRibbonSkinManager` publishes grouped palette color properties: `General`, `Accent`, `Backstage`, `RecentList` and `Ribbon`.
- Flat SkinManager palette aliases such as `BackColor`, `NavigationColor`, `RecentOddColor` and `RecentSelectedColor` are no longer published.
- Package demos and tools stream grouped SkinManager palette properties instead of flat aliases.
- The consistency audit rejects legacy flat SkinManager palette streaming.

## 1.2.14 check

- Package metadata updated to 1.2.14.
- `TLazRibbon.ApplicationButton.*` is the single public Object Inspector API for the Office Application Button.
- `TLazRibbon.ApplicationButton.Style` replaces the old published `MenuButtonStyle` alias for caption/dropdown rendering.
- Package demos, tools and design resources stream `ApplicationButton.*` instead of flattened Application/Menu Button aliases.
- The consistency audit rejects legacy Application/Menu Button streaming in `TLazRibbon` resources.

## 1.2.13 check

- Package metadata updated to 1.2.13.
- `TLazRibbon` publishes `RibbonAppearance` as its only public low-level visual styling property.
- `TLazRibbonSkinManager.Appearance` remains available and continues to stream skin appearance data.
- The consistency audit still rejects legacy `TLazRibbon.Appearance.*` streaming and invalid non-Ribbon `RibbonAppearance.*` streaming.

## 1.2.12 check

- Package metadata updated to 1.2.12.
- `TLazRibbon` resources stream `RibbonAppearance.*`; `TLazRibbonSkinManager` resources stream `Appearance.*`.
- The standalone Skin Editor and `demos/ribbon_form` no longer contain invalid `TLazRibbonSkinManager.RibbonAppearance.*` entries.
- `tools/check_project_consistency.ps1` rejects both legacy `TLazRibbon.Appearance.*` and invalid non-Ribbon `RibbonAppearance.*` streaming.

## 1.2.11 check

- Package metadata updated to 1.2.11.
- Demos, the standalone Skin Editor and the design-time Appearance editor stream `TLazRibbon.RibbonAppearance` in `.lfm` resources instead of legacy `Appearance`.
- `tools/check_project_consistency.ps1` rejects new `.lfm` files containing legacy `Appearance.*` TLazRibbon streaming lines.
- Release ZIPs created through `tools/build_release_zip.ps1` are saved in `D:\Ribbon4Lazarus` by default and must pass the generated-artifact audit.

## 1.2.10 check

- Package metadata updated to 1.2.10.
- The standalone `LazRibbonSkinEditor` opens in a smaller 1060x700 window with tighter editor page spacing.
- The Skin Editor live Ribbon preview remains tall enough to validate pane captions and Dialog Launchers.
- Release ZIPs created through `tools/build_release_zip.ps1` are saved in `D:\Ribbon4Lazarus` by default and must pass the generated-artifact audit.

## 1.2.9 check

- Package metadata updated to 1.2.9.
- `TLazRibbon.RibbonAppearance` is the streamed design-time visual property; the legacy `Appearance` alias is hidden from the designer and not written by new forms.
- Release ZIPs created through `tools/build_release_zip.ps1` are saved in `D:\Ribbon4Lazarus` by default and must pass the generated-artifact audit.

## 1.2.8 check

- Package metadata updated to 1.2.8.
- Design-time caption, structure and Appearance edits force the Ribbon preview to rebuild and repaint.
- Release ZIPs created through `tools/build_release_zip.ps1` are saved in `D:\Ribbon4Lazarus` by default and must pass the generated-artifact audit.

## 1.2.7 check

- Package metadata updated to 1.2.7.
- Runtime fixes keep pane captions visible when a Ribbon is hosted taller than the calculated default toolbar height.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.2.6 check

- Package metadata updated to 1.2.6.
- `TLazRibbonPane` draws pane captions through the direct fit-width text path.
- Skin Editor live Ribbon preview should show pane group names such as `Documento`, `Janela`, `Exemplos` and `Opções`.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.2.5 check

- Package metadata updated to 1.2.5.
- Skin Editor live Ribbon preview height is no longer fixed to the older 132 px layout.
- Skin Editor `Estilos` pane exposes a working Dialog Launcher that opens the complete Appearance editor on the Pane section.
- Dialog Launcher glyphs are drawn by canvas lines, avoiding font/private-use character dependency.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.2.4 check

- Package metadata updated to 1.2.4.
- `TLazRibbonPane` draws item contents before the caption band so pane captions stay visible.
- Pane caption text is centered in the caption band and clipped with ellipsis when needed.
- Skin Editor live Ribbon preview should show pane captions across skins.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.2.3 check

- Package metadata updated to 1.2.3.
- `LazRibbonSkinEditor` complete Appearance inspector marks properties that differ from the focused base skin.
- The inspector can filter to show only Appearance properties that differ from the focused base skin.
- Runtime Ribbon UI behavior remains unchanged.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.2.2 check

- Package metadata updated to 1.2.2.
- `LazRibbonSkinEditor` complete Appearance inspector can restore the selected property from the focused base skin.
- Restoring an Appearance property refreshes the live preview and validation/comparison report.
- Runtime Ribbon UI behavior remains unchanged.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.2.1 check

- Package metadata updated to 1.2.1.
- `LazRibbonSkinEditor` validation report includes comparison against the focused base skin.
- The base comparison covers metadata, icon file/data state, palette colors and published Appearance properties.
- Runtime Ribbon UI behavior remains unchanged.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.2.0 check

- Package metadata updated to 1.2.0.
- `LazRibbonSkinEditor` includes a validation report for identity, metadata, icon file/data state, Appearance mode and contrast checks.
- Validation controls are persisted in `uSkinEditorMain.lfm` for design-time visibility.
- Runtime Ribbon UI behavior remains unchanged.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.1.78 check

- Package metadata updated to 1.1.78.
- Visible LazRibbon component palette icons share a single Office-like visual style.
- Palette icon resources include 24 px, 36 px and 48 px entries using `ClassName`, `ClassName_150` and `ClassName_200`.
- `source/design/icons/make_res.bat` regenerates the current `.lrs` files from all three PNG sizes.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.1.77 check

- Package metadata updated to 1.1.77.
- `TLazRibbon` exposes `TabCaptionHorizontalPadding`, `TabCaptionSpacing` and `MinTabCaptionWidth` for Office-like tab layout tuning.
- Default tab caption metrics are 10 px horizontal padding, 2 px spacing and 40 px minimum caption width.
- Contextual tab header width calculations use the same tab metrics.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.1.76 check

- Package metadata updated to 1.1.76.
- `TLazRibbonPane` exposes Office-style Dialog Launcher names: `ShowDialogLauncher`, `DialogLauncherStyle` and `OnDialogLauncherClick`.
- The default `DialogLauncherStyle` is `dlsArrow`; `dlsPlus` remains available as an alternate glyph style.
- Active demos use the new property, event and enum names.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.1.75 check

- Package metadata updated to 1.1.75.
- `LazRibbonSkinEditor` Appearance inspector now exposes all Appearance sections together, supports filtering and shows RTTI property types.
- Direct inspector editing now includes floats, strings, characters and sets in addition to the existing supported types.
- Runtime UI behavior remains unchanged.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.1.74 check

- Package metadata updated to 1.1.74.
- Public repository docs added: `CONTRIBUTING.md`, `docs/quality/VALIDATION_LAZARUS_4_8.md` and `docs/release/GITHUB_PUBLISHING.md`.
- GitHub issue and pull-request templates added under `.github/`.
- Screenshot guidance added under `docs/assets/screenshots/`.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.1.73 check

- Package metadata updated to 1.1.73.
- Active documentation target updated to Lazarus 4.8.
- Runtime and design-time packages should be compiled with Lazarus 4.8 before publishing.
- Release ZIP should still be created through `tools/build_release_zip.ps1` and must pass the generated-artifact audit.

## 1.1.72 check

- Package metadata updated to 1.1.72.
- `tools/check_project_consistency.ps1` now filters demo `.lpi` files with `-Filter`, reads `GraphicApplication` from the XML `Value` attribute and reports generated directories once.
- The consistency audit blocks common Lazarus/FPC artifacts including `.res`, `.rsj`, `.compiled`, `.ppu`, `.o`, `.obj`, `.exe`, `lib`, `bin`, `obj` and `backup`.
- The public component palette now has resources for `TLazRibbonPopupMenu`, `TLazRibbonSkinManager` and `TLazRibbonSkinSelector`.
- Release ZIP should still be created through `tools/build_release_zip.ps1`.

## 1.1.71 check

- Package metadata updated to 1.1.71.
- `tools/check_project_consistency.ps1` added and wired into `tools/build_release_zip.ps1`.
- The consistency audit checks package version alignment, demo GUI subsystem flags, local environment paths and generated artifacts.
- Release ZIP audit remains unchanged for generated build artifacts.

## 1.1.70 check

- Package metadata updated to 1.1.70.
- Runtime Backspace capture extended to `TLazRibbonForm` for active KeyTips sessions.
- ZIP must not include `packagefiles.xml`, compiler outputs, nested ZIPs or local machine paths.

## 1.1.69 check

- Scope: KeyTips interaction refinement.
- Package metadata updated to 1.1.69.
- `TLazRibbon` closes KeyTips when normal mouse interaction starts on the Ribbon surface.
- `TLazRibbonTitleBar` closes KeyTips when the custom title bar, title-bar QAT or system buttons are clicked.
- `Backspace` removes the last typed multi-character KeyTip prefix character.
- Runtime resize/minimize, contextual tabs and design-time creation/validation logic are unchanged from 1.1.67.
- Release ZIP should exclude `packagefiles.xml`, build artifacts, nested ZIPs, local paths, `lib`, `bin`, `obj` and backup folders.
