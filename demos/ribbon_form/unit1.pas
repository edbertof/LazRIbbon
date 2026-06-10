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

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ActnList, Menus,
  LazRibbon_Form, LazRibbon_Core, LazRibbon_SkinManager, LazRibbon_Backstage,
  LazRibbon_Buttons, LazRibbon_Groups, LazRibbon_Tabs, LazRibbon_RibbonExtItems,
  LazRibbon_Popup;

type
  TForm1 = class(TLazRibbonForm)
    ActionList1: TActionList;
    ActionNew: TAction;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionHelp: TAction;
    ActionMouse: TAction;
    ActionTouch: TAction;
    LazRibbon1: TLazRibbon;
    LazRibbonBackstageView1: TLazRibbonBackstageView;
    LazRibbonBackstagePageNovo: TLazRibbonBackstagePage;
    LazRibbonBackstagePageAbrir: TLazRibbonBackstagePage;
    LazRibbonBackstagePageRecentes: TLazRibbonBackstagePage;
    LazRibbonBackstageRecentList1: TLazRibbonBackstageRecentList;
    LazRibbonLargeButtonNew: TLazRibbonLargeButton;
    LazRibbonLargeButtonOpen: TLazRibbonLargeButton;
    LazRibbonPaneArquivo: TLazRibbonPane;
    LazRibbonPaneTema: TLazRibbonPane;
    LazRibbonSkinGalleryItem1: TLazRibbonSkinGalleryItem;
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbonSmallButtonSave: TLazRibbonSmallButton;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonTabAppearance: TLazRibbonTab;
    PopupTouchMouse: TPopupMenu;
    MenuMouse: TMenuItem;
    MenuTouch: TMenuItem;
    procedure ActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LazRibbon1HelpButtonClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  { These assignments are also saved in the .lfm. They are repeated here only
    to make the demo robust if a developer removes the references in the Object
    Inspector while experimenting. }
  Ribbon := LazRibbon1;
  SkinManager := LazRibbonSkinManager1;
  LazRibbon1.SkinManager := LazRibbonSkinManager1;
  LazRibbon1.QuickAccessToolBar.Position := qapTitleBar;
  LazRibbonBackstageView1.SkinManager := LazRibbonSkinManager1;
  LazRibbonBackstageRecentList1.SkinManager := LazRibbonSkinManager1;
end;

procedure TForm1.ActionExecute(Sender: TObject);
begin
  if Sender is TAction then
    ShowMessage(TAction(Sender).Caption);
end;

procedure TForm1.LazRibbon1HelpButtonClick(Sender: TObject);
begin
  ShowMessage('Ajuda do TLazRibbonForm');
end;

end.
