# QuickAccessToolBar

A `QuickAccessToolBar` é um subobjeto persistente de `TLazRibbon`. Ela aparece no Object Inspector como propriedade expansível.

Uso básico:

```pascal
LazRibbon1.QuickAccessToolBar.Visible := True;
LazRibbon1.QuickAccessToolBar.ShowCustomizeButton := True;
```

Cada item pode ser configurado diretamente, por `Action` ou por `LinkedItem`:

```pascal
LazRibbon1.QuickAccessToolBar.Items[0].Action := actNovo;
LazRibbon1.QuickAccessToolBar.Items[1].LinkedItem := LazRibbonLargeButtonAbrir;
```

## Propriedades visuais

- `ButtonFrameStyle`
  - `qfsHotOnly`: botões ficam planos e mostram fundo/moldura apenas no hover/pressed. É o padrão.
  - `qfsAlways`: desenha a face dos botões sempre.
- `ButtonSize`
  - `0`: tamanho automático.
  - `> 0`: tamanho manual, limitado internamente.
- `Spacing`
  - Espaçamento horizontal entre botões.
- `FallbackGlyphStyle`
  - `qfgOfficeGlyphs`: desenha pequenos ícones vetoriais quando não houver `ImageList`/`ImageIndex`. É o padrão.
  - `qfgCaptionInitial`: preserva o comportamento antigo, desenhando a primeira letra do comando.
  - `qfgNone`: não desenha fallback; use quando todos os itens têm ícones reais.

## Recomendação

Para uma aparência mais próxima do Office, use:

```pascal
LazRibbon1.QuickAccessToolBar.ButtonFrameStyle := qfsHotOnly;
LazRibbon1.QuickAccessToolBar.ButtonSize := 0;
LazRibbon1.QuickAccessToolBar.Spacing := 2;
```


## Ícones

A QuickAccessToolBar deve ser usada preferencialmente com ícones, não com texto. Em aplicações reais, associe uma `ImageList` ao `TLazRibbon.Images` e defina `ImageIndex` nas `Actions`, nos `LinkedItem` ou diretamente nos itens da QuickAccessToolBar.

Quando não houver `ImageList`, o LazRibbon agora usa `FallbackGlyphStyle = qfgOfficeGlyphs` para desenhar pequenos glifos vetoriais de fallback para comandos comuns como Novo, Abrir, Salvar, Desfazer, Refazer e Imprimir. Isso evita a aparência provisória baseada em letras.
