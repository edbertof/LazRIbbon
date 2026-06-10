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

unit LazRibbon_SkinManagerEditor;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls, Forms, StdCtrls, ExtCtrls, ComCtrls,
  Dialogs, ComponentEditors, TypInfo,
  LazRibbon_GUITools, LazRibbon_Dispatch, LazRibbon_Appearance, LazRibbon_SkinManager;

type
  TLazRibbonSkinManagerEditor = class(TComponentEditor)
  private
    function SkinManager: TLazRibbonSkinManager;
    procedure DoEditSkin;
    procedure DoLoadSkin;
    procedure DoSaveSkin;
    procedure DoResetSkin;
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

implementation

type
  TLazRibbonSkinColorSlot = (
    scGeneralBack, scGeneralText, scGeneralMutedText, scGeneralBorder,
    scBackstageNavigation, scBackstageActive, scBackstageHot, scBackstageFrame,
    scRecentOdd, scRecentHover, scRecentSelected, scRecentSelectedFrame, scRecentTitle,
    scRibbonTop, scRibbonBottom, scRibbonTabActive, scRibbonTabHot, scRibbonGroup, scRibbonGroupFrame
  );

  TLazRibbonAppearanceRowKind = (arkColor, arkGradient, arkInteger, arkBoolean);

  TLazRibbonAppearancePropRow = class
  public
    Target: TPersistent;
    PropName: String;
    Kind: TLazRibbonAppearanceRowKind;
    Swatch: TPanel;
    Combo: TComboBox;
    Edit: TEdit;
    Check: TCheckBox;
  end;

  TLazRibbonSilentAppearanceDispatch = class(TLazRibbonBaseAppearanceDispatch)
  public
    procedure NotifyAppearanceChanged; override;
  end;

  TLazRibbonSkinEditForm = class(TForm)
  private
    FManager: TLazRibbonSkinManager;
    FPalette: TLazRibbonSkinPalette;
    FAppearanceDispatch: TLazRibbonSilentAppearanceDispatch;
    FAppearance: TLazRibbonToolbarAppearance;
    FColorDialog: TColorDialog;
    FWasApplied: Boolean;
    FSwatches: array[TLazRibbonSkinColorSlot] of TPanel;
    FRows: TList;
    procedure AddPaletteColorRow(APage: TWinControl; ASlot: TLazRibbonSkinColorSlot; const ACaption: String; var ATop: Integer);
    procedure AddAppearanceColorRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
    procedure AddAppearanceGradientRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
    procedure AddAppearanceIntegerRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
    procedure AddAppearanceBooleanRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
    function AddAppearanceRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String;
      AKind: TLazRibbonAppearanceRowKind; var ATop: Integer): TLazRibbonAppearancePropRow;
    function NewTab(APages: TPageControl; const ACaption: String): TTabSheet;
    function NewScrollTab(APages: TPageControl; const ACaption: String): TScrollBox;
    procedure ChoosePaletteColor(Sender: TObject);
    procedure ChooseAppearanceColor(Sender: TObject);
    procedure GradientChanged(Sender: TObject);
    procedure IntegerChanged(Sender: TObject);
    procedure BooleanChanged(Sender: TObject);
    procedure DoApply(Sender: TObject);
    procedure DoCancel(Sender: TObject);
    procedure DoLoad(Sender: TObject);
    procedure DoOK(Sender: TObject);
    procedure DoReset(Sender: TObject);
    procedure DoSave(Sender: TObject);
    procedure ApplyToManager;
    function GetSlotColor(ASlot: TLazRibbonSkinColorSlot): TColor;
    procedure SetSlotColor(ASlot: TLazRibbonSkinColorSlot; AColor: TColor);
    procedure UpdateAllSwatches;
    procedure UpdatePaletteSwatch(ASlot: TLazRibbonSkinColorSlot);
    procedure UpdateAllAppearanceRows;
    procedure UpdateAppearanceRow(ARow: TLazRibbonAppearancePropRow);
    procedure BuildUI;
    procedure BuildPalettePages(APages: TPageControl);
    procedure BuildAppearancePages(APages: TPageControl);
    procedure BuildTabPage(APage: TWinControl);
    procedure BuildMenuButtonPage(APage: TWinControl);
    procedure BuildPanePage(APage: TWinControl);
    procedure BuildElementPage(APage: TWinControl);
    procedure BuildPopupPage(APage: TWinControl);
  public
    constructor CreateEditor(AOwner: TComponent; AManager: TLazRibbonSkinManager); reintroduce;
    destructor Destroy; override;
    property WasApplied: Boolean read FWasApplied;
  end;

procedure TLazRibbonSilentAppearanceDispatch.NotifyAppearanceChanged;
begin
  { The editor works on a temporary appearance object. Nothing is pushed to the
    manager until Apply/OK. }
end;

constructor TLazRibbonSkinEditForm.CreateEditor(AOwner: TComponent; AManager: TLazRibbonSkinManager);
begin
  inherited CreateNew(AOwner, 1);
  FManager := AManager;
  if FManager <> nil then
    FPalette := FManager.Palette;
  FAppearanceDispatch := TLazRibbonSilentAppearanceDispatch.Create;
  FAppearance := TLazRibbonToolbarAppearance.Create(FAppearanceDispatch);
  if FManager <> nil then
    FAppearance.Assign(FManager.Appearance);
  FRows := TList.Create;
  FWasApplied := False;
  FColorDialog := TColorDialog.Create(Self);
  Caption := 'Editar Skin';
  Position := poScreenCenter;
  BorderStyle := bsSizeable;
  Width := 700;
  Height := 520;
  Constraints.MinWidth := 620;
  Constraints.MinHeight := 430;
  BuildUI;
end;

destructor TLazRibbonSkinEditForm.Destroy;
var
  I: Integer;
begin
  for I := FRows.Count - 1 downto 0 do
    TObject(FRows[I]).Free;
  FRows.Free;
  FAppearance.Free;
  FAppearanceDispatch.Free;
  inherited Destroy;
end;

function TLazRibbonSkinEditForm.NewTab(APages: TPageControl; const ACaption: String): TTabSheet;
begin
  Result := TTabSheet.Create(Self);
  Result.PageControl := APages;
  Result.Caption := ACaption;
end;

function TLazRibbonSkinEditForm.NewScrollTab(APages: TPageControl; const ACaption: String): TScrollBox;
var
  Tab: TTabSheet;
begin
  Tab := NewTab(APages, ACaption);
  Result := TScrollBox.Create(Self);
  Result.Parent := Tab;
  Result.Align := alClient;
  Result.BorderStyle := bsNone;
  Result.VertScrollBar.Visible := True;
end;

procedure TLazRibbonSkinEditForm.BuildUI;
var
  Pages: TPageControl;
  BtnPanel: TPanel;
  Btn: TButton;
begin
  Pages := TPageControl.Create(Self);
  Pages.Parent := Self;
  Pages.Align := alClient;

  BuildPalettePages(Pages);
  BuildAppearancePages(Pages);

  BtnPanel := TPanel.Create(Self);
  BtnPanel.Parent := Self;
  BtnPanel.Align := alBottom;
  BtnPanel.Height := 72;
  BtnPanel.BevelOuter := bvNone;

  Btn := TButton.Create(Self);
  Btn.Parent := BtnPanel;
  Btn.Caption := 'Carregar...';
  Btn.SetBounds(8, 8, 86, 26);
  Btn.OnClick := DoLoad;

  Btn := TButton.Create(Self);
  Btn.Parent := BtnPanel;
  Btn.Caption := 'Salvar...';
  Btn.SetBounds(100, 8, 86, 26);
  Btn.OnClick := DoSave;

  Btn := TButton.Create(Self);
  Btn.Parent := BtnPanel;
  Btn.Caption := 'Resetar';
  Btn.SetBounds(192, 8, 86, 26);
  Btn.OnClick := DoReset;

  Btn := TButton.Create(Self);
  Btn.Parent := BtnPanel;
  Btn.Caption := 'Aplicar';
  Btn.SetBounds(398, 40, 76, 26);
  Btn.OnClick := DoApply;

  Btn := TButton.Create(Self);
  Btn.Parent := BtnPanel;
  Btn.Caption := 'OK';
  Btn.SetBounds(480, 40, 72, 26);
  Btn.Default := True;
  Btn.OnClick := DoOK;

  Btn := TButton.Create(Self);
  Btn.Parent := BtnPanel;
  Btn.Caption := 'Cancelar';
  Btn.SetBounds(558, 40, 86, 26);
  Btn.Cancel := True;
  Btn.OnClick := DoCancel;
end;

procedure TLazRibbonSkinEditForm.BuildPalettePages(APages: TPageControl);
var
  Tab: TTabSheet;
  TopY: Integer;
begin
  Tab := NewTab(APages, 'Paleta');
  TopY := 12;
  AddPaletteColorRow(Tab, scGeneralBack, 'General.BackColor', TopY);
  AddPaletteColorRow(Tab, scGeneralText, 'General.TextColor', TopY);
  AddPaletteColorRow(Tab, scGeneralMutedText, 'General.MutedTextColor', TopY);
  AddPaletteColorRow(Tab, scGeneralBorder, 'General.BorderColor', TopY);
  AddPaletteColorRow(Tab, scRibbonTop, 'Ribbon.TopColor', TopY);
  AddPaletteColorRow(Tab, scRibbonBottom, 'Ribbon.BottomColor', TopY);
  AddPaletteColorRow(Tab, scRibbonTabActive, 'Ribbon.TabActiveColor', TopY);
  AddPaletteColorRow(Tab, scRibbonTabHot, 'Ribbon.TabHotColor', TopY);
  AddPaletteColorRow(Tab, scRibbonGroup, 'Ribbon.GroupColor', TopY);
  AddPaletteColorRow(Tab, scRibbonGroupFrame, 'Ribbon.GroupFrameColor', TopY);

  Tab := NewTab(APages, 'Backstage');
  TopY := 12;
  AddPaletteColorRow(Tab, scBackstageNavigation, 'NavigationColor', TopY);
  AddPaletteColorRow(Tab, scBackstageActive, 'ActiveColor', TopY);
  AddPaletteColorRow(Tab, scBackstageHot, 'HotColor', TopY);
  AddPaletteColorRow(Tab, scBackstageFrame, 'FrameColor', TopY);

  Tab := NewTab(APages, 'RecentList');
  TopY := 12;
  AddPaletteColorRow(Tab, scRecentOdd, 'OddColor', TopY);
  AddPaletteColorRow(Tab, scRecentHover, 'HoverColor', TopY);
  AddPaletteColorRow(Tab, scRecentSelected, 'SelectedColor', TopY);
  AddPaletteColorRow(Tab, scRecentSelectedFrame, 'SelectedFrameColor', TopY);
  AddPaletteColorRow(Tab, scRecentTitle, 'TitleColor', TopY);
end;

procedure TLazRibbonSkinEditForm.BuildAppearancePages(APages: TPageControl);
begin
  BuildTabPage(NewScrollTab(APages, 'Tab'));
  BuildMenuButtonPage(NewScrollTab(APages, 'MenuButton'));
  BuildPanePage(NewScrollTab(APages, 'Pane'));
  BuildElementPage(NewScrollTab(APages, 'Element'));
  BuildPopupPage(NewScrollTab(APages, 'Popup'));
end;

procedure TLazRibbonSkinEditForm.BuildTabPage(APage: TWinControl);
var
  TopY: Integer;
begin
  TopY := 12;
  AddAppearanceColorRow(APage, FAppearance.Tab, 'BorderColor', 'BorderColor', TopY);
  AddAppearanceIntegerRow(APage, FAppearance.Tab, 'CaptionHeight', 'CaptionHeight', TopY);
  AddAppearanceIntegerRow(APage, FAppearance.Tab, 'CornerRadius', 'CornerRadius', TopY);
  AddAppearanceColorRow(APage, FAppearance.Tab, 'GradientFromColor', 'GradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Tab, 'GradientToColor', 'GradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Tab, 'GradientType', 'GradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.Tab, 'InactiveTabHeaderFontColor', 'InactiveTabHeaderFontColor', TopY);
end;

procedure TLazRibbonSkinEditForm.BuildMenuButtonPage(APage: TWinControl);
var
  TopY: Integer;
begin
  TopY := 12;
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'IdleFrameColor', 'IdleFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'IdleGradientFromColor', 'IdleGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'IdleGradientToColor', 'IdleGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.MenuButton, 'IdleGradientType', 'IdleGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'IdleCaptionColor', 'IdleCaptionColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'HotTrackFrameColor', 'HotTrackFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'HotTrackGradientFromColor', 'HotTrackGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'HotTrackGradientToColor', 'HotTrackGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.MenuButton, 'HotTrackGradientType', 'HotTrackGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'HotTrackCaptionColor', 'HotTrackCaptionColor', TopY);
  AddAppearanceIntegerRow(APage, FAppearance.MenuButton, 'HotTrackBrightnessChange', 'HotTrackBrightnessChange', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'ActiveFrameColor', 'ActiveFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'ActiveGradientFromColor', 'ActiveGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'ActiveGradientToColor', 'ActiveGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.MenuButton, 'ActiveGradientType', 'ActiveGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.MenuButton, 'ActiveCaptionColor', 'ActiveCaptionColor', TopY);
end;

procedure TLazRibbonSkinEditForm.BuildPanePage(APage: TWinControl);
var
  TopY: Integer;
begin
  TopY := 12;
  AddAppearanceColorRow(APage, FAppearance.Pane, 'BorderDarkColor', 'BorderDarkColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Pane, 'BorderLightColor', 'BorderLightColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Pane, 'CaptionBgColor', 'CaptionBgColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Pane, 'GradientFromColor', 'GradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Pane, 'GradientToColor', 'GradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Pane, 'GradientType', 'GradientType', TopY);
  AddAppearanceIntegerRow(APage, FAppearance.Pane, 'HotTrackBrightnessChange', 'HotTrackBrightnessChange', TopY);
end;

procedure TLazRibbonSkinEditForm.BuildElementPage(APage: TWinControl);
var
  TopY: Integer;
begin
  TopY := 12;
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleFrameColor', 'IdleFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleGradientFromColor', 'IdleGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleGradientToColor', 'IdleGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Element, 'IdleGradientType', 'IdleGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleInnerLightColor', 'IdleInnerLightColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleInnerDarkColor', 'IdleInnerDarkColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleKnobColor', 'IdleKnobColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleTrackColor', 'IdleTrackColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'IdleCaptionColor', 'IdleCaptionColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'HotTrackFrameColor', 'HotTrackFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'HotTrackGradientFromColor', 'HotTrackGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'HotTrackGradientToColor', 'HotTrackGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Element, 'HotTrackGradientType', 'HotTrackGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'HotTrackInnerLightColor', 'HotTrackInnerLightColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'HotTrackInnerDarkColor', 'HotTrackInnerDarkColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'HotTrackTrackColor', 'HotTrackTrackColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'HotTrackCaptionColor', 'HotTrackCaptionColor', TopY);
  AddAppearanceIntegerRow(APage, FAppearance.Element, 'HotTrackBrightnessChange', 'HotTrackBrightnessChange', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveFrameColor', 'ActiveFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveGradientFromColor', 'ActiveGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveGradientToColor', 'ActiveGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Element, 'ActiveGradientType', 'ActiveGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveInnerLightColor', 'ActiveInnerLightColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveInnerDarkColor', 'ActiveInnerDarkColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveKnobColor', 'ActiveKnobColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveTrackColor', 'ActiveTrackColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Element, 'ActiveCaptionColor', 'ActiveCaptionColor', TopY);
  AddAppearanceBooleanRow(APage, FAppearance.Element, 'KnobAsGradient', 'KnobAsGradient', TopY);
end;

procedure TLazRibbonSkinEditForm.BuildPopupPage(APage: TWinControl);
var
  TopY: Integer;
begin
  TopY := 12;
  AddAppearanceColorRow(APage, FAppearance.Popup, 'CheckedFrameColor', 'CheckedFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'CheckedGradientFromColor', 'CheckedGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'CheckedGradientToColor', 'CheckedGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Popup, 'CheckedGradientType', 'CheckedGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'DisabledCaptionColor', 'DisabledCaptionColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'DividerLineColor', 'DividerLineColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'GutterFrameColor', 'GutterFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'GutterGradientFromColor', 'GutterGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'GutterGradientToColor', 'GutterGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Popup, 'GutterGradientType', 'GutterGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'HotTrackCaptionColor', 'HotTrackCaptionColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'HotTrackFrameColor', 'HotTrackFrameColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'HotTrackGradientFromColor', 'HotTrackGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'HotTrackGradientToColor', 'HotTrackGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Popup, 'HotTrackGradientType', 'HotTrackGradientType', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'IdleCaptionColor', 'IdleCaptionColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'IdleGradientFromColor', 'IdleGradientFromColor', TopY);
  AddAppearanceColorRow(APage, FAppearance.Popup, 'IdleGradientToColor', 'IdleGradientToColor', TopY);
  AddAppearanceGradientRow(APage, FAppearance.Popup, 'IdleGradientType', 'IdleGradientType', TopY);
end;

procedure TLazRibbonSkinEditForm.AddPaletteColorRow(APage: TWinControl; ASlot: TLazRibbonSkinColorSlot; const ACaption: String; var ATop: Integer);
var
  L: TLabel;
  P: TPanel;
  B: TButton;
begin
  L := TLabel.Create(Self);
  L.Parent := APage;
  L.Caption := ACaption;
  L.SetBounds(16, ATop + 4, 190, 22);

  P := TPanel.Create(Self);
  P.Parent := APage;
  P.BevelOuter := bvLowered;
  P.Color := GetSlotColor(ASlot);
  P.SetBounds(216, ATop, 86, 22);
  P.Tag := Ord(ASlot);
  P.OnClick := ChoosePaletteColor;
  FSwatches[ASlot] := P;

  B := TButton.Create(Self);
  B.Parent := APage;
  B.Caption := '...';
  B.SetBounds(312, ATop - 1, 34, 24);
  B.Tag := Ord(ASlot);
  B.OnClick := ChoosePaletteColor;

  Inc(ATop, 30);
end;

function TLazRibbonSkinEditForm.AddAppearanceRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String;
  AKind: TLazRibbonAppearanceRowKind; var ATop: Integer): TLazRibbonAppearancePropRow;
var
  L: TLabel;
  B: TButton;
begin
  Result := TLazRibbonAppearancePropRow.Create;
  Result.Target := ATarget;
  Result.PropName := APropName;
  Result.Kind := AKind;
  FRows.Add(Result);

  L := TLabel.Create(Self);
  L.Parent := APage;
  L.Caption := ACaption;
  L.SetBounds(16, ATop + 4, 220, 22);

  case AKind of
    arkColor:
      begin
        Result.Swatch := TPanel.Create(Self);
        Result.Swatch.Parent := APage;
        Result.Swatch.BevelOuter := bvLowered;
        Result.Swatch.SetBounds(246, ATop, 86, 22);
        Result.Swatch.Tag := PtrInt(Pointer(Result));
        Result.Swatch.OnClick := ChooseAppearanceColor;

        B := TButton.Create(Self);
        B.Parent := APage;
        B.Caption := '...';
        B.SetBounds(342, ATop - 1, 34, 24);
        B.Tag := PtrInt(Pointer(Result));
        B.OnClick := ChooseAppearanceColor;
      end;
    arkGradient:
      begin
        Result.Combo := TComboBox.Create(Self);
        Result.Combo.Parent := APage;
        Result.Combo.Style := csDropDownList;
        Result.Combo.Items.Add('bkSolid');
        Result.Combo.Items.Add('bkVerticalGradient');
        Result.Combo.Items.Add('bkHorizontalGradient');
        Result.Combo.Items.Add('bkConcave');
        Result.Combo.SetBounds(246, ATop - 1, 180, 24);
        Result.Combo.Tag := PtrInt(Pointer(Result));
        Result.Combo.OnChange := GradientChanged;
      end;
    arkInteger:
      begin
        Result.Edit := TEdit.Create(Self);
        Result.Edit.Parent := APage;
        Result.Edit.SetBounds(246, ATop - 1, 80, 24);
        Result.Edit.Tag := PtrInt(Pointer(Result));
        Result.Edit.OnEditingDone := IntegerChanged;
      end;
    arkBoolean:
      begin
        Result.Check := TCheckBox.Create(Self);
        Result.Check.Parent := APage;
        Result.Check.SetBounds(246, ATop - 1, 160, 24);
        Result.Check.Caption := '';
        Result.Check.Tag := PtrInt(Pointer(Result));
        Result.Check.OnChange := BooleanChanged;
      end;
  end;

  UpdateAppearanceRow(Result);
  Inc(ATop, 30);
end;

procedure TLazRibbonSkinEditForm.AddAppearanceColorRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
begin
  AddAppearanceRow(APage, ATarget, APropName, ACaption, arkColor, ATop);
end;

procedure TLazRibbonSkinEditForm.AddAppearanceGradientRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
begin
  AddAppearanceRow(APage, ATarget, APropName, ACaption, arkGradient, ATop);
end;

procedure TLazRibbonSkinEditForm.AddAppearanceIntegerRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
begin
  AddAppearanceRow(APage, ATarget, APropName, ACaption, arkInteger, ATop);
end;

procedure TLazRibbonSkinEditForm.AddAppearanceBooleanRow(APage: TWinControl; ATarget: TPersistent; const APropName, ACaption: String; var ATop: Integer);
begin
  AddAppearanceRow(APage, ATarget, APropName, ACaption, arkBoolean, ATop);
end;

procedure TLazRibbonSkinEditForm.ChoosePaletteColor(Sender: TObject);
var
  Slot: TLazRibbonSkinColorSlot;
begin
  Slot := TLazRibbonSkinColorSlot(TComponent(Sender).Tag);
  FColorDialog.Color := GetSlotColor(Slot);
  if FColorDialog.Execute then
  begin
    SetSlotColor(Slot, FColorDialog.Color);
    UpdatePaletteSwatch(Slot);
  end;
end;

procedure TLazRibbonSkinEditForm.ChooseAppearanceColor(Sender: TObject);
var
  Row: TLazRibbonAppearancePropRow;
begin
  Row := TLazRibbonAppearancePropRow(Pointer(TComponent(Sender).Tag));
  if Row = nil then Exit;
  FColorDialog.Color := TColor(GetOrdProp(Row.Target, Row.PropName));
  if FColorDialog.Execute then
  begin
    SetOrdProp(Row.Target, Row.PropName, FColorDialog.Color);
    UpdateAppearanceRow(Row);
  end;
end;

procedure TLazRibbonSkinEditForm.GradientChanged(Sender: TObject);
var
  Row: TLazRibbonAppearancePropRow;
begin
  Row := TLazRibbonAppearancePropRow(Pointer(TComponent(Sender).Tag));
  if (Row = nil) or (Row.Combo = nil) then Exit;
  if Row.Combo.ItemIndex >= 0 then
    SetOrdProp(Row.Target, Row.PropName, Row.Combo.ItemIndex);
end;

procedure TLazRibbonSkinEditForm.IntegerChanged(Sender: TObject);
var
  Row: TLazRibbonAppearancePropRow;
  V: Integer;
begin
  Row := TLazRibbonAppearancePropRow(Pointer(TComponent(Sender).Tag));
  if (Row = nil) or (Row.Edit = nil) then Exit;
  if TryStrToInt(Row.Edit.Text, V) then
    SetOrdProp(Row.Target, Row.PropName, V)
  else
    UpdateAppearanceRow(Row);
end;

procedure TLazRibbonSkinEditForm.BooleanChanged(Sender: TObject);
var
  Row: TLazRibbonAppearancePropRow;
begin
  Row := TLazRibbonAppearancePropRow(Pointer(TComponent(Sender).Tag));
  if (Row = nil) or (Row.Check = nil) then Exit;
  SetOrdProp(Row.Target, Row.PropName, Ord(Row.Check.Checked));
end;

procedure TLazRibbonSkinEditForm.ApplyToManager;
begin
  if FManager <> nil then
  begin
    FManager.AssignPalette(FPalette);
    FManager.Appearance.Assign(FAppearance);
    FWasApplied := True;
  end;
end;

procedure TLazRibbonSkinEditForm.DoApply(Sender: TObject);
begin
  ApplyToManager;
end;

procedure TLazRibbonSkinEditForm.DoCancel(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TLazRibbonSkinEditForm.DoLoad(Sender: TObject);
var
  D: TOpenDialog;
  Temp: TLazRibbonSkinManager;
begin
  D := TOpenDialog.Create(Self);
  try
    D.Filter := 'LazRibbon skin (*.skin;*.lazskin)|*.skin;*.lazskin|Todos os arquivos|*.*';
    if D.Execute then
    begin
      Temp := TLazRibbonSkinManager.Create(nil);
      try
        Temp.LoadFromFile(D.FileName);
        FPalette := Temp.Palette;
        FAppearance.Assign(Temp.Appearance);
        UpdateAllSwatches;
        UpdateAllAppearanceRows;
      finally
        Temp.Free;
      end;
    end;
  finally
    D.Free;
  end;
end;

procedure TLazRibbonSkinEditForm.DoOK(Sender: TObject);
begin
  ApplyToManager;
  ModalResult := mrOK;
end;

procedure TLazRibbonSkinEditForm.DoReset(Sender: TObject);
var
  Temp: TLazRibbonSkinManager;
begin
  if FManager = nil then Exit;
  Temp := TLazRibbonSkinManager.Create(nil);
  try
    Temp.ActiveSkin := FManager.ActiveSkin;
    Temp.ResetToBuiltInSkin;
    FPalette := Temp.Palette;
    FAppearance.Assign(Temp.Appearance);
    UpdateAllSwatches;
    UpdateAllAppearanceRows;
  finally
    Temp.Free;
  end;
end;

procedure TLazRibbonSkinEditForm.DoSave(Sender: TObject);
var
  D: TSaveDialog;
  Temp: TLazRibbonSkinManager;
begin
  D := TSaveDialog.Create(Self);
  try
    D.Filter := 'LazRibbon skin (*.skin)|*.skin|Skin legado (*.lazskin)|*.lazskin|Todos os arquivos|*.*';
    D.DefaultExt := 'skin';
    if D.Execute then
    begin
      Temp := TLazRibbonSkinManager.Create(nil);
      try
        Temp.AssignPalette(FPalette);
        Temp.Appearance.Assign(FAppearance);
        Temp.SaveToFile(D.FileName);
      finally
        Temp.Free;
      end;
    end;
  finally
    D.Free;
  end;
end;

function TLazRibbonSkinEditForm.GetSlotColor(ASlot: TLazRibbonSkinColorSlot): TColor;
begin
  case ASlot of
    scGeneralBack: Result := FPalette.BackColor;
    scGeneralText: Result := FPalette.TextColor;
    scGeneralMutedText: Result := FPalette.MutedTextColor;
    scGeneralBorder: Result := FPalette.FrameColor;
    scBackstageNavigation: Result := FPalette.NavigationColor;
    scBackstageActive: Result := FPalette.ActiveColor;
    scBackstageHot: Result := FPalette.HotColor;
    scBackstageFrame: Result := FPalette.FrameColor;
    scRecentOdd: Result := FPalette.RecentOddColor;
    scRecentHover: Result := FPalette.RecentHoverColor;
    scRecentSelected: Result := FPalette.RecentSelectedColor;
    scRecentSelectedFrame: Result := FPalette.RecentSelectedFrameColor;
    scRecentTitle: Result := FPalette.RecentTitleColor;
    scRibbonTop: Result := FPalette.RibbonTopColor;
    scRibbonBottom: Result := FPalette.RibbonBottomColor;
    scRibbonTabActive: Result := FPalette.RibbonTabActiveColor;
    scRibbonTabHot: Result := FPalette.RibbonTabHotColor;
    scRibbonGroup: Result := FPalette.RibbonGroupColor;
    scRibbonGroupFrame: Result := FPalette.RibbonGroupFrameColor;
  else
    Result := clBlack;
  end;
end;

procedure TLazRibbonSkinEditForm.SetSlotColor(ASlot: TLazRibbonSkinColorSlot; AColor: TColor);
begin
  case ASlot of
    scGeneralBack: FPalette.BackColor := AColor;
    scGeneralText: FPalette.TextColor := AColor;
    scGeneralMutedText: FPalette.MutedTextColor := AColor;
    scGeneralBorder: FPalette.FrameColor := AColor;
    scBackstageNavigation: FPalette.NavigationColor := AColor;
    scBackstageActive: FPalette.ActiveColor := AColor;
    scBackstageHot: FPalette.HotColor := AColor;
    scBackstageFrame: FPalette.FrameColor := AColor;
    scRecentOdd: FPalette.RecentOddColor := AColor;
    scRecentHover: FPalette.RecentHoverColor := AColor;
    scRecentSelected: FPalette.RecentSelectedColor := AColor;
    scRecentSelectedFrame: FPalette.RecentSelectedFrameColor := AColor;
    scRecentTitle: FPalette.RecentTitleColor := AColor;
    scRibbonTop: FPalette.RibbonTopColor := AColor;
    scRibbonBottom: FPalette.RibbonBottomColor := AColor;
    scRibbonTabActive: FPalette.RibbonTabActiveColor := AColor;
    scRibbonTabHot: FPalette.RibbonTabHotColor := AColor;
    scRibbonGroup: FPalette.RibbonGroupColor := AColor;
    scRibbonGroupFrame: FPalette.RibbonGroupFrameColor := AColor;
  end;
end;

procedure TLazRibbonSkinEditForm.UpdatePaletteSwatch(ASlot: TLazRibbonSkinColorSlot);
begin
  if FSwatches[ASlot] <> nil then
    FSwatches[ASlot].Color := GetSlotColor(ASlot);
end;

procedure TLazRibbonSkinEditForm.UpdateAllSwatches;
var
  Slot: TLazRibbonSkinColorSlot;
begin
  for Slot := Low(TLazRibbonSkinColorSlot) to High(TLazRibbonSkinColorSlot) do
    UpdatePaletteSwatch(Slot);
end;

procedure TLazRibbonSkinEditForm.UpdateAppearanceRow(ARow: TLazRibbonAppearancePropRow);
var
  V: Integer;
begin
  if (ARow = nil) or (ARow.Target = nil) then Exit;
  V := GetOrdProp(ARow.Target, ARow.PropName);
  case ARow.Kind of
    arkColor:
      if ARow.Swatch <> nil then
        ARow.Swatch.Color := TColor(V);
    arkGradient:
      if ARow.Combo <> nil then
        ARow.Combo.ItemIndex := V;
    arkInteger:
      if ARow.Edit <> nil then
        ARow.Edit.Text := IntToStr(V);
    arkBoolean:
      if ARow.Check <> nil then
        ARow.Check.Checked := V <> 0;
  end;
end;

procedure TLazRibbonSkinEditForm.UpdateAllAppearanceRows;
var
  I: Integer;
begin
  for I := 0 to FRows.Count - 1 do
    UpdateAppearanceRow(TLazRibbonAppearancePropRow(FRows[I]));
end;

function TLazRibbonSkinManagerEditor.SkinManager: TLazRibbonSkinManager;
begin
  if Component is TLazRibbonSkinManager then
    Result := TLazRibbonSkinManager(Component)
  else
    Result := nil;
end;

procedure TLazRibbonSkinManagerEditor.DoEditSkin;
var
  F: TLazRibbonSkinEditForm;
begin
  if SkinManager = nil then Exit;
  F := TLazRibbonSkinEditForm.CreateEditor(nil, SkinManager);
  try
    if F.ShowModal = mrOK then
      Designer.Modified
    else if F.WasApplied then
      Designer.Modified;
  finally
    F.Free;
  end;
end;

procedure TLazRibbonSkinManagerEditor.DoLoadSkin;
var
  D: TOpenDialog;
begin
  if SkinManager = nil then Exit;
  D := TOpenDialog.Create(nil);
  try
    D.Filter := 'LazRibbon skin (*.skin;*.lazskin)|*.skin;*.lazskin|Todos os arquivos|*.*';
    if D.Execute then
    begin
      SkinManager.LoadFromFile(D.FileName);
      Designer.Modified;
    end;
  finally
    D.Free;
  end;
end;

procedure TLazRibbonSkinManagerEditor.DoSaveSkin;
var
  D: TSaveDialog;
begin
  if SkinManager = nil then Exit;
  D := TSaveDialog.Create(nil);
  try
    D.Filter := 'LazRibbon skin (*.skin)|*.skin|Skin legado (*.lazskin)|*.lazskin|Todos os arquivos|*.*';
    D.DefaultExt := 'skin';
    if D.Execute then
      SkinManager.SaveToFile(D.FileName);
  finally
    D.Free;
  end;
end;

procedure TLazRibbonSkinManagerEditor.DoResetSkin;
begin
  if SkinManager = nil then Exit;
  SkinManager.ResetToBuiltInSkin;
  Designer.Modified;
end;

procedure TLazRibbonSkinManagerEditor.Edit;
begin
  DoEditSkin;
end;

procedure TLazRibbonSkinManagerEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: DoEditSkin;
    1: DoLoadSkin;
    2: DoSaveSkin;
    3: DoResetSkin;
  end;
end;

function TLazRibbonSkinManagerEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Editar skin...';
    1: Result := 'Carregar skin...';
    2: Result := 'Salvar skin...';
    3: Result := 'Resetar skin';
  else
    Result := '';
  end;
end;

function TLazRibbonSkinManagerEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;

end.
