unit LazRibbon_SkinSelectorItem;

{$mode Delphi}{$H+}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_SkinSelectorItem.pas                                      *
*  Description: Ribbon item that opens a skin selector popup for LazRibbon_Core.    *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Types, LCLType, TypInfo,
  LazRibbon_Math, LazRibbon_Dispatch, LazRibbon_Buttons, LazRibbon_SkinManager, LazRibbon_SkinSelector;

type
  TLazRibbonSkinSelectorItem = class(TLazRibbonLargeButton)
  private
    FSkinManager: TLazRibbonSkinManager;
    FColumns: Integer;
    FItemWidth: Integer;
    FItemHeight: Integer;
    FShowCaptions: Boolean;
    FPopupWidth: Integer;
    FPopupHeight: Integer;
    FOnSkinSelected: TNotifyEvent;
    procedure SetSkinManager(AValue: TLazRibbonSkinManager);
    procedure SetColumns(AValue: Integer);
    procedure SetItemWidth(AValue: Integer);
    procedure SetItemHeight(AValue: Integer);
    procedure SetShowCaptions(AValue: Boolean);
    procedure SetPopupWidth(AValue: Integer);
    procedure SetPopupHeight(AValue: Integer);
    function EffectiveSkinManager: TLazRibbonSkinManager;
  protected
    procedure Click; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetDefaultCaption: String; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;
    property Columns: Integer read FColumns write SetColumns default 4;
    property ItemWidth: Integer read FItemWidth write SetItemWidth default 58;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 28;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions default False;
    property PopupWidth: Integer read FPopupWidth write SetPopupWidth default 260;
    property PopupHeight: Integer read FPopupHeight write SetPopupHeight default 120;
    property OnSkinSelected: TNotifyEvent read FOnSkinSelected write FOnSkinSelected;
  end;

implementation

type
  TLazRibbonSkinSelectorPopupForm = class(TForm)
  private
    FSelector: TLazRibbonSkinSelector;
    procedure SelectorSkinSelected(Sender: TObject);
  public
    constructor CreatePopup(AOwner: TComponent; ASkinManager: TLazRibbonSkinManager;
      AColumns, AItemWidth, AItemHeight: Integer; AShowCaptions: Boolean); reintroduce;
    property Selector: TLazRibbonSkinSelector read FSelector;
  end;

{ TLazRibbonSkinSelectorPopupForm }

constructor TLazRibbonSkinSelectorPopupForm.CreatePopup(AOwner: TComponent;
  ASkinManager: TLazRibbonSkinManager; AColumns, AItemWidth, AItemHeight: Integer;
  AShowCaptions: Boolean);
begin
  inherited CreateNew(AOwner);
  BorderStyle := bsSizeToolWin;
  Caption := 'Skins';
  Position := poDesigned;
  KeyPreview := True;

  FSelector := TLazRibbonSkinSelector.Create(Self);
  FSelector.Parent := Self;
  FSelector.Align := alClient;
  FSelector.BorderSpacing.Around := 6;
  FSelector.SkinManager := ASkinManager;
  FSelector.Columns := AColumns;
  FSelector.IconWidth := AItemWidth;
  FSelector.IconHeight := AItemHeight;
  FSelector.ShowCaptions := AShowCaptions;
  FSelector.OnSkinSelected := SelectorSkinSelected;
end;

procedure TLazRibbonSkinSelectorPopupForm.SelectorSkinSelected(Sender: TObject);
begin
  ModalResult := mrOk;
end;

{ TLazRibbonSkinSelectorItem }

constructor TLazRibbonSkinSelectorItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := GetDefaultCaption;
  FColumns := 4;
  FItemWidth := 58;
  FItemHeight := 28;
  FShowCaptions := False;
  FPopupWidth := 260;
  FPopupHeight := 120;
end;

procedure TLazRibbonSkinSelectorItem.Click;
var
  Popup: TLazRibbonSkinSelectorPopupForm;
  P: T2DIntPoint;
  SM: TLazRibbonSkinManager;
begin
  inherited Click;

  if csDesigning in ComponentState then
    Exit;

  SM := EffectiveSkinManager;
  if SM = nil then
    Exit;

  Popup := TLazRibbonSkinSelectorPopupForm.CreatePopup(nil, SM, FColumns, FItemWidth,
    FItemHeight, FShowCaptions);
  try
    Popup.Width := FPopupWidth;
    Popup.Height := FPopupHeight;
    if FToolbarDispatch <> nil then
    begin
      P.X := Rect.Left;
      P.Y := Rect.Bottom;
      P := FToolbarDispatch.ClientToScreen(P);
      Popup.Left := P.X;
      Popup.Top := P.Y;
    end;
    Popup.ShowModal;
    if Assigned(FOnSkinSelected) then
      FOnSkinSelected(Self);
  finally
    Popup.Free;
  end;
end;

function TLazRibbonSkinSelectorItem.EffectiveSkinManager: TLazRibbonSkinManager;
var
  Root: TComponent;
  PropInfo: PPropInfo;
  Provider: ILazRibbonSkinProvider;
  Obj: TObject;
begin
  Result := FSkinManager;
  if Result <> nil then
    Exit;

  { Normal use: this item lives inside TLazRibbon. Query the owner toolbar
    through the skin provider so we do not create a unit dependency back
    to LazRibbon_Core. }
  if FToolbarDispatch <> nil then
  begin
    Provider := FToolbarDispatch.GetSkinProvider;
    if Provider <> nil then
    begin
      Obj := Provider.GetSkinManagerObject;
      if Obj is TLazRibbonSkinManager then
      begin
        Result := TLazRibbonSkinManager(Obj);
        Exit;
      end;
    end;
  end;

  { Last-resort compatibility fallback. It is intentionally weak because a
    Ribbon item normally belongs to the Ribbon, not directly to a form. }
  Root := GetRootComponent;
  if Root = nil then
    Exit;

  PropInfo := GetPropInfo(Root.ClassInfo, 'SkinManager');
  if PropInfo = nil then
    Exit;

  Obj := GetObjectProp(Root, PropInfo);
  if Obj is TLazRibbonSkinManager then
    Result := TLazRibbonSkinManager(Obj);
end;

function TLazRibbonSkinSelectorItem.GetDefaultCaption: String;
begin
  Result := 'Skins';
end;

procedure TLazRibbonSkinSelectorItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinManager) then
    FSkinManager := nil;
end;

procedure TLazRibbonSkinSelectorItem.SetColumns(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  FColumns := AValue;
end;

procedure TLazRibbonSkinSelectorItem.SetItemHeight(AValue: Integer);
begin
  if AValue < 20 then AValue := 20;
  FItemHeight := AValue;
end;

procedure TLazRibbonSkinSelectorItem.SetItemWidth(AValue: Integer);
begin
  if AValue < 28 then AValue := 28;
  FItemWidth := AValue;
end;

procedure TLazRibbonSkinSelectorItem.SetPopupHeight(AValue: Integer);
begin
  if AValue < 80 then AValue := 80;
  FPopupHeight := AValue;
end;

procedure TLazRibbonSkinSelectorItem.SetPopupWidth(AValue: Integer);
begin
  if AValue < 120 then AValue := 120;
  FPopupWidth := AValue;
end;

procedure TLazRibbonSkinSelectorItem.SetShowCaptions(AValue: Boolean);
begin
  FShowCaptions := AValue;
end;

procedure TLazRibbonSkinSelectorItem.SetSkinManager(AValue: TLazRibbonSkinManager);
begin
  if FSkinManager = AValue then Exit;
  if FSkinManager <> nil then
    FSkinManager.RemoveFreeNotification(Self);
  FSkinManager := AValue;
  if FSkinManager <> nil then
    FSkinManager.FreeNotification(Self);
end;

end.
