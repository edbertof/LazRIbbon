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
