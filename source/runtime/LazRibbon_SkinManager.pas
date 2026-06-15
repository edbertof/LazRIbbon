unit LazRibbon_SkinManager;

{$mode Delphi}{$H+}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_SkinManager.pas                                           *
*  Description: Skin manager for LazRibbon_Core / BackStage components             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, SysUtils, Graphics, Controls, Forms,
  LazRibbon_GUITools, LazRibbon_GraphTools, LazRibbon_Appearance, LazRibbon_Dispatch, LazRibbon_XMLParser, LazRibbon_SkinDefinition;

type
  { Defines where a component obtains the appearance used for painting.

    asInternalStyle preserves the original LazRibbon_Core behavior.
    asSkinManager uses TLazRibbonSkinManager.Appearance.
    asLinkedToolbar is used by components such as Backstage that can mirror
    another toolbar's appearance. }
  TLazRibbonAppearanceSource = (asInternalStyle, asSkinManager, asLinkedToolbar);

  { Compatibility aliases. The real skin model lives in LazRibbon_SkinDefinition.pas. }
  TLazRibbonBuiltInSkin = LazRibbon_SkinDefinition.TLazRibbonBuiltInSkin;
  TLazRibbonSkinPalette = LazRibbon_SkinDefinition.TLazRibbonSkinPalette;
  TLazRibbonSkinSource = LazRibbon_SkinDefinition.TLazRibbonSkinSource;
  TLazRibbonSkinDefinition = LazRibbon_SkinDefinition.TLazRibbonSkinDefinition;

function LazBuiltInSkinCount: Integer;
function LazBuiltInSkinByIndex(AIndex: Integer): TLazRibbonBuiltInSkin;
function LazBuiltInSkinToString(ASkin: TLazRibbonBuiltInSkin): String;
function LazBuiltInSkinCaption(ASkin: TLazRibbonBuiltInSkin): String;
function LazBuiltInSkinMainColor(ASkin: TLazRibbonBuiltInSkin): TColor;
function LazBuiltInSkinAccentColor(ASkin: TLazRibbonBuiltInSkin): TColor;
procedure LazRegisterSkinChangeHandler(AOwner: TComponent; AHandler: TNotifyEvent);
procedure LazUnregisterSkinChangeHandler(AOwner: TComponent);

const
  LazRibbonDefaultSkinFolder = '.\Skins';

type
  TLazRibbonSkinManager = class;

  TLazRibbonSkinAppearanceDispatch = class(TLazRibbonBaseAppearanceDispatch)
  private
    FManager: TLazRibbonSkinManager;
  public
    constructor Create(AManager: TLazRibbonSkinManager);
    procedure NotifyAppearanceChanged; override;
  end;

  TLazRibbonSkinColorGroup = class(TPersistent)
  private
    FManager: TLazRibbonSkinManager;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AManager: TLazRibbonSkinManager); reintroduce; virtual;
  end;

  TLazRibbonSkinGeneralColors = class(TLazRibbonSkinColorGroup)
  private
    function GetBackColor: TColor;
    function GetTextColor: TColor;
    function GetMutedTextColor: TColor;
    function GetBorderColor: TColor;
    procedure SetBackColor(AValue: TColor);
    procedure SetTextColor(AValue: TColor);
    procedure SetMutedTextColor(AValue: TColor);
    procedure SetBorderColor(AValue: TColor);
  published
    property BackColor: TColor read GetBackColor write SetBackColor;
    property TextColor: TColor read GetTextColor write SetTextColor;
    property MutedTextColor: TColor read GetMutedTextColor write SetMutedTextColor;
    property BorderColor: TColor read GetBorderColor write SetBorderColor;
  end;

  TLazRibbonSkinAccentColors = class(TLazRibbonSkinColorGroup)
  private
    function GetNavigationColor: TColor;
    function GetActiveColor: TColor;
    function GetHotColor: TColor;
    procedure SetNavigationColor(AValue: TColor);
    procedure SetActiveColor(AValue: TColor);
    procedure SetHotColor(AValue: TColor);
  published
    property NavigationColor: TColor read GetNavigationColor write SetNavigationColor;
    property ActiveColor: TColor read GetActiveColor write SetActiveColor;
    property HotColor: TColor read GetHotColor write SetHotColor;
  end;

  TLazRibbonSkinBackstageColors = class(TLazRibbonSkinColorGroup)
  private
    function GetNavigationColor: TColor;
    function GetTextColor: TColor;
    function GetMutedTextColor: TColor;
    function GetHotColor: TColor;
    function GetHotTextColor: TColor;
    function GetSelectedColor: TColor;
    function GetSelectedTextColor: TColor;
    function GetSelectedFrameColor: TColor;
    procedure SetNavigationColor(AValue: TColor);
    procedure SetTextColor(AValue: TColor);
    procedure SetMutedTextColor(AValue: TColor);
    procedure SetHotColor(AValue: TColor);
    procedure SetHotTextColor(AValue: TColor);
    procedure SetSelectedColor(AValue: TColor);
    procedure SetSelectedTextColor(AValue: TColor);
    procedure SetSelectedFrameColor(AValue: TColor);
  published
    property NavigationColor: TColor read GetNavigationColor write SetNavigationColor;
    property TextColor: TColor read GetTextColor write SetTextColor;
    property MutedTextColor: TColor read GetMutedTextColor write SetMutedTextColor;
    property HotColor: TColor read GetHotColor write SetHotColor;
    property HotTextColor: TColor read GetHotTextColor write SetHotTextColor;
    property SelectedColor: TColor read GetSelectedColor write SetSelectedColor;
    property SelectedTextColor: TColor read GetSelectedTextColor write SetSelectedTextColor;
    property SelectedFrameColor: TColor read GetSelectedFrameColor write SetSelectedFrameColor;
  end;

  TLazRibbonSkinRecentListColors = class(TLazRibbonSkinColorGroup)
  private
    function GetOddColor: TColor;
    function GetHoverColor: TColor;
    function GetSelectedColor: TColor;
    function GetSelectedFrameColor: TColor;
    function GetTitleColor: TColor;
    procedure SetOddColor(AValue: TColor);
    procedure SetHoverColor(AValue: TColor);
    procedure SetSelectedColor(AValue: TColor);
    procedure SetSelectedFrameColor(AValue: TColor);
    procedure SetTitleColor(AValue: TColor);
  published
    property OddColor: TColor read GetOddColor write SetOddColor;
    property HoverColor: TColor read GetHoverColor write SetHoverColor;
    property SelectedColor: TColor read GetSelectedColor write SetSelectedColor;
    property SelectedFrameColor: TColor read GetSelectedFrameColor write SetSelectedFrameColor;
    property TitleColor: TColor read GetTitleColor write SetTitleColor;
  end;

  TLazRibbonSkinRibbonColors = class(TLazRibbonSkinColorGroup)
  private
    function GetTopColor: TColor;
    function GetBottomColor: TColor;
    function GetTabActiveColor: TColor;
    function GetTabHotColor: TColor;
    function GetGroupColor: TColor;
    function GetGroupFrameColor: TColor;
    procedure SetTopColor(AValue: TColor);
    procedure SetBottomColor(AValue: TColor);
    procedure SetTabActiveColor(AValue: TColor);
    procedure SetTabHotColor(AValue: TColor);
    procedure SetGroupColor(AValue: TColor);
    procedure SetGroupFrameColor(AValue: TColor);
  published
    property TopColor: TColor read GetTopColor write SetTopColor;
    property BottomColor: TColor read GetBottomColor write SetBottomColor;
    property TabActiveColor: TColor read GetTabActiveColor write SetTabActiveColor;
    property TabHotColor: TColor read GetTabHotColor write SetTabHotColor;
    property GroupColor: TColor read GetGroupColor write SetGroupColor;
    property GroupFrameColor: TColor read GetGroupFrameColor write SetGroupFrameColor;
  end;

  TLazRibbonSkinManager = class(TComponent)
  private
    FActiveSkin: TLazRibbonBuiltInSkin;
    FActiveSkinName: String;
    FAutoRefreshControls: Boolean;
    FUpdateCount: Integer;
    FChangedPending: Boolean;
    FSkinFolder: String;
    FSkins: TList;
    FPalette: TLazRibbonSkinPalette;
    FAppearanceDispatch: TLazRibbonSkinAppearanceDispatch;
    FAppearance: TLazRibbonToolbarAppearance;
    FGeneral: TLazRibbonSkinGeneralColors;
    FAccent: TLazRibbonSkinAccentColors;
    FBackstage: TLazRibbonSkinBackstageColors;
    FRecentList: TLazRibbonSkinRecentListColors;
    FRibbon: TLazRibbonSkinRibbonColors;
    FOnChange: TNotifyEvent;
    procedure ApplyBuiltInSkin;
    procedure ApplyBuiltInPaneAppearance;
    procedure ApplyPaletteToAppearance;
    procedure Changed;
    procedure RefreshOwnerControls;
    procedure SetActiveSkin(AValue: TLazRibbonBuiltInSkin);
    procedure SetActiveSkinName(const AValue: String);
    procedure SetSkinFolder(const AValue: String);
    procedure ClearSkinList;
    procedure AddBuiltInSkin(ASkin: TLazRibbonBuiltInSkin);
    procedure ApplySkinDefinition(ASkin: TLazRibbonSkinDefinition);

    function GetBackColor: TColor;
    function GetNavigationColor: TColor;
    function GetActiveColor: TColor;
    function GetHotColor: TColor;
    function GetFrameColor: TColor;
    function GetTextColor: TColor;
    function GetMutedTextColor: TColor;
    function GetRecentOddColor: TColor;
    function GetRecentHoverColor: TColor;
    function GetRecentSelectedColor: TColor;
    function GetRecentSelectedFrameColor: TColor;
    function GetRecentTitleColor: TColor;
    procedure SetAutoRefreshControls(AValue: Boolean);
    procedure SetAppearance(AValue: TLazRibbonToolbarAppearance);
    procedure SetBackColor(AValue: TColor);
    procedure SetNavigationColor(AValue: TColor);
    procedure SetActiveColor(AValue: TColor);
    procedure SetHotColor(AValue: TColor);
    procedure SetFrameColor(AValue: TColor);
    procedure SetTextColor(AValue: TColor);
    procedure SetMutedTextColor(AValue: TColor);
    procedure SetRecentOddColor(AValue: TColor);
    procedure SetRecentHoverColor(AValue: TColor);
    procedure SetRecentSelectedColor(AValue: TColor);
    procedure SetRecentSelectedFrameColor(AValue: TColor);
    procedure SetRecentTitleColor(AValue: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure AssignPalette(const APalette: TLazRibbonSkinPalette);
    procedure ResetToBuiltInSkin;
    procedure LoadBuiltInSkins;
    procedure LoadSkins;
    procedure LoadSkinsFromFolder(const AFolder: String);
    procedure ExportBuiltInSkinsToFolder(const AFolder: String);
    procedure ApplySkinByName(const ASkinName: String);
    function SkinCount: Integer;
    function SkinByIndex(AIndex: Integer): TLazRibbonSkinDefinition;
    function FindSkin(const ASkinName: String): TLazRibbonSkinDefinition;
    procedure LoadFromFile(const AFileName: String);
    procedure SaveToFile(const AFileName: String);
    property Palette: TLazRibbonSkinPalette read FPalette;
    property Skins[AIndex: Integer]: TLazRibbonSkinDefinition read SkinByIndex;
  published
    property ActiveSkin: TLazRibbonBuiltInSkin read FActiveSkin write SetActiveSkin default sbsOfficeBlue;
    property ActiveSkinName: String read FActiveSkinName write SetActiveSkinName;
    property SkinFolder: String read FSkinFolder write SetSkinFolder;
    property AutoRefreshControls: Boolean read FAutoRefreshControls write SetAutoRefreshControls default True;

    { Full LazRibbon_Core appearance model; exposes the original LazRibbon_Appearance structure. }
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;

    { Grouped skin palette model }
    property General: TLazRibbonSkinGeneralColors read FGeneral;
    property Accent: TLazRibbonSkinAccentColors read FAccent;
    property Backstage: TLazRibbonSkinBackstageColors read FBackstage;
    property RecentList: TLazRibbonSkinRecentListColors read FRecentList;
    property Ribbon: TLazRibbonSkinRibbonColors read FRibbon;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

type
  TLazRibbonSkinChangeHandlerItem = class
  public
    Owner: TComponent;
    Handler: TNotifyEvent;
  end;

var
  GSkinChangeHandlers: TList = nil;

function LazBuiltInSkinCount: Integer;
begin
  { Visible built-in skins. sbsCaramel remains in the enum only for old .lfm/source compatibility. }
  Result := 8;
end;

function LazBuiltInSkinByIndex(AIndex: Integer): TLazRibbonBuiltInSkin;
begin
  case AIndex of
    1: Result := sbsOfficeSilver;
    2: Result := sbsOfficeBlack;
    3: Result := sbsMetroLight;
    4: Result := sbsMetroDark;
    5: Result := sbsOlive;
    6: Result := sbsPurple;
    7: Result := sbsModernLight;
  else
    Result := sbsOfficeBlue;
  end;
end;

function LazBuiltInSkinToString(ASkin: TLazRibbonBuiltInSkin): String;
begin
  case ASkin of
    sbsOfficeSilver: Result := 'OfficeSilver';
    sbsOfficeBlack: Result := 'OfficeBlack';
    sbsCaramel: Result := 'Caramel';
    sbsMetroLight: Result := 'MetroLight';
    sbsMetroDark: Result := 'MetroDark';
    sbsOlive: Result := 'Olive';
    sbsPurple: Result := 'Purple';
    sbsModernLight: Result := 'ModernLight';
  else
    Result := 'OfficeBlue';
  end;
end;

function LazBuiltInSkinCaption(ASkin: TLazRibbonBuiltInSkin): String;
begin
  case ASkin of
    sbsOfficeSilver: Result := 'Office Silver';
    sbsOfficeBlack: Result := 'Office Black';
    sbsCaramel: Result := 'Caramel';
    sbsMetroLight: Result := 'Metro Light';
    sbsMetroDark: Result := 'Metro Dark';
    sbsOlive: Result := 'Olive';
    sbsPurple: Result := 'Purple';
    sbsModernLight: Result := 'Modern Light';
  else
    Result := 'Office Blue';
  end;
end;

function LazBuiltInSkinMainColor(ASkin: TLazRibbonBuiltInSkin): TColor;
begin
  case ASkin of
    sbsOfficeSilver: Result := RGBToColor(222, 226, 232);
    sbsOfficeBlack: Result := RGBToColor(70, 70, 70);
    sbsCaramel: Result := RGBToColor(222, 205, 180);
    sbsMetroLight: Result := RGBToColor(245, 246, 248);
    sbsMetroDark: Result := RGBToColor(40, 40, 40);
    sbsOlive: Result := RGBToColor(218, 226, 198);
    sbsPurple: Result := RGBToColor(228, 218, 239);
    sbsModernLight: Result := RGBToColor(248, 249, 251);
  else
    Result := RGBToColor(196, 220, 245);
  end;
end;

function LazBuiltInSkinAccentColor(ASkin: TLazRibbonBuiltInSkin): TColor;
begin
  case ASkin of
    sbsOfficeSilver: Result := RGBToColor(120, 132, 148);
    sbsOfficeBlack: Result := RGBToColor(142, 142, 142);
    sbsCaramel: Result := RGBToColor(168, 125, 76);
    sbsMetroLight: Result := RGBToColor(0, 120, 215);
    sbsMetroDark: Result := RGBToColor(0, 122, 204);
    sbsOlive: Result := RGBToColor(116, 145, 62);
    sbsPurple: Result := RGBToColor(136, 72, 180);
    sbsModernLight: Result := RGBToColor(0, 102, 204);
  else
    Result := RGBToColor(49, 106, 197);
  end;
end;

procedure LazRegisterSkinChangeHandler(AOwner: TComponent; AHandler: TNotifyEvent);
var
  I: Integer;
  Item: TLazRibbonSkinChangeHandlerItem;
begin
  if (AOwner = nil) or not Assigned(AHandler) then
    Exit;
  if GSkinChangeHandlers = nil then
    GSkinChangeHandlers := TList.Create;
  for I := 0 to GSkinChangeHandlers.Count - 1 do
  begin
    Item := TLazRibbonSkinChangeHandlerItem(GSkinChangeHandlers[I]);
    if Item.Owner = AOwner then
    begin
      Item.Handler := AHandler;
      Exit;
    end;
  end;
  Item := TLazRibbonSkinChangeHandlerItem.Create;
  Item.Owner := AOwner;
  Item.Handler := AHandler;
  GSkinChangeHandlers.Add(Item);
end;

procedure LazUnregisterSkinChangeHandler(AOwner: TComponent);
var
  I: Integer;
  Item: TLazRibbonSkinChangeHandlerItem;
begin
  if (AOwner = nil) or (GSkinChangeHandlers = nil) then
    Exit;
  for I := GSkinChangeHandlers.Count - 1 downto 0 do
  begin
    Item := TLazRibbonSkinChangeHandlerItem(GSkinChangeHandlers[I]);
    if Item.Owner = AOwner then
    begin
      GSkinChangeHandlers.Delete(I);
      Item.Free;
    end;
  end;
end;

procedure LazNotifySkinChangeHandlers(ASender: TObject);
var
  I: Integer;
  Item: TLazRibbonSkinChangeHandlerItem;
begin
  if GSkinChangeHandlers = nil then
    Exit;
  for I := GSkinChangeHandlers.Count - 1 downto 0 do
  begin
    Item := TLazRibbonSkinChangeHandlerItem(GSkinChangeHandlers[I]);
    if (Item.Owner <> nil) and
       not (csDestroying in Item.Owner.ComponentState) and
       Assigned(Item.Handler) then
      Item.Handler(ASender);
  end;
end;

function LazColorToHex(AColor: TColor): String;
var
  C: LongInt;
begin
  C := ColorToRGB(AColor);
  Result := '#' +
    IntToHex(C and $FF, 2) +
    IntToHex((C shr 8) and $FF, 2) +
    IntToHex((C shr 16) and $FF, 2);
end;

function LazHexToColor(const AValue: String; ADefault: TColor): TColor;
var
  S: String;
  R, G, B: Integer;
begin
  Result := ADefault;
  S := Trim(AValue);
  if S = '' then Exit;
  if S[1] = '#' then
    Delete(S, 1, 1);
  if Length(S) <> 6 then Exit;
  try
    R := StrToInt('$' + Copy(S, 1, 2));
    G := StrToInt('$' + Copy(S, 3, 2));
    B := StrToInt('$' + Copy(S, 5, 2));
    Result := RGBToColor(R, G, B);
  except
    Result := ADefault;
  end;
end;

function LazRibbonAppFolder: String;
begin
  Result := ExtractFilePath(ParamStr(0));
  if Result = '' then
    Result := GetCurrentDir;
  Result := IncludeTrailingPathDelimiter(Result);
end;

function LazRibbonPathIsAbsolute(const APath: String): Boolean;
begin
  Result :=
    (ExtractFileDrive(APath) <> '') or
    ((APath <> '') and (APath[1] in ['\', '/']));
end;

function LazRibbonResolveSkinFolder(const AFolder: String): String;
var
  AppFolder, Candidate: String;
begin
  Result := '';
  Candidate := Trim(AFolder);
  if Candidate = '' then
    Exit;

  Candidate := ExpandFileName(Candidate);
  if DirectoryExists(Candidate) then
  begin
    Result := Candidate;
    Exit;
  end;

  AppFolder := LazRibbonAppFolder;
  if not LazRibbonPathIsAbsolute(Trim(AFolder)) then
  begin
    Candidate := ExpandFileName(AppFolder + Trim(AFolder));
    if DirectoryExists(Candidate) then
    begin
      Result := Candidate;
      Exit;
    end;
  end;

  if DirectoryExists(AppFolder) then
    Result := AppFolder;
end;

function LazReadSkinColor(AStrings: TStrings; const AName: String; ADefault: TColor): TColor;
begin
  Result := LazHexToColor(AStrings.Values[AName], ADefault);
end;

{ TLazRibbonSkinAppearanceDispatch }

constructor TLazRibbonSkinAppearanceDispatch.Create(AManager: TLazRibbonSkinManager);
begin
  inherited Create;
  FManager := AManager;
end;

procedure TLazRibbonSkinAppearanceDispatch.NotifyAppearanceChanged;
begin
  if FManager <> nil then
    FManager.Changed;
end;

{ TLazRibbonSkinColorGroup }

constructor TLazRibbonSkinColorGroup.Create(AManager: TLazRibbonSkinManager);
begin
  inherited Create;
  FManager := AManager;
end;

function TLazRibbonSkinColorGroup.GetOwner: TPersistent;
begin
  Result := FManager;
end;

{ TLazRibbonSkinGeneralColors }

function TLazRibbonSkinGeneralColors.GetBackColor: TColor;
begin
  Result := FManager.FPalette.BackColor;
end;

function TLazRibbonSkinGeneralColors.GetTextColor: TColor;
begin
  Result := FManager.FPalette.TextColor;
end;

function TLazRibbonSkinGeneralColors.GetMutedTextColor: TColor;
begin
  Result := FManager.FPalette.MutedTextColor;
end;

function TLazRibbonSkinGeneralColors.GetBorderColor: TColor;
begin
  Result := FManager.FPalette.FrameColor;
end;

procedure TLazRibbonSkinGeneralColors.SetBackColor(AValue: TColor);
begin
  FManager.SetBackColor(AValue);
end;

procedure TLazRibbonSkinGeneralColors.SetTextColor(AValue: TColor);
begin
  FManager.SetTextColor(AValue);
end;

procedure TLazRibbonSkinGeneralColors.SetMutedTextColor(AValue: TColor);
begin
  FManager.SetMutedTextColor(AValue);
end;

procedure TLazRibbonSkinGeneralColors.SetBorderColor(AValue: TColor);
begin
  FManager.SetFrameColor(AValue);
end;

{ TLazRibbonSkinAccentColors }

function TLazRibbonSkinAccentColors.GetNavigationColor: TColor;
begin
  Result := FManager.GetNavigationColor;
end;

function TLazRibbonSkinAccentColors.GetActiveColor: TColor;
begin
  Result := FManager.GetActiveColor;
end;

function TLazRibbonSkinAccentColors.GetHotColor: TColor;
begin
  Result := FManager.GetHotColor;
end;

procedure TLazRibbonSkinAccentColors.SetNavigationColor(AValue: TColor);
begin
  FManager.SetNavigationColor(AValue);
end;

procedure TLazRibbonSkinAccentColors.SetActiveColor(AValue: TColor);
begin
  FManager.SetActiveColor(AValue);
end;

procedure TLazRibbonSkinAccentColors.SetHotColor(AValue: TColor);
begin
  FManager.SetHotColor(AValue);
end;

{ TLazRibbonSkinBackstageColors }

function TLazRibbonSkinBackstageColors.GetNavigationColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavColor;
end;

function TLazRibbonSkinBackstageColors.GetTextColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavTextColor;
end;

function TLazRibbonSkinBackstageColors.GetMutedTextColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavMutedTextColor;
end;

function TLazRibbonSkinBackstageColors.GetHotColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavHoverColor;
end;

function TLazRibbonSkinBackstageColors.GetHotTextColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavHoverTextColor;
end;

function TLazRibbonSkinBackstageColors.GetSelectedColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavSelectedColor;
end;

function TLazRibbonSkinBackstageColors.GetSelectedTextColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavSelectedTextColor;
end;

function TLazRibbonSkinBackstageColors.GetSelectedFrameColor: TColor;
begin
  Result := FManager.FPalette.BackstageNavSelectedFrameColor;
end;

procedure TLazRibbonSkinBackstageColors.SetNavigationColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavColor = AValue then Exit;
  FManager.FPalette.BackstageNavColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinBackstageColors.SetTextColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavTextColor = AValue then Exit;
  FManager.FPalette.BackstageNavTextColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinBackstageColors.SetMutedTextColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavMutedTextColor = AValue then Exit;
  FManager.FPalette.BackstageNavMutedTextColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinBackstageColors.SetHotColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavHoverColor = AValue then Exit;
  FManager.FPalette.BackstageNavHoverColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinBackstageColors.SetHotTextColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavHoverTextColor = AValue then Exit;
  FManager.FPalette.BackstageNavHoverTextColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinBackstageColors.SetSelectedColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavSelectedColor = AValue then Exit;
  FManager.FPalette.BackstageNavSelectedColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinBackstageColors.SetSelectedTextColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavSelectedTextColor = AValue then Exit;
  FManager.FPalette.BackstageNavSelectedTextColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinBackstageColors.SetSelectedFrameColor(AValue: TColor);
begin
  if FManager.FPalette.BackstageNavSelectedFrameColor = AValue then Exit;
  FManager.FPalette.BackstageNavSelectedFrameColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

{ TLazRibbonSkinRecentListColors }

function TLazRibbonSkinRecentListColors.GetOddColor: TColor;
begin
  Result := FManager.FPalette.RecentOddColor;
end;

function TLazRibbonSkinRecentListColors.GetHoverColor: TColor;
begin
  Result := FManager.FPalette.RecentHoverColor;
end;

function TLazRibbonSkinRecentListColors.GetSelectedColor: TColor;
begin
  Result := FManager.FPalette.RecentSelectedColor;
end;

function TLazRibbonSkinRecentListColors.GetSelectedFrameColor: TColor;
begin
  Result := FManager.FPalette.RecentSelectedFrameColor;
end;

function TLazRibbonSkinRecentListColors.GetTitleColor: TColor;
begin
  Result := FManager.FPalette.RecentTitleColor;
end;

procedure TLazRibbonSkinRecentListColors.SetOddColor(AValue: TColor);
begin
  FManager.SetRecentOddColor(AValue);
end;

procedure TLazRibbonSkinRecentListColors.SetHoverColor(AValue: TColor);
begin
  FManager.SetRecentHoverColor(AValue);
end;

procedure TLazRibbonSkinRecentListColors.SetSelectedColor(AValue: TColor);
begin
  FManager.SetRecentSelectedColor(AValue);
end;

procedure TLazRibbonSkinRecentListColors.SetSelectedFrameColor(AValue: TColor);
begin
  FManager.SetRecentSelectedFrameColor(AValue);
end;

procedure TLazRibbonSkinRecentListColors.SetTitleColor(AValue: TColor);
begin
  FManager.SetRecentTitleColor(AValue);
end;

{ TLazRibbonSkinRibbonColors }

function TLazRibbonSkinRibbonColors.GetTopColor: TColor;
begin
  Result := FManager.FPalette.RibbonTopColor;
end;

function TLazRibbonSkinRibbonColors.GetBottomColor: TColor;
begin
  Result := FManager.FPalette.RibbonBottomColor;
end;

function TLazRibbonSkinRibbonColors.GetTabActiveColor: TColor;
begin
  Result := FManager.FPalette.RibbonTabActiveColor;
end;

function TLazRibbonSkinRibbonColors.GetTabHotColor: TColor;
begin
  Result := FManager.FPalette.RibbonTabHotColor;
end;

function TLazRibbonSkinRibbonColors.GetGroupColor: TColor;
begin
  Result := FManager.FPalette.RibbonGroupColor;
end;

function TLazRibbonSkinRibbonColors.GetGroupFrameColor: TColor;
begin
  Result := FManager.FPalette.RibbonGroupFrameColor;
end;

procedure TLazRibbonSkinRibbonColors.SetTopColor(AValue: TColor);
begin
  if FManager.FPalette.RibbonTopColor = AValue then Exit;
  FManager.FPalette.RibbonTopColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinRibbonColors.SetBottomColor(AValue: TColor);
begin
  if FManager.FPalette.RibbonBottomColor = AValue then Exit;
  FManager.FPalette.RibbonBottomColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinRibbonColors.SetTabActiveColor(AValue: TColor);
begin
  if FManager.FPalette.RibbonTabActiveColor = AValue then Exit;
  FManager.FPalette.RibbonTabActiveColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinRibbonColors.SetTabHotColor(AValue: TColor);
begin
  if FManager.FPalette.RibbonTabHotColor = AValue then Exit;
  FManager.FPalette.RibbonTabHotColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinRibbonColors.SetGroupColor(AValue: TColor);
begin
  if FManager.FPalette.RibbonGroupColor = AValue then Exit;
  FManager.FPalette.RibbonGroupColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

procedure TLazRibbonSkinRibbonColors.SetGroupFrameColor(AValue: TColor);
begin
  if FManager.FPalette.RibbonGroupFrameColor = AValue then Exit;
  FManager.FPalette.RibbonGroupFrameColor := AValue;
  FManager.ApplyPaletteToAppearance;
  FManager.Changed;
end;

{ TLazRibbonSkinManager }

function LazStyleFromBuiltInSkin(ASkin: TLazRibbonBuiltInSkin): TLazRibbonStyle;
begin
  Result := LazRibbon_SkinDefinition.LazStyleFromBuiltInSkin(ASkin);
end;

procedure TLazRibbonSkinManager.ApplyBuiltInSkin;
begin
  FPalette := LazRibbon_SkinDefinition.LazDefaultPaletteForBuiltInSkin(FActiveSkin);
end;

procedure TLazRibbonSkinManager.ApplyBuiltInPaneAppearance;
begin
  {
    0.1.14: When the active skin is one of the Office-style built-in skins,
    do not let the generic palette algorithm replace the calibrated Ribbon
    appearance from LazRibbon_Appearance.Reset.  The original demos/basic
    project looks correct because it uses this calibrated Appearance directly.

    Dark skins and Modern Light still need the palette-derived appearance
    because the original appearance table either has no matching baseline or
    would overwrite the deliberately flatter 1.1.38 palette.
  }
  if (FAppearance <> nil) and not (FActiveSkin in [sbsOfficeBlack, sbsMetroDark, sbsModernLight]) then
    FAppearance.Reset(LazStyleFromBuiltInSkin(FActiveSkin));
end;

procedure TLazRibbonSkinManager.ApplyPaletteToAppearance;
begin
  if FAppearance = nil then
    Exit;

  with FAppearance.Tab do
  begin
    BorderColor := FPalette.FrameColor;
    GradientFromColor := FPalette.RibbonTopColor;
    GradientToColor := FPalette.RibbonBottomColor;
    GradientType := bkVerticalGradient;
    InactiveTabHeaderFontColor := LazEnsureContrastTextColor(FPalette.RibbonTopColor, FPalette.MutedTextColor);
    TabHeaderFont.Color := LazEnsureContrastTextColor(FPalette.RibbonTopColor, FPalette.TextColor);
  end;

  with FAppearance.MenuButton do
  begin
    IdleFrameColor := FPalette.FrameColor;
    IdleGradientFromColor := FPalette.RibbonTopColor;
    IdleGradientToColor := FPalette.RibbonBottomColor;
    IdleGradientType := bkVerticalGradient;
    IdleCaptionColor := LazEnsureContrastTextColor(FPalette.RibbonTopColor, FPalette.TextColor);
    HotTrackFrameColor := FPalette.FrameColor;
    HotTrackGradientFromColor := FPalette.HotColor;
    HotTrackGradientToColor := FPalette.HotColor;
    HotTrackGradientType := bkSolid;
    HotTrackCaptionColor := LazEnsureContrastTextColor(FPalette.HotColor, FPalette.TextColor);
    ActiveFrameColor := FPalette.FrameColor;
    ActiveGradientFromColor := FPalette.ActiveColor;
    ActiveGradientToColor := FPalette.ActiveColor;
    ActiveGradientType := bkSolid;
    ActiveCaptionColor := LazEnsureContrastTextColor(FPalette.ActiveColor, FPalette.TextColor);
  end;

  with FAppearance.Pane do
  begin
    {
      Pane colors must be derived from the same Ribbon gradient.  Version
      0.1.11 made panes visibly gradient, but the contrast was too independent
      from the Ribbon background.  These values keep panes as a subtle
      sub-surface of the Ribbon rather than a separate visual block.
    }
    BorderDarkColor := FPalette.RibbonGroupFrameColor;
    BorderLightColor := TColorTools.Shade(FPalette.RibbonGroupFrameColor, FPalette.RibbonTopColor, 35);
    CaptionBgColor := TColorTools.Shade(FPalette.RibbonGroupColor, FPalette.RibbonBottomColor, 55);
    CaptionFont.Color := LazEnsureContrastTextColor(CaptionBgColor, FPalette.TextColor);
    GradientFromColor := TColorTools.Shade(FPalette.RibbonGroupColor, FPalette.RibbonTopColor, 55);
    GradientToColor := TColorTools.Shade(FPalette.RibbonGroupColor, FPalette.RibbonBottomColor, 55);
    GradientType := bkVerticalGradient;
  end;

  with FAppearance.Element do
  begin
    CaptionFont.Color := LazEnsureContrastTextColor(FPalette.BackColor, FPalette.TextColor);
    IdleFrameColor := FPalette.FrameColor;
    IdleGradientFromColor := FPalette.BackColor;
    IdleGradientToColor := FPalette.BackColor;
    IdleGradientType := bkSolid;
    IdleCaptionColor := LazEnsureContrastTextColor(FPalette.BackColor, FPalette.TextColor);
    HotTrackFrameColor := FPalette.FrameColor;
    HotTrackGradientFromColor := FPalette.HotColor;
    HotTrackGradientToColor := FPalette.HotColor;
    HotTrackGradientType := bkSolid;
    HotTrackCaptionColor := LazEnsureContrastTextColor(FPalette.HotColor, FPalette.TextColor);
    ActiveFrameColor := FPalette.FrameColor;
    ActiveGradientFromColor := FPalette.ActiveColor;
    ActiveGradientToColor := FPalette.ActiveColor;
    ActiveGradientType := bkSolid;
    ActiveCaptionColor := LazEnsureContrastTextColor(FPalette.ActiveColor, FPalette.TextColor);
  end;

  with FAppearance.Popup do
  begin
    CaptionFont.Color := LazEnsureContrastTextColor(FPalette.BackColor, FPalette.TextColor);
    IdleCaptionColor := LazEnsureContrastTextColor(FPalette.BackColor, FPalette.TextColor);
    IdleGradientFromColor := FPalette.BackColor;
    IdleGradientToColor := FPalette.BackColor;
    IdleGradientType := bkSolid;
    HotTrackCaptionColor := LazEnsureContrastTextColor(FPalette.HotColor, FPalette.TextColor);
    HotTrackFrameColor := FPalette.FrameColor;
    HotTrackGradientFromColor := FPalette.HotColor;
    HotTrackGradientToColor := FPalette.HotColor;
    HotTrackGradientType := bkSolid;
    CheckedFrameColor := FPalette.FrameColor;
    CheckedGradientFromColor := FPalette.ActiveColor;
    CheckedGradientToColor := FPalette.ActiveColor;
    CheckedGradientType := bkSolid;
    GutterFrameColor := FPalette.FrameColor;
    GutterGradientFromColor := FPalette.NavigationColor;
    GutterGradientToColor := FPalette.NavigationColor;
    GutterGradientType := bkSolid;
    DisabledCaptionColor := LazEnsureContrastTextColor(FPalette.BackColor, FPalette.MutedTextColor);
    DividerLineColor := FPalette.FrameColor;
  end;
end;

constructor TLazRibbonSkinManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAppearanceDispatch := TLazRibbonSkinAppearanceDispatch.Create(Self);
  FAppearance := TLazRibbonToolbarAppearance.Create(FAppearanceDispatch);
  FGeneral := TLazRibbonSkinGeneralColors.Create(Self);
  FAccent := TLazRibbonSkinAccentColors.Create(Self);
  FBackstage := TLazRibbonSkinBackstageColors.Create(Self);
  FRecentList := TLazRibbonSkinRecentListColors.Create(Self);
  FRibbon := TLazRibbonSkinRibbonColors.Create(Self);
  FSkins := TList.Create;
  FActiveSkin := sbsOfficeBlue;
  FActiveSkinName := LazBuiltInSkinToString(sbsOfficeBlue);
  FAutoRefreshControls := True;
  FSkinFolder := LazRibbonDefaultSkinFolder;
  LoadSkins;
  ApplyBuiltInSkin;
  FAppearance.Reset(lazOffice2007Blue);
  ApplyPaletteToAppearance;
  ApplyBuiltInPaneAppearance;
end;

destructor TLazRibbonSkinManager.Destroy;
begin
  ClearSkinList;
  FSkins.Free;
  FAppearance.Free;
  FAppearanceDispatch.Free;
  FRibbon.Free;
  FRecentList.Free;
  FBackstage.Free;
  FAccent.Free;
  FGeneral.Free;
  inherited Destroy;
end;

procedure TLazRibbonSkinManager.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TLazRibbonSkinManager.EndUpdate;
begin
  if FUpdateCount <= 0 then
  begin
    FUpdateCount := 0;
    Exit;
  end;

  Dec(FUpdateCount);
  if (FUpdateCount = 0) and FChangedPending then
  begin
    FChangedPending := False;
    Changed;
  end;
end;

procedure TLazRibbonSkinManager.AssignPalette(const APalette: TLazRibbonSkinPalette);
begin
  FPalette := APalette;
  ApplyPaletteToAppearance;
  Changed;
end;

function LazFileLooksLikeXML(const AFileName: String): Boolean;
var
  L: TStringList;
  S: String;
begin
  Result := False;
  L := TStringList.Create;
  try
    L.LoadFromFile(AFileName);
    S := Trim(L.Text);
    Result := (S <> '') and (S[1] = '<');
  finally
    L.Free;
  end;
end;

procedure TLazRibbonSkinManager.LoadFromFile(const AFileName: String);
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := TLazRibbonSkinDefinition.Create;
  try
    Skin.LoadFromFile(AFileName);
    ApplySkinDefinition(Skin);
    FActiveSkinName := Skin.Name;
    if FActiveSkinName = '' then
      FActiveSkinName := ChangeFileExt(ExtractFileName(AFileName), '');
  finally
    Skin.Free;
  end;
  Changed;
end;

procedure TLazRibbonSkinManager.SaveToFile(const AFileName: String);
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := TLazRibbonSkinDefinition.Create;
  try
    Skin.Name := FActiveSkinName;
    if Skin.Name = '' then
      Skin.Name := LazBuiltInSkinToString(FActiveSkin);
    Skin.DisplayName := Skin.Name;
    Skin.Author := '';
    Skin.Description := '';
    Skin.AssignPalette(FPalette);
    Skin.Appearance.Assign(FAppearance);
    Skin.SaveToFile(AFileName);
  finally
    Skin.Free;
  end;
end;

procedure TLazRibbonSkinManager.Changed;
begin
  if FUpdateCount > 0 then
  begin
    FChangedPending := True;
    Exit;
  end;

  LazNotifySkinChangeHandlers(Self);
  if FAutoRefreshControls then
    RefreshOwnerControls;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TLazRibbonSkinManager.RefreshOwnerControls;
var
  I: Integer;
  C: TControl;
begin
  if Owner = nil then Exit;

  for I := 0 to Owner.ComponentCount - 1 do
    if Owner.Components[I] is TControl then
    begin
      C := TControl(Owner.Components[I]);
      C.Invalidate;
      if C.Parent <> nil then
        C.Parent.Invalidate;
    end;

  if Owner is TCustomForm then
  begin
    TCustomForm(Owner).Invalidate;
  end;
end;


procedure TLazRibbonSkinManager.ClearSkinList;
var
  I: Integer;
begin
  if FSkins = nil then Exit;
  for I := FSkins.Count - 1 downto 0 do
  begin
    TObject(FSkins[I]).Free;
    FSkins.Delete(I);
  end;
end;

procedure TLazRibbonSkinManager.AddBuiltInSkin(ASkin: TLazRibbonBuiltInSkin);
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := TLazRibbonSkinDefinition.Create;
  Skin.ResetToBuiltInSkin(ASkin);
  FSkins.Add(Skin);
end;

procedure TLazRibbonSkinManager.LoadBuiltInSkins;
var
  I: Integer;
begin
  ClearSkinList;
  for I := 0 to LazBuiltInSkinCount - 1 do
    AddBuiltInSkin(LazBuiltInSkinByIndex(I));
end;

procedure TLazRibbonSkinManager.LoadSkins;
begin
  LoadBuiltInSkins;
  if Trim(FSkinFolder) <> '' then
    LoadSkinsFromFolder(FSkinFolder);
end;

procedure TLazRibbonSkinManager.LoadSkinsFromFolder(const AFolder: String);
var
  Path: String;

  procedure LoadMatchingSkins(const APattern: String);
  var
    SR: TSearchRec;
    FN: String;
    Skin: TLazRibbonSkinDefinition;
  begin
    if FindFirst(Path + APattern, faAnyFile, SR) <> 0 then
      Exit;
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
        begin
          FN := Path + SR.Name;
          Skin := TLazRibbonSkinDefinition.Create;
          try
            Skin.LoadFromFile(FN);
            Skin.Source := sssExternal;
            Skin.FileName := FN;
            if Skin.Name = '' then
              Skin.Name := ChangeFileExt(SR.Name, '');
            if Skin.DisplayName = '' then
              Skin.DisplayName := Skin.Name;
            if FindSkin(Skin.Name) = nil then
            begin
              FSkins.Add(Skin);
              Skin := nil;
            end;
          finally
            Skin.Free;
          end;
        end;
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  end;

begin
  Path := LazRibbonResolveSkinFolder(AFolder);
  if Path = '' then
    Exit;
  Path := IncludeTrailingPathDelimiter(Path);
  if not DirectoryExists(Path) then
    Exit;
  LoadMatchingSkins('*.skin');
  LoadMatchingSkins('*.lazskin');
end;

procedure TLazRibbonSkinManager.ExportBuiltInSkinsToFolder(const AFolder: String);
var
  I: Integer;
  Skin: TLazRibbonSkinDefinition;
  BuiltIn: TLazRibbonBuiltInSkin;
  FileName: String;
begin
  if Trim(AFolder) = '' then
    Exit;
  ForceDirectories(AFolder);
  for I := 0 to LazBuiltInSkinCount - 1 do
  begin
    BuiltIn := LazBuiltInSkinByIndex(I);
    Skin := TLazRibbonSkinDefinition.Create;
    try
      Skin.ResetToBuiltInSkin(BuiltIn);
      Skin.Source := sssExternal;
      FileName := IncludeTrailingPathDelimiter(AFolder) + LazBuiltInSkinToString(BuiltIn) + '.skin';
      Skin.SaveToFile(FileName);
    finally
      Skin.Free;
    end;
  end;
end;

function TLazRibbonSkinManager.SkinCount: Integer;
begin
  if FSkins = nil then
    Result := 0
  else
    Result := FSkins.Count;
end;

function TLazRibbonSkinManager.SkinByIndex(AIndex: Integer): TLazRibbonSkinDefinition;
begin
  if (FSkins <> nil) and (AIndex >= 0) and (AIndex < FSkins.Count) then
    Result := TLazRibbonSkinDefinition(FSkins[AIndex])
  else
    Result := nil;
end;

function TLazRibbonSkinManager.FindSkin(const ASkinName: String): TLazRibbonSkinDefinition;
var
  I: Integer;
  Skin: TLazRibbonSkinDefinition;
begin
  Result := nil;
  for I := 0 to SkinCount - 1 do
  begin
    Skin := SkinByIndex(I);
    if (Skin <> nil) and
       (SameText(Skin.Name, ASkinName) or SameText(Skin.DisplayName, ASkinName)) then
    begin
      Result := Skin;
      Exit;
    end;
  end;
end;

procedure TLazRibbonSkinManager.ApplySkinDefinition(ASkin: TLazRibbonSkinDefinition);
begin
  if ASkin = nil then Exit;
  FPalette := ASkin.Palette;
  FAppearance.Assign(ASkin.Appearance);
  FActiveSkinName := ASkin.Name;
  if ASkin.Source = sssBuiltIn then
    FActiveSkin := ASkin.BuiltInSkin;
end;

procedure TLazRibbonSkinManager.ApplySkinByName(const ASkinName: String);
begin
  SetActiveSkinName(ASkinName);
end;

procedure TLazRibbonSkinManager.SetActiveSkinName(const AValue: String);
var
  Skin: TLazRibbonSkinDefinition;
  BuiltIn: TLazRibbonBuiltInSkin;
begin
  if SameText(FActiveSkinName, AValue) then Exit;
  Skin := FindSkin(AValue);
  if Skin <> nil then
  begin
    ApplySkinDefinition(Skin);
    Changed;
    Exit;
  end;
  if LazRibbon_SkinDefinition.LazBuiltInSkinFromString(AValue, BuiltIn) then
  begin
    SetActiveSkin(BuiltIn);
    Exit;
  end;
  FActiveSkinName := AValue;
  Changed;
end;

procedure TLazRibbonSkinManager.SetSkinFolder(const AValue: String);
begin
  if FSkinFolder = AValue then Exit;
  FSkinFolder := AValue;
  LoadSkins;
  Changed;
end;

function TLazRibbonSkinManager.GetBackColor: TColor;
begin
  Result := FPalette.BackColor;
end;

function TLazRibbonSkinManager.GetNavigationColor: TColor;
begin
  Result := FPalette.NavigationColor;
end;

function TLazRibbonSkinManager.GetActiveColor: TColor;
begin
  Result := FPalette.ActiveColor;
end;

function TLazRibbonSkinManager.GetHotColor: TColor;
begin
  Result := FPalette.HotColor;
end;

function TLazRibbonSkinManager.GetFrameColor: TColor;
begin
  Result := FPalette.FrameColor;
end;

function TLazRibbonSkinManager.GetTextColor: TColor;
begin
  Result := FPalette.TextColor;
end;

function TLazRibbonSkinManager.GetMutedTextColor: TColor;
begin
  Result := FPalette.MutedTextColor;
end;

function TLazRibbonSkinManager.GetRecentOddColor: TColor;
begin
  Result := FPalette.RecentOddColor;
end;

function TLazRibbonSkinManager.GetRecentHoverColor: TColor;
begin
  Result := FPalette.RecentHoverColor;
end;

function TLazRibbonSkinManager.GetRecentSelectedColor: TColor;
begin
  Result := FPalette.RecentSelectedColor;
end;

function TLazRibbonSkinManager.GetRecentSelectedFrameColor: TColor;
begin
  Result := FPalette.RecentSelectedFrameColor;
end;

function TLazRibbonSkinManager.GetRecentTitleColor: TColor;
begin
  Result := FPalette.RecentTitleColor;
end;

procedure TLazRibbonSkinManager.ResetToBuiltInSkin;
begin
  FActiveSkinName := LazBuiltInSkinToString(FActiveSkin);
  ApplyBuiltInSkin;
  FAppearance.Reset(LazStyleFromBuiltInSkin(FActiveSkin));
  ApplyPaletteToAppearance;
  ApplyBuiltInPaneAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetBackColor(AValue: TColor);
begin
  if FPalette.BackColor = AValue then Exit;
  FPalette.BackColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetNavigationColor(AValue: TColor);
begin
  if FPalette.NavigationColor = AValue then Exit;
  FPalette.NavigationColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetActiveColor(AValue: TColor);
begin
  if FPalette.ActiveColor = AValue then Exit;
  FPalette.ActiveColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetHotColor(AValue: TColor);
begin
  if FPalette.HotColor = AValue then Exit;
  FPalette.HotColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetFrameColor(AValue: TColor);
begin
  if FPalette.FrameColor = AValue then Exit;
  FPalette.FrameColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetTextColor(AValue: TColor);
begin
  if FPalette.TextColor = AValue then Exit;
  FPalette.TextColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetMutedTextColor(AValue: TColor);
begin
  if FPalette.MutedTextColor = AValue then Exit;
  FPalette.MutedTextColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetRecentOddColor(AValue: TColor);
begin
  if FPalette.RecentOddColor = AValue then Exit;
  FPalette.RecentOddColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetRecentHoverColor(AValue: TColor);
begin
  if FPalette.RecentHoverColor = AValue then Exit;
  FPalette.RecentHoverColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetRecentSelectedColor(AValue: TColor);
begin
  if FPalette.RecentSelectedColor = AValue then Exit;
  FPalette.RecentSelectedColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetRecentSelectedFrameColor(AValue: TColor);
begin
  if FPalette.RecentSelectedFrameColor = AValue then Exit;
  FPalette.RecentSelectedFrameColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetRecentTitleColor(AValue: TColor);
begin
  if FPalette.RecentTitleColor = AValue then Exit;
  FPalette.RecentTitleColor := AValue;
  ApplyPaletteToAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetActiveSkin(AValue: TLazRibbonBuiltInSkin);
begin
  if (FActiveSkin = AValue) and SameText(FActiveSkinName, LazBuiltInSkinToString(AValue)) then Exit;
  FActiveSkin := AValue;
  FActiveSkinName := LazBuiltInSkinToString(AValue);
  ApplyBuiltInSkin;
  FAppearance.Reset(LazStyleFromBuiltInSkin(FActiveSkin));
  ApplyPaletteToAppearance;
  ApplyBuiltInPaneAppearance;
  Changed;
end;

procedure TLazRibbonSkinManager.SetAutoRefreshControls(AValue: Boolean);
begin
  if FAutoRefreshControls = AValue then Exit;
  FAutoRefreshControls := AValue;
end;

procedure TLazRibbonSkinManager.SetAppearance(AValue: TLazRibbonToolbarAppearance);
begin
  if AValue = nil then Exit;
  FAppearance.Assign(AValue);
  Changed;
end;


finalization
  while (GSkinChangeHandlers <> nil) and (GSkinChangeHandlers.Count > 0) do
  begin
    TObject(GSkinChangeHandlers[0]).Free;
    GSkinChangeHandlers.Delete(0);
  end;
  GSkinChangeHandlers.Free;
  GSkinChangeHandlers := nil;

end.
