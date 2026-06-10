unit LazRibbon_BaseItem;

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_BaseItem.pas                                              *
*  Description: The module containing the base class for the glass element.    *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

{$mode delphi}
{.$Define EnhancedRecordSupport}

interface

uses
  SysUtils, Graphics, Classes, Controls, LCLType,
  LazRibbon_Math, LazRibbon_Appearance, LazRibbon_Dispatch, LazRibbon_Types;

type
  TLazRibbonItemSize = (isLarge, isNormal);

  TLazRibbonItemTableBehaviour = (tbBeginsRow, tbBeginsColumn, tbContinuesRow);

  TLazRibbonItemGroupBehaviour = (gbSingleItem, gbBeginsGroup, gbContinuesGroup, gbEndsGroup);

  { TLazRibbonBaseItem }

  TLazRibbonBaseItem = class abstract(TLazRibbonComponent)
  private
    FHint: TTranslateString;
    FKeyTip: TTranslateString;
    FShowScreenTip: Boolean;
    FScreenTipTitle: TTranslateString;
    FScreenTipText: TTranslateString;
    FScreenTipShortcut: TTranslateString;
    FScreenTipFooter: TTranslateString;
  protected
    FRect: T2DIntRect;
    FToolbarDispatch: TLazRibbonBaseToolbarDispatch;
    FAppearance: TLazRibbonToolbarAppearance;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FLargeImages: TImageList;
    FDisabledLargeImages: TImageList;
    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;
    FVisible: boolean;
    FEnabled: boolean;

    procedure SetVisible(const Value: boolean); virtual;
    procedure SetEnabled(const Value: boolean); virtual;
    procedure SetRect(const Value: T2DIntRect); virtual;
    procedure SetImages(const Value: TImageList); virtual;
    procedure SetDisabledImages(const Value: TImageList); virtual;
    procedure SetLargeImages(const Value: TImageList); virtual;
    procedure SetDisabledLargeImages(const Value: TImageList); virtual;
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    procedure SetKeyTip(const Value: TTranslateString); virtual;

    function IsHintStored: Boolean; virtual;
    function HasCustomScreenTip: Boolean; virtual;
    function GetScreenTipDefaultTitle: TTranslateString; virtual;
    function BuildScreenTip: TTranslateString; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure MouseLeave; virtual; abstract;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); virtual; abstract;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); virtual; abstract;

    procedure Notify(Item: TComponent; Operation: TOperation); virtual; abstract;

    function GetWidth: integer; virtual; abstract;
    function GetTableBehaviour: TLazRibbonItemTableBehaviour; virtual; abstract;
    function GetGroupBehaviour: TLazRibbonItemGroupBehaviour; virtual; abstract;
    function GetSize: TLazRibbonItemSize; virtual; abstract;

    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); virtual; abstract;

    function GetHintAtPos(X, Y: Integer; out AHint: TTranslateString;
      out ACursorRect: TRect): Boolean; virtual;
    function EffectiveScreenTip: TTranslateString; virtual;
    function ExecuteKeyTip: Boolean; virtual;

    property ToolbarDispatch: TLazRibbonBaseToolbarDispatch read FToolbarDispatch write FToolbarDispatch;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
    property Rect: T2DIntRect read FRect write SetRect;

  published
    property Visible: boolean read FVisible write SetVisible default true;
    property Enabled: boolean read FEnabled write SetEnabled default true;
    property Hint: TTranslateString read FHint write FHint stored IsHintStored;
    property KeyTip: TTranslateString read FKeyTip write SetKeyTip;
    property ShowScreenTip: Boolean read FShowScreenTip write FShowScreenTip default True;
    property ScreenTipTitle: TTranslateString read FScreenTipTitle write FScreenTipTitle;
    property ScreenTipText: TTranslateString read FScreenTipText write FScreenTipText;
    property ScreenTipShortcut: TTranslateString read FScreenTipShortcut write FScreenTipShortcut;
    property ScreenTipFooter: TTranslateString read FScreenTipFooter write FScreenTipFooter;
  end;

  TLazRibbonBaseItemClass = class of TLazRibbonBaseItem;


implementation

{ TLazRibbonBaseItem }

constructor TLazRibbonBaseItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  {$IFDEF EnhancedRecordSupport}
  FRect := T2DIntRect.Create(0, 0, 0, 0);
  {$ELSE}
  FRect.Create(0, 0, 0, 0);
  {$ENDIF}

  FToolbarDispatch := nil;
  FAppearance := nil;
  FImages := nil;
  FDisabledImages := nil;
  FLargeImages := nil;
  FDisabledLargeImages := nil;
  FVisible := true;
  FEnabled := true;
  FShowScreenTip := True;
end;

destructor TLazRibbonBaseItem.Destroy;
begin
  { Pozosta³e operacje }
  inherited Destroy;
end;

function TLazRibbonBaseItem.GetHintAtPos(X, Y: Integer; out AHint: TTranslateString;
  out ACursorRect: TRect): Boolean;
begin
  AHint := EffectiveScreenTip;
  ACursorRect := FRect.ForWinAPI;
  Result := AHint <> '';
end;

function TLazRibbonBaseItem.HasCustomScreenTip: Boolean;
begin
  Result := (FScreenTipTitle <> '') or (FScreenTipText <> '') or
    (FScreenTipShortcut <> '') or (FScreenTipFooter <> '');
end;

function TLazRibbonBaseItem.GetScreenTipDefaultTitle: TTranslateString;
begin
  Result := '';
end;

function TLazRibbonBaseItem.BuildScreenTip: TTranslateString;
var
  TitleText, BodyText, ScreenTipText: TTranslateString;

  procedure AddLine(const ALine: TTranslateString);
  begin
    if ALine = '' then
      Exit;
    if ScreenTipText <> '' then
      ScreenTipText := ScreenTipText + LineEnding;
    ScreenTipText := ScreenTipText + ALine;
  end;

begin
  ScreenTipText := '';

  TitleText := FScreenTipTitle;
  if TitleText = '' then
    TitleText := GetScreenTipDefaultTitle;

  BodyText := FScreenTipText;
  if (BodyText = '') and (FHint <> '') and not SameText(FHint, TitleText) then
    BodyText := FHint;

  AddLine(TitleText);
  AddLine(BodyText);
  AddLine(FScreenTipShortcut);

  if (FScreenTipFooter <> '') and (ScreenTipText <> '') then
    ScreenTipText := ScreenTipText + LineEnding;
  AddLine(FScreenTipFooter);

  Result := ScreenTipText;
end;

function TLazRibbonBaseItem.EffectiveScreenTip: TTranslateString;
begin
  if FShowScreenTip and HasCustomScreenTip then
    Result := BuildScreenTip
  else
    Result := FHint;
end;

function TLazRibbonBaseItem.ExecuteKeyTip: Boolean;
begin
  Result := False;
end;


procedure TLazRibbonBaseItem.SetKeyTip(const Value: TTranslateString);
begin
  if FKeyTip = Value then Exit;
  FKeyTip := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonBaseItem.SetAppearance(const Value: TLazRibbonToolbarAppearance);
begin
  FAppearance := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonBaseItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
  begin
    if AComponent = FImages then
      FImages := nil;
    if AComponent = FDisabledImages then
      FDisabledImages := nil;
    if AComponent = FLargeImages then
      FLargeImages := nil;
    if AComponent = FDisabledLargeImages then
      FDisabledLargeImages := nil;
  end;
end;

procedure TLazRibbonBaseItem.SetDisabledImages(const Value: TImageList);
begin
  if FDisabledImages <> Value then
  begin
    if FDisabledImages <> nil then
      FDisabledImages.RemoveFreeNotification(Self);
    FDisabledImages := Value;
    if FDisabledImages <> nil then
      FDisabledImages.FreeNotification(Self);
  end;
end;

procedure TLazRibbonBaseItem.SetDisabledLargeImages(const Value: TImageList);
begin
  if FDisabledLargeImages <> Value then
  begin
    if FDisabledLargeImages <> nil then
      FDisabledLargeImages.RemoveFreeNotification(Self);
    FDisabledLargeImages := Value;
    if FDisabledLargeImages <> nil then
      FDisabledLargeImages.FreeNotification(Self);
  end;
end;

procedure TLazRibbonBaseItem.SetEnabled(const Value: boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    if FToolbarDispatch<>nil then
      FToolbarDispatch.NotifyVisualsChanged;
  end;
end;

procedure TLazRibbonBaseItem.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    if FImages <> nil then
      FImages.RemoveFreeNotification(Self);
    FImages := Value;
    if FImages <> nil then
      FImages.FreeNotification(Self);
  end;
end;

procedure TLazRibbonBaseItem.SetImagesWidth(const Value: Integer);
begin
  FImagesWidth := Value;
end;

procedure TLazRibbonBaseItem.SetLargeImages(const Value: TImageList);
begin
  if FLargeImages <> Value then
  begin
    if FLargeImages <> nil then
      FLargeImages.RemoveFreeNotification(Self);
    FLargeImages := Value;
    if FLargeImages <> nil then
      FLargeImages.FreeNotification(Self);
  end;
end;

procedure TLazRibbonBaseItem.SetLargeImagesWidth(const Value: Integer);
begin
  FLargeImagesWidth := Value;
end;

procedure TLazRibbonBaseItem.SetRect(const Value: T2DIntRect);
begin
  FRect := Value;
end;

function TLazRibbonBaseItem.IsHintStored: Boolean;
begin
  Result := True;
end;

procedure TLazRibbonBaseItem.SetVisible(const Value: boolean);
begin
  if Value <> FVisible then
  begin
    FVisible := Value;
    if FToolbarDispatch <> nil then
      FToolbarDispatch.NotifyMetricsChanged;
  end;
end;

end.
