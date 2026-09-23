# LazRibbon 2.1.19 Release Notes

`2.1.19` makes Quick Access Toolbar placement match the names exposed in the
Object Inspector and prevents commands from silently disappearing.

## Changes

- `qapBeforeTabs` now renders the QAT before the Application/Arquivo button,
  followed by the normal Ribbon tabs.
- `qapTitleBar` continues to use the visible custom title bar supplied by
  `TLazRibbonForm`.
- When no compatible visible title-bar host exists, `qapTitleBar` falls back to
  the before-tabs layout while preserving the configured `Position` value.
- The effective position is used consistently by layout, painting, mouse input
  and KeyTips.
- Runtime and design-time package metadata are updated to `2.1.19`.

## Validation

The runtime package, design-time package, Skin Editor and all demos are built
with Lazarus 4.8. The release-candidate workflow also validates a clean source
ZIP extraction before publication.

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.19 -ReleaseVersion 2.1.19 -OutputDirectory D:\Ribbon4Lazarus\Releases
```
