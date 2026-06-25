# LazRibbon 2.0.0-rc2 Release Notes

Status: documentation and API-freeze release candidate.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.0.0-rc2` keeps the package metadata at `2.0.0` and uses `2.0.0-rc2` as the public ZIP/tag/release label.

This candidate preserves the `2.0.0-rc1` API-freeze surface and promotes the post-RC1 documentation work into the release line. It is intended to validate that a developer can install, inspect, learn and distribute the package using the GitHub repository, the source ZIP and the generated manuals.

## Highlights Since RC1

- Adds `docs/manual/LAZRIBBON_MANUAL.md`, an illustrated installation and usage guide.
- Adds `docs/manual/LAZRIBBON_COMPONENT_REFERENCE.md`, a property-by-property and event-by-event component reference.
- Adds DOCX versions of both manuals for Microsoft Word and LibreOffice Writer.
- Updates release-candidate guidance, README commands and readiness gates to use the `2.0.0-rc2` public label.

## API Freeze Evidence

Before tagging or publishing `v2.0.0-rc2`, verify:

- `docs/release/API_FREEZE_READINESS_2_0.md` reports no review or manual gates.
- `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` is regenerated and current.
- `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` reports zero unclassified repeated property names.
- `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` is regenerated and current.
- `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md` still matches the intended component composition model.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.0.0 -ReleaseVersion 2.0.0-rc2 -OutputDirectory D:\Ribbon4Lazarus
```

This validates the package version, builds the package/tool/demo matrix, validates a clean extracted source tree and creates a ZIP named with the RC label.

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

Promote `2.0.0-rc2` only if the full preflight passes, the generated ZIP hash is recorded for the release asset, and the Skin Editor plus main demos open successfully in Lazarus 4.8 without manual file copying or generated build artifacts.
