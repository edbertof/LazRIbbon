unit LazRibbon_RibbonCommands;

{$mode Delphi}{$H+}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_RibbonCommands.pas                                        *
*  Description: Minimal reusable command layer for LazRibbon_Core Ribbon UIs       *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, SysUtils, Controls, Menus, ImgList;

type
  { TLazRibbonCommand }

  TLazRibbonCommand = class(TComponent)
  private
    FCaption: TCaption;
    FHint: String;
    FEnabled: Boolean;
    FVisible: Boolean;
    FChecked: Boolean;
    FShortCut: TShortCut;
    FImageIndex: TImageIndex;
    FOnChange: TNotifyEvent;
    FOnExecute: TNotifyEvent;
    procedure SetCaption(const AValue: TCaption);
    procedure SetHint(const AValue: String);
    procedure SetEnabled(AValue: Boolean);
    procedure SetVisible(AValue: Boolean);
    procedure SetChecked(AValue: Boolean);
    procedure SetShortCut(AValue: TShortCut);
    procedure SetImageIndex(AValue: TImageIndex);
  protected
    procedure Changed; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute; virtual;
  published
    property Caption: TCaption read FCaption write SetCaption;
    property Hint: String read FHint write SetHint;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Checked: Boolean read FChecked write SetChecked default False;
    property ShortCut: TShortCut read FShortCut write SetShortCut default 0;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
  end;

  { TLazRibbonCommandList }

  TLazRibbonCommandList = class(TComponent)
  private
    FImages: TCustomImageList;
    procedure SetImages(AValue: TCustomImageList);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function AddCommand(const AName, ACaption: String): TLazRibbonCommand; virtual;
  published
    property Images: TCustomImageList read FImages write SetImages;
  end;

implementation

{ TLazRibbonCommand }

constructor TLazRibbonCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FVisible := True;
  FChecked := False;
  FShortCut := 0;
  FImageIndex := -1;
end;

procedure TLazRibbonCommand.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TLazRibbonCommand.Execute;
begin
  if not FEnabled then Exit;
  if not FVisible then Exit;
  if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

procedure TLazRibbonCommand.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Changed;
end;

procedure TLazRibbonCommand.SetHint(const AValue: String);
begin
  if FHint = AValue then Exit;
  FHint := AValue;
  Changed;
end;

procedure TLazRibbonCommand.SetEnabled(AValue: Boolean);
begin
  if FEnabled = AValue then Exit;
  FEnabled := AValue;
  Changed;
end;

procedure TLazRibbonCommand.SetVisible(AValue: Boolean);
begin
  if FVisible = AValue then Exit;
  FVisible := AValue;
  Changed;
end;

procedure TLazRibbonCommand.SetChecked(AValue: Boolean);
begin
  if FChecked = AValue then Exit;
  FChecked := AValue;
  Changed;
end;

procedure TLazRibbonCommand.SetShortCut(AValue: TShortCut);
begin
  if FShortCut = AValue then Exit;
  FShortCut := AValue;
  Changed;
end;

procedure TLazRibbonCommand.SetImageIndex(AValue: TImageIndex);
begin
  if FImageIndex = AValue then Exit;
  FImageIndex := AValue;
  Changed;
end;

{ TLazRibbonCommandList }

procedure TLazRibbonCommandList.SetImages(AValue: TCustomImageList);
begin
  if FImages = AValue then Exit;
  if FImages <> nil then
    FImages.RemoveFreeNotification(Self);
  FImages := AValue;
  if FImages <> nil then
    FImages.FreeNotification(Self);
end;

procedure TLazRibbonCommandList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
end;

function TLazRibbonCommandList.AddCommand(const AName, ACaption: String): TLazRibbonCommand;
begin
  Result := TLazRibbonCommand.Create(Self);
  if AName <> '' then
    Result.Name := AName;
  Result.Caption := ACaption;
end;

end.
