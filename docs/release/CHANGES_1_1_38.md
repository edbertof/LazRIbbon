# LazRibbon 1.1.38 - Modern visual skin pass

## Objective

Improve the perceived visual maturity of the package without changing the core Ribbon drawing architecture.

## Changes

- Added `sbsModernLight` to `TLazRibbonBuiltInSkin`.
- Added `ModernLight` / `Modern Light` mapping helpers.
- Added a restrained light palette with softer surfaces, weaker borders and a single blue accent.
- Kept the new skin palette-driven by excluding it from the post-palette legacy appearance reset used by older Office-style skins.
- Updated the skins gallery demo to open with `Modern Light` selected.
- Updated `LazRibbonRuntime.lpk` and `LazRibbonDesign.lpk` to 1.1.38.

## Regression focus for Lazarus

1. Compile `LazRibbonRuntime.lpk`.
2. Compile `LazRibbonDesign.lpk`.
3. Open the skins gallery demo and confirm that `Modern Light` appears in the skin list.
4. Select `Modern Light` through `TLazRibbonSkinManager`, `TLazRibbonSkinSelector` and `TLazRibbonSkinGalleryItem`.
5. Confirm that the Ribbon, panes, BackStage and recent files list update consistently.

## Deliberate non-changes

No core geometry, keyboard navigation, action model or design-time registration logic was changed in this pass. The goal was visual polish with low regression risk.
