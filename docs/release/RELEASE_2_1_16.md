# LazRibbon 2.1.16 Release Notes

`2.1.16` improves BackStage composition in the Lazarus form designer.

The package metadata and public ZIP/tag label are both `2.1.16`.

## What changed

- `TLazRibbonBackstageView` has a dedicated component editor.
- `Add BackStage page` creates a content page and matching navigation entry, assigns a unique component name and selects it in the Object Inspector.
- `Add BackStage command` and `Add BackStage separator` append the corresponding entries to the existing `Buttons` collection.
- `Link to Ribbon on this form` finds the form's Ribbon, assigns both canonical links, inherits `SkinManager` and configures the Office-like client-area overlay and navigation style.

## API and compatibility

No published runtime property or event was added. The feature composes the existing `TLazRibbon.BackstageView`, `TLazRibbonBackstageView.LinkedToolbar`, `TLazRibbonBackstageView.Buttons` and `SkinManager` APIs. Existing projects are not changed automatically.

## Validation

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.16 -ReleaseVersion 2.1.16 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

Publish only after the full preflight passes and the official ZIP hash is recorded in `docs/release/RELEASE_ZIP_AUDIT.md`.
