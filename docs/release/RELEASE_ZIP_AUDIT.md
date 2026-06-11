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
