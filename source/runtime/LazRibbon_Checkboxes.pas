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

unit LazRibbon_Checkboxes;

{$mode objfpc}{$H+}

interface

uses
  Graphics, Classes, SysUtils, Controls, StdCtrls, ActnList,
  LazRibbon_Math, LazRibbon_GUITools, LazRibbon_BaseItem, LazRibbon_Buttons;

type
  TLazRibbonCustomCheckBox = class(TLazRibbonCustomTableButton)
  private
    FState: TCheckboxState;              // unchecked, checked, grayed
    FHideFrameWhenIdle : boolean;
    FCheckboxStyle: TLazRibbonCheckboxStyle;
  protected
    procedure CalcRects; override;
    procedure ConstructRect(out BtnRect: T2DIntRect); virtual;
    function  GetChecked: Boolean; override;
    function GetDefaultCaption: String; override;
    function GetDropdownPoint: T2DIntPoint; override;
    procedure SetChecked(const AValue: Boolean); override;
    procedure SetState(AValue: TCheckboxState); virtual;
    property State: TCheckboxState read FState write SetState default cbUnchecked;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
    function GetWidth: integer; override;
  published
    property Checked;
    property TableBehaviour;
  end;

  TLazRibbonCheckbox = class(TLazRibbonCustomCheckbox)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property State;
  end;

  TLazRibbonRadioButton = class(TLazRibbonCustomCheckbox)
  protected
    function GetDefaultCaption: String; override;
    procedure SetState(AValue: TCheckboxState); override;
    procedure UncheckSiblings; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AllowAllUp;
    property GroupIndex;
    property State;
  end;

  TLazRibbonToggleSwitch = class(TLazRibbonCustomCheckbox)
  protected
    procedure ConstructRect(out BtnRect: T2DIntRect); override;
    function GetDefaultCaption: String; override;
    function MouseOnActivePart(X, Y: Integer): Boolean; override;
    procedure SetState(AValue: TCheckboxState); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
    function GetWidth: integer; override;
  published
    property AllowAllUp;
    property GroupIndex;
  end;


implementation

uses
  LCLType, LCLIntf, Math, Themes, Types,
  LazRibbon_GraphTools, LazRibbon_Const, LazRibbon_Tools, LazRibbon_Groups, LazRibbon_Appearance;


{ TLazRibbonCustomCheckbox }

constructor TLazRibbonCustomCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ButtonKind := bkToggle;
  FHideFrameWhenIdle := true;
  FCheckboxStyle := cbsCheckbox;
  FState := cbUnchecked;
end;

procedure TLazRibbonCustomCheckbox.CalcRects;
var
  RectVector: T2DIntVector;
begin
  ConstructRect(FButtonRect);
 {$IFDEF EnhancedRecordSupport}
  FDropdownRect := T2DIntRect.Create(0, 0, 0, 0);
  RectVector := T2DIntVector.Create(FRect.Left, FRect.Top);
 {$ELSE}
  FDropdownRect.Create(0, 0, 0, 0);
  RectVector.Create(FRect.Left, FRect.Top);
 {$ENDIF}
  FButtonRect := FButtonRect + RectVector;
end;

procedure TLazRibbonCustomCheckbox.ConstructRect(out BtnRect: T2DIntRect);
var
  BtnWidth: integer;
  Bitmap: TBitmap;
  TextWidth: Integer;
begin
 {$IFDEF EnhancedRecordSupport}
  BtnRect := T2DIntRect.Create(0, 0, 0, 0);
 {$ELSE}
  BtnRect.Create(0, 0, 0, 0);
 {$ENDIF}

  if not(Assigned(FToolbarDispatch)) then
    exit;
  if not(Assigned(FAppearance)) then
    exit;

  Bitmap := FToolbarDispatch.GetTempBitmap;
  if not Assigned(Bitmap) then
    exit;

  Bitmap.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
  TextWidth := Bitmap.Canvas.TextWidth(FCaption);

  BtnWidth := SmallButtonPadding + SmallButtonGlyphWidth +
    SmallButtonPadding + TextWidth + SmallButtonPadding + 2*SmallButtonBorderWidth;
  BtnWidth := Max(SmallButtonMinWidth, BtnWidth);

 {$IFDEF EnhancedRecordSupport}
  BtnRect := T2DIntRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
 {$ELSE}
  BtnRect.Create(0, 0, BtnWidth - 1, PaneRowHeight - 1);
 {$ENDIF}
end;

procedure TLazRibbonCustomCheckbox.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  fontColor: TColor;
  frameColor, innerLightColor, innerDarkColor: TColor;
  gradientFromColor, gradientToColor: TColor;
  gradientKind: TBackgroundKind;
  xGlyph, yGlyph: Integer;
  xText, yText: Integer;
  w, h: Integer;
  te: TThemedElementDetails;
  cornerRadius: Integer;
  drawBtn: Boolean;
  isRTL: Boolean;
  ts: TTextStyle;
begin
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;
  if (FRect.Width < 2*LargeButtonRadius) or (FRect.Height < 2*LargeButtonRadius) then
    exit;

  isRTL := IsRightToLeft;
  ts := ABuffer.Canvas.TextStyle;
  ts.RightToLeft := isRTL;
  ABuffer.Canvas.TextStyle := ts;

  case FAppearance.Element.Style of
    esRounded:
      cornerRadius := SmallButtonRadius;
    esRectangle:
      cornerRadius := 0;
  end;

  // Border
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
   drawBtn := false;

  if drawBtn then
    TButtonTools.DrawButton(
      ABuffer,
      FButtonRect,
      frameColor,
      innerLightColor,
      innerDarkColor,
      gradientFromColor,
      gradientToColor,
      gradientKind,
      false,  // Left edge open
      false,  // Right edge open
      false,  // Top edge open
      false,  // Bottom edge open
      cornerRadius,
      ClipRect
    );

  // Checkbox
  if ThemeServices.ThemesEnabled then
  begin
    te := ThemeServices.GetElementDetails(tbCheckboxCheckedNormal);
    h := ThemeServices.GetDetailSizeForPPI(te, ScreenInfo.PixelsPerInchX).cy;
    w := ThemeServices.GetDetailSizeForPPI(te, ScreenInfo.PixelsPerInchX).cx;
  end else
  begin
    h := GetSystemMetrics(SM_CYMENUCHECK);
    w := GetSystemMetrics(SM_CXMENUCHECK);
  end;

  if isRTL then
  begin
    xGlyph := FButtonRect.Right - SmallButtonBorderWidth - SmallButtonPadding - w;
    xText := xGlyph - SmallButtonPadding - ABuffer.Canvas.TextWidth(FCaption);
  end
  else
  begin
    xGlyph := FButtonRect.Left + SmallButtonBorderWidth + SmallButtonPadding;
    xText := xGlyph + SmallButtonGlyphWidth + SmallButtonPadding;
  end;
  yGlyph := FButtonRect.Top + (FButtonRect.Height - h) div 2;
  yText := FButtonRect.Top + (FButtonRect.Height - ABuffer.Canvas.TextHeight('Wy')) div 2;

  TGUITools.DrawCheckbox(
    ABuffer.Canvas,
    xGlyph, yGlyph,
    FState,
    FButtonState,
    FCheckboxStyle,
    ClipRect
  );

  // Text
  ABuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);

  case FButtonState of
    bsIdle:
      fontColor := FAppearance.Element.IdleCaptionColor;
    bsBtnHottrack, bsDropdownHotTrack:
      fontColor := FAppearance.Element.HotTrackCaptionColor;
    bsBtnPressed, bsDropdownPressed:
      fontColor := FAppearance.Element.ActiveCaptionColor;
  end;
  if not(FEnabled) then
    fontColor := TColorTools.ColorToGrayscale(fontColor);

  TGUITools.DrawText(ABuffer.Canvas, xText, yText, FCaption, fontColor, ClipRect);
end;

function TLazRibbonCustomCheckbox.GetChecked: Boolean;
begin
  Result := (FState = cbChecked);
end;

function TLazRibbonCustomCheckbox.GetDefaultCaption: String;
begin
  Result := 'Checkbox';
end;

function TLazRibbonCustomCheckbox.GetDropdownPoint: T2DIntPoint;
begin
 {$IFDEF EnhancedRecordSupport}
  Result := T2DIntPoint.Create(0,0);
 {$ELSE}
  Result.Create(0,0);
 {$ENDIF}
end;

function TLazRibbonCustomCheckbox.GetWidth: integer;
var
  BtnRect: T2DIntRect;
begin
  Result := -1;
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;
  ConstructRect(BtnRect);
  Result := BtnRect.Right + 1;
end;

procedure TLazRibbonCustomCheckbox.SetChecked(const AValue: Boolean);
begin
  inherited SetChecked(AValue);
  if FChecked then
    SetState(cbChecked)
  else
    SetState(cbUnchecked);
end;

procedure TLazRibbonCustomCheckbox.SetState(AValue:TCheckboxState);
begin
  if AValue <> FState then
  begin
    FState := AValue;
    inherited SetChecked(Checked);
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;
end;


{ TLazRibbonCheckbox }

constructor TLazRibbonCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCheckboxStyle := cbsCheckbox;
end;


{ TLazRibbonRadioButton }

constructor TLazRibbonRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCheckboxStyle := cbsRadioButton;
end;

function TLazRibbonRadioButton.GetDefaultCaption: string;
begin
  Result := 'RadioButton';
end;

procedure TLazRibbonRadioButton.SetState(AValue: TCheckboxState);
begin
  inherited SetState(AValue);
  if (AValue = cbChecked) then
    UncheckSiblings;
end;

procedure TLazRibbonRadioButton.UncheckSiblings;
var
  i: Integer;
  pane: TLazRibbonPane;
  rb: TLazRibbonRadioButton;
begin
  if (Parent is TLazRibbonPane) then begin
    pane := TLazRibbonPane(Parent);
    for i := 0 to pane.Items.Count-1 do
      if (pane.Items[i] is TLazRibbonRadioButton) then
      begin
        rb := TLazRibbonRadioButton(pane.Items[i]);
        if (rb <> self) and (rb.GroupIndex = GroupIndex) then begin
          rb.FChecked := false;
          rb.FState := cbUnchecked;
        end;
      end;
  end;
end;


{ TLazRibbonToggleSwitch }

constructor TLazRibbonToggleSwitch.Create(AOwner: TComponent);
begin
  inherited;
  FCheckBoxStyle := cbsToggleSwitch;
end;

procedure TLazRibbonToggleSwitch.ConstructRect(out BtnRect: T2DIntRect);
begin
 {$IFDEF EnhancedRecordSupport}
  BtnRect := T2DIntRect.Create(0, 0, ToggleSwitchWidth - 1, ToggleSwitchHeight - 1);
 {$ELSE}
  BtnRect.Create(0, 0, ToggleSwitchWidth - 1, ToggleSwitchHeight - 1);
 {$ENDIF}
end;

procedure TLazRibbonToggleSwitch.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  fontColor: TColor;
  trackColor, knobColor: TColor;
  frameColor, innerLightColor, innerDarkColor: TColor;
  gradientFromColor, gradientToColor: TColor;
  gradientKind: TBackgroundKind;
  x, y: Integer;
  txtSize: TSize;
  trackRect: TRect;
  knobRect: T2DIntRect;  // knobRect: TRect;
  knobX: Integer;
  captionX, captionY: Integer;
  trackRadius: Integer;
  knobRadius: Integer;
  px2: Integer;  // scaled 2 pixels at 96ppi
  isRTL: Boolean;
begin
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;

  if (FRect.Width < ToggleSwitchWidth) or (FRect.Height < ToggleSwitchHeight) then
    exit;

  isRTL := IsRightToLeft;
  px2 := LazScaleX(2, 96, ScreenInfo.PixelsPerInchX);

  // Calculate toggle switch position
  x := IfThen(isRTL,
    FButtonRect.Left + GetWidth - SmallButtonBorderWidth - ToggleSwitchWidth,
    FButtonRect.Left + SmallButtonBorderWidth
  );
  y := (FRect.Top + FRect.Bottom - ToggleSwitchHeight) div 2;

  // Define track rectangle (the background rail)
  trackRect := Bounds(x, y, ToggleSwitchWidth, ToggleSwitchHeight);
  case FAppearance.Element.Style of
    esRounded:
      begin
        if ToggleSwitchRadius < 0 then
        begin
          trackRadius := ToggleSwitchHeight div 2;
          knobRadius := trackRadius - 2;
        end else
        begin
          trackRadius := ToggleSwitchRadius;
          knobRadius := trackRadius;
        end;
      end;
    esRectangle:
      begin
        trackRadius := 0;
        knobRadius := 0;
      end;
  end;

  // Extract button and switch colors from the appearance
  case FButtonState of
    bsIdle:
      begin
        FAppearance.Element.GetIdleButtonColors(Checked,
          fontColor, frameColor, innerLightColor, innerDarkColor,
          gradientFromColor, gradientToColor, gradientKind
        );
        fontColor := FAppearance.Element.IdleCaptionColor;
        frameColor := FAppearance.Element.IdleFrameColor;
        FAppearance.Element.GetIdleSwitchColors(Checked,
          knobColor, trackColor
        );
      end;
    bsBtnHotTrack, bsBtnPressed:
      begin
        FAppearance.Element.GetHotTrackButtonColors(Checked,
          fontColor, frameColor, innerLightColor, innerDarkColor,
          gradientFromColor, gradientToColor, gradientKind
        );
        frameColor := FAppearance.Element.HotTrackFrameColor;
        gradientFromColor := FAppearance.Element.HotTrackGradientFromColor;
        gradientToColor := FAppearance.Element.HotTrackGradientToColor;
        innerLightColor := FAppearance.Element.HotTrackInnerLightColor;
        innerDarkColor := FAppearance.Element.HotTrackInnerDarkColor;
        FAppearance.Element.GetHotTrackSwitchColors(Checked,
          knobColor, trackColor
        );
      end;
  end;

  if not Enabled then
  begin
    fontColor := TColorTools.ColorToGrayScale(fontColor);
    frameColor := TColorTools.ColorToGrayscale(frameColor);
    innerLightColor := TColorTools.ColorToGrayscale(innerLightColor);
    innerDarkColor := TColorTools.ColorToGrayscale(innerDarkColor);
    gradientFromColor := TColorTools.ColorToGrayscale(gradientFromColor);
    gradientToColor := TColorTools.ColorToGrayscale(gradientToColor);
    trackColor := TColorTools.ColorToGrayScale(trackColor);
    knobColor := trackColor;
  end;

  // Draw track (rounded rectangle background)
  ABuffer.Canvas.Brush.Color := trackColor;
  ABuffer.Canvas.Pen.Color := frameColor;
  ABuffer.Canvas.Pen.Width := 1;
  if ToggleSwitchRadius = 0 then
    ABuffer.Canvas.Rectangle(trackRect)
  else
    // Canvas.RoundRect looks better than GUITools.DrawRoundRect...
    ABuffer.Canvas.RoundRect(trackRect, 2*trackRadius, 2*trackRadius);

  // Define knob rectangle (the sliding box/circle)
  knobX := IfThen(Checked xor isRTL, trackRect.Right - ToggleSwitchHeight, trackRect.Left);
 {$IFDEF EnhancedRecordSupport}
  knobRect := T2DIntRect.Create(knobX + px2, trackRect.Top + px2, knobX + ToggleSwitchHeight - px2 - 1, trackRect.Bottom - px2 - 1);
 {$ELSE}
  knobRect.Create(knobX + px2, trackRect.Top + px2, knobX + ToggleSwitchHeight - px2 - 1, trackRect.Bottom - px2 - 1);
 {$ENDIF}

 // Draw knob
  if FAppearance.Element.KnobAsGradient then
  begin
    // Draw the button gradient on the knob
    TButtonTools.DrawButton(
      ABuffer,
      knobRect,
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
      knobRadius,
      ClipRect
    );
  end else
  begin
    // No knob gradient - use the knobColor
    ABuffer.Canvas.Brush.Color := knobColor;
    ABuffer.Canvas.Pen.Color := TColorTools.Darken(knobColor, 50);
    ABuffer.Canvas.Pen.Width := 1;
    inc(knobRect.Right);
    inc(knobRect.Bottom);
    if ToggleSwitchRadius < 0 then
      ABuffer.Canvas.Ellipse(knobRect.ForWinAPI)
    else
    if ToggleSwitchRadius = 0 then
      ABuffer.Canvas.Rectangle(knobRect.ForWinAPI)
    else
      ABuffer.Canvas.RoundRect(knobRect.ForWinAPI, 2*knobRadius, 2*knobRadius);
  end;

  // Draw caption text to the right of the toggle
  if FCaption <> '' then
  begin
    ABuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
    ABuffer.Canvas.Font.Color := fontColor;
    ABuffer.Canvas.Brush.Style := bsClear;

    txtSize := ABuffer.Canvas.TextExtent(FCaption);
    captionX := IfThen(isRTL,
      trackRect.Left - SmallButtonPadding - txtSize.CX,
      trackRect.Right + SmallButtonPadding
    );
    captionY := FRect.Top + (FRect.Height - txtSize.CY) div 2;

    TGUITools.DrawText(ABuffer.Canvas, captionX, captionY, FCaption, fontColor, ClipRect);
  end;
end;

function TLazRibbonToggleSwitch.GetDefaultCaption: String;
begin
  Result := 'Toggle';
end;

function TLazRibbonToggleSwitch.GetWidth: integer;
var
  Bitmap: TBitmap;
  TextWidth: Integer;
  BtnWidth: Integer;
begin
  Result := -1;

  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;

  Bitmap := FToolbarDispatch.GetTempBitmap;
  if not Assigned(Bitmap) then
    exit;

  // Start with toggle switch width
  BtnWidth := ToggleSwitchWidth;

  // Add caption width if present
  if FCaption <> '' then
  begin
    Bitmap.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
    TextWidth := Bitmap.Canvas.TextWidth(FCaption);
    BtnWidth := BtnWidth + SmallButtonPadding + TextWidth;
  end;

  // Add final padding and border widths
  BtnWidth := BtnWidth + 2*SmallButtonBorderWidth;
  // Ensure minimum width
  BtnWidth := Max(SmallButtonMinWidth, BtnWidth);

  Result := BtnWidth;
end;

function TLazRibbonToggleSwitch.MouseOnActivePart(X, Y: Integer): Boolean;
var
  R: TRect;
begin
  R := Classes.Rect(FButtonRect.Left, FButtonRect.Top, FButtonRect.Right, FButtonRect.Bottom);
  if IsRightToLeft then
    R.Left := R.Right - ToggleSwitchWidth
  else
    R.Right := R.Left + ToggleSwitchWidth;
  Result := R.Contains(Point(X, Y));
end;

procedure TLazRibbonToggleSwitch.SetState(AValue: TCheckboxState);
begin
  inherited SetState(AValue);
  if (AValue = cbChecked) and (GroupIndex > 0) then
    UncheckSiblings;
end;

end.

