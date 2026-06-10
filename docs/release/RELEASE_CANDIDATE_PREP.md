# LazRibbon release-candidate preparation

Version: 0.3.64
Target: Lazarus 4.6 / LCL / Windows primary validation

## Purpose

This document defines the stabilization gate for moving LazRibbon toward a future 1.0 release. The goal of 1.0 is a stable and installable Ribbon component suite for Lazarus 4.6, not feature parity with commercial Ribbon suites.

## Feature-freeze rule

From 0.3.64 onward, new features should be deferred unless they fix a release blocker. Accepted changes should be limited to:

- package installation failures;
- design-time registration failures;
- demo compilation failures;
- BackStage regressions;
- SkinManager / SkinSelector / SkinGallery regressions;
- Quick Access Toolbar regressions;
- `TLazRibbonForm` regressions;
- documentation needed for installation or first use.

Large refactorings are explicitly deferred until after 1.0.

## 1.0 minimum gate

Before declaring a 1.0 release candidate, verify:

1. `packages/LazRibbonRuntime.lpk` compiles in Lazarus 4.6.
2. `packages/LazRibbonDesign.lpk` compiles and installs in Lazarus 4.6.
3. The IDE rebuilds/restarts and shows the LazRibbon palette.
4. The following demos open and compile:
   - `demos/basic/project1.lpi`
   - `demos/actions/project1.lpi`
   - `demos/application_button/project1.lpi`
   - `demos/backstage/project1.lpi`
   - `demos/backstage_recent_files/project1.lpi`
   - `demos/quick_access_toolbar/project1.lpi`
   - `demos/ribbon_form/project1.lpi`
   - `demos/skins_gallery/project1.lpi`
   - `demos/skin_editor_sample/project1.lpi`
5. `tools/LazRibbonSkinEditor/LazRibbonSkinEditor.lpi` opens and compiles.
6. The BackStage selected-item hover behavior remains stable.
7. Built-in skins can be switched at runtime.
8. A `.lazskin` file can be loaded and saved.
9. No generated `.exe`, `.ppu`, `.o`, `.obj`, `.compiled`, `.rsj`, `.lps`, `bin/` or `lib/` artifacts are included in the release ZIP.

## Known deferred work

The following items should not block 1.0 unless they cause runtime failure:

- splitting `LazRibbon_Core.pas`;
- splitting `LazRibbon_Backstage.pas`;
- replacing the custom XML parser;
- converting all units to a single compiler mode;
- full feature parity with DevExpress or Microsoft Office;
- advanced Ribbon item gallery infrastructure;
- full multiplatform implementation of custom window chrome.

## Release-candidate naming

Recommended sequence:

- `0.3.x`: stabilization builds;
- `0.9.0`: first feature-frozen release-candidate branch;
- `1.0.0`: first stable release after the manual regression checklist passes.
