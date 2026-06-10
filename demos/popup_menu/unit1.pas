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
  Classes, SysUtils, Forms, Controls, Graphics, Menus,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_Buttons, LazRibbon_Popup;

type
  TForm1 = class(TForm)
    LazRibbon1: TLazRibbon;
    LazRibbonPopupMenu1: TLazRibbonPopupMenu;
    MenuItemNovo: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemSalvar: TMenuItem;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonPaneClipboard: TLazRibbonPane;
    LazRibbonLargeButtonPaste: TLazRibbonLargeButton;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.
