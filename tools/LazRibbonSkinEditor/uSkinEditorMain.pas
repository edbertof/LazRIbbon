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

unit uSkinEditorMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TypInfo, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ComCtrls, Types,
  LazRibbon_Core, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Buttons, LazRibbon_Checkboxes,
  LazRibbon_Appearance, LazRibbon_SkinDefinition, LazRibbon_SkinManager,
  LazRibbon_AppearanceEditor, LazRibbon_Backstage, LazRibbon_RibbonExtItems;

type
  TLazRibbonEditorPaletteField = (
    pfBackColor,
    pfTextColor,
    pfMutedTextColor,
    pfFrameColor,
    pfNavigationColor,
    pfActiveColor,
    pfHotColor,
    pfRibbonTopColor,
    pfRibbonBottomColor,
    pfRibbonTabActiveColor,
    pfRibbonTabHotColor,
    pfRibbonGroupColor,
    pfRibbonGroupFrameColor,
    pfBackstageNavColor,
    pfBackstageNavTextColor,
    pfBackstageNavMutedTextColor,
    pfBackstageNavHoverColor,
    pfBackstageNavHoverTextColor,
    pfBackstageNavSelectedColor,
    pfBackstageNavSelectedTextColor,
    pfBackstageNavSelectedFrameColor
  );

  TLazRibbonSkinAppearanceSection = (
    asecTab,
    asecMenuButton,
    asecPane,
    asecElement,
    asecPopup,
    asecAll
  );

  TLazRibbonAppearancePropertyBinding = class
  public
    Section: TLazRibbonSkinAppearanceSection;
    PropName: String;
  end;

const
  SkinEditorLivePreviewMinHeight = 150;

type
  { TfrmLazRibbonSkinEditor }

  TfrmLazRibbonSkinEditor = class(TForm)
    cbBaseSkin: TComboBox;
    ColorDialog: TColorDialog;
    edtAuthor: TEdit;
    edtDisplayName: TEdit;
    edtGroupName: TEdit;
    edtIcon16: TEdit;
    edtIcon24: TEdit;
    edtIcon32: TEdit;
    edtName: TEdit;
    edtPreviewImage: TEdit;
    btnIcon16: TButton;
    btnIcon24: TButton;
    btnIcon32: TButton;
    btnPreviewImage: TButton;
    btnRefreshValidation: TButton;
    imgSkinIcon: TImage;
    lblAuthor: TLabel;
    lblBaseSkin: TLabel;
    lblBaseHint: TLabel;
    lblDisplayName: TLabel;
    lblGroupName: TLabel;
    lblIcon16: TLabel;
    lblIcon24: TLabel;
    lblIcon32: TLabel;
    lblName: TLabel;
    lblPreviewImage: TLabel;
    lblDescription: TLabel;
    lblHintSimple: TLabel;
    lblLivePreview: TLabel;
    lblPreviewInfo: TLabel;
    lblValidationSummary: TLabel;
    lblSkinListTitle: TLabel;
    lblWorkflow: TLabel;
    lblStatus: TLabel;
    lblColorActive: TLabel;
    lblColorBack: TLabel;
    lblColorFrame: TLabel;
    lblColorHot: TLabel;
    lblColorMutedText: TLabel;
    lblColorNavigation: TLabel;
    lblColorRibbonBottom: TLabel;
    lblColorRibbonGroup: TLabel;
    lblColorRibbonGroupFrame: TLabel;
    lblColorRibbonTabActive: TLabel;
    lblColorRibbonTabHot: TLabel;
    lblColorRibbonTop: TLabel;
    lblColorText: TLabel;
    lstSkins: TListBox;
    memDescription: TMemo;
    memValidationReport: TMemo;
    OpenDialog: TOpenDialog;
    pcMain: TPageControl;
    pnlBottom: TPanel;
    pnlColorActive: TPanel;
    pnlColorBack: TPanel;
    pnlColorFrame: TPanel;
    pnlColorHot: TPanel;
    pnlColorMutedText: TPanel;
    pnlColorNavigation: TPanel;
    pnlColorRibbonBottom: TPanel;
    pnlColorRibbonGroup: TPanel;
    pnlColorRibbonGroupFrame: TPanel;
    pnlColorRibbonTabActive: TPanel;
    pnlColorRibbonTabHot: TPanel;
    pnlColorRibbonTop: TPanel;
    pnlColorText: TPanel;
    pnlLeft: TPanel;
    pnlLivePreview: TPanel;
    pnlMetadata: TPanel;
    pnlPreviewHost: TPanel;
    pnlSimpleColors: TPanel;
    pnlTop: TPanel;
    PreviewSkinManager: TLazRibbonSkinManager;
    PreviewToolbar: TLazRibbon;
    EditorBackstage: TLazRibbonBackstageView;
    BackstagePageInfo: TLazRibbonBackstagePage;
    BackstageLabelInfoTitle: TLabel;
    BackstageLabelInfoText: TLabel;
    EditorTabSkin: TLazRibbonTab;
    EditorTabPreview: TLazRibbonTab;
    EditorPaneFile: TLazRibbonPane;
    EditorPaneExport: TLazRibbonPane;
    EditorPaneAppearance: TLazRibbonPane;
    EditorPaneSampleEdit: TLazRibbonPane;
    EditorPaneSampleOptions: TLazRibbonPane;
    PreviewPaneFile: TLazRibbonPane;
    PreviewPaneView: TLazRibbonPane;
    EditorPaneBases: TLazRibbonPane;
    EditorLargeNewFromBase: TLazRibbonLargeButton;
    EditorLargeExportBuiltIns: TLazRibbonLargeButton;
    EditorLargeFullAppearance: TLazRibbonLargeButton;
    EditorSmallApplyPaletteAppearance: TLazRibbonSmallButton;
    PreviewLargePaste: TLazRibbonLargeButton;
    PreviewLargeNew: TLazRibbonLargeButton;
    PreviewLargeZoom: TLazRibbonLargeButton;
    EditorSmallOpen: TLazRibbonSmallButton;
    EditorSmallSaveAs: TLazRibbonSmallButton;
    PreviewSmallCopy: TLazRibbonSmallButton;
    PreviewSmallCut: TLazRibbonSmallButton;
    PreviewSmallOpen: TLazRibbonSmallButton;
    PreviewSmallSave: TLazRibbonSmallButton;
    PreviewCheckAuto: TLazRibbonCheckbox;
    PreviewBaseGallery: TLazRibbonSkinGalleryItem;
    SaveDialog: TSaveDialog;
    SelectDirDialog: TSelectDirectoryDialog;
    tabAdvanced: TTabSheet;
    tabBackstage: TTabSheet;
    tabMetadata: TTabSheet;
    tabPreview: TTabSheet;
    tabSimpleColors: TTabSheet;
    procedure btnApplyPaletteToAppearanceClick(Sender: TObject);
    procedure btnEditFullAppearanceClick(Sender: TObject);
    procedure btnExportBuiltInsClick(Sender: TObject);
    procedure btnNewFromBaseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnRefreshValidationClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure BaseGallerySkinSelected(Sender: TObject);
    procedure ColorPanelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IconFileButtonClick(Sender: TObject);
    procedure lstSkinsClick(Sender: TObject);
    procedure MetadataChanged(Sender: TObject);
  private
    FManager: TLazRibbonSkinManager;
    FCurrentSkin: TLazRibbonSkinDefinition;
    FUpdating: Boolean;
    FFullAppearanceEdited: Boolean;
    FColorPanels: array[TLazRibbonEditorPaletteField] of TPanel;
    btnApplyPaletteAppearance: TButton;
    lblAppearanceMode: TLabel;
    cbAppearanceSection: TComboBox;
    edtAppearanceFilter: TEdit;
    chkAppearanceOnlyBaseDifferences: TCheckBox;
    btnClearAppearanceFilter: TButton;
    lstAppearanceProperties: TListBox;
    btnEditAppearanceProperty: TButton;
    btnResetAppearancePropertyFromBase: TButton;
    lblAppearanceInspectorHint: TLabel;

    procedure BindColorPanels;
    procedure CreateAdvancedColorPanels;
    procedure CreateAppearanceInspectorControls;
    procedure ClearAppearancePropertyBindings;
    procedure RefreshAppearanceInspector;
    procedure CreateMetadataAssetControls;
    procedure ApplyInternalTabLayout;
    procedure RefreshIconPreview;
    procedure RefreshValidationReport;
    procedure SetupPreviewToolbar;
    procedure SyncLivePreviewHeight;
    procedure ApplyCurrentSkinToPreview;
    procedure RefreshSkinList;
    procedure RefreshBaseCombo;
    procedure LoadSkinToEditor(ASkin: TLazRibbonSkinDefinition);
    procedure UpdateEditorFromSkin;
    procedure UpdateSkinFromEditor;
    procedure UpdateColorPanels;
    procedure UpdateAppearanceModeLabel;
    procedure SetPaletteColor(AField: TLazRibbonEditorPaletteField; AColor: TColor);
    procedure AssignPaletteRespectingAppearanceGuard(const APalette: TLazRibbonSkinPalette);
    procedure OpenFullAppearanceEditor(AInitialPageIndex: Integer);
    function GetPaletteColor(AField: TLazRibbonEditorPaletteField): TColor;
    function FieldFromSender(Sender: TObject; out AField: TLazRibbonEditorPaletteField): Boolean;
    function SelectedAppearanceSection: TLazRibbonSkinAppearanceSection;
    function AppearanceSectionObject(ASection: TLazRibbonSkinAppearanceSection): TPersistent;
    function AppearanceSectionCaption(ASection: TLazRibbonSkinAppearanceSection): String;
    function IsColorAppearanceProperty(APropInfo: PPropInfo): Boolean;
    function FormatAppearancePropertyValue(AObject: TPersistent; APropInfo: PPropInfo): String;
    function CompactInlineValue(const AValue: String; AMaxLength: Integer): String;
    function AppearancePropertyDiffersFromBase(ASection: TLazRibbonSkinAppearanceSection;
      AObject: TPersistent; APropInfo: PPropInfo; out ABaseValue: String): Boolean;
    function AppearancePropertyDisplay(ABinding: TLazRibbonAppearancePropertyBinding): String;
    function AppearancePropertyMatchesFilter(ASection: TLazRibbonSkinAppearanceSection;
      AObject: TPersistent; APropInfo: PPropInfo; const AFilter: String): Boolean;
    procedure AddAppearanceSectionProperties(ASection: TLazRibbonSkinAppearanceSection);
    procedure EditAppearanceProperty(ABinding: TLazRibbonAppearancePropertyBinding);
    procedure ResetAppearancePropertyFromBase(ABinding: TLazRibbonAppearancePropertyBinding);
    procedure cbAppearanceSectionChange(Sender: TObject);
    procedure edtAppearanceFilterChange(Sender: TObject);
    procedure chkAppearanceOnlyBaseDifferencesChange(Sender: TObject);
    procedure btnClearAppearanceFilterClick(Sender: TObject);
    procedure lstAppearancePropertiesDblClick(Sender: TObject);
    procedure btnOpenAppearancePageClick(Sender: TObject);
    procedure btnOpenSelectedAppearanceSectionClick(Sender: TObject);
    procedure btnEditAppearancePropertyClick(Sender: TObject);
    procedure btnResetAppearancePropertyFromBaseClick(Sender: TObject);
    procedure EditorPaneAppearanceDialogLauncherClick(Sender: TObject);
    function AppearanceSectionObjectForSkin(ASkin: TLazRibbonSkinDefinition;
      ASection: TLazRibbonSkinAppearanceSection): TPersistent;
    function CopyAppearancePropertyValue(ABaseObj, ACurrentObj: TPersistent;
      const APropName: String; out AErrorMessage: String): Boolean;
    function SelectedBaseSkin: TLazRibbonSkinDefinition;
    function SafeSkinIdentifier(const AValue: String): String;
    function UniqueCustomSkinIdentifier(ABaseSkin: TLazRibbonSkinDefinition): String;
    function CustomDisplayNameForBase(ABaseSkin: TLazRibbonSkinDefinition): String;
    function IsValidSkinIdentifier(const AValue: String): Boolean;
    function ValidateCurrentSkinForSave: Boolean;
  public
  end;

var
  frmLazRibbonSkinEditor: TfrmLazRibbonSkinEditor;

implementation

{$R *.lfm}

{ TfrmLazRibbonSkinEditor }

function PaletteFieldCaption(AField: TLazRibbonEditorPaletteField): String;
begin
  case AField of
    pfBackstageNavColor: Result := 'Fundo da navegação';
    pfBackstageNavTextColor: Result := 'Texto normal';
    pfBackstageNavMutedTextColor: Result := 'Texto secundário';
    pfBackstageNavHoverColor: Result := 'Fundo em hover';
    pfBackstageNavHoverTextColor: Result := 'Texto em hover';
    pfBackstageNavSelectedColor: Result := 'Fundo selecionado';
    pfBackstageNavSelectedTextColor: Result := 'Texto selecionado';
    pfBackstageNavSelectedFrameColor: Result := 'Borda selecionada';
  else
    Result := '';
  end;
end;

function CreateEditorSection(AOwner: TComponent; AParent: TWinControl;
  const ATitle, ADescription: String; AX, AY, AWidth, AHeight: Integer): TPanel;
var
  L: TLabel;
begin
  Result := TPanel.Create(AOwner);
  Result.Parent := AParent;
  Result.SetBounds(AX, AY, AWidth, AHeight);
  Result.BevelOuter := bvLowered;
  Result.Caption := '';
  Result.Color := clBtnFace;

  L := TLabel.Create(AOwner);
  L.Parent := Result;
  L.Left := 14;
  L.Top := 10;
  L.Width := AWidth - 28;
  L.Height := 18;
  L.Caption := ATitle;
  L.Font.Style := [fsBold];
  L.ParentFont := False;

  if Trim(ADescription) <> '' then
  begin
    L := TLabel.Create(AOwner);
    L.Parent := Result;
    L.Left := 14;
    L.Top := 32;
    L.Width := AWidth - 28;
    L.Height := 34;
    L.AutoSize := False;
    L.WordWrap := True;
    L.Caption := ADescription;
  end;
end;

function AppearanceSectionEditorPageIndex(
  ASection: TLazRibbonSkinAppearanceSection): Integer;
begin
  case ASection of
    asecMenuButton: Result := 0;
    asecTab: Result := 1;
    asecPane: Result := 2;
    asecElement: Result := 3;
    asecPopup: Result := 4;
  else
    Result := -1;
  end;
end;

procedure PlaceLabelAndColor(ALabel: TLabel; AColorPanel: TPanel; AParent: TWinControl;
  AX, AY, ALabelWidth: Integer);
begin
  if (ALabel = nil) or (AColorPanel = nil) then Exit;
  ALabel.Parent := AParent;
  ALabel.Left := AX;
  ALabel.Top := AY + 5;
  ALabel.Width := ALabelWidth;
  AColorPanel.Parent := AParent;
  AColorPanel.Left := AX + ALabelWidth + 14;
  AColorPanel.Top := AY;
  AColorPanel.Width := 132;
  AColorPanel.Height := 24;
end;

procedure PlaceLabelAndEdit(ALabel: TLabel; AEdit: TControl; AParent: TWinControl;
  AX, AY, ALabelWidth, AEditWidth: Integer);
begin
  if (ALabel = nil) or (AEdit = nil) then Exit;
  ALabel.Parent := AParent;
  ALabel.Left := AX;
  ALabel.Top := AY + 5;
  ALabel.Width := ALabelWidth;
  AEdit.Parent := AParent;
  AEdit.Left := AX + ALabelWidth + 14;
  AEdit.Top := AY;
  AEdit.Width := AEditWidth;
end;

procedure TfrmLazRibbonSkinEditor.FormCreate(Sender: TObject);
begin
  FManager := PreviewSkinManager;
  FCurrentSkin := TLazRibbonSkinDefinition.Create;

  OpenDialog.Filter := 'Skins do LazRibbon (*.skin;*.lazskin)|*.skin;*.lazskin|Todos os arquivos (*.*)|*.*';
  SaveDialog.Filter := 'Skins do LazRibbon (*.skin)|*.skin|Skin legado (*.lazskin)|*.lazskin';
  SaveDialog.DefaultExt := 'skin';

  lblLivePreview.Caption := 'Pré-visualização da skin em tempo real';
  lblStatus.Caption := 'Pronto. Use a galeria de bases no Ribbon para visualizar skins e o menu Arquivo para criar ou abrir uma skin editável.';
  lblBaseSkin.Caption := 'Base em foco:';
  lblBaseHint.Caption := 'Visualizando base. Para editar, use Arquivo > Nova skin pela base.';
  cbBaseSkin.Enabled := False;
  lblSkinListTitle.Caption := 'Bases disponíveis';
  { Runtime layout polish: keep the real Ribbon as the first visual element and
    place the compact base-context strip immediately below it. This also keeps
    the designer and runtime layouts closer while avoiding the old side-list UI. }
  if Assigned(pnlLivePreview) then
  begin
    pnlLivePreview.Align := alTop;
    pnlLivePreview.Height := SkinEditorLivePreviewMinHeight;
  end;
  if Assigned(pnlTop) then
  begin
    pnlTop.Align := alTop;
    pnlTop.Height := 30;
    pnlTop.Visible := True;
  end;
  if Assigned(lblWorkflow) then
    lblWorkflow.Visible := False;
  FFullAppearanceEdited := False;

  BindColorPanels;
  CreateAdvancedColorPanels;
  CreateMetadataAssetControls;
  ApplyInternalTabLayout;

  PreviewSkinManager.AutoRefreshControls := True;
  PreviewSkinManager.LoadBuiltInSkins;
  PreviewToolbar.SkinManager := PreviewSkinManager;
  PreviewToolbar.AppearanceSource := asSkinManager;

  SetupPreviewToolbar;
  SyncLivePreviewHeight;
  RefreshBaseCombo;
  RefreshSkinList;

  if Assigned(pnlTop) then pnlTop.Visible := True;
  if Assigned(pnlLeft) then
  begin
    pnlLeft.Align := alNone;
    pnlLeft.Visible := False;
    pnlLeft.SetBounds(-320, 720, 250, 120);
  end;

  if Assigned(PreviewBaseGallery) then
  begin
    PreviewBaseGallery.SkinManager := PreviewSkinManager;
    PreviewBaseGallery.SelectedSkin := PreviewSkinManager.ActiveSkin;
  end;

  if PreviewSkinManager.SkinCount > 0 then
  begin
    LoadSkinToEditor(PreviewSkinManager.SkinByIndex(0));
    cbBaseSkin.ItemIndex := 0;
    lblBaseHint.Caption := 'Visualizando base: ' + PreviewSkinManager.SkinByIndex(0).DisplayName + '. Para editar, use Arquivo > Nova skin pela base.';
  end;
end;

procedure TfrmLazRibbonSkinEditor.FormDestroy(Sender: TObject);
begin
  ClearAppearancePropertyBindings;
  FreeAndNil(FCurrentSkin);
end;

procedure TfrmLazRibbonSkinEditor.BindColorPanels;
begin
  FColorPanels[pfBackColor] := pnlColorBack;
  FColorPanels[pfTextColor] := pnlColorText;
  FColorPanels[pfMutedTextColor] := pnlColorMutedText;
  FColorPanels[pfFrameColor] := pnlColorFrame;
  FColorPanels[pfNavigationColor] := pnlColorNavigation;
  FColorPanels[pfActiveColor] := pnlColorActive;
  FColorPanels[pfHotColor] := pnlColorHot;
  FColorPanels[pfRibbonTopColor] := pnlColorRibbonTop;
  FColorPanels[pfRibbonBottomColor] := pnlColorRibbonBottom;
  FColorPanels[pfRibbonTabActiveColor] := pnlColorRibbonTabActive;
  FColorPanels[pfRibbonTabHotColor] := pnlColorRibbonTabHot;
  FColorPanels[pfRibbonGroupColor] := pnlColorRibbonGroup;
  FColorPanels[pfRibbonGroupFrameColor] := pnlColorRibbonGroupFrame;
end;

procedure TfrmLazRibbonSkinEditor.CreateAdvancedColorPanels;
var
  F: TLazRibbonEditorPaletteField;
  L: TLabel;
  P: TPanel;
  B: TButton;
  SecNav, SecState, SecTech: TPanel;
  Row, X, Y: Integer;

  procedure AddVisualEditorButton(const ACaption: String; APageIndex, AX, AY,
    AWidth: Integer);
  var
    Btn: TButton;
  begin
    Btn := TButton.Create(Self);
    Btn.Parent := SecTech;
    Btn.Left := AX;
    Btn.Top := AY;
    Btn.Width := AWidth;
    Btn.Height := 28;
    Btn.Caption := ACaption;
    Btn.Tag := APageIndex;
    Btn.OnClick := @btnOpenAppearancePageClick;
  end;

begin
  { BackStage colors are now presented as two visual groups instead of a flat
    property list. This keeps the technical model unchanged but makes the editor
    easier to understand for end users. }
  SecNav := CreateEditorSection(Self, tabBackstage,
    'Navegação do BackStage',
    'Cores usadas na coluna esquerda do BackStage aberto pelo botão Arquivo.',
    16, 18, 520, 238);

  SecState := CreateEditorSection(Self, tabBackstage,
    'Estados de interação',
    'Cores usadas quando o usuário passa o mouse ou seleciona uma opção do BackStage.',
    560, 18, 520, 238);

  for F := pfBackstageNavColor to pfBackstageNavSelectedFrameColor do
  begin
    Row := Ord(F) - Ord(pfBackstageNavColor);
    if Row <= 2 then
    begin
      P := SecNav;
      X := 18;
      Y := 82 + Row * 34;
    end
    else
    begin
      P := SecState;
      X := 18;
      Y := 82 + (Row - 3) * 34;
    end;

    L := TLabel.Create(Self);
    L.Parent := P;
    L.Left := X;
    L.Top := Y + 5;
    L.Width := 180;
    L.Caption := PaletteFieldCaption(F);

    FColorPanels[F] := TPanel.Create(Self);
    FColorPanels[F].Parent := P;
    FColorPanels[F].Left := X + 210;
    FColorPanels[F].Top := Y;
    FColorPanels[F].Width := 132;
    FColorPanels[F].Height := 24;
    FColorPanels[F].BevelOuter := bvLowered;
    FColorPanels[F].Caption := '';
    FColorPanels[F].OnClick := @ColorPanelClick;
    FColorPanels[F].TabOrder := Ord(F) - Ord(pfBackstageNavColor);
  end;

  SecTech := CreateEditorSection(Self, tabAdvanced,
    'Editor visual do Appearance',
    'Fluxo completo inspirado no editor nativo do SpkToolBar: preview real, cores, fontes, gradientes, estilos, importacao e exportacao.',
    16, 18, 1064, 230);

  B := TButton.Create(Self);
  B.Parent := SecTech;
  B.Left := 18;
  B.Top := 82;
  B.Width := 250;
  B.Height := 30;
  B.Caption := 'Abrir editor visual completo...';
  B.OnClick := @btnEditFullAppearanceClick;

  AddVisualEditorButton('Menu Button', 0, 18, 124, 116);
  AddVisualEditorButton('Tab', 1, 144, 124, 86);
  AddVisualEditorButton('Pane', 2, 240, 124, 86);
  AddVisualEditorButton('Item', 3, 336, 124, 86);
  AddVisualEditorButton('Dropdown', 4, 432, 124, 104);
  AddVisualEditorButton('Import/Export', 5, 546, 124, 118);
  AddVisualEditorButton('Tools', 6, 674, 124, 84);

  btnApplyPaletteAppearance := TButton.Create(Self);
  btnApplyPaletteAppearance.Parent := SecTech;
  btnApplyPaletteAppearance.Left := 18;
  btnApplyPaletteAppearance.Top := 172;
  btnApplyPaletteAppearance.Width := 270;
  btnApplyPaletteAppearance.Height := 30;
  btnApplyPaletteAppearance.Caption := 'Regerar Appearance pela paleta';
  btnApplyPaletteAppearance.OnClick := @btnApplyPaletteToAppearanceClick;

  lblAppearanceMode := TLabel.Create(Self);
  lblAppearanceMode.Parent := SecTech;
  lblAppearanceMode.Left := 784;
  lblAppearanceMode.Top := 82;
  lblAppearanceMode.Width := 330;
  lblAppearanceMode.Height := 104;
  lblAppearanceMode.AutoSize := False;
  lblAppearanceMode.WordWrap := True;
  lblAppearanceMode.Caption := '';

  L := TLabel.Create(Self);
  L.Parent := SecTech;
  L.Left := 310;
  L.Top := 84;
  L.Width := 430;
  L.Height := 52;
  L.AutoSize := False;
  L.WordWrap := True;
  L.Caption := 'Use os atalhos para abrir diretamente a pagina certa do editor visual. A paleta simples continua disponivel para criar skins rapidamente; o editor visual faz o ajuste fino do Appearance.';

  CreateAppearanceInspectorControls;
end;

procedure TfrmLazRibbonSkinEditor.CreateAppearanceInspectorControls;
var
  Sec: TPanel;
  L: TLabel;
  B: TButton;
begin
  if lstAppearanceProperties <> nil then
    Exit;

  Sec := CreateEditorSection(Self, tabAdvanced,
    'Inspetor completo do Appearance',
    'Lista todas as propriedades publicadas de Tab, MenuButton, Pane, Element e Popup. Edite aqui os mesmos dados salvos no arquivo da skin.',
    16, 270, 1064, 330);

  L := TLabel.Create(Self);
  L.Parent := Sec;
  L.Left := 18;
  L.Top := 82;
  L.Caption := 'Secao';

  cbAppearanceSection := TComboBox.Create(Self);
  cbAppearanceSection.Parent := Sec;
  cbAppearanceSection.Left := 92;
  cbAppearanceSection.Top := 78;
  cbAppearanceSection.Width := 180;
  cbAppearanceSection.Style := csDropDownList;
  cbAppearanceSection.Items.Add('Todas as secoes');
  cbAppearanceSection.Items.Add('Tab');
  cbAppearanceSection.Items.Add('MenuButton');
  cbAppearanceSection.Items.Add('Pane');
  cbAppearanceSection.Items.Add('Element');
  cbAppearanceSection.Items.Add('Popup');
  cbAppearanceSection.ItemIndex := 0;
  cbAppearanceSection.OnChange := @cbAppearanceSectionChange;

  btnEditAppearanceProperty := TButton.Create(Self);
  btnEditAppearanceProperty.Parent := Sec;
  btnEditAppearanceProperty.Left := 292;
  btnEditAppearanceProperty.Top := 77;
  btnEditAppearanceProperty.Width := 150;
  btnEditAppearanceProperty.Height := 27;
  btnEditAppearanceProperty.Caption := 'Editar selecionado';
  btnEditAppearanceProperty.OnClick := @btnEditAppearancePropertyClick;

  btnResetAppearancePropertyFromBase := TButton.Create(Self);
  btnResetAppearancePropertyFromBase.Parent := Sec;
  btnResetAppearancePropertyFromBase.Left := 456;
  btnResetAppearancePropertyFromBase.Top := 77;
  btnResetAppearancePropertyFromBase.Width := 150;
  btnResetAppearancePropertyFromBase.Height := 27;
  btnResetAppearancePropertyFromBase.Caption := 'Restaurar da base';
  btnResetAppearancePropertyFromBase.OnClick := @btnResetAppearancePropertyFromBaseClick;

  B := TButton.Create(Self);
  B.Parent := Sec;
  B.Left := 620;
  B.Top := 77;
  B.Width := 150;
  B.Height := 27;
  B.Caption := 'Abrir secao';
  B.OnClick := @btnOpenSelectedAppearanceSectionClick;

  chkAppearanceOnlyBaseDifferences := TCheckBox.Create(Self);
  chkAppearanceOnlyBaseDifferences.Parent := Sec;
  chkAppearanceOnlyBaseDifferences.Left := 790;
  chkAppearanceOnlyBaseDifferences.Top := 114;
  chkAppearanceOnlyBaseDifferences.Width := 230;
  chkAppearanceOnlyBaseDifferences.Height := 22;
  chkAppearanceOnlyBaseDifferences.Caption := 'Somente diferentes da base';
  chkAppearanceOnlyBaseDifferences.OnChange := @chkAppearanceOnlyBaseDifferencesChange;

  L := TLabel.Create(Self);
  L.Parent := Sec;
  L.Left := 18;
  L.Top := 112;
  L.Caption := 'Filtro';

  edtAppearanceFilter := TEdit.Create(Self);
  edtAppearanceFilter.Parent := Sec;
  edtAppearanceFilter.Left := 92;
  edtAppearanceFilter.Top := 108;
  edtAppearanceFilter.Width := 420;
  edtAppearanceFilter.OnChange := @edtAppearanceFilterChange;

  btnClearAppearanceFilter := TButton.Create(Self);
  btnClearAppearanceFilter.Parent := Sec;
  btnClearAppearanceFilter.Left := 524;
  btnClearAppearanceFilter.Top := 107;
  btnClearAppearanceFilter.Width := 122;
  btnClearAppearanceFilter.Height := 27;
  btnClearAppearanceFilter.Caption := 'Limpar filtro';
  btnClearAppearanceFilter.OnClick := @btnClearAppearanceFilterClick;

  lblAppearanceInspectorHint := TLabel.Create(Self);
  lblAppearanceInspectorHint.Parent := Sec;
  lblAppearanceInspectorHint.Left := 790;
  lblAppearanceInspectorHint.Top := 78;
  lblAppearanceInspectorHint.Width := 230;
  lblAppearanceInspectorHint.Height := 34;
  lblAppearanceInspectorHint.AutoSize := False;
  lblAppearanceInspectorHint.WordWrap := True;
  lblAppearanceInspectorHint.Caption := 'Dica: duplo clique em uma propriedade tambem edita. Cores, fontes, inteiros, booleanos e enums sao tratados automaticamente.';

  lstAppearanceProperties := TListBox.Create(Self);
  lstAppearanceProperties.Parent := Sec;
  lstAppearanceProperties.Left := 18;
  lstAppearanceProperties.Top := 144;
  lstAppearanceProperties.Width := 1018;
  lstAppearanceProperties.Height := 156;
  lstAppearanceProperties.ItemHeight := 18;
  lstAppearanceProperties.OnDblClick := @lstAppearancePropertiesDblClick;
end;

procedure TfrmLazRibbonSkinEditor.ClearAppearancePropertyBindings;
var
  I: Integer;
begin
  if lstAppearanceProperties = nil then
    Exit;

  for I := 0 to lstAppearanceProperties.Items.Count - 1 do
    TObject(lstAppearanceProperties.Items.Objects[I]).Free;
  lstAppearanceProperties.Items.Clear;
end;

function TfrmLazRibbonSkinEditor.SelectedAppearanceSection: TLazRibbonSkinAppearanceSection;
begin
  Result := asecAll;
  if cbAppearanceSection = nil then
    Exit;

  case cbAppearanceSection.ItemIndex of
    1: Result := asecTab;
    2: Result := asecMenuButton;
    3: Result := asecPane;
    4: Result := asecElement;
    5: Result := asecPopup;
  end;
end;

function TfrmLazRibbonSkinEditor.AppearanceSectionObjectForSkin(
  ASkin: TLazRibbonSkinDefinition;
  ASection: TLazRibbonSkinAppearanceSection): TPersistent;
begin
  Result := nil;
  if (ASkin = nil) or (ASkin.Appearance = nil) then
    Exit;

  case ASection of
    asecTab: Result := ASkin.Appearance.Tab;
    asecMenuButton: Result := ASkin.Appearance.MenuButton;
    asecPane: Result := ASkin.Appearance.Pane;
    asecElement: Result := ASkin.Appearance.Element;
    asecPopup: Result := ASkin.Appearance.Popup;
    asecAll: Result := nil;
  end;
end;

function TfrmLazRibbonSkinEditor.AppearanceSectionObject(
  ASection: TLazRibbonSkinAppearanceSection): TPersistent;
begin
  Result := AppearanceSectionObjectForSkin(FCurrentSkin, ASection);
end;

function TfrmLazRibbonSkinEditor.AppearanceSectionCaption(
  ASection: TLazRibbonSkinAppearanceSection): String;
begin
  case ASection of
    asecMenuButton: Result := 'MenuButton';
    asecPane: Result := 'Pane';
    asecElement: Result := 'Element';
    asecPopup: Result := 'Popup';
    asecAll: Result := 'Todas';
  else
    Result := 'Tab';
  end;
end;

function TfrmLazRibbonSkinEditor.IsColorAppearanceProperty(
  APropInfo: PPropInfo): Boolean;
begin
  Result := (APropInfo <> nil) and
    SameText(String(APropInfo^.PropType^.Name), 'TColor');
end;

function TfrmLazRibbonSkinEditor.FormatAppearancePropertyValue(
  AObject: TPersistent; APropInfo: PPropInfo): String;
var
  Kind: TTypeKind;
  Obj: TObject;
begin
  Result := '';
  if (AObject = nil) or (APropInfo = nil) then
    Exit;

  Kind := APropInfo^.PropType^.Kind;
  case Kind of
    tkInteger, tkInt64, tkQWord:
      begin
        if IsColorAppearanceProperty(APropInfo) then
          Result := ColorToString(TColor(GetOrdProp(AObject, APropInfo)))
        else
          Result := IntToStr(GetOrdProp(AObject, APropInfo));
      end;

    tkEnumeration:
      Result := GetEnumProp(AObject, APropInfo);

    tkBool:
      Result := BoolToStr(GetOrdProp(AObject, APropInfo) <> 0, True);

    tkFloat:
      Result := FloatToStr(GetFloatProp(AObject, APropInfo));

    tkSet:
      Result := GetSetProp(AObject, APropInfo, True);

    tkChar, tkWChar, tkUChar:
      Result := Chr(GetOrdProp(AObject, APropInfo));

    tkSString, tkLString, tkAString, tkWString, tkUString:
      Result := GetStrProp(AObject, APropInfo);

    tkClass:
      begin
        Obj := GetObjectProp(AObject, APropInfo);
        if Obj is TFont then
          Result := Format('%s, %d, %s', [TFont(Obj).Name, TFont(Obj).Size,
            ColorToString(TFont(Obj).Color)])
        else if Obj <> nil then
          Result := Obj.ClassName
        else
          Result := '(nil)';
      end;
  else
    Result := '(sem editor)';
  end;
end;

function TfrmLazRibbonSkinEditor.CompactInlineValue(const AValue: String;
  AMaxLength: Integer): String;
begin
  Result := Trim(AValue);
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
  if Result = '' then
    Result := '(vazio)';
  if (AMaxLength > 3) and (Length(Result) > AMaxLength) then
    Result := Copy(Result, 1, AMaxLength - 3) + '...';
end;

function TfrmLazRibbonSkinEditor.AppearancePropertyDiffersFromBase(
  ASection: TLazRibbonSkinAppearanceSection; AObject: TPersistent;
  APropInfo: PPropInfo; out ABaseValue: String): Boolean;
var
  BaseSkin: TLazRibbonSkinDefinition;
  BaseObj: TPersistent;
  BaseProp: PPropInfo;
  CurrentValue: String;
begin
  Result := False;
  ABaseValue := '';
  if (AObject = nil) or (APropInfo = nil) then
    Exit;

  BaseSkin := SelectedBaseSkin;
  BaseObj := AppearanceSectionObjectForSkin(BaseSkin, ASection);
  if BaseObj = nil then
    Exit;

  BaseProp := GetPropInfo(BaseObj, String(APropInfo^.Name));
  if BaseProp = nil then
    Exit;

  ABaseValue := FormatAppearancePropertyValue(BaseObj, BaseProp);
  CurrentValue := FormatAppearancePropertyValue(AObject, APropInfo);
  Result := ABaseValue <> CurrentValue;
end;

function TfrmLazRibbonSkinEditor.AppearancePropertyDisplay(
  ABinding: TLazRibbonAppearancePropertyBinding): String;
var
  Obj: TPersistent;
  PropInfo: PPropInfo;
  TypeName, BaseValue: String;
  DiffersFromBase: Boolean;
begin
  Result := '';
  if ABinding = nil then
    Exit;

  Obj := AppearanceSectionObject(ABinding.Section);
  PropInfo := GetPropInfo(Obj, ABinding.PropName);
  if PropInfo = nil then
    Exit;

  TypeName := String(PropInfo^.PropType^.Name);
  if IsColorAppearanceProperty(PropInfo) then
    TypeName := 'TColor';

  DiffersFromBase := AppearancePropertyDiffersFromBase(ABinding.Section, Obj,
    PropInfo, BaseValue);

  Result := AppearanceSectionCaption(ABinding.Section) + '.' + ABinding.PropName +
    ' [' + TypeName + '] = ' + FormatAppearancePropertyValue(Obj, PropInfo);
  if DiffersFromBase then
    Result := '[alterado] ' + Result + ' | base = ' +
      CompactInlineValue(BaseValue, 72);
end;

function TfrmLazRibbonSkinEditor.AppearancePropertyMatchesFilter(
  ASection: TLazRibbonSkinAppearanceSection; AObject: TPersistent;
  APropInfo: PPropInfo; const AFilter: String): Boolean;
var
  FilterText, Haystack: String;
begin
  Result := True;
  FilterText := LowerCase(Trim(AFilter));
  if FilterText = '' then
    Exit;

  Haystack := LowerCase(
    AppearanceSectionCaption(ASection) + ' ' +
    String(APropInfo^.Name) + ' ' +
    String(APropInfo^.PropType^.Name) + ' ' +
    FormatAppearancePropertyValue(AObject, APropInfo));

  Result := Pos(FilterText, Haystack) > 0;
end;

procedure TfrmLazRibbonSkinEditor.AddAppearanceSectionProperties(
  ASection: TLazRibbonSkinAppearanceSection);
var
  Obj: TPersistent;
  PropList: PPropList;
  PropCount, I: Integer;
  Binding: TLazRibbonAppearancePropertyBinding;
  FilterText, BaseValue: String;
  OnlyBaseDifferences: Boolean;
begin
  Obj := AppearanceSectionObject(ASection);
  if Obj = nil then
    Exit;

  FilterText := '';
  if edtAppearanceFilter <> nil then
    FilterText := edtAppearanceFilter.Text;
  OnlyBaseDifferences := (chkAppearanceOnlyBaseDifferences <> nil) and
    chkAppearanceOnlyBaseDifferences.Checked;

  PropList := nil;
  PropCount := GetPropList(Obj, PropList);
  try
    for I := 0 to PropCount - 1 do
    begin
      if PropList^[I] = nil then
        Continue;

      if not AppearancePropertyMatchesFilter(ASection, Obj, PropList^[I], FilterText) then
        Continue;

      if OnlyBaseDifferences and
         (not AppearancePropertyDiffersFromBase(ASection, Obj, PropList^[I], BaseValue)) then
        Continue;

      Binding := TLazRibbonAppearancePropertyBinding.Create;
      Binding.Section := ASection;
      Binding.PropName := String(PropList^[I]^.Name);
      lstAppearanceProperties.Items.AddObject(
        AppearancePropertyDisplay(Binding), Binding);
    end;
  finally
    if PropList <> nil then
      FreeMem(PropList);
  end;
end;

procedure TfrmLazRibbonSkinEditor.RefreshAppearanceInspector;
const
  Sections: array[0..4] of TLazRibbonSkinAppearanceSection = (
    asecTab,
    asecMenuButton,
    asecPane,
    asecElement,
    asecPopup
  );
var
  I: Integer;
  Section: TLazRibbonSkinAppearanceSection;
begin
  if lstAppearanceProperties = nil then
    Exit;

  ClearAppearancePropertyBindings;

  Section := SelectedAppearanceSection;
  if Section = asecAll then
  begin
    for I := Low(Sections) to High(Sections) do
      AddAppearanceSectionProperties(Sections[I]);
  end
  else
  begin
    AddAppearanceSectionProperties(Section);
  end;
end;

procedure TfrmLazRibbonSkinEditor.EditAppearanceProperty(
  ABinding: TLazRibbonAppearancePropertyBinding);
var
  Obj: TPersistent;
  PropInfo: PPropInfo;
  Kind: TTypeKind;
  S, ValuesText: String;
  TypeData: PTypeData;
  I, EnumValue: Integer;
  FontDialog: TFontDialog;
  Value64: Int64;
  FloatValue: Extended;
  BoolValue: Boolean;
begin
  if ABinding = nil then
    Exit;

  Obj := AppearanceSectionObject(ABinding.Section);
  PropInfo := GetPropInfo(Obj, ABinding.PropName);
  if (Obj = nil) or (PropInfo = nil) then
    Exit;

  Kind := PropInfo^.PropType^.Kind;
  case Kind of
    tkInteger, tkInt64, tkQWord:
      begin
        if IsColorAppearanceProperty(PropInfo) then
        begin
          ColorDialog.Color := TColor(GetOrdProp(Obj, PropInfo));
          if not ColorDialog.Execute then
            Exit;
          SetOrdProp(Obj, PropInfo, ColorDialog.Color);
        end
        else
        begin
          S := IntToStr(GetOrdProp(Obj, PropInfo));
          if not InputQuery('Editar Appearance', ABinding.PropName, S) then
            Exit;
          if not TryStrToInt64(Trim(S), Value64) then
          begin
            MessageDlg('Editar Appearance', 'Valor numerico invalido.', mtWarning, [mbOK], 0);
            Exit;
          end;
          SetOrdProp(Obj, PropInfo, Value64);
        end;
      end;

    tkEnumeration:
      begin
        TypeData := GetTypeData(PropInfo^.PropType);
        ValuesText := '';
        for I := TypeData^.MinValue to TypeData^.MaxValue do
        begin
          if ValuesText <> '' then
            ValuesText := ValuesText + ', ';
          ValuesText := ValuesText + GetEnumName(PropInfo^.PropType, I);
        end;

        S := GetEnumProp(Obj, PropInfo);
        if not InputQuery('Editar Appearance',
          ABinding.PropName + ' (' + ValuesText + ')', S) then
          Exit;
        EnumValue := GetEnumValue(PropInfo^.PropType, Trim(S));
        if EnumValue < 0 then
        begin
          MessageDlg('Editar Appearance', 'Valor de enumeracao invalido.', mtWarning, [mbOK], 0);
          Exit;
        end;
        SetOrdProp(Obj, PropInfo, EnumValue);
      end;

    tkBool:
      begin
        BoolValue := GetOrdProp(Obj, PropInfo) <> 0;
        if MessageDlg('Editar Appearance',
          'Definir ' + ABinding.PropName + ' como True?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          BoolValue := True
        else
          BoolValue := False;
        SetOrdProp(Obj, PropInfo, Ord(BoolValue));
      end;

    tkFloat:
      begin
        S := FloatToStr(GetFloatProp(Obj, PropInfo));
        if not InputQuery('Editar Appearance', ABinding.PropName, S) then
          Exit;
        if not TryStrToFloat(Trim(S), FloatValue) then
        begin
          MessageDlg('Editar Appearance', 'Valor decimal invalido.', mtWarning, [mbOK], 0);
          Exit;
        end;
        SetFloatProp(Obj, PropInfo, FloatValue);
      end;

    tkSet:
      begin
        S := GetSetProp(Obj, PropInfo, True);
        if not InputQuery('Editar Appearance',
          ABinding.PropName + ' (ex.: [fsBold, fsItalic])', S) then
          Exit;
        try
          SetSetProp(Obj, PropInfo, Trim(S));
        except
          on E: Exception do
          begin
            MessageDlg('Editar Appearance', 'Valor de conjunto invalido: ' +
              E.Message, mtWarning, [mbOK], 0);
            Exit;
          end;
        end;
      end;

    tkChar, tkWChar, tkUChar:
      begin
        S := Chr(GetOrdProp(Obj, PropInfo));
        if not InputQuery('Editar Appearance', ABinding.PropName, S) then
          Exit;
        if Length(S) <> 1 then
        begin
          MessageDlg('Editar Appearance', 'Informe apenas um caractere.', mtWarning, [mbOK], 0);
          Exit;
        end;
        SetOrdProp(Obj, PropInfo, Ord(S[1]));
      end;

    tkSString, tkLString, tkAString, tkWString, tkUString:
      begin
        S := GetStrProp(Obj, PropInfo);
        if not InputQuery('Editar Appearance', ABinding.PropName, S) then
          Exit;
        SetStrProp(Obj, PropInfo, S);
      end;

    tkClass:
      begin
        if GetObjectProp(Obj, PropInfo) is TFont then
        begin
          FontDialog := TFontDialog.Create(Self);
          try
            FontDialog.Font.Assign(TFont(GetObjectProp(Obj, PropInfo)));
            if not FontDialog.Execute then
              Exit;
            TFont(GetObjectProp(Obj, PropInfo)).Assign(FontDialog.Font);
          finally
            FontDialog.Free;
          end;
        end
        else
        begin
          MessageDlg('Editar Appearance',
            'Esta propriedade de objeto nao tem editor direto no Skin Editor.',
            mtInformation, [mbOK], 0);
          Exit;
        end;
      end;
  else
    MessageDlg('Editar Appearance',
      'Este tipo de propriedade ainda nao tem editor direto no Skin Editor.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  FCurrentSkin.Source := sssCustom;
  FFullAppearanceEdited := True;
  RefreshAppearanceInspector;
  ApplyCurrentSkinToPreview;
  UpdateAppearanceModeLabel;
  lblStatus.Caption := 'Appearance atualizado em ' +
    AppearanceSectionCaption(ABinding.Section) + '.' + ABinding.PropName + '.';
  RefreshValidationReport;
end;

function TfrmLazRibbonSkinEditor.CopyAppearancePropertyValue(
  ABaseObj, ACurrentObj: TPersistent; const APropName: String;
  out AErrorMessage: String): Boolean;
var
  BaseProp, CurrentProp: PPropInfo;
  Kind: TTypeKind;
  BaseObject, CurrentObject: TObject;
begin
  Result := False;
  AErrorMessage := '';
  if (ABaseObj = nil) or (ACurrentObj = nil) then
  begin
    AErrorMessage := 'Secao de Appearance indisponivel.';
    Exit;
  end;

  BaseProp := GetPropInfo(ABaseObj, APropName);
  CurrentProp := GetPropInfo(ACurrentObj, APropName);
  if (BaseProp = nil) or (CurrentProp = nil) then
  begin
    AErrorMessage := 'Propriedade nao encontrada na base ou na skin atual.';
    Exit;
  end;

  Kind := CurrentProp^.PropType^.Kind;
  if BaseProp^.PropType^.Kind <> Kind then
  begin
    AErrorMessage := 'Tipo da propriedade difere entre a base e a skin atual.';
    Exit;
  end;

  case Kind of
    tkInteger, tkInt64, tkQWord, tkEnumeration, tkBool,
    tkChar, tkWChar, tkUChar:
      SetOrdProp(ACurrentObj, CurrentProp, GetOrdProp(ABaseObj, BaseProp));

    tkFloat:
      SetFloatProp(ACurrentObj, CurrentProp, GetFloatProp(ABaseObj, BaseProp));

    tkSet:
      SetSetProp(ACurrentObj, CurrentProp, GetSetProp(ABaseObj, BaseProp, True));

    tkSString, tkLString, tkAString, tkWString, tkUString:
      SetStrProp(ACurrentObj, CurrentProp, GetStrProp(ABaseObj, BaseProp));

    tkClass:
      begin
        BaseObject := GetObjectProp(ABaseObj, BaseProp);
        CurrentObject := GetObjectProp(ACurrentObj, CurrentProp);
        if (BaseObject is TFont) and (CurrentObject is TFont) then
          TFont(CurrentObject).Assign(TFont(BaseObject))
        else
        begin
          AErrorMessage := 'Esta propriedade de objeto nao pode ser restaurada automaticamente.';
          Exit;
        end;
      end;
  else
    AErrorMessage := 'Tipo de propriedade ainda nao suportado para restauracao.';
    Exit;
  end;

  Result := True;
end;

procedure TfrmLazRibbonSkinEditor.ResetAppearancePropertyFromBase(
  ABinding: TLazRibbonAppearancePropertyBinding);
var
  BaseSkin: TLazRibbonSkinDefinition;
  BaseObj, CurrentObj: TPersistent;
  ErrorMessage: String;
begin
  if ABinding = nil then
    Exit;

  BaseSkin := SelectedBaseSkin;
  if BaseSkin = nil then
  begin
    MessageDlg('Restaurar da base',
      'Selecione uma skin-base antes de restaurar uma propriedade.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  BaseObj := AppearanceSectionObjectForSkin(BaseSkin, ABinding.Section);
  CurrentObj := AppearanceSectionObjectForSkin(FCurrentSkin, ABinding.Section);
  if not CopyAppearancePropertyValue(BaseObj, CurrentObj, ABinding.PropName,
    ErrorMessage) then
  begin
    MessageDlg('Restaurar da base', ErrorMessage, mtWarning, [mbOK], 0);
    Exit;
  end;

  FCurrentSkin.Source := sssCustom;
  FFullAppearanceEdited := True;
  RefreshAppearanceInspector;
  ApplyCurrentSkinToPreview;
  UpdateAppearanceModeLabel;
  RefreshValidationReport;
  lblStatus.Caption := 'Appearance restaurado da base em ' +
    AppearanceSectionCaption(ABinding.Section) + '.' + ABinding.PropName + '.';
end;

procedure TfrmLazRibbonSkinEditor.cbAppearanceSectionChange(Sender: TObject);
begin
  RefreshAppearanceInspector;
end;

procedure TfrmLazRibbonSkinEditor.edtAppearanceFilterChange(Sender: TObject);
begin
  RefreshAppearanceInspector;
end;

procedure TfrmLazRibbonSkinEditor.chkAppearanceOnlyBaseDifferencesChange(
  Sender: TObject);
begin
  RefreshAppearanceInspector;
end;

procedure TfrmLazRibbonSkinEditor.btnClearAppearanceFilterClick(Sender: TObject);
begin
  if edtAppearanceFilter = nil then
    Exit;

  edtAppearanceFilter.Clear;
  RefreshAppearanceInspector;
end;

procedure TfrmLazRibbonSkinEditor.lstAppearancePropertiesDblClick(Sender: TObject);
begin
  btnEditAppearancePropertyClick(Sender);
end;

procedure TfrmLazRibbonSkinEditor.btnOpenAppearancePageClick(Sender: TObject);
begin
  if Sender is TButton then
    OpenFullAppearanceEditor(TButton(Sender).Tag)
  else
    OpenFullAppearanceEditor(-1);
end;

procedure TfrmLazRibbonSkinEditor.btnOpenSelectedAppearanceSectionClick(Sender: TObject);
var
  Section: TLazRibbonSkinAppearanceSection;
  Binding: TLazRibbonAppearancePropertyBinding;
begin
  Section := SelectedAppearanceSection;
  if (Section = asecAll) and (lstAppearanceProperties <> nil) and
     (lstAppearanceProperties.ItemIndex >= 0) then
  begin
    Binding := TLazRibbonAppearancePropertyBinding(
      lstAppearanceProperties.Items.Objects[lstAppearanceProperties.ItemIndex]);
    if Binding <> nil then
      Section := Binding.Section;
  end;

  OpenFullAppearanceEditor(AppearanceSectionEditorPageIndex(Section));
end;

procedure TfrmLazRibbonSkinEditor.btnEditAppearancePropertyClick(Sender: TObject);
begin
  if (lstAppearanceProperties = nil) or
     (lstAppearanceProperties.ItemIndex < 0) then
    Exit;

  EditAppearanceProperty(TLazRibbonAppearancePropertyBinding(
    lstAppearanceProperties.Items.Objects[lstAppearanceProperties.ItemIndex]));
end;

procedure TfrmLazRibbonSkinEditor.btnResetAppearancePropertyFromBaseClick(
  Sender: TObject);
begin
  if (lstAppearanceProperties = nil) or
     (lstAppearanceProperties.ItemIndex < 0) then
    Exit;

  ResetAppearancePropertyFromBase(TLazRibbonAppearancePropertyBinding(
    lstAppearanceProperties.Items.Objects[lstAppearanceProperties.ItemIndex]));
end;

procedure TfrmLazRibbonSkinEditor.CreateMetadataAssetControls;
begin
  if Assigned(edtGroupName) then edtGroupName.OnChange := @MetadataChanged;
  if Assigned(edtIcon16) then edtIcon16.OnChange := @MetadataChanged;
  if Assigned(edtIcon24) then edtIcon24.OnChange := @MetadataChanged;
  if Assigned(edtIcon32) then edtIcon32.OnChange := @MetadataChanged;
  if Assigned(edtPreviewImage) then edtPreviewImage.OnChange := @MetadataChanged;

  if Assigned(btnIcon16) then begin btnIcon16.Tag := 16; btnIcon16.OnClick := @IconFileButtonClick; end;
  if Assigned(btnIcon24) then begin btnIcon24.Tag := 24; btnIcon24.OnClick := @IconFileButtonClick; end;
  if Assigned(btnIcon32) then begin btnIcon32.Tag := 32; btnIcon32.OnClick := @IconFileButtonClick; end;
  if Assigned(btnPreviewImage) then begin btnPreviewImage.Tag := 99; btnPreviewImage.OnClick := @IconFileButtonClick; end;

  if Assigned(imgSkinIcon) then
  begin
    imgSkinIcon.Center := True;
    imgSkinIcon.Stretch := True;
  end;

  if pnlMetadata.Height < 410 then
    pnlMetadata.Height := 410;
end;

procedure TfrmLazRibbonSkinEditor.ApplyInternalTabLayout;
var
  SecMain, SecDesc, SecAssets: TPanel;
  SecGeneral, SecRibbon, SecStates: TPanel;
  SecValidation, SecChecklist: TPanel;
  L: TLabel;
begin
  { Identity tab }
  pnlMetadata.Align := alNone;
  pnlMetadata.SetBounds(16, 16, 1088, 438);
  pnlMetadata.BevelOuter := bvNone;

  SecMain := CreateEditorSection(Self, pnlMetadata,
    'Identificação da skin',
    'Defina o identificador interno e o nome visível usado no seletor de skins.',
    0, 0, 520, 150);
  SecDesc := CreateEditorSection(Self, pnlMetadata,
    'Autoria e descrição',
    'Registre autoria e uma descrição breve para orientar uso futuro.',
    544, 0, 520, 150);
  SecAssets := CreateEditorSection(Self, pnlMetadata,
    'Ícones e imagem de prévia',
    'Opcional. Os arquivos de ícone selecionados são incorporados ao XML da skin ao salvar.',
    0, 174, 1064, 230);

  PlaceLabelAndEdit(lblName, edtName, SecMain, 18, 78, 110, 300);
  PlaceLabelAndEdit(lblDisplayName, edtDisplayName, SecMain, 18, 112, 110, 330);

  PlaceLabelAndEdit(lblAuthor, edtAuthor, SecDesc, 18, 78, 90, 300);
  PlaceLabelAndEdit(lblDescription, memDescription, SecDesc, 18, 112, 90, 350);
  memDescription.Height := 58;

  if Assigned(lblGroupName) then
    PlaceLabelAndEdit(lblGroupName, edtGroupName, SecAssets, 18, 76, 120, 300);
  if Assigned(lblIcon16) then
    PlaceLabelAndEdit(lblIcon16, edtIcon16, SecAssets, 18, 110, 120, 470);
  if Assigned(lblIcon24) then
    PlaceLabelAndEdit(lblIcon24, edtIcon24, SecAssets, 18, 144, 120, 470);
  if Assigned(lblIcon32) then
    PlaceLabelAndEdit(lblIcon32, edtIcon32, SecAssets, 18, 178, 120, 470);
  if Assigned(lblPreviewImage) then
    PlaceLabelAndEdit(lblPreviewImage, edtPreviewImage, SecAssets, 18, 212, 120, 470);

  if Assigned(btnIcon16) then begin btnIcon16.Parent := SecAssets; btnIcon16.SetBounds(624, 109, 28, 25); end;
  if Assigned(btnIcon24) then begin btnIcon24.Parent := SecAssets; btnIcon24.SetBounds(624, 143, 28, 25); end;
  if Assigned(btnIcon32) then begin btnIcon32.Parent := SecAssets; btnIcon32.SetBounds(624, 177, 28, 25); end;
  if Assigned(btnPreviewImage) then begin btnPreviewImage.Parent := SecAssets; btnPreviewImage.SetBounds(624, 211, 28, 25); end;
  if Assigned(imgSkinIcon) then begin imgSkinIcon.Parent := SecAssets; imgSkinIcon.SetBounds(690, 102, 96, 96); end;

  { Ribbon colors tab }
  lblHintSimple.Left := 16;
  lblHintSimple.Top := 14;
  lblHintSimple.Width := 1040;
  lblHintSimple.Height := 38;

  SecGeneral := CreateEditorSection(Self, pnlSimpleColors,
    'Cores gerais',
    'Base visual comum da skin: fundo, texto e bordas.',
    16, 66, 342, 268);
  SecRibbon := CreateEditorSection(Self, pnlSimpleColors,
    'Ribbon e abas',
    'Cores da faixa superior, abas e grupos.',
    386, 66, 342, 268);
  SecStates := CreateEditorSection(Self, pnlSimpleColors,
    'Estados de interação',
    'Cores para navegação, hover e item ativo.',
    756, 66, 342, 268);

  PlaceLabelAndColor(lblColorBack, pnlColorBack, SecGeneral, 18, 82, 140);
  PlaceLabelAndColor(lblColorText, pnlColorText, SecGeneral, 18, 116, 140);
  PlaceLabelAndColor(lblColorMutedText, pnlColorMutedText, SecGeneral, 18, 150, 140);
  PlaceLabelAndColor(lblColorFrame, pnlColorFrame, SecGeneral, 18, 184, 140);

  PlaceLabelAndColor(lblColorRibbonTop, pnlColorRibbonTop, SecRibbon, 18, 82, 140);
  PlaceLabelAndColor(lblColorRibbonBottom, pnlColorRibbonBottom, SecRibbon, 18, 116, 140);
  PlaceLabelAndColor(lblColorRibbonTabActive, pnlColorRibbonTabActive, SecRibbon, 18, 150, 140);
  PlaceLabelAndColor(lblColorRibbonTabHot, pnlColorRibbonTabHot, SecRibbon, 18, 184, 140);
  PlaceLabelAndColor(lblColorRibbonGroup, pnlColorRibbonGroup, SecRibbon, 18, 218, 140);
  PlaceLabelAndColor(lblColorRibbonGroupFrame, pnlColorRibbonGroupFrame, SecRibbon, 18, 252, 140);

  PlaceLabelAndColor(lblColorNavigation, pnlColorNavigation, SecStates, 18, 82, 140);
  PlaceLabelAndColor(lblColorHot, pnlColorHot, SecStates, 18, 116, 140);
  PlaceLabelAndColor(lblColorActive, pnlColorActive, SecStates, 18, 150, 140);

  { Validation tab }
  lblPreviewInfo.Parent := pnlPreviewHost;
  lblPreviewInfo.Left := 32;
  lblPreviewInfo.Top := 28;
  lblPreviewInfo.Width := 960;
  lblPreviewInfo.Caption := 'Valide a skin no Ribbon superior antes de salvar ou exportar. Esta página não altera dados; ela apenas orienta a revisão visual.';

  SecValidation := CreateEditorSection(Self, pnlPreviewHost,
    'O que observar no preview',
    'Use as abas Página inicial e Exibir do Ribbon para checar leitura, contraste e estados visuais.',
    32, 86, 500, 250);
  SecChecklist := CreateEditorSection(Self, pnlPreviewHost,
    'Checklist mínimo antes de salvar',
    'Confirme estes pontos para evitar skins visualmente quebradas.',
    560, 86, 500, 250);

  L := TLabel.Create(Self);
  L.Parent := SecValidation;
  L.SetBounds(24, 82, 420, 118);
  L.AutoSize := False;
  L.WordWrap := True;
  L.Caption := '- abas ativa e inativa;' + LineEnding +
               '- botões grandes e pequenos;' + LineEnding +
               '- grupos/panes;' + LineEnding +
               '- checkbox e estados de item;' + LineEnding +
               '- leitura do texto sobre fundos claros e escuros.';

  L := TLabel.Create(Self);
  L.Parent := SecChecklist;
  L.SetBounds(24, 82, 420, 118);
  L.AutoSize := False;
  L.WordWrap := True;
  L.Caption := '- nome interno definido;' + LineEnding +
               '- nome exibido compreensível;' + LineEnding +
               '- contraste aceitável;' + LineEnding +
               '- BackStage legível;' + LineEnding +
               '- arquivo salvo e reaberto sem erro.';
  SecValidation.Visible := False;
  SecChecklist.Visible := False;

  if Assigned(lblPreviewInfo) then
  begin
    lblPreviewInfo.SetBounds(16, 18, 980, 36);
    lblPreviewInfo.Caption := 'Valide a skin antes de salvar: identidade, arquivos de imagem, dados embutidos, contraste de texto e estado do Appearance detalhado.';
  end;

  if Assigned(btnRefreshValidation) then
    btnRefreshValidation.SetBounds(16, 66, 160, 30);

  if Assigned(lblValidationSummary) then
    lblValidationSummary.SetBounds(192, 72, 860, 24);

  if Assigned(memValidationReport) then
  begin
    memValidationReport.SetBounds(16, 112, pnlPreviewHost.ClientWidth - 32,
      pnlPreviewHost.ClientHeight - 134);
    memValidationReport.Anchors := [akTop, akLeft, akRight, akBottom];
  end;
end;

procedure TfrmLazRibbonSkinEditor.RefreshIconPreview;
var
  FN: String;
  Bmp: TBitmap;
begin
  if imgSkinIcon = nil then Exit;
  imgSkinIcon.Picture.Clear;
  if FCurrentSkin = nil then Exit;

  Bmp := TBitmap.Create;
  try
    Bmp.SetSize(32, 32);
    Bmp.Canvas.Brush.Color := clBtnFace;
    Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
    if LazDrawSkinDefinitionIcon(Bmp.Canvas, FCurrentSkin, 32,
      Rect(0, 0, Bmp.Width, Bmp.Height)) then
    begin
      imgSkinIcon.Picture.Assign(Bmp);
      Exit;
    end;
  finally
    Bmp.Free;
  end;

  FN := FCurrentSkin.ResolveAssetFileName(FCurrentSkin.IconFileNameForSize(32));
  if (FN <> '') and FileExists(FN) then
    try
      imgSkinIcon.Picture.LoadFromFile(FN);
    except
      imgSkinIcon.Picture.Clear;
    end;
end;

procedure TfrmLazRibbonSkinEditor.RefreshValidationReport;
const
  MaxBaseComparisonDetails = 80;
var
  Lines: TStringList;
  DiffLines: TStringList;
  ErrorCount, WarningCount, InfoCount, OkCount: Integer;
  DifferenceCount, DifferenceDetailCount: Integer;
  P: TLazRibbonSkinPalette;

  procedure AddMessage(const AKind, AText: String);
  begin
    if Lines = nil then Exit;
    if SameText(AKind, 'ERRO') then
      Inc(ErrorCount)
    else if SameText(AKind, 'AVISO') then
      Inc(WarningCount)
    else if SameText(AKind, 'INFO') then
      Inc(InfoCount)
    else if SameText(AKind, 'OK') then
      Inc(OkCount);
    Lines.Add('[' + AKind + '] ' + AText);
  end;

  procedure AddBlank;
  begin
    if Lines <> nil then
      Lines.Add('');
  end;

  procedure CheckRequiredText(const ACaption, AValue: String; ARequired: Boolean);
  begin
    if Trim(AValue) <> '' then
      AddMessage('OK', ACaption + ': preenchido.')
    else if ARequired then
      AddMessage('ERRO', ACaption + ': precisa ser preenchido antes de salvar.')
    else
      AddMessage('INFO', ACaption + ': vazio; recomendado para skins distribuiveis.');
  end;

  procedure CheckAssetFile(const ACaption, AFileName, AEmbeddedData: String;
    ARequired: Boolean);
  var
    FN: String;
  begin
    if Trim(AFileName) = '' then
    begin
      if Trim(AEmbeddedData) <> '' then
        AddMessage('OK', ACaption + ': imagem embutida no XML.')
      else if ARequired then
        AddMessage('AVISO', ACaption + ': nenhum arquivo selecionado nem imagem embutida.')
      else
        AddMessage('INFO', ACaption + ': opcional e nao informado.');
      Exit;
    end;

    FN := FCurrentSkin.ResolveAssetFileName(AFileName);
    if FileExists(FN) then
    begin
      if Trim(AEmbeddedData) <> '' then
        AddMessage('OK', ACaption + ': arquivo encontrado e dados embutidos ja existem.')
      else
        AddMessage('INFO', ACaption + ': arquivo encontrado; sera embutido no XML ao salvar.');
    end
    else if Trim(AEmbeddedData) <> '' then
      AddMessage('AVISO', ACaption + ': arquivo nao encontrado, mas a imagem embutida existente sera usada.')
    else
      AddMessage('ERRO', ACaption + ': arquivo nao encontrado e nao ha imagem embutida.');
  end;

  procedure CheckContrast(const ACaption: String; ABackColor, ATextColor: TColor;
    AMinimumRatio: Double);
  var
    Ratio: Double;
  begin
    Ratio := LazContrastRatio(ABackColor, ATextColor);
    if Ratio >= AMinimumRatio then
      AddMessage('OK', ACaption + ': contraste ' + FormatFloat('0.00', Ratio) + ':1.')
    else
      AddMessage('AVISO', ACaption + ': contraste ' + FormatFloat('0.00', Ratio) +
        ':1, abaixo do minimo recomendado de ' + FormatFloat('0.00', AMinimumRatio) + ':1.');
  end;

  function CompactReportValue(const AValue: String): String;
  begin
    Result := Trim(AValue);
    Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);
    Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
    Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);
    while Pos('  ', Result) > 0 do
      Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
    if Result = '' then
      Result := '(vazio)';
    if Length(Result) > 96 then
      Result := Copy(Result, 1, 93) + '...';
  end;

  function EmbeddedDataState(const AData: String): String;
  begin
    if Trim(AData) <> '' then
      Result := 'embutido'
    else
      Result := 'sem dados';
  end;

  procedure AddBaseDifference(const ACaption, ABaseValue, ACurrentValue: String);
  begin
    Inc(DifferenceCount);
    if DifferenceDetailCount >= MaxBaseComparisonDetails then
      Exit;

    Inc(DifferenceDetailCount);
    DiffLines.Add('  - ' + ACaption + ': base=' +
      CompactReportValue(ABaseValue) + '; atual=' +
      CompactReportValue(ACurrentValue));
  end;

  procedure CompareTextField(const ACaption, ABaseValue, ACurrentValue: String);
  begin
    if ABaseValue <> ACurrentValue then
      AddBaseDifference(ACaption, ABaseValue, ACurrentValue);
  end;

  procedure CompareColorField(const ACaption: String; ABaseValue, ACurrentValue: TColor);
  begin
    if ABaseValue <> ACurrentValue then
      AddBaseDifference(ACaption, ColorToString(ABaseValue), ColorToString(ACurrentValue));
  end;

  procedure CompareAppearanceSection(ABaseSkin: TLazRibbonSkinDefinition;
    ASection: TLazRibbonSkinAppearanceSection);
  var
    BaseObj, CurrentObj: TPersistent;
    PropList: PPropList;
    PropCount, I: Integer;
    BaseProp, CurrentProp: PPropInfo;
    PropName, BaseValue, CurrentValue: String;
  begin
    BaseObj := AppearanceSectionObjectForSkin(ABaseSkin, ASection);
    CurrentObj := AppearanceSectionObjectForSkin(FCurrentSkin, ASection);
    if (BaseObj = nil) or (CurrentObj = nil) then
      Exit;

    PropList := nil;
    PropCount := GetPropList(CurrentObj, PropList);
    try
      for I := 0 to PropCount - 1 do
      begin
        CurrentProp := PropList^[I];
        if CurrentProp = nil then
          Continue;

        PropName := String(CurrentProp^.Name);
        BaseProp := GetPropInfo(BaseObj, PropName);
        if BaseProp = nil then
          Continue;

        BaseValue := FormatAppearancePropertyValue(BaseObj, BaseProp);
        CurrentValue := FormatAppearancePropertyValue(CurrentObj, CurrentProp);
        if BaseValue <> CurrentValue then
          AddBaseDifference('Appearance.' + AppearanceSectionCaption(ASection) +
            '.' + PropName, BaseValue, CurrentValue);
      end;
    finally
      if PropList <> nil then
        FreeMem(PropList);
    end;
  end;

  procedure AddBaseComparison;
  const
    Sections: array[0..4] of TLazRibbonSkinAppearanceSection = (
      asecTab,
      asecMenuButton,
      asecPane,
      asecElement,
      asecPopup
    );
  var
    BaseSkin: TLazRibbonSkinDefinition;
    BasePalette, CurrentPalette: TLazRibbonSkinPalette;
    I: Integer;
  begin
    Lines.Add('Comparacao com base em foco');
    Lines.Add('---------------------------');

    BaseSkin := SelectedBaseSkin;
    if BaseSkin = nil then
    begin
      AddMessage('INFO', 'Nenhuma base em foco para comparar.');
      Exit;
    end;

    Lines.Add('Base: ' + BaseSkin.DisplayName + ' (' + BaseSkin.Name + ')');
    DifferenceCount := 0;
    DifferenceDetailCount := 0;
    DiffLines.Clear;

    CompareTextField('Nome interno', BaseSkin.Name, FCurrentSkin.Name);
    CompareTextField('Nome exibido', BaseSkin.DisplayName, FCurrentSkin.DisplayName);
    CompareTextField('Grupo', BaseSkin.GroupName, FCurrentSkin.GroupName);
    CompareTextField('Autor', BaseSkin.Author, FCurrentSkin.Author);
    CompareTextField('Descricao', BaseSkin.Description, FCurrentSkin.Description);
    CompareTextField('Icone 16x16 arquivo', BaseSkin.Icon16FileName, FCurrentSkin.Icon16FileName);
    CompareTextField('Icone 24x24 arquivo', BaseSkin.Icon24FileName, FCurrentSkin.Icon24FileName);
    CompareTextField('Icone 32x32 arquivo', BaseSkin.Icon32FileName, FCurrentSkin.Icon32FileName);
    CompareTextField('Icone 16x16 dados', EmbeddedDataState(BaseSkin.Icon16Data), EmbeddedDataState(FCurrentSkin.Icon16Data));
    CompareTextField('Icone 24x24 dados', EmbeddedDataState(BaseSkin.Icon24Data), EmbeddedDataState(FCurrentSkin.Icon24Data));
    CompareTextField('Icone 32x32 dados', EmbeddedDataState(BaseSkin.Icon32Data), EmbeddedDataState(FCurrentSkin.Icon32Data));
    CompareTextField('Imagem de preview', BaseSkin.PreviewImageFileName, FCurrentSkin.PreviewImageFileName);

    BasePalette := BaseSkin.Palette;
    CurrentPalette := FCurrentSkin.Palette;
    CompareColorField('Palette.BackColor', BasePalette.BackColor, CurrentPalette.BackColor);
    CompareColorField('Palette.TextColor', BasePalette.TextColor, CurrentPalette.TextColor);
    CompareColorField('Palette.MutedTextColor', BasePalette.MutedTextColor, CurrentPalette.MutedTextColor);
    CompareColorField('Palette.FrameColor', BasePalette.FrameColor, CurrentPalette.FrameColor);
    CompareColorField('Palette.NavigationColor', BasePalette.NavigationColor, CurrentPalette.NavigationColor);
    CompareColorField('Palette.ActiveColor', BasePalette.ActiveColor, CurrentPalette.ActiveColor);
    CompareColorField('Palette.HotColor', BasePalette.HotColor, CurrentPalette.HotColor);
    CompareColorField('Palette.RibbonTopColor', BasePalette.RibbonTopColor, CurrentPalette.RibbonTopColor);
    CompareColorField('Palette.RibbonBottomColor', BasePalette.RibbonBottomColor, CurrentPalette.RibbonBottomColor);
    CompareColorField('Palette.RibbonTabActiveColor', BasePalette.RibbonTabActiveColor, CurrentPalette.RibbonTabActiveColor);
    CompareColorField('Palette.RibbonTabHotColor', BasePalette.RibbonTabHotColor, CurrentPalette.RibbonTabHotColor);
    CompareColorField('Palette.RibbonGroupColor', BasePalette.RibbonGroupColor, CurrentPalette.RibbonGroupColor);
    CompareColorField('Palette.RibbonGroupFrameColor', BasePalette.RibbonGroupFrameColor, CurrentPalette.RibbonGroupFrameColor);
    CompareColorField('Palette.BackstageNavColor', BasePalette.BackstageNavColor, CurrentPalette.BackstageNavColor);
    CompareColorField('Palette.BackstageNavTextColor', BasePalette.BackstageNavTextColor, CurrentPalette.BackstageNavTextColor);
    CompareColorField('Palette.BackstageNavMutedTextColor', BasePalette.BackstageNavMutedTextColor, CurrentPalette.BackstageNavMutedTextColor);
    CompareColorField('Palette.BackstageNavHoverColor', BasePalette.BackstageNavHoverColor, CurrentPalette.BackstageNavHoverColor);
    CompareColorField('Palette.BackstageNavHoverTextColor', BasePalette.BackstageNavHoverTextColor, CurrentPalette.BackstageNavHoverTextColor);
    CompareColorField('Palette.BackstageNavSelectedColor', BasePalette.BackstageNavSelectedColor, CurrentPalette.BackstageNavSelectedColor);
    CompareColorField('Palette.BackstageNavSelectedTextColor', BasePalette.BackstageNavSelectedTextColor, CurrentPalette.BackstageNavSelectedTextColor);
    CompareColorField('Palette.BackstageNavSelectedFrameColor', BasePalette.BackstageNavSelectedFrameColor, CurrentPalette.BackstageNavSelectedFrameColor);

    for I := Low(Sections) to High(Sections) do
      CompareAppearanceSection(BaseSkin, Sections[I]);

    if DifferenceCount = 0 then
      AddMessage('OK', 'Skin atual igual a base em foco nos campos auditados.')
    else
    begin
      AddMessage('INFO', Format('Foram encontradas %d diferencas em relacao a base em foco.',
        [DifferenceCount]));
      Lines.AddStrings(DiffLines);
      if DifferenceCount > DifferenceDetailCount then
        Lines.Add(Format('  ... mais %d diferencas omitidas para manter o relatorio legivel.',
          [DifferenceCount - DifferenceDetailCount]));
    end;
  end;

begin
  if (memValidationReport = nil) or (lblValidationSummary = nil) then
    Exit;

  Lines := TStringList.Create;
  DiffLines := TStringList.Create;
  try
    ErrorCount := 0;
    WarningCount := 0;
    InfoCount := 0;
    OkCount := 0;
    DifferenceCount := 0;
    DifferenceDetailCount := 0;

    memValidationReport.Clear;
    if FCurrentSkin = nil then
    begin
      lblValidationSummary.Caption := 'Nenhuma skin carregada.';
      Exit;
    end;

    Lines.Add('Validacao da skin');
    Lines.Add('=================');
    Lines.Add('Nome exibido: ' + FCurrentSkin.DisplayName);
    Lines.Add('Nome interno: ' + FCurrentSkin.Name);
    if Trim(FCurrentSkin.FileName) <> '' then
      Lines.Add('Arquivo: ' + FCurrentSkin.FileName)
    else
      Lines.Add('Arquivo: ainda nao salvo.');
    AddBlank;

    Lines.Add('Identidade');
    Lines.Add('----------');
    CheckRequiredText('Nome interno', FCurrentSkin.Name, True);
    if (Trim(FCurrentSkin.Name) <> '') and
       (not IsValidSkinIdentifier(FCurrentSkin.Name)) then
      AddMessage('ERRO', 'Nome interno: use letras, numeros, sublinhado ou hifen, comecando por letra ou sublinhado.');
    CheckRequiredText('Nome exibido', FCurrentSkin.DisplayName, True);
    CheckRequiredText('Grupo', FCurrentSkin.GroupName, False);
    CheckRequiredText('Autor', FCurrentSkin.Author, False);
    CheckRequiredText('Descricao', FCurrentSkin.Description, False);
    AddBlank;

    Lines.Add('Imagens da skin');
    Lines.Add('---------------');
    CheckAssetFile('Icone 16x16', FCurrentSkin.Icon16FileName, FCurrentSkin.Icon16Data, True);
    CheckAssetFile('Icone 24x24', FCurrentSkin.Icon24FileName, FCurrentSkin.Icon24Data, True);
    CheckAssetFile('Icone 32x32', FCurrentSkin.Icon32FileName, FCurrentSkin.Icon32Data, True);
    CheckAssetFile('Imagem de preview', FCurrentSkin.PreviewImageFileName, '', False);
    AddBlank;

    AddBaseComparison;
    AddBlank;

    Lines.Add('Appearance');
    Lines.Add('----------');
    if FFullAppearanceEdited then
      AddMessage('INFO', 'Appearance detalhado foi editado e sera preservado. Use "Regerar Appearance pela paleta" somente se quiser substituir esses ajustes.')
    else
      AddMessage('OK', 'Appearance esta sincronizado pelo fluxo de paleta simples.');
    AddMessage('OK', 'Inspetor tecnico cobre Tab, MenuButton, Pane, Element e Popup.');
    AddBlank;

    Lines.Add('Contraste');
    Lines.Add('----------');
    P := FCurrentSkin.Palette;
    CheckContrast('Texto sobre fundo geral', P.BackColor, P.TextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('Texto secundario sobre fundo geral', P.BackColor, P.MutedTextColor, 3.0);
    CheckContrast('Texto sobre Ribbon topo', P.RibbonTopColor, P.TextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('Texto sobre Ribbon base', P.RibbonBottomColor, P.TextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('Texto sobre grupo/pane', P.RibbonGroupColor, P.TextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('Texto sobre hover', P.HotColor, P.TextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('Texto sobre ativo', P.ActiveColor, P.TextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('BackStage texto normal', P.BackstageNavColor, P.BackstageNavTextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('BackStage texto secundario', P.BackstageNavColor, P.BackstageNavMutedTextColor, 3.0);
    CheckContrast('BackStage hover', P.BackstageNavHoverColor, P.BackstageNavHoverTextColor, LAZRIBBON_MIN_TEXT_CONTRAST);
    CheckContrast('BackStage selecionado', P.BackstageNavSelectedColor, P.BackstageNavSelectedTextColor, LAZRIBBON_MIN_TEXT_CONTRAST);

    memValidationReport.Lines.Assign(Lines);
    lblValidationSummary.Caption := Format('Erros: %d   Avisos: %d   Infos: %d   OK: %d',
      [ErrorCount, WarningCount, InfoCount, OkCount]);
    if ErrorCount > 0 then
      lblValidationSummary.Font.Color := clRed
    else if WarningCount > 0 then
      lblValidationSummary.Font.Color := clMaroon
    else
      lblValidationSummary.Font.Color := clGreen;
  finally
    DiffLines.Free;
    Lines.Free;
  end;
end;

procedure TfrmLazRibbonSkinEditor.IconFileButtonClick(Sender: TObject);
var
  TargetEdit: TEdit;
  OldFilter: String;
begin
  TargetEdit := nil;
  if Sender = btnIcon16 then TargetEdit := edtIcon16;
  if Sender = btnIcon24 then TargetEdit := edtIcon24;
  if Sender = btnIcon32 then TargetEdit := edtIcon32;
  if Sender = btnPreviewImage then TargetEdit := edtPreviewImage;
  if TargetEdit = nil then Exit;

  OldFilter := OpenDialog.Filter;
  try
    OpenDialog.Filter := 'Imagens (*.png;*.bmp;*.jpg;*.jpeg)|*.png;*.bmp;*.jpg;*.jpeg|Todos os arquivos (*.*)|*.*';
    if OpenDialog.Execute then
    begin
      TargetEdit.Text := OpenDialog.FileName;
      UpdateSkinFromEditor;
      RefreshIconPreview;
    end;
  finally
    OpenDialog.Filter := OldFilter;
  end;
end;

procedure TfrmLazRibbonSkinEditor.SetupPreviewToolbar;
begin
  { The editor no longer uses the normal Ribbon tabs as a command surface.
    File/editor commands live in the Application Button BackStage.  The visible
    Ribbon remains a live visual sample of the skin being edited. }
  PreviewToolbar.ApplicationButton.Caption := 'Arquivo';
  PreviewToolbar.ApplicationButton.Visible := True;
  PreviewToolbar.ApplicationButton.Mode := abmBackstage;
  PreviewToolbar.ApplicationButton.BackstageView := EditorBackstage;
  PreviewToolbar.BackstageView := EditorBackstage;
  PreviewToolbar.ShowMenuButton := True;
  PreviewToolbar.MenuButtonCaption := 'Arquivo';

  if Assigned(EditorTabSkin) then EditorTabSkin.Caption := 'Página inicial';
  if Assigned(EditorTabPreview) then EditorTabPreview.Caption := 'Exibir';
  if Assigned(EditorPaneBases) then EditorPaneBases.Caption := 'Bases';
  if Assigned(PreviewBaseGallery) then
  begin
    PreviewBaseGallery.Caption := 'Bases';
    PreviewBaseGallery.Width := 220;
    PreviewBaseGallery.Columns := 4;
    PreviewBaseGallery.MaxVisibleItems := 8;
  end;
  if Assigned(EditorPaneFile) then EditorPaneFile.Caption := 'Área de transferência';
  if Assigned(EditorPaneAppearance) then
  begin
    EditorPaneAppearance.Caption := 'Estilos';
    EditorPaneAppearance.ShowDialogLauncher := True;
    EditorPaneAppearance.OnDialogLauncherClick := @EditorPaneAppearanceDialogLauncherClick;
  end;
  if Assigned(EditorPaneExport) then EditorPaneExport.Caption := 'Inserir';
  if Assigned(PreviewPaneFile) then PreviewPaneFile.Caption := 'Documento';
  if Assigned(PreviewPaneView) then PreviewPaneView.Caption := 'Janela';
  if Assigned(EditorPaneSampleEdit) then EditorPaneSampleEdit.Caption := 'Exemplos';
  if Assigned(EditorPaneSampleOptions) then EditorPaneSampleOptions.Caption := 'Opções';
  if Assigned(EditorLargeNewFromBase) then EditorLargeNewFromBase.Caption := 'Colar';
  if Assigned(EditorSmallOpen) then EditorSmallOpen.Caption := 'Copiar';
  if Assigned(EditorSmallSaveAs) then EditorSmallSaveAs.Caption := 'Recortar';
  if Assigned(EditorLargeExportBuiltIns) then EditorLargeExportBuiltIns.Caption := 'Tabela';
  if Assigned(EditorLargeFullAppearance) then EditorLargeFullAppearance.Caption := 'Temas';
  if Assigned(EditorSmallApplyPaletteAppearance) then EditorSmallApplyPaletteAppearance.Caption := 'Realce';
  if Assigned(PreviewLargePaste) then PreviewLargePaste.Caption := 'Colar';
  if Assigned(PreviewSmallCopy) then PreviewSmallCopy.Caption := 'Copiar';
  if Assigned(PreviewSmallCut) then PreviewSmallCut.Caption := 'Recortar';
  if Assigned(PreviewLargeNew) then PreviewLargeNew.Caption := 'Novo';
  if Assigned(PreviewSmallOpen) then PreviewSmallOpen.Caption := 'Abrir';
  if Assigned(PreviewSmallSave) then PreviewSmallSave.Caption := 'Salvar';
  if Assigned(PreviewLargeZoom) then PreviewLargeZoom.Caption := 'Zoom';
  if Assigned(PreviewCheckAuto) then PreviewCheckAuto.Caption := 'Opção ativa';

  if Assigned(EditorLargeNewFromBase) then
    EditorLargeNewFromBase.OnClick := nil;
  if Assigned(EditorSmallOpen) then
    EditorSmallOpen.OnClick := nil;
  if Assigned(EditorSmallSaveAs) then
    EditorSmallSaveAs.OnClick := nil;
  if Assigned(EditorLargeExportBuiltIns) then
    EditorLargeExportBuiltIns.OnClick := nil;
  if Assigned(EditorLargeFullAppearance) then
    EditorLargeFullAppearance.OnClick := nil;
  if Assigned(EditorSmallApplyPaletteAppearance) then
    EditorSmallApplyPaletteAppearance.OnClick := nil;

  if Assigned(EditorBackstage) then
  begin
    { Keep the Application/Menu button visible at runtime. The BackStage
      command surface is opened from this button; hiding ShowMenuButton after
      streaming makes the design-time 'Arquivo' entry disappear when the
      editor runs. }
    PreviewToolbar.ShowMenuButton := True;
    { EditorBackstage is streamed with safe design-time bounds.  At runtime it
      is aligned to the client area only after all children/pages are loaded.
      This avoids Lazarus designer errors such as negative page width while
      preserving the BackStage behavior when opened from the Arquivo button. }
    EditorBackstage.Align := alClient;
    EditorBackstage.NavigationWidth := 220;
    EditorBackstage.BorderSpacing.Left := 8;
    EditorBackstage.BorderSpacing.Right := 8;
    EditorBackstage.BorderSpacing.Top := 4;
    EditorBackstage.BorderSpacing.Bottom := 8;
    EditorBackstage.LinkedToolbar := PreviewToolbar;
    EditorBackstage.SkinManager := PreviewSkinManager;
    EditorBackstage.AppearanceSource := asSkinManager;
  end;

  if PreviewToolbar.Tabs.Count > 0 then
    PreviewToolbar.TabIndex := 0;
end;

procedure TfrmLazRibbonSkinEditor.SyncLivePreviewHeight;
var
  RequiredHeight: Integer;
begin
  if (pnlLivePreview = nil) or (PreviewToolbar = nil) then
    Exit;

  RequiredHeight := PreviewToolbar.Height;
  if RequiredHeight < SkinEditorLivePreviewMinHeight then
    RequiredHeight := SkinEditorLivePreviewMinHeight;

  if pnlLivePreview.Height <> RequiredHeight then
    pnlLivePreview.Height := RequiredHeight;
end;

procedure TfrmLazRibbonSkinEditor.ApplyCurrentSkinToPreview;
var
  OldAutoRefresh: Boolean;
begin
  if (FCurrentSkin = nil) or (PreviewSkinManager = nil) or (PreviewToolbar = nil) then
    Exit;

  { Applying a skin can touch many appearance properties. Without batching,
    every property assignment can repaint the whole editor window, making
    Skin Base changes unnecessarily slow. }
  OldAutoRefresh := PreviewSkinManager.AutoRefreshControls;
  PreviewSkinManager.AutoRefreshControls := False;
  PreviewSkinManager.BeginUpdate;
  PreviewToolbar.BeginUpdate;
  try
    PreviewSkinManager.AssignPalette(FCurrentSkin.Palette);
    { AssignPalette updates grouped colors but also derives a generic Appearance.
      Restore the skin's stored full Appearance afterwards so advanced edits
      loaded from .skin/.lazskin or made through the complete editor are visible. }
    PreviewSkinManager.Appearance.Assign(FCurrentSkin.Appearance);
    PreviewToolbar.SkinManager := PreviewSkinManager;
    PreviewToolbar.AppearanceSource := asSkinManager;
  finally
    PreviewToolbar.EndUpdate;
    PreviewSkinManager.EndUpdate;
    PreviewSkinManager.AutoRefreshControls := OldAutoRefresh;
  end;

  PreviewToolbar.ForceRepaint;
  SyncLivePreviewHeight;
  PreviewToolbar.Invalidate;
end;

procedure TfrmLazRibbonSkinEditor.RefreshBaseCombo;
var
  I: Integer;
  Skin: TLazRibbonSkinDefinition;
begin
  cbBaseSkin.Items.Clear;
  for I := 0 to FManager.SkinCount - 1 do
  begin
    Skin := FManager.SkinByIndex(I);
    if Skin <> nil then
      cbBaseSkin.Items.AddObject(Skin.DisplayName, Skin);
  end;
  if cbBaseSkin.Items.Count > 0 then
    cbBaseSkin.ItemIndex := 0;
end;

procedure TfrmLazRibbonSkinEditor.RefreshSkinList;
var
  I: Integer;
  Skin: TLazRibbonSkinDefinition;
begin
  lstSkins.Items.Clear;
  for I := 0 to FManager.SkinCount - 1 do
  begin
    Skin := FManager.SkinByIndex(I);
    if Skin <> nil then
      lstSkins.Items.AddObject(Skin.DisplayName, Skin);
  end;
  if lstSkins.Items.Count > 0 then
    lstSkins.ItemIndex := 0;
end;

procedure TfrmLazRibbonSkinEditor.LoadSkinToEditor(ASkin: TLazRibbonSkinDefinition);
begin
  if ASkin = nil then Exit;
  FCurrentSkin.Assign(ASkin);
  UpdateEditorFromSkin;
end;

procedure TfrmLazRibbonSkinEditor.UpdateEditorFromSkin;
begin
  FUpdating := True;
  try
    edtName.Text := FCurrentSkin.Name;
    edtDisplayName.Text := FCurrentSkin.DisplayName;
    if edtGroupName <> nil then edtGroupName.Text := FCurrentSkin.GroupName;
    edtAuthor.Text := FCurrentSkin.Author;
    memDescription.Text := FCurrentSkin.Description;
    if edtIcon16 <> nil then edtIcon16.Text := FCurrentSkin.Icon16FileName;
    if edtIcon24 <> nil then edtIcon24.Text := FCurrentSkin.Icon24FileName;
    if edtIcon32 <> nil then edtIcon32.Text := FCurrentSkin.Icon32FileName;
    if edtPreviewImage <> nil then edtPreviewImage.Text := FCurrentSkin.PreviewImageFileName;
    UpdateColorPanels;
    RefreshIconPreview;
    UpdateAppearanceModeLabel;
    RefreshAppearanceInspector;
    ApplyCurrentSkinToPreview;
    RefreshValidationReport;
  finally
    FUpdating := False;
  end;
end;

procedure TfrmLazRibbonSkinEditor.UpdateSkinFromEditor;
begin
  if FUpdating or (FCurrentSkin = nil) then Exit;
  FCurrentSkin.Name := Trim(edtName.Text);
  FCurrentSkin.DisplayName := Trim(edtDisplayName.Text);
  if edtGroupName <> nil then
    FCurrentSkin.GroupName := Trim(edtGroupName.Text);
  FCurrentSkin.Author := Trim(edtAuthor.Text);
  FCurrentSkin.Description := memDescription.Text;
  FCurrentSkin.Notes := memDescription.Text;
  if edtIcon16 <> nil then FCurrentSkin.Icon16FileName := Trim(edtIcon16.Text);
  if edtIcon24 <> nil then FCurrentSkin.Icon24FileName := Trim(edtIcon24.Text);
  if edtIcon32 <> nil then FCurrentSkin.Icon32FileName := Trim(edtIcon32.Text);
  if edtPreviewImage <> nil then FCurrentSkin.PreviewImageFileName := Trim(edtPreviewImage.Text);
  FCurrentSkin.Source := sssCustom;
  ApplyCurrentSkinToPreview;
end;

procedure TfrmLazRibbonSkinEditor.UpdateColorPanels;
var
  F: TLazRibbonEditorPaletteField;
begin
  for F := Low(TLazRibbonEditorPaletteField) to High(TLazRibbonEditorPaletteField) do
  begin
    if FColorPanels[F] <> nil then
    begin
      FColorPanels[F].Color := GetPaletteColor(F);
      FColorPanels[F].Caption := ColorToString(GetPaletteColor(F));
      FColorPanels[F].Font.Color := LazEnsureContrastTextColor(FColorPanels[F].Color, clBlack);
    end;
  end;
end;

procedure TfrmLazRibbonSkinEditor.UpdateAppearanceModeLabel;
begin
  if Assigned(lblAppearanceMode) then
  begin
    if FFullAppearanceEdited then
      lblAppearanceMode.Caption := 'Modo atual: ajustes visuais detalhados preservados. Alteracoes nas cores simples atualizam a paleta salva, mas nao recalculam automaticamente o Appearance detalhado.'
    else
      lblAppearanceMode.Caption := 'Modo atual: paleta simples controla o Appearance. Este é o modo recomendado para criar skins de forma rápida e previsível.';
  end;

  if Assigned(lblHintSimple) then
  begin
    if FFullAppearanceEdited then
      lblHintSimple.Caption := 'Clique em uma amostra de cor. A paleta sera atualizada, mas os ajustes visuais detalhados do Appearance serao preservados ate voce usar "Sincronizar paleta -> Appearance".'
    else
      lblHintSimple.Caption := 'Clique em uma amostra de cor. O editor atualiza a paleta e aplica o resultado imediatamente no LazRibbon real acima.';
  end;
end;

procedure TfrmLazRibbonSkinEditor.SetPaletteColor(AField: TLazRibbonEditorPaletteField; AColor: TColor);
var
  P: TLazRibbonSkinPalette;
begin
  P := FCurrentSkin.Palette;
  case AField of
    pfBackColor: P.BackColor := AColor;
    pfTextColor: P.TextColor := AColor;
    pfMutedTextColor: P.MutedTextColor := AColor;
    pfFrameColor: P.FrameColor := AColor;
    pfNavigationColor: P.NavigationColor := AColor;
    pfActiveColor: P.ActiveColor := AColor;
    pfHotColor: P.HotColor := AColor;
    pfRibbonTopColor: P.RibbonTopColor := AColor;
    pfRibbonBottomColor: P.RibbonBottomColor := AColor;
    pfRibbonTabActiveColor: P.RibbonTabActiveColor := AColor;
    pfRibbonTabHotColor: P.RibbonTabHotColor := AColor;
    pfRibbonGroupColor: P.RibbonGroupColor := AColor;
    pfRibbonGroupFrameColor: P.RibbonGroupFrameColor := AColor;
    pfBackstageNavColor: P.BackstageNavColor := AColor;
    pfBackstageNavTextColor: P.BackstageNavTextColor := AColor;
    pfBackstageNavMutedTextColor: P.BackstageNavMutedTextColor := AColor;
    pfBackstageNavHoverColor: P.BackstageNavHoverColor := AColor;
    pfBackstageNavHoverTextColor: P.BackstageNavHoverTextColor := AColor;
    pfBackstageNavSelectedColor: P.BackstageNavSelectedColor := AColor;
    pfBackstageNavSelectedTextColor: P.BackstageNavSelectedTextColor := AColor;
    pfBackstageNavSelectedFrameColor: P.BackstageNavSelectedFrameColor := AColor;
  end;
  AssignPaletteRespectingAppearanceGuard(P);
end;

procedure TfrmLazRibbonSkinEditor.AssignPaletteRespectingAppearanceGuard(
  const APalette: TLazRibbonSkinPalette);
var
  SavedAppearance: TLazRibbonToolbarAppearance;
begin
  if FCurrentSkin = nil then
    Exit;

  { Keep the editor compatible with installations where the runtime unit was
    not rebuilt yet.  The old direct call to AssignPaletteOnly caused a compile
    error when uSkinEditorMain.pas and LazRibbon_SkinDefinition.pas came from
    different 1.1.x snapshots.  This implementation uses only the stable
    AssignPalette/Appearance API and restores the technical Appearance when
    the user has already edited it manually. }
  if FFullAppearanceEdited then
  begin
    SavedAppearance := TLazRibbonToolbarAppearance.Create(nil);
    try
      SavedAppearance.Assign(FCurrentSkin.Appearance);
      FCurrentSkin.AssignPalette(APalette);
      FCurrentSkin.Appearance.Assign(SavedAppearance);
    finally
      SavedAppearance.Free;
    end;
  end
  else
    FCurrentSkin.AssignPalette(APalette);
end;

function TfrmLazRibbonSkinEditor.GetPaletteColor(AField: TLazRibbonEditorPaletteField): TColor;
var
  P: TLazRibbonSkinPalette;
begin
  P := FCurrentSkin.Palette;
  case AField of
    pfTextColor: Result := P.TextColor;
    pfMutedTextColor: Result := P.MutedTextColor;
    pfFrameColor: Result := P.FrameColor;
    pfNavigationColor: Result := P.NavigationColor;
    pfActiveColor: Result := P.ActiveColor;
    pfHotColor: Result := P.HotColor;
    pfRibbonTopColor: Result := P.RibbonTopColor;
    pfRibbonBottomColor: Result := P.RibbonBottomColor;
    pfRibbonTabActiveColor: Result := P.RibbonTabActiveColor;
    pfRibbonTabHotColor: Result := P.RibbonTabHotColor;
    pfRibbonGroupColor: Result := P.RibbonGroupColor;
    pfRibbonGroupFrameColor: Result := P.RibbonGroupFrameColor;
    pfBackstageNavColor: Result := P.BackstageNavColor;
    pfBackstageNavTextColor: Result := P.BackstageNavTextColor;
    pfBackstageNavMutedTextColor: Result := P.BackstageNavMutedTextColor;
    pfBackstageNavHoverColor: Result := P.BackstageNavHoverColor;
    pfBackstageNavHoverTextColor: Result := P.BackstageNavHoverTextColor;
    pfBackstageNavSelectedColor: Result := P.BackstageNavSelectedColor;
    pfBackstageNavSelectedTextColor: Result := P.BackstageNavSelectedTextColor;
    pfBackstageNavSelectedFrameColor: Result := P.BackstageNavSelectedFrameColor;
  else
    Result := P.BackColor;
  end;
end;

function TfrmLazRibbonSkinEditor.FieldFromSender(Sender: TObject; out AField: TLazRibbonEditorPaletteField): Boolean;
var
  F: TLazRibbonEditorPaletteField;
begin
  Result := False;
  for F := Low(TLazRibbonEditorPaletteField) to High(TLazRibbonEditorPaletteField) do
    if Sender = FColorPanels[F] then
    begin
      AField := F;
      Exit(True);
    end;
end;

function TfrmLazRibbonSkinEditor.SelectedBaseSkin: TLazRibbonSkinDefinition;
begin
  Result := nil;
  if Assigned(PreviewBaseGallery) and (Trim(PreviewBaseGallery.SelectedSkinName) <> '') then
    Result := FManager.FindSkin(PreviewBaseGallery.SelectedSkinName);

  if (Result = nil) and (cbBaseSkin.ItemIndex >= 0) then
    Result := TLazRibbonSkinDefinition(cbBaseSkin.Items.Objects[cbBaseSkin.ItemIndex]);
end;

function TfrmLazRibbonSkinEditor.SafeSkinIdentifier(const AValue: String): String;
var
  I: Integer;
  Ch: Char;
  S: String;
begin
  Result := '';
  S := Trim(AValue);
  for I := 1 to Length(S) do
  begin
    Ch := S[I];
    if Ch in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-'] then
      Result := Result + Ch
    else if Ch in [' ', '.', '/', '\', ':', ';', ',', #9, #10, #13] then
      Result := Result + '_';
  end;

  while Pos('__', Result) > 0 do
    Result := StringReplace(Result, '__', '_', [rfReplaceAll]);

  while (Length(Result) > 0) and (Result[1] = '_') do
    Delete(Result, 1, 1);
  while (Length(Result) > 0) and (Result[Length(Result)] = '_') do
    Delete(Result, Length(Result), 1);

  if Result = '' then
    Result := 'Skin';

  if not (Result[1] in ['A'..'Z', 'a'..'z', '_']) then
    Result := 'Skin_' + Result;
end;

function TfrmLazRibbonSkinEditor.UniqueCustomSkinIdentifier(
  ABaseSkin: TLazRibbonSkinDefinition): String;
var
  BaseName: String;
  Suffix: Integer;
begin
  if ABaseSkin <> nil then
  begin
    BaseName := SafeSkinIdentifier(ABaseSkin.Name);
    if BaseName = '' then
      BaseName := SafeSkinIdentifier(ABaseSkin.DisplayName);
  end
  else
    BaseName := 'Skin';

  Result := BaseName + '_Custom';
  Suffix := 2;
  while (FManager <> nil) and (FManager.FindSkin(Result) <> nil) do
  begin
    Result := BaseName + '_Custom' + IntToStr(Suffix);
    Inc(Suffix);
  end;
end;

function TfrmLazRibbonSkinEditor.CustomDisplayNameForBase(
  ABaseSkin: TLazRibbonSkinDefinition): String;
begin
  if (ABaseSkin <> nil) and (Trim(ABaseSkin.DisplayName) <> '') then
    Result := ABaseSkin.DisplayName + ' Custom'
  else
    Result := 'Custom Skin';
end;

function TfrmLazRibbonSkinEditor.IsValidSkinIdentifier(const AValue: String): Boolean;
var
  I: Integer;
  S: String;
begin
  S := Trim(AValue);
  Result := False;
  if S = '' then
    Exit;
  if not (S[1] in ['A'..'Z', 'a'..'z', '_']) then
    Exit;
  for I := 1 to Length(S) do
    if not (S[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-']) then
      Exit;
  Result := True;
end;

function TfrmLazRibbonSkinEditor.ValidateCurrentSkinForSave: Boolean;
var
  SuggestedName: String;
begin
  Result := False;
  if FCurrentSkin = nil then
    Exit;

  UpdateSkinFromEditor;

  if Trim(FCurrentSkin.Name) = '' then
  begin
    SuggestedName := SafeSkinIdentifier(FCurrentSkin.DisplayName);
    if MessageDlg('Validar skin',
      'O nome interno da skin está vazio.' + LineEnding + LineEnding +
      'Usar "' + SuggestedName + '" como nome interno?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      edtName.Text := SuggestedName;
      UpdateSkinFromEditor;
    end
    else
    begin
      pcMain.ActivePage := tabMetadata;
      if edtName.CanFocus then edtName.SetFocus;
      Exit;
    end;
  end;

  if not IsValidSkinIdentifier(FCurrentSkin.Name) then
  begin
    SuggestedName := SafeSkinIdentifier(FCurrentSkin.Name);
    if MessageDlg('Validar skin',
      'O nome interno "' + FCurrentSkin.Name + '" não é seguro para identificação técnica.' + LineEnding + LineEnding +
      'Use apenas letras, números, sublinhado (_) ou hífen (-), começando por letra ou sublinhado.' + LineEnding + LineEnding +
      'Substituir por "' + SuggestedName + '"?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      edtName.Text := SuggestedName;
      UpdateSkinFromEditor;
    end
    else
    begin
      pcMain.ActivePage := tabMetadata;
      if edtName.CanFocus then edtName.SetFocus;
      Exit;
    end;
  end;

  if Trim(FCurrentSkin.DisplayName) = '' then
  begin
    if MessageDlg('Validar skin',
      'O nome exibido da skin está vazio.' + LineEnding + LineEnding +
      'Usar o nome interno "' + FCurrentSkin.Name + '" como nome exibido?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      edtDisplayName.Text := FCurrentSkin.Name;
      UpdateSkinFromEditor;
    end
    else
    begin
      pcMain.ActivePage := tabMetadata;
      if edtDisplayName.CanFocus then edtDisplayName.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

procedure TfrmLazRibbonSkinEditor.BaseGallerySkinSelected(Sender: TObject);
var
  Skin: TLazRibbonSkinDefinition;
begin
  Skin := SelectedBaseSkin;
  if Skin = nil then Exit;

  if cbBaseSkin.Items.Count > 0 then
    cbBaseSkin.ItemIndex := cbBaseSkin.Items.IndexOfObject(Skin);

  FFullAppearanceEdited := False;
  LoadSkinToEditor(Skin);
  lblBaseHint.Caption := 'Visualizando base: ' + Skin.DisplayName + '. Para editar, use Arquivo > Nova skin pela base.';
  lblStatus.Caption := 'Base em foco: ' + Skin.DisplayName + '. Use Arquivo > Nova skin pela base para iniciar uma skin editável.';
end;

procedure TfrmLazRibbonSkinEditor.lstSkinsClick(Sender: TObject);
var
  Skin: TLazRibbonSkinDefinition;
begin
  if lstSkins.ItemIndex < 0 then Exit;
  Skin := TLazRibbonSkinDefinition(lstSkins.Items.Objects[lstSkins.ItemIndex]);
  if Skin = nil then Exit;

  if Assigned(PreviewBaseGallery) then
    PreviewBaseGallery.SelectedSkinName := Skin.Name
  else
    BaseGallerySkinSelected(Sender);
end;

procedure TfrmLazRibbonSkinEditor.MetadataChanged(Sender: TObject);
begin
  UpdateSkinFromEditor;
  if (Sender = edtIcon16) or (Sender = edtIcon24) or (Sender = edtIcon32) or
     (Sender = edtPreviewImage) then
    RefreshIconPreview;
  RefreshValidationReport;
end;

procedure TfrmLazRibbonSkinEditor.ColorPanelClick(Sender: TObject);
var
  F: TLazRibbonEditorPaletteField;
begin
  if not FieldFromSender(Sender, F) then Exit;
  ColorDialog.Color := GetPaletteColor(F);
  if ColorDialog.Execute then
  begin
    SetPaletteColor(F, ColorDialog.Color);
    UpdateColorPanels;
    RefreshAppearanceInspector;
    ApplyCurrentSkinToPreview;
    UpdateAppearanceModeLabel;
    RefreshValidationReport;
    if FFullAppearanceEdited then
      lblStatus.Caption := 'Cor atualizada na paleta. Os ajustes visuais detalhados do Appearance foram preservados.'
    else
      lblStatus.Caption := 'Cor atualizada. O Ribbon acima mostra o resultado imediatamente.';
  end;
end;

procedure TfrmLazRibbonSkinEditor.btnApplyPaletteToAppearanceClick(Sender: TObject);
begin
  if FCurrentSkin = nil then
    Exit;
  FCurrentSkin.ApplyPaletteToAppearance;
  FCurrentSkin.Source := sssCustom;
  FFullAppearanceEdited := False;
  RefreshAppearanceInspector;
  ApplyCurrentSkinToPreview;
  UpdateAppearanceModeLabel;
  RefreshValidationReport;
  lblStatus.Caption := 'Paleta sincronizada com o Appearance. Ajustes visuais detalhados anteriores foram substituidos pela paleta.';
end;

procedure TfrmLazRibbonSkinEditor.OpenFullAppearanceEditor(AInitialPageIndex: Integer);
var
  AppearanceEditor: TfrmLazRibbonAppearanceEditWindow;
begin
  if FCurrentSkin = nil then
    Exit;

  UpdateSkinFromEditor;

  AppearanceEditor := TfrmLazRibbonAppearanceEditWindow.Create(Self);
  try
    AppearanceEditor.Appearance.Assign(FCurrentSkin.Appearance);
    if (AInitialPageIndex >= 0) and
       (AInitialPageIndex < AppearanceEditor.PageControl.PageCount) then
      AppearanceEditor.PageControl.PageIndex := AInitialPageIndex;
    if AppearanceEditor.ShowModal = mrOK then
    begin
      FCurrentSkin.Appearance.Assign(AppearanceEditor.Appearance);
      FCurrentSkin.Source := sssCustom;
      FFullAppearanceEdited := True;
      RefreshAppearanceInspector;
      ApplyCurrentSkinToPreview;
      UpdateAppearanceModeLabel;
      RefreshValidationReport;
      lblStatus.Caption := 'Appearance atualizado pelo editor visual. Use sincronizacao explicita para substituir esses ajustes pela paleta.';
    end;
  finally
    AppearanceEditor.Free;
  end;
end;

procedure TfrmLazRibbonSkinEditor.btnEditFullAppearanceClick(Sender: TObject);
begin
  OpenFullAppearanceEditor(-1);
end;

procedure TfrmLazRibbonSkinEditor.EditorPaneAppearanceDialogLauncherClick(Sender: TObject);
begin
  OpenFullAppearanceEditor(AppearanceSectionEditorPageIndex(asecPane));
end;

procedure TfrmLazRibbonSkinEditor.btnNewFromBaseClick(Sender: TObject);
var
  Skin: TLazRibbonSkinDefinition;
  BaseDisplayName: String;
begin
  Skin := SelectedBaseSkin;
  if Skin = nil then Exit;
  BaseDisplayName := Skin.DisplayName;
  if Trim(BaseDisplayName) = '' then
    BaseDisplayName := Skin.Name;
  FCurrentSkin.Assign(Skin);
  FCurrentSkin.Source := sssCustom;
  FCurrentSkin.Name := UniqueCustomSkinIdentifier(Skin);
  FCurrentSkin.DisplayName := CustomDisplayNameForBase(Skin);
  if Trim(Skin.GroupName) <> '' then
    FCurrentSkin.GroupName := Skin.GroupName
  else
    FCurrentSkin.GroupName := 'Custom Skins';
  FCurrentSkin.Author := '';
  FCurrentSkin.Description := 'Based on ' + BaseDisplayName + '.';
  FCurrentSkin.Notes := FCurrentSkin.Description;
  FFullAppearanceEdited := True;
  UpdateEditorFromSkin;
  lblBaseHint.Caption := 'Editando nova skin baseada em: ' + BaseDisplayName + '.';
  RefreshValidationReport;
  lblStatus.Caption := 'Nova skin criada como copia completa de ' + BaseDisplayName + '. Palette e Appearance foram preservados.';
end;

procedure TfrmLazRibbonSkinEditor.btnOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    FCurrentSkin.LoadFromFile(OpenDialog.FileName);
    FFullAppearanceEdited := True;
    UpdateEditorFromSkin;
    lblBaseHint.Caption := 'Editando arquivo: ' + ExtractFileName(OpenDialog.FileName);
    RefreshValidationReport;
    lblStatus.Caption := 'Skin carregada: ' + OpenDialog.FileName;
  end;
end;

procedure TfrmLazRibbonSkinEditor.btnRefreshValidationClick(Sender: TObject);
begin
  UpdateSkinFromEditor;
  RefreshValidationReport;
  lblStatus.Caption := 'Validacao da skin atualizada.';
end;

procedure TfrmLazRibbonSkinEditor.btnSaveAsClick(Sender: TObject);
begin
  UpdateSkinFromEditor;
  if SaveDialog.Execute then
  begin
    if Trim(FCurrentSkin.Name) = '' then
      edtName.Text := SafeSkinIdentifier(ChangeFileExt(ExtractFileName(SaveDialog.FileName), ''));
    if Trim(FCurrentSkin.DisplayName) = '' then
      edtDisplayName.Text := Trim(FCurrentSkin.Name);

    if not ValidateCurrentSkinForSave then
    begin
      lblStatus.Caption := 'Salvamento cancelado: a identificação da skin precisa ser corrigida.';
      Exit;
    end;

    FCurrentSkin.Source := sssExternal;
    FCurrentSkin.SaveToFile(SaveDialog.FileName);
    RefreshValidationReport;
    lblStatus.Caption := 'Skin salva: ' + SaveDialog.FileName;
  end;
end;

procedure TfrmLazRibbonSkinEditor.btnExportBuiltInsClick(Sender: TObject);
begin
  if SelectDirDialog.Execute then
  begin
    FManager.ExportBuiltInSkinsToFolder(SelectDirDialog.FileName);
    lblStatus.Caption := 'Skins internos exportados para: ' + SelectDirDialog.FileName;
  end;
end;

end.
