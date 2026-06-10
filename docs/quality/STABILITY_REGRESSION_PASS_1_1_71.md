# LazRibbon 1.1.71 — Stability and regression pass

This release is intentionally conservative. It does not add new runtime UI behavior. Its purpose is to make the current 1.1 line easier to validate before the next visual or design-time feature is added.

## Scope

Validated areas for manual testing:

1. Runtime package compilation.
2. Design-time package compilation.
3. Demo GUI subsystem configuration.
4. `TLazRibbonForm` resize/minimize/restore behavior.
5. Staged KeyTips navigation.
6. Multi-character KeyTips.
7. Backspace editing of a KeyTip prefix when focus is inside client controls.
8. QAT KeyTips in the custom title bar.
9. Contextual tab groups and contextual headers.
10. BackStage opening/closing.
11. Skin switching with `Modern Light` as the showcase baseline.
12. Design-time component-editor verbs.

## Non-scope

The following are deliberately not changed in 1.1.71:

- `TLazRibbonForm` custom chrome and resize strategy.
- KeyTips execution semantics.
- Contextual tab drawing.
- BackStage layout.
- SkinManager/SkinSelector runtime behavior.
- Component palette icons.

## New release audit helper

The release adds `tools/check_project_consistency.ps1`. The script checks the source tree for preventable release mistakes:

- runtime and design packages match the expected version;
- every demo `.lpi` is marked as a Windows GUI application;
- no `packagefiles.xml` is present;
- no common generated Lazarus/FPC artifacts are present;
- no obvious local machine paths are present in text files.

The normal release builder now runs this consistency check before creating the ZIP.

## Manual smoke test matrix

### Packages

- Compile `packages/LazRibbonRuntime.lpk`.
- Compile `packages/LazRibbonDesign.lpk`.

### Showcase runtime

Open `demos/showcase/project1.lpi` and verify:

- no extra DOS/console window appears;
- the window is resizeable on all sides and corners;
- minimize/restore works from the custom title bar;
- QAT stays in the title bar;
- `Modern Light` is still usable;
- `Arquivo` opens BackStage;
- `Selecionar imagem` and `Selecionar tabela` can show simultaneous contextual groups;
- `Limpar contexto` hides all contextual groups.

### KeyTips

Verify:

- `Alt` shows only root KeyTips: Application Button, visible tabs and QAT;
- a tab KeyTip selects the tab and switches to command-stage KeyTips;
- QAT numbers disappear in command stage;
- command execution closes all KeyTips;
- multi-character KeyTips such as `EX` and `PR` work character by character;
- `Backspace` removes the typed prefix and redraws the previous command-stage overlay;
- mouse click cancels the KeyTips mode.

### Design-time

Inside Lazarus:

- select a `TLazRibbon`;
- run `Add basic tab`;
- run `Add contextual tab`;
- run `Add starter Ribbon layout`;
- run `Validate KeyTips`;
- save, close and reopen the form to confirm generated nested components stream correctly.
