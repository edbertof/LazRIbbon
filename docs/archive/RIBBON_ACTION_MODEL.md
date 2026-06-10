# LazRibbon: modelo de comandos por Actions

O modelo recomendado é: uma ação, várias representações visuais.

## Fonte dos comandos

Use `TActionList` como catálogo principal de comandos da aplicação.

Exemplos:

```pascal
actNovo
actAbrir
actSalvar
actImprimir
actTouchMouseMode
```

Essas ações podem aparecer em vários lugares:

- botões do Ribbon;
- botões do BackStage;
- itens de PopupMenu;
- QuickAccessToolBar.

## QuickAccessToolBar

A QAT não deve ser entendida como uma toolbar de comandos próprios. Ela é uma lista de atalhos para `Actions` da aplicação.

```pascal
LazRibbon1.QuickAccessToolBar.CustomizeActionList := ActionList1;
LazRibbon1.QuickAccessToolBar.Items.AddAction(actNovo);
LazRibbon1.QuickAccessToolBar.Items.AddAction(actSalvar);
```

`CustomizeActionList` é o catálogo de ações que o usuário pode escolher para aparecer também na QAT. Essas ações não precisam existir como botões do Ribbon.

## Actions apenas na QAT

Algumas ações podem aparecer apenas na QuickAccessToolBar. Exemplo típico:

```pascal
actTouchMouseMode.Caption := 'Modo Toque/Mouse';
LazRibbon1.QuickAccessToolBar.Items.AddAction(actTouchMouseMode);
```

Essa action pode não estar em nenhuma aba do Ribbon. Isso é válido.

## Papel de Items

`QuickAccessToolBar.Items` representa o padrão inicial definido pelo programador.

Se existir configuração salva no INI, a configuração do usuário deve prevalecer.
Se não existir INI, os itens definidos no `.lfm` são usados como padrão.
