# LazRibbon Release-Candidate Preparation

Historical target: `2.0.0-rc3`

## Purpose

This document records the final 2.0 release-candidate gate that was used before the stable `2.0.0` promotion.

The current stable release notes are in `docs/release/RELEASE_2_0_0.md`.

## Version Fields

The release scripts intentionally separate two concepts:

- `-Version`: numeric Lazarus package version expected in `LazRibbonRuntime.lpk` and `LazRibbonDesign.lpk`.
- `-ReleaseVersion`: public ZIP/tag/release label, which may include a suffix such as `2.0.0-rc3`.

For the stable 2.0 release, use the numeric package version and the stable release label:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.0.0 -ReleaseVersion 2.0.0 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

## Required Gates

Before tagging or publishing `v2.0.0`, verify:

- `docs/release/API_FREEZE_READINESS_2_0.md` reports zero review gates and zero manual gates.
- `tools/verify_release_candidate.ps1` passes with the target package version and release label.
- `tools/verify_clean_checkout.ps1` validates an extracted source ZIP without using local generated files.
- `tools/capture_release_screenshots.ps1` regenerates the public README screenshots.
- `docs/release/RELEASE_2_0_0.md` is reviewed as the GitHub release note draft.
- The generated ZIP is stored in `D:\Ribbon4Lazarus\Releases` and its SHA256 is recorded.

## Allowed Changes After Stable 2.0

After `2.0.0`, changes should move to the next 2.x line unless they fix a release blocker:

- package compilation or installation blockers;
- IDE registration problems;
- demo compilation or startup failures;
- Skin Editor save/load blockers;
- BackStage, Quick Access Toolbar, KeyTip or Ribbon form regressions;
- release ZIP hygiene problems;
- documentation needed for installation, validation or first use.

## Deferred Work

The following should not block `2.0.0` unless they cause runtime or installation failure:

- splitting very large runtime units;
- replacing the custom XML parser;
- complete commercial Ribbon feature parity;
- full multiplatform custom window chrome;
- broader Skin Editor workflows beyond the current skin identity and Appearance model.
