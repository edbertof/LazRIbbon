# TLazRibbonForm - primeira versão

`TLazRibbonForm` é a primeira aproximação do LazRibbon para um formulário estilo Office/DevExpress.

Uso básico:

```pascal
TForm1 = class(TLazRibbonForm)
```

No Object Inspector, configure:

```text
Ribbon = LazRibbon1
SkinManager = LazRibbonSkinManager1
UseCustomTitleBar = True
TitleBarHeight = 32
ShowSystemButtons = True
TitleAlignment = taCenter
```

No formulário, coloque o `TLazRibbon` com `Align = alTop`.

## Modelo atual

A versão 0.3.0 usa uma barra de título interna desenhada na área cliente. Em tempo de execução, quando `UseCustomTitleBar = True`, o formulário usa `BorderStyle = bsNone`.

Esta estratégia é mais segura para a primeira versão porque evita mexer imediatamente na área não-cliente do Windows.

## Limitações

Esta ainda não é uma substituição completa de `TdxRibbonForm`.

Ficam para versões futuras:

- QAT integrada diretamente na barra de título;
- suporte avançado a redimensionamento por borda customizada;
- Aero Snap;
- tratamento fino de maximização/restauração;
- botões do sistema mais próximos do skin Office;
- opção Windows-only com non-client painting real.
