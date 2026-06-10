# Começando com LazRibbon 0.2.0

## Instalação

1. Abra `packages/LazRibbonRuntime.lpk`.
2. Compile.
3. Abra `packages/LazRibbonDesign.lpk`.
4. Compile e instale.
5. Reinicie o Lazarus.

## Uso mínimo

Em um formulário, adicione:

- `TLazRibbon`;
- `TLazRibbonSkinManager`, se quiser skins;
- `TLazRibbonBackstageView`, se quiser BackStage.

## ApplicationButton

Use o subobjeto:

```pascal
LazRibbon1.ApplicationButton.Caption := 'Arquivo';
LazRibbon1.ApplicationButton.Visible := True;
LazRibbon1.ApplicationButton.Mode := abmBackstage;
LazRibbon1.ApplicationButton.BackstageView := LazRibbonBackstageView1;
```

## QuickAccessToolBar

Use `TActionList` como catálogo.

```pascal
LazRibbon1.QuickAccessToolBar.CustomizeActionList := ActionList1;
```

Itens em `QuickAccessToolBar.Items` são o padrão inicial. A configuração personalizada do usuário deve ser carregada de `.ini`.

## BackStage

O BackStage deve usar Actions ou LinkedItems sempre que possível.

```pascal
BackstageButton.Action := actAbrir;
```

ou:

```pascal
BackstageButton.LinkedItem := LazRibbonLargeButtonAbrir;
```
