# LazRibbon 2.1.11 Release Notes

Status: Skin Editor validation decision panel.

## Target Environment

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

## Release Scope

`2.1.11` improves the standalone Skin Editor validation step. The goal is to
make the final page easier to act on: instead of presenting only counters and a
technical memo, the validation action area now starts with a save-readiness
status and groups what the user should do next.

The package metadata is set to `2.1.11`. The public ZIP/tag/release label is
also `2.1.11`.

## Highlights

- Runtime and design-time package metadata advanced to `2.1.11`.
- The validation actions area is now titled `Decisao e proximos passos`.
- The action memo starts with an explicit save-readiness status.
- Blocking issues, distribution-review warnings and next workflow steps are
  grouped separately.
- Read-only built-in base skins are shown as a review state instead of a green
  ready-to-save state.
- No new published component API was added.

## Validation Command

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.11 -ReleaseVersion 2.1.11 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Known Limitations

- The panel is still text-based. It is intentionally conservative so it can
  summarize validation decisions without adding another visual workflow surface.

## Validation Performed

- The standalone Skin Editor was rebuilt with Lazarus 4.8 using a temporary
  Lazarus profile with local package links.
- The release consistency audit should pass before publishing.
- The full package/tool/demo preflight should pass before tagging.

## Promotion Rule

Publish `2.1.11` only if the full preflight passes, the generated ZIP hash is
recorded for the release asset, and the ZIP downloaded from the GitHub Release
validates from an extracted source tree.
