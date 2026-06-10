# Modelo Action / LinkedItem no LazRibbon 0.2.0

A arquitetura recomendada passa a ser: uma ação, várias representações visuais.

## Fonte dos comandos

Use `TActionList` como catálogo central de comandos da aplicação.

Exemplo:

```pascal
actNovo
actAbrir
actSalvar
actImprimir
actTouchMouse
```

Essas ações podem aparecer em:

- botões do Ribbon;
- BackStage;
- QuickAccessToolBar;
- popup menus;
- menus tradicionais.

## Regra de prioridade

Para QAT e BackStage, a regra recomendada é:

```text
1. LinkedItem
2. Action
3. propriedades próprias do item
```

## Quando usar Action

Use `Action` quando o item representa um comando simples da aplicação.

Exemplo:

```pascal
QATItem.Action := actSalvar;
BackstageButton.Action := actSalvar;
```

## Quando usar LinkedItem

Use `LinkedItem` quando a representação original do comando já existe no Ribbon e possui comportamento próprio, por exemplo:

- DropDown;
- SplitButton futuro;
- Toggle;
- botão com menu próprio;
- botão com comportamento visual especial.

Exemplo:

```pascal
QATItem.LinkedItem := LazRibbonSmallButtonTouchMouse;
```

Se o botão original for DropDown, a QAT deve preservar o DropDown.

## QAT

A QAT não é dona dos comandos. Ela é uma coleção de atalhos para comandos.

- `CustomizeActionList` = catálogo de ações que o usuário pode escolher;
- `Items` = configuração inicial definida pelo programador no `.lfm`;
- `.ini` = configuração personalizada do usuário.

A QAT pode conter ações que não aparecem em nenhuma aba do Ribbon.

## BackStage

O BackStage também deve reutilizar ações e itens existentes. Evite duplicar eventos e captions manualmente.

Preferível:

```pascal
BackstageButton.Action := actAbrir;
```

ou, quando houver botão já existente no Ribbon:

```pascal
BackstageButton.LinkedItem := LazRibbonLargeButtonAbrir;
```

## Diretriz

Evite programar a mesma operação em dois lugares diferentes. A lógica deve ficar na Action; os componentes visuais apenas apresentam e executam essa Action.
