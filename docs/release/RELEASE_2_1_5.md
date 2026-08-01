# LazRibbon 2.1.5 Release Notes

Status: Workbench CRUD demo release.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.5` continues the post-2.0 validation line by adding a practical
application-style demo. The new demo is intended to show how a developer should
connect the main LazRibbon components to a normal client area in an
administrative/workbench application.

The package metadata is set to `2.1.5`. The public ZIP/tag/release label is also
`2.1.5`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.5`.
- Added `demos/workbench_crud/project1.lpi`.
- The Workbench CRUD demo combines `TLazRibbonForm`, `TLazRibbon`, Quick Access
  Toolbar, BackStage, recent files, `TLazRibbonSkinManager`,
  `TLazRibbonSkinGalleryItem`, `TLazRibbonPopupMenu` and normal LCL CRUD
  controls.
- Added the new demo to `tools/build_all_projects.ps1`, release cleanup and
  `docs/release/DEMO_VALIDATION_MATRIX.md`.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.5 -ReleaseVersion 2.1.5 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The Workbench CRUD demo stores its sample data in memory. It intentionally
  avoids database dependencies so it can compile immediately after package
  installation.
- The demo is a composition and workflow sample, not a persistence framework.

## Validation Performed

- Full build matrix must include the new `demos/workbench_crud/project1.lpi`
  target.
- Release ZIP filename and SHA256 should be recorded after the public ZIP is
  generated.
- The same ZIP must be re-downloaded from the GitHub Release and validated from
  an extracted source tree after publication.

## Promotion Rule

Publish `2.1.5` only if the full preflight passes, the generated ZIP hash is
recorded for the release asset, and the ZIP downloaded from the GitHub Release
validates from an extracted source tree.
