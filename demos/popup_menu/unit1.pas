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

{$mode delphi}{$H+}{$codepage utf8}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Menus, StdCtrls, ExtCtrls,
  ImgList,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Items,
  LazRibbon_Buttons, LazRibbon_Popup, LazRibbon_ControlItems;

type

  { TForm1 }

  TForm1 = class(TForm)
    BorderAll: TMenuItem;
    BorderBottom: TMenuItem;
    BorderNone: TMenuItem;
    BorderSeparator: TMenuItem;
    BorderTop: TMenuItem;
    LazRibbon1: TLazRibbon;
    LazRibbonPopupMenu1: TLazRibbonPopupMenu;
    MenuItemNovo: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemSalvar: TMenuItem;
    LazRibbonTabHome: TLazRibbonTab;
    LazRibbonPaneClipboard: TLazRibbonPane;
    LazRibbonLargeButtonPaste: TLazRibbonLargeButton;
    LazRibbonPaneOptions: TLazRibbonPane;
    SpacingButton: TLazRibbonLargeButton;
    BordersButton: TLazRibbonLargeButton;
    PaperButton: TLazRibbonLargeButton;
    ShapesButton: TLazRibbonLargeButton;
    ColorsButton: TLazRibbonColorComboBoxItem;
    SpacingDouble: TMenuItem;
    SpacingMenu: TLazRibbonPopupMenu;
    BordersMenu: TLazRibbonPopupMenu;
    PaperMenu: TLazRibbonPopupMenu;
    ShapesMenu: TLazRibbonPopupMenu;
    Preview: TLabel;
    ColorSample: TPaintBox;
    SpacingOneAndHalf: TMenuItem;
    SpacingSingle: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure GallerySelect(Sender: TObject; Entry: TLazRibbonPopupEntry);
    procedure MenuCommand(Sender: TObject);
    procedure RepeatBorder(Sender: TObject);
    procedure ApplyColor(Sender: TObject);
    procedure PaintColorSample(Sender: TObject);
  private
    FLastBorder: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
const
  PaperNames: array[0..8] of string =
    ('Carta', 'Ofício', 'Executivo', 'A3', 'A4', 'A5', 'B4', 'B5', 'Fólio');
  PaperSizes: array[0..8] of string =
    ('21,59 × 27,94 cm', '21,59 × 35,56 cm', '18,42 × 26,67 cm',
     '29,7 × 42 cm', '21 × 29,7 cm', '14,8 × 21 cm', '25 × 35,3 cm',
     '17,6 × 25 cm', '21,59 × 33,02 cm');
  ShapeNames: array[0..5] of string =
    ('Retângulo', 'Elipse', 'Triângulo', 'Losango', 'Seta', 'Linha');
var
  I: Integer;
  Entry: TLazRibbonPopupEntry;
  Glyph: TBitmap;
  ShapeImages: TImageList;

  procedure AddHeading(AMenu: TLazRibbonPopupMenu; const ACaption: string);
  var
    Heading: TLazRibbonPopupEntry;
  begin
    Heading := AMenu.Gallery.Items.Add;
    Heading.Caption := ACaption;
    Heading.Kind := pekHeading;
  end;

begin
  FLastBorder := 'Borda inferior';
  for I := Low(PaperNames) to High(PaperNames) do
  begin
    Entry := PaperMenu.Gallery.Items.Add;
    Entry.Caption := PaperNames[I];
    Entry.Description := PaperSizes[I];
  end;
  PaperMenu.Gallery.SelectedIndex := 4;

  ShapeImages := TImageList.Create(Self);
  ShapesMenu.Images := ShapeImages;
  Glyph := TBitmap.Create;
  try
    Glyph.SetSize(16, 16);
    Glyph.Canvas.Pen.Color := clBlack;
    for I := Low(ShapeNames) to High(ShapeNames) do
    begin
      if I = 0 then AddHeading(ShapesMenu, 'Formas básicas');
      if I = 4 then AddHeading(ShapesMenu, 'Linhas e setas');
      Glyph.Canvas.Brush.Color := clWhite;
      Glyph.Canvas.FillRect(0, 0, 16, 16);
      case I of
        0: Glyph.Canvas.Rectangle(1, 3, 15, 13);
        1: Glyph.Canvas.Ellipse(1, 3, 15, 13);
        2: Glyph.Canvas.Polygon([Point(8, 2), Point(14, 13), Point(1, 13)]);
        3: Glyph.Canvas.Polygon([Point(8, 1), Point(14, 8), Point(8, 14), Point(1, 8)]);
        4: Glyph.Canvas.Polyline([Point(1, 8), Point(14, 8), Point(9, 3)]);
        5: Glyph.Canvas.Line(2, 13, 13, 2);
      end;
      Entry := ShapesMenu.Gallery.Items.Add;
      Entry.Caption := ShapeNames[I];
      Entry.ImageIndex := ShapeImages.AddMasked(Glyph, clWhite);
    end;
  finally
    Glyph.Free;
  end;

end;

procedure TForm1.GallerySelect(Sender: TObject; Entry: TLazRibbonPopupEntry);
begin
  Preview.Caption := Entry.Caption;
  if Entry.Description <> '' then
    Preview.Caption := Preview.Caption + ' / ' + Entry.Description;
end;

procedure TForm1.MenuCommand(Sender: TObject);
begin
  Preview.Caption := TMenuItem(Sender).Caption;
  if TMenuItem(Sender).GetParentMenu = BordersMenu then
    FLastBorder := Preview.Caption;
end;

procedure TForm1.RepeatBorder(Sender: TObject);
begin
  Preview.Caption := FLastBorder;
end;

procedure TForm1.ApplyColor(Sender: TObject);
begin
  if ColorsButton.EffectiveColor = clNone then
    Preview.Caption := 'Sem cor'
  else if ColorsButton.SelectedColor = clDefault then
    Preview.Caption := 'Cor automática'
  else if ColorsButton.GradientColor <> clNone then
    Preview.Caption := 'Gradiente aplicado'
  else
    Preview.Caption := 'Cor aplicada';
  ColorSample.Invalidate;
end;

procedure TForm1.PaintColorSample(Sender: TObject);
begin
  if ColorsButton.EffectiveColor = clNone then Exit;
  if ColorsButton.GradientColor <> clNone then
    ColorSample.Canvas.GradientFill(ColorSample.ClientRect,
      ColorsButton.EffectiveColor, ColorsButton.GradientColor, gdHorizontal)
  else
  begin
    ColorSample.Canvas.Brush.Color := ColorsButton.EffectiveColor;
    ColorSample.Canvas.FillRect(ColorSample.ClientRect);
  end;
end;

end.
