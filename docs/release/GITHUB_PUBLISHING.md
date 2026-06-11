# GitHub Publishing Guide

This guide describes the recommended public repository shape for LazRibbon.

## Repository contents

The repository should include:

- `packages/`
- `source/`
- `demos/`
- `tools/`
- `docs/`
- `README.md`
- `INSTALL.md`
- `CHANGELOG.md`
- `STATUS.md`
- `LICENSE.txt`
- `CONTRIBUTING.md`

Generated folders and local IDE files must stay out of the repository. The `.gitignore` already excludes common Lazarus and Free Pascal outputs.

## Suggested repository description

Lazarus/Free Pascal component package for Office-like Ribbon interfaces, including Ribbon controls, BackStage, Quick Access Toolbar, Ribbon forms, skins and design-time tooling.

## Before the first public push

1. Run `tools/check_project_consistency.ps1`.
2. Compile `LazRibbonRuntime.lpk` with Lazarus 4.8.
3. Compile `LazRibbonDesign.lpk` with Lazarus 4.8.
4. Run the manual checklist in `docs/quality/VALIDATION_LAZARUS_4_8.md`.
5. Generate a source ZIP with `tools/build_release_zip.ps1`.
6. Confirm the generated ZIP passes `tools/check_release_zip.ps1`.
7. Add showcase screenshots under `docs/assets/screenshots/`.
8. Create a GitHub release using the same version as the packages.

## Release title format

Use a title such as:

```text
LazRibbon 1.2.1 - Skin Editor base comparison report
```

## Release notes format

Recommended sections:

- Target environment
- Highlights
- Validation performed
- Known limitations
- Download

## Known limitations to mention

- Windows is the primary validation platform.
- Lazarus 4.8 is the active target.
- Skin Editor coverage is still evolving.
- The package aims for Office-like interfaces, not full DevExpress feature parity.

## Screenshots

Use screenshots that show real application state:

- main showcase Ribbon;
- BackStage covering the client area;
- Skin Gallery or Skin Selector;
- Skin Editor;
- component palette icons after installation.

Avoid screenshots that expose local private paths or unrelated project data.
