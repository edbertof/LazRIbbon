unit LazRibbon_ControlItems;

{$mode delphi}{$H+}

{ LazRibbon native LCL items. Modified LGPL with linking exception;
  see LICENSE.txt. Controls are owned by their item and are recreated from
  the item's published properties, never streamed as extra form components. }

interface

uses
  Classes, SysUtils, Types, Controls, Graphics, StdCtrls, Spin, ComCtrls, Forms, LCLType,
  LazRibbon_BaseItem, LazRibbon_Types, LazRibbon_Math, LazRibbon_Buttons,
  LazRibbon_Popup;

type
  TLazRibbonCustomControlItem = class abstract(TLazRibbonBaseItem)
  private
    FControl: TControl;
    FCaption: TCaption;
    FWidth: Integer;
    FLayout: TLazRibbonItemTableBehaviour;
    procedure SetWidth(AValue: Integer);
    procedure SetLayout(AValue: TLazRibbonItemTableBehaviour);
  protected
    function CreateControl: TControl; virtual; abstract;
    procedure SetCaption(const AValue: TCaption); virtual;
    procedure UpdateControl;
    procedure Loaded; override;
    procedure SetRect(const Value: T2DIntRect); override;
    procedure SetEnabled(const Value: Boolean); override;
    procedure SetVisible(const Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetParentComponent(Value: TComponent); override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notify(Item: TComponent; Operation: TOperation); override;
    function ExecuteKeyTip: Boolean; override;
    function GetWidth: Integer; override;
    function GetSize: TLazRibbonItemSize; override;
    function GetTableBehaviour: TLazRibbonItemTableBehaviour; override;
    function GetGroupBehaviour: TLazRibbonItemGroupBehaviour; override;
    procedure Draw(ABuffer: TBitmap; ClipRect: T2DIntRect); override;
    property Control: TControl read FControl;
  published
    property Caption: TCaption read FCaption write SetCaption;
    property Width: Integer read FWidth write SetWidth default 120;
    property Layout: TLazRibbonItemTableBehaviour read FLayout write SetLayout default tbBeginsRow;
  end;

  TLazRibbonCustomInputItem = class abstract(TLazRibbonCustomControlItem)
  private
    FOnChange: TNotifyEvent;
  protected
    procedure ControlChange(Sender: TObject);
    procedure DoChange; virtual;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TLazRibbonEditItem = class(TLazRibbonCustomInputItem)
  private
    function GetText: TCaption;
    procedure SetText(const AValue: TCaption);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(AValue: Boolean);
  protected
    function CreateControl: TControl; override;
  published
    property Text: TCaption read GetText write SetText;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

  TLazRibbonComboBoxItem = class(TLazRibbonCustomInputItem)
  private
    FChanging: Boolean;
    function IsTextStored: Boolean;
    function GetItems: TStrings;
    procedure SetItems(AValue: TStrings);
    function GetItemIndex: Integer;
    procedure SetItemIndex(AValue: Integer);
    function GetText: TCaption;
    procedure SetText(const AValue: TCaption);
    function GetStyle: TComboBoxStyle;
    procedure SetStyle(AValue: TComboBoxStyle);
  protected
    function CreateControl: TControl; override;
    procedure DoChange; override;
  published
    property Items: TStrings read GetItems write SetItems;
    property Style: TComboBoxStyle read GetStyle write SetStyle default csDropDownList;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex default -1;
    property Text: TCaption read GetText write SetText stored IsTextStored;
  end;

  TLazRibbonSpinEditItem = class(TLazRibbonCustomInputItem)
  private
    function GetValue: Integer;
    procedure SetValue(AValue: Integer);
    function GetMinValue: Integer;
    procedure SetMinValue(AValue: Integer);
    function GetMaxValue: Integer;
    procedure SetMaxValue(AValue: Integer);
    function GetIncrement: Integer;
    procedure SetIncrement(AValue: Integer);
  protected
    function CreateControl: TControl; override;
  published
    property MinValue: Integer read GetMinValue write SetMinValue default 0;
    property MaxValue: Integer read GetMaxValue write SetMaxValue default 100;
    property Increment: Integer read GetIncrement write SetIncrement default 1;
    property Value: Integer read GetValue write SetValue default 0;
  end;

  TLazRibbonFontNameComboBoxItem = class(TLazRibbonCustomInputItem)
  private
    FFontName: TFontName;
    FShowFontPreview: Boolean;
    FUpdatingFonts: Boolean;
    function GetItems: TStrings;
    function GetDropDownCount: Integer;
    procedure SetDropDownCount(AValue: Integer);
    procedure SetFontName(const AValue: TFontName);
    procedure SetShowFontPreview(AValue: Boolean);
    procedure FontSelectionChanged(Sender: TObject);
    procedure DrawFontItem(AControl: TWinControl; AIndex: Integer;
      ARect: TRect; AState: TOwnerDrawState);
  protected
    function CreateControl: TControl; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshFonts;
    { System-derived options are not persisted in the form resource. }
    property Items: TStrings read GetItems;
  published
    property FontName: TFontName read FFontName write SetFontName;
    property ShowFontPreview: Boolean read FShowFontPreview write SetShowFontPreview default True;
    property DropDownCount: Integer read GetDropDownCount write SetDropDownCount default 12;
  end;

  TLazRibbonDateEditItem = class(TLazRibbonCustomInputItem)
  private
    function GetDate: TDateTime;
    procedure SetDate(AValue: TDateTime);
    function GetHasDate: Boolean;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(AValue: Boolean);
  protected
    function CreateControl: TControl; override;
  public
    function ExecuteKeyTip: Boolean; override;
    procedure Clear;
    property HasDate: Boolean read GetHasDate;
  published
    property Date: TDateTime read GetDate write SetDate nodefault;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

  TLazRibbonColorOption = (coAutomatic, coThemeColors, coThemeShades,
    coStandardColors, coHighContrast, coMoreColors, coNoColor, coGradients);
  TLazRibbonColorOptions = set of TLazRibbonColorOption;

  TLazRibbonColorSwatch = class(TCollectionItem)
  private
    FCaption: string;
    FColor: TColor;
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: string read FCaption write FCaption;
    property Color: TColor read FColor write FColor default clBlack;
  end;

  TLazRibbonColorSwatches = class(TOwnedCollection)
  private
    function GetSwatch(AIndex: Integer): TLazRibbonColorSwatch;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TLazRibbonColorSwatch;
    property Items[AIndex: Integer]: TLazRibbonColorSwatch read GetSwatch; default;
  end;

  TLazRibbonColorCaptions = class(TPersistent)
  private
    FAutomatic: string;
    FTheme: string;
    FStandard: string;
    FHighContrast: string;
    FMoreColors: string;
    FNoColor: string;
    FGradient: string;
    FLighterGradient: string;
    FDarkerGradient: string;
    FSolidColor: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Automatic: string read FAutomatic write FAutomatic;
    property Theme: string read FTheme write FTheme;
    property Standard: string read FStandard write FStandard;
    property HighContrast: string read FHighContrast write FHighContrast;
    property MoreColors: string read FMoreColors write FMoreColors;
    property NoColor: string read FNoColor write FNoColor;
    property Gradient: string read FGradient write FGradient;
    property LighterGradient: string read FLighterGradient write FLighterGradient;
    property DarkerGradient: string read FDarkerGradient write FDarkerGradient;
    property SolidColor: string read FSolidColor write FSolidColor;
  end;

  TLazRibbonColorComboBoxItem = class(TLazRibbonSmallButton)
  private
    FMenu: TLazRibbonPopupMenu;
    FOptions: TLazRibbonColorOptions;
    FThemeColors: TLazRibbonColorSwatches;
    FStandardColors: TLazRibbonColorSwatches;
    FPaletteCaptions: TLazRibbonColorCaptions;
    FAutomaticColor: TColor;
    FSelectedColor: TColor;
    FGradientColor: TColor;
    FContrastBackground: TColor;
    FMinimumContrast: Single;
    FHighContrastOnly: Boolean;
    FOpenGradientPalette: Boolean;
    FColumns: Integer;
    FSwatchSize: Integer;
    FMaxPopupHeight: Integer;
    FOnChange: TNotifyEvent;
    FOnApply: TNotifyEvent;
    function GetEffectiveColor: TColor;
    procedure SetThemeColors(AValue: TLazRibbonColorSwatches);
    procedure SetStandardColors(AValue: TLazRibbonColorSwatches);
    procedure SetPaletteCaptions(AValue: TLazRibbonColorCaptions);
    procedure SetAutomaticColor(AValue: TColor);
    procedure SetSelectedColor(AValue: TColor);
    procedure SetGradientColor(AValue: TColor);
    function IsMinimumContrastStored: Boolean;
    procedure SetMinimumContrast(AValue: Single);
    procedure SetColumns(AValue: Integer);
    procedure SetSwatchSize(AValue: Integer);
    procedure SetMaxPopupHeight(AValue: Integer);
    procedure PreparePalette(Sender: TObject);
    procedure PaletteSelect(Sender: TObject; Entry: TLazRibbonPopupEntry);
    procedure ApplyContrastFilter;
    procedure OpenGradients;
    procedure CommitColor(AColor, AGradientColor: TColor);
    procedure InvalidateColor;
  protected
    function GetDefaultCaption: String; override;
    function HasDefaultGlyph: Boolean; override;
    function IsDropdownMenuStored: Boolean; override;
    procedure DrawDefaultGlyph(ACanvas: TCanvas; const ARect: TRect;
      AColor: TColor); override;
    procedure Click; override;
    procedure SetRect(const Value: T2DIntRect); override;
    procedure SetEnabled(const Value: Boolean); override;
    procedure SetVisible(const Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteKeyTip: Boolean; override;
    procedure ResetDropdownMenu;
    property EffectiveColor: TColor read GetEffectiveColor;
  published
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clDefault;
    property AutomaticColor: TColor read FAutomaticColor write SetAutomaticColor default clWindowText;
    property GradientColor: TColor read FGradientColor write SetGradientColor default clNone;
    property Options: TLazRibbonColorOptions read FOptions write FOptions
      default [coAutomatic, coThemeColors, coThemeShades, coStandardColors, coHighContrast, coMoreColors, coGradients];
    property ThemeColors: TLazRibbonColorSwatches read FThemeColors write SetThemeColors;
    property StandardColors: TLazRibbonColorSwatches read FStandardColors write SetStandardColors;
    property PaletteCaptions: TLazRibbonColorCaptions read FPaletteCaptions write SetPaletteCaptions;
    property HighContrastOnly: Boolean read FHighContrastOnly write FHighContrastOnly default False;
    property ContrastBackground: TColor read FContrastBackground write FContrastBackground default clWindow;
    property MinimumContrast: Single read FMinimumContrast write SetMinimumContrast stored IsMinimumContrastStored;
    property Columns: Integer read FColumns write SetColumns default 10;
    property SwatchSize: Integer read FSwatchSize write SetSwatchSize default 28;
    property MaxPopupHeight: Integer read FMaxPopupHeight write SetMaxPopupHeight default 440;
    property ShowCaption default False;
    property ButtonKind default bkButtonDropdown;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
  end;

  TLazRibbonStaticTextItem = class(TLazRibbonCustomControlItem)
  private
    function GetAlignment: TAlignment;
    procedure SetAlignment(AValue: TAlignment);
  protected
    function CreateControl: TControl; override;
    procedure SetCaption(const AValue: TCaption); override;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment default taLeftJustify;
  end;

  TLazRibbonProgressBarItem = class(TLazRibbonCustomControlItem)
  private
    function GetMin: Integer;
    procedure SetMin(AValue: Integer);
    function GetMax: Integer;
    procedure SetMax(AValue: Integer);
    function GetPosition: Integer;
    procedure SetPosition(AValue: Integer);
  protected
    function CreateControl: TControl; override;
  published
    property Min: Integer read GetMin write SetMin default 0;
    property Max: Integer read GetMax write SetMax default 100;
    property Position: Integer read GetPosition write SetPosition default 0;
  end;

implementation

uses
  Dialogs, EditBtn, ExtDlgs, Math, StrUtils, LazRibbon_GraphTools, LazRibbon_SkinDefinition;

resourcestring
  RSColorCombo = 'Color';
  RSAutomatic = 'Automatic';
  RSThemeColors = 'Theme Colors';
  RSStandardColors = 'Standard Colors';
  RSHighContrast = 'High contrast only';
  RSMoreColors = 'More Colors...';
  RSNoColor = 'No Color';
  RSGradients = 'Gradient';
  RSLighterGradient = 'Light Variations';
  RSDarkerGradient = 'Dark Variations';
  RSSolidColor = 'Solid Color';

const
  DefaultThemeColors: array[0..9] of TColor = (clWhite, clBlack, $00E3E3E3,
    $00635844, $00C47244, $00317DED, $00A5A5A5, $0000C0FF, $00D59B5B, $0047AD70);
  DefaultStandardColors: array[0..9] of TColor = ($000000C0, clRed, $0000C0FF,
    clYellow, $0050D092, $0050B000, $00F0B000, $00C07000, $00602000, $00A03070);

type
  TRibbonDateEdit = class(TDateEdit)
  protected
    procedure ButtonClick; override;
    procedure EditKeyDown(var Key: Word; Shift: TShiftState); override;
  end;

  TColorPaletteCommand = (cpcAutomatic, cpcNoColor, cpcMoreColors, cpcGradient,
    cpcSolid, cpcContrast);

function TLazRibbonColorSwatch.GetDisplayName: string;
begin
  if Caption <> '' then
    Result := Caption
  else
    Result := ColorToString(Color);
end;

procedure TLazRibbonColorSwatch.Assign(Source: TPersistent);
begin
  if Source is TLazRibbonColorSwatch then
  begin
    FCaption := TLazRibbonColorSwatch(Source).Caption;
    FColor := TLazRibbonColorSwatch(Source).Color;
  end
  else
    inherited Assign(Source);
end;

constructor TLazRibbonColorSwatches.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TLazRibbonColorSwatch);
end;

function TLazRibbonColorSwatches.GetSwatch(AIndex: Integer): TLazRibbonColorSwatch;
begin
  Result := TLazRibbonColorSwatch(inherited Items[AIndex]);
end;

function TLazRibbonColorSwatches.Add: TLazRibbonColorSwatch;
begin
  Result := TLazRibbonColorSwatch(inherited Add);
end;

procedure TLazRibbonColorCaptions.Assign(Source: TPersistent);
var
  Captions: TLazRibbonColorCaptions;
begin
  if not (Source is TLazRibbonColorCaptions) then
  begin
    inherited Assign(Source);
    Exit;
  end;
  Captions := TLazRibbonColorCaptions(Source);
  FAutomatic := Captions.Automatic;
  FTheme := Captions.Theme;
  FStandard := Captions.Standard;
  FHighContrast := Captions.HighContrast;
  FMoreColors := Captions.MoreColors;
  FNoColor := Captions.NoColor;
  FGradient := Captions.Gradient;
  FLighterGradient := Captions.LighterGradient;
  FDarkerGradient := Captions.DarkerGradient;
  FSolidColor := Captions.SolidColor;
end;

constructor TLazRibbonColorComboBoxItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ButtonKind := bkButtonDropdown;
  ShowCaption := False;
  FSelectedColor := clDefault;
  FAutomaticColor := clWindowText;
  FGradientColor := clNone;
  FContrastBackground := clWindow;
  FMinimumContrast := 4.5;
  FColumns := 10;
  FSwatchSize := 28;
  FMaxPopupHeight := 440;
  FOptions := [coAutomatic, coThemeColors, coThemeShades, coStandardColors,
    coHighContrast, coMoreColors, coGradients];
  FThemeColors := TLazRibbonColorSwatches.Create(Self);
  FStandardColors := TLazRibbonColorSwatches.Create(Self);
  FPaletteCaptions := TLazRibbonColorCaptions.Create;
  FMenu := TLazRibbonPopupMenu.Create(Self);
  FMenu.Gallery.Enabled := True;
  FMenu.Gallery.ShowCaptions := False;
  FMenu.OnPopup := PreparePalette;
  FMenu.OnGallerySelect := PaletteSelect;
  DropdownMenu := FMenu;
end;

destructor TLazRibbonColorComboBoxItem.Destroy;
begin
  Destroying;
  FMenu.Free;
  FThemeColors.Free;
  FStandardColors.Free;
  FPaletteCaptions.Free;
  inherited Destroy;
end;

function TLazRibbonColorComboBoxItem.GetDefaultCaption: String;
begin
  Result := RSColorCombo;
end;

function TLazRibbonColorComboBoxItem.HasDefaultGlyph: Boolean;
begin
  Result := True;
end;

function TLazRibbonColorComboBoxItem.IsDropdownMenuStored: Boolean;
begin
  Result := DropdownMenu <> FMenu;
end;

procedure TLazRibbonColorComboBoxItem.ResetDropdownMenu;
begin
  DropdownMenu := FMenu;
end;

function TLazRibbonColorComboBoxItem.GetEffectiveColor: TColor;
begin
  Result := FSelectedColor;
  if Result = clDefault then
    Result := FAutomaticColor;
end;

procedure TLazRibbonColorComboBoxItem.InvalidateColor;
begin
  if ToolbarDispatch <> nil then
    ToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonColorComboBoxItem.SetThemeColors(AValue: TLazRibbonColorSwatches);
begin
  if (AValue <> nil) and (AValue <> FThemeColors) then
    FThemeColors.Assign(AValue);
end;

procedure TLazRibbonColorComboBoxItem.SetStandardColors(AValue: TLazRibbonColorSwatches);
begin
  if (AValue <> nil) and (AValue <> FStandardColors) then
    FStandardColors.Assign(AValue);
end;

procedure TLazRibbonColorComboBoxItem.SetPaletteCaptions(AValue: TLazRibbonColorCaptions);
begin
  if (AValue <> nil) and (AValue <> FPaletteCaptions) then
    FPaletteCaptions.Assign(AValue);
end;

procedure TLazRibbonColorComboBoxItem.SetAutomaticColor(AValue: TColor);
begin
  if FAutomaticColor = AValue then Exit;
  FAutomaticColor := AValue;
  InvalidateColor;
end;

procedure TLazRibbonColorComboBoxItem.SetSelectedColor(AValue: TColor);
begin
  if FSelectedColor = AValue then Exit;
  FSelectedColor := AValue;
  if not (csLoading in ComponentState) then
    FGradientColor := clNone;
  InvalidateColor;
end;

procedure TLazRibbonColorComboBoxItem.SetGradientColor(AValue: TColor);
begin
  if FGradientColor = AValue then Exit;
  FGradientColor := AValue;
  InvalidateColor;
end;

procedure TLazRibbonColorComboBoxItem.SetMinimumContrast(AValue: Single);
begin
  if not IsNan(AValue) then
    FMinimumContrast := EnsureRange(AValue, 1.0, 21.0);
end;

function TLazRibbonColorComboBoxItem.IsMinimumContrastStored: Boolean;
begin
  Result := FMinimumContrast <> 4.5;
end;

procedure TLazRibbonColorComboBoxItem.SetColumns(AValue: Integer);
begin
  FColumns := EnsureRange(AValue, 4, 16);
end;

procedure TLazRibbonColorComboBoxItem.SetSwatchSize(AValue: Integer);
begin
  FSwatchSize := EnsureRange(AValue, 18, 64);
end;

procedure TLazRibbonColorComboBoxItem.SetMaxPopupHeight(AValue: Integer);
begin
  FMaxPopupHeight := EnsureRange(AValue, 64, 2048);
end;

procedure TLazRibbonColorComboBoxItem.SetRect(const Value: T2DIntRect);
begin
  inherited SetRect(Value);
  if (FMenu <> nil) and ((Value.Width <= 0) or (Value.Height <= 0)) then
    FMenu.Close;
end;

procedure TLazRibbonColorComboBoxItem.SetEnabled(const Value: Boolean);
begin
  inherited SetEnabled(Value);
  if (FMenu <> nil) and not Value then FMenu.Close;
end;

procedure TLazRibbonColorComboBoxItem.SetVisible(const Value: Boolean);
begin
  inherited SetVisible(Value);
  if (FMenu <> nil) and not Value then FMenu.Close;
end;

procedure TLazRibbonColorComboBoxItem.DrawDefaultGlyph(ACanvas: TCanvas;
  const ARect: TRect; AColor: TColor);
var
  Bar: TRect;

  function GlyphPoint(X, Y: Integer): TPoint;
  begin
    // Scale the coordinates from a 16 x 16 glyph to the current button size.
    Result := Point(ARect.Left + (X * ARect.Width + 8) div 16,
      ARect.Top + (Y * ARect.Height + 8) div 16);
  end;

begin
  ACanvas.Pen.Style := psClear;
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := AColor;
  ACanvas.Polygon([GlyphPoint(7, 2), GlyphPoint(9, 2), GlyphPoint(13, 12),
    GlyphPoint(11, 12), GlyphPoint(8, 4), GlyphPoint(5, 12), GlyphPoint(3, 12)]);
  ACanvas.FillRect(TRect.Create(GlyphPoint(5, 8), GlyphPoint(11, 10)));

  Bar := TRect.Create(GlyphPoint(0, 12), ARect.BottomRight);
  if not Enabled or (EffectiveColor = clNone) then
  begin
    if EffectiveColor = clNone then
      ACanvas.FrameRect(Bar)
    else
      ACanvas.FillRect(Bar);
  end
  else if FGradientColor <> clNone then
  begin
    // GradientFill draws the band with the canvas pen.
    ACanvas.Pen.Style := psSolid;
    ACanvas.GradientFill(Bar, EffectiveColor, FGradientColor, gdHorizontal);
  end
  else
  begin
    ACanvas.Brush.Color := EffectiveColor;
    ACanvas.FillRect(Bar);
  end;
end;

function TLazRibbonColorComboBoxItem.ExecuteKeyTip: Boolean;
begin
  Result := Enabled and Visible and (Rect.Width > 0) and (Rect.Height > 0)
    and OpenDropdown;
end;

procedure TLazRibbonColorComboBoxItem.Click;
begin
  if csDesigning in ComponentState then Exit;
  if Assigned(FOnApply) then
    FOnApply(Self)
  else
    inherited Click;
end;

procedure TLazRibbonColorComboBoxItem.CommitColor(AColor, AGradientColor: TColor);
begin
  if (FSelectedColor = AColor) and (FGradientColor = AGradientColor) then Exit;
  FSelectedColor := AColor;
  FGradientColor := AGradientColor;
  InvalidateColor;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TLazRibbonColorComboBoxItem.PreparePalette(Sender: TObject);
const
  ShadeLevels: array[0..4] of Integer = (80, 60, 40, -25, -50);
  DarkBaseLevels: array[0..4] of Integer = (50, 35, 25, 15, 5);
  LightBaseLevels: array[0..4] of Integer = (-5, -15, -25, -35, -50);
var
  Entries: TLazRibbonPopupEntries;
  Entry: TLazRibbonPopupEntry;
  ShowGradients: Boolean;

  function AddRow(AKind: TLazRibbonPopupEntryKind; const ACaption: string): TLazRibbonPopupEntry;
  begin
    Result := Entries.Add;
    Result.Kind := AKind;
    Result.Caption := ACaption;
  end;

  function AddCommand(const ACaption: string; ACommand: TColorPaletteCommand): TLazRibbonPopupEntry;
  begin
    Result := AddRow(pekCommand, ACaption);
    Result.Tag := Ord(ACommand);
  end;

  procedure AddColor(AColor: TColor; const ACaption: string; AEndColor: TColor = clNone);
  var
    RGB: TColor;
    Swatch: TLazRibbonPopupEntry;
  begin
    Swatch := AddRow(pekChoice, ACaption);
    Swatch.Color := AColor;
    Swatch.GradientColor := AEndColor;
    Swatch.Checked := (FSelectedColor <> clDefault) and (FSelectedColor <> clNone) and
      (ColorToRGB(AColor) = ColorToRGB(FSelectedColor)) and (AEndColor = FGradientColor);
    if ACaption = '' then
    begin
      RGB := ColorToRGB(AColor);
      if AEndColor <> clNone then RGB := ColorToRGB(AEndColor);
      Swatch.Caption := Format('#%.2x%.2x%.2x', [Red(RGB), Green(RGB), Blue(RGB)]);
    end;
  end;

  procedure AddColors(ASwatches: TLazRibbonColorSwatches; const ADefaults: array of TColor;
    AShadeRow: Integer);
  var
    I, Count, Level: Integer;
    Color: TColor;
    Name: string;
    Luminance: Double;
  begin
    Count := ASwatches.Count;
    if Count = 0 then Count := Length(ADefaults);
    for I := 0 to Count - 1 do
    begin
      if ASwatches.Count = 0 then
      begin
        Color := ADefaults[I];
        Name := '';
      end
      else
      begin
        Color := ASwatches[I].Color;
        Name := ASwatches[I].Caption;
      end;
      if AShadeRow >= 0 then
      begin
        Luminance := LazRelativeLuminance(Color);
        if Luminance < 0.035 then
          Level := DarkBaseLevels[AShadeRow]
        else if Luminance > 0.85 then
          Level := LightBaseLevels[AShadeRow]
        else
          Level := ShadeLevels[AShadeRow];
        if Level > 0 then
          Color := TColorTools.Shade(Color, clWhite, Level)
        else
          Color := TColorTools.Shade(Color, clBlack, -Level);
        Name := '';
      end;
      AddColor(Color, Name);
    end;
  end;

  procedure AddGradientChoices;
  var
    BaseColor: TColor;
    I: Integer;
  begin
    BaseColor := EffectiveColor;
    AddRow(pekHeading, IfThen(PaletteCaptions.LighterGradient <> '',
      PaletteCaptions.LighterGradient, RSLighterGradient));
    for I := 1 to 5 do
      AddColor(BaseColor, '', TColorTools.Shade(BaseColor, clWhite, I * 15));
    AddRow(pekHeading, IfThen(PaletteCaptions.DarkerGradient <> '',
      PaletteCaptions.DarkerGradient, RSDarkerGradient));
    for I := 1 to 5 do
      AddColor(BaseColor, '', TColorTools.Shade(BaseColor, clBlack, I * 15));
    Entry := AddCommand(IfThen(PaletteCaptions.SolidColor <> '',
      PaletteCaptions.SolidColor, RSSolidColor), cpcSolid);
    Entry.Color := BaseColor;
  end;

var
  I, ThemeCount: Integer;
begin
  ShowGradients := FOpenGradientPalette;
  FOpenGradientPalette := False;
  FMenu.Gallery.Columns := FColumns;
  FMenu.Gallery.ItemWidth := FSwatchSize;
  FMenu.Gallery.ItemHeight := FSwatchSize - 2;
  FMenu.Gallery.MaxHeight := FMaxPopupHeight;
  Entries := FMenu.Gallery.Items;
  Entries.Clear;
  FMenu.Gallery.SelectedIndex := -1;
  if ShowGradients then
  begin
    AddGradientChoices;
    Exit;
  end;

  if coHighContrast in FOptions then
  begin
    Entry := AddRow(pekToggle, IfThen(PaletteCaptions.HighContrast <> '',
      PaletteCaptions.HighContrast, RSHighContrast));
    Entry.Tag := Ord(cpcContrast);
    Entry.Checked := FHighContrastOnly;
  end;
  if coAutomatic in FOptions then
  begin
    Entry := AddCommand(IfThen(PaletteCaptions.Automatic <> '',
      PaletteCaptions.Automatic, RSAutomatic), cpcAutomatic);
    Entry.Color := FAutomaticColor;
    Entry.Checked := (FSelectedColor = clDefault) and (FGradientColor = clNone);
  end;
  if coThemeColors in FOptions then
  begin
    AddRow(pekHeading, IfThen(PaletteCaptions.Theme <> '', PaletteCaptions.Theme, RSThemeColors));
    AddColors(FThemeColors, DefaultThemeColors, -1);
    if coThemeShades in FOptions then
    begin
      AddRow(pekSpacer, '');
      ThemeCount := FThemeColors.Count;
      if ThemeCount = 0 then ThemeCount := Length(DefaultThemeColors);
      for I := 0 to High(ShadeLevels) do
      begin
        AddColors(FThemeColors, DefaultThemeColors, I);
        if ThemeCount mod FColumns <> 0 then AddRow(pekSpacer, '');
      end;
    end;
  end;
  if coStandardColors in FOptions then
  begin
    AddRow(pekHeading, IfThen(PaletteCaptions.Standard <> '', PaletteCaptions.Standard, RSStandardColors));
    AddColors(FStandardColors, DefaultStandardColors, -1);
  end;
  if coNoColor in FOptions then
    AddCommand(IfThen(PaletteCaptions.NoColor <> '', PaletteCaptions.NoColor, RSNoColor),
      cpcNoColor).Checked := FSelectedColor = clNone;
  if coMoreColors in FOptions then
    AddCommand(IfThen(PaletteCaptions.MoreColors <> '', PaletteCaptions.MoreColors, RSMoreColors),
      cpcMoreColors);
  if coGradients in FOptions then
  begin
    Entry := AddCommand(IfThen(PaletteCaptions.Gradient <> '', PaletteCaptions.Gradient, RSGradients),
      cpcGradient);
    Entry.Color := EffectiveColor;
    if EffectiveColor <> clNone then
      Entry.GradientColor := TColorTools.Shade(EffectiveColor, clWhite, 65);
    Entry.Enabled := EffectiveColor <> clNone;
  end;
  ApplyContrastFilter;
end;

procedure TLazRibbonColorComboBoxItem.ApplyContrastFilter;
var
  Entry: TLazRibbonPopupEntry;
  I: Integer;
begin
  for I := 0 to FMenu.Gallery.Items.Count - 1 do
  begin
    Entry := FMenu.Gallery.Items[I];
    if Entry.Kind = pekChoice then
      Entry.Enabled := not (FHighContrastOnly and (coHighContrast in FOptions)) or
        (LazContrastRatio(Entry.Color, FContrastBackground) >= FMinimumContrast);
  end;
end;

procedure TLazRibbonColorComboBoxItem.OpenGradients;
begin
  FOpenGradientPalette := True;
  FMenu.PopUp(FMenu.PopupPoint.X, FMenu.PopupPoint.Y);
end;

procedure TLazRibbonColorComboBoxItem.PaletteSelect(Sender: TObject; Entry: TLazRibbonPopupEntry);
var
  Dialog: TColorDialog;
  ChosenColor: TColor;
begin
  if Entry.Kind = pekChoice then
  begin
    CommitColor(Entry.Color, Entry.GradientColor);
    Exit;
  end;
  case TColorPaletteCommand(Entry.Tag) of
    cpcAutomatic: CommitColor(clDefault, clNone);
    cpcNoColor: CommitColor(clNone, clNone);
    cpcSolid: CommitColor(FSelectedColor, clNone);
    cpcContrast:
      begin
        FHighContrastOnly := Entry.Checked;
        ApplyContrastFilter;
      end;
    cpcGradient: OpenGradients;
    cpcMoreColors:
      begin
        Dialog := TColorDialog.Create(nil);
        try
          Dialog.Title := Entry.Caption;
          if EffectiveColor <> clNone then
            Dialog.Color := EffectiveColor;
          if not Dialog.Execute then Exit;
          ChosenColor := Dialog.Color;
        finally
          Dialog.Free;
        end;
        CommitColor(ChosenColor, clNone);
      end;
  end;
end;

constructor TLazRibbonCustomControlItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 120;
  FLayout := tbBeginsRow;
  FControl := CreateControl;
  FControl.Visible := False;
  FControl.AutoSize := False;
  SetCaption(Copy(ClassName, Length('TLazRibbon') + 1, MaxInt));
end;

destructor TLazRibbonCustomControlItem.Destroy;
begin
  Destroying;
  FreeAndNil(FControl);
  inherited Destroy;
end;

procedure TLazRibbonCustomControlItem.Loaded;
begin
  inherited Loaded;
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetParentComponent(Value: TComponent);
begin
  inherited SetParentComponent(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.UpdateControl;
var
  Current: TComponent;
  Host: TWinControl;
  R: TRect;
begin
  if (FControl = nil) or (csDestroying in ComponentState) then Exit;
  Current := Parent;
  while (Current <> nil) and not (Current is TWinControl) do
    if Current is TLazRibbonComponent then
      Current := TLazRibbonComponent(Current).Parent
    else
      Current := Current.Owner;
  Host := TWinControl(Current);
  FControl.Parent := Host;
  R := FRect.ForWinAPI;
  Inc(R.Left, 2);
  Dec(R.Right, 2);
  FControl.Enabled := Enabled;
  FControl.Hint := EffectiveScreenTip;
  FControl.ShowHint := FControl.Hint <> '';
  if (Host = nil) or not Visible or (R.Right <= R.Left) or (R.Bottom <= R.Top) then
  begin
    FControl.Visible := False;
    Exit;
  end;
  FControl.SetBounds(R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top);
  FControl.Visible := True;
end;

procedure TLazRibbonCustomControlItem.SetRect(const Value: T2DIntRect);
begin
  inherited SetRect(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetEnabled(const Value: Boolean);
begin
  inherited SetEnabled(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetVisible(const Value: Boolean);
begin
  inherited SetVisible(Value);
  UpdateControl;
end;

procedure TLazRibbonCustomControlItem.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  if Assigned(FToolbarDispatch) then FToolbarDispatch.NotifyVisualsChanged;
end;

procedure TLazRibbonCustomControlItem.SetWidth(AValue: Integer);
begin
  if AValue < 24 then AValue := 24;
  if FWidth = AValue then Exit;
  FWidth := AValue;
  if Assigned(FToolbarDispatch) then FToolbarDispatch.NotifyMetricsChanged;
end;

procedure TLazRibbonCustomControlItem.SetLayout(AValue: TLazRibbonItemTableBehaviour);
begin
  if FLayout = AValue then Exit;
  FLayout := AValue;
  if Assigned(FToolbarDispatch) then FToolbarDispatch.NotifyMetricsChanged;
end;

function TLazRibbonCustomControlItem.GetWidth: Integer;
begin
  Result := FWidth;
end;

function TLazRibbonCustomControlItem.GetSize: TLazRibbonItemSize;
begin
  Result := isNormal;
end;

function TLazRibbonCustomControlItem.GetTableBehaviour: TLazRibbonItemTableBehaviour;
begin
  Result := FLayout;
end;

function TLazRibbonCustomControlItem.GetGroupBehaviour: TLazRibbonItemGroupBehaviour;
begin
  Result := gbSingleItem;
end;

procedure TLazRibbonCustomControlItem.Draw(ABuffer: TBitmap; ClipRect: T2DIntRect);
begin
  UpdateControl;
end;

function TLazRibbonCustomControlItem.ExecuteKeyTip: Boolean;
begin
  UpdateControl;
  Result := Visible and Enabled and (FControl is TWinControl) and
    TWinControl(FControl).TabStop and TWinControl(FControl).CanFocus;
  if Result then TWinControl(FControl).SetFocus;
end;

procedure TLazRibbonCustomControlItem.MouseLeave;
begin
end;

procedure TLazRibbonCustomControlItem.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then ExecuteKeyTip;
end;

procedure TLazRibbonCustomControlItem.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TLazRibbonCustomControlItem.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TLazRibbonCustomControlItem.Notify(Item: TComponent; Operation: TOperation);
begin
end;

procedure TLazRibbonCustomInputItem.ControlChange(Sender: TObject);
begin
  DoChange;
end;

procedure TLazRibbonCustomInputItem.DoChange;
begin
  if not (csLoading in ComponentState) and not (csDestroying in ComponentState) and
    Assigned(FOnChange) then FOnChange(Self);
end;

procedure TRibbonDateEdit.ButtonClick;
var
  Dialog: TCalendarDialog;
  SelectedDate: TDateTime;
  Accepted: Boolean;
begin
  if ReadOnly or not CanFocus or (csDesigning in ComponentState) then Exit;
  Dialog := TCalendarDialog.Create(nil);
  try
    if Date = NullDate then
      Dialog.Date := SysUtils.Date
    else
      Dialog.Date := Date;
    Accepted := Dialog.Execute;
    SelectedDate := Dialog.Date;
  finally
    Dialog.Free;
  end;
  if Accepted then Date := SelectedDate;
end;

procedure TRibbonDateEdit.EditKeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited EditKeyDown(Key, Shift);
  if ReadOnly then Exit;
  if ((Key = VK_DOWN) and (Shift = [ssAlt])) or ((Key = VK_F4) and (Shift = [])) then
  begin
    Key := 0;
    ButtonClick;
  end
  else if (Key = VK_DELETE) and (Shift = []) then
  begin
    Key := 0;
    Date := NullDate;
  end;
end;

function TLazRibbonDateEditItem.CreateControl: TControl;
var
  Editor: TRibbonDateEdit;
begin
  Editor := TRibbonDateEdit.Create(Self);
  Editor.DirectInput := False;
  Editor.OnChange := ControlChange;
  Result := Editor;
end;

function TLazRibbonDateEditItem.ExecuteKeyTip: Boolean;
var
  Editor: TDateEdit;
begin
  UpdateControl;
  Editor := TDateEdit(Control);
  Result := Visible and Enabled and Editor.TabStop and Editor.CanFocus;
  if Result then Editor.SetFocus;
end;

function TLazRibbonDateEditItem.GetDate: TDateTime;
begin
  Result := TDateEdit(Control).Date;
end;

procedure TLazRibbonDateEditItem.SetDate(AValue: TDateTime);
begin
  if AValue <> NullDate then AValue := Trunc(AValue);
  if AValue <> Date then TDateEdit(Control).Date := AValue;
end;

function TLazRibbonDateEditItem.GetHasDate: Boolean;
begin
  Result := Date <> NullDate;
end;

function TLazRibbonDateEditItem.GetReadOnly: Boolean;
begin
  Result := TDateEdit(Control).ReadOnly;
end;

procedure TLazRibbonDateEditItem.SetReadOnly(AValue: Boolean);
begin
  TDateEdit(Control).ReadOnly := AValue;
end;

procedure TLazRibbonDateEditItem.Clear;
begin
  Date := NullDate;
end;

function TLazRibbonEditItem.CreateControl: TControl;
begin
  Result := TEdit.Create(Self);
  TEdit(Result).OnChange := ControlChange;
end;

function TLazRibbonEditItem.GetText: TCaption;
begin
  Result := TEdit(Control).Text;
end;

procedure TLazRibbonEditItem.SetText(const AValue: TCaption);
begin
  TEdit(Control).Text := AValue;
end;

function TLazRibbonEditItem.GetReadOnly: Boolean;
begin
  Result := TEdit(Control).ReadOnly;
end;

procedure TLazRibbonEditItem.SetReadOnly(AValue: Boolean);
begin
  TEdit(Control).ReadOnly := AValue;
end;

function TLazRibbonComboBoxItem.CreateControl: TControl;
begin
  Result := TComboBox.Create(Self);
  TComboBox(Result).Style := csDropDownList;
  TComboBox(Result).OnChange := ControlChange;
end;

procedure TLazRibbonComboBoxItem.DoChange;
begin
  if not FChanging then inherited DoChange;
end;

function TLazRibbonComboBoxItem.GetItems: TStrings;
begin
  Result := TComboBox(Control).Items;
end;

procedure TLazRibbonComboBoxItem.SetItems(AValue: TStrings);
begin
  TComboBox(Control).Items.Assign(AValue);
end;

function TLazRibbonComboBoxItem.GetItemIndex: Integer;
begin
  Result := TComboBox(Control).ItemIndex;
end;

procedure TLazRibbonComboBoxItem.SetItemIndex(AValue: Integer);
var
  Previous: Integer;
begin
  if (AValue < -1) or (AValue >= Items.Count) then
    raise ERangeError.Create('Ribbon combo item index is outside Items.');
  Previous := ItemIndex;
  if Previous = AValue then Exit;
  FChanging := True;
  try
    TComboBox(Control).ItemIndex := AValue;
  finally
    FChanging := False;
  end;
  DoChange;
end;

function TLazRibbonComboBoxItem.GetText: TCaption;
begin
  Result := TComboBox(Control).Text;
end;

function TLazRibbonComboBoxItem.IsTextStored: Boolean;
begin
  { In a selection-only combo the index is authoritative, including when two
    choices have identical captions. Reapplying Text would select the first. }
  Result := Style <> csDropDownList;
end;

procedure TLazRibbonComboBoxItem.SetText(const AValue: TCaption);
begin
  if Style = csDropDownList then
    SetItemIndex(Items.IndexOf(AValue))
  else
    TComboBox(Control).Text := AValue;
end;

function TLazRibbonComboBoxItem.GetStyle: TComboBoxStyle;
begin
  Result := TComboBox(Control).Style;
end;

procedure TLazRibbonComboBoxItem.SetStyle(AValue: TComboBoxStyle);
begin
  TComboBox(Control).Style := AValue;
end;

function TLazRibbonSpinEditItem.CreateControl: TControl;
begin
  Result := TSpinEdit.Create(Self);
  TSpinEdit(Result).MaxValue := 100;
  TSpinEdit(Result).OnChange := ControlChange;
end;

function TLazRibbonSpinEditItem.GetValue: Integer;
begin
  Result := TSpinEdit(Control).Value;
end;

procedure TLazRibbonSpinEditItem.SetValue(AValue: Integer);
begin
  TSpinEdit(Control).Value := AValue;
end;

function TLazRibbonSpinEditItem.GetMinValue: Integer;
begin
  Result := TSpinEdit(Control).MinValue;
end;

procedure TLazRibbonSpinEditItem.SetMinValue(AValue: Integer);
begin
  TSpinEdit(Control).MinValue := AValue;
end;

function TLazRibbonSpinEditItem.GetMaxValue: Integer;
begin
  Result := TSpinEdit(Control).MaxValue;
end;

procedure TLazRibbonSpinEditItem.SetMaxValue(AValue: Integer);
begin
  TSpinEdit(Control).MaxValue := AValue;
end;

function TLazRibbonSpinEditItem.GetIncrement: Integer;
begin
  Result := TSpinEdit(Control).Increment;
end;

procedure TLazRibbonSpinEditItem.SetIncrement(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  TSpinEdit(Control).Increment := AValue;
end;

constructor TLazRibbonFontNameComboBoxItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowFontPreview := True;
  RefreshFonts;
end;

function TLazRibbonFontNameComboBoxItem.CreateControl: TControl;
begin
  Result := TComboBox.Create(Self);
  with TComboBox(Result) do
  begin
    Style := csOwnerDrawEditableFixed;
    DropDownCount := 12;
    ItemHeight := 24;
    AutoComplete := True;
    OnChange := FontSelectionChanged;
    OnDrawItem := DrawFontItem;
  end;
end;

function TLazRibbonFontNameComboBoxItem.GetItems: TStrings;
begin
  Result := TComboBox(Control).Items;
end;

function TLazRibbonFontNameComboBoxItem.GetDropDownCount: Integer;
begin
  Result := TComboBox(Control).DropDownCount;
end;

procedure TLazRibbonFontNameComboBoxItem.SetDropDownCount(AValue: Integer);
begin
  if AValue < 1 then AValue := 1;
  TComboBox(Control).DropDownCount := AValue;
end;

procedure TLazRibbonFontNameComboBoxItem.SetFontName(const AValue: TFontName);
var
  Combo: TComboBox;
  NewName: TFontName;
  Index: Integer;
begin
  Combo := TComboBox(Control);
  Index := Items.IndexOf(AValue);
  if Index >= 0 then NewName := Items[Index] else NewName := AValue;
  if FFontName = NewName then Exit;
  FUpdatingFonts := True;
  try
    FFontName := NewName;
    Combo.ItemIndex := Index;
    Combo.Text := NewName;
  finally
    FUpdatingFonts := False;
  end;
  DoChange;
end;

procedure TLazRibbonFontNameComboBoxItem.SetShowFontPreview(AValue: Boolean);
begin
  if FShowFontPreview = AValue then Exit;
  FShowFontPreview := AValue;
  Control.Invalidate;
end;

procedure TLazRibbonFontNameComboBoxItem.FontSelectionChanged(Sender: TObject);
var
  NewName: TFontName;
begin
  if FUpdatingFonts then Exit;
  NewName := TComboBox(Control).Text;
  if FFontName = NewName then Exit;
  FFontName := NewName;
  DoChange;
end;

procedure TLazRibbonFontNameComboBoxItem.RefreshFonts;
var
  Names: TStringList;
  Combo: TComboBox;
begin
  Names := TStringList.Create;
  try
    Names.Sorted := True;
    Names.Duplicates := dupIgnore;
    Names.AddStrings(Screen.Fonts);
    Combo := TComboBox(Control);
    FUpdatingFonts := True;
    try
      Combo.Items.BeginUpdate;
      try
        Combo.Items.Assign(Names);
        Combo.ItemIndex := Combo.Items.IndexOf(FFontName);
        { Keep an unavailable font name visible without inventing a list entry.
          Applications can therefore move between machines with different fonts. }
        Combo.Text := FFontName;
      finally
        Combo.Items.EndUpdate;
      end;
    finally
      FUpdatingFonts := False;
    end;
  finally
    Names.Free;
  end;
end;

procedure TLazRibbonFontNameComboBoxItem.DrawFontItem(AControl: TWinControl;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
var
  Combo: TComboBox;
  DrawStyle: TTextStyle;
  FontText: String;
begin
  Combo := TComboBox(AControl);
  if (AIndex >= 0) and (AIndex < Combo.Items.Count) then
    FontText := Combo.Items[AIndex]
  else
    FontText := FFontName;
  with Combo.Canvas do
  begin
    Font.Assign(Combo.Font);
    if FShowFontPreview and not (odComboBoxEdit in AState) then
      Font.Name := FontText;
    if odSelected in AState then
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText;
    end
    else
    begin
      Brush.Color := clWindow;
      Font.Color := clWindowText;
    end;
    FillRect(ARect);
    if not Enabled then Font.Color := clGrayText;
    DrawStyle := Default(TTextStyle);
    DrawStyle.Layout := tlCenter;
    DrawStyle.SingleLine := True;
    DrawStyle.Clipping := True;
    DrawStyle.EndEllipsis := True;
    Inc(ARect.Left, 4);
    TextRect(ARect, ARect.Left, ARect.Top, FontText, DrawStyle);
  end;
end;

function TLazRibbonStaticTextItem.CreateControl: TControl;
begin
  Result := TLabel.Create(Self);
  TLabel(Result).Layout := tlCenter;
  TLabel(Result).Transparent := True;
  TLabel(Result).ShowAccelChar := False;
end;

procedure TLazRibbonStaticTextItem.SetCaption(const AValue: TCaption);
begin
  inherited SetCaption(AValue);
  TLabel(Control).Caption := AValue;
end;

function TLazRibbonStaticTextItem.GetAlignment: TAlignment;
begin
  Result := TLabel(Control).Alignment;
end;

procedure TLazRibbonStaticTextItem.SetAlignment(AValue: TAlignment);
begin
  TLabel(Control).Alignment := AValue;
end;

function TLazRibbonProgressBarItem.CreateControl: TControl;
begin
  Result := TProgressBar.Create(Self);
  TProgressBar(Result).TabStop := False;
end;

function TLazRibbonProgressBarItem.GetMin: Integer;
begin
  Result := TProgressBar(Control).Min;
end;

procedure TLazRibbonProgressBarItem.SetMin(AValue: Integer);
begin
  TProgressBar(Control).Min := AValue;
end;

function TLazRibbonProgressBarItem.GetMax: Integer;
begin
  Result := TProgressBar(Control).Max;
end;

procedure TLazRibbonProgressBarItem.SetMax(AValue: Integer);
begin
  TProgressBar(Control).Max := AValue;
end;

function TLazRibbonProgressBarItem.GetPosition: Integer;
begin
  Result := TProgressBar(Control).Position;
end;

procedure TLazRibbonProgressBarItem.SetPosition(AValue: Integer);
begin
  TProgressBar(Control).Position := AValue;
end;

end.
