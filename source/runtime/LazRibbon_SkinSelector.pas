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

unit LazRibbon_SkinSelector;

{$mode Delphi}{$H+}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_SkinSelector.pas                                          *
*  Description: Runtime skin selector control for LazRibbon_Core.                  *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, SysUtils, Graphics, Controls, Types, LCLType, LCLIntf,
  LazRibbon_SkinManager, LazRibbon_SkinDefinition;

type
  TLazRibbonSkinSelector = class(TCustomControl)
  private
    FSkinManager: TLazRibbonSkinManager;
    FColumns: Integer;
    FItemWidth: Integer;
    FItemHeight: Integer;
    FShowCaptions: Boolean;
    FHoverIndex: Integer;
    FSelectedSkin: TLazRibbonBuiltInSkin;
    FSelectedSkinName: String;
    FOnSkinSelected: TNotifyEvent;
    procedure SetColumns(AValue: Integer);
    procedure SetItemWidth(AValue: Integer);
    procedure SetItemHeight(AValue: Integer);
    procedure ReadLegacyItemWidth(Reader: TReader);
    procedure ReadLegacyItemHeight(Reader: TReader);
    procedure SetShowCaptions(AValue: Boolean);
    procedure SetSelectedSkin(AValue: TLazRibbonBuiltInSkin);
    procedure SetSelectedSkinName(const AValue: String);
    procedure SetSkinManager(AValue: TLazRibbonSkinManager);
    function GetSelectedSkin: TLazRibbonBuiltInSkin;
    function GetSelectedSkinName: String;
    procedure ReadLegacySelectedSkin(Reader: TReader);
  protected
    function SkinCount: Integer; virtual;
    function SkinNameAtIndex(AIndex: Integer): String; virtual;
    function SkinCaptionAtIndex(AIndex: Integer): String; virtual;
    function SkinMainColorAtIndex(AIndex: Integer): TColor; virtual;
    function SkinAccentColorAtIndex(AIndex: Integer): TColor; virtual;
    function ItemRect(AIndex: Integer): TRect; virtual;
    function ItemAtPos(X, Y: Integer): Integer; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    property SelectedSkin: TLazRibbonBuiltInSkin read GetSelectedSkin write SetSelectedSkin default sbsOfficeBlue;
  published
    property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;
    property Columns: Integer read FColumns write SetColumns default 2;
    property IconWidth: Integer read FItemWidth write SetItemWidth default 96;
    property IconHeight: Integer read FItemHeight write SetItemHeight default 34;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions default True;
    property SelectedSkinName: String read GetSelectedSkinName write SetSelectedSkinName;

    property Align;
    property Anchors;
    property BorderSpacing;
    property Color default clWhite;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property OnClick;
    property OnSkinSelected: TNotifyEvent read FOnSkinSelected write FOnSkinSelected;
  end;

implementation

function LazMixColor(AColor1, AColor2: TColor; APercentColor2: Integer): TColor;
var
  C1, C2: LongInt;
  R1, G1, B1, R2, G2, B2: Integer;
begin
  if APercentColor2 < 0 then APercentColor2 := 0;
  if APercentColor2 > 100 then APercentColor2 := 100;

  C1 := ColorToRGB(AColor1);
  C2 := ColorToRGB(AColor2);
  R1 := C1 and $FF;
  G1 := (C1 shr 8) and $FF;
  B1 := (C1 shr 16) and $FF;
  R2 := C2 and $FF;
  G2 := (C2 shr 8) and $FF;
  B2 := (C2 shr 16) and $FF;

  Result := RGBToColor(
    (R1 * (100 - APercentColor2) + R2 * APercentColor2) div 100,
    (G1 * (100 - APercentColor2) + G2 * APercentColor2) div 100,
    (B1 * (100 - APercentColor2) + B2 * APercentColor2) div 100
  );
end;

constructor TLazRibbonSkinSelector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  Color := clWhite;
  ParentFont := False;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FColumns := 2;
  FItemWidth := 96;
  FItemHeight := 34;
  FShowCaptions := True;
  FHoverIndex := -1;
  FSelectedSkin := sbsOfficeBlue;
  FSelectedSkinName := LazBuiltInSkinToString(sbsOfficeBlue);
  Width := 210;
  Height := 78;
end;

procedure TLazRibbonSkinSelector.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('ItemWidth', ReadLegacyItemWidth, nil, False);
  Filer.DefineProperty('ItemHeight', ReadLegacyItemHeight, nil, False);
  Filer.DefineProperty('SelectedSkin', ReadLegacySelectedSkin, nil, False);
end;

procedure TLazRibbonSkinSelector.ReadLegacyItemHeight(Reader: TReader);
begin
  SetItemHeight(Reader.ReadInteger);
end;

procedure TLazRibbonSkinSelector.ReadLegacyItemWidth(Reader: TReader);
begin
  SetItemWidth(Reader.ReadInteger);
end;

procedure TLazRibbonSkinSelector.ReadLegacySelectedSkin(Reader: TReader);
var
  SkinName: String;
  BuiltIn: TLazRibbonBuiltInSkin;
begin
  SkinName := Reader.ReadIdent;
  if (Length(SkinName) > 3) and SameText(Copy(SkinName, 1, 3), 'sbs') then
    Delete(SkinName, 1, 3);
  if LazRibbon_SkinDefinition.LazBuiltInSkinFromString(SkinName, BuiltIn) then
    SetSelectedSkin(BuiltIn);
end;

function TLazRibbonSkinSelector.GetSelectedSkin: TLazRibbonBuiltInSkin;
begin
  if FSkinManager <> nil then
    Result := FSkinManager.ActiveSkin
  else
    Result := FSelectedSkin;
end;

function TLazRibbonSkinSelector.GetSelectedSkinName: String;
begin
  if FSkinManager <> nil then
    Result := FSkinManager.ActiveSkinName
  else
    Result := FSelectedSkinName;
end;

function TLazRibbonSkinSelector.ItemAtPos(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to SkinCount - 1 do
    if PtInRect(ItemRect(I), Point(X, Y)) then
    begin
      Result := I;
      Exit;
    end;
end;

function TLazRibbonSkinSelector.ItemRect(AIndex: Integer): TRect;
var
  Row, Col: Integer;
begin
  if FColumns < 1 then
    FColumns := 1;
  Row := AIndex div FColumns;
  Col := AIndex mod FColumns;
  Result := Rect(
    4 + Col * FItemWidth,
    4 + Row * FItemHeight,
    4 + Col * FItemWidth + FItemWidth - 4,
    4 + Row * FItemHeight + FItemHeight - 4
  );
end;

procedure TLazRibbonSkinSelector.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button <> mbLeft then Exit;
  I := ItemAtPos(X, Y);
  if I >= 0 then
  begin
    SelectedSkinName := SkinNameAtIndex(I);
    Click;
    if Assigned(FOnSkinSelected) then
      FOnSkinSelected(Self);
  end;
end;

procedure TLazRibbonSkinSelector.MouseLeave;
begin
  inherited MouseLeave;
  if FHoverIndex <> -1 then
  begin
    FHoverIndex := -1;
    Invalidate;
  end;
end;

procedure TLazRibbonSkinSelector.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  I := ItemAtPos(X, Y);
  if I <> FHoverIndex then
  begin
    FHoverIndex := I;
    Invalidate;
  end;
end;

procedure TLazRibbonSkinSelector.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinManager) then
    FSkinManager := nil;
end;

procedure TLazRibbonSkinSelector.Paint;
var
  I: Integer;
  R, SwatchR, TextR: TRect;
  SkinName: String;
  IsSelected, IsHot: Boolean;
  MainColor, AccentColor, BorderColor: TColor;
  S: String;
  SkinDef: TLazRibbonSkinDefinition;
begin
  inherited Paint;

  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  Canvas.Font.Assign(Font);

  for I := 0 to SkinCount - 1 do
  begin
    SkinName := SkinNameAtIndex(I);
    R := ItemRect(I);
    IsSelected := SameText(SkinName, GetSelectedSkinName);
    IsHot := I = FHoverIndex;

    MainColor := SkinMainColorAtIndex(I);
    AccentColor := SkinAccentColorAtIndex(I);
    BorderColor := clGray;

    if IsSelected then
    begin
      Canvas.Brush.Color := LazMixColor(MainColor, clWhite, 78);
      Canvas.Pen.Color := AccentColor;
      Canvas.Rectangle(R);
    end
    else if IsHot then
    begin
      Canvas.Brush.Color := LazMixColor(MainColor, clWhite, 88);
      Canvas.Pen.Color := AccentColor;
      Canvas.Rectangle(R);
    end;

    SwatchR := Rect(R.Left + 8, R.Top + 6, R.Left + 24, R.Bottom - 6);
    SkinDef := nil;
    if FSkinManager <> nil then
      SkinDef := FSkinManager.SkinByIndex(I);

    if not LazDrawSkinDefinitionIcon(Canvas, SkinDef, 16, SwatchR) then
    begin
      Canvas.Brush.Color := MainColor;
      Canvas.Pen.Color := BorderColor;
      Canvas.Rectangle(SwatchR);

      Canvas.Brush.Color := AccentColor;
      Canvas.Pen.Color := AccentColor;
      Canvas.Rectangle(Rect(SwatchR.Left + 4, SwatchR.Top + 2, SwatchR.Right - 3, SwatchR.Bottom - 2));
    end;

    if FShowCaptions then
    begin
      S := SkinCaptionAtIndex(I);
      TextR := Rect(SwatchR.Right + 8, R.Top, R.Right - 6, R.Bottom);
      Canvas.Brush.Style := bsClear;
      if Enabled then
        Canvas.Font.Color := clWindowText
      else
        Canvas.Font.Color := clGrayText;
      DrawText(Canvas.Handle, PChar(S), Length(S), TextR, DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);
      Canvas.Brush.Style := bsSolid;
    end;
  end;
end;

procedure TLazRibbonSkinSelector.SetColumns(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  if FColumns = AValue then Exit;
  FColumns := AValue;
  Invalidate;
end;

procedure TLazRibbonSkinSelector.SetItemWidth(AValue: Integer);
begin
  if AValue < 18 then AValue := 18;
  if FItemWidth = AValue then Exit;
  FItemWidth := AValue;
  Invalidate;
end;

procedure TLazRibbonSkinSelector.SetItemHeight(AValue: Integer);
begin
  if AValue < 18 then AValue := 18;
  if FItemHeight = AValue then Exit;
  FItemHeight := AValue;
  Invalidate;
end;

procedure TLazRibbonSkinSelector.SetSelectedSkin(AValue: TLazRibbonBuiltInSkin);
begin
  FSelectedSkin := AValue;
  SetSelectedSkinName(LazBuiltInSkinToString(AValue));
end;

procedure TLazRibbonSkinSelector.SetSelectedSkinName(const AValue: String);
var
  BuiltIn: TLazRibbonBuiltInSkin;
begin
  if SameText(GetSelectedSkinName, AValue) then Exit;
  FSelectedSkinName := AValue;
  if LazRibbon_SkinDefinition.LazBuiltInSkinFromString(AValue, BuiltIn) then
    FSelectedSkin := BuiltIn;
  if FSkinManager <> nil then
    FSkinManager.ActiveSkinName := AValue;
  Invalidate;
end;

procedure TLazRibbonSkinSelector.SetShowCaptions(AValue: Boolean);
begin
  if FShowCaptions = AValue then Exit;
  FShowCaptions := AValue;
  Invalidate;
end;

procedure TLazRibbonSkinSelector.SetSkinManager(AValue: TLazRibbonSkinManager);
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
  Invalidate;
end;

function TLazRibbonSkinSelector.SkinAccentColorAtIndex(AIndex: Integer): TColor;
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := nil;
  if FSkinManager <> nil then
    Skin := FSkinManager.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.Palette.ActiveColor
  else
    Result := LazBuiltInSkinAccentColor(LazBuiltInSkinByIndex(AIndex));
end;

function TLazRibbonSkinSelector.SkinCaptionAtIndex(AIndex: Integer): String;
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := nil;
  if FSkinManager <> nil then
    Skin := FSkinManager.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.DisplayName
  else
    Result := LazBuiltInSkinCaption(LazBuiltInSkinByIndex(AIndex));
  if Result = '' then
    Result := SkinNameAtIndex(AIndex);
end;

function TLazRibbonSkinSelector.SkinCount: Integer;
begin
  if FSkinManager <> nil then
    Result := FSkinManager.SkinCount
  else
    Result := LazBuiltInSkinCount;
end;

function TLazRibbonSkinSelector.SkinMainColorAtIndex(AIndex: Integer): TColor;
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := nil;
  if FSkinManager <> nil then
    Skin := FSkinManager.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.Palette.RibbonTopColor
  else
    Result := LazBuiltInSkinMainColor(LazBuiltInSkinByIndex(AIndex));
end;

function TLazRibbonSkinSelector.SkinNameAtIndex(AIndex: Integer): String;
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := nil;
  if FSkinManager <> nil then
    Skin := FSkinManager.SkinByIndex(AIndex);
  if Skin <> nil then
    Result := Skin.Name
  else
    Result := LazBuiltInSkinToString(LazBuiltInSkinByIndex(AIndex));
end;

end.
