# QuickAccessToolBar: padrão inicial e configuração do usuário

A QuickAccessToolBar deve ser entendida como uma barra configurável pelo usuário final.

## Papéis

- `CustomizeActionList`: catálogo de ações disponíveis para personalização.
- `Items`: itens padrão definidos pelo programador no design-time / `.lfm`.
- Arquivo INI: configuração personalizada do usuário.

## Regra

Se existir configuração salva no INI, ela prevalece.
Se não existir, permanecem os itens definidos no `.lfm`.

Exemplo:

```pascal
procedure TForm1.FormCreate(Sender: TObject);
begin
  LazRibbon1.QuickAccessToolBar.CustomizeActionList := ActionList1;
  LazRibbon1.QuickAccessToolBar.LoadFromIniFile(
    ChangeFileExt(Application.ExeName, '.ini'),
    ActionList1
  );
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  LazRibbon1.QuickAccessToolBar.SaveToIniFile(
    ChangeFileExt(Application.ExeName, '.ini')
  );
end;
```

O retorno de `LoadFromIniFile` pode ser usado quando o programa precisar saber se havia configuração salva:

```pascal
if not LazRibbon1.QuickAccessToolBar.LoadFromIniFile(ConfigFile, ActionList1) then
  ; // mantém os itens definidos no design-time
```

O menu de personalização inclui a opção **Restaurar Barra de Acesso Rápido**, que volta aos itens padrão capturados do `.lfm`.
