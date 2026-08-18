# LazRibbon 2.1.7 Release Notes

Status: Skin Editor document workflow polish.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.7` improves the standalone Skin Editor as a normal document-editing tool.
It focuses on command order, file destination clarity and consistent status
text while preserving the existing skin format and component API.

The package metadata is set to `2.1.7`. The public ZIP/tag/release label is also
`2.1.7`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.7`.
- `Nova skin` now checks for unsaved edits before opening the new-skin dialog.
- `Abrir` now checks for unsaved edits before opening the file picker.
- `Salvar` and `Salvar como...` share one save-target preparation path.
- Save targets without an extension are normalized to `.skin`.
- The current skin, selected base, target file and edit state are shown from one
  consistent workflow model in the top strip, BackStage information page and
  window caption.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.7 -ReleaseVersion 2.1.7 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- This release improves workflow behavior and status clarity. It does not yet
  redesign the Skin Editor pages or add a dedicated multi-state visual preview
  dashboard beyond the preview modes already present in 2.1.

## Validation Performed

- The standalone Skin Editor was rebuilt with Lazarus 4.8 using a temporary
  Lazarus profile with local package links.
- The release consistency audit should pass before publishing.
- The full package/tool/demo preflight should pass before tagging.

## Promotion Rule

Publish `2.1.7` only if the full preflight passes, the generated ZIP hash is
recorded for the release asset, and the ZIP downloaded from the GitHub Release
validates from an extracted source tree.
