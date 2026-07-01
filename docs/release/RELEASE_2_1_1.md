# LazRibbon 2.1.1 Release Notes

Status: Skin Editor preview-state release.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.1` continues the post-2.0 Skin Editor workflow pass. It keeps the stable 2.0 public API direction and improves the standalone Skin Editor live preview so skin authors can validate more realistic Ribbon states before saving a `.skin` file.

The package metadata is set to `2.1.1`. The public ZIP/tag/release label is also `2.1.1`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.1`.
- The standalone Skin Editor live preview now includes disabled large and small commands.
- The preview includes checked/toggle, dropdown and button-dropdown command states.
- The preview includes checked and disabled checkbox states.
- Multiple panes expose Dialog Launcher samples, including the alternate plus launcher style.
- The additional preview controls are streamed in `uSkinEditorMain.lfm`, so the preview structure remains visible at design time.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.1 -ReleaseVersion 2.1.1 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The preview now exercises more command states, but forced hot/hover rendering still depends on normal mouse interaction.
- Windows remains the primary validation platform for the current custom form shell.
- The package aims for Office-like interfaces, not full commercial Ribbon feature parity.

## Validation Performed

- Full release preflight completed for package version `2.1.1` and public release label `2.1.1`.
- Release ZIP: `LazRibbon_2.1.1_source_20260701_084359.zip`
- SHA256: `0098E38D0DFC4855ED263A7F599B962B80BBDC732696F0201585F835AD20BDA7`
- Output folder: `D:\Ribbon4Lazarus\Releases`
- The generated ZIP must be re-downloaded from the GitHub Release and validated from an extracted source tree after publication.

## Promotion Rule

Publish `2.1.1` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the ZIP downloaded from the GitHub Release validates from an extracted source tree.
