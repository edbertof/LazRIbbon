# LazRibbon RC1 candidate

Version: 0.3.66
Target environment: Lazarus 4.6 / LCL / Windows primary validation

## Purpose

This build marks the current LazRibbon package as the first candidate for the 1.0 release-candidate track. It is not yet the final 1.0 release. It is a stabilization build intended for manual validation.

## Scope freeze

The scope for the initial 1.0 line is frozen around the currently available components and tools:

- `TLazRibbon`;
- runtime/design-time package split;
- tabs, panes and basic Ribbon items;
- BackStage view, pages, commands and recent-files list;
- Quick Access Toolbar baseline;
- popup menu support;
- `TLazRibbonSkinManager`;
- built-in and external `.lazskin` support;
- Skin selector and Skin gallery baseline;
- `TLazRibbonForm`;
- `LazRibbonSkinEditor`;
- demos and minimal documentation.

## Allowed changes after this build

Only changes in the following categories should be accepted before 1.0:

1. Package compilation or installation blockers.
2. IDE registration problems.
3. Demo compilation failures.
4. BackStage regressions, especially selected-item/hover behavior.
5. SkinManager, SkinSelector, SkinGallery or `.lazskin` regressions.
6. Quick Access Toolbar regressions.
7. `TLazRibbonForm` regressions.
8. Documentation needed for installation, first use or release validation.
9. Release ZIP hygiene issues.

## Deferred until after 1.0

The following are explicitly deferred:

- splitting `LazRibbon_Core.pas`;
- splitting `LazRibbon_Backstage.pas`;
- replacing the custom XML parser;
- converting all units to a single compiler mode;
- full DevExpress/Office feature parity;
- complete gallery infrastructure for all item types;
- complete multiplatform custom window chrome;
- large API-breaking changes.

## Required validation

Before promoting this line to a formal release candidate, run the manual checklist in:

```text
docs/quality/MANUAL_REGRESSION_CHECKLIST.md
```

Minimum validation:

- compile `packages/LazRibbonRuntime.lpk`;
- compile and install `packages/LazRibbonDesign.lpk`;
- verify the LazRibbon palette appears in Lazarus 4.6;
- compile/open the main demos listed in the checklist;
- compile/open `tools/LazRibbonSkinEditor`;
- switch built-in skins in runtime demos;
- load/save a `.lazskin` file;
- verify BackStage hover/selection behavior remains stable;
- verify the ZIP contains no generated binaries or temporary build artifacts.

## Release decision

If the checklist passes without blockers, the next build may become a formal release candidate branch, for example `0.9.0-rc1`, or continue with minor `0.3.x` stabilization fixes if issues remain.
