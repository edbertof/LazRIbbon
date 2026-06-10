# LazRibbon 1.0.0

This is the first stable LazRibbon release for Lazarus 4.6.

## Target environment

- Lazarus 4.6
- LCL
- Windows as the primary validation platform

## Scope

Included in the 1.0 scope:

- Runtime and design-time package split
- `TLazRibbon` core component
- Tabs, panes and common Ribbon items
- BackStage view, pages, buttons and recent-files list
- Quick Access Toolbar baseline
- Skin manager, built-in skins and external `.lazskin` files
- Skin selector and gallery baseline
- `TLazRibbonForm` custom form shell baseline
- Basic skin editor workflow
- Demos and manual regression documentation

## Out of scope for 1.0

Deferred to future versions:

- Full parity with commercial Ribbon suites
- Deep refactoring of `LazRibbon_Core.pas` and `LazRibbon_Backstage.pas`
- Replacing the custom XML parser
- Global compiler-mode conversion
- Advanced gallery and editor infrastructure
- Complete cross-platform custom window chrome

## Release rule

The 1.0.x line should prioritize bug fixes, installation fixes and regressions. New feature work should start in a later development branch.
