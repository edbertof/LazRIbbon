# LazRibbon 2.1.9 Release Notes

Status: Skin Editor palette map preview.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.9` improves the standalone Skin Editor color-editing workflow. The goal is
to make the `Cores do Ribbon` page more immediate: while a skin author changes
the simple palette, the editor now shows representative Ribbon, command,
BackStage and contrast states from that palette.

The package metadata is set to `2.1.9`. The public ZIP/tag/release label is
also `2.1.9`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.9`.
- The `Cores do Ribbon` page now includes a visual palette map.
- The palette map draws Ribbon tabs, pane body/caption, normal/hover/active
  command states and BackStage selected navigation state from the active skin.
- Key color pairs show contrast ratios next to the editable palette colors.
- The new preview controls are stored in `uSkinEditorMain.lfm` so the Skin
  Editor layout remains visible at design time.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.9 -ReleaseVersion 2.1.9 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The palette map is a fixed Canvas preview. It is intended as immediate color
  feedback, while the live Ribbon preview above the editor remains the
  interactive validation surface.

## Validation Performed

- The standalone Skin Editor was rebuilt with Lazarus 4.8 using a temporary
  Lazarus profile with local package links.
- The release consistency audit should pass before publishing.
- The full package/tool/demo preflight should pass before tagging.

## Promotion Rule

Publish `2.1.9` only if the full preflight passes, the generated ZIP hash is
recorded for the release asset, and the ZIP downloaded from the GitHub Release
validates from an extracted source tree.
