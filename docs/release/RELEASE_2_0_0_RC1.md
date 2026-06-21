# LazRibbon 2.0.0-rc1 Release Notes

Status: first 2.0 API-freeze release candidate.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.0.0-rc1` is the first API-freeze candidate for the LazRibbon package. It is intended to validate the public Object Inspector surface, package installation flow, design-time registration, demos, Skin Editor and release ZIP hygiene before the final `2.0.0`.

The package metadata is set to `2.0.0`. The release/ZIP/tag label is `2.0.0-rc1`.

## Highlights

- Office-like Ribbon tabs, panes and command items for Lazarus LCL applications.
- Office Application Button, BackStage, recent files and Quick Access Toolbar support.
- `TLazRibbonForm` custom Ribbon form shell.
- Built-in and external `.skin` loading through `TLazRibbonSkinManager`.
- Standalone LazRibbon Skin Editor with live Ribbon preview.
- ScreenTips, staged KeyTips, contextual tabs and Dialog Launcher support.
- Clean Object Inspector property model documented for the 2.0 freeze.
- Public screenshots for Showcase, BackStage, Skin Gallery and Skin Editor.

## API Freeze Evidence

Before tagging or publishing `v2.0.0-rc1`, verify:

- `docs/release/API_FREEZE_READINESS_2_0.md` reports no review or manual gates.
- `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` is regenerated and current.
- `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` reports zero unclassified repeated property names.
- `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` is regenerated and current.
- `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md` still matches the intended component composition model.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.0.0 -ReleaseVersion 2.0.0-rc1 -OutputDirectory D:\Ribbon4Lazarus
```

This validates the package version, builds the package/tool/demo matrix, validates a clean extracted source tree and creates a ZIP named with the RC label.

## Validation Performed

The `2.0.0-rc1` preflight passed on 2026-06-21 with Lazarus 4.8.

- ZIP: `LazRibbon_2.0.0-rc1_source_20260621_071121.zip`
- SHA256: `414C63EFE52D141AA13DA8ECA41D49B1AB83CD7D2B87C5F0FA2C83BD07D2101E`

## Screenshot Command

Regenerate and review public screenshots before publishing:

```powershell
powershell -ExecutionPolicy Bypass -File tools/capture_release_screenshots.ps1
```

## Known Limitations

- Windows remains the primary validation platform for the current custom form shell.
- The package aims for Office-like interfaces, not full commercial Ribbon feature parity.
- Skin Editor coverage is broad enough for current skin identity and Appearance work, but future 2.x releases may still expand detailed editing workflows.

## Promotion Rule

Promote `2.0.0-rc1` only if the full preflight passes, the generated ZIP hash is recorded, and the Skin Editor plus main demos open successfully in Lazarus 4.8 without manual file copying or generated build artifacts.
