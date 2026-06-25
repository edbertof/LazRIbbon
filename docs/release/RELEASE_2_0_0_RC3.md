# LazRibbon 2.0.0-rc3 Release Notes

Status: release tooling and API-freeze release candidate.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.0.0-rc3` keeps the package metadata at `2.0.0` and uses `2.0.0-rc3` as the public ZIP/tag/release label.

This candidate preserves the `2.0.0-rc1` API-freeze surface and the `2.0.0-rc2` documentation package. It fixes one release-tooling issue found while validating the ZIP downloaded from the GitHub Release: `tools/check_release_zip.ps1` now treats relative path parts as an array even when the audited path has only one segment.

## Highlights Since RC2

- Fixes `tools/check_release_zip.ps1` for direct directory audits of extracted release trees.
- Keeps the illustrated Markdown manual, complete component reference and DOCX manuals from RC2.
- Updates current release-candidate guidance, README commands and readiness gates to use the `2.0.0-rc3` public label.

## API Freeze Evidence

Before tagging or publishing `v2.0.0-rc3`, verify:

- `docs/release/API_FREEZE_READINESS_2_0.md` reports no review or manual gates.
- `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` is regenerated and current.
- `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` reports zero unclassified repeated property names.
- `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` is regenerated and current.
- `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md` still matches the intended component composition model.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.0.0 -ReleaseVersion 2.0.0-rc3 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

This validates the package version, builds the package/tool/demo matrix, validates a clean extracted source tree and creates a ZIP named with the RC label.

## Validation Performed

The `2.0.0-rc3` preflight passed on 2026-06-25 with Lazarus 4.8.

- ZIP: `LazRibbon_2.0.0-rc3_source_20260625_105750.zip`
- SHA256: `906AFB9347BD39CA14C74695BD1F4203EF2D752F3A36FBEA4707D6EA0870DF71`

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

Promote `2.0.0-rc3` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the ZIP downloaded from the GitHub Release validates from an extracted source tree.
