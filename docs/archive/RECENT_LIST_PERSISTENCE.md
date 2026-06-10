# TLazRibbonBackstageRecentList: rolagem e persistência

A partir da versão 0.1.34, `TLazRibbonBackstageRecentList` possui barra de rolagem interna e métodos simples para persistir a lista de recentes em arquivo INI.

## Propriedades novas

```pascal
property ScrollBarMode: TLazRibbonBackstageRecentScrollBarMode; // rsmAuto, rsmAlways, rsmNever
property MaxRecentItems: Integer; // 20 por padrão; 0 = sem limite
property StorageSection: String; // seção usada no INI; padrão = RecentFiles
```

## Métodos novos

```pascal
procedure AddRecent(const ATitle, ADetail: String);
procedure DeleteRecent(AIndex: Integer);
procedure ClearRecent;
procedure LoadFromIniFile(const AFileName: String; const ASection: String = '');
procedure SaveToIniFile(const AFileName: String; const ASection: String = '');
```

## Exemplo

```pascal
procedure TForm1.FormCreate(Sender: TObject);
begin
  RecentList.StorageSection := 'RecentDatabases';
  RecentList.MaxRecentItems := 25;
  RecentList.LoadFromIniFile(ChangeFileExt(Application.ExeName, '.ini'));
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  RecentList.SaveToIniFile(ChangeFileExt(Application.ExeName, '.ini'));
end;

procedure TForm1.OpenDatabase(const AFileName: String);
begin
  RecentList.AddRecent(ExtractFileName(AFileName), AFileName);
end;
```

O demo `demos/backstage_recent_files` foi atualizado para mostrar o uso em design-time e a persistência no fechamento da aplicação.
