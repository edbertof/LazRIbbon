# LazRibbon 2.1.8 Release Notes

Status: Skin Editor visual validation panel.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.8` improves the standalone Skin Editor validation page. The goal is to
make the final review step more visual and less dependent on reading the audit
memo alone.

The package metadata is set to `2.1.8`. The public ZIP/tag/release label is
also `2.1.8`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.8`.
- The `Validar e salvar` page now includes a compact visual dashboard.
- The dashboard draws normal Ribbon, minimized Ribbon, BackStage navigation and
  text-contrast samples from the current skin.
- The Popup/Menu preview remains on the validation page and is resized for the
  compact layout.
- Visual samples refresh with skin, palette, Appearance and validation changes.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.8 -ReleaseVersion 2.1.8 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The new dashboard is a fixed Canvas preview. It is intentionally not a second
  interactive Ribbon surface; the live Ribbon preview above the editor remains
  the interactive validation area.

## Validation Performed

- The standalone Skin Editor was rebuilt with Lazarus 4.8 using a temporary
  Lazarus profile with local package links.
- The release consistency audit should pass before publishing.
- The full package/tool/demo preflight should pass before tagging.

## Promotion Rule

Publish `2.1.8` only if the full preflight passes, the generated ZIP hash is
recorded for the release asset, and the ZIP downloaded from the GitHub Release
validates from an extracted source tree.
