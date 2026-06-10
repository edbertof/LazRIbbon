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

unit LazRibbon_Form;

{$mode delphi}
{$codepage utf8}

{*******************************************************************************
*                                                                              *
*  File: LazRibbon_Form.pas                                                    *
*  Description: First Windows/desktop-oriented Ribbon form shell for LazRibbon  *
*                                                                              *
*  This is an incremental TLazRibbonForm implementation. It deliberately avoids *
*  non-client-area tricks in this first version and uses a client-area chrome   *
*  control instead. Later versions can replace or extend it with native Windows *
*  non-client drawing.                                                         *
*                                                                              *
*******************************************************************************}

interface

uses
  Classes, SysUtils, Types, Math, Graphics, Controls, Forms, ImgList, LCLIntf, LCLType, LMessages
  {$IFDEF MSWINDOWS}, Windows, ShellApi{$ENDIF},
  LazRibbon_Core, LazRibbon_SkinManager;

type
  TLazRibbonForm = class;

  TLazRibbonFormSystemButton = (rfbNone, rfbMinimize, rfbMaximize, rfbClose);

  { Internal chrome/title control used by TLazRibbonForm.  It is intentionally
    not registered on the component palette. }
  TLazRibbonTitleBar = class(TCustomControl)
  private
    FOwnerForm: TLazRibbonForm;
    FHotButton: TLazRibbonFormSystemButton;
    FDownButton: TLazRibbonFormSystemButton;
    FDragging: Boolean;
    FDragStart: TPoint;
    FFormStart: TPoint;
    FQuickAccessRects: array of TRect;
    FQuickAccessCustomizeRect: TRect;
    FQuickAccessHoverIndex: Integer;
    FQuickAccessActiveIndex: Integer;
    FCachedIcon: TIcon;
    function TryLoadIconFromProjectFile: TIcon;
    function ButtonRect(AButton: TLazRibbonFormSystemButton): TRect;
    function ButtonAt(X, Y: Integer): TLazRibbonFormSystemButton;
    function QuickAccessVisible: Boolean;
    function QuickAccessHitTest(X, Y: Integer): Integer;
    procedure BuildQuickAccessRects;
    function EffectiveFormIcon: TIcon;
    function CachedIcon: TIcon;
    procedure ClearCachedIcon;
    {$IFDEF MSWINDOWS}
    function EffectiveWindowIconHandle: HICON;
    function TryLoadIconFromExecutableResource: TIcon;
    function TryExtractIconFromExecutable: TIcon;
    {$ENDIF}
    function FormIconRect: TRect;
    function FormIconVisible: Boolean;
    procedure DrawFormIcon(ACanvas: TCanvas);
    procedure DrawQuickAccessToolBar(ACanvas: TCanvas);
    procedure DrawKeyTipsOverlay(ACanvas: TCanvas);
    procedure ClearQuickAccessState;
    procedure SafeInvalidate;
    function OwnerFormAlive: Boolean;
    function QuickAccessRightEdge: Integer;
    procedure DrawTitleBarBackground(ACanvas: TCanvas; const R: TRect);
    procedure DrawSystemButton(ACanvas: TCanvas; AButton: TLazRibbonFormSystemButton;
      const R: TRect; AHot, ADown: Boolean);
    procedure SetHotButton(AValue: TLazRibbonFormSystemButton);
    procedure SetDownButton(AValue: TLazRibbonFormSystemButton);
  protected
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TLMessage); message CM_MOUSELEAVE;
    {$IFDEF MSWINDOWS}
    procedure WMNCHitTest(var Message: TLMessage); message WM_NCHITTEST;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  { TLazRibbonForm }

  TLazRibbonForm = class(TForm)
  private
    FOriginalBorderStyle: TFormBorderStyle;
    FRibbon: TLazRibbon;
    FSkinManager: TLazRibbonSkinManager;
    FTitleBar: TLazRibbonTitleBar;
    FTitleBarHeight: Integer;
    FUseCustomTitleBar: Boolean;
    FShowSystemButtons: Boolean;
    FTitleAlignment: TAlignment;
    FShowTitleIcon: Boolean;
    FTitleIcon: TIcon;
    FClosingFromTitleBar: Boolean;
    procedure SafeInvalidateTitleBar;
    procedure RequestCloseFromTitleBar;
    procedure MinimizeFromTitleBar;
    procedure RemoveAccidentalStreamedTitleBars;
    procedure CMTextChanged(var Message: TLMessage); message CM_TEXTCHANGED;
    procedure SetRibbon(AValue: TLazRibbon);
    procedure SetSkinManager(AValue: TLazRibbonSkinManager);
    procedure SetShowSystemButtons(AValue: Boolean);
    procedure SetShowTitleIcon(AValue: Boolean);
    procedure SetTitleAlignment(AValue: TAlignment);
    procedure SetTitleBarHeight(AValue: Integer);
    procedure SetTitleIcon(AValue: TIcon);
    procedure SetUseCustomTitleBar(AValue: Boolean);
    procedure SkinManagerChanged(Sender: TObject);
    procedure UpdateChrome;
    function BackstageClientOverlayActive: Boolean;
    function BackstageClientOverlayColor: TColor;
    {$IFDEF MSWINDOWS}
    function CustomChromeHitTest(const AScreenPoint: TPoint): PtrInt;
    procedure ApplyCustomChromeWindowStyle;
    procedure WMNCHitTest(var Message: TLMessage); message WM_NCHITTEST;
    {$ENDIF}
  protected
    {$IFDEF MSWINDOWS}
    procedure CreateWnd; override;
    {$ENDIF}
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function EffectiveSkinManager: TLazRibbonSkinManager;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property TitleBar: TLazRibbonTitleBar read FTitleBar;
  published
    { Associated Ribbon.  In this first version the property is used mainly to
      share the SkinManager and to make future title/QAT integration explicit. }
    property Ribbon: TLazRibbon read FRibbon write SetRibbon;

    { Optional SkinManager used by the custom title bar. If omitted, the form
      tries to use Ribbon.SkinManager when Ribbon is assigned. }
    property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;

    { First implementation uses a client-area custom title bar and removes the
      native frame at run time. Disable it to fall back to the normal TForm title. }
    property UseCustomTitleBar: Boolean read FUseCustomTitleBar write SetUseCustomTitleBar default True;
    property TitleBarHeight: Integer read FTitleBarHeight write SetTitleBarHeight default 32;
    property ShowSystemButtons: Boolean read FShowSystemButtons write SetShowSystemButtons default True;

    { Icon drawn at the far left of the custom title bar. Leave empty to use
      the normal form/application/project icon. This explicit property is useful
      because BorderStyle=bsNone prevents Windows from drawing the native icon. }
    property ShowTitleIcon: Boolean read FShowTitleIcon write SetShowTitleIcon default True;
    property TitleIcon: TIcon read FTitleIcon write SetTitleIcon;

    property TitleAlignment: TAlignment read FTitleAlignment write SetTitleAlignment default taCenter;
  end;

implementation

const
  { Windows WM_CLOSE value.  We keep a local constant instead of relying on
    WM_CLOSE/LM_CLOSE identifiers because their availability varies with the
    active Lazarus/FPC units. }
  LR_WM_CLOSE = $0010;
  LR_WM_SYSCOMMAND = $0112;
  LR_SC_MINIMIZE = $F020;

function LazRibbonMixColor(A, B: TColor; PercentB: Integer): TColor;
var
  CA, CB: LongInt;
  RA, GA, BA: Byte;
  RB, GB, BB: Byte;
begin
  if PercentB < 0 then PercentB := 0;
  if PercentB > 100 then PercentB := 100;
  CA := ColorToRGB(A);
  CB := ColorToRGB(B);
  RA := CA and $FF;
  GA := (CA shr 8) and $FF;
  BA := (CA shr 16) and $FF;
  RB := CB and $FF;
  GB := (CB shr 8) and $FF;
  BB := (CB shr 16) and $FF;
  Result := RGBToColor(
    (RA * (100 - PercentB) + RB * PercentB) div 100,
    (GA * (100 - PercentB) + GB * PercentB) div 100,
    (BA * (100 - PercentB) + BB * PercentB) div 100
  );
end;

function LazRibbonColorLuminance(AColor: TColor): Integer;
var
  C: LongInt;
  R, G, B: Byte;
begin
  C := ColorToRGB(AColor);
  R := C and $FF;
  G := (C shr 8) and $FF;
  B := (C shr 16) and $FF;
  Result := (Integer(R) * 299 + Integer(G) * 587 + Integer(B) * 114) div 1000;
end;

function LazRibbonIsDarkColor(AColor: TColor): Boolean;
begin
  Result := LazRibbonColorLuminance(AColor) < 128;
end;

function LazRibbonReadableTextColor(ABackColor, APreferredTextColor: TColor): TColor;
var
  LB, LT: Integer;
begin
  Result := APreferredTextColor;
  LB := LazRibbonColorLuminance(ABackColor);
  LT := LazRibbonColorLuminance(APreferredTextColor);

  { Some custom skins can define a text color that is too close to the title
    surface.  The normal Ribbon body may still look acceptable, but the custom
    client-area caption needs stronger contrast because it replaces the native
    Windows non-client caption. }
  if Abs(LB - LT) >= 84 then
    Exit;

  if LB < 128 then
    Result := clWhite
  else
    Result := RGBToColor(30, 30, 30);
end;

function LazRibbonAccentSurfaceColor(ABaseColor: TColor): TColor;
begin
  if LazRibbonIsDarkColor(ABaseColor) then
    Result := LazRibbonMixColor(ABaseColor, clWhite, 10)
  else
    Result := LazRibbonMixColor(ABaseColor, clWhite, 32);
end;

procedure LazRibbonVerticalGradient(ACanvas: TCanvas; const R: TRect; C1, C2: TColor);
var
  Y, H, P: Integer;
begin
  H := R.Bottom - R.Top;
  if H <= 1 then
  begin
    ACanvas.Brush.Color := C1;
    ACanvas.FillRect(R);
    Exit;
  end;
  for Y := R.Top to R.Bottom - 1 do
  begin
    P := ((Y - R.Top) * 100) div (H - 1);
    ACanvas.Pen.Color := LazRibbonMixColor(C1, C2, P);
    ACanvas.Line(R.Left, Y, R.Right, Y);
  end;
end;

{ TLazRibbonTitleBar }

constructor TLazRibbonTitleBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOwnerForm := nil;
  Height := 32;
  Align := alTop;
  ControlStyle := ControlStyle + [csOpaque];
  FHotButton := rfbNone;
  FDownButton := rfbNone;
  FQuickAccessHoverIndex := -1;
  FQuickAccessActiveIndex := -1;
  FCachedIcon := nil;
  SetLength(FQuickAccessRects, 0);
  FQuickAccessCustomizeRect := Types.Rect(-1, -1, -1, -1);
end;

destructor TLazRibbonTitleBar.Destroy;
begin
  try
    MouseCapture := False;
  except
  end;
  FQuickAccessHoverIndex := -1;
  FQuickAccessActiveIndex := -1;
  FOwnerForm := nil;
  ClearCachedIcon;
  inherited Destroy;
end;

function TLazRibbonTitleBar.ButtonRect(AButton: TLazRibbonFormSystemButton): TRect;
var
  BtnW: Integer;
begin
  Result := Types.Rect(0, 0, 0, 0);
  if (not OwnerFormAlive) or not FOwnerForm.ShowSystemButtons then Exit;
  BtnW := Max(28, Height);
  case AButton of
    rfbClose:
      Result := Types.Rect(Width - BtnW, 0, Width, Height);
    rfbMaximize:
      Result := Types.Rect(Width - 2 * BtnW, 0, Width - BtnW, Height);
    rfbMinimize:
      Result := Types.Rect(Width - 3 * BtnW, 0, Width - 2 * BtnW, Height);
  end;
end;

function TLazRibbonTitleBar.ButtonAt(X, Y: Integer): TLazRibbonFormSystemButton;
begin
  Result := rfbNone;
  if PtInRect(ButtonRect(rfbClose), Types.Point(X, Y)) then Exit(rfbClose);
  if PtInRect(ButtonRect(rfbMaximize), Types.Point(X, Y)) then Exit(rfbMaximize);
  if PtInRect(ButtonRect(rfbMinimize), Types.Point(X, Y)) then Exit(rfbMinimize);
end;

function TLazRibbonTitleBar.OwnerFormAlive: Boolean;
begin
  Result := (FOwnerForm <> nil) and
    not (csDestroying in ComponentState) and
    not (csDestroying in FOwnerForm.ComponentState) and
    not FOwnerForm.FClosingFromTitleBar;
end;

procedure TLazRibbonTitleBar.SafeInvalidate;
begin
  if csDestroying in ComponentState then Exit;
  if HandleAllocated then
    Invalidate;
end;

function TLazRibbonTitleBar.QuickAccessVisible: Boolean;
begin
  Result := OwnerFormAlive and
    not FOwnerForm.BackstageClientOverlayActive and
    (FOwnerForm.Ribbon <> nil) and
    not (csDestroying in FOwnerForm.Ribbon.ComponentState) and
    (FOwnerForm.Ribbon.QuickAccessToolBar <> nil) and
    FOwnerForm.Ribbon.QuickAccessToolBar.Visible and
    (FOwnerForm.Ribbon.QuickAccessToolBar.Position = qapTitleBar);
end;

procedure TLazRibbonTitleBar.BuildQuickAccessRects;
var
  QAT: TLazRibbonQuickAccessToolBar;
  I, X, Y, Sz, Gap: Integer;
begin
  SetLength(FQuickAccessRects, 0);
  FQuickAccessCustomizeRect := Types.Rect(-1, -1, -1, -1);

  if not QuickAccessVisible then
    Exit;

  QAT := FOwnerForm.Ribbon.QuickAccessToolBar;
  if QAT.ButtonSize > 0 then
    Sz := QAT.ButtonSize
  else
    Sz := Max(18, Height - 10);
  if Sz > Height - 6 then
    Sz := Height - 6;
  if Sz < 16 then
    Sz := 16;

  Gap := Max(0, QAT.Spacing);
  if FormIconVisible then
    X := FormIconRect.Right + 4
  else
    X := 6;
  Y := (Height - Sz) div 2;

  SetLength(FQuickAccessRects, QAT.Items.Count);
  for I := 0 to High(FQuickAccessRects) do
    FQuickAccessRects[I] := Types.Rect(-1, -1, -1, -1);

  for I := 0 to QAT.Items.Count - 1 do
    if QAT.Items[I].EffectiveVisible then
    begin
      FQuickAccessRects[I] := Types.Rect(X, Y, X + Sz, Y + Sz);
      Inc(X, Sz + Gap);
    end;

  if QAT.ShowCustomizeButton and QAT.AllowQuickCustomizing then
    FQuickAccessCustomizeRect := Types.Rect(X, Y, X + Sz, Y + Sz);
end;

function TLazRibbonTitleBar.QuickAccessHitTest(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  if not QuickAccessVisible then Exit;

  BuildQuickAccessRects;

  if PtInRect(FQuickAccessCustomizeRect, Types.Point(X, Y)) then
  begin
    Result := -2;
    Exit;
  end;

  for I := 0 to High(FQuickAccessRects) do
    if PtInRect(FQuickAccessRects[I], Types.Point(X, Y)) then
    begin
      Result := I;
      Exit;
    end;
end;

function TLazRibbonTitleBar.EffectiveFormIcon: TIcon;
begin
  Result := nil;

  if OwnerFormAlive and (not FOwnerForm.ShowTitleIcon) then
    Exit;

  if OwnerFormAlive and (FOwnerForm.TitleIcon <> nil) and
     (not FOwnerForm.TitleIcon.Empty) then
    Exit(FOwnerForm.TitleIcon);

  if OwnerFormAlive and (FOwnerForm.Icon <> nil) and (not FOwnerForm.Icon.Empty) then
    Exit(FOwnerForm.Icon);

  if (Application <> nil) and (Application.Icon <> nil) and
     (not Application.Icon.Empty) then
    Exit(Application.Icon);

  if (Application <> nil) and (Application.MainForm <> nil) and
     (Application.MainForm.Icon <> nil) and
     (not Application.MainForm.Icon.Empty) then
    Exit(Application.MainForm.Icon);

  Result := CachedIcon;
end;

function TLazRibbonTitleBar.CachedIcon: TIcon;
begin
  Result := FCachedIcon;
  if (Result <> nil) and (not Result.Empty) then
    Exit;

  ClearCachedIcon;

  Result := TryLoadIconFromProjectFile;

  {$IFDEF MSWINDOWS}
  if (Result = nil) or Result.Empty then
    Result := TryLoadIconFromExecutableResource;
  if (Result = nil) or Result.Empty then
    Result := TryExtractIconFromExecutable;
  {$ENDIF}
end;


function TLazRibbonTitleBar.TryLoadIconFromProjectFile: TIcon;
var
  ExeName, ExeDir, BaseName, Candidate: String;

  function TryCandidate(const AFileName: String): Boolean;
  begin
    Result := False;
    if (AFileName = '') or (not FileExists(AFileName)) then Exit;
    try
      ClearCachedIcon;
      FCachedIcon := TIcon.Create;
      FCachedIcon.LoadFromFile(AFileName);
      Result := (FCachedIcon <> nil) and (not FCachedIcon.Empty);
      if not Result then
        ClearCachedIcon;
    except
      ClearCachedIcon;
      Result := False;
    end;
  end;

begin
  Result := nil;

  if Application <> nil then
    ExeName := Application.ExeName
  else
    ExeName := ParamStr(0);

  if ExeName = '' then Exit;

  ExeDir := ExtractFilePath(ExeName);
  BaseName := ChangeFileExt(ExtractFileName(ExeName), '.ico');

  { Development-time fallback.  Lazarus often places the compiled executable in
    a bin\ directory while the project icon remains beside the .lpi file.  The
    normal Windows title bar hides this detail because Lazarus embeds the icon
    when the project has <Icon Value="0"/>.  With a custom title bar we also try
    the common file locations so the icon appears while running demos from the
    IDE even when the resource was not regenerated yet. }
  Candidate := ChangeFileExt(ExeName, '.ico');
  if TryCandidate(Candidate) then Exit(FCachedIcon);

  Candidate := IncludeTrailingPathDelimiter(ExeDir) + BaseName;
  if TryCandidate(Candidate) then Exit(FCachedIcon);

  Candidate := ExpandFileName(IncludeTrailingPathDelimiter(ExeDir) + '..' + DirectorySeparator + BaseName);
  if TryCandidate(Candidate) then Exit(FCachedIcon);

  Candidate := IncludeTrailingPathDelimiter(GetCurrentDir) + BaseName;
  if TryCandidate(Candidate) then Exit(FCachedIcon);

  Result := FCachedIcon;
end;

procedure TLazRibbonTitleBar.ClearCachedIcon;
begin
  FreeAndNil(FCachedIcon);
end;

{$IFDEF MSWINDOWS}
function TLazRibbonTitleBar.EffectiveWindowIconHandle: HICON;
const
  LR_WM_GETICON   = $007F;
  LR_ICON_SMALL   = 0;
  LR_ICON_BIG     = 1;
  LR_GCLP_HICON   = -14;
  LR_GCLP_HICONSM = -34;
begin
  Result := 0;

  if not OwnerFormAlive then Exit;
  if not FOwnerForm.HandleAllocated then Exit;

  { A normal Windows title bar obtains the icon from the window/class data.
    With BorderStyle=bsNone and a client-area title bar, we must recover that
    icon explicitly. This path is used mainly for applications that explicitly
    assigned Form.Icon/Application.Icon or whose widgetset already attached
    the project icon to the window handle. }
  Result := HICON(Windows.SendMessage(FOwnerForm.Handle, LR_WM_GETICON, LR_ICON_SMALL, 0));
  if Result = 0 then
    Result := HICON(Windows.SendMessage(FOwnerForm.Handle, LR_WM_GETICON, LR_ICON_BIG, 0));
  if Result = 0 then
    Result := HICON(Windows.GetClassLong(FOwnerForm.Handle, LR_GCLP_HICONSM));
  if Result = 0 then
    Result := HICON(Windows.GetClassLong(FOwnerForm.Handle, LR_GCLP_HICON));
end;

function TLazRibbonTitleBar.TryLoadIconFromExecutableResource: TIcon;
const
  LR_IMAGE_ICON      = 1;
  LR_DEFAULTCOLOR    = $0000;
  LR_DEFAULTSIZE     = $0040;
var
  H: HICON;
  Sz: Integer;

  procedure TryLoadByName(const AName: PChar);
  begin
    if H <> 0 then Exit;
    H := HICON(Windows.LoadImage(HInstance, AName, LR_IMAGE_ICON, Sz, Sz, LR_DEFAULTCOLOR));
    if H = 0 then
      H := HICON(Windows.LoadImage(HInstance, AName, LR_IMAGE_ICON, 0, 0, LR_DEFAULTSIZE));
  end;

begin
  Result := nil;
  H := 0;
  Sz := Min(16, Max(0, Height - 8));
  if Sz < 12 then
    Sz := 16;

  { Lazarus normally stores the project icon as MAINICON, but some projects
    and resource scripts use another conventional name. }
  TryLoadByName(PChar('MAINICON'));
  TryLoadByName(PChar('APPICON'));
  TryLoadByName(PChar('ICON'));

  if H = 0 then Exit;

  { LoadImage was intentionally called without LR_SHARED, so the returned
    icon handle is owned by the TIcon assigned below and will be released when
    FCachedIcon is freed. }
  FCachedIcon := TIcon.Create;
  FCachedIcon.Handle := H;
  Result := FCachedIcon;
end;

function TLazRibbonTitleBar.TryExtractIconFromExecutable: TIcon;
var
  SmallIcon, BigIcon, AssocIcon: HICON;
  ExeName: String;
  IconIndex: Word;
  ExeBuffer: array[0..MAX_PATH] of Char;
begin
  Result := nil;
  SmallIcon := 0;
  BigIcon := 0;
  AssocIcon := 0;

  if Application = nil then Exit;
  ExeName := Application.ExeName;
  if ExeName = '' then Exit;

  { This is the fallback that matters when Lazarus has embedded the icon in
    the executable but has not exposed it through Form.Icon, Application.Icon,
    WM_GETICON or the window class. It asks Windows for the first icon stored
    in the .exe, regardless of the internal resource name. }
  ShellApi.ExtractIconEx(PChar(ExeName), 0, BigIcon, SmallIcon, 1);

  if (SmallIcon = 0) and (BigIcon = 0) then
  begin
    FillChar(ExeBuffer, SizeOf(ExeBuffer), 0);
    StrPLCopy(ExeBuffer, ExeName, MAX_PATH);
    IconIndex := 0;
    AssocIcon := ShellApi.ExtractAssociatedIcon(HInstance, ExeBuffer, @IconIndex);
  end;

  if (SmallIcon = 0) and (BigIcon = 0) and (AssocIcon = 0) then
    Exit;

  FCachedIcon := TIcon.Create;
  if SmallIcon <> 0 then
  begin
    FCachedIcon.Handle := SmallIcon;
    if BigIcon <> 0 then
      Windows.DestroyIcon(BigIcon);
  end
  else if BigIcon <> 0 then
    FCachedIcon.Handle := BigIcon
  else if AssocIcon <> 0 then
    FCachedIcon.Handle := AssocIcon;

  if FCachedIcon.Empty then
    ClearCachedIcon;

  Result := FCachedIcon;
end;
{$ENDIF}

function TLazRibbonTitleBar.FormIconRect: TRect;
var
  Sz: Integer;
begin
  Sz := Min(16, Max(0, Height - 8));
  if Sz < 12 then
    Sz := 12;
  Result := Types.Rect(6, (Height - Sz) div 2, 6 + Sz, (Height - Sz) div 2 + Sz);
end;

function TLazRibbonTitleBar.FormIconVisible: Boolean;
begin
  Result := OwnerFormAlive and FOwnerForm.ShowTitleIcon and
    not FOwnerForm.BackstageClientOverlayActive;
end;

procedure TLazRibbonTitleBar.DrawFormIcon(ACanvas: TCanvas);
{$IFDEF MSWINDOWS}
const
  LR_DI_NORMAL = $0003;
{$ENDIF}
var
  R: TRect;
  LIcon: TIcon;
  {$IFDEF MSWINDOWS}
  LWinIcon: HICON;
  {$ENDIF}
begin
  if not FormIconVisible then
    Exit;

  R := FormIconRect;
  if (R.Right <= R.Left) or (R.Bottom <= R.Top) then
    Exit;

  LIcon := EffectiveFormIcon;
  if LIcon <> nil then
  begin
    ACanvas.StretchDraw(R, LIcon);
    Exit;
  end;

  {$IFDEF MSWINDOWS}
  LWinIcon := EffectiveWindowIconHandle;
  if LWinIcon = 0 then
    LWinIcon := Windows.LoadIcon(0, IDI_APPLICATION);
  if LWinIcon <> 0 then
    Windows.DrawIconEx(ACanvas.Handle, R.Left, R.Top, LWinIcon,
      R.Right - R.Left, R.Bottom - R.Top, 0, 0, LR_DI_NORMAL);
  {$ELSE}
  ACanvas.Brush.Style := bsClear;
  ACanvas.Pen.Color := clWindowText;
  ACanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
  ACanvas.Line(R.Left + 3, R.Top + 3, R.Right - 3, R.Top + 3);
  {$ENDIF}
end;

function TLazRibbonTitleBar.QuickAccessRightEdge: Integer;
var
  I: Integer;
begin
  if FormIconVisible then
    Result := FormIconRect.Right
  else
    Result := 0;
  if not QuickAccessVisible then Exit;
  BuildQuickAccessRects;
  for I := 0 to High(FQuickAccessRects) do
    if FQuickAccessRects[I].Right > Result then
      Result := FQuickAccessRects[I].Right;
  if FQuickAccessCustomizeRect.Right > Result then
    Result := FQuickAccessCustomizeRect.Right;
end;

procedure TLazRibbonTitleBar.DrawQuickAccessToolBar(ACanvas: TCanvas);
var
  I, Img, X, Y, Sz: Integer;
  R, GlyphRect: TRect;
  QAT: TLazRibbonQuickAccessToolBar;
  Item: TLazRibbonQuickAccessItem;
  QImages: TCustomImageList;
  Hot, Down, Enabled, HasDropDown: Boolean;
  Fill, Border, GlyphColor: TColor;

  procedure DrawButtonFace(const ARect: TRect; AHot, ADown, AEnabled: Boolean);
  begin
    if (QAT.ButtonFrameStyle = qfsHotOnly) and AEnabled and (not AHot) and (not ADown) then
      Exit;

    if ADown then
      Fill := LazRibbonMixColor(clBtnFace, clBlack, 18)
    else if AHot then
      Fill := LazRibbonMixColor(clBtnFace, clWhite, 15)
    else if not AEnabled then
      Fill := LazRibbonMixColor(clBtnFace, clWhite, 10)
    else
      Fill := LazRibbonMixColor(clBtnFace, clWhite, 4);

    if (FOwnerForm <> nil) and (FOwnerForm.EffectiveSkinManager <> nil) then
    begin
      Border := FOwnerForm.EffectiveSkinManager.General.BorderColor;
      if ADown then
        Fill := LazRibbonMixColor(FOwnerForm.EffectiveSkinManager.Ribbon.TabHotColor, clBlack, 12)
      else if AHot then
      begin
        if LazRibbonIsDarkColor(FOwnerForm.EffectiveSkinManager.Ribbon.TabHotColor) then
          Fill := LazRibbonMixColor(FOwnerForm.EffectiveSkinManager.Ribbon.TabHotColor, clWhite, 12)
        else
          Fill := LazRibbonMixColor(FOwnerForm.EffectiveSkinManager.Ribbon.TabHotColor, clWhite, 15);
      end
      else
        Fill := LazRibbonAccentSurfaceColor(FOwnerForm.EffectiveSkinManager.Ribbon.TopColor);
    end
    else
      Border := clGray;

    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := Fill;
    ACanvas.Pen.Color := Border;
    ACanvas.RoundRect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom, 5, 5);
  end;

  procedure DrawFallbackGlyph(const ARect: TRect; const ACaption, AHint: String; AColor: TColor);
  var
    Key, S: String;
    CX, CY: Integer;
  begin
    Key := LowerCase(ACaption + ' ' + AHint);
    CX := (ARect.Left + ARect.Right) div 2;
    CY := (ARect.Top + ARect.Bottom) div 2;
    ACanvas.Pen.Color := AColor;
    ACanvas.Pen.Width := 1;
    ACanvas.Brush.Style := bsClear;

    if (Pos('salvar', Key) > 0) or (Pos('save', Key) > 0) then
    begin
      ACanvas.Rectangle(CX - 6, CY - 6, CX + 6, CY + 6);
      ACanvas.Rectangle(CX - 3, CY - 5, CX + 3, CY - 2);
      ACanvas.Rectangle(CX - 3, CY + 2, CX + 3, CY + 6);
    end
    else if (Pos('abrir', Key) > 0) or (Pos('open', Key) > 0) then
    begin
      ACanvas.Rectangle(CX - 7, CY - 3, CX + 7, CY + 6);
      ACanvas.Line(CX - 7, CY - 3, CX - 3, CY - 7);
      ACanvas.Line(CX - 3, CY - 7, CX + 7, CY - 7);
      ACanvas.Line(CX + 7, CY - 7, CX + 9, CY - 3);
    end
    else if (Pos('novo', Key) > 0) or (Pos('new', Key) > 0) then
    begin
      ACanvas.Rectangle(CX - 5, CY - 7, CX + 5, CY + 7);
      ACanvas.Line(CX + 1, CY - 7, CX + 5, CY - 3);
      ACanvas.Pen.Width := 2;
      ACanvas.Line(CX + 7, CY + 2, CX + 13, CY + 2);
      ACanvas.Line(CX + 10, CY - 1, CX + 10, CY + 5);
      ACanvas.Pen.Width := 1;
    end
    else if (Pos('desfazer', Key) > 0) or (Pos('undo', Key) > 0) then
    begin
      ACanvas.Arc(CX - 7, CY - 6, CX + 8, CY + 7, CX - 6, CY - 4, CX + 4, CY + 4);
      ACanvas.Line(CX - 6, CY - 4, CX - 10, CY - 4);
      ACanvas.Line(CX - 6, CY - 4, CX - 6, CY - 8);
    end
    else if (Pos('refazer', Key) > 0) or (Pos('redo', Key) > 0) then
    begin
      ACanvas.Arc(CX - 8, CY - 6, CX + 7, CY + 7, CX + 6, CY - 4, CX - 4, CY + 4);
      ACanvas.Line(CX + 6, CY - 4, CX + 10, CY - 4);
      ACanvas.Line(CX + 6, CY - 4, CX + 6, CY - 8);
    end
    else
    begin
      if ACaption <> '' then
        S := Copy(ACaption, 1, 1)
      else
        S := '•';
      ACanvas.Font.Style := [fsBold];
      ACanvas.Font.Color := AColor;
      ACanvas.TextOut(CX - ACanvas.TextWidth(S) div 2, CY - ACanvas.TextHeight(S) div 2, S);
      ACanvas.Font.Style := [];
    end;
  end;

  procedure DrawSmallArrow(const ARect: TRect; AColor: TColor; ACustomize: Boolean);
  var
    P: array[0..2] of TPoint;
    CX, CY: Integer;
  begin
    if ACustomize then
      CX := (ARect.Left + ARect.Right) div 2
    else
      CX := ARect.Right - 5;
    CY := (ARect.Top + ARect.Bottom) div 2 + 1;
    P[0] := Types.Point(CX - 3, CY - 2);
    P[1] := Types.Point(CX + 3, CY - 2);
    P[2] := Types.Point(CX, CY + 2);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := AColor;
    ACanvas.Pen.Style := psClear;
    ACanvas.Polygon(P);
    ACanvas.Pen.Style := psSolid;
  end;

begin
  if not QuickAccessVisible then Exit;

  QAT := FOwnerForm.Ribbon.QuickAccessToolBar;
  BuildQuickAccessRects;

  { Draw a subtle capsule behind the title-bar QAT.  This separates the
    application icon/QAT cluster from the caption area without making the
    buttons look like old-style toolbar push buttons. }
  R := Types.Rect(0, 0, 0, 0);
  for I := 0 to High(FQuickAccessRects) do
    if (FQuickAccessRects[I].Right > FQuickAccessRects[I].Left) and
       (FQuickAccessRects[I].Bottom > FQuickAccessRects[I].Top) then
    begin
      if R.Right <= R.Left then
        R := FQuickAccessRects[I]
      else
      begin
        R.Left := Min(R.Left, FQuickAccessRects[I].Left);
        R.Top := Min(R.Top, FQuickAccessRects[I].Top);
        R.Right := Max(R.Right, FQuickAccessRects[I].Right);
        R.Bottom := Max(R.Bottom, FQuickAccessRects[I].Bottom);
      end;
    end;
  if (FQuickAccessCustomizeRect.Right > FQuickAccessCustomizeRect.Left) and
     (FQuickAccessCustomizeRect.Bottom > FQuickAccessCustomizeRect.Top) then
  begin
    if R.Right <= R.Left then
      R := FQuickAccessCustomizeRect
    else
    begin
      R.Left := Min(R.Left, FQuickAccessCustomizeRect.Left);
      R.Top := Min(R.Top, FQuickAccessCustomizeRect.Top);
      R.Right := Max(R.Right, FQuickAccessCustomizeRect.Right);
      R.Bottom := Max(R.Bottom, FQuickAccessCustomizeRect.Bottom);
    end;
  end;
  if R.Right > R.Left then
  begin
    InflateRect(R, 3, 2);
    if FOwnerForm.EffectiveSkinManager <> nil then
    begin
      Fill := LazRibbonAccentSurfaceColor(FOwnerForm.EffectiveSkinManager.Ribbon.TopColor);
      if LazRibbonIsDarkColor(FOwnerForm.EffectiveSkinManager.Ribbon.TopColor) then
        Border := LazRibbonMixColor(FOwnerForm.EffectiveSkinManager.General.BorderColor, clWhite, 20)
      else
        Border := LazRibbonMixColor(FOwnerForm.EffectiveSkinManager.General.BorderColor, clWhite, 24);
    end
    else
    begin
      Fill := LazRibbonMixColor(clBtnFace, clWhite, 24);
      Border := clGray;
    end;
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := Fill;
    ACanvas.Pen.Color := Border;
    ACanvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 12, 12);
  end;

  for I := 0 to High(FQuickAccessRects) do
  begin
    if I >= QAT.Items.Count then Continue;
    R := FQuickAccessRects[I];
    if (R.Right <= R.Left) or (R.Bottom <= R.Top) then Continue;

    Item := QAT.Items[I];
    if not Item.EffectiveVisible then Continue;

    Hot := FQuickAccessHoverIndex = I;
    Down := (FQuickAccessActiveIndex = I) and Hot;
    Enabled := Item.EffectiveEnabled;
    DrawButtonFace(R, Hot, Down, Enabled);

    if (FOwnerForm <> nil) and (FOwnerForm.EffectiveSkinManager <> nil) then
      GlyphColor := LazRibbonReadableTextColor(FOwnerForm.EffectiveSkinManager.Ribbon.TopColor,
        FOwnerForm.EffectiveSkinManager.General.TextColor)
    else
      GlyphColor := clWindowText;
    if not Enabled then
      GlyphColor := clGray;

    HasDropDown := Item.HasLinkedDropDown;
    GlyphRect := R;
    InflateRect(GlyphRect, -2, -2);
    if HasDropDown then
      Dec(GlyphRect.Right, 6);

    Img := Item.EffectiveImageIndex;
    QImages := QAT.Images;
    if QImages = nil then
      QImages := FOwnerForm.Ribbon.Images;
    if (Img >= 0) and (QImages <> nil) and (Img < QImages.Count) then
    begin
      Sz := Max(16, QImages.Width);
      X := GlyphRect.Left + ((GlyphRect.Right - GlyphRect.Left) - Sz) div 2;
      Y := GlyphRect.Top + ((GlyphRect.Bottom - GlyphRect.Top) - Sz) div 2;
      QImages.Draw(ACanvas, X, Y, Img, Enabled);
    end
    else if QAT.FallbackGlyphStyle <> qfgNone then
      DrawFallbackGlyph(GlyphRect, Item.EffectiveCaption, Item.EffectiveHint, GlyphColor);

    if HasDropDown then
      DrawSmallArrow(R, GlyphColor, False);
  end;

  if QAT.ShowCustomizeButton and QAT.AllowQuickCustomizing and
     (FQuickAccessCustomizeRect.Right > FQuickAccessCustomizeRect.Left) then
  begin
    R := FQuickAccessCustomizeRect;
    Hot := FQuickAccessHoverIndex = -2;
    Down := (FQuickAccessActiveIndex = -2) and Hot;
    DrawButtonFace(R, Hot, Down, True);
    if (FOwnerForm <> nil) and (FOwnerForm.EffectiveSkinManager <> nil) then
      GlyphColor := LazRibbonReadableTextColor(FOwnerForm.EffectiveSkinManager.Ribbon.TopColor,
        FOwnerForm.EffectiveSkinManager.General.TextColor)
    else
      GlyphColor := clWindowText;
    DrawSmallArrow(R, GlyphColor, True);
  end;
end;


procedure TLazRibbonTitleBar.DrawKeyTipsOverlay(ACanvas: TCanvas);
var
  I: Integer;
  QAT: TLazRibbonQuickAccessToolBar;
  Tip: String;
  R: TRect;

  function CleanKeyTip(const S: String): String;
  begin
    Result := UpperCase(Trim(StringReplace(S, '&', '', [rfReplaceAll])));
  end;

  function VisibleKeyTipText(const ATip: String): String;
  var
    Prefix: String;
  begin
    if ATip = '' then
      Exit('');

    Prefix := CleanKeyTip(FOwnerForm.Ribbon.KeyTipsPrefix);
    if Prefix = '' then
      Exit(ATip);

    if Copy(ATip, 1, Length(Prefix)) <> Prefix then
      Exit('');

    Result := Copy(ATip, Length(Prefix) + 1, MaxInt);
    if Result = '' then
      Result := ATip;
  end;

  procedure DrawKeyTipBox(const AText: String; const AAnchor: TRect);
  var
    Box: TRect;
    W, H, X, Y: Integer;
  begin
    if AText = '' then Exit;

    ACanvas.Font.Style := [fsBold];
    W := ACanvas.TextWidth(AText) + 12;
    H := ACanvas.TextHeight('Wy') + 6;

    X := AAnchor.Left + ((AAnchor.Right - AAnchor.Left) - W) div 2;
    Y := AAnchor.Bottom - H + 5;

    if X < 2 then X := 2;
    if X + W > Width - 2 then X := Width - W - 2;
    if Y < 1 then Y := 1;
    if Y + H > Height - 1 then Y := Height - H - 1;

    Box := Types.Rect(X, Y, X + W, Y + H);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := clInfoBk;
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Color := clGray;
    ACanvas.Rectangle(Box.Left, Box.Top, Box.Right, Box.Bottom);
    ACanvas.Font.Color := clBlack;
    ACanvas.TextOut(Box.Left + 6, Box.Top + 3, AText);
  end;

begin
  if not QuickAccessVisible then Exit;
  if (FOwnerForm = nil) or (FOwnerForm.Ribbon = nil) then Exit;
  if (not FOwnerForm.Ribbon.ShowKeyTips) or
     (not FOwnerForm.Ribbon.KeyTipsTopLevelVisible) then
    Exit;

  QAT := FOwnerForm.Ribbon.QuickAccessToolBar;
  if QAT = nil then Exit;

  BuildQuickAccessRects;

  for I := 0 to High(FQuickAccessRects) do
  begin
    if I >= QAT.Items.Count then Continue;
    if not QAT.Items[I].EffectiveVisible then Continue;
    R := FQuickAccessRects[I];
    if (R.Right <= R.Left) or (R.Bottom <= R.Top) then Continue;

    Tip := CleanKeyTip(QAT.Items[I].KeyTip);
    if Tip = '' then
      Tip := IntToStr(I + 1);
    DrawKeyTipBox(VisibleKeyTipText(Tip), R);
  end;
end;

procedure TLazRibbonTitleBar.ClearQuickAccessState;
begin
  if (FQuickAccessHoverIndex <> -1) or (FQuickAccessActiveIndex <> -1) then
  begin
    FQuickAccessHoverIndex := -1;
    FQuickAccessActiveIndex := -1;
    SafeInvalidate;
  end;
end;

procedure TLazRibbonTitleBar.DrawTitleBarBackground(ACanvas: TCanvas; const R: TRect);
var
  SM: TLazRibbonSkinManager;
  C1, C2, Border: TColor;
begin
  if (FOwnerForm <> nil) and FOwnerForm.BackstageClientOverlayActive then
  begin
    ACanvas.Brush.Color := FOwnerForm.BackstageClientOverlayColor;
    ACanvas.Pen.Color := FOwnerForm.BackstageClientOverlayColor;
    ACanvas.Rectangle(R);
    Exit;
  end;

  SM := nil;
  if FOwnerForm <> nil then
    SM := FOwnerForm.EffectiveSkinManager;

  if SM <> nil then
  begin
    { The title strip should read as part of the active skin, not as a generic
      Windows toolbar.  Light skins receive a subtle Office-like highlight; dark
      skins keep their dark surface and only gain a small top lift so the custom
      chrome does not become washed out. }
    if LazRibbonIsDarkColor(SM.Ribbon.TopColor) then
    begin
      C1 := LazRibbonMixColor(SM.Ribbon.TopColor, clWhite, 6);
      C2 := LazRibbonMixColor(SM.Ribbon.BottomColor, clBlack, 6);
      Border := LazRibbonMixColor(SM.General.BorderColor, clWhite, 16);
    end
    else
    begin
      C1 := LazRibbonMixColor(SM.Ribbon.TopColor, clWhite, 14);
      C2 := LazRibbonMixColor(SM.Ribbon.BottomColor, clWhite, 4);
      Border := LazRibbonMixColor(SM.General.BorderColor, clWhite, 12);
    end;
  end
  else
  begin
    C1 := clBtnHighlight;
    C2 := clBtnFace;
    Border := clGray;
  end;

  LazRibbonVerticalGradient(ACanvas, R, C1, C2);
  ACanvas.Pen.Color := Border;
  ACanvas.Line(R.Left, R.Bottom - 1, R.Right, R.Bottom - 1);
end;

procedure TLazRibbonTitleBar.DrawSystemButton(ACanvas: TCanvas;
  AButton: TLazRibbonFormSystemButton; const R: TRect; AHot, ADown: Boolean);
var
  Fill, Frame, Glyph: TColor;
  CX, CY, S: Integer;
  RR: TRect;
  SM: TLazRibbonSkinManager;
begin
  if IsRectEmpty(R) then Exit;

  if (FOwnerForm <> nil) and FOwnerForm.BackstageClientOverlayActive then
  begin
    Fill := FOwnerForm.BackstageClientOverlayColor;
    Frame := LazRibbonMixColor(Fill, clBlack, 18);
    Glyph := LazRibbonReadableTextColor(Fill, clWindowText);
    if AButton = rfbClose then
    begin
      if AHot or ADown then
      begin
        Fill := $003535E8;
        Glyph := clWhite;
      end
      else
        Fill := clNone;
    end
    else if ADown then
      Fill := LazRibbonMixColor(Fill, clBlack, 12)
    else if AHot then
      Fill := LazRibbonMixColor(Fill, clBlack, 6)
    else
      Fill := clNone;
  end
  else
  begin
    SM := nil;
    if FOwnerForm <> nil then
      SM := FOwnerForm.EffectiveSkinManager;

    if SM <> nil then
    begin
      Frame := SM.General.BorderColor;
      Glyph := LazRibbonReadableTextColor(SM.Ribbon.TopColor, SM.General.TextColor);
      Fill := SM.Ribbon.TabHotColor;
    end
    else
    begin
      Frame := clGray;
      Glyph := clWindowText;
      Fill := clBtnFace;
    end;

    if AButton = rfbClose then
    begin
      if AHot or ADown then
      begin
        Fill := $003535E8;
        Glyph := clWhite;
      end
      else
        Fill := clNone;
    end
    else if ADown then
      Fill := LazRibbonMixColor(Fill, clBlack, 18)
    else if AHot then
    begin
      if LazRibbonIsDarkColor(Fill) then
        Fill := LazRibbonMixColor(Fill, clWhite, 14)
      else
        Fill := LazRibbonMixColor(Fill, clWhite, 15);
    end
    else
      Fill := clNone;
  end;

  if Fill <> clNone then
  begin
    ACanvas.Brush.Color := Fill;
    ACanvas.Pen.Color := Frame;
    ACanvas.Rectangle(R);
  end;

  CX := (R.Left + R.Right) div 2;
  CY := (R.Top + R.Bottom) div 2;
  S := Max(8, Min(R.Right - R.Left, R.Bottom - R.Top) div 3);
  if ADown then
  begin
    Inc(CX);
    Inc(CY);
  end;

  ACanvas.Pen.Color := Glyph;
  ACanvas.Pen.Width := 1;
  case AButton of
    rfbMinimize:
      begin
        ACanvas.Line(CX - S div 2, CY + S div 3, CX + S div 2 + 1, CY + S div 3);
      end;
    rfbMaximize:
      begin
        if (FOwnerForm <> nil) and (FOwnerForm.WindowState = wsMaximized) then
        begin
          RR := Types.Rect(CX - S div 2 + 2, CY - S div 2, CX + S div 2 + 2, CY + S div 2);
          ACanvas.Rectangle(RR);
          OffsetRect(RR, -3, 3);
          ACanvas.Rectangle(RR);
        end
        else
        begin
          RR := Types.Rect(CX - S div 2, CY - S div 2, CX + S div 2 + 1, CY + S div 2 + 1);
          ACanvas.Rectangle(RR);
        end;
      end;
    rfbClose:
      begin
        ACanvas.Line(CX - S div 2, CY - S div 2, CX + S div 2 + 1, CY + S div 2 + 1);
        ACanvas.Line(CX + S div 2, CY - S div 2, CX - S div 2 - 1, CY + S div 2 + 1);
      end;
  end;
  ACanvas.Pen.Width := 1;
end;

procedure TLazRibbonTitleBar.Paint;
var
  R, TextR: TRect;
  BackstageTitleMode: Boolean;
  SM: TLazRibbonSkinManager;
  TextFlags: LongInt;
  OldBrushStyle: TBrushStyle;
begin
  inherited Paint;
  R := ClientRect;
  BackstageTitleMode := (FOwnerForm <> nil) and FOwnerForm.BackstageClientOverlayActive;
  DrawTitleBarBackground(Canvas, R);

  if not BackstageTitleMode then
  begin
    DrawFormIcon(Canvas);
    DrawQuickAccessToolBar(Canvas);
  end;

  if (FOwnerForm <> nil) and FOwnerForm.ShowSystemButtons then
  begin
    DrawSystemButton(Canvas, rfbMinimize, ButtonRect(rfbMinimize),
      FHotButton = rfbMinimize, FDownButton = rfbMinimize);
    DrawSystemButton(Canvas, rfbMaximize, ButtonRect(rfbMaximize),
      FHotButton = rfbMaximize, FDownButton = rfbMaximize);
    DrawSystemButton(Canvas, rfbClose, ButtonRect(rfbClose),
      FHotButton = rfbClose, FDownButton = rfbClose);
  end;

  if FOwnerForm <> nil then
  begin
    if BackstageTitleMode then
      Canvas.Font.Color := LazRibbonReadableTextColor(
        FOwnerForm.BackstageClientOverlayColor, clWindowText)
    else
    begin
      SM := FOwnerForm.EffectiveSkinManager;
      if SM <> nil then
        Canvas.Font.Color := LazRibbonReadableTextColor(SM.Ribbon.TopColor, SM.General.TextColor)
      else
        Canvas.Font.Color := clWindowText;
    end;
    Canvas.Font.Style := [];

    TextR := ClientRect;
    InflateRect(TextR, -8, 0);

    TextFlags := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    case FOwnerForm.TitleAlignment of
      taLeftJustify:
        begin
          TextR.Left := Max(TextR.Left, QuickAccessRightEdge + 10);
          if FOwnerForm.ShowSystemButtons then
            Dec(TextR.Right, Max(28, Height) * 3 + 6);
          TextFlags := TextFlags or DT_LEFT;
        end;
      taRightJustify:
        begin
          TextR.Left := Max(TextR.Left, QuickAccessRightEdge + 10);
          if FOwnerForm.ShowSystemButtons then
            Dec(TextR.Right, Max(28, Height) * 3 + 6);
          TextFlags := TextFlags or DT_RIGHT;
        end;
    else
      begin
        { Center the caption against the whole window, not merely against the
          residual space after the QAT.  This mirrors the DevExpress/Office
          composition: icon/QAT on the left, system buttons on the right, and
          the title visually centered.  The symmetric inset prevents overlap
          when the QAT grows. }
        if FOwnerForm.ShowSystemButtons then
          TextR.Left := Max(QuickAccessRightEdge + 10, Max(28, Height) * 3 + 14)
        else
          TextR.Left := QuickAccessRightEdge + 10;
        TextR.Right := Width - TextR.Left;
        if TextR.Right <= TextR.Left + 24 then
        begin
          TextR := ClientRect;
          InflateRect(TextR, -8, 0);
          TextR.Left := Max(TextR.Left, QuickAccessRightEdge + 10);
          if FOwnerForm.ShowSystemButtons then
            Dec(TextR.Right, Max(28, Height) * 3 + 6);
        end;
        TextFlags := TextFlags or DT_CENTER;
      end;
    end;

    { Do not let the brush used by the last drawn system button leak into
      DrawText.  In 0.3.1 this could draw the caption over a red rectangle
      after painting the Close button. }
    OldBrushStyle := Canvas.Brush.Style;
    Canvas.Brush.Style := bsClear;
    try
      DrawText(Canvas.Handle, PChar(FOwnerForm.Caption), Length(FOwnerForm.Caption), TextR, TextFlags);
    finally
      Canvas.Brush.Style := OldBrushStyle;
    end;
  end;

  DrawKeyTipsOverlay(Canvas);
end;

procedure TLazRibbonTitleBar.SetHotButton(AValue: TLazRibbonFormSystemButton);
begin
  if FHotButton = AValue then Exit;
  FHotButton := AValue;
  SafeInvalidate;
end;

procedure TLazRibbonTitleBar.SetDownButton(AValue: TLazRibbonFormSystemButton);
begin
  if FDownButton = AValue then Exit;
  FDownButton := AValue;
  SafeInvalidate;
end;

procedure TLazRibbonTitleBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  inherited MouseMove(Shift, X, Y);
  if not OwnerFormAlive then Exit;
  if FDragging then
  begin
    P := Mouse.CursorPos;
    FOwnerForm.Left := FFormStart.X + (P.X - FDragStart.X);
    FOwnerForm.Top := FFormStart.Y + (P.Y - FDragStart.Y);
    Exit;
  end;

  FQuickAccessHoverIndex := QuickAccessHitTest(X, Y);
  SetHotButton(ButtonAt(X, Y));
  SafeInvalidate;
end;

procedure TLazRibbonTitleBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  B: TLazRibbonFormSystemButton;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button <> mbLeft then Exit;
  if not OwnerFormAlive then Exit;

  { Keep the Office-like KeyTips mode strictly keyboard-driven. Clicking the
    custom title bar, title-bar QAT or system buttons closes the overlay first
    and then continues with the normal mouse action. }
  if (FOwnerForm <> nil) and (FOwnerForm.Ribbon <> nil) and
     FOwnerForm.Ribbon.KeyTipsVisible then
    FOwnerForm.Ribbon.HideKeyTips;

  B := ButtonAt(X, Y);
  if B <> rfbNone then
  begin
    SetDownButton(B);
    ClearQuickAccessState;
    Exit;
  end;

  FQuickAccessActiveIndex := QuickAccessHitTest(X, Y);
  if FQuickAccessActiveIndex <> -1 then
  begin
    FQuickAccessHoverIndex := FQuickAccessActiveIndex;
    SafeInvalidate;
    Exit;
  end;

  if (ssDouble in Shift) and (FOwnerForm <> nil) then
  begin
    if FOwnerForm.WindowState = wsMaximized then
      FOwnerForm.WindowState := wsNormal
    else
      FOwnerForm.WindowState := wsMaximized;
    Exit;
  end;

  if FOwnerForm <> nil then
  begin
    FDragging := True;
    FDragStart := Mouse.CursorPos;
    FFormStart := Types.Point(FOwnerForm.Left, FOwnerForm.Top);
  end;
end;

procedure TLazRibbonTitleBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  B: TLazRibbonFormSystemButton;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button <> mbLeft then Exit;
  if not OwnerFormAlive then Exit;

  FDragging := False;

  if (FOwnerForm <> nil) and (FOwnerForm.Ribbon <> nil) and
     (FQuickAccessActiveIndex <> -1) then
  begin
    if QuickAccessHitTest(X, Y) = FQuickAccessActiveIndex then
    begin
      if FQuickAccessActiveIndex = -2 then
        FOwnerForm.Ribbon.ShowQuickAccessCustomizeMenuAtScreen(
          ClientToScreen(Types.Point(FQuickAccessCustomizeRect.Left, FQuickAccessCustomizeRect.Bottom)))
      else if (FQuickAccessActiveIndex >= 0) and
              (FQuickAccessActiveIndex < FOwnerForm.Ribbon.QuickAccessToolBar.Items.Count) then
        FOwnerForm.Ribbon.QuickAccessToolBar.Items[FQuickAccessActiveIndex].ExecuteAt(
          ClientToScreen(Types.Point(FQuickAccessRects[FQuickAccessActiveIndex].Left,
            FQuickAccessRects[FQuickAccessActiveIndex].Bottom)));
    end;
    FQuickAccessActiveIndex := -1;
    FQuickAccessHoverIndex := QuickAccessHitTest(X, Y);
    SafeInvalidate;
    Exit;
  end;

  B := ButtonAt(X, Y);
  if (FOwnerForm <> nil) and (B <> rfbNone) and (B = FDownButton) then
  begin
    case B of
      rfbMinimize:
        FOwnerForm.MinimizeFromTitleBar;
      rfbMaximize:
        if FOwnerForm.WindowState = wsMaximized then
          FOwnerForm.WindowState := wsNormal
        else
          FOwnerForm.WindowState := wsMaximized;
      rfbClose:
        begin
          { Never call Close directly from this MouseUp. If the owner form is the
            main form, Close may destroy the form while this control is still
            executing its mouse handler.  Posting WM_CLOSE through LCLIntf keeps
            the close request outside the current mouse event and avoids a queued
            object-method callback that can outlive the form during application
            shutdown. }
          FDownButton := rfbNone;
          FHotButton := rfbNone;
          FQuickAccessActiveIndex := -1;
          FQuickAccessHoverIndex := -1;
          FDragging := False;
          try
            MouseCapture := False;
          except
          end;
          FOwnerForm.RequestCloseFromTitleBar;
          Exit;
        end;
    end;
  end;
  SetDownButton(rfbNone);
  SetHotButton(ButtonAt(X, Y));
end;

procedure TLazRibbonTitleBar.CMMouseLeave(var Message: TLMessage);
begin
  inherited;
  if not FDragging then
  begin
    SetHotButton(rfbNone);
    SetDownButton(rfbNone);
    ClearQuickAccessState;
  end;
end;

{$IFDEF MSWINDOWS}
procedure TLazRibbonTitleBar.WMNCHitTest(var Message: TLMessage);
var
  ScreenP: TPoint;
  Hit: PtrInt;
begin
  inherited;
  if not OwnerFormAlive then
    Exit;

  ScreenP := Types.Point(
    SmallInt(PtrUInt(Message.LParam) and $FFFF),
    SmallInt((PtrUInt(Message.LParam) shr 16) and $FFFF));
  Hit := FOwnerForm.CustomChromeHitTest(ScreenP);
  if Hit <> HTCLIENT then
    Message.Result := Hit;
end;
{$ENDIF}

{ TLazRibbonForm }

constructor TLazRibbonForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOriginalBorderStyle := BorderStyle;
  FUseCustomTitleBar := True;
  FTitleBarHeight := 32;
  FShowSystemButtons := True;
  FTitleAlignment := taCenter;
  FShowTitleIcon := True;
  FClosingFromTitleBar := False;
  FTitleIcon := TIcon.Create;

  { Create the internal title bar without an Owner.  If it is owned by the
    form, Lazarus may treat it as a normal design-time child component when
    TLazRibbonForm is registered as a designer base class, and may then try to
    stream TLazRibbonTitleBar into .lfm files.  This title bar is implementation
    detail, not part of the form's persistent component tree. }
  FTitleBar := TLazRibbonTitleBar.Create(nil);
  FTitleBar.FOwnerForm := Self;
  FTitleBar.Parent := Self;
  FTitleBar.Align := alTop;
  FTitleBar.Height := FTitleBarHeight;
  FTitleBar.Visible := FUseCustomTitleBar;
end;

destructor TLazRibbonForm.Destroy;
begin
  { Important: descendant destructors run before TComponent.Destroy marks the
    component as csDestroying.  Mark it now so pending paints, notifications,
    skin-change dispatches and QAT metric updates stop using this form while
    its fields are being torn down. }
  FClosingFromTitleBar := True;
  Destroying;

  { The title bar is intentionally not owned by the form, because it is an
    internal chrome control and must not be streamed into .lfm files.  Free it
    explicitly and clear the back-reference first so no pending paint/mouse
    notification can reach a form that is already being torn down. }
  if FTitleBar <> nil then
  begin
    try
      FTitleBar.MouseCapture := False;
    except
    end;
    FTitleBar.Enabled := False;
    FTitleBar.Visible := False;
    FTitleBar.FOwnerForm := nil;
    FTitleBar.Parent := nil;
    FreeAndNil(FTitleBar);
  end;

  if FSkinManager <> nil then
  begin
    LazUnregisterSkinChangeHandler(Self);
    FSkinManager.RemoveFreeNotification(Self);
    FSkinManager := nil;
  end;
  if FRibbon <> nil then
  begin
    FRibbon.RemoveFreeNotification(Self);
    FRibbon := nil;
  end;
  FreeAndNil(FTitleIcon);
  inherited Destroy;
end;

procedure TLazRibbonForm.RemoveAccidentalStreamedTitleBars;
var
  I: Integer;
  C: TComponent;
  Ctrl: TControl;
begin
  { Defensive repair for .lfm files that may have been saved while the internal
    TLazRibbonTitleBar was accidentally treated as a normal owned child.  Such
    entries are not part of the public API and can also cause EClassNotFound in
    applications that did not register the internal class. }
  for I := ComponentCount - 1 downto 0 do
  begin
    C := Components[I];
    if (C is TLazRibbonTitleBar) and (C <> FTitleBar) then
      C.Free;
  end;

  for I := ControlCount - 1 downto 0 do
  begin
    Ctrl := Controls[I];
    if (Ctrl is TLazRibbonTitleBar) and (Ctrl <> FTitleBar) then
      Ctrl.Free;
  end;
end;

procedure TLazRibbonForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  { While the Office-like KeyTips overlay is active, Backspace is part of the
    KeyTip prefix editor.  In real forms the focus is often in a client control
    rather than in TLazRibbon itself, so TLazRibbonForm handles Backspace before
    the focused child can consume it. }
  if (Key = VK_BACK) and (FRibbon <> nil) and FRibbon.KeyTipsVisible and
     FRibbon.ProcessKeyTipsBackspace then
  begin
    Key := 0;
    Exit;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TLazRibbonForm.KeyPress(var Key: Char);
begin
  { Some LCL widgetsets deliver Backspace as #8 in KeyPress.  Keep the same
    fallback at form level because TLazRibbon may not be the focused control. }
  if (Key = #8) and (FRibbon <> nil) and FRibbon.KeyTipsVisible and
     FRibbon.ProcessKeyTipsBackspace then
  begin
    Key := #0;
    Exit;
  end;

  inherited KeyPress(Key);
end;

procedure TLazRibbonForm.Loaded;
begin
  inherited Loaded;
  RemoveAccidentalStreamedTitleBars;

  { Capture the border style that was actually streamed from the .lfm before
    the custom chrome removes the native frame.  The resize policy must be
    based on the developer's original form style, not on the run-time bsNone
    style used internally by TLazRibbonForm. }
  if (not (csDesigning in ComponentState)) and (BorderStyle <> bsNone) then
    FOriginalBorderStyle := BorderStyle;

  { TLazRibbonForm hosts the title-bar QAT and custom chrome, and is the only
    safe place to catch keys that focused child controls may consume.  Enable
    form-level key preview so Backspace can edit an active KeyTip prefix. }
  if not (csDesigning in ComponentState) and FUseCustomTitleBar and (FRibbon <> nil) then
    KeyPreview := True;

  UpdateChrome;
end;

procedure TLazRibbonForm.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    { The current internal title bar is no longer owned by the form.  This
      branch remains defensive for older or experimental builds in which a
      title bar might still arrive through component notification. }
    if AComponent = FTitleBar then
    begin
      FTitleBar := nil;
      Exit;
    end;

    if AComponent = FRibbon then
      FRibbon := nil;
    if AComponent = FSkinManager then
    begin
      if not (csDestroying in ComponentState) then
        LazUnregisterSkinChangeHandler(Self);
      FSkinManager := nil;
    end;

    SafeInvalidateTitleBar;
  end;
end;

procedure TLazRibbonForm.SafeInvalidateTitleBar;
begin
  if csDestroying in ComponentState then Exit;
  if FTitleBar = nil then Exit;
  if csDestroying in FTitleBar.ComponentState then Exit;
  if FTitleBar.HandleAllocated then
    FTitleBar.Invalidate;
end;

procedure TLazRibbonForm.RequestCloseFromTitleBar;
begin
  if FClosingFromTitleBar then Exit;
  if csDestroying in ComponentState then Exit;
  FClosingFromTitleBar := True;

  { Closing from a client-area custom caption is dangerous if the title-bar
    control remains the mouse-capture target while the main form is destroyed.
    Detach it before posting WM_CLOSE so any late mouse/hint messages cannot
    call back into a half-destroyed TLazRibbonForm. }
  if FTitleBar <> nil then
  begin
    try
      FTitleBar.MouseCapture := False;
    except
    end;
    FTitleBar.FOwnerForm := nil;
    FTitleBar.Enabled := False;
  end;

  if HandleAllocated then
    LCLIntf.PostMessage(Handle, LR_WM_CLOSE, 0, 0);
end;

procedure TLazRibbonForm.MinimizeFromTitleBar;
begin
  if csDestroying in ComponentState then Exit;

  { Use the native system command on Windows instead of only assigning
    WindowState.  With the custom title bar we have removed the native caption,
    but the top-level window still owns the taskbar entry and the system menu.
    Posting SC_MINIMIZE keeps minimize/restore behavior on the same path used by
    the normal Windows caption button. }
  if HandleAllocated then
  begin
    {$IFDEF MSWINDOWS}
    LCLIntf.PostMessage(Handle, LR_WM_SYSCOMMAND, LR_SC_MINIMIZE, 0);
    {$ELSE}
    WindowState := wsMinimized;
    {$ENDIF}
  end
  else
    WindowState := wsMinimized;
end;

procedure TLazRibbonForm.CMTextChanged(var Message: TLMessage);
begin
  inherited;
  SafeInvalidateTitleBar;
end;

function TLazRibbonForm.EffectiveSkinManager: TLazRibbonSkinManager;
begin
  Result := nil;
  if csDestroying in ComponentState then
    Exit;

  if (FSkinManager <> nil) and
     not (csDestroying in FSkinManager.ComponentState) then
    Result := FSkinManager;

  if (Result = nil) and (FRibbon <> nil) and
     not (csDestroying in FRibbon.ComponentState) then
    Result := FRibbon.SkinManager;

  if (Result <> nil) and (csDestroying in Result.ComponentState) then
    Result := nil;
end;

{$IFDEF MSWINDOWS}
procedure TLazRibbonForm.CreateWnd;
begin
  inherited CreateWnd;
  ApplyCustomChromeWindowStyle;
end;

procedure TLazRibbonForm.ApplyCustomChromeWindowStyle;
var
  Style: LongInt;
  ResizeAllowed: Boolean;
begin
  if (csDesigning in ComponentState) or (csDestroying in ComponentState) then
    Exit;
  if (not FUseCustomTitleBar) or (not HandleAllocated) then
    Exit;

  ResizeAllowed := FOriginalBorderStyle in [bsSizeable, bsSizeToolWin];

  { Keep a real Windows top-level frame policy instead of relying on a pure
    BorderStyle=bsNone window.  A fully borderless form lets child controls cover
    the whole client area, so only the form itself may see WM_NCHITTEST; edge and
    corner resizing then becomes unreliable in Lazarus/LCL applications.

    The robust composition is: the LCL form remains sizeable when the developer
    designed it as sizeable, the native caption is removed, and the sizing frame
    is preserved.  The client-area TLazRibbonTitleBar still paints the visible
    title/QAT/system-button chrome. }
  Style := Windows.GetWindowLong(Handle, GWL_STYLE);
  Style := Style and not WS_CAPTION;
  Style := Style or WS_SYSMENU;

  if ResizeAllowed then
    Style := Style or WS_THICKFRAME or WS_SIZEBOX
  else
    Style := Style and not (WS_THICKFRAME or WS_SIZEBOX);

  if FShowSystemButtons then
  begin
    Style := Style or WS_MINIMIZEBOX;
    if ResizeAllowed then
      Style := Style or WS_MAXIMIZEBOX
    else
      Style := Style and not WS_MAXIMIZEBOX;
  end
  else
    Style := Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);

  Windows.SetWindowLong(Handle, GWL_STYLE, Style);
  Windows.SetWindowPos(Handle, 0, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_NOACTIVATE or
    SWP_FRAMECHANGED);
end;

function TLazRibbonForm.CustomChromeHitTest(const AScreenPoint: TPoint): PtrInt;
var
  P: TPoint;
  Edge: Integer;
  AtLeft, AtRight, AtTop, AtBottom: Boolean;
  ResizeAllowed: Boolean;
begin
  Result := HTCLIENT;
  if (csDestroying in ComponentState) or (not FUseCustomTitleBar) or
     (WindowState <> wsNormal) then
    Exit;

  ResizeAllowed := FOriginalBorderStyle in [bsSizeable, bsSizeToolWin];
  if not ResizeAllowed then
    Exit;

  P := ScreenToClient(AScreenPoint);
  Edge := 8;

  AtLeft := P.X <= Edge;
  AtRight := P.X >= ClientWidth - Edge - 1;
  AtTop := P.Y <= Edge;
  AtBottom := P.Y >= ClientHeight - Edge - 1;

  if AtTop and AtLeft then
    Result := HTTOPLEFT
  else if AtTop and AtRight then
    Result := HTTOPRIGHT
  else if AtBottom and AtLeft then
    Result := HTBOTTOMLEFT
  else if AtBottom and AtRight then
    Result := HTBOTTOMRIGHT
  else if AtLeft then
    Result := HTLEFT
  else if AtRight then
    Result := HTRIGHT
  else if AtTop then
    Result := HTTOP
  else if AtBottom then
    Result := HTBOTTOM;
end;

procedure TLazRibbonForm.WMNCHitTest(var Message: TLMessage);
var
  ScreenP: TPoint;
  Hit: PtrInt;
begin
  inherited;
  ScreenP := Types.Point(
    SmallInt(PtrUInt(Message.LParam) and $FFFF),
    SmallInt((PtrUInt(Message.LParam) shr 16) and $FFFF));
  Hit := CustomChromeHitTest(ScreenP);
  if Hit <> HTCLIENT then
    Message.Result := Hit;
end;
{$ENDIF}

function TLazRibbonForm.BackstageClientOverlayActive: Boolean;
var
  Backstage: TCustomControl;
begin
  Result := False;
  if csDestroying in ComponentState then Exit;
  if (FRibbon = nil) or (FRibbon.BackstageView = nil) then Exit;

  Backstage := FRibbon.BackstageView;
  Result :=
    Backstage.Visible and
    (Backstage.Parent = Self) and
    (Backstage.Left <= 0) and
    (Backstage.Top <= 0) and
    (Backstage.Width >= ClientWidth) and
    (Backstage.Height >= ClientHeight);
end;

function TLazRibbonForm.BackstageClientOverlayColor: TColor;
begin
  Result := clWhite;
  if (FRibbon <> nil) and (FRibbon.BackstageView <> nil) then
    Result := FRibbon.BackstageView.Color;
  if Result = clDefault then
    Result := clWhite;
end;

procedure TLazRibbonForm.SetRibbon(AValue: TLazRibbon);
begin
  if FRibbon = AValue then Exit;
  if FRibbon <> nil then
    FRibbon.RemoveFreeNotification(Self);
  FRibbon := AValue;
  if FRibbon <> nil then
  begin
    FRibbon.FreeNotification(Self);
    if (FSkinManager <> nil) and (FRibbon.SkinManager = nil) then
      FRibbon.SkinManager := FSkinManager;
  end;
  if not (csDesigning in ComponentState) and FUseCustomTitleBar and (FRibbon <> nil) then
    KeyPreview := True;
  SafeInvalidateTitleBar;
end;

procedure TLazRibbonForm.SetSkinManager(AValue: TLazRibbonSkinManager);
begin
  if FSkinManager = AValue then Exit;
  if FSkinManager <> nil then
  begin
    LazUnregisterSkinChangeHandler(Self);
    FSkinManager.RemoveFreeNotification(Self);
  end;
  FSkinManager := AValue;
  if FSkinManager <> nil then
  begin
    FSkinManager.FreeNotification(Self);
    LazRegisterSkinChangeHandler(Self, SkinManagerChanged);
    if (FRibbon <> nil) and (FRibbon.SkinManager = nil) then
      FRibbon.SkinManager := FSkinManager;
  end;
  SafeInvalidateTitleBar;
end;

procedure TLazRibbonForm.SetShowSystemButtons(AValue: Boolean);
begin
  if FShowSystemButtons = AValue then Exit;
  FShowSystemButtons := AValue;
  SafeInvalidateTitleBar;
end;

procedure TLazRibbonForm.SetShowTitleIcon(AValue: Boolean);
begin
  if FShowTitleIcon = AValue then Exit;
  FShowTitleIcon := AValue;
  SafeInvalidateTitleBar;
end;

procedure TLazRibbonForm.SetTitleIcon(AValue: TIcon);
begin
  if FTitleIcon = nil then
    FTitleIcon := TIcon.Create;
  FTitleIcon.Assign(AValue);
  SafeInvalidateTitleBar;
end;

procedure TLazRibbonForm.SetTitleAlignment(AValue: TAlignment);
begin
  if FTitleAlignment = AValue then Exit;
  FTitleAlignment := AValue;
  SafeInvalidateTitleBar;
end;

procedure TLazRibbonForm.SetTitleBarHeight(AValue: Integer);
begin
  if AValue < 24 then AValue := 24;
  if AValue > 64 then AValue := 64;
  if FTitleBarHeight = AValue then Exit;
  FTitleBarHeight := AValue;
  UpdateChrome;
end;

procedure TLazRibbonForm.SetUseCustomTitleBar(AValue: Boolean);
begin
  if FUseCustomTitleBar = AValue then Exit;
  if AValue and (BorderStyle <> bsNone) then
    FOriginalBorderStyle := BorderStyle;
  FUseCustomTitleBar := AValue;
  UpdateChrome;
end;

procedure TLazRibbonForm.SkinManagerChanged(Sender: TObject);
begin
  SafeInvalidateTitleBar;
end;

procedure TLazRibbonForm.UpdateChrome;
begin
  if csDestroying in ComponentState then Exit;

  if not (csDesigning in ComponentState) and FUseCustomTitleBar and (FRibbon <> nil) then
    KeyPreview := True;

  if FTitleBar <> nil then
  begin
    FTitleBar.Visible := FUseCustomTitleBar;
    FTitleBar.Height := FTitleBarHeight;
    FTitleBar.Align := alTop;
    SafeInvalidateTitleBar;
  end;

  { Keep the designer easier to handle.  At run time, Windows builds keep the
    original LCL border policy and remove only the native caption through window
    styles.  This preserves a real sizing frame for bsSizeable forms while the
    client-area title bar remains the visible chrome.  Non-Windows platforms keep
    the older pure client-area fallback. }
  if not (csDesigning in ComponentState) then
  begin
    if FUseCustomTitleBar then
    begin
      {$IFDEF MSWINDOWS}
      if FOriginalBorderStyle <> bsNone then
        BorderStyle := FOriginalBorderStyle
      else
        BorderStyle := bsSizeable;
      ApplyCustomChromeWindowStyle;
      {$ELSE}
      BorderStyle := bsNone;
      {$ENDIF}
    end
    else
      BorderStyle := FOriginalBorderStyle;
  end;
end;

initialization
  { Keep the runtime able to read old/stale .lfm files that may contain the
    internal title-bar class after a design-time save.  New .lfm files should
    not contain TLazRibbonTitleBar because TLazRibbonForm now creates it with
    Owner=nil. }
  Classes.RegisterClass(TLazRibbonTitleBar);

end.
