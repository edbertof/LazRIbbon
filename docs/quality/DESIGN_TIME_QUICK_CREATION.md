# Design-time quick creation verbs

Introduced in LazRibbon 1.1.58 and extended in LazRibbon 1.1.61, 2.1.15 and 2.1.16.

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
- `TLazRibbonSkinManager` created or reused and assigned to the Ribbon;
- `TLazRibbonBackstageView` created or reused and assigned to `TLazRibbon.BackstageView`;
- BackStage starter pages, page navigation buttons, a separator and bottom command entries;
- Quick Access Toolbar enabled in the title bar;
- QAT entries linked to generated `Novo`, `Abrir` and `Salvar` commands;
- normal tabs `Início`, `Inserir` and `Exibir`;
- one contextual tab `Imagem` under `Ferramentas de Imagem`;
- panes, large/small commands, KeyTips and ScreenTip metadata.

It is intentionally a scaffold, not a framework generator. The developer must still assign actions, images, event handlers, persistence and application-specific behavior.

## 2.1.15 starter-composition check

- Compile `LazRibbonDesign.lpk`.
- Drop a `TLazRibbon` on a normal Lazarus form.
- Run `Add starter Ribbon layout`.
- Confirm that a `TLazRibbonSkinManager` exists and is assigned to `TLazRibbon.SkinManager`.
- Confirm that a `TLazRibbonBackstageView` exists, is assigned to `TLazRibbon.BackstageView`, uses `OverlayMode = bomCoverClientArea` and contains starter page buttons in `Buttons`.
- Confirm that the existing Ribbon tabs, QAT entries and KeyTips are still generated.

## 2.1.16 BackStage composition commands

The `TLazRibbonBackstageView` component editor adds these direct design-time commands:

- `Add BackStage page` creates a content page and its navigation entry, assigns a unique component name and selects the page in the Object Inspector.
- `Add BackStage command` appends a command entry to `Buttons`.
- `Add BackStage separator` appends a structural separator to `Buttons`.
- `Link to Ribbon on this form` finds the form's Ribbon, assigns the canonical `TLazRibbon.BackstageView` link, inherits its `SkinManager` and applies the Office-like client-area overlay defaults.

These commands compose the existing public model and do not introduce duplicate properties or a second BackStage ownership path.

## 1.1.62 hotfix check

- Compile `LazRibbonDesign.lpk` and verify that `LazRibbon_Editor.pas` resolves `TLazRibbonBaseItem` through `LazRibbon_BaseItem`.
- Re-test `Add starter Ribbon layout`; behavior should be unchanged from 1.1.61.
