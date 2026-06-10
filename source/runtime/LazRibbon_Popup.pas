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
  Types, SysUtils, Classes, Controls, Graphics, Menus, StdCtrls,
  LazRibbon_Const, LazRibbon_GUITools, LazRibbon_Math, LazRibbon_Appearance;

type
  TLazRibbonPopupMenu = class(TPopupMenu)
  private
    FAppearance: TLazRibbonToolbarAppearance;
    procedure SetAppearance(AValue: TLazRibbonToolbarAppearance);
    function GetIconSize: TSize;
    function GetPPI: Integer;

  protected
    procedure DrawItemHandler(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState); virtual;
    procedure MeasureItemHandler(Sender: TObject; {%H-}ACanvas: TCanvas;
      var {%H-}AWidth, {%H-}AHeight: Integer); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    //constructor Create(AOwner: TComponent); override;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
  end;

implementation

uses
  Themes;

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
    Result.CY := Result.CY;
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

