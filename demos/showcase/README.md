## 1.1.58 Showcase demo

This demo is the visual smoke test for LazRibbon. It combines Ribbon, Application Button, BackStage, Quick Access Toolbar in the custom title bar, ScreenTips, KeyTips, SkinGallery and contextual tabs.

The contextual-tab test has two groups:

- `Selecionar imagem` shows `Ferramentas de Imagem` / `Imagem`;
- `Selecionar tabela` shows `Ferramentas de Tabela` / `Tabela`;
- `Limpar contexto` hides all contextual tabs.

KeyTips check: press `Alt` and confirm that QAT numbers `1`, `2`, `3` appear only in the custom title bar. There must be no duplicated or overlapped QAT KeyTip near the `Arquivo` tab. The `TLazRibbonForm` resize behavior from 1.1.54 is intentionally left unchanged. The 1.1.58 design-time quick creation verbs are validated in the Lazarus IDE, not inside this runtime demo.


## 1.1.66 multi-character KeyTips check

The `Inserir` and `Revisão` tabs include command KeyTips with more than one character, such as `EX`, `PR`, `RV` and `HP`. Press `Alt`, choose the tab KeyTip, then type the command letters in sequence. The overlay should keep waiting after the first matching prefix and should disappear only after the complete command KeyTip is accepted.
