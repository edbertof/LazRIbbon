# LazRibbon 2.1.4 Release Notes

Status: SkinManager Appearance workflow release.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.4` continues the post-2.0 Skin Editor and design-time cleanup line. It keeps `RibbonAppearance` available internally for rendering and legacy `.lfm` streaming, but removes it from the new-project Object Inspector workflow.

The package metadata is set to `2.1.4`. The public ZIP/tag/release label is also `2.1.4`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.4`.
- `TLazRibbon.RibbonAppearance` is hidden from the Lazarus Object Inspector.
- Existing forms that stream `RibbonAppearance.*` remain readable because the runtime property still exists.
- The `TLazRibbonSkinManager` component editor now exposes `Editar Appearance completo...`.
- The SkinManager edit dialog now includes an `Appearance completo...` button.
- Detailed low-level visual editing is now reachable from the skin workflow, not from the Ribbon root component.
- The generated design-time property skip audit records the new hidden `RibbonAppearance` rule.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.4 -ReleaseVersion 2.1.4 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- `RibbonAppearance` still exists internally because the rendering engine and older `.lfm` files depend on it.
- Some demos may still stream `RibbonAppearance.*`; this is compatibility evidence, not the recommended new-project workflow.
- The complete Appearance editor is still the original low-level visual editor, now reached through `TLazRibbonSkinManager`.

## Validation Performed

- Full release preflight completed for package version `2.1.4` and public release label `2.1.4`.
- Release ZIP filename and SHA256 are recorded in `docs/release/RELEASE_ZIP_AUDIT.md`.
- The same ZIP must be re-downloaded from the GitHub Release and validated from an extracted source tree after publication.

## Promotion Rule

Publish `2.1.4` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the ZIP downloaded from the GitHub Release validates from an extracted source tree.
