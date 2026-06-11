unit LazRibbon_Groups;

{$mode delphi}
{.$Define EnhancedRecordSupport}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Groups.pas                                                  *
*  Description: The component of the toolbar panel                             *
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*******************************************************************************)

interface

uses
  Graphics, Controls, Classes, SysUtils, Math, Dialogs, Types,
  LazRibbon_GraphTools, LazRibbon_GUITools, LazRibbon_Math,
  LazRibbon_Appearance, LazRibbon_Const, LazRibbon_Dispatch, LazRibbon_Exceptions,
  LazRibbon_BaseItem, LazRibbon_Items, LazRibbon_Types, LazRibbon_Tools;

type
  TLazRibbonPaneState = (psIdle, psHover);

  TLazRibbonMousePaneElementType = (peNone, pePaneArea, peItem);

  TLazRibbonMousePaneElement = record
    ElementType: TLazRibbonMousePaneElementType;
    ElementIndex: integer;
  end;

  T2DIntRectArray = array of T2DIntRect;

  TLazRibbonPaneItemsLayout = record
    Rects: T2DIntRectArray;
    Width: integer;
  end;

  // Dialog Launcher button states
  TLazRibbonDialogLauncherState = (dlsIdle, dlsHotTrack, dlsPressed);
  TLazRibbonDialogLauncherStyle = (dlsArrow, dlsPlus);

  TLazRibbonPane = class;

  TLazRibbonPane = class(TLazRibbonComponent)
  private
    FPaneState: TLazRibbonPaneState;
    FMouseHoverElement: TLazRibbonMousePaneElement;
    FMouseActiveElement: TLazRibbonMousePaneElement;
    // Dialog Launcher button
    FDialogLauncherState: TLazRibbonDialogLauncherState;
    FDialogLauncherStyle: TLazRibbonDialogLauncherStyle;
    FInDialogLauncher: boolean;
    FOnDialogLauncherClick: TNotifyEvent;
  protected
    FCaption: string;
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
    FItems: TLazRibbonItems;
    FDialogLauncherRect: T2DIntRect;
    FShowDialogLauncher: boolean;

    // *** Generating a layout of elements ***
    function GenerateLayout: TLazRibbonPaneItemsLayout;
    function IsRightToLeft: Boolean;

    // *** Designtime and LFM support ***
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure DefineProperties(Filer : TFiler); override;
    procedure Loaded; override;

    // *** Getters and setters ***
    procedure SetCaption(const Value: string);
    procedure SetVisible(const Value: boolean);
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);
    procedure SetRect(ARect : T2DIntRect);
    procedure SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
    procedure SetShowDialogLauncher(const Value: boolean);
    procedure SetDialogLauncherStyle(const Value: TLazRibbonDialogLauncherStyle);

  public
    // *** Constructor, destructor ***
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetRootComponent: TComponent;

    // *** Mouse support ***
    procedure MouseLeave;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    // *** Geometry and drawing ***
    function GetWidth: integer;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
    procedure DrawDialogLauncher(ABuffer: TBitmap; ClipRect: T2DIntRect);
    function FindItemAt(x, y: integer): integer;

    // *** Support for elements ***
    procedure FreeingItem(AItem: TLazRibbonBaseItem);

    // *** Dialog Launcher button ***
    procedure DoDialogLauncherClick;

    property ToolbarDispatch: TLazRibbonBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
    property Rect: T2DIntRect read FRect write SetRect;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
    property Items: TLazRibbonItems read FItems;

  published
    property Caption: string
      read FCaption write SetCaption;
    property Visible: boolean
      read FVisible write SetVisible default true;
    property DialogLauncherStyle: TLazRibbonDialogLauncherStyle
      read FDialogLauncherStyle write SetDialogLauncherStyle default dlsArrow;
    property ShowDialogLauncher: boolean
      read FShowDialogLauncher write SetShowDialogLauncher default false;
    property OnDialogLauncherClick: TNotifyEvent
      read FOnDialogLauncherClick write FOnDialogLauncherClick;
  end;

  TLazRibbonPanes = class(TLazRibbonCollection)
  protected
    FToolbarDispatch: TLazRibbonBaseToolbarDispatch;
    FAppearance: TLazRibbonToolbarAppearance;
    FImages: TImageList;
    FDisabledImages: TImageList;
    FLargeImages: TImageList;
    FDisabledLargeImages: TImageList;
    FImagesWidth: Integer;
    FLargeImagesWidth: Integer;

    // *** Getters and setters ***
    procedure SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
    function GetItems(AIndex: integer): TLazRibbonPane; reintroduce;
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);
    procedure SetImages(const Value: TImageList);
    procedure SetDisabledImages(const Value: TImageList);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetDisabledLargeImages(const Value: TImageList);
    procedure SetImagesWidth(const Value: Integer);
    procedure SetLargeImagesWidth(const Value: Integer);

  public
    // *** Adding and inserting elements ***
    function Add: TLazRibbonPane;
    function Insert(AIndex: integer): TLazRibbonPane;

    // *** Reaction to changes ***
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    procedure Update; override;

    property Items[index: integer]: TLazRibbonPane read GetItems; default;
    property ToolbarDispatch: TLazRibbonBaseToolbarDispatch read FToolbarDispatch write SetToolbarDispatch;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
    property Images: TImageList read FImages write SetImages;
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth;
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth;
  end;


implementation

// Husker : temp, à déplacer dans les constantes   //!!!!!!!!!
//const
//  PaneDialogLauncherWidth : integer = 15;

{ TLazRibbonPane }

constructor TLazRibbonPane.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPaneState := psIdle;
  FMouseHoverElement.ElementType := peNone;
  FMouseHoverElement.ElementIndex := -1;
  FMouseActiveElement.ElementType := peNone;
  FMouseActiveElement.ElementIndex := -1;

  FDialogLauncherState := dlsIdle;
  FDialogLauncherStyle := dlsArrow;
  FInDialogLauncher := False;

  FCaption := 'Pane';
  {$IFDEF EnhancedRecordSupport}
  FRect := T2DIntRect.Create(0,0,0,0);
  {$ELSE}
  FRect.Create(0,0,0,0);
  {$ENDIF}
  FToolbarDispatch := nil;
  FAppearance := nil;
  FImages := nil;
  FDisabledImages := nil;
  FLargeImages := nil;
  FDisabledLargeImages := nil;

  FVisible := true;

  FItems := TLazRibbonItems.Create(self);
  FItems.ToolbarDispatch := FToolbarDispatch;
  FItems.Appearance := FAppearance;
  FItems.ImagesWidth := FImagesWidth;
  FItems.LargeImagesWidth := FLargeImagesWidth;
end;

destructor TLazRibbonPane.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TLazRibbonPane.SetRect(ARect: T2DIntRect);
var
  Pt: T2DIntPoint;
  i: integer;
  x1, x2: Integer;
  Layout: TLazRibbonPaneItemsLayout;
begin
  FRect := ARect;

  // Set 'Dialog launcher' button rect
  if IsRightToLeft then
  begin
    x1 := FRect.Left + PaneBorderHalfSize + 2;
    x2 := FRect.Left + PaneBorderHalfSize + PaneDialogLauncherWidth;
  end else
  begin
    x1 := FRect.Right - PaneBorderHalfSize - PaneDialogLauncherWidth;
    x2 := FRect.Right - PaneBorderHalfSize - 2;
  end;
  {$IFDEF EnhancedRecordSupport}
  FDialogLauncherRect := T2DIntRect.Create(
  {$ELSE}
  FDialogLauncherRect := Create2DIntRect(
  {$ENDIF}
    x1,
    FRect.Bottom - PaneCaptionHeight - PaneBorderHalfSize,
    x2,
    FRect.Bottom - PaneBorderHalfSize - 2
  );

  // Obliczamy layout
  Layout := GenerateLayout;

  {$IFDEF EnhancedRecordSupport}
  Pt := T2DIntPoint.Create(
  {$ELSE}
  Pt.Create(
  {$ENDIF}
    ARect.Left + PaneBorderSize + PaneLeftPadding,
    ARect.Top + PaneBorderSize
  );

  if Length(Layout.Rects) > 0 then
  begin
    for i := 0 to High(Layout.Rects) do
      FItems[i].Rect:=Layout.Rects[i] + Pt;
  end;
end;

procedure TLazRibbonPane.SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
begin
  FToolbarDispatch := Value;
  FItems.ToolbarDispatch := FToolbarDispatch;
end;


procedure TLazRibbonPane.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Items', FItems.ReadNames, FItems.WriteNames, true);
end;

procedure TLazRibbonPane.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  BgFromColor, BgToColor, CaptionColor, CaptionFromColor, CaptionToColor: TColor;
  FontColor, BorderLightColor, BorderDarkColor, c: TColor;
  i: Integer;
  R: T2DIntRect;
  CaptionTextRect: TRect;
  CaptionTextY: Integer;
  delta: Integer;
  isRTL: Boolean;
  ts: TTextStyle;
begin
  // Under some conditions, we are not able to draw::
  // * No dispatcher
  if FToolbarDispatch = nil then
     exit;

  // * No appearance
  if FAppearance = nil then
     exit;

  isRTL := IsRightToLeft;
  ts := ABuffer.Canvas.TextStyle;
  ts.RightToLeft := IsRightToLeft;
  ABuffer.Canvas.TextStyle := ts;

  if FPaneState = psIdle then
  begin
    // psIdle
    BgFromColor := FAppearance.Pane.GradientFromColor;
    BgToColor := FAppearance.Pane.GradientToColor;
    CaptionColor := FAppearance.Pane.CaptionBgColor;
    FontColor := FAppearance.Pane.CaptionFont.Color;
    BorderLightColor := FAppearance.Pane.BorderLightColor;
    BorderDarkColor := FAppearance.Pane.BorderDarkColor;
  end else
  begin
    // psHover
    delta := FAppearance.Pane.HotTrackBrightnessChange;
    BgFromColor := TColorTools.Brighten(FAppearance.Pane.GradientFromColor, delta);
    BgToColor := TColorTools.Brighten(FAppearance.Pane.GradientToColor, delta);
    CaptionColor := TColorTools.Brighten(FAppearance.Pane.CaptionBgColor, delta);
    FontColor := TColorTools.Brighten(FAppearance.Pane.CaptionFont.Color, delta);
    BorderLightColor := TColorTools.Brighten(FAppearance.Pane.BorderLightColor, delta);
    BorderDarkColor := TColorTools.Brighten(FAppearance.Pane.BorderDarkColor, delta);
  end;

  // The background
  {$IFDEF EnhancedRecordSupport}
  R := T2DIntRect.Create(
  {$ELSE}
  R := Create2DIntRect(
  {$ENDIF}
    FRect.Left,
    FRect.Top,
    FRect.Right - PaneBorderHalfSize,
    FRect.Bottom - PaneBorderHalfSize
  );
  TGuiTools.DrawRoundRect(
    ABuffer.Canvas,
    R,
    PaneCornerRadius,
    BgFromColor,
    BgToColor,
    FAppearance.Pane.GradientType,
    ClipRect
  );

  // Items must stay below the caption band.  Some layouts can paint close to
  // the bottom rail, so render them before the caption background and text.
  for i := 0 to FItems.Count - 1 do
    if FItems[i].Visible then
      FItems[i].Draw(ABuffer, ClipRect);

  CaptionFromColor := TColorTools.Brighten(CaptionColor, 15);
  CaptionToColor := TColorTools.Darken(CaptionColor, 5);

  // Label background
  {$IFDEF EnhancedRecordSupport}
  R := T2DIntRect.Create(
  {$ELSE}
  R := Create2DIntRect(
  {$ENDIF}
    FRect.Left,
    FRect.Bottom - PaneCaptionHeight - PaneBorderHalfSize,
    FRect.Right - PaneBorderHalfSize,
    FRect.Bottom - PaneBorderHalfSize
  );
  TGuiTools.DrawRoundRect(
    ABuffer.Canvas,
    R,
    PaneCornerRadius,
    CaptionFromColor,
    CaptionToColor,
    bkVerticalGradient,
    ClipRect,
    false,
    false,
    true,
    true
  );

  // Pane label
  ABuffer.Canvas.Font.Assign(FAppearance.Pane.CaptionFont);
  CaptionTextRect := Types.Rect(
    FRect.Left + PaneBorderSize + PaneCaptionHMargin,
    FRect.Bottom - PaneCaptionHeight - PaneBorderHalfSize,
    FRect.Right - PaneBorderHalfSize - PaneCaptionHMargin,
    FRect.Bottom - PaneBorderHalfSize
  );
  if FShowDialogLauncher then
  begin
    if isRTL then
      Inc(CaptionTextRect.Left, PaneDialogLauncherWidth)
    else
      Dec(CaptionTextRect.Right, PaneDialogLauncherWidth);
  end;
  if CaptionTextRect.Right < CaptionTextRect.Left then
    CaptionTextRect.Right := CaptionTextRect.Left;

  ABuffer.Canvas.Brush.Style := bsClear;
  ABuffer.Canvas.Font.Color := FontColor;
  CaptionTextY := CaptionTextRect.Top +
    Max(0, (CaptionTextRect.Bottom - CaptionTextRect.Top -
      ABuffer.Canvas.TextHeight('Wy')) div 2);
  TGUITools.DrawFitWText(ABuffer.Canvas, CaptionTextRect.Left,
    CaptionTextRect.Right, CaptionTextY, FCaption, FontColor, taCenter);

  // Draw the 'Dialog launcher' button
  DrawDialogLauncher(ABuffer, ClipRect);

  // Frames
  case FAppearance.Pane.Style of
    psRectangleFlat:
      begin
        {$IFDEF EnhancedRecordSupport}
        R := T2DIntRect.Create(
        {$ELSE}
        R := Create2DIntRect(
        {$ENDIF}
          FRect.Left,
          FRect.Top,
          FRect.Right,
          FRect.bottom
        );
        TGUITools.DrawAARoundFrame(
          ABuffer,
          R,
          PaneCornerRadius,
          BorderDarkColor,
          ClipRect
        );
     end;

   psRectangleEtched, psRectangleRaised:
     begin
       {$IFDEF EnhancedRecordSupport}
       R := T2DIntRect.Create(
       {$ELSE}
       R := Create2DIntRect(
       {$ENDIF}
         FRect.Left + 1,
         FRect.Top + 1,
         FRect.Right,
         FRect.bottom
       );
       if FAppearance.Pane.Style = psRectangleEtched then
         c := BorderLightColor else
         c := BorderDarkColor;
       TGUITools.DrawAARoundFrame(
         ABuffer,
         R,
         PaneCornerRadius,
         c,
         ClipRect
       );

       {$IFDEF EnhancedRecordSupport}
       R := T2DIntRect.Create(
       {$ELSE}
       R := Create2DIntRect(
       {$ENDIF}
         FRect.Left,
         FRect.Top,
         FRect.Right-1,
         FRect.Bottom-1
       );
       if FAppearance.Pane.Style = psRectangleEtched then
         c := BorderDarkColor
       else
         c := BorderLightColor;
       TGUITools.DrawAARoundFrame(
         ABuffer,
         R,
         PaneCornerRadius,
         c,
         ClipRect
       );
     end;

   psDividerRaised, psDividerEtched:
     begin
       if FAppearance.Pane.Style = psDividerRaised then
         c := BorderLightColor else
         c := BorderDarkColor;
       TGUITools.DrawVLine(
         ABuffer,
         FRect.Right + PaneBorderHalfSize - 1,
         FRect.Top,
         FRect.Bottom,
         c
       );
       if FAppearance.Pane.Style = psDividerRaised then
         c := BorderDarkColor
       else
         c := BorderLightColor;
       TGUITools.DrawVLine(
         ABuffer,
         FRect.Right + PaneBorderHalfSize,
         FRect.Top,
         FRect.Bottom,
         c
       );
     end;

   psDividerFlat:
     TGUITools.DrawVLine(
       ABuffer,
       FRect.Right + PaneBorderHalfSize,
       FRect.Top,
       FRect.Bottom,
       BorderDarkColor
     );
  end;
end;

{ Drawing procedure for the 'Dialog launcher' button }
procedure TLazRibbonPane.DrawDialogLauncher(ABuffer: TBitmap; ClipRect: T2DIntRect);
var
  LauncherFontColor, LauncherFrameColor: TColor;
  LauncherGradientFromColor, LauncherGradientToColor: TColor;
  LauncherInnerLightColor, LauncherInnerDarkColor: TColor;
  LauncherGradientKind: TBackgroundKind;
  LauncherX1, LauncherY1, LauncherX2, LauncherY2: Integer;
  LauncherCenterX, LauncherCenterY: Integer;
begin
  // Under some conditions, we are not able to draw
  // * No dispatcher
  if FToolbarDispatch = nil then
     exit;

  // * No appearance
  if FAppearance = nil then
     exit;

  // Draw the 'Dialog launcher' button in the right corner of the Pane label background
  if FShowDialogLauncher then
  begin
    // Get colors for drawing
    if (FDialogLauncherState = dlsIdle) then
    begin
      FAppearance.Element.GetIdleButtonColors(False,
        LauncherFontColor, LauncherFrameColor, LauncherInnerLightColor,
        LauncherInnerDarkColor, LauncherGradientFromColor, LauncherGradientToColor,
        LauncherGradientKind
      );
    end else
    if FDialogLauncherState = dlsHotTrack then
    begin
      FAppearance.Element.GetHotTrackButtonColors(False,
        LauncherFontColor, LauncherFrameColor, LauncherInnerLightColor,
        LauncherInnerDarkColor, LauncherGradientFromColor, LauncherGradientToColor,
        LauncherGradientKind
      );
    end else
    if FDialogLauncherState = dlsPressed then
    begin
      FAppearance.Element.GetActiveButtonColors(False,
        LauncherFontColor, LauncherFrameColor, LauncherInnerLightColor,
        LauncherInnerDarkColor, LauncherGradientFromColor, LauncherGradientToColor,
        LauncherGradientKind
      );
    end;

    // Draw the 'dialog launcher' button border
    TButtonTools.DrawButton(
      ABuffer,
      FDialogLauncherRect,
      LauncherFrameColor,
      LauncherInnerLightColor,
      LauncherInnerDarkColor,
      LauncherGradientFromColor,
      LauncherGradientToColor,
      LauncherGradientKind,
      false,
      false,
      false,
      false,
      1,
      ClipRect
    );

    // Draw the launcher glyph in the button.  The previous implementation used
    // font-specific private-use glyphs, which could render blank depending on
    // the active widgetset/font.  Canvas lines keep the Office-style launcher
    // visible everywhere.
    ABuffer.Canvas.Pen.Color := LauncherFontColor;
    ABuffer.Canvas.Pen.Style := psSolid;
    ABuffer.Canvas.Pen.Width := 1;
    case FDialogLauncherStyle of
      dlsArrow:
        begin
          LauncherX1 := FDialogLauncherRect.Left + 4;
          LauncherY1 := FDialogLauncherRect.Top + 4;
          LauncherX2 := FDialogLauncherRect.Right - 5;
          LauncherY2 := FDialogLauncherRect.Bottom - 5;
          ABuffer.Canvas.MoveTo(LauncherX1, LauncherY1);
          ABuffer.Canvas.LineTo(LauncherX2, LauncherY2);
          ABuffer.Canvas.MoveTo(LauncherX2 - 4, LauncherY2);
          ABuffer.Canvas.LineTo(LauncherX2, LauncherY2);
          ABuffer.Canvas.LineTo(LauncherX2, LauncherY2 - 4);
        end;
      dlsPlus:
        begin
          LauncherCenterX := FDialogLauncherRect.Left + FDialogLauncherRect.Width div 2;
          LauncherCenterY := FDialogLauncherRect.Top + FDialogLauncherRect.Height div 2;
          ABuffer.Canvas.MoveTo(LauncherCenterX - 3, LauncherCenterY);
          ABuffer.Canvas.LineTo(LauncherCenterX + 4, LauncherCenterY);
          ABuffer.Canvas.MoveTo(LauncherCenterX, LauncherCenterY - 3);
          ABuffer.Canvas.LineTo(LauncherCenterX, LauncherCenterY + 4);
        end;
    end;
  end;
end;

function TLazRibbonPane.FindItemAt(x, y: integer): integer;
var
  i: integer;
begin
  result := -1;
  i := FItems.count-1;
  while (i >= 0) and (result = -1) do
  begin
    if FItems[i].Visible then
    begin
      {$IFDEF EnhancedRecordSupport}
      if FItems[i].Rect.Contains(T2DIntVector.create(x,y)) then
      {$ELSE}
      if FItems[i].Rect.Contains(x,y) then
      {$ENDIF}
        Result := i;
    end;
    dec(i);
  end;
end;

procedure TLazRibbonPane.FreeingItem(AItem: TLazRibbonBaseItem);
begin
  FItems.RemoveReference(AItem);
end;

// Support for 'Dialog launcher' button click
procedure TLazRibbonPane.DoDialogLauncherClick;
begin
  if Assigned(FOnDialogLauncherClick) then
    FOnDialogLauncherClick(self);
end;

function TLazRibbonPane.GenerateLayout: TLazRibbonPaneItemsLayout;
type
  TLayoutRow = array of integer;
  TLayoutColumn = array of TLayoutRow;
  TLayout = array of TLayoutColumn;
var
  Layout: TLayout = nil;
  CurrentColumn: integer;
  CurrentRow: integer;
  CurrentItem: integer;
  c, r, i: Integer;
  ItemTableBehaviour: TLazRibbonItemTableBehaviour;
  ItemGroupBehaviour: TLazRibbonItemGroupBehaviour;
  ItemSize: TLazRibbonItemSize;
  ForceNewColumn: boolean;
  LastX: integer;
  EndRowX: integer;
  ColumnX: integer;
  rows: Integer;
  sgn: Integer;
  ItemWidth: Integer;
  tmpRect: T2DIntRect;
  isRTL: Boolean;
begin
  Result.Rects := Default(T2DIntRectArray);

  SetLength(Result.Rects, FItems.count);
  Result.Width := 0;

  if FItems.Count = 0 then
    exit;

  isRTL := IsRightToLeft;
  sgn := IfThen(isRTL, -1, +1);

  // Note: the algorithm is structured in such a way that three of them,
  // CurrentColumn, CurrentRow and CurrentItem, point to an element that
  // is not yet present (just after the recently added element).

  SetLength(Layout, 1);
  CurrentColumn := 0;

  SetLength(Layout[CurrentColumn], 1);
  CurrentRow := 0;

  SetLength(Layout[CurrentColumn][CurrentRow], 0);
  CurrentItem := 0;

  ForceNewColumn := false;

  for i := 0 to FItems.Count - 1 do
  begin
    ItemTableBehaviour := FItems[i].GetTableBehaviour;
    ItemSize := FItems[i].GetSize;

    // Starting a new column?
    if (i=0) or
       (ItemSize = isLarge) or
       (ItemTableBehaviour = tbBeginsColumn) or
       ((ItemTableBehaviour = tbBeginsRow) and (CurrentRow = 2)) or
       (ForceNewColumn) then
    begin
      // If we are already at the beginning of the new column, there is nothing to do.
      if (CurrentRow <> 0) or (CurrentItem <> 0) then
      begin
        SetLength(Layout, Length(Layout)+1);
        CurrentColumn := High(Layout);

        SetLength(Layout[CurrentColumn], 1);
        CurrentRow := 0;

        SetLength(Layout[CurrentColumn][CurrentRow], 0);
        CurrentItem := 0;
      end;
    end else
    // Starting a new row?
    if (ItemTableBehaviour = tbBeginsRow) then
    begin
      // If we are already at the beginning of a new poem, there is nothing to do.
      if CurrentItem <> 0 then
      begin
        SetLength(Layout[CurrentColumn], Length(Layout[CurrentColumn])+1);
        inc(CurrentRow);
        CurrentItem := 0;
      end;
    end;

    ForceNewColumn := (ItemSize = isLarge);

    // If the item is visible, we add it in the current column and the current row.
    if FItems[i].Visible then
    begin
      SetLength(Layout[CurrentColumn][CurrentRow], Length(Layout[CurrentColumn][CurrentRow])+1);
      Layout[CurrentColumn][CurrentRow][CurrentItem] := i;

      inc(CurrentItem);
    end;
  end;

  // We have a ready layout here. Now you have to calculate the positions
  // and sizes of the Rects.

  // First, fill them with empty data that will fill the place of invisible elements.
  {$IFDEF EnhancedRecordSupport}
  for i := 0 to FItems.Count - 1 do
    Result.Rects[i] := T2DIntRect.Create(-1, -1, -1, -1);
  {$ELSE}
  for i := 0 to FItems.Count - 1 do
    Result.Rects[i].Create(-1, -1, -1, -1);
  {$ENDIF}

  EndRowX := 0;

  // Now, we iterate through the layout, fixing the recit.
  for c := 0 to High(Layout) do
  begin
    if c>0 then
    begin
      LastX := EndRowX + sgn * PaneColumnSpacer;
      EndRowX := LastX;
    end
    else
    begin
      LastX := EndRowX;
    end;

    ColumnX := LastX;

    rows := Length(Layout[c]);
    for r := 0 to rows - 1 do
    begin
      LastX := ColumnX;

      for i := 0 to High(Layout[c][r]) do
      begin
        ItemGroupBehaviour := FItems[Layout[c][r][i]].GetGroupBehaviour;
        ItemSize := FItems[Layout[c][r][i]].GetSize;
        ItemWidth := FItems[Layout[c][r][i]].GetWidth;

        if ItemSize = isLarge then
        begin
          tmpRect.Top := PaneFullRowTopPadding;
          tmpRect.Bottom := tmpRect.Top + PaneFullRowHeight - 1;
          if isRTL then
          begin
            tmpRect.Right := LastX;
            tmpRect.Left := LastX - ItemWidth + 1;
            LastX := tmpRect.Left - 1;
            if lastX < EndRowX then
              EndRowX := LastX;
          end else
          begin
            tmpRect.Left := LastX;
            tmpRect.Right := LastX + ItemWidth - 1;
            LastX := tmpRect.Right + 1;
            if LastX > EndRowX then
              EndRowX := LastX;
          end;
        end
        else
        begin
          if ItemGroupBehaviour in [gbContinuesGroup, gbEndsGroup] then
          begin
            if isRTL then
            begin
              tmpRect.Right := LastX;
              tmpRect.Left := tmpRect.Right - ItemWidth + 1;
            end else
            begin
              tmpRect.Left := LastX;
              tmpRect.Right := tmpRect.Left + ItemWidth - 1;
            end;
          end
          else
          begin
            // If the element is not the first one, it must be offset by
            // the margin from the previous one
            if isRTL then
            begin
              if i > 0 then
                tmpRect.Right := LastX - PaneGroupSpacer
              else
                tmpRect.Right := LastX;
              tmpRect.Left := tmpRect.Right - ItemWidth + 1;
            end else
            begin
              if i>0 then
                tmpRect.Left := LastX + PaneGroupSpacer
              else
                tmpRect.Left := LastX;
              tmpRect.Right := tmpRect.Left + ItemWidth - 1;
            end;
          end;

          {$REGION 'Calculation of tmpRect.top and bottom'}
          case rows of
            1 : begin
                  tmpRect.Top := PaneOneRowTopPadding;
                  tmpRect.Bottom := tmpRect.Top + PaneRowHeight - 1;
                end;
            2 : case r of
                  0 : begin
                        tmpRect.Top := PaneTwoRowsTopPadding;
                        tmpRect.Bottom := tmpRect.top + PaneRowHeight - 1;
                      end;
                  1 : begin
                        tmpRect.Top := PaneTwoRowsTopPadding + PaneRowHeight + PaneTwoRowsVSpacer;
                        tmpRect.Bottom := tmpRect.top + PaneRowHeight - 1;
                      end;
                end;
            3 : case r of
                  0 : begin
                        tmpRect.Top := PaneThreeRowsTopPadding;
                        tmpRect.Bottom := tmpRect.Top + PaneRowHeight - 1;
                      end;
                  1 : begin
                        tmpRect.Top := PaneThreeRowsTopPadding + PaneRowHeight + PaneThreeRowsVSpacer;
                        tmpRect.Bottom := tmpRect.Top + PaneRowHeight - 1;
                      end;
                  2 : begin
                        tmpRect.Top := PaneThreeRowsTopPadding + 2 * PaneRowHeight + 2 * PaneThreeRowsVSpacer;
                        tmpRect.Bottom := tmpRect.Top + PaneRowHeight - 1;
                      end;
                end;
          end;
          {$ENDREGION}

          if isRTL then
          begin
            LastX := tmpRect.Left - 1;
            if LastX < EndRowX then
              EndRowX := LastX;
          end else
          begin
            LastX := tmpRect.right + 1;
            if LastX > EndRowX then
              EndRowX := LastX;
          end;
        end;

        Result.Rects[Layout[c][r][i]] := tmpRect;
      end;
    end;
  end;

  // At this point, EndRowX points to the first pixel behind the most
  // right-hand element - ergo is equal to the width of the entire layout.
  // (In case of Right-to-left EndRowX points to the first pixel BEFORE the
  // most left-hand element)
  Result.Width := abs(EndRowX);

  // In case of RTL we must move the rects to the right of the pane;
  // they have negative x coordinates so far.
  if isRTL then
    for c := 0 to High(Layout) do
      for r := 0 to High(Layout[c]) do
        for i := 0 to High(Layout[c, r]) do
          Result.Rects[Layout[c,r,i]].Move(Result.Width, 0);
end;

procedure TLazRibbonPane.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FItems.Count - 1 do
    Proc(FItems.Items[i]);
end;

function TLazRibbonPane.GetRootComponent: TComponent;
var
  tab: TLazRibbonBaseItem;
begin
  Result := nil;
  if Collection <> nil then
    tab := TLazRibbonBaseItem(Collection.RootComponent)
  else
    exit;
  if (tab <> nil) and (tab.Collection <> nil) then
    Result := tab.Collection.RootComponent;
end;

function TLazRibbonPane.GetWidth: integer;
var
  tmpBitmap: TBitmap;
  PaneCaptionWidth, PaneElementsWidth: integer;
  TextW: integer;
  ElementsW: integer;
  Layout: TLazRibbonPaneItemsLayout;
begin
  // Preparing...
  Result := -1;
  if FToolbarDispatch = nil then
    exit;
  if FAppearance = nil then
    exit;

  tmpBitmap := FToolbarDispatch.GetTempBitmap;
  if tmpBitmap = nil then
    exit;
  tmpBitmap.Canvas.Font.Assign(FAppearance.Pane.CaptionFont);

  // *** The minimum width of the sheet (text) ***
  TextW := tmpBitmap.Canvas.TextWidth(FCaption);

  // Widen width to include 'Dialog launcher' button if necessary
  if FShowDialogLauncher then
    PaneCaptionWidth := 2*PaneBorderSize + 2*PaneCaptionHMargin + TextW + PaneDialogLauncherWidth
  else
    PaneCaptionWidth := 2*PaneBorderSize + 2*PaneCaptionHMargin + TextW;

  // *** The width of the elements of the sheet ***
  Layout := GenerateLayout;
  ElementsW := Layout.Width;
  PaneElementsWidth := PaneBorderSize + PaneLeftPadding + ElementsW + PaneRightPadding + PaneBorderSize;

  // *** Setting the width of the pane ***
  Result := Max(PaneCaptionWidth, PaneElementsWidth);
end;

function TLazRibbonPane.IsRightToLeft: Boolean;
begin
  Result := (GetRootComponent as TControl).IsRightToLeft;
end;

procedure TLazRibbonPane.Loaded;
begin
  inherited;
  if FItems.ListState = lsNeedsProcessing then
     FItems.ProcessNames(self.Owner);
end;

procedure TLazRibbonPane.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  // Handle mouse down on 'Dialog launcher' button
  if FInDialogLauncher and FShowDialogLauncher then
  begin
    FDialogLauncherState := dlsPressed;
    // Draw the 'Dialog launcher' button
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
    // Fire OnDialogLauncherClick event
    DoDialogLauncherClick;
    // Set the button drawing to idle
    FDialogLauncherState := dlsIdle;
    // Draw the 'Dialog launcher' button
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;

  if FMouseActiveElement.ElementType = peItem then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FItems[FMouseActiveElement.ElementIndex].MouseDown(Button, Shift, X, Y);
  end else
  if FMouseActiveElement.ElementType = pePaneArea then
  begin
    FPaneState := psHover;
  end else
  if FMouseActiveElement.ElementType = peNone then
  begin
    if FMouseHoverElement.ElementType = peItem then
    begin
      if FMouseHoverElement.ElementIndex <> -1 then
      begin
        FMouseActiveElement.ElementType := peItem;
        FMouseActiveElement.ElementIndex := FMouseHoverElement.ElementIndex;
        FItems[FMouseHoverElement.ElementIndex].MouseDown(Button, Shift, X, Y);
      end
      else
      begin
        FMouseActiveElement.ElementType := pePaneArea;
        FMouseActiveElement.ElementIndex := -1;
      end;
    end else
    if FMouseHoverElement.ElementType = pePaneArea then
    begin
      FMouseActiveElement.ElementType := pePaneArea;
      FMouseActiveElement.ElementIndex := -1;
      // Placeholder, if there is a need to handle this event.
    end;
  end;
end;

procedure TLazRibbonPane.MouseLeave;
begin
  if FMouseActiveElement.ElementType = peNone then
  begin
    if FMouseHoverElement.ElementType = peItem then
    begin
      if FMouseHoverElement.ElementIndex <> -1 then
        FItems[FMouseHoverElement.ElementIndex].MouseLeave;
    end else
    if FMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event.
    end;
  end;

  FMouseHoverElement.ElementType := peNone;
  FMouseHoverElement.ElementIndex := -1;

  // Regardless of which item was active / under the mouse, you need to
  // expire HotTrack.
  if FPaneState <> psIdle then
  begin
    FPaneState := psIdle;
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;
end;

procedure TLazRibbonPane.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  NewMouseHoverElement: TLazRibbonMousePaneElement;
begin
  // MouseMove is only called when the tile is active, or when the mouse moves
  // inside its area. Therefore, it is always necessary to ignite HotTrack
  // in this situation.

  if FPaneState = psIdle then
  begin
    FPaneState := psHover;
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;

  // Test if mouse on 'Dialog launcher' button
  if FShowDialogLauncher and FDialogLauncherRect.Contains(X, Y) then
  begin
    FInDialogLauncher := True;
    FDialogLauncherState := dlsHotTrack;
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end else
  begin
    FInDialogLauncher := False;
    FDialogLauncherState := dlsIdle;
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;

  // We're looking for an object under the mouse
  i := FindItemAt(X, Y);
  if i <> -1 then
  begin
    NewMouseHoverElement.ElementType := peItem;
    NewMouseHoverElement.ElementIndex := i;
  end else
  if (X >= FRect.Left) and (Y >= FRect.Top) and
     (X <= FRect.Right) and (Y <= FRect.Bottom) then
  begin
    NewMouseHoverElement.ElementType := pePaneArea;
    NewMouseHoverElement.ElementIndex := -1;
  end else
  begin
    NewMouseHoverElement.ElementType := peNone;
    NewMouseHoverElement.ElementIndex := -1;
  end;

  if FMouseActiveElement.ElementType = peItem then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FItems[FMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
  end else
  if FMouseActiveElement.ElementType = pePaneArea then
  begin
    // Placeholder, if there is a need to handle this event
  end else
  if FMouseActiveElement.ElementType = peNone then
  begin
    // If the item under the mouse changes, we inform the previous element
    // that the mouse leaves its area
    if (NewMouseHoverElement.ElementType <> FMouseHoverElement.ELementType) or
       (NewMouseHoverElement.ElementIndex <> FMouseHoverElement.ElementIndex) then
    begin
      if FMouseHoverElement.ElementType = peItem then
      begin
        if FMouseHoverElement.ElementIndex <> -1 then
          FItems[FMouseHoverElement.ElementIndex].MouseLeave;
      end else
      if FMouseHoverElement.ElementType = pePaneArea then
      begin
        // Placeholder, if there is a need to handle this event
      end;
    end;

    if NewMouseHoverElement.ElementType = peItem then
    begin
      if NewMouseHoverElement.ElementIndex <> -1 then
        FItems[NewMouseHoverElement.ElementIndex].MouseMove(Shift, X, Y);
    end else
    if NewMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;
  end;

  FMouseHoverElement := NewMouseHoverElement;
end;

procedure TLazRibbonPane.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  ClearActive: boolean;
begin
  ClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  // Handle mouse up on 'Dialog launcher' button
  if FInDialogLauncher then
  begin
    FDialogLauncherState := dlsHotTrack;
    // Draw the 'Dialog launcher' button
    if Assigned(FToolbarDispatch) then
      FToolbarDispatch.NotifyVisualsChanged;
  end;

  if FMouseActiveElement.ElementType = peItem then
  begin
    if FMouseActiveElement.ElementIndex <> -1 then
      FItems[FMouseActiveElement.ElementIndex].MouseUp(Button, Shift, X, Y);
  end else
  if FMouseActiveElement.ElementType = pePaneArea then
  begin
    // Placeholder, if there is a need to handle this event
  end;

  if ClearActive and
    (FMouseActiveElement.ElementType <> FMouseHoverElement.ElementType) or
    (FMouseActiveElement.ElementIndex <> FMouseHoverElement.ElementIndex) then
  begin
    if FMouseActiveElement.ElementType = peItem then
    begin
      if FMouseActiveElement.ElementIndex <> -1 then
        FItems[FMouseActiveElement.ElementIndex].MouseLeave;
    end else
    if FMouseActiveElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end;

    if FMouseHoverElement.ElementType = peItem then
    begin
      if FMouseActiveElement.ElementIndex <> -1 then
        FItems[FMouseActiveElement.ElementIndex].MouseMove(Shift, X, Y);
    end else
    if FMouseHoverElement.ElementType = pePaneArea then
    begin
      // Placeholder, if there is a need to handle this event
    end else
    if FMouseHoverElement.ElementType = peNone then
    begin
      if FPaneState <> psIdle then
      begin
        FPaneState := psIdle;
        if Assigned(FToolbarDispatch) then
          FToolbarDispatch.NotifyVisualsChanged;
      end;
    end;
  end;

  if ClearActive then
  begin
    FMouseActiveElement.ElementType := peNone;
    FMouseActiveElement.ElementIndex := -1;
  end;
end;

procedure TLazRibbonPane.SetAppearance(const Value: TLazRibbonToolbarAppearance);
begin
  FAppearance := Value;
  FItems.Appearance := Value;
end;

procedure TLazRibbonPane.SetCaption(const Value: string);
begin
  FCaption := Value;
  if Assigned(FToolbarDispatch) then
     FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonPane.SetDisabledImages(const Value: TImageList);
begin
  FDisabledImages := Value;
  FItems.DisabledImages := FDisabledImages;
end;

procedure TLazRibbonPane.SetDisabledLargeImages(const Value: TImageList);
begin
  FDisabledLargeImages := Value;
  FItems.DisabledLargeImages := FDisabledLargeImages;
end;

procedure TLazRibbonPane.SetImages(const Value: TImageList);
begin
  FImages := Value;
  FItems.Images := FImages;
end;

procedure TLazRibbonPane.SetImagesWidth(const Value: Integer);
begin
  FImagesWidth := Value;
  FItems.ImagesWidth := FImagesWidth;
end;

procedure TLazRibbonPane.SetLargeImages(const Value: TImageList);
begin
  FLargeImages := Value;
  FItems.LargeImages := FLargeImages;
end;

procedure TLazRibbonPane.SetLargeImagesWidth(const Value: Integer);
begin
  FLargeImagesWidth := Value;
  FItems.LargeImagesWidth := FLargeImagesWidth;
end;

procedure TLazRibbonPane.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyItemsChanged;
end;

procedure TLazRibbonPane.SetShowDialogLauncher(const Value: boolean);
begin
  if FShowDialogLauncher = Value then exit;
  FShowDialogLauncher := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyItemsChanged;
end;

procedure TLazRibbonPane.SetDialogLauncherStyle(const Value: TLazRibbonDialogLauncherStyle);
begin
  if FDialogLauncherStyle = Value then exit;
  FDialogLauncherStyle := Value;
  if Assigned(FToolbarDispatch) then
    FToolbarDispatch.NotifyItemsChanged;
end;


{ TLazRibbonPanes }

function TLazRibbonPanes.Add: TLazRibbonPane;
begin
  Result := TLazRibbonPane.Create(FRootComponent);
  Result.Parent := FRootComponent;
  AddItem(Result);
end;

function TLazRibbonPanes.GetItems(AIndex: integer): TLazRibbonPane;
begin
  Result := TLazRibbonPane(inherited Items[AIndex]);
end;

function TLazRibbonPanes.Insert(AIndex: integer): TLazRibbonPane;
var
  lOwner, lParent: TComponent;
  i: Integer;
begin
  if (AIndex < 0) or (AIndex > self.Count) then
    raise InternalException.Create('TLazRibbonPanes.Insert: Invalid index!');

  if FRootComponent<>nil then
  begin
    lOwner := FRootComponent.Owner;
    lParent := FRootComponent;
  end
  else
  begin
    lOwner := nil;
    lParent := nil;
  end;

  Result := TLazRibbonPane.Create(lOwner);
  Result.Parent := lParent;

  if FRootComponent <> nil then
  begin
    i := 0;
    while FRootComponent.Owner.FindComponent('LazRibbonPane'+IntToStr(i)) <> nil do
      inc(i);
    Result.Name := 'LazRibbonPane' + IntToStr(i);
  end;
   
  InsertItem(AIndex, Result);
end;

procedure TLazRibbonPanes.Notify(Item: TComponent; Operation: TOperation);
var
  i: Integer;
  pane: TLazRibbonPane;
begin
  inherited Notify(Item, Operation);

  case Operation of
    opInsert:
      if Item is TLazRibbonPane then
      begin
        // Setting the dispatcher to nil will cause that during the
        // ownership assignment, the Notify method will not be called
        TLazRibbonPane(Item).ToolbarDispatch := nil;
        TLazRibbonPane(Item).Appearance := FAppearance;
        TLazRibbonPane(Item).Images := FImages;
        TLazRibbonPane(Item).DisabledImages := FDisabledImages;
        TLazRibbonPane(Item).LargeImages := FLargeImages;
        TLazRibbonPane(Item).DisabledLargeImages := FDisabledLargeImages;
        TLazRibbonPane(Item).ImagesWidth := FImagesWidth;
        TLazRibbonPane(Item).LargeImagesWidth := FLargeImagesWidth;
        TLazRibbonPane(Item).ToolbarDispatch := FToolbarDispatch;
      end;
    opRemove:
      if Item is TLazRibbonPane then
      begin
        if not(csDestroying in Item.ComponentState) then
        begin
          TLazRibbonPane(Item).ToolbarDispatch := nil;
          TLazRibbonPane(Item).Appearance := nil;
          TLazRibbonPane(Item).Images := nil;
          TLazRibbonPane(Item).DisabledImages := nil;
          TLazRibbonPane(Item).LargeImages := nil;
          TLazRibbonPane(Item).DisabledLargeImages := nil;
        end;
      end else
        for i := 0 to Count-1 do
        begin
          pane := Items[i];
          pane.Items.Notify(Item, Operation);
        end;
  end;
end;

procedure TLazRibbonPanes.SetImages(const Value: TImageList);
var
  I: Integer;
begin
  FImages := Value;
  for I := 0 to self.Count - 1 do
    Items[i].Images := Value;
end;

procedure TLazRibbonPanes.SetImagesWidth(const Value: Integer);
var
  I: Integer;
begin
  FImagesWidth := Value;
  for I := 0 to Count - 1 do
    Items[i].ImagesWidth := Value;
end;

procedure TLazRibbonPanes.SetLargeImages(const Value: TImageList);
var
  I: Integer;
begin
  FLargeImages := Value;
  for I := 0 to self.Count - 1 do
    Items[i].LargeImages := Value;
end;

procedure TLazRibbonPanes.SetLargeImagesWidth(const Value: Integer);
var
  I: Integer;
begin
  FLargeImagesWidth := Value;
  for I := 0 to Count - 1 do
    Items[i].LargeImagesWidth := Value;
end;

procedure TLazRibbonPanes.SetToolbarDispatch(const Value: TLazRibbonBaseToolbarDispatch);
var
  i: integer;
begin
  FToolbarDispatch := Value;
  for i := 0 to self.Count - 1 do
    Items[i].ToolbarDispatch := FToolbarDispatch;
end;

procedure TLazRibbonPanes.SetAppearance(const Value: TLazRibbonToolbarAppearance);
var
  i: Integer;
begin
  FAppearance := Value;
  for i := 0 to self.Count - 1 do
    Items[i].Appearance := FAppearance;
  if FToolbarDispatch <> nil then
     FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonPanes.SetDisabledImages(const Value: TImageList);
var
  I: Integer;
begin
  FDisabledImages := Value;
  for I := 0 to self.Count - 1 do
    Items[i].DisabledImages := Value;
end;

procedure TLazRibbonPanes.SetDisabledLargeImages(const Value: TImageList);
var
  I: Integer;
begin
  FDisabledLargeImages := Value;
  for I := 0 to self.Count - 1 do
    Items[i].DisabledLargeImages := Value;
end;

procedure TLazRibbonPanes.Update;
begin
  inherited Update;
  if Assigned(FToolbarDispatch) then
     FToolbarDispatch.NotifyItemsChanged;
end;


end.
