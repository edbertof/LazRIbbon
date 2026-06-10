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
