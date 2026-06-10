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
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, Menus, Dialogs,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_Buttons, LazRibbon_Backstage, LazRibbon_Popup,
  LazRibbon_SkinManager, LazRibbon_SkinDefinition;

type
  TForm1 = class(TForm)
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbonPopupMenu1: TLazRibbonPopupMenu;
    MenuItemNovo: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemOpcoes: TMenuItem;
    LazRibbon1: TLazRibbon;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonPaneMain: TLazRibbonPane;
    LazRibbonLargeButtonDemo: TLazRibbonLargeButton;
    LazRibbonBackstageView1: TLazRibbonBackstageView;
    LazRibbonBackstagePageInfo: TLazRibbonBackstagePage;
    LabelBackstageInfo: TLabel;
    LabelInfo: TLabel;
    ButtonBackstage: TButton;
    ButtonPopupMenu: TButton;
    ButtonEvent: TButton;
    procedure ApplicationButtonEvent(Sender: TObject);
    procedure PopupItemClick(Sender: TObject);
    procedure SetModeBackstage(Sender: TObject);
    procedure SetModePopup(Sender: TObject);
    procedure SetModeEvent(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.ApplicationButtonEvent(Sender: TObject);
begin
  ShowMessage('ApplicationButtonMode = abmEvent: evento executado.');
end;

procedure TForm1.PopupItemClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    ShowMessage('ApplicationMenu: ' + TMenuItem(Sender).Caption)
  else
    ShowMessage('ApplicationMenu.');
end;

procedure TForm1.SetModeBackstage(Sender: TObject);
begin
  LazRibbon1.ApplicationButton.Mode := abmBackstage;
  LabelInfo.Caption := 'Modo atual: abmBackstage. Clique em Arquivo para abrir/fechar o BackStage.';
end;

procedure TForm1.SetModePopup(Sender: TObject);
begin
  LazRibbon1.ApplicationButton.Mode := abmPopupMenu;
  LabelInfo.Caption := 'Modo atual: abmPopupMenu. Clique em Arquivo para abrir o menu popup.';
end;

procedure TForm1.SetModeEvent(Sender: TObject);
begin
  LazRibbon1.ApplicationButton.Mode := abmEvent;
  LabelInfo.Caption := 'Modo atual: abmEvent. Clique em Arquivo para disparar OnApplicationButtonClick.';
end;

end.
