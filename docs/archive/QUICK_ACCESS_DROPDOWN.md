# QuickAccessToolBar e botões DropDown

A QuickAccessToolBar não cria comandos próprios. Ela representa comandos da aplicação.

Para comandos simples, use `Action`:

```pascal
LazRibbon1.QuickAccessToolBar.Items.Add.Action := actSalvar;
```

Para comandos com comportamento visual próprio, especialmente botões DropDown, use `LinkedItem`:

```pascal
LazRibbon1.QuickAccessToolBar.Items.Add.LinkedItem := LazRibbonSmallButtonTouchMouse;
```

Quando o `LinkedItem` for um botão do tipo `bkDropdown` ou `bkButtonDropdown` e tiver `DropdownMenu`, a QAT:

- desenha uma pequena seta no botão;
- abre o mesmo menu do item original ao clicar;
- usa Caption, Hint, Enabled e ImageIndex herdados do item vinculado.

Isso permite representar no QAT botões como “Modo Toque/Mouse”, que no Office aparece como um pequeno dropdown na barra de acesso rápido.
