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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, Menus,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups,
  LazRibbon_Buttons, LazRibbon_SkinManager;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    ActionNew: TAction;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionUndo: TAction;
    ActionRedo: TAction;
    ActionPrint: TAction;
    ActionEmail: TAction;
    ActionTouchMouse: TAction;
    ActionTouchModeMouse: TAction;
    ActionTouchModeTouch: TAction;
    PopupTouchMouse: TPopupMenu;
    MenuMouse: TMenuItem;
    MenuTouch: TMenuItem;
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbon1: TLazRibbon;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonPaneFile: TLazRibbonPane;
    LazRibbonLargeButtonNew: TLazRibbonLargeButton;
    LazRibbonLargeButtonOpen: TLazRibbonLargeButton;
    LazRibbonSmallButtonSave: TLazRibbonSmallButton;
    LazRibbonSmallButtonUndo: TLazRibbonSmallButton;
    LazRibbonSmallButtonTouchMouse: TLazRibbonSmallButton;
    procedure ActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure QuickAccessCustomize(Sender: TObject);
    procedure QuickAccessMoreCommands(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.ActionExecute(Sender: TObject);
begin
  if Sender is TAction then
    ShowMessage('Ação executada: ' + TAction(Sender).Caption)
  else
    ShowMessage('Comando executado.');
end;

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

procedure TForm1.QuickAccessCustomize(Sender: TObject);
begin
  ShowMessage('Botão de customização da QuickAccessToolBar.');
end;

procedure TForm1.QuickAccessMoreCommands(Sender: TObject);
begin
  ShowMessage('Aqui abriria uma janela de personalização avançada da QuickAccessToolBar.');
end;

end.
