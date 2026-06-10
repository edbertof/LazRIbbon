# QuickAccessToolBar: permissões e imagens

A QuickAccessToolBar deve ser tratada como uma lista configurável de atalhos para ações do sistema.

## Propriedades principais

- `CustomizeActionList`: catálogo de ações que o usuário pode escolher no menu de personalização.
- `Items`: configuração inicial/padrão definida no `.lfm`.
- `Images`: ImageList própria da QuickAccessToolBar. Se vazia, a QAT usa `LazRibbon.Images`.

## Permissões

- `AllowCustomizing`: permite adicionar/remover ações pelo menu.
- `AllowQuickCustomizing`: permite abrir o menu pela setinha da QAT.
- `AllowReset`: permite mostrar/restaurar os itens padrão.
- `AllowPositionChange`: permite alternar acima/abaixo da Faixa de Opções.
- `AllowMinimizeRibbon`: permite minimizar/restaurar a Faixa de Opções pelo menu da QAT.

As antigas propriedades `ShowMoreCommandsItem`, `ShowPositionMenuItem`, `ShowMinimizeRibbonMenuItem` e `ShowResetToDefaultsItem` continuam existindo. A regra prática é:

```text
Allow* = controla se o recurso é permitido
Show*  = controla se o item aparece quando o recurso é permitido
```

## Modelo recomendado

Configure ações em um `TActionList`; defina alguns itens iniciais em `QuickAccessToolBar.Items`; salve/carregue a configuração do usuário por INI.
