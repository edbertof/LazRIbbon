unit LazRibbon_Buttons;

{$mode delphi}
{.$Define EnhancedRecordSupport}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Buttons.pas                                               *
*  Description: A module containing button components for the toolbar.         *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

interface

uses
  Graphics, Classes, Types, Controls, Menus, ActnList, Math,
  Dialogs, ImgList, Forms, LCLType,
  LazRibbon_GUITools, LazRibbon_GraphTools, LazRibbon_Math,
  LazRibbon_Const, LazRibbon_BaseItem, LazRibbon_Tools;

type
  TLazRibbonMouseButtonElement = (beNone, beButton, beDropdown);

  TLazRibbonButtonKind = (bkButton, bkButtonDropdown, bkDropdown, bkToggle, bkSeparator);

  TLazRibbonBaseButton = class;

  { TLazRibbonButtonActionLink }

  TLazRibbonButtonActionLink = class(TActionLink)
  protected
    FClient: TLazRibbonBaseButton;
    procedure AssignClient(AClient: TObject); override;
    function IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetGroupIndex(Value: Integer); override;
    procedure SetImageIndex(Value: integer); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute({%H-}Value: TNotifyEvent); override;
    procedure SetHint(const Value: string); override;
  public
    function DoShowHint(var HintStr: string): Boolean; virtual;
    function IsCaptionLinked: Boolean; override;
    function IsCheckedLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsGroupIndexLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
  end;


  { TLazRibbonBaseButton }

  TLazRibbonBaseButton = class abstract(TLazRibbonBaseItem)
  private
    FMouseHoverElement: TLazRibbonMouseButtonElement;
    FMouseActiveElement: TLazRibbonMouseButtonElement;

    // Getters and Setters
    function GetAction: TBasicAction;
    procedure SetAllowAllUp(const Value: Boolean);
    procedure SetButtonKind(const Value: TLazRibbonButtonKind);
    procedure SetCaption(const Value: string);
    procedure SetDropdownMenu(const Value: TPopupMenu);
    procedure SetGroupIndex(const Value: Integer);

  protected
    FCaption: string;
    FOnClick: TNotifyEvent;
    FActionLink: TLazRibbonButtonActionLink;
    FButtonState: TLazRibbonButtonState;
    FButtonRect: T2DIntRect;
    FDropdownRect: T2DIntRect;
    FButtonKind: TLazRibbonButtonKind;
    FChecked: Boolean;
    FGroupIndex: Integer;
    FAllowAllUp: Boolean;
    FDropdownMenu: TPopupMenu;

    // *** Drawing support ***
    // The task of the method in inherited classes is to calculate the
    // button's rectangle and the dropdown menu depending on FButtonState
    procedure CalcRects; virtual; abstract;
    function GetDropdownPoint: T2DIntPoint; virtual; abstract;

    // *** Action support ***
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); virtual;
    procedure Click; virtual;
    procedure DoActionChange(Sender: TObject);
    function GetDefaultCaption: String; virtual;
    function GetScreenTipDefaultTitle: TTranslateString; override;
    function MouseOnActivePart(X, Y: Integer): Boolean; virtual;

    function SiblingsChecked: Boolean; virtual;
    procedure UncheckSiblings; virtual;

    procedure DrawDropdownArrow(ABuffer: TBitmap; ARect: TRect; AColor: TColor);

    // Getters and Setters
    function GetChecked: Boolean; virtual;
    procedure SetAction(const Value: TBasicAction); virtual;
    procedure SetChecked(const Value: Boolean); virtual;
    procedure SetEnabled(const Value: boolean); override;
    procedure SetRect(const Value: T2DIntRect); override;

    function IsHintStored: Boolean; override;

    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default false;
    property ButtonKind: TLazRibbonButtonKind read FButtonKind write SetButtonKind default bkButton;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; {%H-}Shift: TShiftState;
      {%H-}X, {%H-}Y: Integer); override;
    procedure MouseMove({%H-}Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      {%H-}X, {%H-}Y: Integer); override;

    function GetRootComponent: TComponent;
    function IsRightToLeft: Boolean;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    function ExecuteKeyTip: Boolean; override;

    property ActionLink: TLazRibbonButtonActionLink read FActionLink;
    property Checked: Boolean read GetChecked write SetChecked default false;

  published
    property Action: TBasicAction read GetAction write SetAction;
    property Caption: string read FCaption write SetCaption;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;


  { TLazRibbonLargeButton }

  TLazRibbonCustomLargeButton = class(TLazRibbonBaseButton)
  private
    FLargeImageIndex: TImageIndex;
    procedure FindBreakPlace(s: string; out Position: integer; out Width: integer);
    procedure SetLargeImageIndex(const Value: TImageIndex);
  protected
    procedure CalcRects; override;
    function GetDropdownPoint : T2DIntPoint; override;
    property LargeImageIndex: TImageIndex
      read FLargeImageIndex write SetLargeImageIndex default -1;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
    function GetGroupBehaviour: TLazRibbonItemGroupBehaviour; override;
    function GetSize: TLazRibbonItemSize; override;
    function GetTableBehaviour: TLazRibbonItemTableBehaviour; override;
    function GetWidth: integer; override;
  published
  end;


  { TLazRibbonLargeButton }

  TLazRibbonLargeButton = class(TLazRibbonCustomLargeButton)
  published
    property AllowAllUp;
    property ButtonKind;
    property Checked;
    property DropdownMenu;
    property GroupIndex;
    property LargeImageIndex;
  end;


  { TLazRibbonSeparator }

  TLazRibbonSeparator = class(TLazRibbonCustomLargeButton)
  protected
    function GetDefaultCaption: String; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


  { TLazRibbonCustomTableButton (Ancestor of SmallButton and Checkbox/RadioButton/ToggleSwitch) }

  TLazRibbonCustomTableButton = class(TLazRibbonBaseButton)
  private
    FTableBehaviour: TLazRibbonItemTableBehaviour;
    procedure SetTableBehaviour(const Value: TLazRibbonItemTableBehaviour);
  protected
    property TableBehaviour: TLazRibbonItemTableBehaviour
      read FTableBehaviour write SetTableBehaviour default tbContinuesRow;
  public
    constructor Create(AOwner: TComponent); override;
    function GetGroupBehaviour: TLazRibbonItemGroupBehaviour; override;
    function GetSize: TLazRibbonItemSize; override;
    function GetTableBehaviour: TLazRibbonItemTableBehaviour; override;
  end;

  { TLazRibbonSmallButton }

  TLazRibbonSmallButton = class(TLazRibbonCustomTableButton)
  private
    FImageIndex: TImageIndex;
    FGroupBehaviour: TLazRibbonItemGroupBehaviour;
    FHideFrameWhenIdle: boolean;
    FShowCaption: boolean;
    procedure ConstructRects(out BtnRect, DropRect: T2DIntRect);
    procedure SetGroupBehaviour(const Value: TLazRibbonItemGroupBehaviour);
    procedure SetHideFrameWhenIdle(const Value: boolean);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetShowCaption(const Value: boolean);
  protected
    procedure CalcRects; override;
    function GetDropdownPoint: T2DIntPoint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
    function GetGroupBehaviour: TLazRibbonItemGroupBehaviour; override;
    function GetWidth: integer; override;
  published
    property GroupBehaviour: TLazRibbonItemGroupBehaviour
      read FGroupBehaviour write SetGroupBehaviour default gbSingleItem;
    property HideFrameWhenIdle: boolean
      read FHideFrameWhenIdle write SetHideFrameWhenIdle default true;
    property ImageIndex: TImageIndex
      read FImageIndex write SetImageIndex default -1;
    property ShowCaption: boolean
      read FShowCaption write SetShowCaption default true;
    property TableBehaviour;
    property AllowAllUp;
    property ButtonKind;
    property Checked;
    property DropdownMenu;
    property GroupIndex;
  end;


implementation

uses
  LCLIntf, LCLProc, LCLVersion, SysUtils,
  LazRibbon_Groups, LazRibbon_Appearance, LazRibbon_Popup;

function LazRibbonDisabledTextColor(AColor, ABackgroundColor: TColor): TColor;
begin
  Result := TColorTools.Shade(TColorTools.ColorToGrayscale(AColor), ABackgroundColor, 35);
end;

procedure LazRibbonApplyDisabledButtonColors(var ACaptionColor, AFrameColor,
  AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TColor;
  ABackgroundColor: TColor);
begin
  ACaptionColor := LazRibbonDisabledTextColor(ACaptionColor, ABackgroundColor);
  AFrameColor := TColorTools.Shade(TColorTools.ColorToGrayscale(AFrameColor), ABackgroundColor, 55);
  AInnerLightColor := TColorTools.Shade(TColorTools.ColorToGrayscale(AInnerLightColor), ABackgroundColor, 65);
  AInnerDarkColor := TColorTools.Shade(TColorTools.ColorToGrayscale(AInnerDarkColor), ABackgroundColor, 65);
  AGradientFromColor := TColorTools.Shade(TColorTools.ColorToGrayscale(AGradientFromColor), ABackgroundColor, 75);
  AGradientToColor := TColorTools.Shade(TColorTools.ColorToGrayscale(AGradientToColor), ABackgroundColor, 75);
end;


{ TLazRibbonButtonActionLink }

procedure TLazRibbonButtonActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := TLazRibbonBaseButton(AClient);
end;

function TLazRibbonButtonActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and Assigned(FClient) and
            (Action is TCustomAction) and
            (FClient.Caption = TCustomAction(Action).Caption);
end;

function TLazRibbonButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and Assigned(FClient) and
            (Action is TCustomAction) and
            (FClient.Checked = TCustomAction(Action).Checked);
end;

function TLazRibbonButtonActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and Assigned(FClient) and
            (Action is TCustomAction) and
            (FClient.Enabled = TCustomAction(Action).Enabled);
end;

function TLazRibbonButtonActionLink.IsGroupIndexLinked: Boolean;
begin
  Result := inherited IsGroupIndexLinked and Assigned(FClient) and
            (Action is TCustomAction) and
            (FClient.GroupIndex = TCustomAction(Action).GroupIndex);
end;

function TLazRibbonButtonActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and Assigned(FClient) and
            (Action is TCustomAction);
  if not Result then
    Exit;

  if (FClient is TLazRibbonSmallButton) then
    Result := TLazRibbonSmallButton(FClient).ImageIndex = TCustomAction(Action).ImageIndex
  else
  if (FClient is TLazRibbonLargeButton) then
    Result := TLazRibbonLargeButton(FClient).LargeImageIndex = TCustomAction(Action).ImageIndex
  else
    Result := false;
end;

function TLazRibbonButtonActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked;
  //and
  //          (@TLazRibbonBaseButton(FClient).OnClick = @Action.OnExecute);
end;

function TLazRibbonButtonActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and Assigned(FClient) and
            (Action is TCustomAction) and
            (FClient.Visible = TCustomAction(Action).Visible);
end;

function TLazRibbonButtonActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and Assigned(FClient) and
            (Action is TCustomAction) and
            (FClient.Hint = TCustomAction(Action).Hint);
end;

procedure TLazRibbonButtonActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then
    FClient.Caption := Value;
end;

procedure TLazRibbonButtonActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then
    FClient.Checked := Value;
end;

procedure TLazRibbonButtonActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then
    FClient.Enabled := Value;
end;

procedure TLazRibbonButtonActionLink.SetGroupIndex(Value: Integer);
begin
  if IsGroupIndexLinked then
    FClient.GroupIndex := Value;
end;

procedure TLazRibbonButtonActionLink.SetImageIndex(Value: integer);
begin
  if IsImageIndexLinked then begin
    if (FClient is TLazRibbonSmallButton) then
      (TLazRibbonSmallButton(FClient)).ImageIndex := Value
    else
    if (FClient is TLazRibbonLargeButton) then
      (TLazRibbonLargeButton(FClient)).LargeImageIndex := Value;
  end;
end;

procedure TLazRibbonButtonActionLink.SetOnExecute(Value: TNotifyEvent);
begin
// Note: formerly this changed FClient.OnClick, but that is unneeded, because
//       TControl.Click executes Action
end;

procedure TLazRibbonButtonActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then
    FClient.Hint := Value;
end;

function TLazRibbonButtonActionLink.DoShowHint(var HintStr: string): Boolean;
var
  ShortcutText: String;
begin
  Result := True;
  if Action is TCustomAction then
  begin
    if TCustomAction(Action).DoHint(HintStr)
    and Application.HintShortCuts
    and (TCustomAction(Action).ShortCut <> scNone) then
    begin
      ShortcutText := ShortCutToText(TCustomAction(Action).ShortCut);
      if (HintStr <> '') and (ShortcutText <> '') then
      begin
        if Pos(LineEnding, HintStr) > 0 then
          HintStr := HintStr + LineEnding + ShortcutText
        else
          HintStr := Format('%s (%s)', [HintStr, ShortcutText]);
      end;
    end;
  end;
end;

procedure TLazRibbonButtonActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then
    FClient.Visible := Value;
end;


{ TLazRibbonBaseButton }

constructor TLazRibbonBaseButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := GetDefaultCaption;
  FButtonState := bsIdle;
  FButtonKind := bkButton;
  {$IFDEF EnhancedRecordSupport}
  FButtonRect := T2DIntRect.Create(0, 0, 1, 1);
  FDropdownRect := T2DIntRect.Create(0, 0, 1, 1);
  {$ELSE}
  FButtonRect.Create(0, 0, 1, 1);
  FDropdownRect.Create(0, 0, 1, 1);
  {$ENDIF}
  FMouseHoverElement := beNone;
  FMouseActiveElement := beNone;
end;

destructor TLazRibbonBaseButton.Destroy;
begin
  FreeAndNil(FActionLink);
  inherited Destroy;
end;

procedure TLazRibbonBaseButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
var
  newAction: TCustomAction;
begin
  if Sender is TCustomAction then begin
    newAction := TCustomAction(Sender);
    if (not CheckDefaults) or (Caption = '') or (Caption = Name) then
      Caption := newAction.Caption;
    if not CheckDefaults or Enabled then
      Enabled := newAction.Enabled;

    if not CheckDefaults or (Hint = '') then
      Hint := newAction.Hint;

    if not CheckDefaults or Visible then
      Visible := newAction.Visible;
    if not CheckDefaults or Checked then
      Checked := newAction.Checked;
    if not CheckDefaults or (GroupIndex > 0) then
      GroupIndex := newAction.GroupIndex;

    {   !!! wp: Actions don't have an AllowAllUp property !!!

    if not CheckDefaults or not AllowAllUp then
      AllowAllUp := newAction.AllowAllUp;
    }

    if self is TLazRibbonSmallButton then begin
      if not CheckDefaults or (TLazRibbonSmallButton(self).ImageIndex < 0) then
        TLazRibbonSmallButton(self).ImageIndex := newAction.ImageIndex;
    end;
    if self is TLazRibbonLargeButton then begin
      if not CheckDefaults or (TLazRibbonLargeButton(self).LargeImageIndex < 0) then
        TLazRibbonLargeButton(self).LargeImageIndex := newAction.ImageIndex;
    end;

    { wp: !!! Helpcontext not yet supported !!!

    if not CheckDefaults or (Self.HelpContext = 0) then
      Self.HelpContext := HelpContext;
    if not CheckDefaults or (Self.HelpKeyword = '') then
      Self.HelpKeyword := HelpKeyword;
    // HelpType is set implicitly when assigning HelpContext or HelpKeyword
    }
  end;
end;

(*   wp: Thid is the old part (before avoiding OnExecute = OnClick) - just for reference.

    with TCustomAction(Sender) do
    begin
      if not CheckDefaults or (Self.Caption = '') or (Self.Caption = GetDefaultCaption) then
         Self.Caption := Caption;
      if not CheckDefaults or Self.Enabled then
         Self.Enabled := Enabled;
      if not CheckDefaults or (Self.Visible = True) then
         Self.Visible := Visible;
      if not CheckDefaults or Self.Checked then
        Self.Checked := Checked;
      if not CheckDefaults or (Self.GroupIndex > 0) then
        Self.GroupIndex := GroupIndex;
      if not CheckDefaults or not Self.AllowAllUp then
        Self.AllowAllUp := AllowAllUp;
{
      if not CheckDefaults or not Assigned(Self.OnClick) then
         Self.OnClick := OnExecute;
}
      if self is TLazRibbonSmallButton then begin
        if not CheckDefaults or (TLazRibbonSmallButton(self).ImageIndex < 0) then
          TLazRibbonSmallButton(self).ImageIndex := ImageIndex;
      end;
      if self is TLazRibbonLargeButton then begin
        if not CheckDefaults or (TLazRibbonLargeButton(self).LargeImageIndex < 0) then
          TLazRibbonLargeButton(Self).LargeImageIndex := ImageIndex;
      end;
    end;
end;
*)

procedure TLazRibbonBaseButton.Click;
begin
  // first call our own OnClick
  if Assigned(FOnClick) then
    FOnClick(Self)
  else
  // otherwise trigger the action
  if (not (csDesigning in ComponentState)) and (FActionLink <> nil) then
    FActionLink.Execute(Self);
end;

function TLazRibbonBaseButton.ExecuteKeyTip: Boolean;
var
  DropPoint: T2DIntPoint;
begin
  Result := False;
  if (not FVisible) or (not FEnabled) then
    Exit;

  if FButtonKind in [bkButton, bkButtonDropdown, bkToggle] then
  begin
    if (FButtonKind = bkToggle) and
       ((Action = nil) or ((Action is TCustomAction) and not TCustomAction(Action).AutoCheck))
    then
      Checked := not Checked;
    Click;
    Result := True;
    Exit;
  end;

  if (FButtonKind = bkDropdown) and Assigned(FDropdownMenu) and Assigned(FToolbarDispatch) then
  begin
    DropPoint := FToolbarDispatch.ClientToScreen(GetDropdownPoint);
    if IsRightToLeft then
      FDropDownMenu.BiDiMode := bdRightToLeft
    else
      FDropDownMenu.BiDiMode := bdLeftToRight;
    FDropdownMenu.Popup(DropPoint.x, DropPoint.y);
    Result := True;
  end;
end;

procedure TLazRibbonBaseButton.DoActionChange(Sender: TObject);
begin
  if Sender = Action then
    ActionChange(Sender, False);
end;

{ Draw a downward-facing filled triangle as dropdown arrow }
procedure TLazRibbonBaseButton.DrawDropdownArrow(ABuffer: TBitmap; ARect: TRect;
  AColor: TColor);
var
  P: array[0..3] of TPoint;
begin
  P[2].x := ARect.Left + (ARect.Right - ARect.Left) div 2;
  P[2].y := ARect.Top + (ARect.Bottom - ARect.Top + DropDownArrowHeight) div 2 - 1;
  P[0] := Point(P[2].x - DropDownArrowWidth div 2, P[2].y - DropDownArrowHeight div 2);
  P[1] := Point(P[2].x + DropDownArrowWidth div 2, P[0].y);
  P[3] := P[0];
  ABuffer.Canvas.Brush.Color := AColor;
  ABuffer.Canvas.Pen.Style := psClear;
  ABuffer.Canvas.Polygon(P);
end;

function TLazRibbonBaseButton.GetAction: TBasicAction;
begin
  if Assigned(FActionLink) then
    Result := FActionLink.Action
  else
    Result := nil;
end;

function TLazRibbonBaseButton.GetChecked: Boolean;
begin
  Result := FChecked;
end;

function TLazRibbonBaseButton.GetDefaultCaption: String;
begin
  Result := 'Button';
end;

function TLazRibbonBaseButton.GetRootComponent: TComponent;
var
  pane: TLazRibbonBaseItem;
  tab: TLazRibbonBaseItem;
begin
  result := nil;
  if Collection <> nil then
    pane := TLazRibbonBaseItem(Collection.RootComponent)
  else
    exit;
  if (pane <> nil) and (pane.Collection <> nil) then
    tab := TLazRibbonBaseItem(pane.Collection.RootComponent)
  else
    exit;
  if (tab <> nil) and (tab.Collection <> nil) then
    result := tab.Collection.RootComponent;
end;

function TLazRibbonBaseButton.IsRightToLeft: Boolean;
begin
  Result := (GetRootComponent as TControl).IsRightToLeft;
end;

procedure TLazRibbonBaseButton.Notify(Item: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (Item = FDropDownMenu) then
  begin
    DropDownMenu := nil;
  end;
end;

procedure TLazRibbonBaseButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FEnabled then
  begin
    // The buttons react only to the left mouse button
    if Button <> mbLeft then
      exit;

    if (FButtonKind = bkToggle) and
       ((Action = nil) or ((Action is TCustomAction) and not TCustomAction(Action).AutoCheck)) and
       MouseOnActivePart(X, Y)
    then
      Checked := not Checked;

    if FMouseActiveElement = beButton then
    begin
      if FButtonState <> bsBtnPressed then
      begin
        FButtonState := bsBtnPressed;
        if Assigned(FToolbarDispatch) then
          FToolbarDispatch.NotifyVisualsChanged;
      end;
    end else
    if FMouseActiveElement = beDropdown then
    begin
      if FButtonState <> bsDropdownPressed then
      begin
        FButtonState := bsDropdownPressed;
        if Assigned(FToolbarDispatch) then
          FToolbarDispatch.NotifyVisualsChanged;
      end;
    end else
    if FMouseActiveElement = beNone then
    begin
      if FMouseHoverElement = beButton then
      begin
        FMouseActiveElement := beButton;
        if FButtonState <> bsBtnPressed then
        begin
          FButtonState := bsBtnPressed;
          if FToolbarDispatch <> nil then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end else
      if FMouseHoverElement = beDropdown then
      begin
        FMouseActiveElement := beDropdown;
        if FButtonState <> bsDropdownPressed then
        begin
          FButtonState := bsDropdownPressed;
          if FToolbarDispatch <> nil then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end;
    end;
  end    // if FEnabled
  else
  begin
    FMouseHoverElement := beNone;
    FMouseActiveElement := beNone;
    if FButtonState <> bsIdle then
    begin
      FButtonState := bsIdle;
      if Assigned(FToolbarDispatch) then
        FToolbarDispatch.NotifyVisualsChanged;
    end;
  end;
end;

procedure TLazRibbonBaseButton.MouseLeave;
begin
  if FEnabled then
  begin
    if FMouseActiveElement = beNone then
    begin
      if FMouseHoverElement = beButton then
      begin
        // Placeholder, if there is a need to handle this event
      end else
      if FMouseHoverElement = beDropdown then
      begin
        // Placeholder, if there is a need to handle this event
      end;
    end;
    if FButtonState <> bsIdle then
    begin
      FButtonState := bsIdle;
      if Assigned(FToolbarDispatch) then
        FToolbarDispatch.NotifyVisualsChanged;
    end;
  end  // if FEnabled
  else
  begin
    FMouseHoverElement := beNone;
    FMouseActiveElement := beNone;
    if FButtonState <> bsIdle then
    begin
      FButtonState := bsIdle;
      if Assigned(FToolbarDispatch) then
        FToolbarDispatch.NotifyVisualsChanged;
    end;
  end;
end;

procedure TLazRibbonBaseButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewMouseHoverElement: TLazRibbonMouseButtonElement;
begin
  if FEnabled then
  begin
    {$IFDEF EnhancedRecordSupport}
    if FButtonRect.Contains(T2DIntPoint.Create(X,Y))
    {$ELSE}
    if FButtonRect.Contains(X,Y)
    {$ENDIF}
    then
      NewMouseHoverElement := beButton
    else
    if (FButtonKind = bkButtonDropdown) and
      {$IFDEF EnhancedRecordSupport}
      (FDropdownRect.Contains(T2DIntPoint.Create(X,Y))) then
      {$ELSE}
      (FDropdownRect.Contains(X,Y))
      {$ENDIF}
    then
      NewMouseHoverElement := beDropdown
    else
      NewMouseHoverElement := beNone;

    if not MouseOnActivePart(X, Y) then
      NewMouseHoverElement := beNone;

    if FMouseActiveElement = beButton then
    begin
      if (NewMouseHoverElement = beNone) and (FButtonState <> bsIdle) then
      begin
        FButtonState := bsIdle;
        if FToolbarDispatch <> nil then
          FToolbarDispatch.NotifyVisualsChanged;
      end else
      if (NewMouseHoverElement = beButton) and (FButtonState <> bsBtnPressed) then
      begin
        FButtonState := bsBtnPressed;
        if FToolbarDispatch <> nil then
          FToolbarDispatch.NotifyVisualsChanged;
      end;
    end else
    if FMouseActiveElement = beDropdown then
    begin
      if (NewMouseHoverElement = beNone) and (FButtonState <> bsIdle) then
      begin
        FButtonState := bsIdle;
        if FToolbarDispatch <> nil then
          FToolbarDispatch.NotifyVisualsChanged;
      end else
      if (NewMouseHoverElement = beDropdown) and (FButtonState <> bsDropdownPressed) then
      begin
        FButtonState := bsDropdownPressed;
        if FToolbarDispatch <> nil then
          FToolbarDispatch.NotifyVisualsChanged;
      end;
    end else
    if FMouseActiveElement = beNone then
    begin
      // Due to the simplified mouse support in the button, there is no need to
      // inform the previous element that the mouse has left its area.
      if NewMouseHoverElement = beButton then
      begin
        if FButtonState <> bsBtnHottrack then
        begin
          FButtonState := bsBtnHottrack;
          if FToolbarDispatch <> nil then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end else
      if NewMouseHoverElement = beDropdown then
      begin
        if FButtonState <> bsDropdownHottrack then
        begin
          FButtonState := bsDropdownHottrack;
          if FToolbarDispatch <> nil then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end else
      if NewMouseHoverElement = beNone then
      begin
        FButtonState := bsIdle;
        if FToolbarDispatch <> nil then
          FToolbarDispatch.NotifyVisualsChanged;
      end;
    end;
    FMouseHoverElement := NewMouseHoverElement;
  end    // if FEnabled
  else
  begin
    FMouseHoverElement := beNone;
    FMouseActiveElement := beNone;
    if FButtonState <> bsIdle then
    begin
      FButtonState := bsIdle;
      if Assigned(FToolbarDispatch) then
        FToolbarDispatch.NotifyVisualsChanged;
    end;
  end;
end;

procedure TLazRibbonBaseButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  ClearActive: boolean;
  DropPoint: T2DIntPoint;
begin
  if FEnabled then
  begin
    // The buttons react only to the left mouse button
    if Button <> mbLeft then
      exit;

    ClearActive := not (ssLeft in Shift);

    if FMouseActiveElement = beButton then
    begin
      // The event only works when the mouse button is released above the button
      if FMouseHoverElement = beButton then
      begin
        if FButtonKind in [bkButton, bkButtonDropdown, bkToggle] then
        begin
          FButtonState := bsBtnHottrack;
          if Assigned(FToolbarDispatch) then
            FToolbarDispatch.NotifyVisualsChanged;
          Click;
        end else
        if FButtonKind = bkDropdown then
        begin
          if Assigned(FDropdownMenu) then
          begin
            DropPoint := FToolbarDispatch.ClientToScreen(GetDropdownPoint);
            if IsRightToLeft then
              FDropDownMenu.BiDiMode := bdRightToLeft
            else
              FDropDownMenu.BiDiMode := bdLeftToRight;
            FDropdownMenu.Popup(DropPoint.x, DropPoint.y);
            FButtonState := bsBtnHottrack;
            if Assigned(FToolbarDispatch) then
              FToolbarDispatch.NotifyVisualsChanged;
          end;
        end;
      end;
    end else
    if FMouseActiveElement = beDropDown then
    begin
      // The event only works if the mouse button has been released above the
      // DropDown button
      if FMouseHoverElement = beDropDown then
      begin
        if Assigned(FDropdownMenu) then
        begin
          DropPoint := FToolbarDispatch.ClientToScreen(GetDropdownPoint);
          if IsRightToLeft then
            FDropDownMenu.BiDiMode := bdRightToLeft
          else
            FDropDownMenu.BiDiMode := bdLeftToRight;
          FDropdownMenu.Popup(DropPoint.x, DropPoint.y);
          FButtonState := bsBtnHottrack;
          if Assigned(FToolbarDispatch) then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end;
    end;

    if ClearActive and (FMouseActiveElement <> FMouseHoverElement) then
    begin
      // Due to the simplified handling, there is no need to inform the
      // previous element that the mouse has left its area.
      if FMouseHoverElement = beButton then
      begin
        if FButtonState <> bsBtnHottrack then
        begin
          FButtonState := bsBtnHottrack;
          if Assigned(FToolbarDispatch) then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end else
      if FMouseHoverElement = beDropdown then
      begin
        if FButtonState <> bsDropdownHottrack then
        begin
          FButtonState := bsDropdownHottrack;
          if Assigned(FToolbarDispatch) then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end else
      if FMouseHoverElement = beNone then
      begin
        if FButtonState <> bsIdle then
        begin
          FButtonState := bsIdle;
          if Assigned(FToolbarDispatch) then
            FToolbarDispatch.NotifyVisualsChanged;
        end;
      end;
    end;

    if ClearActive then
    begin
      FMouseActiveElement := beNone;
    end;
  end   // if FEnabled
  else
  begin
    FMouseHoverElement := beNone;
    FMouseActiveElement := beNone;
    if FButtonState <> bsIdle then
    begin
      FButtonState := bsIdle;
      if Assigned(FToolbarDispatch) then
        FToolbarDispatch.NotifyVisualsChanged;
    end;
  end;
end;

function TLazRibbonBaseButton.MouseOnActivePart(X, Y: Integer): Boolean;
begin
  Result := true;
end;

procedure TLazRibbonBaseButton.SetAction(const Value: TBasicAction);
begin
  if Value = nil then
  begin
    FActionLink.Free;
    FActionLink := nil;
  end else
  begin
    if FActionLink = nil then
      FActionLink := TLazRibbonButtonActionLink.Create(self);
    FActionLink.Action := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
  end;
end;

procedure TLazRibbonBaseButton.SetAllowAllUp(const Value: Boolean);
begin
  FAllowAllUp := Value;
end;

procedure TLazRibbonBaseButton.SetButtonKind(const Value: TLazRibbonButtonKind);
begin
  if FButtonKind = Value then
    exit;

  FButtonKind := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonBaseButton.SetCaption(const Value: string);
begin
  if FCaption = Value then
    exit;

  FCaption := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonBaseButton.SetChecked(const Value: Boolean);
begin
  if FChecked = Value then
    exit;

  if FGroupIndex > 0 then
  begin
    if FAllowAllUp or ((not FAllowAllUp) and Value) then
      UncheckSiblings;
    if not FAllowAllUp and (not Value) and not SiblingsChecked then
      exit;
  end;

  FChecked := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;

  if not (csDesigning in ComponentState) and (Action is TCustomAction) then
    TCustomAction(Action).Checked := Value;
end;

procedure TLazRibbonBaseButton.SetDropdownMenu(const Value: TPopupMenu);
begin
  if FDropDownMenu = Value then
    exit;

  FDropdownMenu := Value;
  if (FDropdownMenu is TLazRibbonPopupMenu) then
    TLazRibbonPopupMenu(FDropdownMenu).Appearance := Self.Appearance;
  if Assigned(FToolbarDispatch) then
     FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonBaseButton.SetEnabled(const Value: boolean);
begin
  inherited;
  if not FEnabled then
  begin
    // If the button has been switched off, it is immediately switched into
    // the Idle state and the active and under the mouse are reset.
    // If it has been enabled, its status will change during the first
    // mouse action.

    // Original comment:
    // Jeœli przycisk zosta³ wy³¹czony, zostaje natychmiast prze³¹czony
    // w stan Idle i zerowane s¹ elementy aktywne i pod mysz¹. Jeœli zosta³
    // w³¹czony, jego stan zmieni siê podczas pierwszej akcji myszy.

    FMouseHoverElement := beNone;
    FMouseActiveElement := beNone;

    if FButtonState <> bsIdle then
    begin
      FButtonState := bsIdle;
      if Assigned(FToolbarDispatch) then
        FToolbarDispatch.NotifyVisualsChanged;
    end;
  end;
end;

procedure TLazRibbonBaseButton.SetGroupIndex(const Value: Integer);
begin
  if FGroupIndex = Value then
    exit;

  FGroupIndex := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonBaseButton.SetRect(const Value: T2DIntRect);
begin
  inherited;
  CalcRects;
end;

function TLazRibbonBaseButton.IsHintStored: Boolean;
begin
  Result := (FActionLink = nil) or not FActionLink.IsHintLinked;
end;


function TLazRibbonBaseButton.GetScreenTipDefaultTitle: TTranslateString;
begin
  Result := Caption;
end;


function TLazRibbonBaseButton.SiblingsChecked: Boolean;
var
  i: Integer;
  pane: TLazRibbonPane;
  btn: TLazRibbonBaseButton;
begin
  if (Parent is TLazRibbonPane) then
  begin
    pane := TLazRibbonPane(Parent);
    for i:=0 to pane.Items.Count-1 do
      if pane.Items[i] is TLazRibbonBaseButton then
      begin
        btn := TLazRibbonBaseButton(pane.Items[i]);
        if (btn <> self) and (btn.ButtonKind = bkToggle) and
           (btn.GroupIndex = FGroupIndex) and btn.Checked then
        begin
          Result := true;
          exit;
        end;
      end;
  end;
  Result := false;
end;

procedure TLazRibbonBaseButton.UncheckSiblings;
var
  i: Integer;
  pane: TLazRibbonPane;
  btn: TLazRibbonBaseButton;
begin
  if (Parent is TLazRibbonPane) then begin
    pane := TLazRibbonPane(Parent);
    for i:=0 to pane.Items.Count-1 do
      if pane.Items[i] is TLazRibbonBasebutton then
      begin
        btn := TLazRibbonBaseButton(pane.Items[i]);
        if (btn <> self) and (btn.ButtonKind = bkToggle) and (btn.GroupIndex = FGroupIndex) then
          btn.FChecked := false;
      end;
  end;
end;


{ TLazRibbonCustomLargeButton }

procedure TLazRibbonCustomLargeButton.CalcRects;
begin
  if (FDropdownMenu is TLazRibbonPopupMenu) then
    TLazRibbonPopupMenu(FDropdownMenu).Appearance := FAppearance;

 {$IFDEF EnhancedRecordSupport}
  if FButtonKind = bkButtonDropdown then
  begin
    FButtonRect := T2DIntRect.Create(FRect.Left, FRect.Top, FRect.Right, FRect.Bottom - LargeButtonDropdownFieldSize);
    FDropdownRect := T2DIntRect.Create(FRect.Left, FRect.Bottom - LargeButtonDropdownFieldSize, FRect.Right, FRect.Bottom);
    //FDropdownRect := T2DIntRect.Create(FRect.Left, FRect.Bottom - LargeButtonDropdownFieldSize + 1, FRect.Right, FRect.Bottom);
  end else
  if FButtonKind = bkSeparator then
  begin
    FButtonRect := T2DIntRect.Create(FRect.Left, FRect.Top, FRect.Left + LargeButtonSeparatorWidth, FRect.Bottom - LargeButtonDropdownFieldSize);
    FDropdownRect := T2DIntRect.Create(0, 0, 0, 0);
  end else
  begin
    FButtonRect := FRect;
    FDropdownRect := T2DIntRect.Create(0, 0, 0, 0);
  end;
 {$ELSE}
  if FButtonKind = bkButtonDropdown then
  begin
    FButtonRect.Create(FRect.Left, FRect.Top, FRect.Right, FRect.Bottom - LargeButtonDropdownFieldSize);
    FDropdownRect.Create(FRect.Left, FRect.Bottom - LargeButtonDropdownFieldSize, FRect.Right, FRect.Bottom);
//    FDropdownRect.Create(FRect.Left, FRect.Bottom - LargeButtonDropdownFieldSize + 1, FRect.Right, FRect.Bottom);
  end else
  if FButtonKind = bkSeparator then
  begin
    FButtonRect.Create(FRect.Left, FRect.Top, FRect.Left + LargeButtonSeparatorWidth, FRect.Bottom - LargeButtonDropdownFieldSize);
    FDropdownRect.Create(0, 0, 0, 0);
  end else
  begin
    FButtonRect := FRect;
    FDropdownRect.Create(0, 0, 0, 0);
  end;
 {$ENDIF}
end;

constructor TLazRibbonCustomLargeButton.Create(AOwner: TComponent);
begin
  inherited;
  FLargeImageIndex := -1;
end;

procedure TLazRibbonCustomLargeButton.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  fontColor, frameColor: TColor;
  gradientFromColor, gradientToColor: TColor;
  innerLightColor, innerDarkColor: TColor;
  gradientKind: TBackgroundKind;
  x: Integer;
  y: Integer;
  delta: Integer;
  cornerRadius: Integer;
  imgList: TImageList;
  imgSize: TSize;
  txtHeight: Integer;
  breakPos, breakWidth: Integer;
  s: String;
  P: T2DIntPoint;
  drawBtn: Boolean;
  ppi: Integer;
  R: TRect;
  SeparatorRect: TRect;
  SeparatorLineColor: TColor;
  ts: TTextStyle;
  drawImgEnabled: Boolean = true;
  pressedOffset: Integer;
begin
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;

  ts := ABuffer.Canvas.TextStyle;
  ts.RightToLeft := IsRightToLeft;
  ABuffer.Canvas.TextStyle := ts;

  if (FButtonKind <> bkSeparator) then
  begin
    if (FRect.Width < 2*LargeButtonRadius) or (FRect.Height < 2*LargeButtonRadius) then
      exit;
  end else
  begin
    SeparatorLineColor := FAppearance.Pane.BorderDarkColor;
    SeparatorRect.Create(FRect.Left + (LargeButtonSeparatorWidth div 2),
      FRect.Top,FRect.Left + (LargeButtonSeparatorWidth div 2) + 1,
      FRect.Bottom);
    TGUITools.DrawVLine(
      ABuffer,
      SeparatorRect.Left,
      SeparatorRect.Top + LargeButtonSeparatorTopMargin,
      SeparatorRect.Bottom - LargeButtonSeparatorBottomMargin,
      SeparatorLineColor
    );
    exit;
  end;

  delta := FAppearance.Element.HotTrackBrightnessChange;
  case FAppearance.Element.Style of
    esRounded:
      cornerRadius := LargeButtonRadius;
    esRectangle:
      cornerRadius := 0;
  end;

  pressedOffset := 0;
  if FEnabled and (FButtonState in [bsBtnPressed, bsDropdownPressed]) then
    pressedOffset := 1;

  // Prepare text color
  fontColor := clNone;
  case FButtonState of
    bsIdle:
      fontColor := FAppearance.Element.IdleCaptionColor;
    bsBtnHottrack, bsDropdownHottrack:
      fontColor := FAppearance.Element.HotTrackCaptionColor;
    bsBtnPressed, bsDropdownPressed:
      fontColor := FAppearance.ELement.ActiveCaptionColor;
  end;
  if not FEnabled then
    fontColor := LazRibbonDisabledTextColor(fontColor, FAppearance.Pane.GradientToColor);

  // Dropdown button
  // Draw full rect, otherwise the DropDownRect will contain the full gradient
  if FButtonKind = bkButtonDropdown then
  begin
    drawBtn := true;
    if (FButtonState in [bsBtnHotTrack, bsBtnPressed]) then
    begin
      FAppearance.Element.GetHotTrackButtonColors(Checked,
        fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, gradientKind,
        delta);
    end else
    if (FButtonState = bsDropdownHottrack) then
    begin
      FAppearance.Element.GetHotTrackButtonColors(Checked,
        fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, gradientKind);
    end else
    if (FButtonState = bsDropdownPressed) then
    begin
      FAppearance.Element.GetActiveButtonColors(Checked,
        fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, gradientKind);
    end else
      drawBtn := false;

    if drawBtn then begin
      if not FEnabled then
        LazRibbonApplyDisabledButtonColors(fontColor, frameColor, innerLightColor, innerDarkColor,
          gradientFromColor, gradientToColor, FAppearance.Pane.GradientToColor);
      TButtonTools.DrawButton(
        ABuffer,
        FRect,
        frameColor,
        innerLightColor,
        innerDarkColor,
        gradientFromColor,
        gradientToColor,
        gradientKind,
        false,
        false,
        false,
        false,
        cornerRadius,
        ClipRect
      );
    end;
  end;

  // Button (Background and frame)
  drawBtn := true;
  if FButtonState = bsBtnHottrack then
  begin
    FAppearance.Element.GetHotTrackButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientKind);
  end else
  if FButtonState = bsBtnPressed then
  begin
    FAppearance.Element.GetActiveButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientkind);
  end else
  if (FButtonState in [bsDropdownHotTrack, bsDropdownPressed]) then
  begin
    FAppearance.Element.GetHotTrackButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientKind,
      delta);
  end else
  if (FButtonState = bsIdle) and Checked then
  begin
    FAppearance.Element.GetActiveButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientKind
    );
  end else
    drawBtn := false;

  if drawBtn then
  begin
    if not FEnabled then
      LazRibbonApplyDisabledButtonColors(fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, FAppearance.Pane.GradientToColor);
    TButtonTools.DrawButton(
      ABuffer,
      FButtonRect,       // draw button part only
      frameColor,
      innerLightColor,
      innerDarkColor,
      gradientFromColor,
      gradientToColor,
      gradientKind,
      false,
      false,
      false,
      FButtonKind = bkButtonDropdown,
      cornerRadius,
      ClipRect
    );
  end;

  // Dropdown button - draw horizontal dividing line
  if FButtonKind = bkButtonDropdown then
  begin
    drawBtn := true;
    if (FButtonState in [bsDropdownHotTrack, bsBtnHotTrack]) then
      frameColor := FAppearance.element.HotTrackFrameColor
    else
    if (FButtonState in [bsDropDownPressed, bsBtnPressed]) then
      frameColor := FAppearance.Element.ActiveFrameColor
    else
      drawBtn := false;
    if drawBtn then
      TGuiTools.DrawHLine(
        ABuffer,
        FDropDownRect.Left,
        FDropDownRect.Right,
        FDropDownRect.Top,
        frameColor,
        ClipRect
     );
  end;

  // Icon
  if not FEnabled and (FDisabledLargeImages <> nil) then
    imgList := FDisabledLargeImages
  else
  begin
    imgList := FLargeImages;
    if not FEnabled then drawImgEnabled := false;
  end;

  if (imgList <> nil) and (FLargeImageIndex >= 0) and (FLargeImageIndex < imgList.Count) then
  begin
    ppi := FAppearance.Element.CaptionFont.PixelsPerInch;
    {$IF LCL_FULLVERSION >= 1090000}
    imgSize := imgList.SizeForPPI[FLargeImagesWidth, ppi];
    {$ELSE}
    imgSize := Size(imgList.Width, imgList.Height);
    {$ENDIF}

    P := {$IFDEF EnhancedRecordSupport}T2DIntPoint.Create{$ELSE}Create2DIntPoint{$ENDIF}(
      FButtonRect.Left + (FButtonRect.Width - imgSize.CX) div 2 + pressedOffset,
      FButtonRect.Top + LargeButtonBorderSize + LargeButtonGlyphMargin + pressedOffset
    );
    TGUITools.DrawImage(ABuffer.Canvas, imgList, FLargeImageIndex, P, ClipRect,
      FLargeImagesWidth, ppi, 1.0, drawImgEnabled);
  end;

  // Text
  ABuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
  ABuffer.Canvas.Font.Color := fontColor;

  if FButtonKind in [bkButton, bkToggle] then
    FindBreakPlace(FCaption, breakPos, breakWidth)
  else
    breakPos := 0;
  txtHeight := ABuffer.Canvas.TextHeight('Wy');

  if breakPos > 0 then
  begin
    s := Copy(FCaption, 1, breakPos - 1);
    x := FRect.Left + (FRect.Width - ABuffer.Canvas.Textwidth(s)) div 2;
    y := FRect.Top + LargeButtonCaptionTopRail - txtHeight div 2;
    TGUITools.DrawText(ABuffer.Canvas, x + pressedOffset, y + pressedOffset, s, fontColor, ClipRect);

    s := Copy(FCaption, breakPos+1, Length(FCaption) - breakPos);
    x := FRect.Left + (FRect.Width - ABuffer.Canvas.Textwidth(s)) div 2;
    y := FRect.Top + LargeButtonCaptionButtomRail - txtHeight div 2;
    TGUITools.DrawText(ABuffer.Canvas, x + pressedOffset, y + pressedOffset, s, fontColor, ClipRect);
  end else
  begin
    // The text is not broken
    x := FButtonRect.Left + (FButtonRect.Width - ABuffer.Canvas.Textwidth(FCaption)) div 2;
    y := FRect.Top + LargeButtonCaptionTopRail - txtHeight div 2;
    TGUITools.DrawText(ABuffer.Canvas, x + pressedOffset, y + pressedOffset, FCaption, FontColor, ClipRect);
  end;

  // Dropdown arrow
  if FButtonKind = bkDropdown then
  begin
    y := FButtonRect.Bottom - ABuffer.Canvas.TextHeight('Tg') - 1;
    R := Classes.Rect(FButtonRect.Left, y, FButtonRect.Right, FButtonRect.Bottom);
    Types.OffsetRect(R, pressedOffset, pressedOffset);
    DrawDropdownArrow(ABuffer, R, fontcolor);
  end else
  if FButtonKind = bkButtonDropdown then
  begin
    y := FDropdownRect.Bottom - ABuffer.Canvas.TextHeight('Tg') - 1;
    R := Classes.Rect(FDropdownRect.Left, y, FDropDownRect.Right, FDropdownRect.Bottom);
    Types.OffsetRect(R, pressedOffset, pressedOffset);
    DrawDropdownArrow(ABuffer, R, fontcolor);
  end;
end;

procedure TLazRibbonCustomLargeButton.FindBreakPlace(s: string; out Position: integer; out Width: integer);
var
  i: integer;
  Bitmap: TBitmap;
  BeforeWidth, AfterWidth: integer;
begin
  Position := -1;
  Width := -1;

  if FToolbarDispatch=nil then
     exit;
  if FAppearance=nil then
     exit;

  Bitmap := FToolbarDispatch.GetTempBitmap;
  if Bitmap=nil then
    exit;

  Bitmap.Canvas.Font.Assign(FAppearance.Element.CaptionFont);

  Width := Bitmap.Canvas.TextWidth(FCaption);

  for i := 1 to Length(s) do
    if s[i] = ' ' then
    begin
      if i > 1 then
        BeforeWidth := Bitmap.Canvas.TextWidth(Copy(s, 1, i-1))
      else
        BeforeWidth := 0;

      if i < Length(s) then
        AfterWidth := Bitmap.Canvas.TextWidth(Copy(s, i+1, Length(s)-i))
      else
        AfterWidth := 0;

      if (Position = -1) or (Max(BeforeWidth, AfterWidth) < Width) then
      begin
        Width := Max(BeforeWidth, AfterWidth);
        Position := i;
      end;
    end;
end;

function TLazRibbonCustomLargeButton.GetDropdownPoint: T2DIntPoint;
begin
  {$IFDEF EnhancedRecordSupport}
  case FButtonKind of
    bkDropdown       : Result := T2DIntPoint.Create(FButtonRect.left, FButtonRect.Bottom+1);
    bkButtonDropdown : Result := T2DIntPoint.Create(FDropdownRect.left, FDropdownRect.Bottom+1);
  else
    Result := T2DIntPoint.Create(0,0);
  end;
  {$ELSE}
  case FButtonKind of
    bkDropdown       : Result.Create(FButtonRect.left, FButtonRect.Bottom+1);
    bkButtonDropdown : Result.Create(FDropdownRect.left, FDropdownRect.Bottom+1);
  else
    Result.Create(0,0);
  end;
  {$ENDIF}
end;

function TLazRibbonCustomLargeButton.GetGroupBehaviour: TLazRibbonItemGroupBehaviour;
begin
  Result := gbSingleItem;
end;

function TLazRibbonCustomLargeButton.GetSize: TLazRibbonItemSize;
begin
  Result := isLarge;
end;

function TLazRibbonCustomLargeButton.GetTableBehaviour: TLazRibbonItemTableBehaviour;
begin
  Result := tbBeginsColumn;
end;

function TLazRibbonCustomLargeButton.GetWidth: integer;
var
  GlyphWidth: integer;
  TextWidth: integer;
  Bitmap: TBitmap;
  BreakPos, RowWidth: integer;
begin
  Result := -1;

  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;

  if FButtonKind = bkSeparator then
  begin
    Result := LargeButtonSeparatorWidth;
    exit
  end;

  Bitmap := FToolbarDispatch.GetTempBitmap;
  if Bitmap = nil then
    exit;

  // Glyph
  if FLargeImages <> nil then
    GlyphWidth := 2 * LargeButtonGlyphMargin + FLargeImages.WidthForPPI[FLargeImagesWidth, Screen.PixelsPerInch]
  else
    GlyphWidth := 0;

  // Text
  if FButtonKind in [bkButton, bkToggle] then
  begin
    // Label
    FindBreakPlace(FCaption,BreakPos,RowWidth);
    TextWidth := 2 * LargeButtonCaptionHMargin + RowWidth;
  end else
  begin
    // do not break the label
    Bitmap.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
    TextWidth := 2 * LargeButtonCaptionHMargin + Bitmap.Canvas.TextWidth(FCaption);
  end;

  Result := Max(LargeButtonMinWidth, Max(GlyphWidth, TextWidth));
end;

procedure TLazRibbonCustomLargeButton.SetLargeImageIndex(const Value: TImageIndex);
begin
  FLargeImageIndex := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;


{ TLazRibbonCustomTableButton }

constructor TLazRibbonCustomTableButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTableBehaviour := tbContinuesRow;
end;

function TLazRibbonCustomTableButton.GetGroupBehaviour: TLazRibbonItemGroupBehaviour;
begin
  Result := gbSingleItem;
end;

function TLazRibbonCustomTableButton.GetSize: TLazRibbonItemSize;
begin
  Result := isNormal;
end;

function TLazRibbonCustomTableButton.GetTableBehaviour: TLazRibbonItemTableBehaviour;
begin
  Result := FTableBehaviour;
end;

procedure TLazRibbonCustomTableButton.SetTableBehaviour(const Value: TLazRibbonItemTableBehaviour);
begin
  FTableBehaviour := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;


{ TLazRibbonSmallButton }

constructor TLazRibbonSmallButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageIndex := -1;
  FGroupBehaviour := gbSingleItem;
  FHideFrameWhenIdle := true;
  FShowCaption := true;
end;

procedure TLazRibbonSmallButton.CalcRects;
var
  RectVector: T2DIntVector;
begin
  if FButtonKind = bkSeparator then
  begin
    FButtonRect.Create(FRect.Left, FRect.Top,
      FRect.Left + SmallButtonSeparatorWidth,
      FRect.Bottom - LargeButtonDropdownFieldSize
      );
    FDropdownRect.Create(0, 0, 0, 0);
  end else
  begin
    ConstructRects(FButtonRect, FDropdownRect);
    {$IFDEF EnhancedRecordSupport}
    RectVector := T2DIntVector.Create(FRect.Left, FRect.Top);
   {$ELSE}
    RectVector.Create(FRect.Left, FRect.Top);
   {$ENDIF}
    FButtonRect := FButtonRect + RectVector;
    FDropdownRect := FDropdownRect + RectVector;
  end;
end;

procedure TLazRibbonSmallButton.ConstructRects(out BtnRect, DropRect: T2DIntRect);
var
  BtnWidth: integer;
  DropdownWidth: Integer;
  Bitmap: TBitmap;
  TextWidth: Integer;
  AdditionalPadding: Boolean;
  isRTL: Boolean;
begin
  {$IFDEF EnhancedRecordSupport}
  BtnRect := T2DIntRect.Create(0, 0, 0, 0);
  DropRect := T2DIntRect.Create(0, 0, 0, 0);
  {$ELSE}
  BtnRect.Create(0, 0, 0, 0);
  DropRect.Create(0, 0, 0, 0);
  {$ENDIF}

  if not Assigned(FToolbarDispatch) then
    exit;
  if not Assigned(FAppearance) then
    exit;

  Bitmap := FToolbarDispatch.GetTempBitmap;
  if not Assigned(Bitmap) then
    exit;

  isRTL := IsRightToLeft;

  // *** Regardless of the type, there must be room for the icon and / or text ***

  BtnWidth := 0;
  AdditionalPadding := false;

  // Icon
  if FImageIndex <> -1 then
  begin
    BtnWidth := BtnWidth + SmallButtonPadding + SmallButtonGlyphWidth;
    AdditionalPadding := true;
  end;

  // Text
  if FShowCaption then
  begin
    Bitmap.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
    TextWidth := Bitmap.Canvas.TextWidth(FCaption);

    BtnWidth := BtnWidth + SmallButtonPadding + TextWidth;
    AdditionalPadding := true;
  end;

  // Padding behind the text or icon
  if AdditionalPadding then
    BtnWidth := BtnWidth + SmallButtonPadding;

  // The width of the button content must be at least SMALLBUTTON_MIN_WIDTH
  BtnWidth := Max(SmallButtonMinWidth, BtnWidth);

  // *** Dropdown ***
  case FButtonKind of
    bkButton, bkToggle:
      begin
        // Left edge of the button
        if FGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          BtnWidth := BtnWidth + SmallButtonHalfBorderWidth
        else
          BtnWidth := BtnWidth + SmallButtonBorderWidth;

        // Right edge of the button
        if (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
          BtnWidth := BtnWidth + SmallButtonHalfBorderWidth
        else
          BtnWidth := BtnWidth + SmallButtonBorderWidth;

        {$IFDEF EnhancedRecordSupport}
        BtnRect := T2DIntRect.Create(0, 0, BtnWidth - 1, LazLayoutSizes.PANE_ROW_HEIGHT - 1);
        DropRect := T2DIntRect.Create(0, 0, 0, 0);
        {$ELSE}
        BtnRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
        DropRect.Create(0, 0, 0, 0);
        {$ENDIF}
      end;

    bkButtonDropdown:
      begin
        // Left edge of the button
        if FGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          BtnWidth := BtnWidth + SmallButtonHalfBorderWidth
        else
          BtnWidth := BtnWidth + SmallButtonBorderWidth;

        // Right edge of the button
        BtnWidth := BtnWidth + SmallButtonHalfBorderWidth;

        // Left edge and dropdown field content
        DropdownWidth := SmallButtonHalfBorderWidth + SmallButtonDropdownWidth;

        // Right edge of the dropdown field
        if (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
          DropdownWidth := DropdownWidth + SmallButtonHalfBorderWidth
        else
          DropdownWidth := DropdownWidth + SmallButtonBorderWidth;

        if isRTL then
        begin
          {$IFDEF EnhancedRecordSupport}
          DropRect := T2DIntRect.Create(0, 0, DropdownWidth - 1, PaneRowHeight - 1);
          BtnRect := T2DIntRect.Create(DropRect.Right+1, 0, DropRect.Right + BtnWidth, PaneRowHeight - 1);
          {$ELSE}
          DropRect.Create(0, 0, DropdownWidth - 1, PaneRowHeight - 1);
          BtnRect.Create(DropRect.Right+1, 0, DropRect.Right + BtnWidth, PaneRowHeight - 1);
          {$ENDIF}
        end else
        begin
          {$IFDEF EnhancedRecordSupport}
          BtnRect := T2DIntRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
          DropRect := T2DIntRect.Create(BtnRect.Right+1, 0, BtnRect.Right+DropdownWidth, PaneRowHeight - 1);
          {$ELSE}
          BtnRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
          DropRect.Create(BtnRect.Right+1,  0, BtnRect.Right+DropdownWidth, PaneRowHeight - 1);
          {$ENDIF}
        end;
      end;

    bkDropdown:
      begin
        // Left edge of the button
        if FGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          BtnWidth := BtnWidth + SmallButtonHalfBorderWidth
        else
          BtnWidth := BtnWidth + SmallButtonBorderWidth;

        // Right edge of the button
        if (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) then
          BtnWidth := BtnWidth + SmallButtonHalfBorderWidth
        else
          BtnWidth := BtnWidth + SmallButtonBorderWidth;

        // Additional area for dropdown + place for the central edge,
        // for dimensional compatibility with dkButtonDropdown
        BtnWidth := BtnWidth + SmallButtonBorderWidth + SmallButtonDropdownWidth;

        {$IFDEF EnhancedRecordSupport}
        BtnRect := T2DIntRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
        DropRect := T2DIntRect.Create(0, 0, 0, 0);
        {$ELSE}
        BtnRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
        DropRect.Create(0, 0, 0, 0);
        {$ENDIF}
      end;
  end;
end;

procedure TLazRibbonSmallButton.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  fontColor: TColor;
  frameColor, innerLightColor, innerDarkColor, knobColor, trackColor: TColor;
  gradientFromColor, gradientToColor: TColor;
  gradientKind: TBackgroundKind;
  P: T2DIntPoint;
  x, dx, y: Integer;
  delta: Integer;
  cornerRadius: Integer;
  ppi, sgn: Integer;
  imgList: TImageList;
  imgSize: TSize;
  drawBtn: Boolean;
  R: TRect;
  SeparatorRect: TRect;
  SeparatorLineColor: TColor;
  leftEdgeOpen, rightEdgeOpen: Boolean;
  drawImgEnabled: Boolean = true;
  pressedOffset: Integer;
  isRTL: Boolean;
  ts: TTextStyle;
begin
  if (FToolbarDispatch = nil) or (FAppearance = nil) then
    exit;

  if FButtonKind = bkSeparator then
  begin
    SeparatorLineColor := FAppearance.Pane.BorderDarkColor;
    SeparatorRect.Create(FRect.Left + (SmallButtonSeparatorWidth div 2),
      FRect.Top,FRect.Left + (SmallButtonSeparatorWidth div 2) + 1,
      FRect.Bottom);
    TGUITools.DrawVLine(
      ABuffer,
      SeparatorRect.Left,
      SeparatorRect.Top + SmallButtonSeparatorTopMargin,
      SeparatorRect.Bottom - SmallButtonSeparatorBottomMargin,
      SeparatorLineColor
    );
    exit;
  end;

  if (FRect.Width < 2*SmallButtonRadius) or (FRect.Height < 2*SmallButtonRadius) then
    exit;

  isRTL := IsRightToLeft;
  sgn := IfThen(isRTL, -1, +1);
  ts := ABuffer.Canvas.TextStyle;
  ts.RightToLeft := isRTL;
  ABuffer.Canvas.TextStyle := ts;

  delta := FAppearance.Element.HotTrackBrightnessChange;
  case FAppearance.Element.Style of
    esRounded:
      cornerRadius := SmallButtonRadius;
    esRectangle:
      cornerRadius := 0;
  end;

  pressedOffset := 0;
  if FEnabled and (FButtonState in [bsBtnPressed, bsDropdownPressed]) then
    pressedOffset := 1;

  // Button (Background and frame)
  drawBtn := true;
  if (FButtonState = bsIdle) and (not FHideFrameWhenIdle) then
  begin
    FAppearance.Element.GetIdleButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientKind
    );
  end else
  if FButtonState = bsBtnHottrack then
  begin
    FAppearance.Element.GetHotTrackButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientKind
    );
  end else
  if FButtonState = bsBtnPressed then
  begin
    FAppearance.Element.GetActiveButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientKind
    );
  end else
  if (FButtonState in [bsDropdownHotTrack, bsDropdownPressed]) then
  begin
    FAppearance.Element.GetHotTrackButtonColors(Checked,
      fontColor, frameColor, innerLightColor, innerDarkColor,
      gradientFromColor, gradientToColor, gradientKind,
      delta
    );
  end else
    drawBtn := false;

  if drawBtn then
  begin
    if not FEnabled then
      LazRibbonApplyDisabledButtonColors(fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, FAppearance.Pane.GradientToColor);
    if isRTL then begin
      rightEdgeOpen := (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]);
      leftEdgeOpen := (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (FButtonKind = bkButtonDropdown);
    end else
    begin
      leftEdgeOpen := (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]);
      rightEdgeOpen := (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]) or (FButtonKind = bkButtonDropdown);
    end;
    TButtonTools.DrawButton(
      ABuffer,
      FButtonRect,       // draw button part only
      frameColor,
      innerLightColor,
      innerDarkColor,
      gradientFromColor,
      gradientToColor,
      gradientKind,
      leftEdgeOpen,
      rightEdgeOpen,
      false,
      false,
      cornerRadius,
      ClipRect
    );
  end;

  // Icon
  if not FEnabled and (FDisabledImages <> nil) then
    imgList := FDisabledImages
  else
  begin
    imgList := FImages;
    if not FEnabled then drawImgEnabled := false;
  end;

  if (imgList <> nil) and (FImageIndex >= 0) and (FImageIndex < imgList.Count) then
  begin
    ppi := FAppearance.Element.CaptionFont.PixelsPerInch;
    {$IF LCL_FULLVERSION >= 1090000}
    imgSize := imgList.SizeForPPI[FImagesWidth, ppi];
    {$ELSE}
    imgSize := Size(imgList.Width, imgList.Height);
    {$ENDIF}

    x := IfThen(isRTL, FButtonRect.Right - imgSize.CX, FButtonRect.Left);
    if (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
      inc(x, sgn * (SmallButtonHalfBorderWidth + SmallButtonPadding))
    else
      inc(x, sgn * (SmallButtonBorderWidth + SmallButtonPadding));
    y := FButtonRect.top + (FButtonRect.height - imgSize.CY) div 2;
    P := {$IFDEF EnhancedRecordSupport}T2DIntPoint.Create{$ELSE}Create2DIntPoint{$ENDIF}(x + pressedOffset, y + pressedOffset);
    TGUITools.DrawImage(
      ABuffer.Canvas,
      imgList,
      FImageIndex,
      P,
      ClipRect,
      FImagesWidth,
      ppi, 1.0,
      drawImgEnabled
    );
  end;

  // Prepare font and chevron color
  fontColor := clNone;
  case FButtonState of
    bsIdle:
      fontColor := FAppearance.Element.IdleCaptionColor;
    bsBtnHottrack,
    bsDropdownHottrack:
      fontColor := FAppearance.Element.HotTrackCaptionColor;
    bsBtnPressed,
    bsDropdownPressed:
      fontColor := FAppearance.ELement.ActiveCaptionColor;
  end;
  if not FEnabled then
    fontColor := LazRibbonDisabledTextColor(fontColor, FAppearance.Pane.GradientToColor);

  // Text
  if FShowCaption and (FCaption <> '') then
  begin
    ABuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
    ABuffer.Canvas.Font.Color := fontColor;

    if isRTL then
      x := FButtonRect.Right - ABuffer.Canvas.TextWidth(FCaption)
    else
      x := FButtonRect.Left;
    if (FGroupBehaviour in [gbContinuesGroup, gbEndsGroup]) then
      inc(x, sgn * SmallButtonHalfBorderWidth)
    else
      inc(x, sgn * SmallButtonBorderWidth);

    if FImageIndex <> -1 then
      inc(x, sgn * (2 * SmallButtonPadding + SmallButtonGlyphWidth))
    else
      inc(x, sgn * SmallButtonPadding);
    y := FButtonRect.Top + (FButtonRect.Height - ABuffer.Canvas.TextHeight('Wy')) div 2;

    TGUITools.DrawText(ABuffer.Canvas, x + pressedOffset, y + pressedOffset, FCaption, fontColor, ClipRect);
  end;

  // Dropdown button
  if FButtonKind = bkButtonDropdown then
  begin
    drawBtn := true;
    if (FButtonState = bsIdle) and (not FHideFrameWhenIdle) then
    begin
      FAppearance.Element.GetIdleButtonColors(Checked,
        fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, gradientkind
      );
    end else
    if (FButtonState in [bsBtnHottrack, bsBtnPressed]) then
    begin
      FAppearance.Element.GetHotTrackButtonColors(Checked,
        fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, gradientKind,
        delta
      );
    end else
    if (FButtonState = bsDropdownHottrack) then
    begin
      FAppearance.Element.GetHotTrackButtonColors(Checked,
        fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, gradientkind
      );
    end else
    if (FButtonState = bsDropdownPressed) then
    begin
      FAppearance.Element.GetActiveButtonColors(Checked,
        fontColor, frameColor, innerLightColor, innerDarkColor,
        gradientFromColor, gradientToColor, gradientKind
      );
    end else
      drawBtn := false;

    // Dropdown button
    if drawBtn then begin
      if not FEnabled then
        LazRibbonApplyDisabledButtonColors(fontColor, frameColor, innerLightColor, innerDarkColor,
          gradientFromColor, gradientToColor, FAppearance.Pane.GradientToColor);
      if isRTL then
      begin
        leftEdgeOpen := (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]);
        rightEdgeOpen := true;
      end else
      begin
        leftEdgeOpen := true;
        rightEdgeOpen := (FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup]);
      end;
      TButtonTools.DrawButton(
        ABuffer,
        FDropdownRect,
        frameColor,
        innerLightColor,
        innerDarkColor,
        gradientFromColor,
        gradientToColor,
        gradientKind,
        leftEdgeOpen,
        rightEdgeOpen,
        false,
        false,
        cornerRadius,
        ClipRect
      );
    end;
  end;

  // Dropdown arrow
  if FButtonKind in [bkDropdown, bkButtonDropdown] then begin
    dx := SmallButtonDropdownWidth;
    if FGroupBehaviour in [gbBeginsGroup, gbContinuesGroup] then
      inc(dx, SmallButtonHalfBorderWidth)
    else
      inc(dx, SmallButtonBorderWidth);
    if FButtonKind = bkDropdown then
    begin
      if isRTL then
        R := Classes.Rect(FButtonRect.Left+1, FButtonRect.Top, FButtonRect.Left+dx+1, FButtonRect.Bottom)
      else
        R := Classes.Rect(FButtonRect.Right-dx, FButtonRect.Top, FButtonRect.Right, FButtonRect.Bottom);
    end else
    begin
      if isRTL then
        R := Classes.Rect(FDropDownRect.Left+1, FDropDownRect.Top, FDropDownRect.Left+dx+1, FDropDownRect.Bottom)
      else
        R := Classes.Rect(FDropdownRect.Right-dx, FDropdownRect.Top, FDropdownRect.Right, FDropdownRect.Bottom);
    end;
    Types.OffsetRect(R, pressedOffset, pressedOffset);
    DrawDropdownArrow(ABuffer, R, fontcolor);
  end;
end;

function TLazRibbonSmallButton.GetDropdownPoint: T2DIntPoint;
begin
 {$IFDEF EnhancedRecordSupport}
  if FButtonKind in [bkButtonDropdown, bkDropdown] then
    Result := T2DIntPoint.Create(FButtonRect.Left, FButtonRect.Bottom+1)
  else
    Result := T2DIntPoint.Create(0,0);
 {$ELSE}
  if FButtonKind in [bkButtonDropdown, bkDropdown] then
    Result.Create(FButtonRect.Left, FButtonRect.Bottom+1)
  else
    Result.Create(0,0);
 {$ENDIF}
end;

function TLazRibbonSmallButton.GetGroupBehaviour: TLazRibbonItemGroupBehaviour;
begin
  Result := FGroupBehaviour;
end;

function TLazRibbonSmallButton.GetWidth: integer;
var
  BtnRect, DropRect: T2DIntRect;
begin
  Result := -1;

  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;

  if FButtonKind = bkSeparator then
  begin
    Result := SmallButtonSeparatorWidth;
    exit
  end;

  ConstructRects(BtnRect, DropRect);

  if FButtonKind = bkButtonDropdown then
  begin
    if IsRightToLeft then
      Result := BtnRect.Right + 1
    else
      Result := DropRect.Right + 1;
  end else
    Result := BtnRect.Right + 1;
end;

procedure TLazRibbonSmallButton.SetGroupBehaviour(const Value: TLazRibbonItemGroupBehaviour);
begin
  FGroupBehaviour := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonSmallButton.SetHideFrameWhenIdle(const Value: boolean);
begin
  FHideFrameWhenIdle := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonSmallButton.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonSmallButton.SetShowCaption(const Value: boolean);
begin
  FShowCaption := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyMetricsChanged;
end;



{ TLazRibbonSeparator }

constructor TLazRibbonSeparator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ButtonKind := bkSeparator;
end;

function TLazRibbonSeparator.GetDefaultCaption: String;
begin
  Result := 'Separator';
end;



end.
