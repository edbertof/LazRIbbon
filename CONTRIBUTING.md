# Contributing to LazRibbon

Thank you for taking an interest in LazRibbon. The project is currently focused on a stable Lazarus 4.8 baseline, distribution hygiene, and controlled improvements to the Ribbon, BackStage and skin tooling.

## Target environment

- Lazarus 4.8
- The Free Pascal version bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

Other platforms or Lazarus versions may work, but changes should be validated against the active target before being proposed as generally supported.

## Local setup

1. Open `packages/LazRibbonRuntime.lpk` in Lazarus.
2. Compile the runtime package.
3. Open `packages/LazRibbonDesign.lpk`.
4. Compile and install the design-time package.
5. Rebuild and restart Lazarus.
6. Open at least `demos/showcase/project1.lpi` as a smoke test.

## Change discipline

- Keep changes small and focused.
- Avoid broad rewrites of `LazRibbon_Core.pas` unless there is a clear extraction plan.
- Preserve existing `.lfm` compatibility unless the migration is explicit and documented.
- Do not commit generated `lib`, `bin`, `backup`, `.ppu`, `.o`, `.compiled`, `.lps`, `.exe`, `.res` or `packagefiles.xml` files.
- Update `CHANGELOG.md` for user-visible, packaging, design-time or compatibility changes.

## Validation before sharing

Run the source-tree audit before packaging:

```powershell
powershell -ExecutionPolicy Bypass -File tools/check_project_consistency.ps1
```

Build a clean source ZIP with:

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_release_zip.ps1
```

The release ZIP must pass `tools/check_release_zip.ps1` and contain source, package files, demos, tools and documentation only.
