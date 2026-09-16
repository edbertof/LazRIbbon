# LazRibbon 2.1.15 Release Notes

`2.1.15` improves the first-use design-time workflow for creating an Office-like
application shell.

The package metadata is set to `2.1.15`. The public ZIP/tag/release label is
also `2.1.15`.

## What changed

- The `TLazRibbon` component-editor verb `Add starter Ribbon layout` now creates
  or reuses a `TLazRibbonSkinManager` and assigns it to the Ribbon.
- The same starter action now creates or reuses a linked
  `TLazRibbonBackstageView`.
- The generated BackStage uses `OverlayMode = bomCoverClientArea`, navigation
  width and item height defaults that match the existing demos.
- The generated BackStage includes starter pages (`Informações`, `Novo`,
  `Abrir`) and page links created through `TLazRibbonBackstageView.Buttons`.
- The generated BackStage also includes a separator plus starter bottom command
  entries for `Opções` and `Sair`, and a `Salvar` command that keeps the
  BackStage open.
- The existing starter Ribbon tabs, panes, commands, KeyTips, ScreenTips and
  title-bar Quick Access Toolbar entries remain unchanged.

## Compatibility

No new published Object Inspector property was added. This is a design-time
experience improvement that uses the existing public component model:

- `TLazRibbon.SkinManager`
- `TLazRibbon.AppearanceSource`
- `TLazRibbon.BackstageView`
- `TLazRibbonBackstageView.Buttons`
- `TLazRibbonBackstagePage`

Existing projects are unaffected unless the developer explicitly runs the
starter-layout component-editor verb again.

## Validation

Run the full release-candidate preflight before publishing:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.15 -ReleaseVersion 2.1.15 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

Publish `2.1.15` only if the full preflight passes, the generated ZIP hash is
recorded in `docs/release/RELEASE_ZIP_AUDIT.md`, and the tag points to the same
commit as the public ZIP.
