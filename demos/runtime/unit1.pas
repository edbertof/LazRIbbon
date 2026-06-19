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
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ImgList, ComCtrls, Menus, Grids, ExtCtrls, StdCtrls,
  LazRibbon_Core, LazRibbon_GUITools, LazRibbon_Math, LazRibbon_GraphTools, LazRibbon_Popup, LazRibbon_Tabs,
  LazRibbon_Groups, LazRibbon_Types, LazRibbon_Tools, LazRibbon_BaseItem, LazRibbon_Buttons,
  LazRibbon_Checkboxes;

type

  { TForm1 }

  TForm1 = class(TForm)
    ImageList: TImageList;
    LargeImageList: TImageList;
    LazLargeButton1: TLazRibbonLargeButton;
    LazLargeButton2: TLazRibbonLargeButton;
    LazPane2: TLazRibbonPane;
    LazPane1: TLazRibbonPane;
    LazSmallButton1: TLazRibbonSmallButton;
    LazSmallButton2: TLazRibbonSmallButton;
    LazSmallButton3: TLazRibbonSmallButton;
    LazTab1: TLazRibbonTab;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ImageListGetWidthForPPI(Sender: TCustomImageList; AImageWidth,
      APPI: Integer; var AResultWidth: Integer);
    procedure StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure StyleChangeHandler(Sender: TObject);
  private
    { private declarations }
    Ribbon : TLazRibbon;
    StylePopupMenu: TLazRibbonPopupMenu;
    RecentFilesPopupMenu: TLazRibbonPopupMenu;
    CbHorizGrid : TLazRibbonCheckbox;
    CbVertGrid: TLazRibbonCheckbox;
    CbRowSelect: TLazRibbonCheckbox;
    procedure AboutHandler(Sender: TObject);
    function CreateRecentFilesPopup: TLazRibbonPopupMenu;
    function CreateStylePopup: TLazRibbonPopupMenu;
    procedure FileOpenHandler(Sender: TObject);
    procedure FileSaveHandler(Sender: TObject);
    procedure FileQuitHandler(Sender: TObject);
    procedure FormatGridHandler(Sender: TObject);
    procedure HorizontalGridLinesHandler(Sender: TObject);
    procedure VerticalGridLinesHandler(Sender: TObject);
    procedure RowSelectHandler(Sender: TObject);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  LCLIntf, LazRibbon_Appearance;

{ TAboutForm }
type
  TAboutForm = class(TForm)
  private
    FIconLink: TLabel;
    procedure LinkClickHandler(Sender: TObject);
    procedure LinkMouseEnterHandler(Sender: TObject);
    procedure LinkMouseLeaveHandler(Sender: TObject);
  public
    constructor CreateNew(AOwner: TComponent; Num: Integer = 0); override;
  end;

constructor TAboutForm.CreateNew(AOwner: TComponent; Num: Integer = 0);
begin
  inherited;
  Width := 300;
  Height := 180;
  Caption := 'About';
  Position := poMainFormCenter;
  with TLabel.Create(self) do begin
    Caption := 'LazRibbon demo';
    Parent := self;
    Align := alTop;
    BorderSpacing.Top := 16;
    Font.Size := 16;
    Alignment := taCenter;
  end;
  with TLabel.Create(self) do begin
    Caption := 'Icons kindly provided by Roland Hahn' ;
    Parent := self;
    Align := alTop;
    Alignment := taCenter;
    BorderSpacing.Top := 16;
    Left := 16;
    Top := 999;
  end;
  FIconLink := TLabel.Create(self);
  with FIconLink do begin
    Caption := 'https://www.rhsoft.de';
    Font.Color := clBlue;
    Parent := self;
    Align := alTop;
    Alignment := taCenter;
    Top := 9999;
    OnClick := @LinkClickHandler;
    OnMouseEnter := @LinkMouseEnterHandler;
    OnMouseLeave := @LinkMouseLeaveHandler;
  end;
  with TButton.Create(self) do begin
    Caption := 'Close';
    Parent := Self;
    Left := (Self.Width - Width) div 2;
    Top := Self.Height - 16 - Height;
    ModalResult := mrOK;
    Default := true;
    Cancel := true;
  end;
end;

procedure TAboutForm.LinkClickHandler(Sender: TObject);
begin
  OpenURL((Sender as TLabel).Caption);
end;

procedure TAboutForm.LinkMouseEnterHandler(Sender: TObject);
begin
  FIconLink.Font.Style := [fsUnderline];
end;

procedure TAboutForm.LinkMouseLeaveHandler(Sender: TObject);
begin
  FIconLink.Font.Style := [];
end;


{ TForm1 }

procedure TForm1.AboutHandler(Sender: TObject);
var
  F: TForm;
begin
  F := TAboutForm.CreateNew(nil);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

function TForm1.CreateRecentFilesPopup: TLazRibbonPopupMenu;
var
  item: TMenuItem;
begin
  Result := TLazRibbonPopupMenu.Create(Self);

  item := TMenuItem.Create(Self);
  item.Caption := 'First file';
  item.ImageIndex := 15;
  Result.Items.Add(item);

  item := TMenuItem.Create(Self);
  item.Caption := 'Second file';
  item.ImageIndex := 16;
  Result.Items.Add(item);

  item := TMenuItem.Create(Self);
  item.Caption := 'Third file';
  item.ImageIndex := 17;
  Result.Items.Add(item);

  RecentFilesPopupMenu := Result;
end;

function TForm1.CreateStylePopup: TLazRibbonPopupMenu;
var
  item: TMenuItem;
begin
  Result := TLazRibbonPopupMenu.Create(Self);

  item := TMenuItem.Create(Self);
  item.Caption := 'Office2007 blue';
  item.GroupIndex := 10;
  item.Checked := true;
  item.Tag := ord(lazOffice2007Blue);
  item.OnClick := @StyleChangeHandler;
  Result.Items.Add(item);

  item := TMenuItem.Create(Self);
  item.Caption := 'Office2007 silver (yellow highlight)';
  item.GroupIndex := 10;
  item.Tag := ord(lazOffice2007Silver);
  item.OnClick := @StyleChangeHandler;
  Result.Items.Add(item);

  item := TMenuItem.Create(Self);
  item.Caption := 'Office2007 silver (turquoise highlight)';
  item.GroupIndex := 10;
  item.Tag := ord(lazOffice2007SilverTurquoise);
  item.OnClick := @StyleChangeHandler;
  Result.Items.Add(item);

  item := TMenuItem.Create(Self);
  item.Caption := 'Metro light';
  item.GroupIndex := 10;
  item.Tag := ord(lazMetroLight);
  item.OnClick := @StyleChangeHandler;
  Result.Items.Add(item);

  item := TMenuItem.Create(Self);
  item.Caption := 'Metro dark';
  item.GroupIndex := 10;
  item.Tag := ord(lazMetroDark);
  item.OnClick := @StyleChangeHandler;
  Result.Items.Add(item);

  StylePopupMenu := Result;
end;

procedure TForm1.FileOpenHandler(Sender: TObject);
begin
  Statusbar1.SimpleText := '"File" / "Open" clicked';
end;

procedure TForm1.FileSaveHandler(Sender: TObject);
begin
  Statusbar1.SimpleText := '"File" / "Save" clicked';
end;

procedure TForm1.FileQuitHandler(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormatGridHandler(Sender: TObject);
begin
  // Formatting is handled by the grid's OnPrepareCanvas event immediately
  // before painting.
  StringGrid1.Invalidate;
end;

procedure TForm1.HorizontalGridLinesHandler(Sender: TObject);
begin
  if CbHorizGrid.Checked then
    StringGrid1.Options := StringGrid1.Options + [goHorzLine]
  else
    StringGrid1.Options := StringGrid1.Options - [goHorzLine];
end;

procedure TForm1.VerticalGridLinesHandler(Sender: TObject);
begin
  if CbVertGrid.Checked then
    StringGrid1.Options := StringGrid1.Options + [goVertLine]
  else
    StringGrid1.Options := StringGrid1.Options - [goVertLine];
end;

procedure TForm1.RowSelectHandler(Sender: TObject);
begin
  if CbRowSelect.Checked then
    StringGrid1.Options := StringGrid1.Options + [goRowSelect]
  else
    StringGrid1.Options := StringGrid1.Options - [goRowSelect];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Ribbon := TLazRibbon.Create(self);

  with Ribbon do begin
    Parent := self;
    RibbonAppearance.Pane.CaptionFont.Style := [fsBold, fsItalic];
    Color := clSkyBlue;
    Images := ImageList;
    LargeImages := LargeImageList;
    ShowHint := true;

    with Tabs.Add do begin
      Caption := 'File';
      with Panes.Add do begin
        Caption := 'File commands';
        with Items.AddLargeButton do begin
          Caption := 'Open file';
          ButtonKind := bkButtonDropdown;
          DropdownMenu := CreateRecentFilesPopup;  //RecentFilesPopupMenu;
          LargeImageIndex := 1;
          Hint := 'Open a file';
          OnClick := @FileOpenHandler;
        end;
        with Items.AddLargeButton do begin
          Caption := 'Save file';
          LargeImageIndex := 2;
          Hint := 'Save file';
          OnClick := @FileSaveHandler;
        end;
        with Items.AddLargeButton do begin
          Caption := 'Quit program';
          LargeImageIndex := 0;
          Hint := 'Close application';
          OnClick := @FileQuitHandler;
        end;
      end;
    end;

    with Tabs.Add do begin
      Caption := 'Edit';
      with Panes.Add do begin
        Caption := 'Edit commands';
        with Items.AddSmallButton do begin
          Caption := 'Cut';
          HideFrameWhenIdle := true;
          TableBehaviour := tbBeginsRow;
          ImageIndex := 3;
          Hint := 'Cut to clipboard';
        end;
        with Items.AddSmallButton do begin
          Caption := 'Copy';
          HideFrameWhenIdle := true;
          TableBehaviour := tbBeginsRow;
          ImageIndex := 4;
          Hint := 'Copy to clipboard';
        end;
        with Items.AddSmallButton do begin
          Caption := 'Paste';
          HideFrameWhenIdle := true;
          TableBehaviour := tbBeginsColumn;
          ImageIndex := 5;
          Hint := 'Paste from clipboard';
        end;
      end;
    end;

    with Tabs.Add do begin
      Caption := 'Format';
      with Panes.Add do begin
        Caption := 'Format Settings';
        with Items.AddSmallButton do begin
          Caption := 'Bold';
          ButtonKind := bkToggle;
          GroupBehaviour := gbBeginsGroup;
          TableBehaviour := tbBeginsRow;
          ImageIndex := 6;
          ShowCaption := false;
          AllowAllUp := true;
          Hint := 'Bold';
          OnClick := @FormatGridHandler;
        end;
        with Items.AddSmallButton do begin
          Caption := 'Italic';
          ButtonKind := bkToggle;
          TableBehaviour := tbContinuesRow;
          GroupBehaviour := gbContinuesGroup;
          ImageIndex := 7;
          ShowCaption := false;
          AllowAllUp := true;
          Hint := 'Italic';
          OnClick := @FormatGridHandler;
        end;
        with Items.AddSmallButton do begin
          Caption := 'Underline';
          ButtonKind := bkToggle;
          TableBehaviour := tbContinuesRow;
          GroupBehaviour := gbEndsGroup;
          ImageIndex := 8;
          ShowCaption := false;
          AllowAllUp := true;
          Hint := 'Underlined';
          OnClick := @FormatGridHandler;
        end;

        with Items.AddSmallButton do begin
          Caption := 'Left-aligned';
          ButtonKind := bkToggle;
          GroupBehaviour := gbBeginsGroup;
          TableBehaviour := tbBeginsRow;
          ImageIndex := 11;
          ShowCaption := false;
          GroupIndex := 2;
          Checked := true;
          Hint := 'Left-aligned';
          OnClick := @FormatGridHandler;
        end;
        with Items.AddSmallButton do begin
          Caption := 'Centered';
          ButtonKind := bkToggle;
          TableBehaviour := tbContinuesRow;
          GroupBehaviour := gbContinuesGroup;
          ImageIndex := 12;
          ShowCaption := false;
          GroupIndex := 2;
          Checked := false;
          Hint := 'Centered';
          OnClick := @FormatGridHandler;
        end;
        with Items.AddSmallButton do begin
          Caption := 'Right-aligned';
          ButtonKind := bkToggle;
          TableBehaviour := tbContinuesRow;
          GroupBehaviour := gbEndsGroup;
          ImageIndex := 13;
          ShowCaption := false;
          GroupIndex := 2;
          Hint := 'Right-aligned';
          OnClick := @FormatGridHandler;
        end;
        {
        // I don't have an event handler for these...

        with Items.AddSmallButton do begin
          Caption := 'Block';
          ButtonKind := bkToggle;
          TableBehaviour := tbContinuesRow;
          GroupBehaviour := gbEndsGroup;
          ImageIndex := 14;
          ShowCaption := false;
          GroupIndex := 2;
          Hint := 'Block';
        end;

        with Items.AddSmallButton do begin
          Caption := 'Subscript';
          ButtonKind := bkToggle;
          TableBehaviour := tbBeginsColumn;
          GroupBehaviour := gbBeginsGroup;
          ImageIndex := 9;
          ShowCaption := false;
          AllowAllUp := true;
          GroupIndex := 1;
          Hint := 'Subscript';
        end;
        with Items.AddSmallButton do begin
          Caption := 'Superscript';
          ButtonKind := bkToggle;
          TableBehaviour := tbContinuesRow;
          GroupBehaviour := gbEndsGroup;
          ImageIndex := 10;
          ShowCaption := false;
          AllowAllUp := true;
          GroupIndex := 1;
          Hint := 'Superscript';
        end;

        With Items.AddSmallButton do begin
          Enabled := false;
          TableBehaviour := tbBeginsRow;
          HideFrameWhenIdle := true;
          Caption := '';
        end;
        }
      end;
    end;

    with Tabs.Add do begin
      Caption := 'Options';
      with Panes.Add do begin
        Caption := 'Grid settings';
        CbHorizGrid := Items.AddCheckbox;
        with CbHorizGrid do begin
          Caption := 'Horizontal grid lines';
          TableBehaviour := tbBeginsRow;
          Checked := true;
          Hint := 'Show/hide horizontal grid lines';
          OnClick := @HorizontalGridLinesHandler;
        end;
        CbVertGrid := Items.AddCheckbox;
        with CbVertGrid do begin
          Caption := 'Vertical grid lines';
          Hint := 'Show/hide vertical grid lines';
          TableBehaviour := tbBeginsRow;
          Checked := true;
          OnClick := @VerticalGridLinesHandler;
        end;
        CbRowSelect := Items.AddCheckbox;
        with CbRowSelect do begin
          Caption := 'Row select';
          TableBehaviour := tbBeginsRow;
          Checked := false;
          Hint := 'Select entire row';
          OnClick := @RowSelectHandler;
        end;
      end;
      with Panes.Add do begin
        Caption := 'Themes';
        with Items.AddLargeButton do begin
          Caption := 'Change style';
          Hint := 'Change theme';
          ButtonKind := bkDropdown;
          DropdownMenu := CreateStylePopup; //StylePopupMenu;
          LargeImageIndex := 7;
        end;
      end;
      with Panes.Add do begin
        Caption := 'Save settings';
        with Items.AddSmallButton do begin
          Caption := 'Save now';
          Hint := 'Save settings now';
          HideFrameWhenIdle := true;
          ImageIndex := 2;
        end;
        with Items.AddCheckbox do begin
          Caption := 'Auto-save settings';
          Checked := true;
          TableBehaviour := tbBeginsRow;
          Hint := 'Automatically save settings when program closes';
        end;
      end;
    end;

    with Tabs.Add do begin
      Caption := 'Help';
      with Panes.Add do begin
        Caption := 'Help commands';
        with Items.AddLargeButton do begin
          Caption := 'About...';
          LargeImageIndex := 6;
          Hint := 'About this program';
          OnClick := @AboutHandler;
        end;
      end;
    end;
  end;
end;

procedure TForm1.ImageListGetWidthForPPI(Sender: TCustomImageList; AImageWidth,
  APPI: Integer; var AResultWidth: Integer);
begin
  AResultWidth := AImageWidth * APPI div 96;
end;

procedure TForm1.StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var
  grid: TStringGrid;
  ts: TTextStyle;
  R: TRect;
begin
  if Sender is TStringGrid then
    grid := TStringGrid(Sender)
  else
    exit;

  if (ACol = 0) or (ARow = 0) then
    exit;

  // Button "bold"
  if TLazRibbonBaseButton(Ribbon.Tabs[2].Panes[0].Items[0]).Checked then
    grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsBold]
  else
    grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsBold];

  // Button "italic"
  if TLazRibbonBaseButton(Ribbon.Tabs[2].Panes[0].Items[1]).Checked then
    grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsItalic]
  else
    grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsItalic];

  // Button "underline"
  if TLazRibbonBaseButton(Ribbon.Tabs[2].Panes[0].Items[2]).Checked then
    grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsUnderline]
  else
    grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsUnderline];

  ts := grid.Canvas.TextStyle;
  // Button "left-aligned"
  if TLazRibbonBaseButton(Ribbon.Tabs[2].Panes[0].Items[3]).Checked then
    ts.Alignment := taLeftJustify;
  // Button "centered"
  if TLazRibbonBaseButton(Ribbon.Tabs[2].Panes[0].Items[4]).Checked then
    ts.Alignment := taCenter;
  // Button "right-aligned"
  if TLazRibbonBaseButton(Ribbon.Tabs[2].Panes[0].Items[5]).Checked then
    ts.Alignment := taRightJustify;

  grid.Canvas.Textstyle := ts;
end;

procedure TForm1.StyleChangeHandler(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to StylePopupMenu.Items.Count-1 do
    StylePopupMenu.Items[i].Checked := StylePopupMenu.Items[i] = TMenuItem(Sender);
  Ribbon.Style := TLazRibbonStyle((Sender as TMenuItem).Tag);
  case Ribbon.Style of
    lazOffice2007Blue            : Ribbon.Color := clSkyBlue;
    lazOffice2007Silver          : Ribbon.Color := clWhite;
    lazOffice2007SilverTurquoise : Ribbon.Color := clWhite;
    lazMetroLight                : Ribbon.Color := clSilver;
    lazMetroDark                 : Ribbon.Color := $080808;
  end;
end;


end.
