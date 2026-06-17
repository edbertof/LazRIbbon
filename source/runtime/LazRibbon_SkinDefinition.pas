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

unit LazRibbon_SkinDefinition;

{$mode Delphi}{$H+}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_SkinDefinition.pas                                        *
*  Description: External skin model for LazRibbon_Core.                            *
*               This unit deliberately does not depend on LazRibbon_Core or on the *
*               design-time editor. It is the future base for the standalone   *
*               SkinEditor application.                                       *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, SysUtils, Math, Graphics, Types,
  LazRibbon_GUITools, LazRibbon_GraphTools, LazRibbon_Appearance, LazRibbon_XMLParser;

type
  TLazRibbonBuiltInSkin = (sbsOfficeBlue, sbsOfficeSilver, sbsOfficeBlack, sbsCaramel,
    sbsMetroLight, sbsMetroDark, sbsOlive, sbsPurple, sbsModernLight);

  TLazRibbonSkinSource = (sssBuiltIn, sssExternal, sssCustom);

  TLazRibbonSkinPalette = record
    BackColor: TColor;
    NavigationColor: TColor;
    ActiveColor: TColor;
    HotColor: TColor;
    FrameColor: TColor;
    TextColor: TColor;
    MutedTextColor: TColor;
    { BackStage navigation colors are deliberately separate from generic
      ActiveColor/HotColor/TextColor. The same generic colors are used by
      several Ribbon surfaces; using them directly in BackStage made active
      items unreadable in some skins. }
    BackstageNavColor: TColor;
    BackstageNavTextColor: TColor;
    BackstageNavMutedTextColor: TColor;
    BackstageNavHoverColor: TColor;
    BackstageNavHoverTextColor: TColor;
    BackstageNavSelectedColor: TColor;
    BackstageNavSelectedTextColor: TColor;
    BackstageNavSelectedFrameColor: TColor;
    RecentOddColor: TColor;
    RecentHoverColor: TColor;
    RecentSelectedColor: TColor;
    RecentSelectedFrameColor: TColor;
    RecentTitleColor: TColor;
    RibbonTopColor: TColor;
    RibbonBottomColor: TColor;
    RibbonTabActiveColor: TColor;
    RibbonTabHotColor: TColor;
    RibbonGroupColor: TColor;
    RibbonGroupFrameColor: TColor;
  end;

  { TLazRibbonSkinDefinition

    A complete skin definition that can be stored outside the component source.
    The editor will work on this object instead of changing LazRibbon_Appearance.pas. }

  TLazRibbonSkinDefinition = class(TPersistent)
  private
    FName: String;
    FDisplayName: String;
    FGroupName: String;
    FAuthor: String;
    FDescription: String;
    FNotes: String;
    FFormatVersion: String;
    FIcon16FileName: String;
    FIcon24FileName: String;
    FIcon32FileName: String;
    FIcon16Data: String;
    FIcon24Data: String;
    FIcon32Data: String;
    FPreviewImageFileName: String;
    FFileName: String;
    FSource: TLazRibbonSkinSource;
    FBuiltInSkin: TLazRibbonBuiltInSkin;
    FPalette: TLazRibbonSkinPalette;
    FAppearance: TLazRibbonToolbarAppearance;
    procedure SetAppearance(AValue: TLazRibbonToolbarAppearance);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignPalette(const APalette: TLazRibbonSkinPalette);
    procedure AssignPaletteOnly(const APalette: TLazRibbonSkinPalette);
    procedure ApplyPaletteToAppearance;
    procedure ResetToBuiltInSkin(ASkin: TLazRibbonBuiltInSkin);
    procedure LoadFromFile(const AFileName: String);
    procedure SaveToFile(const AFileName: String);
    function IconFileNameForSize(ASize: Integer): String;
    function IconDataForSize(ASize: Integer): String;
    procedure UpdateEmbeddedIconDataFromFiles;
    function ResolveAssetFileName(const AFileName: String): String;
    property Palette: TLazRibbonSkinPalette read FPalette;
    property FileName: String read FFileName write FFileName;
    { File-name fields are kept for code compatibility and for editors that
      import icon files. New distributable .skin files should rely on the
      embedded Icon*Data fields instead. }
    property Icon16FileName: String read FIcon16FileName write FIcon16FileName;
    property Icon24FileName: String read FIcon24FileName write FIcon24FileName;
    property Icon32FileName: String read FIcon32FileName write FIcon32FileName;
  published
    property Name: String read FName write FName;
    property DisplayName: String read FDisplayName write FDisplayName;
    property GroupName: String read FGroupName write FGroupName;
    property Author: String read FAuthor write FAuthor;
    property Description: String read FDescription write FDescription;
    property Notes: String read FNotes write FNotes;
    property FormatVersion: String read FFormatVersion write FFormatVersion;
    property Icon16Data: String read FIcon16Data write FIcon16Data;
    property Icon24Data: String read FIcon24Data write FIcon24Data;
    property Icon32Data: String read FIcon32Data write FIcon32Data;
    property PreviewImageFileName: String read FPreviewImageFileName write FPreviewImageFileName;
    property Source: TLazRibbonSkinSource read FSource write FSource default sssCustom;
    property BuiltInSkin: TLazRibbonBuiltInSkin read FBuiltInSkin write FBuiltInSkin default sbsOfficeBlue;
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;
  end;

function LazBuiltInSkinCount: Integer;
function LazBuiltInSkinByIndex(AIndex: Integer): TLazRibbonBuiltInSkin;
function LazBuiltInSkinToString(ASkin: TLazRibbonBuiltInSkin): String;
function LazBuiltInSkinCaption(ASkin: TLazRibbonBuiltInSkin): String;
function LazBuiltInSkinFromString(const AName: String; out ASkin: TLazRibbonBuiltInSkin): Boolean;
function LazBuiltInSkinMainColor(ASkin: TLazRibbonBuiltInSkin): TColor;
function LazBuiltInSkinAccentColor(ASkin: TLazRibbonBuiltInSkin): TColor;
function LazDefaultPaletteForBuiltInSkin(ASkin: TLazRibbonBuiltInSkin): TLazRibbonSkinPalette;
function LazStyleFromBuiltInSkin(ASkin: TLazRibbonBuiltInSkin): TLazRibbonStyle;

function LazFileLooksLikeXML(const AFileName: String): Boolean;
function LazReadSkinColor(AList: TStrings; const AName: String; ADefault: TColor): TColor;
function LazReadSkinString(AList: TStrings; const AName, ADefault: String): String;
function LazDrawSkinDefinitionIcon(ACanvas: TCanvas; ASkin: TLazRibbonSkinDefinition;
  APreferredSize: Integer; const ARect: TRect): Boolean;

const
  LAZRIBBON_MIN_TEXT_CONTRAST = 4.5;

function LazRelativeLuminance(AColor: TColor): Double;
function LazContrastRatio(AColor1, AColor2: TColor): Double;
function LazEnsureContrastTextColor(ABackColor, APreferred: TColor;
  AMinRatio: Double = LAZRIBBON_MIN_TEXT_CONTRAST): TColor;

implementation

uses
  base64;

function LazBase64FromFile(const AFileName: String): String;
var
  S: TFileStream;
  Data: String;
begin
  Result := '';
  if (Trim(AFileName) = '') or (not FileExists(AFileName)) then
    Exit;

  S := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Data := '';
    SetLength(Data, S.Size);
    if Length(Data) > 0 then
      S.ReadBuffer(Data[1], Length(Data));
    Result := EncodeStringBase64(Data);
  finally
    S.Free;
  end;
end;

function LazCleanBase64Text(const AValue: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
    if not (AValue[I] in [#9, #10, #13, ' ']) then
      Result := Result + AValue[I];
end;

function LazLoadPictureFromBase64(const AData: String; APicture: TPicture): Boolean;
var
  Decoded: String;
  Stream: TMemoryStream;
begin
  Result := False;
  if (APicture = nil) or (Trim(AData) = '') then
    Exit;

  Stream := TMemoryStream.Create;
  try
    Decoded := DecodeStringBase64(LazCleanBase64Text(AData));
    if Length(Decoded) = 0 then
      Exit;
    Stream.WriteBuffer(Decoded[1], Length(Decoded));
    Stream.Position := 0;
    APicture.LoadFromStream(Stream);
    Result := (APicture.Graphic <> nil) and not APicture.Graphic.Empty;
  finally
    Stream.Free;
  end;
end;

function LazSRGBComponentToLinear(AValue: Integer): Double;
var
  V: Double;
begin
  V := AValue / 255.0;
  if V <= 0.03928 then
    Result := V / 12.92
  else
    Result := Power((V + 0.055) / 1.055, 2.4);
end;

function LazRelativeLuminance(AColor: TColor): Double;
var
  C: LongInt;
begin
  C := ColorToRGB(AColor);
  Result := 0.2126 * LazSRGBComponentToLinear(C and $FF) +
    0.7152 * LazSRGBComponentToLinear((C shr 8) and $FF) +
    0.0722 * LazSRGBComponentToLinear((C shr 16) and $FF);
end;

function LazContrastRatio(AColor1, AColor2: TColor): Double;
var
  L1, L2, T: Double;
begin
  L1 := LazRelativeLuminance(AColor1);
  L2 := LazRelativeLuminance(AColor2);
  if L1 < L2 then
  begin
    T := L1;
    L1 := L2;
    L2 := T;
  end;
  Result := (L1 + 0.05) / (L2 + 0.05);
end;

function LazEnsureContrastTextColor(ABackColor, APreferred: TColor;
  AMinRatio: Double): TColor;
var
  BackRGB, PreferredRGB: TColor;
  BlackRatio, WhiteRatio: Double;
begin
  BackRGB := ColorToRGB(ABackColor);
  PreferredRGB := ColorToRGB(APreferred);

  if LazContrastRatio(PreferredRGB, BackRGB) >= AMinRatio then
    Exit(PreferredRGB);

  BlackRatio := LazContrastRatio(clBlack, BackRGB);
  WhiteRatio := LazContrastRatio(clWhite, BackRGB);
  if BlackRatio >= WhiteRatio then
    Result := clBlack
  else
    Result := clWhite;
end;

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

function LazBuiltInSkinFromString(const AName: String; out ASkin: TLazRibbonBuiltInSkin): Boolean;
var
  I: Integer;
  S: String;
begin
  Result := False;
  S := Trim(AName);
  for I := 0 to LazBuiltInSkinCount - 1 do
  begin
    ASkin := LazBuiltInSkinByIndex(I);
    if SameText(S, LazBuiltInSkinToString(ASkin)) or
       SameText(S, LazBuiltInSkinCaption(ASkin)) then
    begin
      Result := True;
      Exit;
    end;
  end;
  if SameText(S, 'Caramel') then
  begin
    ASkin := sbsCaramel;
    Result := True;
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

function LazStyleFromBuiltInSkin(ASkin: TLazRibbonBuiltInSkin): TLazRibbonStyle;
begin
  case ASkin of
    sbsOfficeSilver: Result := lazOffice2007Silver;
    sbsOfficeBlack: Result := lazOffice2007Silver;
    sbsCaramel: Result := lazOffice2007Bege;
    sbsMetroLight: Result := lazMetroLight;
    sbsMetroDark: Result := lazMetroDark;
    sbsOlive: Result := lazOffice2007Sage;
    sbsPurple: Result := lazOffice2007Rose;
    sbsModernLight: Result := lazMetroLight;
  else
    Result := lazOffice2007Blue;
  end;
end;

function LazDefaultPaletteForBuiltInSkin(ASkin: TLazRibbonBuiltInSkin): TLazRibbonSkinPalette;
begin
  FillChar(Result, SizeOf(Result), 0);
  case ASkin of
    sbsOfficeSilver:
      begin
        Result.BackColor := clWhite;
        Result.NavigationColor := RGBToColor(241, 242, 244);
        Result.ActiveColor := RGBToColor(218, 221, 228);
        Result.HotColor := RGBToColor(232, 235, 240);
        Result.FrameColor := RGBToColor(169, 177, 192);
        Result.TextColor := RGBToColor(32, 32, 32);
        Result.MutedTextColor := RGBToColor(96, 96, 96);
        Result.BackstageNavColor := Result.NavigationColor;
        Result.BackstageNavTextColor := Result.TextColor;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := Result.HotColor;
        Result.BackstageNavHoverTextColor := Result.TextColor;
        Result.BackstageNavSelectedColor := clWhite;
        Result.BackstageNavSelectedTextColor := Result.TextColor;
        Result.BackstageNavSelectedFrameColor := RGBToColor(95, 105, 120);
        Result.RecentOddColor := RGBToColor(248, 249, 251);
        Result.RecentHoverColor := RGBToColor(236, 240, 247);
        Result.RecentSelectedColor := RGBToColor(224, 230, 241);
        Result.RecentSelectedFrameColor := RGBToColor(150, 161, 183);
        Result.RecentTitleColor := RGBToColor(40, 50, 70);
        Result.RibbonTopColor := RGBToColor(231, 234, 238);
        Result.RibbonBottomColor := RGBToColor(248, 249, 251);
        Result.RibbonTabActiveColor := clWhite;
        Result.RibbonTabHotColor := RGBToColor(235, 238, 243);
        Result.RibbonGroupColor := RGBToColor(246, 247, 249);
        Result.RibbonGroupFrameColor := RGBToColor(180, 186, 198);
      end;
    sbsOfficeBlack:
      begin
        Result.BackColor := RGBToColor(54, 54, 54);
        Result.NavigationColor := RGBToColor(42, 42, 42);
        Result.ActiveColor := RGBToColor(246, 191, 45);
        Result.HotColor := RGBToColor(72, 72, 72);
        Result.FrameColor := RGBToColor(98, 98, 98);
        Result.TextColor := clWhite;
        Result.MutedTextColor := RGBToColor(190, 190, 190);
        Result.BackstageNavColor := Result.NavigationColor;
        Result.BackstageNavTextColor := clWhite;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := Result.HotColor;
        Result.BackstageNavHoverTextColor := clWhite;
        Result.BackstageNavSelectedColor := Result.BackColor;
        Result.BackstageNavSelectedTextColor := clWhite;
        Result.BackstageNavSelectedFrameColor := RGBToColor(246, 191, 45);
        Result.RecentOddColor := RGBToColor(62, 62, 62);
        Result.RecentHoverColor := RGBToColor(76, 76, 76);
        Result.RecentSelectedColor := RGBToColor(246, 191, 45);
        Result.RecentSelectedFrameColor := RGBToColor(160, 112, 0);
        Result.RecentTitleColor := clWhite;
        Result.RibbonTopColor := RGBToColor(35, 35, 35);
        Result.RibbonBottomColor := RGBToColor(75, 75, 75);
        Result.RibbonTabActiveColor := RGBToColor(72, 72, 72);
        Result.RibbonTabHotColor := RGBToColor(90, 90, 90);
        Result.RibbonGroupColor := RGBToColor(62, 62, 62);
        Result.RibbonGroupFrameColor := RGBToColor(110, 110, 110);
      end;
    sbsMetroLight:
      begin
        Result.BackColor := RGBToColor(250, 250, 250);
        Result.NavigationColor := RGBToColor(245, 246, 248);
        Result.ActiveColor := RGBToColor(0, 120, 215);
        Result.HotColor := RGBToColor(232, 236, 241);
        Result.FrameColor := RGBToColor(204, 210, 218);
        Result.TextColor := RGBToColor(30, 30, 30);
        Result.MutedTextColor := RGBToColor(110, 110, 110);
        Result.BackstageNavColor := Result.NavigationColor;
        Result.BackstageNavTextColor := Result.TextColor;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := Result.HotColor;
        Result.BackstageNavHoverTextColor := Result.TextColor;
        Result.BackstageNavSelectedColor := clWhite;
        Result.BackstageNavSelectedTextColor := Result.TextColor;
        Result.BackstageNavSelectedFrameColor := RGBToColor(0, 90, 170);
        Result.RecentOddColor := RGBToColor(248, 249, 250);
        Result.RecentHoverColor := RGBToColor(235, 239, 244);
        Result.RecentSelectedColor := RGBToColor(225, 240, 252);
        Result.RecentSelectedFrameColor := RGBToColor(0, 120, 215);
        Result.RecentTitleColor := RGBToColor(30, 30, 30);
        Result.RibbonTopColor := RGBToColor(245, 246, 248);
        Result.RibbonBottomColor := RGBToColor(232, 236, 241);
        Result.RibbonTabActiveColor := clWhite;
        Result.RibbonTabHotColor := RGBToColor(235, 239, 244);
        Result.RibbonGroupColor := clWhite;
        Result.RibbonGroupFrameColor := RGBToColor(190, 196, 204);
      end;
    sbsMetroDark:
      begin
        Result.BackColor := RGBToColor(40, 40, 40);
        Result.NavigationColor := RGBToColor(32, 32, 32);
        Result.ActiveColor := RGBToColor(0, 122, 204);
        Result.HotColor := RGBToColor(58, 58, 58);
        Result.FrameColor := RGBToColor(68, 68, 68);
        Result.TextColor := clWhite;
        Result.MutedTextColor := RGBToColor(190, 190, 190);
        Result.BackstageNavColor := Result.NavigationColor;
        Result.BackstageNavTextColor := clWhite;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := Result.HotColor;
        Result.BackstageNavHoverTextColor := clWhite;
        Result.BackstageNavSelectedColor := Result.BackColor;
        Result.BackstageNavSelectedTextColor := clWhite;
        Result.BackstageNavSelectedFrameColor := RGBToColor(0, 88, 148);
        Result.RecentOddColor := RGBToColor(46, 46, 46);
        Result.RecentHoverColor := RGBToColor(58, 58, 58);
        Result.RecentSelectedColor := RGBToColor(0, 122, 204);
        Result.RecentSelectedFrameColor := RGBToColor(0, 88, 148);
        Result.RecentTitleColor := clWhite;
        Result.RibbonTopColor := RGBToColor(50, 50, 50);
        Result.RibbonBottomColor := RGBToColor(32, 32, 32);
        Result.RibbonTabActiveColor := RGBToColor(50, 50, 50);
        Result.RibbonTabHotColor := RGBToColor(74, 74, 74);
        Result.RibbonGroupColor := RGBToColor(50, 50, 50);
        Result.RibbonGroupFrameColor := RGBToColor(74, 74, 74);
      end;
    sbsOlive:
      begin
        Result.BackColor := RGBToColor(250, 252, 244);
        Result.NavigationColor := RGBToColor(218, 226, 198);
        Result.ActiveColor := RGBToColor(161, 188, 72);
        Result.HotColor := RGBToColor(242, 247, 230);
        Result.FrameColor := RGBToColor(112, 128, 82);
        Result.TextColor := RGBToColor(20, 35, 20);
        Result.MutedTextColor := RGBToColor(88, 105, 62);
        Result.BackstageNavColor := Result.NavigationColor;
        Result.BackstageNavTextColor := Result.TextColor;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := Result.HotColor;
        Result.BackstageNavHoverTextColor := Result.TextColor;
        Result.BackstageNavSelectedColor := Result.BackColor;
        Result.BackstageNavSelectedTextColor := Result.TextColor;
        Result.BackstageNavSelectedFrameColor := RGBToColor(80, 110, 42);
        Result.RecentOddColor := RGBToColor(248, 251, 240);
        Result.RecentHoverColor := RGBToColor(235, 244, 214);
        Result.RecentSelectedColor := RGBToColor(220, 235, 153);
        Result.RecentSelectedFrameColor := RGBToColor(116, 145, 62);
        Result.RecentTitleColor := RGBToColor(20, 35, 20);
        Result.RibbonTopColor := RGBToColor(218, 226, 198);
        Result.RibbonBottomColor := RGBToColor(242, 247, 230);
        Result.RibbonTabActiveColor := RGBToColor(250, 252, 244);
        Result.RibbonTabHotColor := RGBToColor(212, 226, 180);
        Result.RibbonGroupColor := RGBToColor(244, 249, 232);
        Result.RibbonGroupFrameColor := RGBToColor(105, 122, 76);
      end;
    sbsPurple:
      begin
        Result.BackColor := RGBToColor(252, 248, 255);
        Result.NavigationColor := RGBToColor(228, 218, 239);
        Result.ActiveColor := RGBToColor(168, 112, 198);
        Result.HotColor := RGBToColor(241, 232, 249);
        Result.FrameColor := RGBToColor(136, 72, 180);
        Result.TextColor := RGBToColor(45, 20, 65);
        Result.MutedTextColor := RGBToColor(112, 86, 130);
        Result.BackstageNavColor := Result.NavigationColor;
        Result.BackstageNavTextColor := Result.TextColor;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := Result.HotColor;
        Result.BackstageNavHoverTextColor := Result.TextColor;
        Result.BackstageNavSelectedColor := Result.BackColor;
        Result.BackstageNavSelectedTextColor := Result.TextColor;
        Result.BackstageNavSelectedFrameColor := RGBToColor(98, 48, 138);
        Result.RecentOddColor := RGBToColor(251, 247, 255);
        Result.RecentHoverColor := RGBToColor(239, 229, 249);
        Result.RecentSelectedColor := RGBToColor(226, 205, 244);
        Result.RecentSelectedFrameColor := RGBToColor(136, 72, 180);
        Result.RecentTitleColor := RGBToColor(45, 20, 65);
        Result.RibbonTopColor := RGBToColor(228, 218, 239);
        Result.RibbonBottomColor := RGBToColor(246, 238, 252);
        Result.RibbonTabActiveColor := RGBToColor(252, 248, 255);
        Result.RibbonTabHotColor := RGBToColor(236, 224, 248);
        Result.RibbonGroupColor := RGBToColor(249, 244, 253);
        Result.RibbonGroupFrameColor := RGBToColor(136, 72, 180);
      end;
    sbsModernLight:
      begin
        { 1.1.38: restrained light palette for a more contemporary Ribbon surface.
          It deliberately uses flatter surfaces, weaker borders and a single blue
          accent so the component looks cleaner without changing drawing code. }
        Result.BackColor := clWhite;
        Result.NavigationColor := RGBToColor(246, 248, 251);
        Result.ActiveColor := RGBToColor(222, 238, 252);
        Result.HotColor := RGBToColor(241, 246, 252);
        Result.FrameColor := RGBToColor(210, 218, 229);
        Result.TextColor := RGBToColor(32, 36, 43);
        Result.MutedTextColor := RGBToColor(96, 105, 118);
        Result.BackstageNavColor := RGBToColor(247, 249, 252);
        Result.BackstageNavTextColor := Result.TextColor;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := RGBToColor(235, 244, 253);
        Result.BackstageNavHoverTextColor := Result.TextColor;
        Result.BackstageNavSelectedColor := clWhite;
        Result.BackstageNavSelectedTextColor := Result.TextColor;
        Result.BackstageNavSelectedFrameColor := RGBToColor(0, 102, 204);
        Result.RecentOddColor := RGBToColor(250, 251, 253);
        Result.RecentHoverColor := RGBToColor(240, 247, 254);
        Result.RecentSelectedColor := RGBToColor(224, 240, 255);
        Result.RecentSelectedFrameColor := RGBToColor(0, 102, 204);
        Result.RecentTitleColor := RGBToColor(28, 48, 74);
        Result.RibbonTopColor := RGBToColor(248, 249, 251);
        Result.RibbonBottomColor := RGBToColor(252, 253, 254);
        Result.RibbonTabActiveColor := clWhite;
        Result.RibbonTabHotColor := RGBToColor(238, 246, 254);
        Result.RibbonGroupColor := RGBToColor(252, 253, 254);
        Result.RibbonGroupFrameColor := RGBToColor(218, 225, 235);
      end;
    sbsCaramel:
      begin
        Result.BackColor := RGBToColor(255, 250, 242);
        Result.NavigationColor := RGBToColor(237, 218, 190);
        Result.ActiveColor := RGBToColor(210, 156, 84);
        Result.HotColor := RGBToColor(249, 234, 210);
        Result.FrameColor := RGBToColor(174, 132, 82);
        Result.TextColor := RGBToColor(65, 42, 24);
        Result.MutedTextColor := RGBToColor(120, 86, 52);
        Result.BackstageNavColor := Result.NavigationColor;
        Result.BackstageNavTextColor := Result.TextColor;
        Result.BackstageNavMutedTextColor := Result.MutedTextColor;
        Result.BackstageNavHoverColor := Result.HotColor;
        Result.BackstageNavHoverTextColor := Result.TextColor;
        Result.BackstageNavSelectedColor := Result.BackColor;
        Result.BackstageNavSelectedTextColor := Result.TextColor;
        Result.BackstageNavSelectedFrameColor := RGBToColor(132, 90, 48);
        Result.RecentOddColor := RGBToColor(252, 248, 240);
        Result.RecentHoverColor := RGBToColor(247, 237, 220);
        Result.RecentSelectedColor := RGBToColor(255, 248, 232);
        Result.RecentSelectedFrameColor := RGBToColor(178, 139, 92);
        Result.RecentTitleColor := RGBToColor(80, 48, 22);
        Result.RibbonTopColor := RGBToColor(183, 150, 124);
        Result.RibbonBottomColor := RGBToColor(249, 240, 224);
        Result.RibbonTabActiveColor := RGBToColor(255, 250, 240);
        Result.RibbonTabHotColor := RGBToColor(248, 232, 205);
        Result.RibbonGroupColor := RGBToColor(248, 239, 222);
        Result.RibbonGroupFrameColor := RGBToColor(187, 154, 122);
      end;
  else
    begin
      Result.BackColor := clWhite;
      Result.NavigationColor := RGBToColor(232, 242, 252);
      Result.ActiveColor := RGBToColor(220, 235, 250);
      Result.HotColor := RGBToColor(234, 243, 252);
      Result.FrameColor := RGBToColor(148, 182, 210);
      Result.TextColor := RGBToColor(30, 57, 91);
      Result.MutedTextColor := RGBToColor(95, 111, 127);
      Result.BackstageNavColor := Result.NavigationColor;
      Result.BackstageNavTextColor := Result.TextColor;
      Result.BackstageNavMutedTextColor := Result.MutedTextColor;
      Result.BackstageNavHoverColor := Result.HotColor;
      Result.BackstageNavHoverTextColor := Result.TextColor;
      Result.BackstageNavSelectedColor := clWhite;
      Result.BackstageNavSelectedTextColor := Result.TextColor;
      Result.BackstageNavSelectedFrameColor := RGBToColor(34, 78, 150);
      Result.RecentOddColor := RGBToColor(248, 250, 253);
      Result.RecentHoverColor := RGBToColor(236, 244, 253);
      Result.RecentSelectedColor := RGBToColor(219, 235, 252);
      Result.RecentSelectedFrameColor := RGBToColor(126, 169, 219);
      Result.RecentTitleColor := RGBToColor(0, 60, 130);
      Result.RibbonTopColor := RGBToColor(191, 218, 241);
      Result.RibbonBottomColor := RGBToColor(237, 247, 255);
      Result.RibbonTabActiveColor := clWhite;
      Result.RibbonTabHotColor := RGBToColor(219, 236, 250);
      Result.RibbonGroupColor := RGBToColor(238, 247, 254);
      Result.RibbonGroupFrameColor := RGBToColor(148, 182, 210);
    end;
  end;
end;

function LazReadSkinColor(AList: TStrings; const AName: String; ADefault: TColor): TColor;
var
  I, P: Integer;
  S, K, V: String;
begin
  Result := ADefault;
  if AList = nil then Exit;
  for I := 0 to AList.Count - 1 do
  begin
    S := Trim(AList[I]);
    if (S = '') or (S[1] = '#') or (S[1] = ';') then Continue;
    P := Pos('=', S);
    if P <= 0 then Continue;
    K := Trim(Copy(S, 1, P - 1));
    V := Trim(Copy(S, P + 1, MaxInt));
    if SameText(K, AName) then
    begin
      if (Length(V) > 0) and (V[1] = '$') then
        Result := StrToIntDef(V, ADefault)
      else if (Length(V) > 0) and (V[1] = '#') then
        Result := StrToIntDef('$' + Copy(V, 2, MaxInt), ADefault)
      else
        Result := StrToIntDef(V, ADefault);
      Exit;
    end;
  end;
end;

function LazReadSkinString(AList: TStrings; const AName, ADefault: String): String;
var
  I, P: Integer;
  S, K: String;
begin
  Result := ADefault;
  if AList = nil then Exit;
  for I := 0 to AList.Count - 1 do
  begin
    S := Trim(AList[I]);
    if (S = '') or (S[1] = '#') or (S[1] = ';') then Continue;
    P := Pos('=', S);
    if P <= 0 then Continue;
    K := Trim(Copy(S, 1, P - 1));
    if SameText(K, AName) then
    begin
      Result := Trim(Copy(S, P + 1, MaxInt));
      Exit;
    end;
  end;
end;

function LazDrawSkinDefinitionIcon(ACanvas: TCanvas; ASkin: TLazRibbonSkinDefinition;
  APreferredSize: Integer; const ARect: TRect): Boolean;
var
  FN: String;
  Pic: TPicture;
begin
  Result := False;
  if (ACanvas = nil) or (ASkin = nil) then Exit;

  Pic := TPicture.Create;
  try
    try
      if LazLoadPictureFromBase64(ASkin.IconDataForSize(APreferredSize), Pic) then
      begin
        ACanvas.StretchDraw(ARect, Pic.Graphic);
        Result := True;
        Exit;
      end;

      FN := ASkin.ResolveAssetFileName(ASkin.IconFileNameForSize(APreferredSize));
      if (FN <> '') and FileExists(FN) then
      begin
        Pic.LoadFromFile(FN);
        if (Pic.Graphic <> nil) and not Pic.Graphic.Empty then
        begin
          ACanvas.StretchDraw(ARect, Pic.Graphic);
          Result := True;
        end;
      end;
    except
      Result := False;
    end;
  finally
    Pic.Free;
  end;
end;

function LazFileLooksLikeXML(const AFileName: String): Boolean;
var
  L: TStringList;
  S: String;
begin
  Result := False;
  if not FileExists(AFileName) then Exit;
  L := TStringList.Create;
  try
    L.LoadFromFile(AFileName);
    S := Trim(L.Text);
    Result := (S <> '') and (S[1] = '<');
  finally
    L.Free;
  end;
end;

function XMLText(AParent: TLazRibbonXMLNode; const AName, ADefault: String): String;
var
  N: TLazRibbonXMLNode;
begin
  Result := ADefault;
  if AParent = nil then Exit;
  N := AParent[AName, False];
  if N <> nil then
    Result := N.Text;
end;

function XMLColor(AParent: TLazRibbonXMLNode; const AName: String; ADefault: TColor): TColor;
var
  N: TLazRibbonXMLNode;
begin
  Result := ADefault;
  if AParent = nil then Exit;
  N := AParent[AName, False];
  if N <> nil then
    Result := N.TextAsColor;
end;

procedure LoadSkinXMLWithCompatibility(AParser: TLazRibbonXMLParser; const AFileName: String);
var
  L: TStringList;
  S: String;
begin
  { 1.1.20 could write the inherited Appearance node as <Menu Button>.
    That is not a valid XML element name and makes the legacy XML parser fail
    with "Expected equality sign" before the editor can load the file.
    Normalize that known invalid tag while loading, then keep saving as the
    valid <MenuButton> node from 1.1.21 onward. }
  L := TStringList.Create;
  try
    L.LoadFromFile(AFileName);
    S := L.Text;
    S := StringReplace(S, '<Menu Button', '<MenuButton', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, '</Menu Button>', '</MenuButton>', [rfReplaceAll, rfIgnoreCase]);
    AParser.Parse(PChar(S));
  finally
    L.Free;
  end;
end;

{ TLazRibbonSkinDefinition }

constructor TLazRibbonSkinDefinition.Create;
begin
  inherited Create;
  FAppearance := TLazRibbonToolbarAppearance.Create(nil);
  FFormatVersion := '5';
  FSource := sssCustom;
  FBuiltInSkin := sbsOfficeBlue;
  ResetToBuiltInSkin(sbsOfficeBlue);
end;

destructor TLazRibbonSkinDefinition.Destroy;
begin
  FAppearance.Free;
  inherited Destroy;
end;

procedure TLazRibbonSkinDefinition.Assign(Source: TPersistent);
var
  Src: TLazRibbonSkinDefinition;
begin
  if Source is TLazRibbonSkinDefinition then
  begin
    Src := TLazRibbonSkinDefinition(Source);
    FName := Src.FName;
    FDisplayName := Src.FDisplayName;
    FGroupName := Src.FGroupName;
    FAuthor := Src.FAuthor;
    FDescription := Src.FDescription;
    FNotes := Src.FNotes;
    FFormatVersion := Src.FFormatVersion;
    FIcon16FileName := Src.FIcon16FileName;
    FIcon24FileName := Src.FIcon24FileName;
    FIcon32FileName := Src.FIcon32FileName;
    FIcon16Data := Src.FIcon16Data;
    FIcon24Data := Src.FIcon24Data;
    FIcon32Data := Src.FIcon32Data;
    FPreviewImageFileName := Src.FPreviewImageFileName;
    FFileName := Src.FFileName;
    FSource := Src.FSource;
    FBuiltInSkin := Src.FBuiltInSkin;
    FPalette := Src.FPalette;
    FAppearance.Assign(Src.FAppearance);
  end
  else
    inherited Assign(Source);
end;

procedure TLazRibbonSkinDefinition.AssignPalette(const APalette: TLazRibbonSkinPalette);
begin
  FPalette := APalette;
  ApplyPaletteToAppearance;
end;

procedure TLazRibbonSkinDefinition.AssignPaletteOnly(const APalette: TLazRibbonSkinPalette);
begin
  FPalette := APalette;
end;

procedure TLazRibbonSkinDefinition.ApplyPaletteToAppearance;
begin
  if FAppearance = nil then
    Exit;

  with FAppearance.Tab do
  begin
    BorderColor := FPalette.FrameColor;
    GradientFromColor := FPalette.RibbonTopColor;
    GradientToColor := FPalette.RibbonBottomColor;
    GradientType := bkVerticalGradient;
    InactiveTabHeaderFontColor := FPalette.MutedTextColor;
    TabHeaderFont.Color := FPalette.TextColor;
  end;

  with FAppearance.MenuButton do
  begin
    IdleFrameColor := FPalette.FrameColor;
    IdleGradientFromColor := FPalette.RibbonTopColor;
    IdleGradientToColor := FPalette.RibbonBottomColor;
    IdleGradientType := bkVerticalGradient;
    IdleCaptionColor := FPalette.TextColor;
    HotTrackFrameColor := FPalette.FrameColor;
    HotTrackGradientFromColor := FPalette.HotColor;
    HotTrackGradientToColor := FPalette.HotColor;
    HotTrackGradientType := bkSolid;
    HotTrackCaptionColor := FPalette.TextColor;
    ActiveFrameColor := FPalette.FrameColor;
    ActiveGradientFromColor := FPalette.ActiveColor;
    ActiveGradientToColor := FPalette.ActiveColor;
    ActiveGradientType := bkSolid;
    ActiveCaptionColor := FPalette.TextColor;
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
    CaptionFont.Color := FPalette.TextColor;
    GradientFromColor := TColorTools.Shade(FPalette.RibbonGroupColor, FPalette.RibbonTopColor, 55);
    GradientToColor := TColorTools.Shade(FPalette.RibbonGroupColor, FPalette.RibbonBottomColor, 55);
    GradientType := bkVerticalGradient;
  end;

  with FAppearance.Element do
  begin
    CaptionFont.Color := FPalette.TextColor;
    IdleFrameColor := FPalette.FrameColor;
    IdleGradientFromColor := FPalette.BackColor;
    IdleGradientToColor := FPalette.BackColor;
    IdleGradientType := bkSolid;
    IdleCaptionColor := FPalette.TextColor;
    HotTrackFrameColor := FPalette.FrameColor;
    HotTrackGradientFromColor := FPalette.HotColor;
    HotTrackGradientToColor := FPalette.HotColor;
    HotTrackGradientType := bkSolid;
    HotTrackCaptionColor := FPalette.TextColor;
    ActiveFrameColor := FPalette.FrameColor;
    ActiveGradientFromColor := FPalette.ActiveColor;
    ActiveGradientToColor := FPalette.ActiveColor;
    ActiveGradientType := bkSolid;
    ActiveCaptionColor := FPalette.TextColor;
  end;

  with FAppearance.Popup do
  begin
    CaptionFont.Color := FPalette.TextColor;
    IdleCaptionColor := FPalette.TextColor;
    IdleGradientFromColor := FPalette.BackColor;
    IdleGradientToColor := FPalette.BackColor;
    IdleGradientType := bkSolid;
    HotTrackCaptionColor := FPalette.TextColor;
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
    DisabledCaptionColor := FPalette.MutedTextColor;
    DividerLineColor := FPalette.FrameColor;
  end;

  FAppearance.NotifyAppearanceChanged;
end;

procedure TLazRibbonSkinDefinition.ResetToBuiltInSkin(ASkin: TLazRibbonBuiltInSkin);
begin
  FBuiltInSkin := ASkin;
  FSource := sssBuiltIn;
  FName := LazBuiltInSkinToString(ASkin);
  FDisplayName := LazBuiltInSkinCaption(ASkin);
  FGroupName := 'Standard Skins';
  FAuthor := 'LazRibbon';
  FDescription := 'Built-in LazRibbon skin';
  FNotes := FDescription;
  FIcon16FileName := '';
  FIcon24FileName := '';
  FIcon32FileName := '';
  FIcon16Data := '';
  FIcon24Data := '';
  FIcon32Data := '';
  FPreviewImageFileName := '';
  FPalette := LazDefaultPaletteForBuiltInSkin(ASkin);
  FAppearance.Reset(LazStyleFromBuiltInSkin(ASkin));
  ApplyPaletteToAppearance;

  {
    0.1.14: For built-in Office-style skins, keep the full appearance calibrated
    by LazRibbon_Appearance.Reset.  The original demos/basic project uses that
    tuned Appearance directly.  Applying the generic palette over it makes the
    Ribbon and Panes visually diverge.

    Dark skins and Modern Light remain palette-derived because the original
    appearance table either has no matching baseline or would overwrite the
    deliberately flatter 1.1.38 palette.
  }
  if not (ASkin in [sbsOfficeBlack, sbsMetroDark, sbsModernLight]) then
    FAppearance.Reset(LazStyleFromBuiltInSkin(ASkin));
end;

function TLazRibbonSkinDefinition.IconFileNameForSize(ASize: Integer): String;
begin
  if (ASize <= 16) and (FIcon16FileName <> '') then
    Exit(FIcon16FileName);
  if (ASize <= 24) and (FIcon24FileName <> '') then
    Exit(FIcon24FileName);
  if FIcon32FileName <> '' then
    Exit(FIcon32FileName);
  if FIcon24FileName <> '' then
    Exit(FIcon24FileName);
  if FIcon16FileName <> '' then
    Exit(FIcon16FileName);
  Result := FPreviewImageFileName;
end;

function TLazRibbonSkinDefinition.IconDataForSize(ASize: Integer): String;
begin
  if (ASize <= 16) and (FIcon16Data <> '') then
    Exit(FIcon16Data);
  if (ASize <= 24) and (FIcon24Data <> '') then
    Exit(FIcon24Data);
  if FIcon32Data <> '' then
    Exit(FIcon32Data);
  if FIcon24Data <> '' then
    Exit(FIcon24Data);
  Result := FIcon16Data;
end;

procedure TLazRibbonSkinDefinition.UpdateEmbeddedIconDataFromFiles;
var
  FN, Data: String;

  procedure UpdateOneIcon(const AFileName: String; var AData: String);
  begin
    FN := ResolveAssetFileName(AFileName);
    Data := LazBase64FromFile(FN);
    if Data <> '' then
      AData := Data;
  end;

begin
  UpdateOneIcon(FIcon16FileName, FIcon16Data);
  UpdateOneIcon(FIcon24FileName, FIcon24Data);
  UpdateOneIcon(FIcon32FileName, FIcon32Data);
end;

function TLazRibbonSkinDefinition.ResolveAssetFileName(const AFileName: String): String;
begin
  Result := Trim(AFileName);
  if Result = '' then Exit;

  { Avoid depending on FilenameIsAbsolute across FPC/Lazarus versions. }
  if (Length(Result) > 0) and (Result[1] in ['/', '\']) then Exit;
  if (Length(Result) > 1) and (Result[2] = ':') then Exit;

  if (FFileName <> '') then
    Result := ExpandFileName(IncludeTrailingPathDelimiter(ExtractFilePath(FFileName)) + Result)
  else
    Result := ExpandFileName(Result);
end;

procedure TLazRibbonSkinDefinition.SetAppearance(AValue: TLazRibbonToolbarAppearance);
begin
  if AValue <> nil then
    FAppearance.Assign(AValue);
end;

procedure TLazRibbonSkinDefinition.LoadFromFile(const AFileName: String);
var
  L: TStringList;
  Parser: TLazRibbonXMLParser;
  Root, Info, Node: TLazRibbonXMLNode;
  P: TLazRibbonSkinPalette;
  BuiltIn: TLazRibbonBuiltInSkin;
begin
  FFileName := AFileName;
  if LazFileLooksLikeXML(AFileName) then
  begin
    Parser := TLazRibbonXMLParser.Create;
    try
      LoadSkinXMLWithCompatibility(Parser, AFileName);
      Root := Parser['LazSkin', False];
      if Root = nil then
        Root := Parser['LazRibbonSkin', False];
      if Root = nil then
        Exit;

      Info := Root['Info', False];
      FName := XMLText(Info, 'Name', XMLText(Root, 'Name', ChangeFileExt(ExtractFileName(AFileName), '')));
      FDisplayName := XMLText(Info, 'DisplayName', XMLText(Root, 'DisplayName', FName));
      FGroupName := XMLText(Info, 'GroupName', XMLText(Info, 'Group', FGroupName));
      FAuthor := XMLText(Info, 'Author', FAuthor);
      FDescription := XMLText(Info, 'Description', FDescription);
      FNotes := XMLText(Info, 'Notes', FNotes);
      FFormatVersion := XMLText(Info, 'FormatVersion', FFormatVersion);
      FIcon16FileName := XMLText(Info, 'Icon16FileName', XMLText(Info, 'Icon16', FIcon16FileName));
      FIcon24FileName := XMLText(Info, 'Icon24FileName', XMLText(Info, 'Icon24', FIcon24FileName));
      FIcon32FileName := XMLText(Info, 'Icon32FileName', XMLText(Info, 'Icon32', FIcon32FileName));
      FIcon16Data := XMLText(Info, 'Icon16Data', FIcon16Data);
      FIcon24Data := XMLText(Info, 'Icon24Data', FIcon24Data);
      FIcon32Data := XMLText(Info, 'Icon32Data', FIcon32Data);
      FPreviewImageFileName := XMLText(Info, 'PreviewImageFileName', XMLText(Info, 'PreviewImage', FPreviewImageFileName));
      FSource := sssExternal;
      if LazBuiltInSkinFromString(FName, BuiltIn) then
        FBuiltInSkin := BuiltIn;

      Node := Root['Palette', False];
      if Node <> nil then
      begin
        P := FPalette;
        P.BackColor := XMLColor(Node, 'BackColor', P.BackColor);
        P.TextColor := XMLColor(Node, 'TextColor', P.TextColor);
        P.MutedTextColor := XMLColor(Node, 'MutedTextColor', P.MutedTextColor);
        P.BackstageNavColor := XMLColor(Node, 'BackstageNavColor', P.BackstageNavColor);
        P.BackstageNavTextColor := XMLColor(Node, 'BackstageNavTextColor', P.BackstageNavTextColor);
        P.BackstageNavMutedTextColor := XMLColor(Node, 'BackstageNavMutedTextColor', P.BackstageNavMutedTextColor);
        P.BackstageNavHoverColor := XMLColor(Node, 'BackstageNavHoverColor', P.BackstageNavHoverColor);
        P.BackstageNavHoverTextColor := XMLColor(Node, 'BackstageNavHoverTextColor', P.BackstageNavHoverTextColor);
        P.BackstageNavSelectedColor := XMLColor(Node, 'BackstageNavSelectedColor', P.BackstageNavSelectedColor);
        P.BackstageNavSelectedTextColor := XMLColor(Node, 'BackstageNavSelectedTextColor', P.BackstageNavSelectedTextColor);
        P.BackstageNavSelectedFrameColor := XMLColor(Node, 'BackstageNavSelectedFrameColor', P.BackstageNavSelectedFrameColor);
        P.FrameColor := XMLColor(Node, 'FrameColor', P.FrameColor);
        P.NavigationColor := XMLColor(Node, 'NavigationColor', P.NavigationColor);
        P.ActiveColor := XMLColor(Node, 'ActiveColor', P.ActiveColor);
        P.HotColor := XMLColor(Node, 'HotColor', P.HotColor);
        P.RecentOddColor := XMLColor(Node, 'RecentOddColor', P.RecentOddColor);
        P.RecentHoverColor := XMLColor(Node, 'RecentHoverColor', P.RecentHoverColor);
        P.RecentSelectedColor := XMLColor(Node, 'RecentSelectedColor', P.RecentSelectedColor);
        P.RecentSelectedFrameColor := XMLColor(Node, 'RecentSelectedFrameColor', P.RecentSelectedFrameColor);
        P.RecentTitleColor := XMLColor(Node, 'RecentTitleColor', P.RecentTitleColor);
        P.RibbonTopColor := XMLColor(Node, 'RibbonTopColor', P.RibbonTopColor);
        P.RibbonBottomColor := XMLColor(Node, 'RibbonBottomColor', P.RibbonBottomColor);
        P.RibbonTabActiveColor := XMLColor(Node, 'RibbonTabActiveColor', P.RibbonTabActiveColor);
        P.RibbonTabHotColor := XMLColor(Node, 'RibbonTabHotColor', P.RibbonTabHotColor);
        P.RibbonGroupColor := XMLColor(Node, 'RibbonGroupColor', P.RibbonGroupColor);
        P.RibbonGroupFrameColor := XMLColor(Node, 'RibbonGroupFrameColor', P.RibbonGroupFrameColor);
        FPalette := P;
      end;

      Node := Root['Appearance', False];
      if Node <> nil then
        FAppearance.LoadFromXML(Node)
      else
        ApplyPaletteToAppearance;
    finally
      Parser.Free;
    end;
    if FName = '' then
      FName := ChangeFileExt(ExtractFileName(AFileName), '');
    if FDisplayName = '' then
      FDisplayName := FName;
    if FGroupName = '' then
      FGroupName := 'Standard Skins';
    if FNotes = '' then
      FNotes := FDescription;
    Exit;
  end;

  { Legacy INI-like .lazskin format. }
  L := TStringList.Create;
  try
    L.LoadFromFile(AFileName);
    FName := LazReadSkinString(L, 'Name', ChangeFileExt(ExtractFileName(AFileName), ''));
    FDisplayName := LazReadSkinString(L, 'DisplayName', FName);
    FGroupName := LazReadSkinString(L, 'GroupName', LazReadSkinString(L, 'Group', 'Standard Skins'));
    FAuthor := LazReadSkinString(L, 'Author', FAuthor);
    FDescription := LazReadSkinString(L, 'Description', FDescription);
    FNotes := LazReadSkinString(L, 'Notes', FDescription);
    FIcon16FileName := LazReadSkinString(L, 'Icon16FileName', LazReadSkinString(L, 'Icon16', FIcon16FileName));
    FIcon24FileName := LazReadSkinString(L, 'Icon24FileName', LazReadSkinString(L, 'Icon24', FIcon24FileName));
    FIcon32FileName := LazReadSkinString(L, 'Icon32FileName', LazReadSkinString(L, 'Icon32', FIcon32FileName));
    FIcon16Data := LazReadSkinString(L, 'Icon16Data', FIcon16Data);
    FIcon24Data := LazReadSkinString(L, 'Icon24Data', FIcon24Data);
    FIcon32Data := LazReadSkinString(L, 'Icon32Data', FIcon32Data);
    FPreviewImageFileName := LazReadSkinString(L, 'PreviewImageFileName', LazReadSkinString(L, 'PreviewImage', FPreviewImageFileName));
    P := FPalette;
    P.BackColor := LazReadSkinColor(L, 'BackColor', LazReadSkinColor(L, 'General.BackColor', P.BackColor));
    P.NavigationColor := LazReadSkinColor(L, 'NavigationColor', LazReadSkinColor(L, 'Backstage.NavigationColor', P.NavigationColor));
    P.ActiveColor := LazReadSkinColor(L, 'ActiveColor', LazReadSkinColor(L, 'Backstage.ActiveColor', P.ActiveColor));
    P.HotColor := LazReadSkinColor(L, 'HotColor', LazReadSkinColor(L, 'Backstage.HotColor', P.HotColor));
    P.FrameColor := LazReadSkinColor(L, 'FrameColor', LazReadSkinColor(L, 'General.BorderColor', P.FrameColor));
    P.TextColor := LazReadSkinColor(L, 'TextColor', LazReadSkinColor(L, 'General.TextColor', P.TextColor));
    P.MutedTextColor := LazReadSkinColor(L, 'MutedTextColor', LazReadSkinColor(L, 'General.MutedTextColor', P.MutedTextColor));
    P.BackstageNavColor := LazReadSkinColor(L, 'BackstageNavColor', LazReadSkinColor(L, 'Backstage.NavigationColor', P.BackstageNavColor));
    P.BackstageNavTextColor := LazReadSkinColor(L, 'BackstageNavTextColor', LazReadSkinColor(L, 'Backstage.TextColor', P.BackstageNavTextColor));
    P.BackstageNavMutedTextColor := LazReadSkinColor(L, 'BackstageNavMutedTextColor', LazReadSkinColor(L, 'Backstage.MutedTextColor', P.BackstageNavMutedTextColor));
    P.BackstageNavHoverColor := LazReadSkinColor(L, 'BackstageNavHoverColor', LazReadSkinColor(L, 'Backstage.HoverColor', P.BackstageNavHoverColor));
    P.BackstageNavHoverTextColor := LazReadSkinColor(L, 'BackstageNavHoverTextColor', LazReadSkinColor(L, 'Backstage.HoverTextColor', P.BackstageNavHoverTextColor));
    P.BackstageNavSelectedColor := LazReadSkinColor(L, 'BackstageNavSelectedColor', LazReadSkinColor(L, 'Backstage.SelectedColor', P.BackstageNavSelectedColor));
    P.BackstageNavSelectedTextColor := LazReadSkinColor(L, 'BackstageNavSelectedTextColor', LazReadSkinColor(L, 'Backstage.SelectedTextColor', P.BackstageNavSelectedTextColor));
    P.BackstageNavSelectedFrameColor := LazReadSkinColor(L, 'BackstageNavSelectedFrameColor', LazReadSkinColor(L, 'Backstage.SelectedFrameColor', P.BackstageNavSelectedFrameColor));
    P.RecentOddColor := LazReadSkinColor(L, 'RecentOddColor', LazReadSkinColor(L, 'RecentList.OddColor', P.RecentOddColor));
    P.RecentHoverColor := LazReadSkinColor(L, 'RecentHoverColor', LazReadSkinColor(L, 'RecentList.HoverColor', P.RecentHoverColor));
    P.RecentSelectedColor := LazReadSkinColor(L, 'RecentSelectedColor', LazReadSkinColor(L, 'RecentList.SelectedColor', P.RecentSelectedColor));
    P.RecentSelectedFrameColor := LazReadSkinColor(L, 'RecentSelectedFrameColor', LazReadSkinColor(L, 'RecentList.SelectedFrameColor', P.RecentSelectedFrameColor));
    P.RecentTitleColor := LazReadSkinColor(L, 'RecentTitleColor', LazReadSkinColor(L, 'RecentList.TitleColor', P.RecentTitleColor));
    P.RibbonTopColor := LazReadSkinColor(L, 'Ribbon.TopColor', P.RibbonTopColor);
    P.RibbonBottomColor := LazReadSkinColor(L, 'Ribbon.BottomColor', P.RibbonBottomColor);
    P.RibbonTabActiveColor := LazReadSkinColor(L, 'Ribbon.TabActiveColor', P.RibbonTabActiveColor);
    P.RibbonTabHotColor := LazReadSkinColor(L, 'Ribbon.TabHotColor', P.RibbonTabHotColor);
    P.RibbonGroupColor := LazReadSkinColor(L, 'Ribbon.GroupColor', P.RibbonGroupColor);
    P.RibbonGroupFrameColor := LazReadSkinColor(L, 'Ribbon.GroupFrameColor', P.RibbonGroupFrameColor);
    FPalette := P;
    ApplyPaletteToAppearance;
    if FName = '' then
      FName := ChangeFileExt(ExtractFileName(AFileName), '');
    if FDisplayName = '' then
      FDisplayName := FName;
    if FGroupName = '' then
      FGroupName := 'Standard Skins';
    if FNotes = '' then
      FNotes := FDescription;
    FSource := sssExternal;
  finally
    L.Free;
  end;
end;

procedure TLazRibbonSkinDefinition.SaveToFile(const AFileName: String);
var
  Parser: TLazRibbonXMLParser;
  Root, Info, Node: TLazRibbonXMLNode;

  procedure WriteLegacyIconFileNameIfNeeded(const ANodeName, AFileName, AData: String);
  begin
    if (Trim(AFileName) <> '') and (Trim(AData) = '') then
      Info[ANodeName, True].Text := AFileName;
  end;

begin
  FFormatVersion := '6';
  UpdateEmbeddedIconDataFromFiles;

  Parser := TLazRibbonXMLParser.Create;
  try
    Root := TLazRibbonXMLNode.Create('LazSkin', xntNormal);
    Parser.Add(Root);
    Root.Parameters['Version', True].Value := '6';

    Info := Root['Info', True];
    Info['Name', True].Text := FName;
    Info['DisplayName', True].Text := FDisplayName;
    Info['GroupName', True].Text := FGroupName;
    Info['Author', True].Text := FAuthor;
    Info['Description', True].Text := FDescription;
    Info['Notes', True].Text := FNotes;
    Info['FormatVersion', True].Text := FFormatVersion;
    Info['Icon16Data', True].Text := FIcon16Data;
    Info['Icon24Data', True].Text := FIcon24Data;
    Info['Icon32Data', True].Text := FIcon32Data;
    WriteLegacyIconFileNameIfNeeded('Icon16FileName', FIcon16FileName, FIcon16Data);
    WriteLegacyIconFileNameIfNeeded('Icon24FileName', FIcon24FileName, FIcon24Data);
    WriteLegacyIconFileNameIfNeeded('Icon32FileName', FIcon32FileName, FIcon32Data);
    Info['PreviewImageFileName', True].Text := FPreviewImageFileName;

    Node := Root['Palette', True];
    Node['BackColor', True].TextAsColor := FPalette.BackColor;
    Node['TextColor', True].TextAsColor := FPalette.TextColor;
    Node['MutedTextColor', True].TextAsColor := FPalette.MutedTextColor;
    Node['BackstageNavColor', True].TextAsColor := FPalette.BackstageNavColor;
    Node['BackstageNavTextColor', True].TextAsColor := FPalette.BackstageNavTextColor;
    Node['BackstageNavMutedTextColor', True].TextAsColor := FPalette.BackstageNavMutedTextColor;
    Node['BackstageNavHoverColor', True].TextAsColor := FPalette.BackstageNavHoverColor;
    Node['BackstageNavHoverTextColor', True].TextAsColor := FPalette.BackstageNavHoverTextColor;
    Node['BackstageNavSelectedColor', True].TextAsColor := FPalette.BackstageNavSelectedColor;
    Node['BackstageNavSelectedTextColor', True].TextAsColor := FPalette.BackstageNavSelectedTextColor;
    Node['BackstageNavSelectedFrameColor', True].TextAsColor := FPalette.BackstageNavSelectedFrameColor;
    Node['FrameColor', True].TextAsColor := FPalette.FrameColor;
    Node['NavigationColor', True].TextAsColor := FPalette.NavigationColor;
    Node['ActiveColor', True].TextAsColor := FPalette.ActiveColor;
    Node['HotColor', True].TextAsColor := FPalette.HotColor;
    Node['RecentOddColor', True].TextAsColor := FPalette.RecentOddColor;
    Node['RecentHoverColor', True].TextAsColor := FPalette.RecentHoverColor;
    Node['RecentSelectedColor', True].TextAsColor := FPalette.RecentSelectedColor;
    Node['RecentSelectedFrameColor', True].TextAsColor := FPalette.RecentSelectedFrameColor;
    Node['RecentTitleColor', True].TextAsColor := FPalette.RecentTitleColor;
    Node['RibbonTopColor', True].TextAsColor := FPalette.RibbonTopColor;
    Node['RibbonBottomColor', True].TextAsColor := FPalette.RibbonBottomColor;
    Node['RibbonTabActiveColor', True].TextAsColor := FPalette.RibbonTabActiveColor;
    Node['RibbonTabHotColor', True].TextAsColor := FPalette.RibbonTabHotColor;
    Node['RibbonGroupColor', True].TextAsColor := FPalette.RibbonGroupColor;
    Node['RibbonGroupFrameColor', True].TextAsColor := FPalette.RibbonGroupFrameColor;

    FAppearance.SaveToXML(Root['Appearance', True]);
    Parser.SaveToFile(AFileName, True);
    FFileName := AFileName;
    FSource := sssExternal;
  finally
    Parser.Free;
  end;
end;

end.
