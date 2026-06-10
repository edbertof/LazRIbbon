{*******************************************************************************
*                                                                              *
*  LazRibbon                                                                   *
*                                                                              *
*  License: Modified LGPL with linking exception, preserving original          *
*           LazToolbar/LazRibbon notices where applicable.                     *
*           See LICENSE.txt in this distribution.                              *
*                                                                              *
*  This header was normalized as part of the LazRibbon 0.3.55 project hygiene  *
*  pass. Functional code was not intentionally changed in this unit.           *
*                                                                              *
*******************************************************************************}

unit Unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, Dialogs, ActnList,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_Buttons, LazRibbon_Backstage, LazRibbon_SkinManager, LazRibbon_SkinDefinition;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    actNew: TAction;
    actOpen: TAction;
    actClose: TAction;
    actExit: TAction;
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbon1: TLazRibbon;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonPaneDatabase: TLazRibbonPane;
    LazRibbonLargeButtonNew: TLazRibbonLargeButton;
    LazRibbonLargeButtonOpen: TLazRibbonLargeButton;
    LazRibbonTabAppearance: TLazRibbonTab;
    LazRibbonBackstageView1: TLazRibbonBackstageView;
    LazRibbonBackstagePageInfo: TLazRibbonBackstagePage;
    LazRibbonBackstagePageRecent: TLazRibbonBackstagePage;
    LabelInfoTitle: TLabel;
    LabelInfoText: TLabel;
    LazRibbonBackstageRecentList1: TLazRibbonBackstageRecentList;
    procedure ActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RecentItemClick(Sender: TObject; Index: Integer; const Title, Detail: String);
  private
    function RecentIniFileName: String;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function TForm1.RecentIniFileName: String;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  { The list is designed in the .lfm. At runtime it is loaded from an INI file,
    when one exists. If no INI file exists yet, the design-time sample items
    remain visible. }
  LazRibbonBackstageRecentList1.StorageSection := 'RecentDatabases';
  LazRibbonBackstageRecentList1.MaxRecentItems := 25;
  if FileExists(RecentIniFileName) then
    LazRibbonBackstageRecentList1.LoadFromIniFile(RecentIniFileName);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  LazRibbonBackstageRecentList1.SaveToIniFile(RecentIniFileName);
end;

procedure TForm1.ActionExecute(Sender: TObject);
begin
  if Sender is TAction then
    ShowMessage('Action executada: ' + TAction(Sender).Caption)
  else
    ShowMessage('Action executada.');
end;

procedure TForm1.RecentItemClick(Sender: TObject; Index: Integer; const Title, Detail: String);
begin
  ShowMessage('Abrir recente: ' + Title + LineEnding + Detail);
end;

end.
