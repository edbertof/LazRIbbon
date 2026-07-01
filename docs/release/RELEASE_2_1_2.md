# LazRibbon 2.1.2 Release Notes

Status: Skin Editor workflow UX release.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.2` continues the post-2.0 Skin Editor workflow pass. It keeps the stable 2.0 public API direction and focuses on making the standalone Skin Editor more natural for skin authors.

The package metadata is set to `2.1.2`. The public ZIP/tag/release label is also `2.1.2`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.2`.
- The Skin Editor now has a compact workflow strip below the live Ribbon preview.
- The focused base selector remains visible and usable during the normal editing flow.
- `Nova pela base`, `Abrir...` and `Salvar...` are now visible quick actions instead of being discoverable only through the File tab.
- Main editor pages are numbered as workflow steps: identity, Ribbon colors, BackStage, validation/save and advanced adjustment.
- The status bar and workflow hint update when the active editor page changes.
- Changing the focused base no longer replaces a skin that is already being edited; it updates the comparison/new-skin base instead.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.2 -ReleaseVersion 2.1.2 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The Skin Editor still uses the native complete `Appearance` editor for deep low-level styling.
- The advanced RTTI inspector is intentionally technical and should be treated as an adjustment tool, not the main workflow.
- Windows remains the primary validation platform for the current custom form shell.
- The package aims for Office-like interfaces, not full commercial Ribbon feature parity.

## Validation Performed

- Full release preflight completed for package version `2.1.2` and public release label `2.1.2`.
- Release ZIP: `LazRibbon_2.1.2_source_20260701_092650.zip`
- SHA256: `351D388C2A6B2DA569893262EDC5307E35442304FA7FAEB3EC4F999972B1EA38`
- Output folder: `D:\Ribbon4Lazarus\Releases`
- The generated ZIP must be re-downloaded from the GitHub Release and validated from an extracted source tree after publication.

## Promotion Rule

Publish `2.1.2` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the ZIP downloaded from the GitHub Release validates from an extracted source tree.
