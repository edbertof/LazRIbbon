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

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  LazRibbon_Core, LazRibbon_Backstage, LazRibbon_Tabs, LazRibbon_SkinManager, LazRibbon_SkinSelector,
  LazRibbon_Groups, LazRibbon_Buttons, LazRibbon_RibbonExtItems;

type

  { TForm1 }

  TForm1 = class(TForm)
    LazBackstagePage1: TLazRibbonBackstagePage;
    LazBackstageRecentList1: TLazRibbonBackstageRecentList;
    LazBackstageView1: TLazRibbonBackstageView;
    LazLargeButton1: TLazRibbonLargeButton;
    LazLargeButton2: TLazRibbonLargeButton;
    LazLargeButton3: TLazRibbonLargeButton;
    LazPane1: TLazRibbonPane;
    LazPane2: TLazRibbonPane;
    LazRibbonSkinGalleryItem2: TLazRibbonSkinGalleryItem;
    LazSkinManager1: TLazRibbonSkinManager;
    LazSkinSelector1: TLazRibbonSkinSelector;
    LazSmallButton1: TLazRibbonSmallButton;
    LazSmallButton2: TLazRibbonSmallButton;
    LazSmallButton3: TLazRibbonSmallButton;
    LazTab1: TLazRibbonTab;
    LazToolbar1: TLazRibbon;
    procedure LazBackstageView1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.LazBackstageView1Click(Sender: TObject);
begin

end;

end.

