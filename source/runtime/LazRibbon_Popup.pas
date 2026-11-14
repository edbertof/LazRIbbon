(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Popup.pas                                                   *
*  Description: Popup menu for Lazarus port of TLazRibbon                     *
*  Copyright:   (c) 2023 by W. Pamler                                          *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*  Issues:                                                                     *
*    - The popup menu is not borderless - looks strange in Metro Dark          *
*    - Checkbox and radio button are drawn with theme services --> hardly      *
*      visible in Metro Dark                                                   *
*    - Submenu indicator triangle is black --> hardly visible in Metro Dark    *
*                                                                              *
*******************************************************************************)

unit LazRibbon_Popup;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, LCLProc,
  Types, SysUtils, Classes, Controls, Forms, Graphics, ImgList, Menus, StdCtrls,
  LazRibbon_Const, LazRibbon_GUITools, LazRibbon_Math, LazRibbon_Appearance;

type
  TLazRibbonPopupEntryKind = (pekChoice, pekHeading, pekCommand, pekToggle, pekSpacer);

  TLazRibbonPopupEntry = class(TCollectionItem)
  private
    FCaption: string;
    FDescription: string;
    FColor: TColor;
    FGradientColor: TColor;
    FChecked: Boolean;
    FEnabled: Boolean;
    FImageIndex: TImageIndex;
    FKind: TLazRibbonPopupEntryKind;
    FTag: PtrInt;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: string read FCaption write FCaption;
    property Description: string read FDescription write FDescription;
    property Color: TColor read FColor write FColor default clNone;
    property GradientColor: TColor read FGradientColor write FGradientColor default clNone;
    property Checked: Boolean read FChecked write FChecked default False;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property ImageIndex: TImageIndex read FImageIndex write FImageIndex default -1;
    property Kind: TLazRibbonPopupEntryKind read FKind write FKind default pekChoice;
    property Tag: PtrInt read FTag write FTag default 0;
  end;

  TLazRibbonPopupEntries = class(TOwnedCollection)
  private
    function GetEntry(AIndex: Integer): TLazRibbonPopupEntry;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TLazRibbonPopupEntry;
    property Entries[AIndex: Integer]: TLazRibbonPopupEntry read GetEntry; default;
  end;

  TLazRibbonPopupGallery = class(TPersistent)
  private
    FOwner: TPersistent;
    FEnabled: Boolean;
    FColumns: Integer;
    FItemWidth: Integer;
    FItemHeight: Integer;
    FMaxHeight: Integer;
    FShowCaptions: Boolean;
    FItems: TLazRibbonPopupEntries;
    FSelectedID: Integer;
    function GetSelectedIndex: Integer;
    procedure SetColumns(AValue: Integer);
    procedure SetItemWidth(AValue: Integer);
    procedure SetItemHeight(AValue: Integer);
    procedure SetMaxHeight(AValue: Integer);
    procedure SetItems(AValue: TLazRibbonPopupEntries);
    procedure SetSelectedIndex(AValue: Integer);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
  published
    property Enabled: Boolean read FEnabled write FEnabled default False;
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemWidth: Integer read FItemWidth write SetItemWidth default 220;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 40;
    property MaxHeight: Integer read FMaxHeight write SetMaxHeight default 320;
    property ShowCaptions: Boolean read FShowCaptions write FShowCaptions default True;
    property Items: TLazRibbonPopupEntries read FItems write SetItems;
  end;

  TLazRibbonPopupSelectEvent = procedure(Sender: TObject; Entry: TLazRibbonPopupEntry) of object;

  TLazRibbonPopupMenu = class(TPopupMenu)
  private
    FAppearance: TLazRibbonToolbarAppearance;
    FGallery: TLazRibbonPopupGallery;
    FGalleryWindow: TCustomForm;
    FOnGallerySelect: TLazRibbonPopupSelectEvent;
    procedure SetAppearance(AValue: TLazRibbonToolbarAppearance);
    procedure SetGallery(AValue: TLazRibbonPopupGallery);
    procedure HideGallery;
    function GetIconSize: TSize;
    function GetPPI: Integer;

  protected
    procedure DrawItemHandler(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState); virtual;
    procedure MeasureItemHandler(Sender: TObject; {%H-}ACanvas: TCanvas;
      var {%H-}AWidth, {%H-}AHeight: Integer); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoClose; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PopUp(X, Y: Integer); override;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
  published
    property Gallery: TLazRibbonPopupGallery read FGallery write SetGallery;
    property OnGallerySelect: TLazRibbonPopupSelectEvent read FOnGallerySelect write FOnGallerySelect;
  end;

implementation

uses
  Themes, Math, LMessages;

type
  TLazRibbonPopupCell = record
    Bounds: TRect;
    EntryID: Integer;
  end;

  TLazRibbonPopupGalleryWindow = class(TForm)
  private
    FMenu: TLazRibbonPopupMenu;
    FStyle: TLazRibbonPopupMenuAppearance;
    FCells: array of TLazRibbonPopupCell;
    FScrollBar: TScrollBar;
    FPPI: Integer;
    FContentWidth: Integer;
    FContentHeight: Integer;
    FOffset: Integer;
    FActiveCell: Integer;
    FPressedCell: Integer;
    function Scale(AValue: Integer): Integer;
    function EntryAt(AIndex: Integer): TLazRibbonPopupEntry;
    function IsSelectable(AIndex: Integer): Boolean;
    function CellAt(X, Y: Integer): Integer;
    procedure BuildLayout(AWidth: Integer);
    procedure ScrollTo(AOffset: Integer);
    procedure ScrollChanged(Sender: TObject);
    procedure SetActiveCell(AIndex: Integer; AReveal: Boolean);
    procedure MoveSelection(ADirection: Integer; AVertical: Boolean);
    procedure ActivateCell(AIndex: Integer);
    procedure Dismiss;
    procedure PaintCell(AEntry: TLazRibbonPopupEntry; const R: TRect; AHot: Boolean);
    procedure DialogCode(var Message: TLMGetDlgCode); message LM_GETDLGCODE;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Deactivate; override;
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
  public
    constructor CreateForMenu(AMenu: TLazRibbonPopupMenu; const APoint: TPoint);
    destructor Destroy; override;
  end;

constructor TLazRibbonPopupEntry.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FEnabled := True;
  FImageIndex := -1;
  FColor := clNone;
  FGradientColor := clNone;
end;

procedure TLazRibbonPopupEntry.Assign(Source: TPersistent);
var
  Entry: TLazRibbonPopupEntry;
begin
  if not (Source is TLazRibbonPopupEntry) then
  begin
    inherited Assign(Source);
    Exit;
  end;
  Entry := TLazRibbonPopupEntry(Source);
  FCaption := Entry.Caption;
  FDescription := Entry.Description;
  FColor := Entry.Color;
  FGradientColor := Entry.GradientColor;
  FChecked := Entry.Checked;
  FEnabled := Entry.Enabled;
  FImageIndex := Entry.ImageIndex;
  FKind := Entry.Kind;
  FTag := Entry.Tag;
end;

function TLazRibbonPopupEntry.GetDisplayName: string;
begin
  if Caption <> '' then
    Result := Caption
  else
    Result := inherited GetDisplayName;
end;

constructor TLazRibbonPopupEntries.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TLazRibbonPopupEntry);
end;

function TLazRibbonPopupEntries.Add: TLazRibbonPopupEntry;
begin
  Result := TLazRibbonPopupEntry(inherited Add);
end;

function TLazRibbonPopupEntries.GetEntry(AIndex: Integer): TLazRibbonPopupEntry;
begin
  Result := TLazRibbonPopupEntry(inherited Items[AIndex]);
end;

constructor TLazRibbonPopupGallery.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FColumns := 1;
  FItemWidth := 220;
  FItemHeight := 40;
  FMaxHeight := 320;
  FShowCaptions := True;
  FSelectedID := -1;
  FItems := TLazRibbonPopupEntries.Create(Self);
end;

destructor TLazRibbonPopupGallery.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TLazRibbonPopupGallery.Assign(Source: TPersistent);
var
  Gallery: TLazRibbonPopupGallery;
begin
  if Source = Self then Exit;
  if not (Source is TLazRibbonPopupGallery) then
  begin
    inherited Assign(Source);
    Exit;
  end;
  Gallery := TLazRibbonPopupGallery(Source);
  Enabled := Gallery.Enabled;
  Columns := Gallery.Columns;
  ItemWidth := Gallery.ItemWidth;
  ItemHeight := Gallery.ItemHeight;
  MaxHeight := Gallery.MaxHeight;
  ShowCaptions := Gallery.ShowCaptions;
  Items := Gallery.Items;
  SelectedIndex := Gallery.SelectedIndex;
end;

function TLazRibbonPopupGallery.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TLazRibbonPopupGallery.GetSelectedIndex: Integer;
var
  Entry: TLazRibbonPopupEntry;
begin
  Result := -1;
  Entry := TLazRibbonPopupEntry(FItems.FindItemID(FSelectedID));
  if (Entry <> nil) and (Entry.Kind = pekChoice) then
    Result := Entry.Index;
end;

procedure TLazRibbonPopupGallery.SetSelectedIndex(AValue: Integer);
begin
  FSelectedID := -1;
  if (AValue >= 0) and (AValue < FItems.Count) and
    (FItems[AValue].Kind = pekChoice) then
    FSelectedID := FItems[AValue].ID;
end;

procedure TLazRibbonPopupGallery.SetColumns(AValue: Integer);
begin
  FColumns := EnsureRange(AValue, 1, 32);
end;

procedure TLazRibbonPopupGallery.SetItemWidth(AValue: Integer);
begin
  FItemWidth := EnsureRange(AValue, 16, 2048);
end;

procedure TLazRibbonPopupGallery.SetItemHeight(AValue: Integer);
begin
  FItemHeight := EnsureRange(AValue, 16, 256);
end;

procedure TLazRibbonPopupGallery.SetMaxHeight(AValue: Integer);
begin
  FMaxHeight := EnsureRange(AValue, 40, 2048);
end;

procedure TLazRibbonPopupGallery.SetItems(AValue: TLazRibbonPopupEntries);
begin
  if (AValue = nil) or (AValue = FItems) then Exit;
  FSelectedID := -1;
  FItems.Assign(AValue);
end;

constructor TLazRibbonPopupGalleryWindow.CreateForMenu(AMenu: TLazRibbonPopupMenu;
  const APoint: TPoint);
var
  WorkArea: TRect;
  TargetMonitor: TMonitor;
  X, Y, W, H, MaxHeight, BarWidth: Integer;
begin
  inherited CreateNew(nil);
  FMenu := AMenu;
  FMenu.FreeNotification(Self);
  FActiveCell := -1;
  FPressedCell := -1;
  Scaled := False;
  BorderStyle := bsNone;
  ShowInTaskBar := stNever;
  KeyPreview := True;
  PopupMode := pmExplicit;
  PopupParent := Screen.ActiveCustomForm;
  Position := poDesigned;
  ParentBiDiMode := False;
  BiDiMode := FMenu.BiDiMode;
  ShowHint := True;

  FStyle := TLazRibbonPopupMenuAppearance.Create(nil);
  if FMenu.Appearance <> nil then
    FStyle.Assign(FMenu.Appearance.Popup);
  Color := FStyle.IdleGradientFromColor;

  TargetMonitor := Screen.MonitorFromPoint(APoint, mdNearest);
  WorkArea := Screen.WorkAreaRect;
  FPPI := Screen.PixelsPerInch;
  if TargetMonitor <> nil then
  begin
    WorkArea := TargetMonitor.WorkareaRect;
    FPPI := TargetMonitor.PixelsPerInch;
  end;
  if FPPI <= 0 then FPPI := 96;
  Font.Assign(FStyle.CaptionFont);
  Font.PixelsPerInch := FPPI;

  W := Min(WorkArea.Width, Scale(FMenu.Gallery.Columns * FMenu.Gallery.ItemWidth) + 2);
  MaxHeight := Min(WorkArea.Height, Scale(FMenu.Gallery.MaxHeight));
  BuildLayout(Max(1, W - 2));
  H := Min(MaxHeight, FContentHeight + 2);
  if FContentHeight + 2 > H then
  begin
    BarWidth := Scale(18);
    W := Min(WorkArea.Width, W + BarWidth);
    BuildLayout(Max(1, W - BarWidth - 2));
    FScrollBar := TScrollBar.Create(Self);
    FScrollBar.Parent := Self;
    FScrollBar.Kind := sbVertical;
    FScrollBar.TabStop := False;
    FScrollBar.SetBounds(W - BarWidth - 1, 1, BarWidth, H - 2);
    FScrollBar.SmallChange := Scale(FMenu.Gallery.ItemHeight);
    FScrollBar.LargeChange := H - 2;
    FScrollBar.SetParams(0, 0, FContentHeight - 1, H - 2);
    FScrollBar.OnChange := @ScrollChanged;
  end;

  X := APoint.X;
  if FMenu.IsRightToLeft then
    Dec(X, W);
  Y := APoint.Y;
  if (Y + H > WorkArea.Bottom) and (Y - H - Scale(24) >= WorkArea.Top) then
    Dec(Y, H + Scale(24));
  SetBounds(EnsureRange(X, WorkArea.Left, WorkArea.Right - W),
    EnsureRange(Y, WorkArea.Top, WorkArea.Bottom - H), W, H);
  SetActiveCell(FMenu.Gallery.SelectedIndex, True);
end;

destructor TLazRibbonPopupGalleryWindow.Destroy;
begin
  if FMenu <> nil then
  begin
    if FMenu.FGalleryWindow = Self then
      FMenu.FGalleryWindow := nil;
    FMenu.RemoveFreeNotification(Self);
  end;
  FStyle.Free;
  inherited Destroy;
end;

procedure TLazRibbonPopupGalleryWindow.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FMenu) then
    FMenu := nil;
end;

function TLazRibbonPopupGalleryWindow.Scale(AValue: Integer): Integer;
begin
  Result := MulDiv(AValue, FPPI, 96);
end;

procedure TLazRibbonPopupGalleryWindow.BuildLayout(AWidth: Integer);
var
  I, Col, Y, Columns, CellHeight, RowHeight, LeftEdge, RightEdge: Integer;
  Entry: TLazRibbonPopupEntry;
begin
  FContentWidth := AWidth;
  Columns := Min(FMenu.Gallery.Columns, Max(1, AWidth div Scale(16)));
  CellHeight := Scale(FMenu.Gallery.ItemHeight);
  SetLength(FCells, FMenu.Gallery.Items.Count);
  Col := 0;
  Y := 0;
  for I := 0 to High(FCells) do
  begin
    Entry := FMenu.Gallery.Items[I];
    FCells[I].EntryID := Entry.ID;
    if Entry.Kind = pekChoice then
    begin
      LeftEdge := Col * AWidth div Columns;
      RightEdge := (Col + 1) * AWidth div Columns;
      if FMenu.IsRightToLeft then
        FCells[I].Bounds := Rect(1 + AWidth - RightEdge, Y, 1 + AWidth - LeftEdge, Y + CellHeight)
      else
        FCells[I].Bounds := Rect(1 + LeftEdge, Y, 1 + RightEdge, Y + CellHeight);
      Inc(Col);
      if Col = Columns then
      begin
        Col := 0;
        Inc(Y, CellHeight);
      end;
    end
    else
    begin
      if Col <> 0 then
        Inc(Y, CellHeight);
      Col := 0;
      RowHeight := Max(Scale(23), Canvas.TextHeight('Tg') + Scale(6));
      if Entry.Kind = pekSpacer then
        RowHeight := Scale(7);
      if (Entry.Kind = pekCommand) and (Entry.Description <> '') then
        RowHeight := Max(CellHeight, 2 * Canvas.TextHeight('Tg') + Scale(6));
      FCells[I].Bounds := Rect(1, Y, 1 + AWidth, Y + RowHeight);
      Inc(Y, RowHeight);
    end;
  end;
  if Col <> 0 then
    Inc(Y, CellHeight);
  FContentHeight := Y;
end;

function TLazRibbonPopupGalleryWindow.EntryAt(AIndex: Integer): TLazRibbonPopupEntry;
begin
  Result := nil;
  if (FMenu <> nil) and (AIndex >= 0) and (AIndex < Length(FCells)) then
    Result := TLazRibbonPopupEntry(FMenu.Gallery.Items.FindItemID(FCells[AIndex].EntryID));
end;

function TLazRibbonPopupGalleryWindow.IsSelectable(AIndex: Integer): Boolean;
var
  Entry: TLazRibbonPopupEntry;
begin
  Entry := EntryAt(AIndex);
  Result := (Entry <> nil) and Entry.Enabled and
    not (Entry.Kind in [pekHeading, pekSpacer]);
end;

function TLazRibbonPopupGalleryWindow.CellAt(X, Y: Integer): Integer;
var
  I: Integer;
  P: TPoint;
begin
  Result := -1;
  if (X < 1) or (X > FContentWidth) or (Y < 1) or (Y >= ClientHeight - 1) then
    Exit;
  P := Point(X, Y + FOffset - 1);
  for I := 0 to High(FCells) do
    if PtInRect(FCells[I].Bounds, P) then Exit(I);
end;

procedure TLazRibbonPopupGalleryWindow.ScrollTo(AOffset: Integer);
begin
  AOffset := EnsureRange(AOffset, 0, Max(0, FContentHeight - ClientHeight + 2));
  if FOffset = AOffset then Exit;
  FOffset := AOffset;
  if FScrollBar <> nil then
    FScrollBar.Position := FOffset;
  Invalidate;
end;

procedure TLazRibbonPopupGalleryWindow.ScrollChanged(Sender: TObject);
begin
  ScrollTo(FScrollBar.Position);
end;

procedure TLazRibbonPopupGalleryWindow.SetActiveCell(AIndex: Integer; AReveal: Boolean);
var
  R: TRect;
begin
  if not IsSelectable(AIndex) then AIndex := -1;
  FActiveCell := AIndex;
  if AReveal and (AIndex >= 0) then
  begin
    R := FCells[AIndex].Bounds;
    if (R.Top < FOffset) or (R.Height > ClientHeight - 2) then
      ScrollTo(R.Top)
    else if R.Bottom > FOffset + ClientHeight - 2 then
      ScrollTo(R.Bottom - ClientHeight + 2);
  end;
  Invalidate;
end;

procedure TLazRibbonPopupGalleryWindow.MoveSelection(ADirection: Integer; AVertical: Boolean);
var
  I, Best, RowDistance, ColDistance, BestRow, BestCol: Integer;
  ActiveBounds, CandidateBounds: TRect;
begin
  if (FActiveCell < 0) or not AVertical then
  begin
    I := FActiveCell + ADirection;
    if (FActiveCell < 0) and (ADirection < 0) then
      I := High(FCells);
    while (I >= 0) and (I < Length(FCells)) do
    begin
      if IsSelectable(I) then
      begin
        SetActiveCell(I, True);
        Exit;
      end;
      Inc(I, ADirection);
    end;
    Exit;
  end;
  ActiveBounds := FCells[FActiveCell].Bounds;
  Best := -1;
  BestRow := MaxInt;
  BestCol := MaxInt;
  for I := 0 to High(FCells) do
  begin
    CandidateBounds := FCells[I].Bounds;
    RowDistance := (CandidateBounds.Top - ActiveBounds.Top) * ADirection;
    if (RowDistance <= 0) or (RowDistance > BestRow) or not IsSelectable(I) then
      Continue;
    ColDistance := Abs(CandidateBounds.Left + CandidateBounds.Right -
      ActiveBounds.Left - ActiveBounds.Right);
    if (RowDistance = BestRow) and (ColDistance >= BestCol) then Continue;
    Best := I;
    BestRow := RowDistance;
    BestCol := ColDistance;
  end;
  if Best >= 0 then
    SetActiveCell(Best, True);
end;

procedure TLazRibbonPopupGalleryWindow.Dismiss;
begin
  if (FMenu <> nil) and (FMenu.FGalleryWindow = Self) then
    FMenu.Close;
end;

procedure TLazRibbonPopupGalleryWindow.ActivateCell(AIndex: Integer);
var
  Entry: TLazRibbonPopupEntry;
  EntryID: Integer;
begin
  if not IsSelectable(AIndex) or (FMenu.FGalleryWindow <> Self) then Exit;
  Entry := EntryAt(AIndex);
  if Entry.Kind = pekToggle then
  begin
    Entry.Checked := not Entry.Checked;
    Invalidate;
    if Assigned(FMenu.FOnGallerySelect) then
      FMenu.FOnGallerySelect(FMenu, Entry);
    Exit;
  end;
  EntryID := Entry.ID;
  if Entry.Kind = pekChoice then
    FMenu.Gallery.SelectedIndex := Entry.Index;
  { Keep the window alive while OnClose can show a dialog or destroy the menu. }
  FMenu.FGalleryWindow := nil;
  try
    Hide;
    FMenu.Close;
    if (FMenu <> nil) and Assigned(FMenu.FOnGallerySelect) then
    begin
      Entry := TLazRibbonPopupEntry(FMenu.Gallery.Items.FindItemID(EntryID));
      if Entry <> nil then
        FMenu.FOnGallerySelect(FMenu, Entry);
    end;
  finally
    Release;
  end;
end;

procedure TLazRibbonPopupGalleryWindow.Deactivate;
begin
  inherited Deactivate;
  Dismiss;
end;

procedure TLazRibbonPopupGalleryWindow.DialogCode(var Message: TLMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTALLKEYS;
end;

procedure TLazRibbonPopupGalleryWindow.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Dismiss;
    VK_RETURN, VK_SPACE: ActivateCell(FActiveCell);
    VK_UP: MoveSelection(-1, True);
    VK_DOWN: MoveSelection(1, True);
    VK_LEFT: if IsRightToLeft then MoveSelection(1, False) else MoveSelection(-1, False);
    VK_RIGHT: if IsRightToLeft then MoveSelection(-1, False) else MoveSelection(1, False);
    VK_HOME:
      begin
        FActiveCell := -1;
        MoveSelection(1, False);
      end;
    VK_END:
      begin
        FActiveCell := -1;
        MoveSelection(-1, False);
      end;
    else
      begin
        inherited KeyDown(Key, Shift);
        Exit;
      end;
  end;
  Key := 0;
end;

procedure TLazRibbonPopupGalleryWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  Entry: TLazRibbonPopupEntry;
begin
  inherited MouseMove(Shift, X, Y);
  I := CellAt(X, Y);
  if I <> FActiveCell then
    SetActiveCell(I, False);
  Entry := EntryAt(I);
  if (Entry <> nil) and (Entry.Kind <> pekHeading) then
  begin
    if Hint <> Entry.Caption then
      Hint := Entry.Caption;
  end
  else
    Hint := '';
end;

procedure TLazRibbonPopupGalleryWindow.MouseLeave;
begin
  inherited MouseLeave;
  SetActiveCell(-1, False);
  Hint := '';
end;

procedure TLazRibbonPopupGalleryWindow.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
    FPressedCell := CellAt(X, Y);
end;

procedure TLazRibbonPopupGalleryWindow.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Pressed: Integer;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button <> mbLeft then Exit;
  Pressed := FPressedCell;
  FPressedCell := -1;
  if Pressed = CellAt(X, Y) then
    ActivateCell(Pressed);
end;

function TLazRibbonPopupGalleryWindow.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := FScrollBar <> nil;
  if Result then
    ScrollTo(FOffset - WheelDelta * FScrollBar.SmallChange div 120)
  else
    Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;

procedure TLazRibbonPopupGalleryWindow.PaintCell(AEntry: TLazRibbonPopupEntry;
  const R: TRect; AHot: Boolean);
var
  Content, Glyph: TRect;
  ImageSize: TSize;
  TextStyle: TTextStyle;
  TextHeight, Pad: Integer;
  ShowText: Boolean;
  FrameColor: TColor;
begin
  if AEntry.Kind = pekSpacer then Exit;
  Canvas.Font.Assign(Font);
  Canvas.Font.Color := FStyle.IdleCaptionColor;
  FrameColor := clNone;
  if AEntry.Kind = pekHeading then
    Canvas.Font.Style := Canvas.Font.Style + [fsBold]
  else if not AEntry.Enabled then
    Canvas.Font.Color := FStyle.DisabledCaptionColor
  else if AHot then
  begin
    Canvas.Brush.Color := FStyle.HotTrackGradientFromColor;
    Canvas.FillRect(R);
    Canvas.Font.Color := FStyle.HotTrackCaptionColor;
    FrameColor := FStyle.HotTrackFrameColor;
  end
  else if ((AEntry.Kind <> pekToggle) and AEntry.Checked) or
    (AEntry.ID = FMenu.Gallery.FSelectedID) then
  begin
    Canvas.Brush.Color := FStyle.CheckedGradientFromColor;
    Canvas.FillRect(R);
    FrameColor := FStyle.CheckedFrameColor;
  end;
  if FrameColor <> clNone then
  begin
    Canvas.Brush.Color := FrameColor;
    Canvas.FrameRect(R);
  end;

  Pad := Scale(4);
  Content := R;
  InflateRect(Content, -Pad, 0);
  if AEntry.Kind = pekHeading then
    if FStyle.DividerLineColor <> clNone then
    begin
      Canvas.Pen.Color := FStyle.DividerLineColor;
      Canvas.Line(R.Left, R.Top, R.Right, R.Top);
    end;
  ShowText := (AEntry.Kind <> pekChoice) or FMenu.Gallery.ShowCaptions;
  Glyph := Content;
  if ShowText then
  begin
    if IsRightToLeft then
      Glyph.Left := Max(Glyph.Left, Glyph.Right - Scale(26))
    else
      Glyph.Right := Min(Glyph.Right, Glyph.Left + Scale(26));
  end;
  if AEntry.Kind = pekToggle then
  begin
    Glyph := Bounds((Glyph.Left + Glyph.Right - Scale(12)) div 2,
      (R.Top + R.Bottom - Scale(12)) div 2, Scale(12), Scale(12));
    Canvas.Brush.Color := Canvas.Font.Color;
    Canvas.FrameRect(Glyph);
    if AEntry.Checked then
    begin
      Canvas.Pen.Color := Canvas.Font.Color;
      Canvas.Polyline([Point(Glyph.Left + Scale(2), Glyph.Top + Scale(6)),
        Point(Glyph.Left + Scale(5), Glyph.Bottom - Scale(3)),
        Point(Glyph.Right - Scale(2), Glyph.Top + Scale(3))]);
    end;
  end
  else if AEntry.Color <> clNone then
  begin
    InflateRect(Glyph, 0, -Pad);
    if not AEntry.Enabled then
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(Glyph);
    end
    else if AEntry.GradientColor <> clNone then
      Canvas.GradientFill(Glyph, AEntry.Color, AEntry.GradientColor, gdHorizontal)
    else
    begin
      Canvas.Brush.Color := AEntry.Color;
      Canvas.FillRect(Glyph);
    end;
    Canvas.Brush.Color := FStyle.DisabledCaptionColor;
    Canvas.FrameRect(Glyph);
  end
  else if (FMenu.Images <> nil) and (AEntry.ImageIndex >= 0) and
    (AEntry.ImageIndex < FMenu.Images.Count) then
  begin
    ImageSize := FMenu.Images.SizeForPPI[FMenu.ImagesWidth, FPPI];
    FMenu.Images.DrawForPPI(Canvas, (Glyph.Left + Glyph.Right - ImageSize.CX) div 2,
      (Glyph.Top + Glyph.Bottom - ImageSize.CY) div 2, AEntry.ImageIndex,
      FMenu.ImagesWidth, FPPI, 1.0, AEntry.Enabled);
  end
  else
    Glyph := Rect(0, 0, 0, 0);
  if not ShowText then Exit;
  if Glyph.Width > 0 then
    if IsRightToLeft then
      Content.Right := Glyph.Left - Pad
    else
      Content.Left := Glyph.Right + Pad;
  if Content.Width <= 0 then Exit;

  TextStyle := Canvas.TextStyle;
  TextStyle.Clipping := True;
  TextStyle.Opaque := False;
  TextStyle.EndEllipsis := True;
  TextStyle.Layout := tlCenter;
  TextStyle.RightToLeft := IsRightToLeft;
  if IsRightToLeft then
    TextStyle.Alignment := taRightJustify;
  Canvas.Brush.Style := bsClear;
  if AEntry.Description <> '' then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    TextHeight := Canvas.TextHeight('Tg');
    Content.Top := Max(R.Top, (R.Top + R.Bottom) div 2 - TextHeight);
    Content.Bottom := Min(R.Bottom, Content.Top + TextHeight);
  end;
  Canvas.TextRect(Content, Content.Left, Content.Top, AEntry.Caption, TextStyle);
  if AEntry.Description <> '' then
  begin
    Canvas.Font.Style := Font.Style;
    Content.Top := Content.Bottom;
    Content.Bottom := Min(R.Bottom, Content.Top + TextHeight);
    Canvas.TextRect(Content, Content.Left, Content.Top, AEntry.Description, TextStyle);
  end;
  Canvas.Brush.Style := bsSolid;
end;

procedure TLazRibbonPopupGalleryWindow.Paint;
var
  I: Integer;
  R, Viewport, PreviousClip, Clip: TRect;
  Entry: TLazRibbonPopupEntry;
begin
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  if FStyle.DividerLineColor <> clNone then
  begin
    Canvas.Brush.Color := FStyle.DividerLineColor;
    Canvas.FrameRect(ClientRect);
  end;
  Viewport := Rect(1, 1, 1 + FContentWidth, ClientHeight - 1);
  PreviousClip := Canvas.ClipRect;
  Canvas.SaveHandleState;
  try
    Canvas.Clipping := True;
    for I := 0 to High(FCells) do
    begin
      R := FCells[I].Bounds;
      OffsetRect(R, 0, 1 - FOffset);
      if R.Bottom <= Viewport.Top then Continue;
      if R.Top >= Viewport.Bottom then Break;
      Entry := EntryAt(I);
      if (Entry = nil) or not IntersectRect(Clip, R, Viewport) then Continue;
      if not IntersectRect(Clip, Clip, PreviousClip) then Continue;
      Canvas.ClipRect := Clip;
      PaintCell(Entry, R, I = FActiveCell);
    end;
  finally
    Canvas.RestoreHandleState;
  end;
end;

constructor TLazRibbonPopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGallery := TLazRibbonPopupGallery.Create(Self);
end;

destructor TLazRibbonPopupMenu.Destroy;
begin
  if FGalleryWindow <> nil then
  begin
    if ActivePopupMenu = Self then
      ActivePopupMenu := nil;
    HideGallery;
  end;
  FreeAndNil(FGallery);
  inherited Destroy;
end;

procedure TLazRibbonPopupMenu.SetGallery(AValue: TLazRibbonPopupGallery);
begin
  FGallery.Assign(AValue);
end;

procedure TLazRibbonPopupMenu.PopUp(X, Y: Integer);
var
  Window: TLazRibbonPopupGalleryWindow;
begin
  if not Gallery.Enabled then
  begin
    inherited PopUp(X, Y);
    Exit;
  end;

  if ActivePopupMenu <> nil then
    ActivePopupMenu.Close;
  SetPopupPoint(Point(X, Y));
  ReleaseCapture;
  DoPopup(Self);
  if not Gallery.Enabled then Exit;
  if Gallery.Items.Count = 0 then Exit;
  Window := TLazRibbonPopupGalleryWindow.CreateForMenu(Self, PopupPoint);
  FGalleryWindow := Window;
  ActivePopupMenu := Self;
  try
    Window.Show;
  except
    if FGalleryWindow = Window then
    begin
      ActivePopupMenu := nil;
      Window.Free;
    end;
    raise;
  end;
end;

procedure TLazRibbonPopupMenu.HideGallery;
var
  Window: TCustomForm;
begin
  Window := FGalleryWindow;
  if Window = nil then Exit;
  FGalleryWindow := nil;
  Window.Hide;
  Window.Release;
end;

procedure TLazRibbonPopupMenu.DoClose;
begin
  HideGallery;
  inherited DoClose;
end;

procedure TLazRibbonPopupMenu.DrawItemHandler(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
const
  CHECKBOX_STYLES: array[boolean] of TLazRibbonCheckboxStyle = (cbsCheckbox, cbsRadioButton);
var
  menuItem: TMenuItem;
  FrameColor: TColor = clNone;
  ColorFrom: TColor;
  ColorTo: TColor;
  TextColor: TColor;
  GradientType: TBackgroundKind;
  P: T2DIntPoint;
  R, Rgutter, Rcheck: T2DIntRect;
  Radius: Integer = 0;
  x, y, wGutter, hText, wText: Integer;
  iconSize: TSize;
  checkboxSize: TSize;
  isHot: Boolean;
  te: TThemedElementDetails;
  shortCutText: String;
begin
  if FAppearance = nil then
    exit;

  if (Sender is TMenuItem) then
  begin
    menuItem := TMenuItem(Sender);

    {$IFDEF EnhancedRecordSupport}
    R := T2DIntRect.Create(
    {$ELSE}
    R := Create2DIntRect(
    {$ENDIF}
      ARect.Left,
      ARect.Top,
      ARect.Right,
      ARect.Bottom - 1
    );
    isHot := AState * [odSelected, odHotLight] <>[];
    if not menuItem.Enabled then isHot := false;

    // Draw background
    if isHot then
    begin
      FrameColor := FAppearance.Popup.HotTrackFrameColor;
      ColorFrom := FAppearance.Popup.HotTrackGradientFromColor;
      ColorTo := FAppearance.Popup.HotTrackGradientToColor;
      GradientType := FAppearance.Popup.HotTrackGradientType;
      if FAppearance.Popup.SelectionShape = ssRounded then
        Radius := DropdownSelectionRadius
    end else
    begin
      ColorFrom := FAppearance.Popup.IdleGradientFromColor;
      ColorTo := FAppearance.Popup.IdleGradientToColor;
      GradientType := FAppearance.Popup.IdleGradientType;
    end;
    TGUITools.DrawPopupItemRect(ACanvas, R, Radius, ColorFrom, ColorTo, GradientType);
    if isHot and (FrameColor <> clNone) then
    begin
      if FAppearance.Popup.SelectionShape = ssRounded then
        TGUITools.DrawRoundRectBorder(ACanvas, R, Radius, FrameColor)
      else
      begin
        TGUITools.DrawHLine(ACanvas, R.Left, R.Right-1, R.Top, FrameColor);
        TGUITools.DrawHLine(ACanvas, R.Left, R.Right-1, R.Bottom-1, FrameColor);
        TGUITools.DrawVLine(ACanvas, R.Left, R.Top, R.Bottom-1, FrameColor);
        TGUITools.DrawVLine(ACanvas, R.Right-1, R.Top, R.Bottom-1, FrameColor);
      end;
    end;

    // Gutter

    iconSize := GetIconSize;
    wGutter := iconSize.CX + 2*DropdownMenuMargin;
    {$IFDEF EnhancedRecordSupport}
    Rgutter := T2DIntRect.Create(
    {$ELSE}
    Rgutter := Create2DIntRect(
    {$ENDIF}
      ARect.Left,
      ARect.Top,
      ARect.Left + wGutter - 1,
      ARect.Bottom
    );

    if not IsHot and (FAppearance.Popup.Style = psGutter) then
    begin
      FrameColor := FAppearance.Popup.GutterFrameColor;
      ColorFrom := FAppearance.Popup.GutterGradientFromColor;
      ColorTo := FAppearance.Popup.GutterGradientToColor;
      GradientType := FAppearance.Popup.GutterGradientType;
      TGUITools.DrawPopupItemRect(ACanvas, Rgutter, 0, ColorFrom, ColorTo, GradientType);
      if FrameColor <> clNone then
        TGUITools.DrawVLine(ACanvas, Rgutter.Right+1, R.Top, R.Bottom, FrameColor);
    end;

    // Checkbox
    if menuItem.Checked then
    begin
      {$IFDEF EnhancedRecordSupport}
      Rcheck := T2DIntRect.Create(
      {$ELSE}
      Rcheck := Create2DIntRect(
      {$ENDIF}
        ARect.Left,
        ARect.Top,
        ARect.Left + wGutter,
        ARect.Bottom - 1
      );
      FrameColor := FAppearance.Popup.CheckedFrameColor;
      ColorFrom := FAppearance.Popup.CheckedGradientFromColor;
      ColorTo := FAppearance.Popup.CheckedGradientToColor;
      GradientType := FAppearance.Popup.CheckedGradientType;
      TGUITools.DrawPopupItemRect(ACanvas, Rcheck, Radius, ColorFrom, ColorTo, GradientType);
      TGUITools.DrawHLine(ACanvas, Rcheck.Left, Rcheck.Right-1, Rcheck.Top, FrameColor);
      TGUITools.DrawHLine(ACanvas, Rcheck.Left, Rcheck.Right-1, Rcheck.Bottom-1, FrameColor);
      TGUITools.DrawVLine(ACanvas, Rcheck.Left, Rcheck.Top, Rcheck.Bottom-1, FrameColor);
      TGUITools.DrawVLine(ACanvas, Rcheck.Right-1, Rcheck.Top, Rcheck.Bottom-1, FrameColor);

      if not Assigned(Images) or (menuItem.ImageIndex = -1) then
      begin
        if ThemeServices.ThemesEnabled then
        begin
          if menuItem.Enabled then
          begin
            if menuItem.RadioItem then
              te := ThemeServices.GetElementDetails(tmPopupBulletNormal)
            else
              te := ThemeServices.GetElementDetails(tmPopupCheckmarkNormal);
          end else
          begin
            if menuItem.RadioItem then
              te := ThemeServices.GetElementDetails(tmPopupBulletDisabled)
            else
              te := ThemeServices.GetElementDetails(tmPopupCheckmarkDisabled);
          end;
          ThemeServices.DrawElement(ACanvas.Handle, te, Rect(Rcheck.Left, Rcheck.Top, Rcheck.Right, Rcheck.Bottom));
        end else
        begin
          checkboxSize.CX := GetSystemMetrics(SM_CYMENUCHECK);
          checkboxSize.CY := GetSystemMetrics(SM_CXMENUCHECK);
          x := (Rcheck.Left + Rcheck.Right - checkboxSize.CX) div 2;
          y := (Rcheck.Top + Rcheck.Bottom - checkboxSize.CY) div 2;
          TGUITools.DrawCheckbox(
            ACanvas,
            x, y,
            cbChecked,
            bsIdle,
            CHECKBOX_STYLES[menuItem.RadioItem]
          );
        end;
      end;
    end;

    // Draw icon
    if Assigned(Images) and (menuItem.ImageIndex > -1) then
    begin
      P := {$IFDEF EnhancedRecordSupport}T2DIntPoint.Create{$ELSE}Create2DIntPoint{$ENDIF}(
        ARect.Left + DropdownMenuMargin,
        (ARect.Top + ARect.Bottom - iconSize.CY) div 2
      );
      TGUITools.DrawImage(ACanvas, Images, menuItem.ImageIndex, P, RGutter, ImagesWidth, GetPPI, 1.0, menuItem.Enabled);
    end;

    // Draw text
    if menuItem.Enabled then
    begin
      if isHot then
        TextColor := FAppearance.Popup.HotTrackCaptionColor
      else
        TextColor := FAppearance.Popup.IdleCaptionColor;
    end else
      TextColor := FAppearance.Popup.DisabledCaptionColor;

    ACanvas.Font.Assign(FAppearance.Popup.CaptionFont);
    ACanvas.Font.Color := TextColor;
    hText := ACanvas.TextHeight('Tg');

    x := wGutter;
    inc(x, DropdownMenuMargin*2);

    if menuItem.IsLine then
    begin
      // Menu dividing lines
      if FAppearance.Popup.Style <> psGutter then
        x := DropDownMenuMargin;
      y := (ARect.Top + ARect.Bottom) div 2;
      FrameColor := FAppearance.Popup.DividerLineColor;
      if FrameColor <> clNone then
        TGUITools.DrawHLine(ACanvas, x, ARect.Right-DropdownMenuMargin, y, FrameColor);
    end else
    begin
      y := (ARect.Top + ARect.Bottom - hText) div 2;
      if menuItem.ShortCut <> scNone then
      begin
        // Shortcut text
        shortCutText := ShortCutToText(menuItem.ShortCut);
        if menuItem.ShortCutKey2 <> scNone then
          shortCutText := ShortCutText + ', ' + ShortCutToText(menuItem.ShortCutKey2);
        wText := ACanvas.TextWidth(shortCutText) + DropdownMenuMargin;
        TGUITools.DrawText(ACanvas, ARect.Right - wText, y, shortcutText, TextColor);
      end else
        wText := 0;

      // Caption
      R.Right := ARect.Right - wText;   // ClipRect to avoid painting into shortcut text
      TGUITools.DrawText(ACanvas, x, y, menuItem.Caption, TextColor, R, true);
    end;
  end;
end;

function TLazRibbonPopupMenu.GetIconSize: TSize;
begin
  if Assigned(Images) then
    Result := Images.SizeForPPI[ImagesWidth, GetPPI]
  else
  begin
    Result.CX := ScaleX(16, 96);
    Result.CY := Result.CX;
  end;
end;

function TLazRibbonPopupMenu.GetPPI: Integer;
begin
  if Parent is TControl then
    Result := TControl(Parent).Font.PixelsPerInch
  else
    Result := ScreenInfo.PixelsPerInchX;
end;

procedure TLazRibbonPopupMenu.MeasureItemHandler(Sender: TObject; ACanvas: TCanvas;
  var AWidth, AHeight: Integer);
begin
  //
end;

procedure TLazRibbonPopupMenu.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    (*    FAppearance does not inherit from TComponent !!!!!!!!!!!
    if AComponent = FAppearance then
      FAppearance := nil;
      *)
  end;
end;

procedure TLazRibbonPopupMenu.SetAppearance(AValue: TLazRibbonToolbarAppearance);
var
  i: Integer;
begin
//  if FAppearance = AValue then
//    exit;
  FAppearance := AValue;
  OwnerDraw := FAppearance <> nil;
  OnDrawItem := @DrawItemHandler;
  //OnMeasureItem := @MeasureItemHandler;

  for i := 0 to Items.Count-1 do
  begin
    Items[i].OnDrawItem := @DrawItemHandler;
    //Items[i].OnMeasureItem := @MeasureItemHandler;
  end;
end;

end.

