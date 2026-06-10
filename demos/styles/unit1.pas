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
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Buttons, LazRibbon_Checkboxes, ImgList;

type

  { TForm1 }

  TForm1 = class(TForm)
    LargeImages: TImageList;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ScrollBox1: TScrollBox;
    SmallImages: TImageList;
    LazCheckbox1: TLazRibbonCheckbox;
    LazCheckbox2: TLazRibbonCheckbox;
    LazCheckbox3: TLazRibbonCheckbox;
    LazCheckbox4: TLazRibbonCheckbox;
    LazCheckbox5: TLazRibbonCheckbox;
    LazLargeButton1: TLazRibbonLargeButton;
    LazLargeButton10: TLazRibbonLargeButton;
    LazLargeButton11: TLazRibbonLargeButton;
    LazLargeButton12: TLazRibbonLargeButton;
    LazLargeButton13: TLazRibbonLargeButton;
    LazLargeButton14: TLazRibbonLargeButton;
    LazLargeButton15: TLazRibbonLargeButton;
    LazLargeButton2: TLazRibbonLargeButton;
    LazLargeButton3: TLazRibbonLargeButton;
    LazLargeButton4: TLazRibbonLargeButton;
    LazLargeButton5: TLazRibbonLargeButton;
    LazLargeButton6: TLazRibbonLargeButton;
    LazLargeButton7: TLazRibbonLargeButton;
    LazLargeButton8: TLazRibbonLargeButton;
    LazLargeButton9: TLazRibbonLargeButton;
    LazPane1: TLazRibbonPane;
    LazPane10: TLazRibbonPane;
    LazPane11: TLazRibbonPane;
    LazPane12: TLazRibbonPane;
    LazPane13: TLazRibbonPane;
    LazPane14: TLazRibbonPane;
    LazPane15: TLazRibbonPane;
    LazPane16: TLazRibbonPane;
    LazPane17: TLazRibbonPane;
    LazPane18: TLazRibbonPane;
    LazPane19: TLazRibbonPane;
    LazPane2: TLazRibbonPane;
    LazPane20: TLazRibbonPane;
    LazPane3: TLazRibbonPane;
    LazPane4: TLazRibbonPane;
    LazPane5: TLazRibbonPane;
    LazPane6: TLazRibbonPane;
    LazPane7: TLazRibbonPane;
    LazPane8: TLazRibbonPane;
    LazPane9: TLazRibbonPane;
    LazSmallButton1: TLazRibbonSmallButton;
    LazSmallButton10: TLazRibbonSmallButton;
    LazSmallButton11: TLazRibbonSmallButton;
    LazSmallButton12: TLazRibbonSmallButton;
    LazSmallButton13: TLazRibbonSmallButton;
    LazSmallButton14: TLazRibbonSmallButton;
    LazSmallButton15: TLazRibbonSmallButton;
    LazSmallButton16: TLazRibbonSmallButton;
    LazSmallButton17: TLazRibbonSmallButton;
    LazSmallButton18: TLazRibbonSmallButton;
    LazSmallButton19: TLazRibbonSmallButton;
    LazSmallButton2: TLazRibbonSmallButton;
    LazSmallButton20: TLazRibbonSmallButton;
    LazSmallButton21: TLazRibbonSmallButton;
    LazSmallButton22: TLazRibbonSmallButton;
    LazSmallButton23: TLazRibbonSmallButton;
    LazSmallButton24: TLazRibbonSmallButton;
    LazSmallButton25: TLazRibbonSmallButton;
    LazSmallButton26: TLazRibbonSmallButton;
    LazSmallButton27: TLazRibbonSmallButton;
    LazSmallButton28: TLazRibbonSmallButton;
    LazSmallButton29: TLazRibbonSmallButton;
    LazSmallButton3: TLazRibbonSmallButton;
    LazSmallButton30: TLazRibbonSmallButton;
    LazSmallButton31: TLazRibbonSmallButton;
    LazSmallButton32: TLazRibbonSmallButton;
    LazSmallButton33: TLazRibbonSmallButton;
    LazSmallButton34: TLazRibbonSmallButton;
    LazSmallButton35: TLazRibbonSmallButton;
    LazSmallButton36: TLazRibbonSmallButton;
    LazSmallButton37: TLazRibbonSmallButton;
    LazSmallButton38: TLazRibbonSmallButton;
    LazSmallButton39: TLazRibbonSmallButton;
    LazSmallButton4: TLazRibbonSmallButton;
    LazSmallButton40: TLazRibbonSmallButton;
    LazSmallButton41: TLazRibbonSmallButton;
    LazSmallButton42: TLazRibbonSmallButton;
    LazSmallButton43: TLazRibbonSmallButton;
    LazSmallButton44: TLazRibbonSmallButton;
    LazSmallButton45: TLazRibbonSmallButton;
    LazSmallButton46: TLazRibbonSmallButton;
    LazSmallButton47: TLazRibbonSmallButton;
    LazSmallButton48: TLazRibbonSmallButton;
    LazSmallButton49: TLazRibbonSmallButton;
    LazSmallButton5: TLazRibbonSmallButton;
    LazSmallButton50: TLazRibbonSmallButton;
    LazSmallButton51: TLazRibbonSmallButton;
    LazSmallButton52: TLazRibbonSmallButton;
    LazSmallButton53: TLazRibbonSmallButton;
    LazSmallButton54: TLazRibbonSmallButton;
    LazSmallButton55: TLazRibbonSmallButton;
    LazSmallButton56: TLazRibbonSmallButton;
    LazSmallButton57: TLazRibbonSmallButton;
    LazSmallButton58: TLazRibbonSmallButton;
    LazSmallButton59: TLazRibbonSmallButton;
    LazSmallButton6: TLazRibbonSmallButton;
    LazSmallButton60: TLazRibbonSmallButton;
    LazSmallButton61: TLazRibbonSmallButton;
    LazSmallButton62: TLazRibbonSmallButton;
    LazSmallButton63: TLazRibbonSmallButton;
    LazSmallButton64: TLazRibbonSmallButton;
    LazSmallButton65: TLazRibbonSmallButton;
    LazSmallButton66: TLazRibbonSmallButton;
    LazSmallButton67: TLazRibbonSmallButton;
    LazSmallButton68: TLazRibbonSmallButton;
    LazSmallButton69: TLazRibbonSmallButton;
    LazSmallButton7: TLazRibbonSmallButton;
    LazSmallButton70: TLazRibbonSmallButton;
    LazSmallButton71: TLazRibbonSmallButton;
    LazSmallButton72: TLazRibbonSmallButton;
    LazSmallButton73: TLazRibbonSmallButton;
    LazSmallButton74: TLazRibbonSmallButton;
    LazSmallButton75: TLazRibbonSmallButton;
    LazSmallButton8: TLazRibbonSmallButton;
    LazSmallButton9: TLazRibbonSmallButton;
    LazTab1: TLazRibbonTab;
    LazTab2: TLazRibbonTab;
    LazTab4: TLazRibbonTab;
    LazTab5: TLazRibbonTab;
    LazTab6: TLazRibbonTab;
    LazToolbar1: TLazRibbon;
    LazToolbar2: TLazRibbon;
    LazToolbar3: TLazRibbon;
    LazToolbar4: TLazRibbon;
    LazToolbar5: TLazRibbon;
    procedure LargeImagesGetWidthForPPI(Sender: TCustomImageList; AImageWidth,
      APPI: Integer; var AResultWidth: Integer);
    procedure RadioButton1Change(Sender: TObject);
    procedure SmallImagesGetWidthForPPI(Sender: TCustomImageList; AImageWidth,
      APPI: Integer; var AResultWidth: Integer);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  if Sender = RadioButton1 then
  begin
    LazToolbar1.BiDiMode := bdLeftToRight;
    LazToolbar2.BiDiMode := bdLeftToRight;
    LazToolbar3.BiDiMode := bdLeftToRight;
    LazToolbar4.BiDiMode := bdLeftToRight;
    LazToolbar5.BiDiMode := bdLeftToRight;
  end else
  if Sender = RadioButton2 then
  begin
    LazToolbar1.BiDiMode := bdRightToLeft;
    LazToolbar2.BiDiMode := bdRightToLeft;
    LazToolbar3.BiDiMode := bdRightToLeft;
    LazToolbar4.BiDiMode := bdRightToLeft;
    LazToolbar5.BiDiMode := bdRightToLeft;
  end;
end;

procedure TForm1.SmallImagesGetWidthForPPI(Sender: TCustomImageList;
  AImageWidth, APPI: Integer; var AResultWidth: Integer);
begin
  AResultWidth := AImageWidth * APPI div 96;
end;

procedure TForm1.LargeImagesGetWidthForPPI(Sender: TCustomImageList;
  AImageWidth, APPI: Integer; var AResultWidth: Integer);
begin
  AResultWidth := AImageWidth * APPI div 96;
end;

end.

