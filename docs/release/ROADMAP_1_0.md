# LazRibbon 1.0 Roadmap

## Official target

- Lazarus 4.6
- LCL
- Windows as the primary validation platform

## 1.0 minimum scope

The 1.0 release should provide a stable and usable Ribbon suite for Lazarus 4.6, including:

- `TLazRibbon`
- `TLazRibbonBackstageView` and pages
- BackStage recent list
- Quick Access Toolbar baseline
- `TLazRibbonSkinManager`
- built-in and external `.lazskin` support
- `TLazRibbonSkinSelector` and skin gallery baseline
- `TLazRibbonForm` baseline
- basic `LazRibbonSkinEditor`
- runtime and design-time packages installable in Lazarus 4.6
- demos that compile after a clean checkout
- concise documentation for installation and demos

## Explicitly out of scope for 1.0

- full equivalence with DevExpress or Microsoft Office
- complete gallery framework for every item type
- complete cross-platform custom window frame behavior
- replacement of the internal XML parser
- large-scale refactor of `LazRibbon_Core.pas` or `LazRibbon_Backstage.pas`
- automatic conversion or support for proprietary DevExpress skin formats
- automated migration from all historical LazToolbar projects

## Release discipline

Before adding a new feature, check whether it is required for the 1.0 minimum scope. If not, defer it to post-1.0.

The current priority is:

1. Keep runtime/design packages compiling in Lazarus 4.6.
2. Keep demos compiling.
3. Avoid regressions in BackStage and skin rendering.
4. Improve documentation and installation reliability.
5. Only then add narrowly scoped features.

## Suggested path

- 0.3.58: Lazarus 4.6 target and 1.0 roadmap.
- 0.3.59: manual regression checklist.
- 0.3.60: demo compilation cleanup.
- 0.3.61: skin metadata/icons stabilization.
- 0.3.62: SkinEditor usability pass.
- 0.3.63: RibbonForm validation pass.
- 0.4.x: release-candidate hardening.
- 1.0.0: stable baseline release for Lazarus 4.6.
