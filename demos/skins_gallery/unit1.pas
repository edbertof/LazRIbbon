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
  Classes, SysUtils, Forms, Controls, Graphics,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_Buttons, LazRibbon_RibbonExtItems, LazRibbon_SkinManager,
  LazRibbon_SkinDefinition;

type
  TForm1 = class(TForm)
    LazRibbonSkinManager1: TLazRibbonSkinManager;
    LazRibbon1: TLazRibbon;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonPaneCommands: TLazRibbonPane;
    LazRibbonLargeButtonNew: TLazRibbonLargeButton;
    LazRibbonSmallButtonOpen: TLazRibbonSmallButton;
    LazRibbonPaneSkins: TLazRibbonPane;
    LazRibbonSkinGalleryItem1: TLazRibbonSkinGalleryItem;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.
