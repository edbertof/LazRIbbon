# LazRibbon 2.0.0 Release Notes

Status: stable release.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.0.0` is the first stable LazRibbon release after the 2.0 release-candidate line.

The package metadata is set to `2.0.0`. The public ZIP/tag/release label is also `2.0.0`.

This release preserves the validated API-freeze surface from `2.0.0-rc1`, includes the illustrated manual and component reference added in `2.0.0-rc2`, and includes the release ZIP audit fix validated in `2.0.0-rc3`.

## Highlights

- Office-like Ribbon tabs, panes and command items for Lazarus LCL applications.
- Office Application Button, BackStage, recent files and Quick Access Toolbar support.
- `TLazRibbonForm` custom Ribbon form shell.
- Built-in and external `.skin` loading through `TLazRibbonSkinManager`.
- Standalone LazRibbon Skin Editor with live Ribbon preview.
- ScreenTips, staged KeyTips, contextual tabs and Dialog Launcher support.
- Clean Object Inspector property model documented for the 2.0 API freeze.
- Public screenshots for Showcase, BackStage, Skin Gallery and Skin Editor.
- Illustrated Markdown manual, complete component reference and DOCX manuals.
- Release ZIP and clean checkout validation workflow.

## API Freeze Evidence

The 2.0 public API is supported by:

- `docs/release/API_FREEZE_READINESS_2_0.md`
- `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md`
- `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md`
- `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md`
- `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md`

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.0.0 -ReleaseVersion 2.0.0 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

This validates the package version, builds the package/tool/demo matrix, validates a clean extracted source tree and creates a ZIP named with the stable release label.

## Validation Performed

- Full release preflight completed for package version `2.0.0` and public release label `2.0.0`.
- Release ZIP: `LazRibbon_2.0.0_source_20260625_111943.zip`
- SHA256: `F55A20F322FFE3F78BC023112FF877E8BC2A68E540F82BE24859C3EE9CD48B24`
- Output folder: `D:\Ribbon4Lazarus\Releases`
- The generated ZIP is expected to be re-downloaded from the GitHub Release and validated from an extracted source tree after publication.

## Screenshot Command

Regenerate and review public screenshots before publishing when visual behavior changes:

```powershell
powershell -ExecutionPolicy Bypass -File tools/capture_release_screenshots.ps1
```

## Known Limitations

- Windows remains the primary validation platform for the current custom form shell.
- The package aims for Office-like interfaces, not full commercial Ribbon feature parity.
- Skin Editor coverage is broad enough for current skin identity and Appearance work, but future 2.x releases may still expand detailed editing workflows.
- DOCX manuals are generated structurally from Markdown; visual render QA depends on LibreOffice/`soffice` being available in the validation environment.

## Promotion Rule

Publish `2.0.0` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the ZIP downloaded from the GitHub Release validates from an extracted source tree.
