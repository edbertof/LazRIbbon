# Manual Regression Checklist — LazRibbon 1.1.71

## Package compilation

1. Compile `packages/LazRibbonRuntime.lpk`.
2. Compile `packages/LazRibbonDesign.lpk`.

## Runtime smoke test

1. Open `demos/showcase/project1.lpi`.
2. Run the demo and confirm that no extra console/DOS window appears on Windows.
3. Confirm the window remains resizeable.
4. Minimize the window using the custom title-bar minimize button.
5. Restore the window from the Windows taskbar and confirm it returns normally.
6. Click `Selecionar imagem` and `Selecionar tabela`; confirm contextual headers remain separated.
7. Press `Alt`; confirm QAT KeyTips `1`, `2`, `3` appear only in the custom title bar.
8. Confirm normal tab KeyTips, contextual tab KeyTips and active-tab command KeyTips still appear.
9. Open `Arquivo` and confirm BackStage still covers the client area.
10. Use the skin gallery on `Exibir` and confirm the Ribbon updates.

## Design-time quick creation verbs

1. Open Lazarus with the design package installed.
2. Place or select a `TLazRibbon` component on a form.
3. Open the component-editor context menu.
4. Confirm the verbs appear:
   - `Contents editor...`
   - `Add basic tab`
   - `Add contextual tab`
5. Run `Add basic tab`. Confirm a new visible tab is created with one pane, one large button and one small button.
6. Run `Add contextual tab`. Confirm a new visible contextual tab is created with `Contextual = True`, `ContextualGroupCaption = Ferramentas Contextuais`, one pane and one starter command.
7. Save and reopen the form to confirm the generated nested components stream correctly.


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

## 1.1.63 design-time KeyTip validation

- Select a `TLazRibbon` in the Lazarus form designer.
- Run `Add starter Ribbon layout`.
- Run `Validate KeyTips` and confirm that the generated layout has no obvious duplicate KeyTips.
- Manually assign the same KeyTip to two visible commands in the same tab and confirm that `Validate KeyTips` reports the collision.


## 1.1.64 staged KeyTips navigation

- Press Alt: confirm only root-level KeyTips appear: Application Button, visible tabs and QAT.
- Confirm active tab command KeyTips do not appear in the first stage.
- Press a tab KeyTip: confirm the tab is selected and only that tab's command KeyTips appear.
- Confirm title-bar QAT numbers are hidden in the command stage.
- Press Esc once from the command stage: confirm root-level KeyTips return.
- Press Esc again: confirm KeyTips are hidden.
- Run `Validate KeyTips` in design-time and confirm root and per-tab command scopes are treated separately.


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


## 1.1.69 KeyTips mouse/backspace check

- Press Alt to show the root KeyTips overlay, then click any Ribbon area with the mouse; confirm all KeyTips disappear and the click is processed normally.
- Press Alt, press a tab KeyTip to enter command-stage KeyTips, then click inside the Ribbon; confirm all KeyTips disappear.
- With QAT in the `TLazRibbonForm` title bar, press Alt and then click the title-bar QAT or title bar; confirm the KeyTips overlay closes.
- For a multi-character KeyTip such as `EX`, press `E`, then Backspace; confirm the overlay returns to the previous unfiltered command-stage KeyTips.

## 1.1.70 KeyTips Backspace capture check

1. Open `demos/showcase`.
2. Press `Alt`.
3. Press the KeyTip for `Inserir`.
4. Press `E`; only the remaining suffix `X` should be shown for `EX`.
5. Press Backspace; the overlay should return to `EX` and `PR`.
6. Press `E`, then `X`; the command should execute and close KeyTips.


## 1.1.71 stability pass

- Run `tools/check_project_consistency.ps1 -ExpectedVersion 1.1.71` before packaging when PowerShell is available.
- Confirm all demos remain GUI applications and do not show a console window on Windows.
- Confirm the 1.1.70 KeyTips Backspace test still passes.
- Confirm no runtime behavior changed from 1.1.70; this release is a regression/audit pass.
- Use `docs/quality/STABILITY_REGRESSION_PASS_1_1_71.md` as the current checklist.
