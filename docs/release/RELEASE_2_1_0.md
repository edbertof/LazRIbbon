# LazRibbon 2.1.0 Release Notes

Status: first post-2.0 feature release.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.0` is the first post-2.0 LazRibbon build. It keeps the stable 2.0 public API direction and starts the Skin Editor 2.1 workflow pass.

The package metadata is set to `2.1.0`. The public ZIP/tag/release label is also `2.1.0`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.0`.
- `docs/release/ROADMAP_2_1.md` defines the post-2.0 direction.
- `tools/export_skin_editor_2_1_coverage.ps1` generates `docs/quality/SKIN_EDITOR_APPEARANCE_COVERAGE_2_1.md`.
- The standalone Skin Editor validation report now groups base differences by area:
  identity, icons/preview, palette and each `Appearance` section.
- The detailed base comparison remains available below the grouped summary.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.0 -ReleaseVersion 2.1.0 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The Skin Editor 2.1 pass has started with validation workflow improvements; richer preview states and additional direct helpers remain planned work.
- Windows remains the primary validation platform for the current custom form shell.
- The package aims for Office-like interfaces, not full commercial Ribbon feature parity.

## Validation Performed

- Full release preflight completed for package version `2.1.0` and public release label `2.1.0`.
- Release ZIP: `LazRibbon_2.1.0_source_20260629_172528.zip`
- SHA256: `4D5F82C7DC7DF232B57A4BC786A132EFFEE68F56C657E965CE6BA4C986BD9AAC`
- Output folder: `D:\Ribbon4Lazarus\Releases`
- The generated ZIP is expected to be re-downloaded from the GitHub Release and validated from an extracted source tree after publication.

## Promotion Rule

Publish `2.1.0` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the ZIP downloaded from the GitHub Release validates from an extracted source tree.
