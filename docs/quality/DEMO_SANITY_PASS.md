# Demo Sanity Pass — LazRibbon 1.1.71

Primary demo target remains `demos/showcase/project1.lpi`.

Validate:

1. The demo opens with `Modern Light`.
2. No extra console/DOS window appears when the demo is compiled/run on Windows.
3. The form uses `TLazRibbonForm` and remains resizeable.
4. Minimize the window from the custom title bar and restore it from the taskbar.
5. QAT appears in the custom title bar.
6. `Selecionar imagem` and `Selecionar tabela` can show simultaneous contextual groups.
7. `Limpar contexto` hides contextual tabs.
8. `Alt` shows KeyTips without duplicate QAT labels.
9. BackStage, ScreenTips and skin switching continue to work.

Additional design-time validation from 1.1.58/1.1.59 remains valid: inside Lazarus, select a `TLazRibbon` and test the `Add basic tab` and `Add contextual tab` component-editor verbs.


## 1.1.61 design-time starter layout checks

- Install/compile `LazRibbonDesign.lpk`.
- Drop a `TLazRibbon` on a new form.
- Use `Add starter Ribbon layout` from the component editor menu.
- Save, close and reopen the form.
- Confirm generated tabs, panes, commands and QAT items persist.
- Run the project and press Alt to verify generated KeyTips.

## 1.1.62 hotfix check

- Compile `LazRibbonDesign.lpk` and verify that `LazRibbon_Editor.pas` resolves `TLazRibbonBaseItem` through `LazRibbon_BaseItem`.
- Re-test `Add starter Ribbon layout`; behavior should be unchanged from 1.1.61.

## 1.1.63 design-time note

No demo runtime behavior changed in 1.1.63. The only new feature is the design-time `Validate KeyTips` component-editor verb.


## 1.1.64 staged KeyTips runtime note

Manual check: press Alt in `demos/showcase`. The first overlay should show Application Button, tab and QAT KeyTips only. Press a tab KeyTip such as `I` or `T`; the selected tab should open and the overlay should switch to command KeyTips for that tab only. QAT numbers should disappear during this second stage.


## 1.1.65 KeyTips command-execution check

- Press Alt.
- Press a tab KeyTip to enter the command stage.
- Press a command KeyTip.
- Confirm all KeyTips disappear immediately after the command is accepted.
- Confirm pressing a tab KeyTip still keeps KeyTips active and switches to that tab's command stage.


## 1.1.66 check

- Verify staged KeyTips still work.
- Verify multi-character command KeyTips such as `EX` and `PR` are accepted one character at a time.
- Verify the overlay hides before executing the command after the full KeyTip is typed.
- Verify `Validate KeyTips` reports prefix ambiguity such as `B` versus `BA` in the same scope.


## 1.1.67 check

- Compile `LazRibbonDesign.lpk` to confirm the `System.Copy` design-time hotfix.
- Re-run `Validate KeyTips` on a sample Ribbon with multi-character KeyTips.


## 1.1.69 check

- Press Alt in `demos/showcase`, then click inside the Ribbon; KeyTips should close.
- Press Alt, enter a tab command stage, then click inside the Ribbon; KeyTips should close.
- Type the first character of a multi-character KeyTip, then press Backspace; the typed prefix should be removed and matching KeyTips should redraw.

## 1.1.70 check

- In `demos/showcase`, press `Alt`, enter the `Inserir` tab, type `E` for the `EX` command prefix, then press Backspace.
- Expected: the command overlay returns to showing `EX` and `PR`, not only `X`.
- Then type `E` + `X`; expected: the command executes and KeyTips disappear.


## 1.1.71 stability pass

- Run `tools/check_project_consistency.ps1 -ExpectedVersion 1.1.71` before packaging when PowerShell is available.
- Confirm all demos remain GUI applications and do not show a console window on Windows.
- Confirm the 1.1.70 KeyTips Backspace test still passes.
- Confirm no runtime behavior changed from 1.1.70; this release is a regression/audit pass.
- Use `docs/quality/STABILITY_REGRESSION_PASS_1_1_71.md` as the current checklist.
