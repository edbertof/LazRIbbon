# Design-time quick creation verbs

Introduced in LazRibbon 1.1.58 and extended in LazRibbon 1.1.61.

When `LazRibbonDesign.lpk` is installed, the `TLazRibbon` component editor exposes two scaffold actions:

- `Add basic tab`
- `Add contextual tab`
- `Add starter Ribbon layout`

`Add basic tab` creates:

- one `TLazRibbonTab`;
- one `TLazRibbonPane`;
- one `TLazRibbonLargeButton`;
- one `TLazRibbonSmallButton`;
- starter captions, KeyTips and ScreenTip metadata.

`Add contextual tab` creates:

- one contextual `TLazRibbonTab`;
- `ContextualGroupCaption = Ferramentas Contextuais`;
- a contextual color;
- one pane;
- one starter contextual command.

These actions are scaffolding helpers. They do not replace the existing contents editor and they do not assign application actions, images or business logic automatically.


## 1.1.59 hotfix

The 1.1.59 build fixes compilation of the design-time package by using the inherited `Designer` property in `TLazRibbonEditor.MarkDesignerModified`. The quick creation verbs introduced in 1.1.58 are otherwise unchanged.


## Add starter Ribbon layout

Introduced in LazRibbon 1.1.61.

This design-time verb creates a fuller starter structure for a new application:

- Application Button captioned `Arquivo`;
- Quick Access Toolbar enabled in the title bar;
- QAT entries linked to generated `Novo`, `Abrir` and `Salvar` commands;
- normal tabs `Início`, `Inserir` and `Exibir`;
- one contextual tab `Imagem` under `Ferramentas de Imagem`;
- panes, large/small commands, KeyTips and ScreenTip metadata.

It is intentionally a scaffold, not a framework generator. The developer must still assign actions, images, event handlers, persistence and application-specific behavior.

## 1.1.62 hotfix check

- Compile `LazRibbonDesign.lpk` and verify that `LazRibbon_Editor.pas` resolves `TLazRibbonBaseItem` through `LazRibbon_BaseItem`.
- Re-test `Add starter Ribbon layout`; behavior should be unchanged from 1.1.61.
