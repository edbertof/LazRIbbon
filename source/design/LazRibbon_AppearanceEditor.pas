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

unit LazRibbon_AppearanceEditor;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LCLVersion,
  SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, Spin, Menus,
  LazRibbon_GraphTools, LazRibbon_GUITools, LazRibbon_XMLParser, LazRibbon_Core, LazRibbon_Buttons, LazRibbon_Groups, LazRibbon_Tabs,
  LazRibbon_Appearance, LazRibbon_Checkboxes, LazRibbon_Popup, Types;

type

  { TfrmLazRibbonAppearanceEditWindow }

  TfrmLazRibbonAppearanceEditWindow = class(TForm)
    bItemActiveInnerDarkColor1: TSpeedButton;
    bItemActiveKnobColor: TSpeedButton;
    bItemActiveTrackColor: TSpeedButton;
    bItemIdleKnobColor: TSpeedButton;
    bItemIdleTrackColor: TSpeedButton;
    bItemIdleTrackColor1: TSpeedButton;
    bPopupCheckedGradientFromColor: TSpeedButton;
    bPopupCheckedGradientToColor: TSpeedButton;
    bPopupGutterFrameColor: TSpeedButton;
    bPopupCheckedFrameColor: TSpeedButton;
    bPopupGutterGradientFromColor: TSpeedButton;
    bPopupGutterGradientToColor: TSpeedButton;
    bPopupHotTrackGradientFromColor: TSpeedButton;
    bPopupHotTrackGradientToColor: TSpeedButton;
    bPopupHotTrackCaptionColor: TSpeedButton;
    bPopupIdleGradientFromColor: TSpeedButton;
    bPopupHotTrackFrameColor: TSpeedButton;
    bPopupIdleGradientToColor: TSpeedButton;
    bPopupIdleCaptionColor: TSpeedButton;
    bPopupDisabledCaptionColor: TSpeedButton;
    bPopupDividerLineColor: TSpeedButton;
    bvPopupIdleFrame: TBevel;
    bvHorSpacer: TBevel;
    bvPaneHorSpacer: TBevel;
    bvVertSpacer: TBevel;
    bMenuButtonActiveCaptionColor: TSpeedButton;
    bMenuButtonActiveFrameColor: TSpeedButton;
    bMenuButtonActiveGradientFromColor: TSpeedButton;
    bMenuButtonActiveGradientToColor: TSpeedButton;
    bMenuButtonHotTrackCaptionColor: TSpeedButton;
    bMenuButtonHotTrackFrameColor: TSpeedButton;
    bMenuButtonHotTrackGradientFromColor: TSpeedButton;
    bMenuButtonHotTrackGradientToColor: TSpeedButton;
    bMenuButtonIdleCaptionColor: TSpeedButton;
    bMenuButtonIdleFrameColor: TSpeedButton;
    bMenuButtonIdleGradientFromColor: TSpeedButton;
    bMenuButtonIdleGradientToColor: TSpeedButton;
    bvPaneVertSpacer: TBevel;
    cbPopupGutterGradientKind: TComboBox;
    cbPopupCheckedGradientKind: TComboBox;
    cbPopupHotSelectionShape: TComboBox;
    cbPopupIdleGradientKind: TComboBox;
    cbMenuButtonActiveGradientKind: TComboBox;
    cbMenuButtonHottrackGradientKind: TComboBox;
    cbMenuButtonIdleGradientKind: TComboBox;
    cbMenuButtonShapeStyle: TComboBox;
    cbPopupHotTrackGradientKind: TComboBox;
    cbKnobAsGradient: TCheckBox;
    edMenuButtonHotTrackBrightnessChange: TSpinEdit;

    edTabCaptionHeight: TSpinEdit;
    Images: TImageList;
    lblItemIdleKnobColor: TLabel;
    lblItemIdleTrackColor: TLabel;
    lblPopupHotSelectionShape: TLabel;
    lblPopupFont: TLabel;
    lblPopupDisabledCaptionColor: TLabel;
    lblPopupCaption: TLabel;
    lblPopupDividerLine: TLabel;
    lblPopupFrame: TLabel;
    lblPopupGradientFrom: TLabel;
    lblPopupGradientTo: TLabel;
    lblPopupGradientType: TLabel;
    lblPopupIdle: TLabel;
    lblPopupHotTrack: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    lblPopupGutter: TLabel;
    lblPopupChecked: TLabel;
    lblMenuButtonFont: TLabel;
    Label34: TLabel;
    lMenuButtonIdleFrame: TLabel;
    lblMenuButtonActive: TLabel;
    lblMenuButtonHotTrack: TLabel;
    lblMenuButtonIdle: TLabel;
    lblTabCornerRadius: TLabel;
    lblTabCaptionHeight: TLabel;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    pItemActiveInnerDark1: TPanel;
    pItemActiveKnobColor: TPanel;
    pItemActiveTrackColor: TPanel;
    pItemIdleKnobColor: TPanel;
    pItemIdleTrackColor: TPanel;
    pItemHotTrackTrackColor: TPanel;
    pPopupCheckedGradientFromColor: TPanel;
    pPopupCheckedGradientToColor: TPanel;
    pPopupDisabledCaptionColor: TPanel;
    pPopupDividerLineColor: TPanel;
    pPopupFont: TPanel;
    pPopupGutterFrameColor: TPanel;
    pPopupCheckedFrameColor: TPanel;
    pPopupGutterGradientFromColor: TPanel;
    pPopupGutterGradientToColor: TPanel;
    pPopupIdleGradientFromColor: TPanel;

    pMenuButtonActiveCaptionColor: TPanel;
    pMenuButtonActiveFrame: TPanel;
    pMenuButtonActiveGradientFrom: TPanel;
    pMenuButtonActiveGradientTo: TPanel;
    pMenuButtonFont: TPanel;
    pMenuButtonHottrackCaptionColor: TPanel;
    pMenuButtonHottrackFrame: TPanel;
    pMenuButtonHottrackGradientFrom: TPanel;
    pMenuButtonHottrackGradientTo: TPanel;
    pMenuButtonIdleCaptionColor: TPanel;
    pMenuButtonIdleFrame: TPanel;
    pMenuButtonIdleGradientFrom: TPanel;
    pMenuButtonIdleGradientTo: TPanel;
    pPopupHotTrackFrameColor: TPanel;
    pPopupHotTrackGradientFromColor: TPanel;
    pPopupHotTrackGradientToColor: TPanel;
    pPopupHotTrackCaptionColor: TPanel;
    pPopupIdleGradientToColor: TPanel;
    pPopupIdleCaptionColor: TPanel;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    Separator4: TMenuItem;

    SmallImages: TImageList;
    LargeImages: TImageList;
    Images_150: TImageList;
    Label15: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    PaneHSpacer: TBevel;
    bvItemHorSpacer: TBevel;
    edPaneHotTrackBrightnessChange: TSpinEdit;
    edItemHotTrackBrightnessChange: TSpinEdit;
    edTabCornerRadius: TSpinEdit;
    LazPane4: TLazRibbonPane;
    LazPopupMenu1: TLazRibbonPopupMenu;
    LazToggleSwitch1: TLazRibbonToggleSwitch;
    LazToggleSwitch2: TLazRibbonToggleSwitch;
    TabSheet6: TTabSheet;
    bInactiveTabHeaderFontColor: TSpeedButton;
    bItemActiveInnerDarkColor: TSpeedButton;
    bItemActiveGradientFromColor: TSpeedButton;
    bItemActiveGradientToColor: TSpeedButton;
    bItemActiveCaptionColor: TSpeedButton;
    bItemActiveInnerLightColor: TSpeedButton;
    bItemHotTrackInnerDarkColor: TSpeedButton;
    bItemHotTrackFrameColor: TSpeedButton;
    bItemActiveFrameColor: TSpeedButton;
    bItemHotTrackGradientFromColor: TSpeedButton;
    bItemHotTrackGradientToColor: TSpeedButton;
    bItemHotTrackCaptionColor: TSpeedButton;
    bItemHotTrackInnerLightColor: TSpeedButton;
    bItemIdleInnerDarkColor: TSpeedButton;
    bItemIdleGradientFromColor: TSpeedButton;
    bItemIdleGradientToColor: TSpeedButton;
    bItemIdleCaptionColor: TSpeedButton;
    bItemIdleInnerLightColor: TSpeedButton;
    bPaneBorderDarkColor: TSpeedButton;
    bPaneBorderLightColor: TSpeedButton;
    bPaneGradientFromColor: TSpeedButton;
    bPaneGradientToColor: TSpeedButton;
    bPaneCaptionBackgroundColor: TSpeedButton;
    bPaneCaptionFontColor: TSpeedButton;
    bItemIdleFrameColor: TSpeedButton;
    bTabGradientFromColor: TSpeedButton;
    bTabGradientToColor: TSpeedButton;
    bActiveTabHeaderFontColor: TSpeedButton;
    bExportToPascal: TButton;
    bCopyToClipboard: TButton;
    cbItemStyle: TComboBox;
    cbPaneStyle: TComboBox;
    ColorView: TShape;
    bvItemVertSpacer: TBevel;
    gbPreview: TGroupBox;
    Label12: TLabel;
    Label27: TLabel;
    LblCaptionBackground1: TLabel;
    LblRGB: TLabel;
    Images_100: TImageList;
    Images_200: TImageList;
    Label18: TLabel;
    LblInactiveTabHeaderFontColor: TLabel;
    pInactiveTabHeaderFont: TPanel;
    ButtonPanel: TPanel;
    bTabFrameColor: TSpeedButton;
    LazTab2: TLazRibbonTab;
    pgPopup: TTabSheet;
    tbPreview: TLazRibbon;
    LazTab1: TLazRibbonTab;
    LazPane1: TLazRibbonPane;
    LazLargeButton1: TLazRibbonLargeButton;
    LazLargeButton3: TLazRibbonLargeButton;
    LazLargeButton2: TLazRibbonLargeButton;
    LazPane2: TLazRibbonPane;
    LazSmallButton1: TLazRibbonSmallButton;
    LazSmallButton2: TLazRibbonSmallButton;
    LazSmallButton3: TLazRibbonSmallButton;
    LazPane3: TLazRibbonPane;
    LazSmallButton4: TLazRibbonSmallButton;
    LazSmallButton5: TLazRibbonSmallButton;
    LazSmallButton6: TLazRibbonSmallButton;
    LazSmallButton7: TLazRibbonSmallButton;
    LazSmallButton8: TLazRibbonSmallButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lblTabFrame: TLabel;
    pTabFrame: TPanel;
    pTabGradientFrom: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    pTabGradientTo: TPanel;
    cbTabGradientKind: TComboBox;
    Label5: TLabel;
    lblTabHeaderFont: TLabel;
    pTabHeaderFont: TPanel;
    lblPaneBorderDark: TLabel;
    pPaneBorderDark: TPanel;
    pPaneBorderLight: TPanel;
    Label21: TLabel;
    Label9: TLabel;
    pPaneGradientFrom: TPanel;
    pPaneGradientTo: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    cbPaneGradientKind: TComboBox;
    pPaneCaptionBackground: TPanel;
    lblPaneCaptionBackground: TLabel;
    Label13: TLabel;
    pPaneCaptionFont: TPanel;
    lblItemIdleFrame: TLabel;
    Label7: TLabel;
    Label14: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    pItemFont: TPanel;
    cbItemIdleGradientKind: TComboBox;
    pItemIdleGradientTo: TPanel;
    pItemIdleGradientFrom: TPanel;
    pItemIdleFrame: TPanel;
    lblItemIdle: TLabel;
    Label28: TLabel;
    pItemIdleCaptionColor: TPanel;
    Label29: TLabel;
    pItemIdleInnerDark: TPanel;
    lblItemInnerLightColor: TLabel;
    pItemIdleInnerLight: TPanel;
    cbItemHottrackGradientKind: TComboBox;
    pItemHottrackGradientTo: TPanel;
    pItemHottrackGradientFrom: TPanel;
    pItemHottrackFrame: TPanel;
    LblHotTrack: TLabel;
    pItemHottrackCaptionColor: TPanel;
    pItemHottrackInnerDark: TPanel;
    pItemHottrackInnerLight: TPanel;
    cbItemActiveGradientKind: TComboBox;
    pItemActiveGradientTo: TPanel;
    pItemActiveGradientFrom: TPanel;
    pItemActiveFrame: TPanel;
    LblActive: TLabel;
    pItemActiveCaptionColor: TPanel;
    pItemActiveInnerDark: TPanel;
    pItemActiveInnerLight: TPanel;
    bOK: TButton;
    bCancel: TButton;
    cdColorDialog: TColorDialog;
    fdFontDialog: TFontDialog;
    pActiveTabHeaderFont: TPanel;
    pPaneCaptionFontColor: TPanel;
    TabSheet4: TTabSheet;
    bImport: TButton;
    bExportToXML: TButton;
    mXML: TMemo;
    sTabRectangle: TShape;
    cbLinkTab: TCheckBox;
    sPaneRectangle: TShape;
    cbLinkPane: TCheckBox;
    cbLinkItem: TCheckBox;
    sItemRectangle: TShape;
    TabSheet5: TTabSheet;
    Label17: TLabel;
    LbAppearanceStyle: TListbox;

    procedure bActiveTabHeaderFontColorClick(Sender: TObject);
    procedure bCopyToClipboardClick(Sender: TObject);
    procedure bExportToPascalClick(Sender: TObject);
    procedure bExportToXMLClick(Sender: TObject);
    procedure bImportClick(Sender: TObject);
    procedure bInactiveTabHeaderFontColorClick(Sender: TObject);
    procedure bItemActiveCaptionColorClick(Sender: TObject);
    procedure bItemActiveFrameColorClick(Sender: TObject);
    procedure bItemActiveGradientFromColorClick(Sender: TObject);
    procedure bItemActiveGradientToColorClick(Sender: TObject);
    procedure bItemActiveInnerDarkColorClick(Sender: TObject);
    procedure bItemActiveInnerLightColorClick(Sender: TObject);
    procedure bItemActiveKnobColorClick(Sender: TObject);
    procedure bItemActiveTrackColorClick(Sender: TObject);
    procedure bItemHotTrackCaptionColorClick(Sender: TObject);
    procedure bItemHotTrackFrameColorClick(Sender: TObject);
    procedure bItemHotTrackGradientFromColorClick(Sender: TObject);
    procedure bItemHotTrackGradientToColorClick(Sender: TObject);
    procedure bItemHotTrackInnerDarkColorClick(Sender: TObject);
    procedure bItemHotTrackInnerLightColorClick(Sender: TObject);
    procedure bItemIdleCaptionColorClick(Sender: TObject);
    procedure bItemIdleFrameColorClick(Sender: TObject);
    procedure bItemIdleGradientFromColorClick(Sender: TObject);
    procedure bItemIdleGradientToColorClick(Sender: TObject);
    procedure bItemIdleInnerDarkColorClick(Sender: TObject);
    procedure bItemIdleInnerLightColorClick(Sender: TObject);
    procedure bItemIdleKnobColorClick(Sender: TObject);
    procedure bItemIdleTrackColor1Click(Sender: TObject);
    procedure bItemIdleTrackColorClick(Sender: TObject);
    procedure bPaneBorderDarkColorClick(Sender: TObject);
    procedure bPaneBorderLightColorClick(Sender: TObject);
    procedure bPaneCaptionBackgroundColorClick(Sender: TObject);
    procedure bPaneCaptionFontColorClick(Sender: TObject);
    procedure bPaneGradientFromColorClick(Sender: TObject);
    procedure bPaneGradientToColorClick(Sender: TObject);
    procedure bPopupCheckedFrameColorClick(Sender: TObject);
    procedure bPopupCheckedGradientFromColorClick(Sender: TObject);
    procedure bPopupCheckedGradientToColorClick(Sender: TObject);
    procedure bPopupDisabledCaptionColorClick(Sender: TObject);
    procedure bPopupDividerLineColorClick(Sender: TObject);
    procedure bPopupGutterFrameColorClick(Sender: TObject);
    procedure bPopupGutterGradientFromColorClick(Sender: TObject);
    procedure bPopupGutterGradientToColorClick(Sender: TObject);
    procedure bPopupHotTrackCaptionColorClick(Sender: TObject);
    procedure bPopupHotTrackFrameColorClick(Sender: TObject);
    procedure bPopupHotTrackGradientFromColorClick(Sender: TObject);
    procedure bPopupHotTrackGradientToColorClick(Sender: TObject);
    procedure bPopupIdleCaptionColorClick(Sender: TObject);
    procedure bPopupIdleGradientFromColorClick(Sender: TObject);
    procedure bPopupIdleGradientToColorClick(Sender: TObject);
    procedure bResetClick(Sender: TObject);

    procedure bTabBorderColorClick(Sender: TObject);
    procedure bTabGradientFromColorClick(Sender: TObject);
    procedure bTabGradientToColorClick(Sender: TObject);

    procedure cbItemActiveGradientKindChange(Sender: TObject);
    procedure cbItemHottrackGradientKindChange(Sender: TObject);
    procedure cbItemIdleGradientKindChange(Sender: TObject);
    procedure cbItemStyleChange(Sender: TObject);
    procedure cbKnobAsGradientChange(Sender: TObject);
    procedure cbPaneGradientKindChange(Sender: TObject);
    procedure cbPaneStyleChange(Sender: TObject);
    procedure cbPopupCheckedGradientKindChange(Sender: TObject);
    procedure cbPopupGutterGradientKindChange(Sender: TObject);
    procedure cbPopupHotSelectionShapeChange(Sender: TObject);
    procedure cbPopupHotTrackGradientKindChange(Sender: TObject);
    procedure cbPopupIdleGradientKindChange(Sender: TObject);
    procedure cbTabGradientKindChange(Sender: TObject);

    procedure cbLinkItemClick(Sender: TObject);
    procedure cbLinkPaneClick(Sender: TObject);
    procedure cbLinkTabClick(Sender: TObject);

    procedure edItemHotTrackBrightnessChangeChange(Sender: TObject);
    procedure edPaneHotTrackBrightnessChangeChange(Sender: TObject);
    procedure edTabCaptionHeightChange(Sender: TObject);
    procedure edTabCornerRadiusChange(Sender: TObject);

    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure LbAppearanceStyleClick(Sender: TObject);

    procedure pActiveTabHeaderFontClick(Sender: TObject);
    procedure pInactiveTabHeaderFontClick(Sender: TObject);
    procedure pItemActiveKnobColorClick(Sender: TObject);
    procedure pItemActiveTrackColorClick(Sender: TObject);
    procedure pItemHotTrackTrackColorClick(Sender: TObject);
    procedure pItemIdleKnobColorClick(Sender: TObject);
    procedure pPopupCheckedFrameColorClick(Sender: TObject);
    procedure pPopupCheckedGradientFromColorClick(Sender: TObject);
    procedure pPopupCheckedGradientToColorClick(Sender: TObject);
    procedure pPopupFontClick(Sender: TObject);
    procedure pPopupGutterFrameColorClick(Sender: TObject);
    procedure pPopupGutterGradientFromColorClick(Sender: TObject);
    procedure pPopupGutterGradientToColorClick(Sender: TObject);
    procedure pPopupHotTrackFrameColorClick(Sender: TObject);
    procedure pPopupHotTrackGradientFromColorClick(Sender: TObject);
    procedure pPopupHotTrackGradientToColorClick(Sender: TObject);
    procedure pPopupIdleCaptionColorClick(Sender: TObject);
    procedure pPopupDisabledCaptionColorClick(Sender: TObject);
    procedure pPopupDividerLineColorClick(Sender: TObject);
    procedure pPopupIdleGradientFromColorClick(Sender: TObject);
    procedure pPopupIdleGradientToColorClick(Sender: TObject);
    procedure pPopupHotTrackCaptionColorClick(Sender: TObject);

    procedure pTabFrameClick(Sender: TObject);
    procedure pTabGradientFromClick(Sender: TObject);
    procedure pTabGradientToClick(Sender: TObject);

    procedure pPaneBorderDarkClick(Sender: TObject);
    procedure pPaneBorderLightClick(Sender: TObject);
    procedure pPaneCaptionFontClick(Sender: TObject);
    procedure pPaneCaptionFontColorClick(Sender: TObject);
    procedure pPaneGradientFromClick(Sender: TObject);
    procedure pPaneGradientToClick(Sender: TObject);
    procedure pPaneCaptionBackgroundClick(Sender: TObject);

    procedure pItemActiveCaptionColorClick(Sender: TObject);
    procedure pItemActiveFrameClick(Sender: TObject);
    procedure pItemActiveGradientFromClick(Sender: TObject);
    procedure pItemActiveGradientToClick(Sender: TObject);
    procedure pItemActiveInnerDarkClick(Sender: TObject);
    procedure pItemActiveInnerLightClick(Sender: TObject);

    procedure pItemFontClick(Sender: TObject);
    procedure pItemIdleCaptionColorClick(Sender: TObject);
    procedure pItemIdleFrameClick(Sender: TObject);
    procedure pItemIdleGradientFromClick(Sender: TObject);
    procedure pItemIdleGradientToClick(Sender: TObject);
    procedure pItemIdleInnerDarkClick(Sender: TObject);
    procedure pItemIdleInnerLightClick(Sender: TObject);

    procedure pItemHottrackCaptionColorClick(Sender: TObject);
    procedure pItemHottrackFrameClick(Sender: TObject);
    procedure pItemHottrackGradientFromClick(Sender: TObject);
    procedure pItemHottrackGradientToClick(Sender: TObject);
    procedure pItemHottrackInnerDarkClick(Sender: TObject);
    procedure pItemHottrackInnerLightClick(Sender: TObject);

    procedure pTabHeaderFontClick(Sender: TObject);

    { Support for managing appearance of Menu Button }
    procedure bMenuButtonIdleFrameColorClick(Sender: TObject);
    procedure bMenuButtonIdleGradientFromColorClick(Sender: TObject);
    procedure bMenuButtonIdleGradientToColorClick(Sender: TObject);
    procedure bMenuButtonIdleCaptionColorClick(Sender: TObject);
    procedure bMenuButtonHotTrackFrameColorClick(Sender: TObject);
    procedure bMenuButtonHotTrackGradientFromColorClick(Sender: TObject);
    procedure bMenuButtonHotTrackGradientToColorClick(Sender: TObject);
    procedure bMenuButtonHotTrackCaptionColorClick(Sender: TObject);
    procedure bMenuButtonActiveFrameColorClick(Sender: TObject);
    procedure bMenuButtonActiveGradientFromColorClick(Sender: TObject);
    procedure bMenuButtonActiveGradientToColorClick(Sender: TObject);
    procedure bMenuButtonActiveCaptionColorClick(Sender: TObject);

    procedure cbMenuButtonIdleGradientKindChange(Sender: TObject);
    procedure cbMenuButtonHottrackGradientKindChange(Sender: TObject);
    procedure cbMenuButtonActiveGradientKindChange(Sender: TObject);
    procedure cbMenuButtonShapeStyleChange(Sender: TObject);

    procedure edMenuButtonHotTrackBrightnessChangeChange(Sender: TObject);

    procedure pMenuButtonIdleFrameClick(Sender: TObject);
    procedure pMenuButtonIdleGradientFromClick(Sender: TObject);
    procedure pMenuButtonIdleGradientToClick(Sender: TObject);
    procedure pMenuButtonIdleCaptionColorClick(Sender: TObject);

    procedure pMenuButtonHottrackFrameClick(Sender: TObject);
    procedure pMenuButtonHottrackGradientFromClick(Sender: TObject);
    procedure pMenuButtonHottrackGradientToClick(Sender: TObject);
    procedure pMenuButtonHottrackCaptionColorClick(Sender: TObject);

    procedure pMenuButtonActiveFrameClick(Sender: TObject);
    procedure pMenuButtonActiveGradientFromClick(Sender: TObject);
    procedure pMenuButtonActiveGradientToClick(Sender: TObject);
    procedure pMenuButtonActiveCaptionColorClick(Sender: TObject);

    procedure pMenuButtonFontClick(Sender: TObject);

  private
    procedure SetLinkedFrameColor(AColor : TColor);
    procedure SetLinkedGradientFromColor(AColor : TColor);
    procedure SetLinkedGradientToColor(AColor : TColor);
    procedure SetLinkedGradientKind(AKindIndex : integer);

    function GetAppearance: TLazRibbonToolbarAppearance;
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);

    procedure SwitchAttributesLink(const Value : boolean);

    function ChangeColor(Panel : TPanel) : boolean;
    procedure SetPanelColor(Panel: TPanel; AColor : TColor);
    function ChangeFont(Panel : TPanel) : boolean;
    procedure SetPanelFont(Panel : TPanel; AFont : TFont);
    procedure SetComboIndex(Combo: TComboBox; AIndex: Integer);
    function SafeComboIndex(Combo: TComboBox): Integer;
    procedure SetComboGradientKind(Combo : TComboBox; GradientType : TBackgroundKind);
    procedure LoadAppearance(AAppearance : TLazRibbonToolbarAppearance);

  private  { Color picker }
    FScreenBitmap: TBitmap;
    FScreenshotForm: TForm;
    function PickColor(APanel: TPanel): Boolean;
    procedure ScreenshotKeyDown(Sender: TObject;
      var Key: Word; {%H-}Shift: TShiftState);
    procedure ScreenshotMouseDown(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: integer);
    procedure ScreenshotMouseMove(Sender: TObject;
      {%H-}Shift: TShiftState; X, Y: integer);
    procedure ScreenshotMouseUp(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: integer);

  private
    FAutoSized: Boolean;
    cbPopupStyle: TComboBox;
    lblPopupStyle: TLabel;
    procedure CreatePopupStyleControls;
    procedure UpdateImages;
    procedure UpdateSizes;
    procedure cbPopupStyleChange(Sender: TObject);

  protected
    {$IF lcl_fullversion >= 1080000}
    procedure DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
      const AXProportion, AYProportion: Double); override;
    {$ENDIF}

  public
    property Appearance : TLazRibbonToolbarAppearance read GetAppearance write SetAppearance;
  end;

var
  frmLazRibbonAppearanceEditWindow: TfrmLazRibbonAppearanceEditWindow;

implementation

{$R *.lfm}

uses
  clipbrd;

var
  CurrPageIndex: Integer = 0;


{ TfrmLazRibbonAppearanceEditWindow }

{$IF lcl_fullversion >= 1080000}
procedure TfrmLazRibbonAppearanceEditWindow.DoAutoAdjustLayout(
  const AMode: TLayoutAdjustmentPolicy; const AXProportion, AYProportion: Double);
begin
  inherited;
end;
{$ENDIF}

procedure TfrmLazRibbonAppearanceEditWindow.SetAppearance(const Value: TLazRibbonToolbarAppearance);
begin
  tbPreview.Appearance.Assign(Value);
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetComboIndex(Combo: TComboBox;
  AIndex: Integer);
begin
  if Combo = nil then
    Exit;

  if Combo.Items.Count = 0 then
  begin
    Combo.ItemIndex := -1;
    Exit;
  end;

  if AIndex < 0 then
    AIndex := 0;
  if AIndex >= Combo.Items.Count then
    AIndex := Combo.Items.Count - 1;

  Combo.ItemIndex := AIndex;
end;

function TfrmLazRibbonAppearanceEditWindow.SafeComboIndex(Combo: TComboBox): Integer;
begin
  Result := 0;
  if Combo = nil then
    Exit;

  if Combo.ItemIndex >= 0 then
    Result := Combo.ItemIndex;

  if (Combo.Items.Count > 0) and (Result >= Combo.Items.Count) then
    Result := Combo.Items.Count - 1;
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetComboGradientKind(Combo: TComboBox;
  GradientType: TBackgroundKind);
begin
  SetComboIndex(Combo, Ord(GradientType));
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetLinkedFrameColor(AColor: TColor);
begin
  tbPreview.Appearance.Tab.BorderColor := AColor;
  SetPanelColor(pTabFrame, AColor);

  tbPreview.Appearance.Pane.BorderDarkColor := AColor;
  SetPanelColor(pPaneBorderDark, AColor);

  tbPreview.Appearance.Element.IdleFrameColor := AColor;
  SetPanelColor(pItemIdleFrame, AColor);
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetLinkedGradientFromColor(AColor: TColor);
begin
  tbPreview.Appearance.Tab.GradientFromColor := AColor;
  SetPanelColor(pTabGradientFrom, AColor);

  tbPreview.Appearance.Pane.GradientFromColor := AColor;
  SetPanelColor(pPaneGradientFrom, AColor);

  tbPreview.Appearance.Element.IdleGradientFromColor := AColor;
  SetPanelColor(pItemIdleGradientFrom, AColor);
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetLinkedGradientKind(AKindIndex: integer);
var
  Kind: TBackgroundKind;
begin
  Kind := TBackgroundKind(AKindIndex);

  tbPreview.Appearance.Tab.GradientType := Kind;
  SetComboGradientKind(cbTabGradientKind, Kind);

  tbPreview.Appearance.Pane.GradientType := Kind;
  SetComboGradientKind(cbPaneGradientKind, Kind);

  tbPreview.Appearance.Element.IdleGradientType := Kind;
  SetComboGradientKind(cbItemIdleGradientKind, Kind);
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetLinkedGradientToColor(AColor: TColor);
begin
  tbPreview.Appearance.Tab.GradientToColor := AColor;
  SetPanelColor(pTabGradientTo, AColor);

  tbPreview.Appearance.Pane.GradientToColor := AColor;
  SetPanelColor(pPaneGradientTo, AColor);

  tbPreview.Appearance.Element.IdleGradientToColor := AColor;
  SetPanelColor(pItemIdleGradientTo, AColor);
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetPanelColor(Panel: TPanel; AColor: TColor);
begin
  Panel.Color := AColor;
  if Panel.Color <> AColor then
     Showmessage('lipa!');                  // wp: what is this?
  Panel.Font.Color := TColorTools.GetContrastColor(AColor, clBlack, clWhite);
  Panel.Caption := '$' + IntToHex(AColor, 8);
end;

procedure TfrmLazRibbonAppearanceEditWindow.SetPanelFont(Panel: TPanel; AFont: TFont);
begin
  Panel.Font.Assign(AFont);
  Panel.Caption := AFont.Name + ', ' + IntToStr(AFont.Size);
end;

procedure TfrmLazRibbonAppearanceEditWindow.bTabBorderColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pTabFrame) then
  begin
    tbPreview.Appearance.Tab.BorderColor := pTabFrame.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pTabFrame.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bTabGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pTabGradientFrom) then
  begin
    tbPreview.Appearance.Tab.GradientFromColor := pTabGradientFrom.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pTabGradientFrom.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bTabGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pTabGradientTo) then
  begin
    tbPreview.Appearance.Tab.GradientToColor := pTabGradientTo.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pTabGradientTo.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bCopyToClipboardClick(Sender: TObject);
begin
  if mXML.Lines.Count > 0 then
    Clipboard.AsText := mXML.Text;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bActiveTabHeaderFontColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pActiveTabHeaderFont) then
  begin
    tbPreview.Appearance.Tab.TabHeaderFont.Color := pActiveTabHeaderFont.Color;
    tbPreview.ForceRepaint;
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bExportToPascalClick(Sender: TObject);
var
  L: TStrings;
begin
  L := TStringList.Create;
  try
    tbPreview.Appearance.SaveToPascal(L);
    mXML.Clear;
    mXML.Lines.Assign(L);
  finally
    L.Free;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bExportToXMLClick(Sender: TObject);
var
  Xml: TLazRibbonXMLParser;
  Node: TLazRibbonXMLNode;
begin
  XML:=TLazRibbonXMLParser.Create;
  try
    Node := XML['Appearance', true];
    tbPreview.Appearance.SaveToXML(Node);
    mXML.Clear;
    mXml.Text:=XML.Generate;
  finally
    XML.Free;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bInactiveTabHeaderFontColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pInactiveTabHeaderFont) then
  begin
    tbPreview.Appearance.Tab.InactiveTabHeaderFontColor := pInactiveTabHeaderFont.Color;
    tbPreview.ForceRepaint;
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveCaptionColorClick(Sender: TObject
  );
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveCaptionColor) then
    tbPreview.Appearance.Element.ActiveCaptionColor := pItemActiveCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveFrame) then
    tbPreview.Appearance.Element.ActiveFrameColor := pItemactiveFrame.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveGradientFrom) then
    tbPreview.Appearance.Element.ActiveGradientFromColor := pItemActiveGradientFrom.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveGradientTo) then
    tbPreview.Appearance.Element.ActiveGradientToColor := pItemActiveGradientTo.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveInnerDarkColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveInnerDark) then
    tbPreview.Appearance.Element.ActiveInnerDarkColor := pItemActiveInnerDark.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveInnerLightColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveInnerLight) then
    tbPreview.Appearance.Element.ActiveInnerLightColor := pItemActiveInnerLight.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveKnobColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveKnobColor) then
    tbPreview.Appearance.Element.ActiveKnobColor := pItemActiveKnobColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemActiveTrackColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemActiveTrackColor) then
    tbPreview.Appearance.Element.ActiveTrackColor := pItemActiveTrackColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemHotTrackCaptionColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemHotTrackCaptionColor) then
    tbPreview.Appearance.Element.HotTrackCaptionColor := pItemHotTrackCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemHotTrackFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemHottrackFrame) then
    tbPreview.Appearance.Element.HotTrackFrameColor := pItemHottrackFrame.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemHotTrackGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemHotTrackGradientFrom) then
    tbPreview.Appearance.Element.HotTrackGradientFromColor := pItemHotTrackGradientFrom.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemHotTrackGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemHotTrackGradientTo) then
    tbPreview.Appearance.Element.HotTrackGradientToColor := pItemHotTrackGradientTo.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemHotTrackInnerDarkColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemHotTrackInnerDark) then
    tbPreview.Appearance.Element.HotTrackInnerDarkColor := pItemHotTrackInnerDark.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemHotTrackInnerLightColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemHotTrackInnerLight) then
    tbPreview.Appearance.Element.HotTrackInnerLightColor := pItemHotTrackInnerLight.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleCaptionColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleCaptionColor) then
  begin
    tbPreview.Appearance.Element.IdleCaptionColor := pItemIdleCaptionColor.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pItemIdleCaptionColor.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleFrame) then
  begin
    tbPreview.Appearance.Element.IdleFrameColor := pItemIdleFrame.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pItemIdleFrame.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleGradientFrom) then
  begin
    tbPreview.Appearance.Element.IdleGradientFromColor := pItemIdleGradientFrom.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pItemIdleGradientFrom.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleGradientTo) then
  begin
    tbPreview.Appearance.Element.IdleGradientToColor := pItemIdleGradientTo.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pItemIdleGradientTo.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleInnerDarkColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleInnerDark) then
  begin
    tbPreview.Appearance.Element.IdleInnerDarkColor := pItemIdleInnerDark.Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor(pItemIdleInnerDark.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleInnerLightColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleInnerLight) then
  begin
    tbPreview.Appearance.Element.IdleInnerLightColor := pItemIdleInnerLight.Color;
    if cbLinkPane.Checked then
      SetLinkedFrameColor(pItemIdleInnerLight.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleKnobColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleKnobColor) then
    tbPreview.Appearance.Element.IdleKnobColor := pItemIdleKnobColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleTrackColor1Click(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemHotTrackTrackColor) then
    tbPreview.Appearance.Element.HotTrackTrackColor := pItemHotTrackTrackColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bItemIdleTrackColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pItemIdleTrackColor) then
    tbPreview.Appearance.Element.IdleTrackColor := pItemIdleTrackColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPaneBorderDarkColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPaneBorderDark) then
  begin
    tbPreview.Appearance.Pane.BorderDarkColor := pPaneBorderDark.Color;
    if cbLinkPane.Checked then
      SetLinkedFrameColor(pPaneBorderDark.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPaneBorderLightColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPaneBorderLight) then
  begin
    tbPreview.Appearance.Pane.BorderLightColor := pPaneBorderLight.Color;
    if cbLinkPane.Checked then
      SetLinkedFrameColor(pPaneBorderLight.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPaneCaptionBackgroundColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPaneCaptionBackground) then
    tbPreview.Appearance.Pane.CaptionBgColor := pPaneCaptionBackground.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPaneCaptionFontColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPaneCaptionFontColor) then
  begin
    tbPreview.Appearance.Pane.CaptionFont.Color := pPaneCaptionFontColor.Color;
    tbPreview.ForceRepaint;
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPaneGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPaneGradientFrom) then
  begin
    tbPreview.Appearance.Pane.GradientFromColor := pPaneGradientFrom.Color;
    if cbLinkPane.Checked then
      SetLinkedFrameColor(pPaneGradientFrom.Color)
  end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPaneGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPaneGradientTo) then
  begin
    tbPreview.Appearance.Pane.GradientToColor := pPaneGradientTo.Color;
    if cbLinkPane.Checked then
      SetLinkedFrameColor(pPaneGradientTo.Color)
    end;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupCheckedFrameColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupCheckedFrameColor) then
    tbPreview.Appearance.Popup.CheckedFrameColor := pPopupCheckedFrameColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupCheckedGradientFromColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupCheckedGradientFromColor) then
    tbPreview.Appearance.Popup.CheckedGradientFromColor := pPopupCheckedGradientFromColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupCheckedGradientToColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupCheckedGradientFromColor) then
    tbPreview.Appearance.Popup.CheckedGradientToColor := pPopupCheckedGradientToColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupDisabledCaptionColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupDisabledCaptionColor) then
    tbPreview.Appearance.Popup.DisabledCaptionColor := pPopupDisabledCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;

end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupDividerLineColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupDividerLineColor) then
    tbPreview.Appearance.Popup.DividerLineColor := pPopupDividerLineColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupGutterFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupGutterFrameColor) then
    tbPreview.Appearance.Popup.GutterFrameColor := pPopupGutterFrameColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupGutterGradientFromColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupGutterGradientFromColor) then
    tbPreview.Appearance.Popup.GutterGradientFromColor := pPopupGutterGradientFromColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupGutterGradientToColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupGutterGradientToColor) then
    tbPreview.Appearance.Popup.GutterGradientToColor := pPopupGutterGradientToColor.Color;
  (Sender as TSpeedButton).Down := false;

end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupHotTrackCaptionColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupHotTrackCaptionColor) then
    tbPreview.Appearance.Popup.HotTrackCaptionColor := pPopupHotTrackCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupHotTrackFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupHotTrackFrameColor) then
    tbPreview.Appearance.Popup.HotTrackFrameColor := pPopupHotTrackFrameColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupHotTrackGradientFromColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupHotTrackGradientFromColor) then
    tbPreview.Appearance.Popup.HotTrackGradientFromColor := pPopupHotTrackGradientFromColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupHotTrackGradientToColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupHotTrackGradientToColor) then
    tbPreview.Appearance.Popup.HotTrackGradientToColor := pPopupHotTrackGradientToColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupIdleCaptionColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupIdleCaptionColor) then
    tbPreview.Appearance.Popup.IdleCaptionColor := pPopupIdleCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupIdleGradientFromColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupIdleGradientFromColor) then
    tbPreview.Appearance.Popup.IdleGradientFromColor := pPopupIdleGradientFromColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bPopupIdleGradientToColorClick(
  Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pPopupIdleGradientToColor) then
    tbPreview.Appearance.Popup.IdleGradientToColor := pPopupIdleGradientToColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.SwitchAttributesLink(const Value: boolean);
begin
  cbLinkTab.checked := Value;
  cbLinkPane.Checked := Value;
  cbLinkItem.Checked := Value;

  sTabRectangle.Visible := Value;
  sPaneRectangle.Visible := Value;
  sItemRectangle.Visible := Value;
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbItemHottrackGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.Element do
    HotTrackGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbItemIdleGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.Element do
    IdleGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
  if cbLinkItem.Checked then
     SetLinkedGradientKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbItemStyleChange(Sender: TObject);
begin
  with tbPreview.Appearance.Element do
    Style := TLazRibbonElementStyle(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbKnobAsGradientChange(Sender: TObject);
begin
  tbPreview.Appearance.Element.KnobAsGradient := cbKnobAsGradient.Checked;
  lblItemIdleKnobColor.Enabled := not cbKnobAsGradient.Checked;
  pItemIdleKnobColor.Enabled := not cbKnobAsGradient.Checked;
  bItemIdleKnobColor.Enabled := not cbKnobAsGradient.Checked;
  pItemActiveKnobColor.Enabled := not cbKnobAsGradient.Checked;
  bItemActiveKnobColor.Enabled := not cbKnobAsGradient.Checked;
  if cbKnobAsGradient.Checked then
  begin
    pItemIdleKnobColor.Color := clDefault;
    pItemActiveKnobColor.Color := clDefault;
  end else
  begin
    pItemIdleKnobColor.Color := tbPreview.Appearance.Element.IdleKnobColor;
    pItemActiveKnobColor.Color := tbPreview.Appearance.Element.ActiveKnobColor;
  end;

end;

procedure TfrmLazRibbonAppearanceEditWindow.cbLinkItemClick(Sender: TObject);
begin
  SwitchAttributesLink(cbLinkItem.Checked);
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbLinkPaneClick(Sender: TObject);
begin
  SwitchAttributesLink(cbLinkPane.Checked);
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbLinkTabClick(Sender: TObject);
begin
  SwitchAttributesLink(cbLinkTab.Checked);
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbTabGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.Tab do
    GradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
  if cbLinkTab.Checked then
    SetLinkedGradientKind(SafeComboIndex(Sender as TComboBox));
end;

function TfrmLazRibbonAppearanceEditWindow.ChangeColor(Panel: TPanel): boolean;
begin
  cdColorDialog.Color := Panel.Color;
  Result := cdColorDialog.Execute;
  if Result then
    SetPanelColor(Panel, cdColorDialog.Color);
end;

function TfrmLazRibbonAppearanceEditWindow.ChangeFont(Panel: TPanel): boolean;
begin
  fdFontDialog.Font.Assign(Panel.Font);
  Result := fdFontDialog.Execute;
  if Result then
    SetPanelFont(Panel, fdFontDialog.Font);
end;

procedure TfrmLazRibbonAppearanceEditWindow.edItemHotTrackBrightnessChangeChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.Element do
    HotTrackBrightnessChange := (Sender as TSpinEdit).Value;
  tbPreview.Invalidate;
end;

procedure TfrmLazRibbonAppearanceEditWindow.edPaneHotTrackBrightnessChangeChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.Pane do
    HotTrackBrightnessChange := (Sender as TSpinEdit).Value;
  tbPreview.Invalidate;
end;

procedure TfrmLazRibbonAppearanceEditWindow.edTabCaptionHeightChange(Sender: TObject);
begin
  with tbPreview.Appearance.Tab do
    CaptionHeight := (Sender as TSpinEdit).Value;
  tbPreview.Invalidate;
end;

procedure TfrmLazRibbonAppearanceEditWindow.edTabCornerRadiusChange(Sender: TObject);
begin
  with tbPreview.Appearance.Tab do
    CornerRadius := (Sender as TSpinEdit).Value;
  tbPreview.Invalidate;
end;

procedure TfrmLazRibbonAppearanceEditWindow.FormActivate(Sender: TObject);
begin
  UpdateImages;
  UpdateSizes;
end;

procedure TfrmLazRibbonAppearanceEditWindow.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if CanClose then CurrPageIndex := PageControl.PageIndex;
end;

procedure TfrmLazRibbonAppearanceEditWindow.FormCreate(Sender: TObject);
begin
  CreatePopupStyleControls;

  if PageControl.PageCount > 0 then
  begin
    if CurrPageIndex < 0 then
      CurrPageIndex := 0;
    if CurrPageIndex >= PageControl.PageCount then
      CurrPageIndex := PageControl.PageCount - 1;
    PageControl.PageIndex := CurrPageIndex;
  end;

  if (tbPreview <> nil) and (tbPreview.Tabs.Count > 0) then
    tbPreview.TabIndex := 0;
end;

procedure TfrmLazRibbonAppearanceEditWindow.CreatePopupStyleControls;
begin
  if (pgPopup = nil) or (cbPopupStyle <> nil) then
    Exit;

  cbPopupStyle := TComboBox.Create(Self);
  cbPopupStyle.Parent := pgPopup;
  cbPopupStyle.SetBounds(424, 238, 100, cbPopupHotSelectionShape.Height);
  cbPopupStyle.Style := csDropDownList;
  cbPopupStyle.Items.Add('default');
  cbPopupStyle.Items.Add('gutter');
  cbPopupStyle.ItemIndex := 0;
  cbPopupStyle.OnChange := cbPopupStyleChange;

  lblPopupStyle := TLabel.Create(Self);
  lblPopupStyle.Parent := pgPopup;
  lblPopupStyle.Left := cbPopupStyle.Left;
  lblPopupStyle.Top := cbPopupStyle.Top - 17;
  lblPopupStyle.Caption := 'Popup style';
end;

procedure TfrmLazRibbonAppearanceEditWindow.FormShow(Sender: TObject);
begin
  LoadAppearance(tbPreview.Appearance);
end;

function TfrmLazRibbonAppearanceEditWindow.GetAppearance: TLazRibbonToolbarAppearance;
begin
  result := tbPreview.Appearance;
end;

procedure TfrmLazRibbonAppearanceEditWindow.LbAppearanceStyleClick(Sender: TObject);
begin
  if LbAppearanceStyle.ItemIndex < 0 then
    Exit;
  tbPreview.Appearance.Reset(TLazRibbonStyle(LbAppearanceStyle.ItemIndex));
  LoadAppearance(tbPreview.Appearance);
end;

procedure TfrmLazRibbonAppearanceEditWindow.LoadAppearance(AAppearance: TLazRibbonToolbarAppearance);
begin
  with AAppearance do
  begin
    with Tab do
    begin
      SetPanelColor(pTabFrame, BorderColor);
      SetPanelColor(pTabGradientFrom, GradientFromColor);
      SetPanelColor(pTabGradientTo, GradientToColor);
      SetComboGradientKind(cbTabGradientKind, GradientType);
      SetPanelFont(pTabHeaderFont, TabHeaderFont);
      SetPanelColor(pActiveTabHeaderFont, TabHeaderFont.Color);
      SetPanelColor(pInactiveTabHeaderFont, InactiveTabHeaderFontColor);
      edTabCornerRadius.Value := CornerRadius;
      edTabCaptionHeight.Value := CaptionHeight;
    end;

    with MenuButton do
    begin
      SetPanelFont(pMenuButtonFont, CaptionFont);

      SetPanelColor(pMenuButtonIdleFrame, IdleFrameColor);
      SetPanelColor(pMenuButtonIdleGradientFrom, IdleGradientFromColor);
      SetPanelColor(pMenuButtonIdleGradientTo, IdleGradientToColor);
      SetComboGradientKind(cbMenuButtonIdleGradientKind, IdleGradientType);
      SetPanelColor(pMenuButtonIdleCaptionColor, IdleCaptionColor);

      SetPanelColor(pMenuButtonHottrackFrame, HottrackFrameColor);
      SetPanelColor(pMenuButtonHottrackGradientFrom, HottrackGradientFromColor);
      SetPanelColor(pMenuButtonHottrackGradientTo, HottrackGradientToColor);
      SetComboGradientKind(cbMenuButtonHottrackGradientKind, HottrackGradientType);
      SetPanelColor(pMenuButtonHottrackCaptionColor, HottrackCaptionColor);

      SetPanelColor(pMenuButtonActiveFrame, ActiveFrameColor);
      SetPanelColor(pMenuButtonActiveGradientFrom, ActiveGradientFromColor);
      SetPanelColor(pMenuButtonActiveGradientTo, ActiveGradientToColor);
      SetComboGradientKind(cbMenuButtonActiveGradientKind, ActiveGradientType);
      SetPanelColor(pMenuButtonActiveCaptionColor, ActiveCaptionColor);

      SetComboIndex(cbMenuButtonShapeStyle, Ord(ShapeStyle));
      edMenuButtonHotTrackBrightnessChange.Value := HotTrackBrightnessChange;
    end;

    with Pane do
    begin
      SetPanelColor(pPaneBorderDark, BorderDarkColor);
      SetPanelColor(pPaneBorderLight, BorderLightColor);
      SetPanelColor(pPaneGradientFrom, GradientFromColor);
      SetPanelColor(pPaneGradientTo, GradientToColor);
      SetComboGradientKind(cbPaneGradientKind, GradientType);
      SetPanelColor(pPaneCaptionBackground, CaptionBgColor);
      SetPanelFont(pPaneCaptionFont, CaptionFont);
      SetPanelColor(pPaneCaptionFontColor, CaptionFont.Color);
      SetComboIndex(cbPaneStyle, Ord(Style));
      edPaneHotTrackBrightnessChange.Value := HotTrackBrightnessChange;
    end;

    with Element do
    begin
      SetPanelFont(pItemFont, CaptionFont);

      SetPanelColor(pItemIdleFrame, IdleFrameColor);
      SetPanelColor(pItemIdleGradientFrom, IdleGradientFromColor);
      SetPanelColor(pItemIdleGradientTo, IdleGradientToColor);
      SetComboGradientKind(cbItemIdleGradientKind, IdleGradientType);
      SetPanelColor(pItemIdleCaptionColor, IdleCaptionColor);
      SetPanelColor(pItemIdleInnerDark, IdleInnerDarkColor);
      SetPanelColor(pItemIdleInnerLight, IdleInnerLightColor);
      SetPanelColor(pItemIdleKnobColor, IdleKnobColor);
      SetPanelColor(pItemIdleTrackColor, IdleTrackColor);

      SetPanelColor(pItemHottrackFrame, HottrackFrameColor);
      SetPanelColor(pItemHottrackGradientFrom, HottrackGradientFromColor);
      SetPanelColor(pItemHottrackGradientTo, HottrackGradientToColor);
      SetComboGradientKind(cbItemHottrackGradientKind, HottrackGradientType);
      SetPanelColor(pItemHottrackCaptionColor, HottrackCaptionColor);
      SetPanelColor(pItemHottrackInnerDark, HottrackInnerDarkColor);
      SetPanelColor(pItemHottrackInnerLight, HottrackInnerLightColor);
      SetPanelColor(pItemHotTrackTrackColor, HottrackTrackColor);

      SetPanelColor(pItemActiveFrame, ActiveFrameColor);
      SetPanelColor(pItemActiveGradientFrom, ActiveGradientFromColor);
      SetPanelColor(pItemActiveGradientTo, ActiveGradientToColor);
      SetComboGradientKind(cbItemActiveGradientKind, ActiveGradientType);
      SetPanelColor(pItemActiveCaptionColor, ActiveCaptionColor);
      SetPanelColor(pItemActiveInnerDark, ActiveInnerDarkColor);
      SetPanelColor(pItemActiveInnerLight, ActiveInnerLightColor);
      SetPanelColor(pItemActiveKnobColor, ActiveKnobColor);
      SetPanelColor(pItemActiveTrackColor, ActiveTrackColor);

      cbKnobAsGradient.Checked := KnobAsGradient;

      SetComboIndex(cbItemStyle, Ord(Style));
      edItemHotTrackBrightnessChange.Value := HotTrackBrightnessChange;
    end;

    with Popup do
    begin
      SetComboIndex(cbPopupHotSelectionShape, Ord(SelectionShape));
      SetComboIndex(cbPopupStyle, Ord(Style));

      SetPanelFont(pPopupFont, CaptionFont);
      SetPanelColor(pPopupDisabledCaptionColor, DisabledCaptionColor);
      SetPanelColor(pPopupIdleGradientFromColor, IdleGradientFromColor);
      SetPanelColor(pPopupIdleGradientToColor, IdleGradientToColor);
      SetComboGradientKind(cbPopupIdleGradientKind, IdleGradientType);
      SetPanelColor(pPopupIdleCaptionColor, IdleCaptionColor);
      SetPanelColor(pPopupDividerLineColor, DividerLineColor);

      SetPanelColor(pPopupHottrackFrameColor, HottrackFrameColor);
      SetPanelColor(pPopupHottrackGradientFromColor, HottrackGradientFromColor);
      SetPanelColor(pPopupHottrackGradientToColor, HottrackGradientToColor);
      SetComboGradientKind(cbPopupHottrackGradientKind, HottrackGradientType);
      SetPanelColor(pPopupHottrackCaptionColor, HottrackCaptionColor);

      SetPanelColor(pPopupGutterFrameColor, GutterFrameColor);
      SetPanelColor(pPopupGutterGradientFromColor, GutterGradientFromColor);
      SetPanelColor(pPopupGutterGradientTocolor, GutterGradientToColor);
      SetComboGradientKind(cbPopupGutterGradientKind, GutterGradientType);

      SetPanelColor(pPopupCheckedFrameColor, CheckedFrameColor);
      SetPanelColor(pPopupCheckedGradientFromcolor, CheckedGradientFromColor);
      SetPanelColor(pPopupCheckedGradientTocolor, CheckedGradientToColor);
      SetComboGradientKind(cbPopupCheckedGradientKind, CheckedGradientType);

//      edItemHotTrackBrightnessChange.Value := HotTrackBrightnessChange;
    end;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then begin
    tbPreview.Appearance.Element.ActiveCaptionColor:=(Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveFrameClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.ActiveFrameColor:=(Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.ActiveGradientFromColor:=(Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bImportClick(Sender: TObject);
var
  XML: TLazRibbonXMLParser;
  Node: TLazRibbonXMLNode;
begin
  tbPreview.BeginUpdate;
  XML := TLazRibbonXMLParser.Create;
  try
    XML.Parse(PChar(mXML.text));
    Node := XML['Appearance', false];
    if assigned(Node) then
      tbPreview.Appearance.LoadFromXML(Node);
    LoadAppearance(tbPreview.Appearance);
  finally
    XML.Free;
    tbPreview.EndUpdate;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bResetClick(Sender: TObject);
begin
  tbPreview.Appearance.Reset;
  LoadAppearance(tbPreview.Appearance);
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbItemActiveGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.Element do
    ActiveGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.ActiveGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveInnerDarkClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.ActiveInnerDarkColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveInnerLightClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.ActiveInnerLightColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemHottrackCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.HotTrackCaptionColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemHottrackFrameClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.HotTrackFrameColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemHottrackGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.HotTrackGradientFromColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemHottrackGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.HotTrackGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemHottrackInnerDarkClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.HotTrackInnerDarkColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemHottrackInnerLightClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.HotTrackInnerLightColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemIdleCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.IdleCaptionColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemIdleFrameClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.IdleFrameColor := (Sender as TPanel).Color;
    if cbLinkItem.Checked then
      SetLinkedFrameColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemIdleGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.IdleGradientFromColor := (Sender as TPanel).Color;
    if cbLinkItem.Checked then
      SetLinkedGradientFromColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemIdleGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.IdleGradientToColor := (Sender as TPanel).Color;
    if cbLinkItem.Checked then
      SetLinkedGradientToColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemIdleInnerDarkClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.IdleInnerDarkColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemIdleInnerLightClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Element.IdleInnerLightColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemFontClick(Sender: TObject);
begin
  if ChangeFont(Sender as TPanel) then
    tbPreview.Appearance.Element.CaptionFont.Assign((Sender as TPanel).Font);
  tbPreview.ForceRepaint;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPaneBorderDarkClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Pane.BorderDarkColor := (Sender as TPanel).Color;
    if cbLinkPane.Checked then
      SetLinkedFrameColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPaneBorderLightClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Pane.BorderLightColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPaneCaptionBackgroundClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Pane.CaptionBgColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPaneCaptionFontClick(Sender: TObject);
begin
  if ChangeFont(Sender as TPanel) then
    tbPreview.Appearance.Pane.CaptionFont.Assign((Sender as TPanel).Font);
  tbPreview.ForceRepaint;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPaneCaptionFontColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Pane.CaptionFont.Color:=((Sender as TPanel).Color);
    pPaneCaptionFont.Font.color:=((Sender as TPanel).Color);
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPaneGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Pane.GradientFromColor:=(Sender as TPanel).Color;
    if cbLinkPane.Checked then
      SetLinkedGradientFromColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPaneGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.Pane do
    GradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
  if cbLinkPane.Checked then
    SetLinkedGradientKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPaneStyleChange(Sender: TObject);
begin
  with tbPreview.Appearance.Pane do
    Style := TLazRibbonPaneStyle(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPopupCheckedGradientKindChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.Popup do
    CheckedGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPopupGutterGradientKindChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.Popup do
    GutterGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPopupHotSelectionShapeChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.Popup do
    SelectionShape := TLazRibbonPopupSelectionShape(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPopupStyleChange(Sender: TObject);
begin
  with tbPreview.Appearance.Popup do
    Style := TLazRibbonPopupStyle(SafeComboIndex(Sender as TComboBox));
  tbPreview.Invalidate;
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPopupHotTrackGradientKindChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.Popup do
    HotTrackGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbPopupIdleGradientKindChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.Popup do
    IdleGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPaneGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Pane.GradientToColor:=(Sender as TPanel).Color;
    if cbLinkPane.Checked then
      SetLinkedGradientToColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pTabFrameClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Tab.BorderColor:=(Sender as TPanel).Color;
    if cbLinkTab.checked then
      SetLinkedFrameColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pTabGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Tab.GradientFromColor := (Sender as TPanel).Color;
    if cbLinkTab.Checked then
      SetLinkedGradientFromColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pTabGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Tab.GradientToColor := (Sender as TPanel).Color;
    if cbLinkTab.Checked then
      SetLinkedGradientToColor((Sender as TPanel).Color);
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pTabHeaderFontClick(Sender: TObject);
begin
  if ChangeFont(Sender as TPanel) then begin
    tbPreview.Appearance.Tab.TabHeaderFont.Assign((Sender as TPanel).Font);
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pActiveTabHeaderFontClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Tab.TabHeaderFont.Color := (Sender as TPanel).Color;
    pTabHeaderFont.Font.Color := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pInactiveTabHeaderFontClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Tab.InactiveTabHeaderFontColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveKnobColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.ActiveKnobColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemActiveTrackColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.ActiveTrackColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemHotTrackTrackColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.HotTrackTrackColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pItemIdleKnobColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.Element.IdleKnobColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupCheckedFrameColorClick(
  Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.CheckedFrameColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupCheckedGradientFromColorClick(
  Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.CheckedGradientFromColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupCheckedGradientToColorClick(
  Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.CheckedGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupFontClick(Sender: TObject);
begin
  if ChangeFont(Sender as TPanel) then
    tbPreview.Appearance.Popup.CaptionFont.Assign((Sender as TPanel).Font);
  tbPreview.ForceRepaint;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupGutterFrameColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.GutterFrameColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupGutterGradientFromColorClick(
  Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.GutterGradientFromColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupGutterGradientToColorClick(
  Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.GutterGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupHotTrackFrameColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.HotTrackFrameColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupHotTrackGradientFromColorClick(
  Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.HotTrackGradientFromColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupHotTrackGradientToColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.HotTrackGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupIdleCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.IdleCaptionColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupDisabledCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.DisabledCaptionColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupDividerLineColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.DividerLineColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupIdleGradientFromColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.IdleGradientFromColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupIdleGradientToColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.IdleGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pPopupHotTrackCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.Popup.HotTrackCaptionColor := (Sender as TPanel).Color;
end;

function TfrmLazRibbonAppearanceEditWindow.PickColor(APanel: TPanel): Boolean;
var
  screenDC: HDC;
  cvOrigin: TPoint;
  rgbOrigin: TPoint;
  P: TPoint;
  img: TImage;
begin
  FScreenshotForm := TForm.Create(self);
  FScreenBitmap := TBitmap.Create;
  try
    screenDC := GetDC(0);
    try
      FScreenBitmap.LoadFromDevice(ScreenDC);
    finally
      ReleaseDC(0, screenDC);
    end;

    FScreenshotForm.BorderStyle := bsNone;
    FScreenshotForm.FormStyle := fsStayOnTop;
    FScreenshotForm.SetBounds(0, 0, Screen.Width, Screen.Height);

    img := TImage.Create(FScreenshotForm);
    img.Picture.Bitmap := FScreenBitmap;
    img.Parent := FScreenshotForm;
    img.Align := alClient;

    cvOrigin := ColorView.BoundsRect.TopLeft;
    P := ColorView.ClientToScreen(Point(0, 0));
    ColorView.Parent := FScreenshotForm;
    ColorView.Top := P.Y;
    ColorView.Left := P.X;
    ColorView.Show;

    rgbOrigin := LblRGB.BoundsRect.TopLeft;
    P := LblRGB.ClientToScreen(Point(0, 0));
    LblRGB.Parent := FScreenshotForm;
    LblRGB.Top := P.Y;
    LblRGB.Left := P.X;
    LblRGB.Show;

    //  Screen.Cursors[1] := LoadCursorFromLazarusResource('picker');
    FScreenshotForm.Cursor := crCross; //1;
    img.Cursor := crCross; //1;

    FScreenshotForm.OnKeyDown := ScreenshotKeyDown;
    img.OnMouseUp := ScreenshotMouseUp;
    img.OnMouseDown := ScreenshotMouseDown;
    img.OnMouseMove := ScreenshotMouseMove;

    Result := FScreenshotForm.ShowModal = mrOK;
    if Result then
      SetPanelColor(APanel, ColorView.Brush.Color);

    ColorView.Hide;
    ColorView.Top := cvOrigin.Y;
    ColorView.Left := cvOrigin.X;
    ColorView.Parent := ButtonPanel;

    LblRGB.Hide;
    LblRGB.Top := rgbOrigin.Y;
    LblRGB.Left := rgbOrigin.X;
    LblRGB.Parent := ButtonPanel;

  finally
    FScreenshotForm.Free;
    FScreenBitmap.Free;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.ScreenshotKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: FScreenshotForm.ModalResult := mrCancel;
    VK_RETURN: FScreenshotForm.ModalResult := mrOK;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.ScreenshotMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  ColorView.Brush.Color := FScreenBitmap.Canvas.Pixels[X, Y];
  LblRGB.Caption := '$' + IntToHex(ColorView.Brush.Color, 8);
end;

procedure TfrmLazRibbonAppearanceEditWindow.ScreenshotMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: integer);
begin
  ColorView.Brush.Color := FScreenBitmap.Canvas.Pixels[X, Y];
  LblRGB.Caption := '$' + IntToHex(ColorView.Brush.Color, 8);
end;

procedure TfrmLazRibbonAppearanceEditWindow.ScreenshotMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FScreenshotForm.ModalResult := mrOK;
end;

procedure TfrmLazRibbonAppearanceEditWindow.UpdateImages;
var
  m: double;
  ico: TIcon;
  w, h: Integer;

  procedure AddBestIconToList(AList: TImageList; AWidth, AHeight: Integer);
  var
    BestIndex: Integer;
  begin
    if (AList = nil) or (ico = nil) or ico.Empty then
      Exit;

    BestIndex := ico.GetBestIndexForSize(Size(AWidth, AHeight));
    if BestIndex < 0 then
      Exit;

    try
      ico.Current := BestIndex;
    except
      Exit;
    end;

    if (ico.Width <= 0) or (ico.Height <= 0) then
      Exit;

    AList.Width := ico.Width;
    AList.Height := ico.Height;
    AList.AddIcon(ico);
  end;

begin
  // Use correct icon sizes for the toolbar sample. Do not assume that the
  // executable has an application icon. The SkinEditor currently has no .ico;
  // Application.Icon can therefore be empty and GetBestIndexForSize/Current can
  // raise "List index (0) out of bounds" before the Appearance dialog is shown.
  if ScreenInfo.PixelsPerInchY >= 180 then
    m := 2.0
  else if ScreenInfo.PixelsPerInchY >= 135 then
    m := 1.5
  else
    m := 1.0;

  ico := TIcon.Create;
  try
    try
      if (Application.Icon = nil) or Application.Icon.Empty then
        Exit;

      ico.Assign(Application.Icon);
      if ico.Empty then
        Exit;

      w := round(LargeImages.Width * m);
      h := round(LargeImages.Height * m);
      AddBestIconToList(LargeImages, w, h);

      w := round(SmallImages.Width * m);
      h := round(SmallImages.Height * m);
      AddBestIconToList(SmallImages, w, h);
    except
      // Missing or malformed application icons must not abort the editor.
      // The preview can work without these sample images.
    end;
  finally
    ico.Free;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.UpdateSizes;
var
  w, h, PreviewWidth: Integer;

  function Max(a, b: Integer): Integer;
  begin
    if a > b then Result := a else Result := b;
  end;

  function SafePreviewWidth: Integer;
  begin
    Result := PageControl.Constraints.MinWidth;

    if tbPreview = nil then
      Exit;

    Result := Max(Result, tbPreview.Width);

    // Do not assume that the Ribbon preview has already finished streaming.
    // When this dialog is opened from LazRibbonSkinEditor, OnActivate can fire
    // while the child collections are still empty/rebuilding, and direct access
    // to Tabs[0].Panes[2] raises "List index (0) out of bounds".
    if tbPreview.Tabs.Count = 0 then
      Exit;

    if tbPreview.Tabs[0].Panes.Count <= 2 then
      Exit;

    Result := Max(Result, tbPreview.Tabs[0].Panes[2].Rect.Right + 2);
  end;

begin
  if FAutoSized then
    exit;

  // Update layout of controls
  bOK.AutoSize := false;
  bOK.Width := bCancel.Width;

  ColorView.Width := ColorView.Height;

  h := cbItemStyle.Top + cbItemStyle.Height + cbItemStyle.BorderSpacing.Bottom;
  PageControl.Constraints.MinHeight := PageControl.Height - PageControl.Clientheight + h;

  w := bMenuButtonActiveFramecolor.Left + bMenuButtonActiveFrameColor.Width;
  PageControl.Constraints.MinWidth := PageControl.Width - PageControl.ClientWidth + w;

  Constraints.MinHeight := PageControl.Constraints.MinHeight + gbPreview.Height +
    ButtonPanel.Height + ButtonPanel.BorderSpacing.Top * 2;

  PreviewWidth := SafePreviewWidth;
  Constraints.MinWidth := Max(PreviewWidth, PageControl.Constraints.MinWidth);

  AutoSize := false;
  FAutoSized := true;

  Position := poDesigned;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonIdleFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonIdleFrame) then
    tbPreview.Appearance.MenuButton.IdleFrameColor := pMenuButtonIdleFrame.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonIdleGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonIdleGradientFrom) then
    tbPreview.Appearance.MenuButton.IdleGradientFromColor := pMenuButtonIdleGradientFrom.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonIdleGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonIdleGradientTo) then
    tbPreview.Appearance.MenuButton.IdleGradientToColor := pMenuButtonIdleGradientTo.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonIdleCaptionColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonIdleCaptionColor) then
    tbPreview.Appearance.MenuButton.IdleCaptionColor := pMenuButtonIdleCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonHotTrackFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonHotTrackFrame) then
    tbPreview.Appearance.MenuButton.HotTrackFrameColor := pMenuButtonHotTrackFrame.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonHotTrackGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonHotTrackGradientFrom) then
    tbPreview.Appearance.MenuButton.HotTrackGradientFromColor := pMenuButtonHotTrackGradientFrom.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonHotTrackGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonHotTrackGradientTo) then
    tbPreview.Appearance.MenuButton.HotTrackGradientToColor := pMenuButtonHotTrackGradientTo.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonHotTrackCaptionColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonHotTrackCaptionColor) then
    tbPreview.Appearance.MenuButton.HotTrackCaptionColor := pMenuButtonHotTrackCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonActiveFrameColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonActiveFrame) then
    tbPreview.Appearance.MenuButton.ActiveFrameColor := pMenuButtonActiveFrame.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonActiveGradientFromColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonActiveGradientFrom) then
    tbPreview.Appearance.MenuButton.ActiveGradientFromColor := pMenuButtonActiveGradientFrom.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonActiveGradientToColorClick(Sender: TObject);
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonActiveGradientTo) then
    tbPreview.Appearance.MenuButton.ActiveGradientToColor := pMenuButtonActiveGradientTo.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.bMenuButtonActiveCaptionColorClick(Sender: TObject
  );
begin
  (Sender as TSpeedButton).Down := true;
  if PickColor(pMenuButtonActiveCaptionColor) then
    tbPreview.Appearance.MenuButton.ActiveCaptionColor := pMenuButtonActiveCaptionColor.Color;
  (Sender as TSpeedButton).Down := false;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonIdleFrameClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.IdleFrameColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonIdleGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.IdleGradientFromColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonIdleGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.IdleGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbMenuButtonIdleGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.MenuButton do
    IdleGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonIdleCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.MenuButton.IdleCaptionColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonHottrackFrameClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.HotTrackFrameColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonHottrackGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.HotTrackGradientFromColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonHottrackGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.HotTrackGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbMenuButtonHottrackGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.MenuButton do
    HotTrackGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonHottrackCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
  begin
    tbPreview.Appearance.MenuButton.HotTrackCaptionColor := (Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonActiveFrameClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.ActiveFrameColor:=(Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonActiveGradientFromClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.ActiveGradientFromColor:=(Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonActiveGradientToClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.ActiveGradientToColor := (Sender as TPanel).Color;
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbMenuButtonActiveGradientKindChange(Sender: TObject);
begin
  with tbPreview.Appearance.MenuButton do
    ActiveGradientType := TBackgroundKind(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonActiveCaptionColorClick(Sender: TObject);
begin
  if ChangeColor(Sender as TPanel) then begin
    tbPreview.Appearance.MenuButton.ActiveCaptionColor:=(Sender as TPanel).Color;
    tbPreview.ForceRepaint;
  end;
end;

procedure TfrmLazRibbonAppearanceEditWindow.pMenuButtonFontClick(Sender: TObject);
begin
  if ChangeFont(Sender as TPanel) then
    tbPreview.Appearance.MenuButton.CaptionFont.Assign((Sender as TPanel).Font);
  tbPreview.ForceRepaint;
end;

procedure TfrmLazRibbonAppearanceEditWindow.cbMenuButtonShapeStyleChange(Sender: TObject);
begin
  with tbPreview.Appearance.MenuButton do
    ShapeStyle := TLazRibbonMenuButtonShapeStyle(SafeComboIndex(Sender as TComboBox));
end;

procedure TfrmLazRibbonAppearanceEditWindow.edMenuButtonHotTrackBrightnessChangeChange(
  Sender: TObject);
begin
  with tbPreview.Appearance.MenuButton do
    HotTrackBrightnessChange := (Sender as TSpinEdit).Value;
  tbPreview.Invalidate;
end;

end.
