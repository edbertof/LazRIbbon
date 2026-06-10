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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ComCtrls,
  StdCtrls, LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Buttons, ImgList;

type

  { TForm1 }

  TForm1 = class(TForm)
    ImageList1: TImageList;
    LazLargeButton1: TLazRibbonLargeButton;
    LazLargeButton2: TLazRibbonLargeButton;
    LazPane1: TLazRibbonPane;
    LazSmallButton1: TLazRibbonSmallButton;
    LazSmallButton2: TLazRibbonSmallButton;
    LazSmallButton3: TLazRibbonSmallButton;
    LazTab1: TLazRibbonTab;
    LazToolbar1: TLazRibbon;
    procedure ImageList1GetWidthForPPI(Sender: TCustomImageList; AImageWidth,
      APPI: Integer; var AResultWidth: Integer);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ImageList1GetWidthForPPI(Sender: TCustomImageList;
  AImageWidth, APPI: Integer; var AResultWidth: Integer);
begin
  AResultWidth := AImageWidth * APPI div 96;
end;

end.

