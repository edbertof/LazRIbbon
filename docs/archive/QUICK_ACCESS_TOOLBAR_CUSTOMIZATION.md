# QuickAccessToolBar configurável

A partir da versão 0.1.37, a QuickAccessToolBar pode usar uma `TActionList` como fonte de comandos disponíveis para o menu de personalização.

Exemplo básico:

```pascal
LazRibbon1.QuickAccessToolBar.Visible := True;
LazRibbon1.QuickAccessToolBar.CustomizeActionList := ActionList1;
LazRibbon1.QuickAccessToolBar.AddAction(actNovo);
LazRibbon1.QuickAccessToolBar.AddAction(actAbrir);
LazRibbon1.QuickAccessToolBar.AddAction(actSalvar);
```

Com isso, o botão de customização da QuickAccessToolBar pode listar as ações de `ActionList1` e marcar as que já estão na barra.

## Persistência em INI

No `OnCreate` do formulário:

```pascal
LazRibbon1.QuickAccessToolBar.CustomizeActionList := ActionList1;
LazRibbon1.QuickAccessToolBar.LoadFromIniFile(
  ChangeFileExt(Application.ExeName, '.ini'),
  ActionList1
);
```

No `OnClose`:

```pascal
LazRibbon1.QuickAccessToolBar.SaveToIniFile(
  ChangeFileExt(Application.ExeName, '.ini')
);
```

O arquivo INI salva os nomes das Actions. Portanto, as Actions devem ter nomes estáveis, como `actNovo`, `actAbrir`, `actSalvar`.

## Regra de arquitetura

A QuickAccessToolBar deve referenciar comandos existentes, não duplicar lógica. O comando real deve estar em uma `TActionList`; o Ribbon, o BackStage, menus e QuickAccessToolBar devem apenas apresentar esse mesmo comando em lugares diferentes.
