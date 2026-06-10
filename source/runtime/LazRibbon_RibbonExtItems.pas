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

unit LazRibbon_RibbonExtItems;

{$mode delphi}

interface

uses
  Classes, SysUtils, Types, Graphics, Controls, LCLType,
  LazRibbon_Math, LazRibbon_Appearance, LazRibbon_Dispatch, LazRibbon_BaseItem, LazRibbon_Types,
  LazRibbon_GraphTools, LazRibbon_SkinManager, LazRibbon_SkinDefinition;

type
  TLazRibbonExtItemDisplayMode = (rimCompact, rimNormal, rimLarge);
  TLazRibbonGalleryPopupMode = (gpmNone, gpmDropDown);
  TLazRibbonGalleryOverflowMode = (gomNone, gomScrollButtons);

  TLazRibbonExtItemEvent = procedure(Sender: TObject) of object;

  { TLazRibbonCustomRibbonExtItem }

  TLazRibbonCustomRibbonExtItem = class(TLazRibbonBaseItem)
  private
    FCaption: TCaption;
    FImageIndex: Integer;
    FLargeImageIndex: Integer;
    FDisplayMode: TLazRibbonExtItemDisplayMode;
    FWidth: Integer;
    FPressed: Boolean;
    FHot: Boolean;
    FOnClick: TLazRibbonExtItemEvent;
    procedure SetCaption(const AValue: TCaption);
    procedure SetDisplayMode(AValue: TLazRibbonExtItemDisplayMode);
    procedure SetImageIndex(AValue: Integer);
    procedure SetLargeImageIndex(AValue: Integer);
    procedure SetWidth(AValue: Integer);
  protected
    procedure ChangedMetrics;
    procedure ChangedVisuals;
    procedure DoClick; virtual;
    procedure DrawItemBackground(ABuffer: TBitmap; const R: TRect); virtual;
    procedure DrawItemContent(ABuffer: TBitmap; const R: TRect); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    function ExecuteKeyTip: Boolean; override;
    function GetWidth: integer; override;
    function GetTableBehaviour: TLazRibbonItemTableBehaviour; override;
    function GetGroupBehaviour: TLazRibbonItemGroupBehaviour; override;
    function GetSize: TLazRibbonItemSize; override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
  published
    property Caption: TCaption read FCaption write SetCaption;
    property DisplayMode: TLazRibbonExtItemDisplayMode read FDisplayMode write SetDisplayMode default rimNormal;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property LargeImageIndex: Integer read FLargeImageIndex write SetLargeImageIndex default -1;
    property Width: Integer read FWidth write SetWidth default 96;
    property OnClick: TLazRibbonExtItemEvent read FOnClick write FOnClick;
  end;

  { TLazRibbonControlHostItem }

  TLazRibbonControlHostItem = class(TLazRibbonCustomRibbonExtItem)
  private
    FControlName: String;
    FControlClassName: String;
    procedure SetControlName(const AValue: String);
    procedure SetControlClassName(const AValue: String);
  protected
    procedure DrawItemContent(ABuffer: TBitmap; const R: TRect); override;
  published
    property ControlName: String read FControlName write SetControlName;
    property ControlClassName: String read FControlClassName write SetControlClassName;
  end;

  { TLazRibbonGalleryItem }

  TLazRibbonGalleryItem = class(TLazRibbonCustomRibbonExtItem)
  private
    FColumns: Integer;
    FItemHeight: Integer;
    FItemWidth: Integer;
    FPopupMode: TLazRibbonGalleryPopupMode;
    FPopupWidth: Integer;
    FPopupHeight: Integer;
    procedure SetColumns(AValue: Integer);
    procedure SetItemHeight(AValue: Integer);
    procedure SetItemWidth(AValue: Integer);
    procedure SetPopupHeight(AValue: Integer);
    procedure SetPopupMode(AValue: TLazRibbonGalleryPopupMode);
    procedure SetPopupWidth(AValue: Integer);
  protected
    procedure DrawItemContent(ABuffer: TBitmap; const R: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Columns: Integer read FColumns write SetColumns default 4;
    property ItemWidth: Integer read FItemWidth write SetItemWidth default 22;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 22;
    property IconWidth: Integer read FItemWidth write SetItemWidth default 22;
    property IconHeight: Integer read FItemHeight write SetItemHeight default 22;
    property PopupMode: TLazRibbonGalleryPopupMode read FPopupMode write SetPopupMode default gpmDropDown;
    property PopupWidth: Integer read FPopupWidth write SetPopupWidth default 220;
    property PopupHeight: Integer read FPopupHeight write SetPopupHeight default 180;
  end;

  { TLazRibbonSkinGalleryItem }

  TLazRibbonSkinGalleryItem = class(TLazRibbonGalleryItem)
  private
    FSkinManager: TLazRibbonSkinManager;
    FShowHints: Boolean;
    FSelectedSkin: TLazRibbonBuiltInSkin;
    FSelectedSkinName: String;
    FHoverSkinIndex: Integer;
    FMaxVisibleItems: Integer;
    FVisibleStartIndex: Integer;
    FOverflowMode: TLazRibbonGalleryOverflowMode;
    FOnSkinSelected: TNotifyEvent;
    FHoverScrollButton: Integer;
    function GetSelectedSkin: TLazRibbonBuiltInSkin;
    function GetSelectedSkinName: String;
    procedure SetSelectedSkin(AValue: TLazRibbonBuiltInSkin);
    procedure SetSelectedSkinName(const AValue: String);
    procedure SetSkinManager(AValue: TLazRibbonSkinManager);
    procedure SetShowHints(AValue: Boolean);
    procedure ReadObsoleteShowCaptions(Reader: TReader);
    procedure SetMaxVisibleItems(AValue: Integer);
    procedure SetVisibleStartIndex(AValue: Integer);
    procedure SetOverflowMode(AValue: TLazRibbonGalleryOverflowMode);
    function EffectiveSkinManager: TLazRibbonSkinManager;
  protected
    function SkinCount: Integer; virtual;
    function SkinNameAtIndex(AIndex: Integer): String; virtual;
    function SkinCaptionAtIndex(AIndex: Integer): String; virtual;
    function SkinMainColorAtIndex(AIndex: Integer): TColor; virtual;
    function SkinAccentColorAtIndex(AIndex: Integer): TColor; virtual;
    function SkinCellRect(AIndex: Integer; const R: TRect): TRect; virtual;
    function SkinIndexAtPos(X, Y: Integer): Integer; virtual;
    function VisibleSkinCapacity(const R: TRect): Integer; virtual;
    function HasOverflow(const R: TRect): Boolean; virtual;
    function ScrollUpRect(const R: TRect): TRect; virtual;
    function ScrollDownRect(const R: TRect): TRect; virtual;
    function ScrollButtonAtPos(X, Y: Integer): Integer; virtual;
    procedure SelectSkinIndex(AIndex: Integer); virtual;
    procedure ScrollBy(Delta: Integer); virtual;
    procedure DrawScrollButtons(ABuffer: TBitmap; const R: TRect); virtual;
    procedure DrawItemBackground(ABuffer: TBitmap; const R: TRect); override;
    procedure DrawItemContent(ABuffer: TBitmap; const R: TRect); override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetHintAtPos(X, Y: Integer; out AHint: TTranslateString;
      out ACursorRect: TRect): Boolean; override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    function GetWidth: integer; override;
  published
    property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;
    property SelectedSkin: TLazRibbonBuiltInSkin read GetSelectedSkin write SetSelectedSkin default sbsOfficeBlue;
    property SelectedSkinName: String read GetSelectedSkinName write SetSelectedSkinName;
    property ShowHints: Boolean read FShowHints write SetShowHints default True;
    { IconWidth/IconHeight are inherited from TLazRibbonGalleryItem and are
      the public design-time size controls for this compact skin gallery.
      ItemWidth/ItemHeight are deliberately hidden at design time for
      TLazRibbonSkinGalleryItem by registerlaztoolbar.pas. }
    property MaxVisibleItems: Integer read FMaxVisibleItems write SetMaxVisibleItems default 12;
    property VisibleStartIndex: Integer read FVisibleStartIndex write SetVisibleStartIndex default 0;
    property OverflowMode: TLazRibbonGalleryOverflowMode read FOverflowMode write SetOverflowMode default gomScrollButtons;
    property OnSkinSelected: TNotifyEvent read FOnSkinSelected write FOnSkinSelected;
  end;

implementation

function RectWidth(const R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;

function RectHeight(const R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;

function MakeTRect(ALeft, ATop, ARight, ABottom: Integer): TRect;
begin
  Result.Left := ALeft;
  Result.Top := ATop;
  Result.Right := ARight;
  Result.Bottom := ABottom;
end;

{ TLazRibbonCustomRibbonExtItem }

constructor TLazRibbonCustomRibbonExtItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := 'Ribbon Item';
  FImageIndex := -1;
  FLargeImageIndex := -1;
  FDisplayMode := rimNormal;
  FWidth := 96;
  FPressed := False;
  FHot := False;
end;

procedure TLazRibbonCustomRibbonExtItem.ChangedMetrics;
begin
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonCustomRibbonExtItem.ChangedVisuals;
begin
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonCustomRibbonExtItem.DoClick;
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

function TLazRibbonCustomRibbonExtItem.ExecuteKeyTip: Boolean;
begin
  Result := FVisible and FEnabled and Assigned(FOnClick);
  if Result then
    DoClick;
end;

procedure TLazRibbonCustomRibbonExtItem.DrawItemBackground(ABuffer: TBitmap; const R: TRect);
var
  C: TColor;
begin
  if FPressed then
    C := $00D8C7AA
  else if FHot then
    C := $00EFE3CA
  else
    C := clBtnFace;

  ABuffer.Canvas.Brush.Color := C;
  ABuffer.Canvas.Pen.Color := clBtnShadow;
  ABuffer.Canvas.Rectangle(R);
end;

procedure TLazRibbonCustomRibbonExtItem.DrawItemContent(ABuffer: TBitmap; const R: TRect);
var
  TR: TRect;
  TextY: Integer;
begin
  ABuffer.Canvas.Font.Color := clWindowText;
  ABuffer.Canvas.Brush.Style := bsClear;
  TR := R;
  InflateRect(TR, -4, -4);
  TextY := TR.Top + (TR.Bottom - TR.Top - ABuffer.Canvas.TextHeight(FCaption)) div 2;
  ABuffer.Canvas.TextRect(TR, TR.Left + 2, TextY, FCaption);
  ABuffer.Canvas.Brush.Style := bsSolid;
end;

procedure TLazRibbonCustomRibbonExtItem.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  R: TRect;
begin
  if not Visible then
    Exit;
  R := FRect.ForWinAPI;
  if (RectWidth(R) <= 0) or (RectHeight(R) <= 0) then
    Exit;
  DrawItemBackground(ABuffer, R);
  DrawItemContent(ABuffer, R);
end;

function TLazRibbonCustomRibbonExtItem.GetGroupBehaviour: TLazRibbonItemGroupBehaviour;
begin
  Result := gbSingleItem;
end;

function TLazRibbonCustomRibbonExtItem.GetSize: TLazRibbonItemSize;
begin
  if FDisplayMode = rimLarge then
    Result := isLarge
  else
    Result := isNormal;
end;

function TLazRibbonCustomRibbonExtItem.GetTableBehaviour: TLazRibbonItemTableBehaviour;
begin
  Result := tbBeginsColumn;
end;

function TLazRibbonCustomRibbonExtItem.GetWidth: integer;
begin
  Result := FWidth;
end;

procedure TLazRibbonCustomRibbonExtItem.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Enabled then
  begin
    FPressed := True;
    ChangedVisuals;
  end;
end;

procedure TLazRibbonCustomRibbonExtItem.MouseLeave;
begin
  if FHot or FPressed then
  begin
    FHot := False;
    FPressed := False;
    ChangedVisuals;
  end;
end;

procedure TLazRibbonCustomRibbonExtItem.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if not FHot then
  begin
    FHot := True;
    ChangedVisuals;
  end;
end;

procedure TLazRibbonCustomRibbonExtItem.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and FPressed then
  begin
    FPressed := False;
    ChangedVisuals;
    if Enabled then
      DoClick;
  end;
end;

procedure TLazRibbonCustomRibbonExtItem.Notify(Item: TComponent; Operation: TOperation);
begin
  { Base extensible item has no external component references. }
end;

procedure TLazRibbonCustomRibbonExtItem.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonCustomRibbonExtItem.SetDisplayMode(AValue: TLazRibbonExtItemDisplayMode);
begin
  if FDisplayMode = AValue then Exit;
  FDisplayMode := AValue;
  ChangedMetrics;
end;

procedure TLazRibbonCustomRibbonExtItem.SetImageIndex(AValue: Integer);
begin
  if FImageIndex = AValue then Exit;
  FImageIndex := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonCustomRibbonExtItem.SetLargeImageIndex(AValue: Integer);
begin
  if FLargeImageIndex = AValue then Exit;
  FLargeImageIndex := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonCustomRibbonExtItem.SetWidth(AValue: Integer);
begin
  if AValue < 24 then AValue := 24;
  if FWidth = AValue then Exit;
  FWidth := AValue;
  ChangedMetrics;
end;

{ TLazRibbonControlHostItem }

procedure TLazRibbonControlHostItem.DrawItemContent(ABuffer: TBitmap; const R: TRect);
var
  TR: TRect;
  S: String;
begin
  inherited DrawItemContent(ABuffer, R);
  if FControlName <> '' then
  begin
    S := FControlName;
    TR := R;
    InflateRect(TR, -6, -6);
    TR.Top := TR.Bottom - ABuffer.Canvas.TextHeight(S) - 2;
    ABuffer.Canvas.Font.Color := clGrayText;
    ABuffer.Canvas.Brush.Style := bsClear;
    ABuffer.Canvas.TextRect(TR, TR.Left + 2, TR.Top, S);
    ABuffer.Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TLazRibbonControlHostItem.SetControlClassName(const AValue: String);
begin
  if FControlClassName = AValue then Exit;
  FControlClassName := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonControlHostItem.SetControlName(const AValue: String);
begin
  if FControlName = AValue then Exit;
  FControlName := AValue;
  ChangedVisuals;
end;

{ TLazRibbonGalleryItem }

constructor TLazRibbonGalleryItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := 'Gallery';
  Width := 126;
  FColumns := 4;
  FItemWidth := 22;
  FItemHeight := 22;
  FPopupMode := gpmDropDown;
  FPopupWidth := 220;
  FPopupHeight := 180;
end;

procedure TLazRibbonGalleryItem.DrawItemContent(ABuffer: TBitmap; const R: TRect);
var
  I, Col, Row, X, Y: Integer;
  Cell, TR: TRect;
begin
  ABuffer.Canvas.Font.Color := clWindowText;
  ABuffer.Canvas.Brush.Style := bsClear;
  TR := MakeTRect(R.Left + 4, R.Top + 2, R.Right - 4, R.Top + 18);
  ABuffer.Canvas.TextRect(TR, TR.Left + 2, TR.Top, Caption);
  ABuffer.Canvas.Brush.Style := bsSolid;

  for I := 0 to 5 do
  begin
    Col := I mod FColumns;
    Row := I div FColumns;
    X := R.Left + 8 + Col * (FItemWidth + 4);
    Y := R.Top + 24 + Row * (FItemHeight + 4);
    Cell := MakeTRect(X, Y, X + FItemWidth, Y + FItemHeight);
    if Cell.Bottom > R.Bottom - 4 then Break;
    ABuffer.Canvas.Brush.Color := clWindow;
    ABuffer.Canvas.Pen.Color := clBtnShadow;
    ABuffer.Canvas.Rectangle(Cell);
  end;
end;

procedure TLazRibbonGalleryItem.SetColumns(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  if FColumns = AValue then Exit;
  FColumns := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonGalleryItem.SetItemHeight(AValue: Integer);
begin
  if AValue < 8 then AValue := 8;
  if FItemHeight = AValue then Exit;
  FItemHeight := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonGalleryItem.SetItemWidth(AValue: Integer);
begin
  if AValue < 8 then AValue := 8;
  if FItemWidth = AValue then Exit;
  FItemWidth := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonGalleryItem.SetPopupHeight(AValue: Integer);
begin
  if AValue < 64 then AValue := 64;
  FPopupHeight := AValue;
end;

procedure TLazRibbonGalleryItem.SetPopupMode(AValue: TLazRibbonGalleryPopupMode);
begin
  FPopupMode := AValue;
end;

procedure TLazRibbonGalleryItem.SetPopupWidth(AValue: Integer);
begin
  if AValue < 64 then AValue := 64;
  FPopupWidth := AValue;
end;

{ TLazRibbonSkinGalleryItem }

constructor TLazRibbonSkinGalleryItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := 'Skins';
  DisplayMode := rimLarge;
  Width := 166;
  Columns := 4;
  ItemWidth := 22;
  ItemHeight := 22;
  FShowHints := True;
  FSelectedSkin := sbsOfficeBlue;
  FSelectedSkinName := LazBuiltInSkinToString(sbsOfficeBlue);
  FHoverSkinIndex := -1;
  FMaxVisibleItems := 12;
  FVisibleStartIndex := 0;
  FOverflowMode := gomScrollButtons;
  FHoverScrollButton := -1;
  Hint := '';
end;

procedure TLazRibbonSkinGalleryItem.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  { Compatibility with older .lfm files. ShowCaptions was removed from the
    public design-time API because the Ribbon gallery must stay compact. }
  Filer.DefineProperty('ShowCaptions', ReadObsoleteShowCaptions, nil, False);
end;

function TLazRibbonSkinGalleryItem.EffectiveSkinManager: TLazRibbonSkinManager;
var
  Provider: ILazRibbonSkinProvider;
  Obj: TObject;
begin
  Result := FSkinManager;
  if Result <> nil then
    Exit;

  { Normal use: this item lives inside TLazRibbon. In that case the
    SkinManager should be inherited from the owning Ribbon through the
    toolbar skin provider.  This avoids forcing the programmer to set the
    same SkinManager twice and avoids a unit reference back to
    LazRibbon_Core. }
  if FToolbarDispatch = nil then
    Exit;

  Provider := FToolbarDispatch.GetSkinProvider;
  if Provider = nil then
    Exit;

  Obj := Provider.GetSkinManagerObject;
  if Obj is TLazRibbonSkinManager then
    Result := TLazRibbonSkinManager(Obj);
end;

procedure TLazRibbonSkinGalleryItem.DrawItemBackground(ABuffer: TBitmap; const R: TRect);
var
  BackColor, FrameColor: TColor;
  SM: TLazRibbonSkinManager;
begin
  { The skin chooser is an inline gallery panel, not a single push button. }
  SM := EffectiveSkinManager;
  if SM <> nil then
  begin
    BackColor := SM.Ribbon.GroupColor;
    FrameColor := SM.Ribbon.GroupFrameColor;
  end
  else
  begin
    BackColor := clBtnFace;
    FrameColor := clBtnShadow;
  end;

  ABuffer.Canvas.Brush.Color := BackColor;
  ABuffer.Canvas.Pen.Color := FrameColor;
  ABuffer.Canvas.Rectangle(R);
end;

procedure TLazRibbonSkinGalleryItem.DrawScrollButtons(ABuffer: TBitmap; const R: TRect);
var
  UpR, DownR: TRect;
  BaseC, HotC, PressedC, FrameC, GlyphC, DisabledGlyphC: TColor;
  UpEnabled, DownEnabled: Boolean;
  SM: TLazRibbonSkinManager;

  procedure DrawChevronButton(const ButtonR: TRect; AKind: Integer; AEnabled, AHot: Boolean);
  var
    C1, C2, GC: TColor;
    MidX, MidY: Integer;
    Pts: array[0..2] of TPoint;
    OldWidth: Integer;
  begin
    if AHot and AEnabled then
    begin
      C1 := TColorTools.Brighten(HotC, 16);
      C2 := TColorTools.Darken(HotC, 4);
    end
    else
    begin
      C1 := TColorTools.Brighten(BaseC, 12);
      C2 := TColorTools.Darken(BaseC, 5);
    end;

    if not AEnabled then
    begin
      C1 := TColorTools.Shade(C1, BaseC, 65);
      C2 := TColorTools.Shade(C2, BaseC, 65);
    end;

    TGradientTools.VGradient(ABuffer.Canvas, C1, C2, ButtonR.Left, ButtonR.Top, ButtonR.Right, ButtonR.Bottom);
    ABuffer.Canvas.Brush.Style := bsClear;
    ABuffer.Canvas.Pen.Color := FrameC;
    ABuffer.Canvas.Rectangle(ButtonR);
    ABuffer.Canvas.Brush.Style := bsSolid;

    if AEnabled then
      GC := GlyphC
    else
      GC := DisabledGlyphC;

    MidX := (ButtonR.Left + ButtonR.Right) div 2;
    MidY := (ButtonR.Top + ButtonR.Bottom) div 2;

    if AKind < 0 then
    begin
      Pts[0] := Point(MidX - 4, MidY + 2);
      Pts[1] := Point(MidX,     MidY - 2);
      Pts[2] := Point(MidX + 4, MidY + 2);
    end
    else
    begin
      Pts[0] := Point(MidX - 4, MidY - 2);
      Pts[1] := Point(MidX,     MidY + 2);
      Pts[2] := Point(MidX + 4, MidY - 2);
    end;

    OldWidth := ABuffer.Canvas.Pen.Width;
    try
      ABuffer.Canvas.Pen.Width := 2;
      ABuffer.Canvas.Pen.Color := GC;
      ABuffer.Canvas.Brush.Style := bsClear;
      ABuffer.Canvas.Polyline(Pts);
    finally
      ABuffer.Canvas.Pen.Width := OldWidth;
      ABuffer.Canvas.Brush.Style := bsSolid;
    end;
  end;

begin
  if not HasOverflow(R) then
    Exit;

  SM := EffectiveSkinManager;
  if SM <> nil then
  begin
    BaseC := SM.Ribbon.GroupColor;
    HotC := SM.Ribbon.TabHotColor;
    PressedC := SM.Ribbon.TabActiveColor;
    FrameC := SM.Ribbon.GroupFrameColor;
    GlyphC := SM.General.TextColor;
  end
  else
  begin
    BaseC := clBtnFace;
    HotC := clInfoBk;
    PressedC := clHighlight;
    FrameC := clBtnShadow;
    GlyphC := clWindowText;
  end;

  { Keep the variable intentionally meaningful for future pressed-state drawing. }
  if PressedC = clNone then
    PressedC := HotC;

  DisabledGlyphC := TColorTools.Shade(GlyphC, BaseC, 60);

  UpR := ScrollUpRect(R);
  DownR := ScrollDownRect(R);
  UpEnabled := FVisibleStartIndex > 0;
  DownEnabled := FVisibleStartIndex + VisibleSkinCapacity(R) < SkinCount;

  DrawChevronButton(UpR, -1, UpEnabled, FHoverScrollButton = 0);
  DrawChevronButton(DownR, 1, DownEnabled, FHoverScrollButton = 1);
end;

procedure TLazRibbonSkinGalleryItem.DrawItemContent(ABuffer: TBitmap; const R: TRect);
var
  I, LastIndex, Capacity: Integer;
  Cell, Swatch: TRect;
  SkinName: String;
  IsSelected, IsHot: Boolean;
  MainColor, AccentColor, SelFrame, HotFrame, TextC: TColor;
  SM: TLazRibbonSkinManager;
  SkinDef: TLazRibbonSkinDefinition;
begin
  { Ribbon gallery is compact: no visible captions. Skin names are exposed by Hint. }
  SM := EffectiveSkinManager;
  if SM <> nil then
  begin
    SelFrame := SM.Ribbon.TabActiveColor;
    HotFrame := SM.Ribbon.TabHotColor;
    TextC := SM.General.TextColor;
  end
  else
  begin
    SelFrame := clHighlight;
    HotFrame := clInfoBk;
    TextC := clWindowText;
  end;

  Capacity := VisibleSkinCapacity(R);
  if Capacity <= 0 then
    Exit;

  if FVisibleStartIndex < 0 then
    FVisibleStartIndex := 0;
  if FVisibleStartIndex >= SkinCount then
    FVisibleStartIndex := 0;

  LastIndex := FVisibleStartIndex + Capacity - 1;
  if LastIndex >= SkinCount then
    LastIndex := SkinCount - 1;

  for I := FVisibleStartIndex to LastIndex do
  begin
    SkinName := SkinNameAtIndex(I);
    Cell := SkinCellRect(I, R);
    if (Cell.Right > R.Right - 4) or (Cell.Bottom > R.Bottom - 4) then
      Continue;

    IsSelected := SameText(SkinName, GetSelectedSkinName);
    IsHot := I = FHoverSkinIndex;
    MainColor := SkinMainColorAtIndex(I);
    AccentColor := SkinAccentColorAtIndex(I);
    SkinDef := nil;
    if SM <> nil then
      SkinDef := SM.SkinByIndex(I);

    if IsSelected then
    begin
      ABuffer.Canvas.Brush.Color := SelFrame;
      ABuffer.Canvas.Pen.Color := AccentColor;
      ABuffer.Canvas.Rectangle(MakeTRect(Cell.Left - 3, Cell.Top - 3, Cell.Right + 3, Cell.Bottom + 3));
    end
    else if IsHot then
    begin
      ABuffer.Canvas.Brush.Color := HotFrame;
      ABuffer.Canvas.Pen.Color := AccentColor;
      ABuffer.Canvas.Rectangle(MakeTRect(Cell.Left - 3, Cell.Top - 3, Cell.Right + 3, Cell.Bottom + 3));
    end;

    Swatch := Cell;
    InflateRect(Swatch, -2, -2);
    if not LazDrawSkinDefinitionIcon(ABuffer.Canvas, SkinDef, ItemWidth, Swatch) then
    begin
      ABuffer.Canvas.Brush.Color := MainColor;
      ABuffer.Canvas.Pen.Color := AccentColor;
      ABuffer.Canvas.Rectangle(Swatch);

      { Accent stripe / color block }
      ABuffer.Canvas.Brush.Color := AccentColor;
      ABuffer.Canvas.Pen.Color := AccentColor;
      ABuffer.Canvas.Rectangle(MakeTRect(
        Swatch.Left + (Swatch.Right - Swatch.Left) div 2,
        Swatch.Top + 3,
        Swatch.Right - 3,
        Swatch.Bottom - 3));

      { Small glossy highlight }
      ABuffer.Canvas.Brush.Color := clWhite;
      ABuffer.Canvas.Pen.Color := clWhite;
      ABuffer.Canvas.Rectangle(MakeTRect(Swatch.Left + 3, Swatch.Top + 3,
        Swatch.Left + 8, Swatch.Top + 8));
    end;
  end;

  DrawScrollButtons(ABuffer, R);

  { Avoid compiler hint about TextC in FPC modes where TextOut glyphs are optimized differently. }
  ABuffer.Canvas.Font.Color := TextC;
end;

function TLazRibbonSkinGalleryItem.GetHintAtPos(X, Y: Integer;
  out AHint: TTranslateString; out ACursorRect: TRect): Boolean;
var
  I: Integer;
  R: TRect;
begin
  AHint := ''; 
  ACursorRect := MakeTRect(X, Y, X, Y);
  Result := False;

  if not FShowHints then
    Exit;

  I := SkinIndexAtPos(X, Y);
  if I < 0 then
    Exit;

  R := FRect.ForWinAPI;
  ACursorRect := SkinCellRect(I, R);
  InflateRect(ACursorRect, 3, 3);
  AHint := SkinCaptionAtIndex(I);
  Result := AHint <> ''; 
end;

function TLazRibbonSkinGalleryItem.GetWidth: integer;
var
  Needed, C, VisibleCount: Integer;
begin
  C := Columns;
  if C < 1 then
    C := 1;

  VisibleCount := FMaxVisibleItems;
  if VisibleCount < 1 then
    VisibleCount := SkinCount;
  if VisibleCount > SkinCount then
    VisibleCount := SkinCount;
  if VisibleCount < C then
    C := VisibleCount;

  Needed := 16 + C * (ItemWidth + 8);
  if FOverflowMode = gomScrollButtons then
    Inc(Needed, 18);

  if Needed < inherited GetWidth then
    Result := inherited GetWidth
  else
    Result := Needed;
end;

function TLazRibbonSkinGalleryItem.GetSelectedSkin: TLazRibbonBuiltInSkin;
var
  SM: TLazRibbonSkinManager;
begin
  SM := EffectiveSkinManager;
  if SM <> nil then
    Result := SM.ActiveSkin
  else
    Result := FSelectedSkin;
end;

function TLazRibbonSkinGalleryItem.GetSelectedSkinName: String;
var
  SM: TLazRibbonSkinManager;
begin
  SM := EffectiveSkinManager;
  if SM <> nil then
    Result := SM.ActiveSkinName
  else
    Result := FSelectedSkinName;
end;

procedure TLazRibbonSkinGalleryItem.MouseLeave;
begin
  FHoverSkinIndex := -1;
  FHoverScrollButton := -1;
  Hint := '';
  ChangedVisuals;
  inherited MouseLeave;
end;

procedure TLazRibbonSkinGalleryItem.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I, ScrollButton: Integer;
begin
  ScrollButton := ScrollButtonAtPos(X, Y);
  if ScrollButton >= 0 then
    I := -1
  else
    I := SkinIndexAtPos(X, Y);

  if (I <> FHoverSkinIndex) or (ScrollButton <> FHoverScrollButton) then
  begin
    FHoverSkinIndex := I;
    FHoverScrollButton := ScrollButton;
    if FShowHints and (I >= 0) then
      Hint := SkinCaptionAtIndex(I)
    else
      Hint := '';
    ChangedVisuals;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TLazRibbonSkinGalleryItem.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  R: TRect;
  P1, P2: TPoint;
begin
  if Button = mbLeft then
  begin
    R := FRect.ForWinAPI;
    P1 := Point(X, Y);
    P2 := Point(R.Left + X, R.Top + Y);

    if HasOverflow(R) then
    begin
      if PtInRect(ScrollUpRect(R), P1) or PtInRect(ScrollUpRect(R), P2) then
      begin
        ScrollBy(-Columns);
        inherited MouseUp(Button, Shift, X, Y);
        Exit;
      end;
      if PtInRect(ScrollDownRect(R), P1) or PtInRect(ScrollDownRect(R), P2) then
      begin
        ScrollBy(Columns);
        inherited MouseUp(Button, Shift, X, Y);
        Exit;
      end;
    end;

    I := SkinIndexAtPos(X, Y);
    if I >= 0 then
      SelectSkinIndex(I);
  end;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TLazRibbonSkinGalleryItem.Notify(Item: TComponent; Operation: TOperation);
begin
  inherited Notify(Item, Operation);
  if (Operation = opRemove) and (Item = FSkinManager) then
    FSkinManager := nil;
end;

procedure TLazRibbonSkinGalleryItem.SelectSkinIndex(AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= SkinCount) then
    Exit;
  SelectedSkinName := SkinNameAtIndex(AIndex);
  if Assigned(FOnSkinSelected) then
    FOnSkinSelected(Self);
end;

procedure TLazRibbonSkinGalleryItem.SetSelectedSkin(AValue: TLazRibbonBuiltInSkin);
begin
  FSelectedSkin := AValue;
  SetSelectedSkinName(LazBuiltInSkinToString(AValue));
end;

procedure TLazRibbonSkinGalleryItem.SetSelectedSkinName(const AValue: String);
var
  BuiltIn: TLazRibbonBuiltInSkin;
  SM: TLazRibbonSkinManager;
begin
  if SameText(GetSelectedSkinName, AValue) then Exit;
  FSelectedSkinName := AValue;
  if LazRibbon_SkinDefinition.LazBuiltInSkinFromString(AValue, BuiltIn) then
    FSelectedSkin := BuiltIn;
  SM := EffectiveSkinManager;
  if SM <> nil then
    SM.ActiveSkinName := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonSkinGalleryItem.SetShowHints(AValue: Boolean);
begin
  if FShowHints = AValue then Exit;
  FShowHints := AValue;
  if not FShowHints then
    Hint := ''
  else if FHoverSkinIndex >= 0 then
    Hint := SkinCaptionAtIndex(FHoverSkinIndex);
  ChangedVisuals;
end;

procedure TLazRibbonSkinGalleryItem.ReadObsoleteShowCaptions(Reader: TReader);
begin
  { Intentionally ignored. Kept only so old .lfm files that still contain
    ShowCaptions can be opened and saved again without breaking. }
  Reader.ReadBoolean;
end;

procedure TLazRibbonSkinGalleryItem.SetMaxVisibleItems(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  if FMaxVisibleItems = AValue then Exit;
  FMaxVisibleItems := AValue;
  if FVisibleStartIndex > SkinCount - 1 then
    FVisibleStartIndex := 0;
  ChangedMetrics;
end;

procedure TLazRibbonSkinGalleryItem.SetVisibleStartIndex(AValue: Integer);
begin
  if AValue < 0 then AValue := 0;
  if AValue >= SkinCount then AValue := SkinCount - 1;
  if FVisibleStartIndex = AValue then Exit;
  FVisibleStartIndex := AValue;
  ChangedVisuals;
end;

procedure TLazRibbonSkinGalleryItem.SetOverflowMode(AValue: TLazRibbonGalleryOverflowMode);
begin
  if FOverflowMode = AValue then Exit;
  FOverflowMode := AValue;
  ChangedMetrics;
end;

procedure TLazRibbonSkinGalleryItem.SetSkinManager(AValue: TLazRibbonSkinManager);
begin
  if FSkinManager = AValue then Exit;
  if FSkinManager <> nil then
    FSkinManager.RemoveFreeNotification(Self);
  FSkinManager := AValue;
  if FSkinManager <> nil then
  begin
    FSkinManager.FreeNotification(Self);
    FSelectedSkin := FSkinManager.ActiveSkin;
    FSelectedSkinName := FSkinManager.ActiveSkinName;
  end;
  ChangedVisuals;
end;

function TLazRibbonSkinGalleryItem.SkinAccentColorAtIndex(AIndex: Integer): TColor;
var
  Skin: TLazRibbonSkinDefinition;
  SM: TLazRibbonSkinManager;
begin
  Skin := nil;
  SM := EffectiveSkinManager;
  if SM <> nil then
    Skin := SM.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.Palette.ActiveColor
  else
    Result := LazBuiltInSkinAccentColor(LazBuiltInSkinByIndex(AIndex));
end;

function TLazRibbonSkinGalleryItem.SkinNameAtIndex(AIndex: Integer): String;
var
  Skin: TLazRibbonSkinDefinition;
  SM: TLazRibbonSkinManager;
begin
  Skin := nil;
  SM := EffectiveSkinManager;
  if SM <> nil then
    Skin := SM.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.Name
  else
    Result := LazBuiltInSkinToString(LazBuiltInSkinByIndex(AIndex));
end;

function TLazRibbonSkinGalleryItem.SkinCaptionAtIndex(AIndex: Integer): String;
var
  Skin: TLazRibbonSkinDefinition;
  SM: TLazRibbonSkinManager;
begin
  Skin := nil;
  SM := EffectiveSkinManager;
  if SM <> nil then
    Skin := SM.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.DisplayName
  else
    Result := LazBuiltInSkinCaption(LazBuiltInSkinByIndex(AIndex));
  if Result = '' then
    Result := SkinNameAtIndex(AIndex);
end;

function TLazRibbonSkinGalleryItem.ScrollUpRect(const R: TRect): TRect;
begin
  Result := MakeTRect(R.Right - 17, R.Top + 6, R.Right - 3, R.Top + 23);
end;

function TLazRibbonSkinGalleryItem.ScrollDownRect(const R: TRect): TRect;
begin
  Result := MakeTRect(R.Right - 17, R.Bottom - 23, R.Right - 3, R.Bottom - 6);
end;

function TLazRibbonSkinGalleryItem.ScrollButtonAtPos(X, Y: Integer): Integer;
var
  R: TRect;
  P: TPoint;
begin
  Result := -1;
  R := FRect.ForWinAPI;
  if not HasOverflow(R) then
    Exit;

  P := Point(X, Y);
  if PtInRect(ScrollUpRect(R), P) then
  begin
    Result := 0;
    Exit;
  end;
  if PtInRect(ScrollDownRect(R), P) then
  begin
    Result := 1;
    Exit;
  end;

  { Some toolbar dispatch paths deliver item-local coordinates. Try that too. }
  P := Point(R.Left + X, R.Top + Y);
  if PtInRect(ScrollUpRect(R), P) then
    Result := 0
  else if PtInRect(ScrollDownRect(R), P) then
    Result := 1;
end;

function TLazRibbonSkinGalleryItem.HasOverflow(const R: TRect): Boolean;
begin
  Result := (FOverflowMode = gomScrollButtons) and
            (SkinCount > VisibleSkinCapacity(R));
end;

function TLazRibbonSkinGalleryItem.VisibleSkinCapacity(const R: TRect): Integer;
var
  Rows, C, H: Integer;
begin
  C := Columns;
  if C < 1 then C := 1;

  H := R.Bottom - R.Top - 12;
  Rows := H div (ItemHeight + 8);
  if Rows < 1 then Rows := 1;

  Result := Rows * C;
  if (FMaxVisibleItems > 0) and (Result > FMaxVisibleItems) then
    Result := FMaxVisibleItems;
  if Result < 1 then Result := 1;
end;

procedure TLazRibbonSkinGalleryItem.ScrollBy(Delta: Integer);
var
  NewIndex, Capacity, MaxStart: Integer;
  R: TRect;
begin
  R := FRect.ForWinAPI;
  Capacity := VisibleSkinCapacity(R);
  if Capacity < 1 then Capacity := 1;

  NewIndex := FVisibleStartIndex + Delta;
  MaxStart := SkinCount - Capacity;
  if MaxStart < 0 then MaxStart := 0;
  if NewIndex < 0 then NewIndex := 0;
  if NewIndex > MaxStart then NewIndex := MaxStart;

  if FVisibleStartIndex <> NewIndex then
  begin
    FVisibleStartIndex := NewIndex;
    ChangedVisuals;
  end;
end;

function TLazRibbonSkinGalleryItem.SkinCellRect(AIndex: Integer; const R: TRect): TRect;
var
  LocalIndex, Col, Row, C, RightPad: Integer;
begin
  C := Columns;
  if C < 1 then
    C := 1;
  LocalIndex := AIndex - FVisibleStartIndex;
  if LocalIndex < 0 then LocalIndex := 0;
  Col := LocalIndex mod C;
  Row := LocalIndex div C;
  if HasOverflow(R) then
    RightPad := 20
  else
    RightPad := 4;
  Result := MakeTRect(
    R.Left + 10 + Col * (ItemWidth + 8),
    R.Top + 8 + Row * (ItemHeight + 8),
    R.Left + 10 + Col * (ItemWidth + 8) + ItemWidth,
    R.Top + 8 + Row * (ItemHeight + 8) + ItemHeight);
  if Result.Right > R.Right - RightPad then
  begin
    Result.Left := R.Right + 1;
    Result.Right := R.Right + 1;
  end;
end;

function TLazRibbonSkinGalleryItem.SkinIndexAtPos(X, Y: Integer): Integer;
var
  LastIndex, Capacity: Integer;
  R: TRect;
  P: TPoint;

  function HitTestPoint(const AP: TPoint): Integer;
  var
    J: Integer;
    HitR: TRect;
  begin
    Result := -1;
    for J := FVisibleStartIndex to LastIndex do
    begin
      HitR := SkinCellRect(J, R);
      { The painted feedback rectangle is wider than the raw icon cell
        (Cell +/- 3 px). Use that same area for hover/click hit testing;
        otherwise the skin appears to ignore the cursor on its visual edge. }
      InflateRect(HitR, 4, 4);
      if PtInRect(HitR, AP) then
      begin
        Result := J;
        Exit;
      end;
    end;
  end;

begin
  Result := -1;
  R := FRect.ForWinAPI;

  Capacity := VisibleSkinCapacity(R);
  LastIndex := FVisibleStartIndex + Capacity - 1;
  if LastIndex >= SkinCount then
    LastIndex := SkinCount - 1;
  if LastIndex < FVisibleStartIndex then
    Exit;

  { Normal path: the ribbon dispatch sends toolbar coordinates. }
  P := Point(X, Y);
  Result := HitTestPoint(P);
  if Result >= 0 then
    Exit;

  { Compatibility path: some embedded/hosted dispatch paths can send
    item-local coordinates. Convert and test the same visual hit area. }
  P := Point(R.Left + X, R.Top + Y);
  Result := HitTestPoint(P);
end;

function TLazRibbonSkinGalleryItem.SkinCount: Integer;
var
  SM: TLazRibbonSkinManager;
begin
  SM := EffectiveSkinManager;
  if SM <> nil then
    Result := SM.SkinCount
  else
    Result := LazBuiltInSkinCount;
end;

function TLazRibbonSkinGalleryItem.SkinMainColorAtIndex(AIndex: Integer): TColor;
var
  Skin: TLazRibbonSkinDefinition;
  SM: TLazRibbonSkinManager;
begin
  Skin := nil;
  SM := EffectiveSkinManager;
  if SM <> nil then
    Skin := SM.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.Palette.RibbonTopColor
  else
    Result := LazBuiltInSkinMainColor(LazBuiltInSkinByIndex(AIndex));
end;

end.
