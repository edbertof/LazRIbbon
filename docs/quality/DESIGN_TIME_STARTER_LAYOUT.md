# Design-time starter Ribbon layout

Introduced in LazRibbon 1.1.61 and expanded in LazRibbon 2.1.15.

The `TLazRibbon` component editor now includes `Add starter Ribbon layout`. It is intended for the first five minutes of a new Ribbon-based form, when the developer wants a reasonable structure without manually adding every tab, pane and button.

The generated scaffold includes:

- Application Button: `Arquivo`;
- a `TLazRibbonSkinManager` linked to the Ribbon;
- a `TLazRibbonBackstageView` linked through `TLazRibbon.BackstageView`;
- BackStage starter pages: `Informações`, `Novo`, `Abrir`;
- BackStage navigation and command entries through `TLazRibbonBackstageView.Buttons`;
- Quick Access Toolbar in the custom title bar;
- linked QAT commands: `Novo`, `Abrir`, `Salvar`;
- normal tabs: `Início`, `Inserir`, `Exibir`;
- contextual tab: `Imagem`;
- contextual group: `Ferramentas de Imagem`;
- panes and starter commands with KeyTips and ScreenTips.

Manual regression checks:

1. Install `LazRibbonDesign.lpk`.
2. Drop a `TLazRibbon` on a form.
3. Right-click the component and choose `Add starter Ribbon layout`.
4. Confirm that the generated structure appears in the visual designer.
5. Save, close and reopen the form.
6. Confirm that generated SkinManager, BackStage, tabs, panes, buttons and QAT items persist in the `.lfm`.
7. Compile a small project and press Alt to verify generated KeyTips.
8. Click `Arquivo` and confirm that the generated BackStage opens.

## 1.1.62 hotfix check

- Compile `LazRibbonDesign.lpk` and verify that `LazRibbon_Editor.pas` resolves `TLazRibbonBaseItem` through `LazRibbon_BaseItem`.
- Re-test `Add starter Ribbon layout`; behavior should be unchanged from 1.1.61.
