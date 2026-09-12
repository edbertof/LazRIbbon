# LazRibbon 2.1.12 Release Notes

Status: Skin Editor advanced property detail.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.12` improves the standalone Skin Editor `Ajuste avancado` page. The goal
is to make the complete `Appearance` inspector easier to understand without
adding new public component properties or changing the `.skin` file format.

The package metadata is set to `2.1.12`. The public ZIP/tag/release label is
also `2.1.12`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.12`.
- The advanced Appearance inspector preserves the selected property after
  filtering, editing or refreshing when the same item is still visible.
- Edit/reset actions stay disabled until a valid editable Appearance property
  is selected.
- The difference/detail panel shows the selected property's section, type,
  current value, base value and editing guidance.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.12 -ReleaseVersion 2.1.12 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The advanced inspector remains a generic RTTI editor. High-frequency skin
  edits should still be handled first through the palette pages and visual
  previews.

## Validation Performed

- The standalone Skin Editor was rebuilt with Lazarus 4.8 using a temporary
  Lazarus profile with local package links.
- The release consistency audit should pass before publishing.
- The full package/tool/demo preflight should pass before tagging.

## Promotion Rule

Publish `2.1.12` only if the full preflight passes, the generated ZIP hash is
recorded for the release asset, and the ZIP downloaded from the GitHub Release
validates from an extracted source tree.
