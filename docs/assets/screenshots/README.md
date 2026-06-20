# Screenshots

Public-facing LazRibbon screenshots live in this folder and are referenced from the top section of `README.md`.

Current release assets:

- `showcase-main.png`
- `showcase-backstage.png`
- `showcase-skins.png`
- `skin-editor.png`

Regenerate the set from a Lazarus 4.8 environment with:

```powershell
powershell -ExecutionPolicy Bypass -File tools/capture_release_screenshots.ps1
```

The capture script builds the package/demo/tool targets in a temporary Lazarus primary config path, opens the GUI targets, captures PNG files, and removes generated build artifacts when it finishes.

Screenshots should show real LazRibbon application state and must not expose private paths, customer data or unrelated applications.
