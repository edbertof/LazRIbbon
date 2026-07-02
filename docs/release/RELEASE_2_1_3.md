# LazRibbon 2.1.3 Release Notes

Status: Skin Editor save-workflow release.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.3` continues the post-2.0 Skin Editor workflow pass. It keeps the stable 2.0 public API direction and focuses on making the standalone Skin Editor safer and more natural when editing `.skin` files.

The package metadata is set to `2.1.3`. The public ZIP/tag/release label is also `2.1.3`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.3`.
- The Skin Editor now tracks unsaved changes explicitly.
- The window caption shows `*` when the current skin has pending edits.
- The workflow hint reports whether the current skin is `alterada`, `salva` or `ainda não salva`.
- The top workflow strip and BackStage commands now separate `Salvar` from `Salvar como...`.
- `Salvar` reuses the current `.skin` file path when one is available.
- `Salvar como...` remains available for choosing a new destination.
- Closing the editor, opening another skin or creating a new skin from a base now asks before discarding unsaved edits.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.3 -ReleaseVersion 2.1.3 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The Skin Editor still uses the native complete `Appearance` editor for deep low-level styling.
- The advanced RTTI inspector is intentionally technical and should be treated as an adjustment tool, not the main workflow.
- Windows remains the primary validation platform for the current custom form shell.
- The package aims for Office-like interfaces, not full commercial Ribbon feature parity.

## Validation Performed

- Full release preflight completed for package version `2.1.3` and public release label `2.1.3`.
- Release ZIP created as `LazRibbon_2.1.3_source_20260702_110045.zip`.
- SHA256: `0209DE20B7561BA49C70CD15EAE08B172305C7EA7E2EA50E1037D7E4D7F36A11`.
- The generated ZIP must be re-downloaded from the GitHub Release and validated from an extracted source tree after publication.

## Promotion Rule

Publish `2.1.3` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the ZIP downloaded from the GitHub Release validates from an extracted source tree.
