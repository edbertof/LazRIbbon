# LazRibbon Support

LazRibbon is currently developed and validated for Lazarus 4.8, the Free Pascal
version bundled with Lazarus 4.8, LCL applications and Windows as the primary
validation platform.

## Before Opening An Issue

1. Confirm that both packages compile in order:
   `packages/LazRibbonRuntime.lpk`, then `packages/LazRibbonDesign.lpk`.
2. Rebuild and restart Lazarus after installing the design-time package.
3. Open `demos/showcase/project1.lpi` or the smallest relevant demo.
4. Run the consistency audit when working from source:

```powershell
powershell -ExecutionPolicy Bypass -File tools/check_project_consistency.ps1
```

## Good Support Reports

Please include:

- Lazarus version.
- Free Pascal version.
- Operating system and widgetset.
- LazRibbon version or Git commit.
- The package, tool or demo that reproduces the problem.
- Compiler output, screenshot or a minimal sample project when possible.

Use the Lazarus compatibility issue template when the problem involves package
installation, form designer loading, `.lfm` streaming, widgetset differences,
HiDPI behavior or the Skin Editor.

## Scope

Supported questions are focused on installing the package, composing Ribbon
interfaces, using BackStage/QAT/SkinManager/Skin Editor, and reporting defects
that can be reproduced from the included demos or a small sample project.
