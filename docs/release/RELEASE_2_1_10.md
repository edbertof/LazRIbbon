# LazRibbon 2.1.10 Release Notes

Status: Skin Editor base comparison preview.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.10` improves the standalone Skin Editor validation step. The goal is to
make base-derived skins easier to review before saving: the validation page now
shows the selected base and the current skin side by side in one fixed visual
panel.

The package metadata is set to `2.1.10`. The public ZIP/tag/release label is
also `2.1.10`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.10`.
- The Skin Editor validation visual panel is now titled `Base x skin atual`.
- The panel draws representative Ribbon, pane caption/body, command-state,
  BackStage selected navigation and contrast samples for the selected base and
  current skin.
- The comparison reports how many simple-palette colors differ from the base.
- Validation guidance now explicitly treats the visual panel as a base/current
  comparison step before saving.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.10 -ReleaseVersion 2.1.10 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The comparison is a fixed Canvas preview focused on the simple palette. The
  full `Appearance` difference report remains the detailed low-level audit.

## Validation Performed

- The standalone Skin Editor was rebuilt with Lazarus 4.8 using a temporary
  Lazarus profile with local package links.
- The release consistency audit should pass before publishing.
- The full package/tool/demo preflight should pass before tagging.

## Promotion Rule

Publish `2.1.10` only if the full preflight passes, the generated ZIP hash is
recorded for the release asset, and the ZIP downloaded from the GitHub Release
validates from an extracted source tree.
