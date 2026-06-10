# Lazarus 4.8 Validation Checklist

Use this checklist before publishing a new source ZIP or pushing a public repository update.

## Environment

- Lazarus reports version 4.8.
- The bundled Free Pascal compiler is used.
- The validation platform is Windows.
- The source tree does not contain generated build output.

## Packages

1. Open `packages/LazRibbonRuntime.lpk`.
2. Compile the runtime package.
3. Open `packages/LazRibbonDesign.lpk`.
4. Compile the design-time package.
5. Install the design-time package.
6. Rebuild and restart Lazarus.
7. Confirm the `LazRibbon` component palette is visible.

## Component palette

Confirm that visible palette icons exist for:

- `TLazRibbon`
- `TLazRibbonPopupMenu`
- `TLazRibbonBackstageView`
- `TLazRibbonBackstagePage`
- `TLazRibbonBackstageRecentList`
- `TLazRibbonSkinManager`
- `TLazRibbonSkinSelector`

## Showcase demo

Open `demos/showcase/project1.lpi` and verify:

- the project builds without errors;
- no extra console window appears;
- the main Ribbon window opens;
- title-bar Quick Access Toolbar buttons render in the custom title bar;
- the `Arquivo` button opens BackStage;
- BackStage closes and returns to the Ribbon;
- contextual tabs can be shown and hidden;
- ScreenTips appear for commands that define them;
- skin switching changes the Ribbon appearance.

## KeyTips

With the showcase focused:

- press `Alt` and confirm root KeyTips appear;
- use a tab KeyTip and confirm command-stage KeyTips appear;
- verify multi-character KeyTips still work;
- press `Backspace` while typing a multi-character KeyTip prefix;
- press `Esc` once to return to root stage and again to hide KeyTips;
- click with the mouse and confirm KeyTips are cancelled.

## Skin tooling

- Open `tools/LazRibbonSkinEditor/LazRibbonSkinEditor.lpi`.
- Build the Skin Editor.
- Open an existing `.skin` or `.lazskin` sample.
- Create a new skin based on an existing skin.
- Save as `.skin`.
- Confirm identity icon data can be embedded in the XML.
- Confirm `TLazRibbonSkinManager` loads external `.skin` files from `.\Skins` when present.

## Release package

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_release_zip.ps1
```

The generated ZIP must pass the release ZIP audit and must not include generated compiler output, executables, nested ZIP files or local IDE state.
