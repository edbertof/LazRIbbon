unit LazRibbon_Appearance;

{$mode Delphi}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Appearance.pas                                            *
*  Description: Base classes for the appearance classes of the toolbar elements*
*  Copyright:   (c) 2009 by Spook.                                             *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*               See "license.txt" in this installation                         *
*                                                                              *
*  Lazarus port and contributions: Luiz Américo, Werner Pamler, Husker         *
*******************************************************************************)

interface

uses
  Graphics, Classes, Forms, SysUtils, LCLVersion,
  LazRibbon_GUITools, LazRibbon_XMLParser, LazRibbon_XMLTools,
  LazRibbon_Dispatch, LazRibbon_Exceptions;

type
  TLazRibbonPaneStyle = (
    psRectangleFlat, psRectangleEtched, psRectangleRaised,
    psDividerFlat, psDividerEtched, psDividerRaised
  );

  TLazRibbonElementStyle = (esRounded, esRectangle);
  TLazRibbonMenuButtonShapeStyle = (mbssRounded, mbssRectangle);

  TLazRibbonPopupStyle = (psDefault, psGutter);
  TLazRibbonPopupSelectionShape = (ssRounded, ssRectangle);

  TLazRibbonStyle = (
    lazOffice2007Blue,
    lazOffice2007Silver,
    lazOffice2007SilverTurquoise,
    lazMetroLight,
    lazMetroDark,
    lazOffice2007Rose,
    lazOffice2007Sage,
    { StyleMaker:Enum:Begin }
    { StyleMaker:lazOffice2007Bege:Begin }
    lazOffice2007Bege
{ StyleMaker:lazOffice2007Bege:End }
{ StyleMaker:Enum:End }
  );

  { TLazRibbonTabAppearance }

  TLazRibbonTabAppearance = class(TPersistent)
  private
    FDispatch: TLazRibbonBaseAppearanceDispatch;
    FTabHeaderFont: TFont;
    FBorderColor: TColor;
    FGradientFromColor: TColor;
    FGradientToColor: TColor;
    FGradientType: TBackgroundKind;
    FInactiveHeaderFontColor: TColor;
    FCornerRadius: Integer;
    FCaptionHeight: Integer;

    // Getter & setter methods
    function IsCaptionHeightStored: Boolean;
    procedure SetHeaderFont(const Value: TFont);
    procedure SetBorderColor(const Value: TColor);
    procedure SetCaptionHeight(const Value: Integer);
    procedure SetCornerRadius(const Value: Integer);
    procedure SetGradientFromColor(const Value: TColor);
    procedure SetGradientToColor(const Value: TColor);
    procedure SetGradientType(const Value: TBackgroundKind);
    procedure SetInactiveHeaderFontColor(const Value: TColor);

    procedure TabHeaderFontChange(Sender: TObject);

  public
    // *** Constructor, destructor, Assign ***
    // Remarks: Appearance must have Assign because it exists as a
    // published property.
    constructor Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function CalcCaptionHeight: Integer;
    procedure LoadFromXML(Node: TLazRibbonXMLNode);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TLazRibbonXMLNode);
    procedure Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);

  published
    property TabHeaderFont: TFont read FTabHeaderFont write SetHeaderFont;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property CaptionHeight: Integer read FCaptionHeight write SetCaptionHeight stored IsCaptionHeightStored;
    property CornerRadius: Integer read FCornerRadius write SetCornerRadius;
    property GradientFromColor: TColor read FGradientFromColor write SetGradientFromColor;
    property GradientToColor: TColor read FGradientToColor write SetGradientToColor;
    property GradientType: TBackgroundKind read FGradientType write SetGradientType;
    property InactiveTabHeaderFontColor: TColor read FInactiveHeaderFontColor write SetInactiveHeaderFontColor;
  end;


  { TLazRibbonMenuButtonAppearance }

  // Note :
  // For consistancy in appearance drawing with Tabs, CornerRadius and
  // CaptionHeight used to draw Menu Button comes from TLazRibbonTabAppearance.

  TLazRibbonMenuButtonAppearance = class(TPersistent)
  private
    FDispatch: TLazRibbonBaseAppearanceDispatch;
    FCaptionFont: TFont;
    FIdleFrameColor: TColor;
    FIdleGradientFromColor: TColor;
    FIdleGradientToColor: TColor;
    FIdleGradientType: TBackgroundKind;
    FIdleCaptionColor: TColor;
    FHotTrackFrameColor: TColor;
    FHotTrackGradientFromColor: TColor;
    FHotTrackGradientToColor: TColor;
    FHotTrackGradientType: TBackgroundKind;
    FHotTrackCaptionColor: TColor;
    FHotTrackBrightnessChange: Integer;
    FActiveFrameColor: TColor;
    FActiveGradientFromColor: TColor;
    FActiveGradientToColor: TColor;
    FActiveGradientType: TBackgroundKind;
    FActiveCaptionColor: TColor;
    FShapeStyle: TLazRibbonMenubuttonShapeStyle;
    procedure SetActiveCaptionColor(const Value: TColor);
    procedure SetActiveFrameColor(const Value: TColor);
    procedure SetActiveGradientFromColor(const Value: TColor);
    procedure SetActiveGradientToColor(const Value: TColor);
    procedure SetActiveGradientType(const Value: TBackgroundKind);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetHotTrackCaptionColor(const Value: TColor);
    procedure SetHotTrackFrameColor(const Value: TColor);
    procedure SetHotTrackGradientFromColor(const Value: TColor);
    procedure SetHotTrackGradientToColor(const Value: TColor);
    procedure SetHotTrackGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackBrightnessChange(const Value: Integer);
    procedure SetIdleCaptionColor(const Value: TColor);
    procedure SetIdleFrameColor(const Value: TColor);
    procedure SetIdleGradientFromColor(const Value: TColor);
    procedure SetIdleGradientToColor(const Value: TColor);
    procedure SetIdleGradientType(const Value: TBackgroundKind);
    procedure SetShapeStyle(const Value: TLazRibbonMenuButtonShapeStyle);

    procedure CaptionFontChange(Sender: TObject);
  public
    constructor Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromXML(Node: TLazRibbonXMLNode);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TLazRibbonXMLNode);
    procedure Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);

    procedure GetActiveColors(IsChecked: Boolean; out ACaptionColor, AFrameColor,
      AGradientFromColor, AGradientToColor: TColor; out AGradientKind: TBackgroundKind;
      ABrightenBy: Integer = 0);
    procedure GetHotTrackColors(IsChecked: Boolean; out ACaptionColor, AFrameColor,
      AGradientFromColor, AGradientToColor: TColor; out AGradientKind: TBackgroundKind;
      ABrightenBy: Integer = 0);
    procedure GetIdleColors(IsChecked: Boolean; out ACaptionColor, AFrameColor,
      AGradientFromColor, AGradientToColor: TColor; out AGradientKind: TBackgroundKind;
      ABrightenBy: Integer = 0);

  published
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property IdleFrameColor: TColor read FIdleFrameColor write SetIdleFrameColor;
    property IdleGradientFromColor: TColor read FIdleGradientFromColor write SetIdleGradientFromColor;
    property IdleGradientToColor: TColor read FIdleGradientToColor write SetIdleGradientToColor;
    property IdleGradientType: TBackgroundKind read FIdleGradientType write SetIdleGradientType;
    property IdleCaptionColor: TColor read FIdleCaptionColor write SetIdleCaptionColor;
    property HotTrackFrameColor: TColor read FHotTrackFrameColor write SetHotTrackFrameColor;
    property HotTrackGradientFromColor: TColor read FHotTrackGradientFromColor write SetHotTrackGradientFromColor;
    property HotTrackGradientToColor: TColor read FHotTrackGradientToColor write SetHotTrackGradientToColor;
    property HotTrackGradientType: TBackgroundKind read FHotTrackGradientType write SetHotTrackGradientType;
    property HotTrackCaptionColor: TColor read FHotTrackCaptionColor write SetHotTrackCaptionColor;
    property HotTrackBrightnessChange: Integer read FHotTrackBrightnessChange write SetHotTrackBrightnessChange default 20;
    property ActiveFrameColor: TColor read FActiveFrameColor write SetActiveFrameColor;
    property ActiveGradientFromColor: TColor read FActiveGradientFromColor write SetActiveGradientFromColor;
    property ActiveGradientToColor: TColor read FActiveGradientToColor write SetActiveGradientToColor;
    property ActiveGradientType: TBackgroundKind read FActiveGradientType write SetActiveGradientType;
    property ActiveCaptionColor: TColor read FActiveCaptionColor write SetActiveCaptionColor;
    property ShapeStyle: TLazRibbonMenuButtonShapeStyle read FShapeStyle write SetShapeStyle;
  end;


  { TLazRibbonPaneAppearance }

  TLazRibbonPaneAppearance = class(TPersistent)
  private
    FDispatch: TLazRibbonBaseAppearanceDispatch;
    FCaptionFont: TFont;
    FBorderDarkColor: TColor;
    FBorderLightColor: TColor;
    FCaptionBgColor: TColor;
    FGradientFromColor: TColor;
    FGradientToColor: TColor;
    FGradientType: TBackgroundKind;
    FHotTrackBrightnessChange: Integer;
    FStyle: TLazRibbonPaneStyle;
    procedure SetCaptionBgColor(const Value: TColor);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetBorderDarkColor(const Value: TColor);
    procedure SetBorderLightColor(const Value: TColor);
    procedure SetGradientFromColor(const Value: TColor);
    procedure SetGradientToColor(const Value: TColor);
    procedure SetGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackBrightnessChange(const Value: Integer);
    procedure SetStyle(const Value: TLazRibbonPaneStyle);

    procedure CaptionFontChange(Sender: TObject);

  public
    constructor Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromXML(Node: TLazRibbonXMLNode);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TLazRibbonXMLNode);
    procedure Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);

  published
    property BorderDarkColor: TColor read FBorderDarkColor write SetBorderDarkColor;
    property BorderLightColor: TColor read FBorderLightColor write SetBorderLightColor;
    property CaptionBgColor: TColor read FCaptionBgColor write SetCaptionBgColor;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property GradientFromColor: TColor read FGradientFromColor write SetGradientFromColor;
    property GradientToColor: TColor read FGradientToColor write SetGradientToColor;
    property GradientType: TBackgroundKind read FGradientType write SetGradientType;
    property HotTrackBrightnessChange: Integer read FHotTrackBrightnessChange write SetHotTrackBrightnessChange default 20;
    property Style: TLazRibbonPaneStyle read FStyle write SetStyle default psRectangleEtched;
  end;


  { TLazRibbonElementAppearance }
  TLazRibbonElementAppearance = class(TPersistent)
  private
    FDispatch: TLazRibbonBaseAppearanceDispatch;
    FCaptionFont: TFont;
    FIdleFrameColor: TColor;
    FIdleGradientFromColor: TColor;
    FIdleGradientToColor: TColor;
    FIdleGradientType: TBackgroundKind;
    FIdleInnerLightColor: TColor;
    FIdleInnerDarkColor: TColor;
    FIdleCaptionColor: TColor;
    FIdleTrackColor: TColor;
    FIdleKnobColor: TColor;
    FHotTrackFrameColor: TColor;
    FHotTrackGradientFromColor: TColor;
    FHotTrackGradientToColor: TColor;
    FHotTrackGradientType: TBackgroundKind;
    FHotTrackInnerLightColor: TColor;
    FHotTrackInnerDarkColor: TColor;
    FHotTrackTrackColor: TColor;
    FHotTrackCaptionColor: TColor;
    FHotTrackBrightnessChange: Integer;
    FActiveFrameColor: TColor;
    FActiveGradientFromColor: TColor;
    FActiveGradientToColor: TColor;
    FActiveGradientType: TBackgroundKind;
    FActiveInnerLightColor: TColor;
    FActiveInnerDarkColor: TColor;
    FActiveKnobColor: TColor;
    FActiveTrackColor: TColor;
    FActiveCaptionColor: TColor;
    FKnobAsGradient: Boolean;
    FStyle: TLazRibbonElementStyle;
    procedure SetActiveCaptionColor(const Value: TColor);
    procedure SetActiveFrameColor(const Value: TColor);
    procedure SetActiveGradientFromColor(const Value: TColor);
    procedure SetActiveGradientToColor(const Value: TColor);
    procedure SetActiveGradientType(const Value: TBackgroundKind);
    procedure SetActiveInnerDarkColor(const Value: TColor);
    procedure SetActiveInnerLightColor(const Value: TColor);
    procedure SetActiveKnobColor(const Value: TColor);
    procedure SetActiveTrackColor(const Value: TColor);
    procedure SetCaptionFont(const Value: TFont);
    procedure SetHotTrackCaptionColor(const Value: TColor);
    procedure SetHotTrackFrameColor(const Value: TColor);
    procedure SetHotTrackGradientFromColor(const Value: TColor);
    procedure SetHotTrackGradientToColor(const Value: TColor);
    procedure SetHotTrackGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackInnerDarkColor(const Value: TColor);
    procedure SetHotTrackInnerLightColor(const Value: TColor);
    procedure SetHotTrackTrackColor(const Value: TColor);
    procedure SetHotTrackBrightnessChange(const Value: Integer);
    procedure SetIdleCaptionColor(const Value: TColor);
    procedure SetIdleFrameColor(const Value: TColor);
    procedure SetIdleGradientFromColor(const Value: TColor);
    procedure SetIdleGradientToColor(const Value: TColor);
    procedure SetIdleGradientType(const Value: TBackgroundKind);
    procedure SetIdleInnerDarkColor(const Value: TColor);
    procedure SetIdleInnerLightColor(const Value: TColor);
    procedure SetIdleKnobColor(const Value: TColor);
    procedure SetIdleTrackColor(const Value: TColor);
    procedure SetKnobAsGradient(const Value: Boolean);
    procedure SetStyle(const Value: TLazRibbonElementStyle);

    procedure CaptionFontChange(Sender: TObject);

  protected
    procedure BrightenButtonColors(ABrightenBy: Integer;
      var ACaptionColor, AFrameColor, AInnerLightColor, AInnerDarkColor,
      AGradientFromColor, AGradientToColor: TColor);
    procedure BrightenSwitchColors(ABrightenBy: Integer;
      var AKnobColor, ATrackColor: TColor);
  public
    constructor Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure LoadFromXML(Node: TLazRibbonXMLNode);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TLazRibbonXMLNode);
    procedure Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);

    procedure GetActiveButtonColors(IsChecked: Boolean; out ACaptionColor, AFrameColor,
      AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TColor;
      out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
    procedure GetHotTrackButtonColors(IsChecked: Boolean; out ACaptionColor, AFrameColor,
      AInnerLightColor, AInnerDarkColor,
      AGradientFromColor, AGradientToColor: TColor; out AGradientKind: TBackgroundKind;
      ABrightenBy: Integer = 0);
    procedure GetIdleButtonColors(IsChecked: Boolean; out ACaptionColor, AFrameColor,
      AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor: TColor;
      out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);

    procedure GetActiveSwitchColors(IsChecked: Boolean;
      out AKnobColor, ATrackColor: TColor; ABrightenBy: Integer = 0);
    procedure GetHotTrackSwitchColors(IsChecked: Boolean;
      out AKnobColor, ATrackColor: TColor; ABrightenBy: Integer = 0);
    procedure GetIdleSwitchColors(IsChecked: Boolean;
      out AKnobColor, ATrackColor: TColor; ABrightenBy: Integer = 0);

  published
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property IdleFrameColor: TColor read FIdleFrameColor write SetIdleFrameColor;
    property IdleGradientFromColor: TColor read FIdleGradientFromColor write SetIdleGradientFromColor;
    property IdleGradientToColor: TColor read FIdleGradientToColor write SetIdleGradientToColor;
    property IdleGradientType: TBackgroundKind read FIdleGradientType write SetIdleGradientType;
    property IdleInnerLightColor: TColor read FIdleInnerLightColor write SetIdleInnerLightColor;
    property IdleInnerDarkColor: TColor read FIdleInnerDarkColor write SetIdleInnerDarkColor;
    property IdleKnobColor: TColor read FIdleKnobColor write SetIdleKnobColor;
    property IdleTrackColor: TColor read FIdleTrackColor write SetIdleTrackColor;
    property IdleCaptionColor: TColor read FIdleCaptionColor write SetIdleCaptionColor;
    property HotTrackFrameColor: TColor read FHotTrackFrameColor write SetHotTrackFrameColor;
    property HotTrackGradientFromColor: TColor read FHotTrackGradientFromColor write SetHotTrackGradientFromColor;
    property HotTrackGradientToColor: TColor read FHotTrackGradientToColor write SetHotTrackGradientToColor;
    property HotTrackGradientType: TBackgroundKind read FHotTrackGradientType write SetHotTrackGradientType;
    property HotTrackInnerLightColor: TColor read FHotTrackInnerLightColor write SetHotTrackInnerLightColor;
    property HotTrackInnerDarkColor: TColor read FHotTrackInnerDarkColor write SetHotTrackInnerDarkColor;
    property HotTrackTrackColor: TColor read FHotTracKTrackColor write SetHotTrackTrackColor;
    property HotTrackCaptionColor: TColor read FHotTrackCaptionColor write SetHotTrackCaptionColor;
    property HotTrackBrightnessChange: Integer read FHotTrackBrightnessChange write SetHotTrackBrightnessChange default 20;
    property ActiveFrameColor: TColor read FActiveFrameColor write SetActiveFrameColor;
    property ActiveGradientFromColor: TColor read FActiveGradientFromColor write SetActiveGradientFromColor;
    property ActiveGradientToColor: TColor read FActiveGradientToColor write SetActiveGradientToColor;
    property ActiveGradientType: TBackgroundKind read FActiveGradientType write SetActiveGradientType;
    property ActiveInnerLightColor: TColor read FActiveInnerLightColor write SetActiveInnerLightColor;
    property ActiveInnerDarkColor: TColor read FActiveInnerDarkColor write SetActiveInnerDarkColor;
    property ActiveKnobColor: TColor read FActiveKnobColor write SetActiveKnobColor;
    property ActiveTrackColor: TColor read FActiveTrackColor write SetActiveTrackColor;
    property ActiveCaptionColor: TColor read FActiveCaptionColor write SetActiveCaptionColor;
    property KnobAsGradient: Boolean read FKnobAsGradient write SetKnobAsGradient default false;
    property Style: TLazRibbonElementStyle read FStyle write SetStyle;
  end;

  TLazRibbonPopupMenuAppearance = class(TPersistent)
  private
    FDispatch: TLazRibbonBaseAppearanceDispatch;
    FCaptionFont: TFont;
    FCheckedFrameColor: TColor;
    FCheckedGradientFromColor: TColor;
    FCheckedGradientToColor: TColor;
    FCheckedGradientType: TBackgroundKind;
    FDisabledCaptionColor: TColor;
    FDividerLineColor: TColor;
    FGutterFrameColor: TColor;
    FGutterGradientFromColor: TColor;
    FGutterGradientToColor: TColor;
    FGutterGradientType: TBackgroundKind;
    FHotTrackCaptionColor: TColor;
    FHotTrackFrameColor: TColor;
    FHotTrackGradientFromColor: TColor;
    FHotTrackGradientToColor: TColor;
    FHotTrackGradientType: TBackgroundKind;
    FIdleCaptionColor: TColor;
    FIdleGradientFromColor: TColor;
    FIdleGradientToColor: TColor;
    FIdleGradientType: TBackgroundKind;
    FStyle: TLazRibbonPopupStyle;
    FSelShape: TLazRibbonPopupSelectionShape;
    procedure SetCaptionFont(const Value: TFont);
    procedure SetCheckedFrameColor(const Value: TColor);
    procedure SetCheckedGradientFromColor(const Value: TColor);
    procedure SetCheckedGradientToColor(const Value: TColor);
    procedure SetCheckedGradientType(const Value: TBackgroundKind);
    procedure SetDisabledCaptionColor(const Value: TColor);
    procedure SetDividerLineColor(const Value: TColor);
    procedure SetGutterFrameColor(const Value: TColor);
    procedure SetGutterGradientFromColor(const Value: TColor);
    procedure SetGutterGradientToColor(const Value: TColor);
    procedure SetGutterGradientType(const Value: TBackgroundKind);
    procedure SetHotTrackCaptionColor(const Value: TColor);
    procedure SetHotTrackFrameColor(const Value: TColor);
    procedure SetHotTrackGradientFromColor(const Value: TColor);
    procedure SetHotTrackGradientToColor(const Value: TColor);
    procedure SetHotTrackGradientType(const Value: TBackgroundKind);
    procedure SetIdleCaptionColor(const Value: TColor);
    procedure SetIdleGradientFromColor(const Value: TColor);
    procedure SetIdleGradientToColor(const Value: TColor);
    procedure SetIdleGradientType(const Value: TBackgroundKind);
    procedure SetSelShape(const Value: TLazRibbonPopupSelectionShape);
    procedure SetStyle(const Value: TLazRibbonPopupStyle);
  protected
    procedure CaptionFontChange(Sender: TObject);
  public
    constructor Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromXML(Node: TLazRibbonXMLNode);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TLazRibbonXMLNode);
    procedure Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);
  published
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property CheckedFrameColor: TColor read FCheckedFrameColor write SetCheckedFrameColor;
    property CheckedGradientFromColor: TColor read FCheckedGradientFromColor write SetCheckedGradientFromColor;
    property CheckedGradientToColor: TColor read FCheckedGradientToColor write SetCheckedGradientToColor;
    property CheckedGradientType: TBackgroundKind read FCheckedGradientType write SetCheckedGradientType;
    property DisabledCaptionColor: TColor read FDisabledCaptionColor write SetDisabledCaptionColor;
    property DividerLineColor: TColor read FDividerLineColor write SetDividerLineColor;
    property GutterFrameColor: TColor read FGutterFrameColor write SetGutterFrameColor;
    property GutterGradientFromColor: TColor read FGutterGradientFromColor write SetGutterGradientFromColor;
    property GutterGradientToColor: TColor read FGutterGradientToColor write SetGutterGradientToColor;
    property GutterGradientType: TBackgroundKind read FGutterGradientType write SetGutterGradientType;
    property HotTrackCaptionColor: TColor read FHotTrackCaptionColor write SetHotTrackCaptionColor;
    property HotTrackFrameColor: TColor read FHotTrackFrameColor write SetHotTrackFrameColor;
    property HotTrackGradientFromColor: TColor read FHotTrackGradientFromColor write SetHotTrackGradientFromColor;
    property HotTrackGradientToColor: TColor read FHotTrackGradientToColor write SetHotTrackGradientToColor;
    property HotTrackGradientType: TBackgroundKind read FHotTrackGradientType write SetHotTrackGradientType;
    property IdleCaptionColor: TColor read FIdleCaptionColor write SetIdleCaptionColor;
    property IdleGradientFromColor: TColor read FIdleGradientFromColor write SetIdleGradientFromColor;
    property IdleGradientToColor: TColor read FIdleGradientToColor write SetIdleGradientToColor;
    property IdleGradientType: TBackgroundKind read FIdleGradientType write SetIdleGradientType;
    property SelectionShape: TLazRibbonPopupSelectionShape read FSelShape write SetSelShape;
    property Style: TLazRibbonPopupStyle read FStyle write SetStyle;
  end;


  { TLazRibbonToolbarAppearance }

  TLazRibbonToolbarAppearance = class;

  TLazRibbonToolbarAppearanceDispatch = class(TLazRibbonBaseAppearanceDispatch)
  private
    FToolbarAppearance: TLazRibbonToolbarAppearance;
  public
    constructor Create(AToolbarAppearance: TLazRibbonToolbarAppearance);
    procedure NotifyAppearanceChanged; override;
  end;

  TLazRibbonToolbarAppearance = class(TPersistent)
  private
    FAppearanceDispatch: TLazRibbonToolbarAppearanceDispatch;
    FTab: TLazRibbonTabAppearance;
    FMenuButton: TLazRibbonMenuButtonAppearance;
    FPane: TLazRibbonPaneAppearance;
    FElement: TLazRibbonElementAppearance;
    FPopup: TLazRibbonPopupMenuAppearance;
    FDispatch: TLazRibbonBaseAppearanceDispatch;
    procedure SetElementAppearance(const Value: TLazRibbonElementAppearance);
    procedure SetPaneAppearance(const Value: TLazRibbonPaneAppearance);
    procedure SetTabAppearance(const Value: TLazRibbonTabAppearance);
    procedure SetPopupAppearance(const Value: TLazRibbonPopupMenuAppearance);
    procedure SetMenuButtonAppearance(const Value: TLazRibbonMenuButtonAppearance);
  public
    constructor Create(ADispatch: TLazRibbonBaseAppearanceDispatch); reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure NotifyAppearanceChanged;
    procedure Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);
    procedure SaveToPascal(AList: TStrings);
    procedure SaveToXML(Node: TLazRibbonXMLNode);
    procedure LoadFromXML(Node: TLazRibbonXMLNode);
  published
    property Tab: TLazRibbonTabAppearance read FTab write SetTabAppearance;
    property MenuButton: TLazRibbonMenuButtonAppearance read FMenuButton write SetMenuButtonAppearance;
    property Pane: TLazRibbonPaneAppearance read FPane write SetPaneAppearance;
    property Element: TLazRibbonElementAppearance read FElement write SetElementAppearance;
    property Popup: TLazRibbonPopupMenuAppearance read FPopup write SetPopupAppearance;
  end;

procedure SetDefaultFont({%H-}AFont: TFont);


implementation

uses
  LCLIntf, LCLType, typinfo, LazRibbon_Const, LazRibbon_GraphTools;

function GradientTypeName(AGradientType: TBackgroundKind): String;
begin
  Result := GetEnumName(TypeInfo(TBackgroundKind), ord(AGradientType));
end;

procedure SaveFontToPascal(AList: TStrings; AFont: TFont; AName: String);
var
  sty: String;
begin
  sty := '';
  if fsBold in AFont.Style then sty := sty + 'fsBold,';
  if fsItalic in AFont.Style then sty := sty + 'fsItalic,';
  if fsUnderline in AFont.Style then sty := sty + 'fsUnderline,';
  if fsStrikeout in AFont.Style then sty := sty + 'fsStrikeout,';
  if sty <> '' then Delete(sty, Length(sty), 1);
  with AList do begin
    Add(AName + '.Name := ''' + AFont.Name + ''';');
    Add(AName + '.Size := ' + IntToStr(AFont.Size) + ';');
    Add(AName + '.Style := [' + sty + '];');
    Add(AName + '.Color := $' + IntToHex(AFont.Color, 8) + ';');
  end;
end;

{ TLazRibbonBaseToolbarAppearance }

constructor TLazRibbonTabAppearance.Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FCaptionHeight := TOOLBAR_TAB_CAPTIONS_HEIGHT;
  FCornerRadius := 0;
  FTabHeaderFont := TFont.Create;
  FTabHeaderFont.OnChange := TabHeaderFontChange;
  Reset;
end;

destructor TLazRibbonTabAppearance.Destroy;
begin
  FTabHeaderFont.Free;
  inherited;
end;

procedure TLazRibbonTabAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TLazRibbonTabAppearance;
begin
  if Source is TLazRibbonTabAppearance then
  begin
     SrcAppearance := TLazRibbonTabAppearance(Source);
     FTabHeaderFont.Assign(SrcAppearance.TabHeaderFont);
     FBorderColor := SrcAppearance.BorderColor;
     FCaptionHeight := SrcAppearance.CaptionHeight;
     FCornerRadius := SrcAppearance.CornerRadius;
     FGradientFromColor := SrcAppearance.GradientFromColor;
     FGradientToColor := SrcAppearance.GradientToColor;
     FGradientType := SrcAppearance.GradientType;
     FInactiveHeaderFontColor := SrcAppearance.InactiveTabHeaderFontColor;

     if FDispatch <> nil then
        FDispatch.NotifyAppearanceChanged;
  end else
    raise AssignException.Create('TLazRibbonToolbarAppearance.Assign: Cannot assign the object '+Source.ClassName+' to TLazRibbonToolbarAppearance!');
end;

function TLazRibbonTabAppearance.CalcCaptionHeight: Integer;
var
  h: Integer;
begin
  if FCaptionHeight < 0 then
  begin
     if FTabHeaderFont.Size = 0 then
       h := GetFontData(FTabHeaderFont.Handle).Height
     else
       h := FTabHeaderFont.Height;
     Result := abs(h) + LazScaleY(10, 96, Screen.PixelsPerInch);
  end
  else
    Result := FCaptionHeight;
end;

function TLazRibbonTabAppearance.IsCaptionHeightStored: Boolean;
begin
  Result := FCaptionHeight <> TOOLBAR_TAB_CAPTIONS_HEIGHT; // this is -1
end;

procedure TLazRibbonTabAppearance.LoadFromXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['TabHeaderFont',false];
  if Assigned(Subnode) then
    TLazRibbonXMLTools.Load(Subnode, FTabHeaderFont);

  Subnode := Node['BorderColor',false];
  if Assigned(Subnode) then
    FBorderColor := Subnode.TextAsColor;

  SubNode := Node['CaptionHeight', false];
  if Assigned(SubNode) then
    FCaptionHeight := SubNode.TextAsInteger;

  SubNode := Node['CornerRadius', false];
  if Assigned(SubNode) then
    FCornerRadius := SubNode.TextAsInteger;

  Subnode := Node['GradientFromColor',false];
  if Assigned(Subnode) then
    FGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['GradientToColor',false];
  if Assigned(Subnode) then
    FGradientToColor := Subnode.TextAsColor;

  Subnode := Node['GradientType',false];
  if Assigned(Subnode) then
    FGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['InactiveTabHeaderFontColor', false];
  if Assigned(Subnode) then
    FInactiveHeaderFontColor := Subnode.TextAsColor;
end;

procedure TLazRibbonTabAppearance.Reset(AStyle: TLazRibbonStyle);
begin
  SetDefaultFont(FTabHeaderFont);

  case AStyle of
    lazOffice2007Blue:
      begin
        FTabHeaderFont.Color := rgb(21, 66, 139);
        FBorderColor := rgb(141, 178, 227);
        FCaptionHeight := -1;
        FCornerRadius := LazRibbon_Const.TabCornerRadius;
        FGradientFromColor := rgb(222, 232, 245);
        FGradientToColor := rgb(199, 216, 237);
        FGradientType := bkConcave;
        FInactiveHeaderFontColor := FTabHeaderFont.Color;
      end;

    lazOffice2007Silver,
    lazOffice2007SilverTurquoise:
      begin
        FTabHeaderFont.Style := [];
        FTabHeaderFont.Color := $007A534C;
        FBorderColor := $00BEBEBE;
        FCaptionHeight := -1;
        FCornerRadius := LazRibbon_Const.TabCornerRadius;
        FGradientFromColor := $00F4F2F2;
        FGradientToColor := $00EFE6E1;
        FGradientType := bkConcave;
        FInactiveHeaderFontColor := $007A534C;
      end;

    lazMetroLight:
      begin
        FTabHeaderFont.Style := [];
        FTabHeaderFont.Color := $0095572A;
        FBorderColor := $00D2D0CF;
        FCaptionHeight := -1;
        FCornerRadius := 0;
        FGradientFromColor := $00F1F1F1;
        FGradientToColor := $00F1F1F1;
        FGradientType := bkSolid;
        FInactiveHeaderFontColor := $00696969;
      end;

    lazMetroDark:
      begin
        FTabHeaderFont.Style := [];
        FTabHeaderFont.Color := $00FFFFFF;
        FBorderColor := $00000000;
        FCaptionHeight := -1;
        FCornerRadius := 0;
        FGradientFromColor := $00464646;
        FGradientToColor := $00464646;
        FGradientType := bkSolid;
        FInactiveHeaderFontColor := $00787878;
      end;

    lazOffice2007Rose:
      begin
        FTabHeaderFont.Color := rgb(139, 21, 66);
        FBorderColor := rgb(227, 141, 178);
        FCaptionHeight := -1;
        FCornerRadius := LazRibbon_Const.TabCornerRadius;
        FGradientFromColor := rgb(245, 222, 232);
        FGradientToColor := rgb(237, 199, 216);
        FGradientType := bkConcave;
        FInactiveHeaderFontColor := FTabHeaderFont.Color;
      end;

    lazOffice2007Sage:
      begin
        FTabHeaderFont.Color := rgb(21, 139, 66);
        FBorderColor := rgb(141, 227, 178);
        FCaptionHeight := -1;
        FCornerRadius := LazRibbon_Const.TabCornerRadius;
        FGradientFromColor := rgb(222, 245, 232);
        FGradientToColor := rgb(199, 237, 216);
        FGradientType := bkConcave;
        FInactiveHeaderFontColor := FTabHeaderFont.Color;
      end;

    { StyleMaker:TabReset:Begin }
    { StyleMaker:lazOffice2007Bege:Begin }
    lazOffice2007Bege:
      begin
        TabHeaderFont.Name := 'default';
        TabHeaderFont.Size := 0;
        TabHeaderFont.Style := [];
        TabHeaderFont.Color := $00000000;
        BorderColor := $0064748C;
        CaptionHeight := -1;
        CornerRadius := 2;
        GradientFromColor := $00F5E8DE;
        GradientToColor := $00EDD8C7;
        GradientType := bkSolid;
        InactiveTabHeaderFontColor := $00000000;
      end;
{ StyleMaker:lazOffice2007Bege:End }
{ StyleMaker:TabReset:End }
  end;
end;

procedure TLazRibbonTabAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do begin
    Add('  with Tab do begin');
    SaveFontToPascal(AList, FTabHeaderFont, '    TabHeaderFont');
    Add('    BorderColor := $' + IntToHex(FBorderColor, 8) + ';');
    Add('    CaptionHeight := ' + IntToStr(FCaptionHeight) + ';');
    Add('    CornerRadius := ' + IntToStr(FCornerRadius) + ';');
    Add('    GradientFromColor := $' + IntToHex(FGradientFromColor, 8) + ';');
    Add('    GradientToColor := $' + IntToHex(FGradientToColor, 8) + ';');
    Add('    GradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FGradientType)) + ';');
    Add('    InactiveTabHeaderFontColor := $' + IntToHex(FInactiveHeaderFontColor, 8) + ';');
    Add('  end;');
  end;
end;

procedure TLazRibbonTabAppearance.SaveToXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not(assigned(Node)) then
    exit;

  Subnode := Node['TabHeaderFont',true];
  TLazRibbonXMLTools.Save(Subnode, FTabHeaderFont);

  Subnode := Node['BorderColor',true];
  Subnode.TextAsColor := FBorderColor;

  SubNode := Node['CaptionHeight', true];
  SubNode.TextAsInteger := FCaptionHeight;

  SubNode := Node['CornerRadius',true];
  SubNode.TextAsInteger := FCornerRadius;

  Subnode := Node['GradientFromColor',true];
  Subnode.TextAsColor := FGradientFromColor;

  Subnode := Node['GradientToColor',true];
  Subnode.TextAsColor := FGradientToColor;

  Subnode := Node['GradientType',true];
  Subnode.TextAsInteger := integer(FGradientType);

  Subnode := Node['InactiveTabHeaderFontColor', true];
  Subnode.TextAsColor := FInactiveHeaderFontColor;
end;

procedure TLazRibbonTabAppearance.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.SetCaptionHeight(const Value: Integer);
begin
  if Value < -1 then FCaptionHeight := -1 else FCaptionHeight := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.SetCornerRadius(const Value: Integer);
begin
  FCornerRadius := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.SetGradientFromColor(const Value: TColor);
begin
  FGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.SetGradientToColor(const Value: TColor);
begin
  FGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.SetGradientType(const Value: TBackgroundKind);
begin
  FGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.SetHeaderFont(const Value: TFont);
begin
  FTabHeaderFont.Assign(Value);
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.SetInactiveHeaderFontColor(const Value: TColor);
begin
  FInactiveHeaderFontColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonTabAppearance.TabHeaderFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;


{ TLazRibbonPaneAppearance }

constructor TLazRibbonPaneAppearance.Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChange := CaptionFontChange;
  FHotTrackBrightnessChange := 20;
  FStyle := psRectangleEtched;
  Reset;
end;

destructor TLazRibbonPaneAppearance.Destroy;
begin
  FCaptionFont.Free;
  inherited Destroy;
end;

procedure TLazRibbonPaneAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TLazRibbonPaneAppearance;
begin
  if Source is TLazRibbonPaneAppearance then
  begin
    SrcAppearance := TLazRibbonPaneAppearance(Source);

    FCaptionFont.Assign(SrcAppearance.CaptionFont);
    FBorderDarkColor := SrcAppearance.BorderDarkColor;
    FBorderLightColor := SrcAppearance.BorderLightColor;
    FCaptionBgColor := SrcAppearance.CaptionBgColor;
    FGradientFromColor := SrcAppearance.GradientFromColor;
    FGradientToColor := SrcAppearance.GradientToColor;
    FGradientType := SrcAppearance.GradientType;
    FHotTrackBrightnessChange := SrcAppearance.HotTrackBrightnessChange;
    FStyle := SrcAppearance.Style;

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end else
    raise AssignException.Create('TLazRibbonPaneAppearance.Assign: Cannot assign the class '+Source.ClassName+' to TLazRibbonPaneAppearance!');
end;

procedure TLazRibbonPaneAppearance.CaptionFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.LoadFromXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not(Assigned(Node)) then
    exit;

  Subnode := Node['CaptionFont', false];
  if Assigned(Subnode) then
    TLazRibbonXMLTools.Load(Subnode, FCaptionFont);

  Subnode := Node['BorderDarkColor', false];
  if Assigned(Subnode) then
    FBorderDarkColor := Subnode.TextAsColor;

  Subnode := Node['BorderLightColor', false];
  if Assigned(Subnode) then
    FBorderLightColor := Subnode.TextAsColor;

  Subnode := Node['CaptionBgColor', false];
  if Assigned(Subnode) then
    FCaptionBgColor := Subnode.TextAsColor;

  Subnode := Node['GradientFromColor', false];
  if Assigned(Subnode) then
    FGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['GradientToColor', false];
  if Assigned(Subnode) then
    FGradientToColor := Subnode.TextAsColor;

  Subnode := Node['GradientType', false];
  if Assigned(Subnode) then
    FGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['HotTrackBrightnessChange', false];
  if Assigned(Subnode) then
    FHotTrackBrightnessChange := Subnode.TextAsInteger;

  Subnode := Node['Style', false];
  if Assigned(Subnode) then
    FStyle := TLazRibbonPaneStyle(SubNode.TextAsInteger);
end;

procedure TLazRibbonPaneAppearance.Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);
begin
  SetDefaultFont(FCaptionFont);

  case AStyle of
    lazOffice2007Blue:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := rgb(21, 66, 139);
        FBorderDarkColor := rgb(158, 190, 218);
        FBorderLightColor := rgb(237, 242, 248);
        FCaptionBgColor := rgb(194, 217, 241);
        FGradientFromColor := rgb(222, 232, 245);
        FGradientToColor := rgb(199, 216, 237);
        FGradientType := bkConcave;
        FHotTrackBrightnessChange := 20;
        FStyle := psRectangleEtched;
      end;

    lazOffice2007Silver,
    lazOffice2007SilverTurquoise:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $00363636;
        FBorderDarkColor := $00A6A6A6;
        FBorderLightColor := $00FFFFFF;
        FCaptionBgColor := $00E4E4E4;
        FGradientFromColor := $00F8F8F8;
        FGradientToColor := $00E9E9E9;
        FGradientType := bkConcave;
        FHotTrackBrightnessChange := 20;
        FStyle := psRectangleEtched;
      end;

    lazMetroLight:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $00696969;
        FBorderDarkColor := $00D2D0CF;
        FBorderLightColor := $00F8F2ED;
        FCaptionBgColor := $00F1F1F1;
        FGradientFromColor := $00F1F1F1;
        FGradientToColor := $00F1F1F1;
        FGradientType := bkSolid;
        FHotTrackBrightnessChange := 0;
        FStyle := psDividerFlat;
      end;

    lazMetroDark:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $00FFFFFF;
        FBorderDarkColor := $008C8482;
        FBorderLightColor := $00A29D9B;
        FCaptionBgColor := $00464646;
        FGradientFromColor := $00464646;
        FGradientToColor := $00F1F1F1;
        FGradientType := bkSolid;
        FHotTrackBrightnessChange := 0;
        FStyle := psDividerFlat;
      end;

    lazOffice2007Rose:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := rgb(139, 21, 66);
        FBorderDarkColor := rgb(218, 158, 190);
        FBorderLightColor := rgb(248, 237, 242);
        FCaptionBgColor := rgb(241, 194, 217);
        FGradientFromColor := rgb(245, 222, 232);
        FGradientToColor := rgb(237, 199, 216);
        FGradientType := bkConcave;
        FHotTrackBrightnessChange := 20;
        FStyle := psRectangleEtched;
      end;

    lazOffice2007Sage:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := rgb(21, 139, 66);
        FBorderDarkColor := rgb(158, 218, 190);
        FBorderLightColor := rgb(237, 248, 242);
        FCaptionBgColor := rgb(194, 241, 217);
        FGradientFromColor := rgb(222, 245, 232);
        FGradientToColor := rgb(199, 237, 216);
        FGradientType := bkConcave;
        FHotTrackBrightnessChange := 20;
        FStyle := psRectangleEtched;
      end;

    { StyleMaker:PaneReset:Begin }
    { StyleMaker:lazOffice2007Bege:Begin }
    lazOffice2007Bege:
      begin
        CaptionFont.Name := 'default';
        CaptionFont.Size := 0;
        CaptionFont.Style := [];
        CaptionFont.Color := $008B4215;
        BorderDarkColor := $0097A9BA;
        BorderLightColor := $00D5E7ED;
        CaptionBgColor := $00B8D4E2;
        GradientFromColor := $00DCE9ED;
        GradientToColor := $00D2E3E9;
        GradientType := bkVerticalGradient;
        HotTrackBrightnessChange := 20;
        Style := psRectangleEtched;
      end;
{ StyleMaker:lazOffice2007Bege:End }
{ StyleMaker:PaneReset:End }
  end;
end;

procedure TLazRibbonPaneAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do begin
    Add('  with Pane do begin');
    SaveFontToPascal(AList, FCaptionFont, '    CaptionFont');
    Add('    BorderDarkColor := $' + IntToHex(FBorderDarkColor, 8) + ';');
    Add('    BorderLightColor := $' + IntToHex(FBorderLightColor, 8) + ';');
    Add('    CaptionBgColor := $' + IntToHex(FcaptionBgColor, 8) + ';');
    Add('    GradientFromColor := $' + IntToHex(FGradientFromColor, 8) + ';');
    Add('    GradientToColor := $' + IntToHex(FGradientToColor, 8) + ';');
    Add('    GradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FGradientType)) + ';');
    Add('    HotTrackBrightnessChange := ' + IntToStr(FHotTrackBrightnessChange) + ';');
    Add('    Style := ' + GetEnumName(TypeInfo(TLazRibbonPaneStyle), ord(FStyle)) +';');
    Add('  end;');
  end;
end;

procedure TLazRibbonPaneAppearance.SaveToXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['CaptionFont',true];
  TLazRibbonXMLTools.Save(Subnode, FCaptionFont);

  Subnode := Node['BorderDarkColor',true];
  Subnode.TextAsColor := FBorderDarkColor;

  Subnode := Node['BorderLightColor',true];
  Subnode.TextAsColor := FBorderLightColor;

  Subnode := Node['CaptionBgColor',true];
  Subnode.TextAsColor := FCaptionBgColor;

  Subnode := Node['GradientFromColor',true];
  Subnode.TextAsColor := FGradientFromColor;

  Subnode := Node['GradientToColor',true];
  Subnode.TextAsColor := FGradientToColor;

  Subnode := Node['GradientType',true];
  Subnode.TextAsInteger := integer(FGradientType);

  Subnode := Node['HotTrackBrightnessChange',true];
  Subnode.TextAsInteger := FHotTrackBrightnessChange;

  Subnode := Node['Style', true];
  Subnode.TextAsInteger := integer(FStyle);
end;

procedure TLazRibbonPaneAppearance.SetBorderDarkColor(const Value: TColor);
begin
  FBorderDarkColor := Value;
  if Assigned(FDispatch) then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetBorderLightColor(const Value: TColor);
begin
  FBorderLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetCaptionBgColor(const Value: TColor);
begin
  FCaptionBgColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont.Assign(Value);
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetGradientFromColor(const Value: TColor);
begin
  FGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetGradientToColor(const Value: TColor);
begin
  FGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetGradientType(const Value: TBackgroundKind);
begin
  FGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetHotTrackBrightnessChange(const Value: Integer);
begin
  FHotTrackBrightnessChange := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPaneAppearance.SetStyle(const Value: TLazRibbonPaneStyle);
begin
  FStyle := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;


{ TLazRibbonElementAppearance }

constructor TLazRibbonElementAppearance.Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChange := CaptionFontChange;
  FHotTrackBrightnessChange := 40;
  Reset;
end;

destructor TLazRibbonElementAppearance.Destroy;
begin
  FCaptionFont.Free;
  inherited Destroy;
end;

procedure TLazRibbonElementAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TLazRibbonElementAppearance;
begin
  if Source is TLazRibbonElementAppearance then
  begin
    SrcAppearance := TLazRibbonElementAppearance(Source);

    FCaptionFont.Assign(SrcAppearance.CaptionFont);
    FIdleFrameColor := SrcAppearance.IdleFrameColor;
    FIdleGradientFromColor := SrcAppearance.IdleGradientFromColor;
    FIdleGradientToColor := SrcAppearance.IdleGradientToColor;
    FIdleGradientType := SrcAppearance.IdleGradientType;
    FIdleInnerLightColor := SrcAppearance.IdleInnerLightColor;
    FIdleInnerDarkColor := SrcAppearance.IdleInnerDarkColor;
    FIdleKnobColor := SrcAppearance.IdleKnobColor;
    FIdleTrackColor := SrcAppearance.IdleTrackColor;
    FIdleCaptionColor := SrcAppearance.IdleCaptionColor;
    FHotTrackFrameColor := SrcAppearance.HotTrackFrameColor;
    FHotTrackGradientFromColor := SrcAppearance.HotTrackGradientFromColor;
    FHotTrackGradientToColor := SrcAppearance.HotTrackGradientToColor;
    FHotTrackGradientType := SrcAppearance.HotTrackGradientType;
    FHotTrackInnerLightColor := SrcAppearance.HotTrackInnerLightColor;
    FHotTrackInnerDarkColor := SrcAppearance.HotTrackInnerDarkColor;
    FHotTrackTrackColor := SrcAppearance.HotTrackTrackColor;
    FHotTrackCaptionColor := SrcAppearance.HotTrackCaptionColor;
    FHotTrackBrightnessChange := SrcAppearance.HotTrackBrightnessChange;
    FActiveFrameColor := SrcAppearance.ActiveFrameColor;
    FActiveGradientFromColor := SrcAppearance.ActiveGradientFromColor;
    FActiveGradientToColor := SrcAppearance.ActiveGradientToColor;
    FActiveGradientType := SrcAppearance.ActiveGradientType;
    FActiveInnerLightColor := SrcAppearance.ActiveInnerLightColor;
    FActiveInnerDarkColor := SrcAppearance.ActiveInnerDarkColor;
    FActiveKnobColor := SrcAppearance.ActiveKnobcolor;
    FActiveTrackColor := SrcAppearance.ActiveTrackColor;
    FActiveCaptionColor := SrcAppearance.ActiveCaptionColor;
    FKnobAsGradient := SrcAppearance.KnobAsGradient;
    FStyle := SrcAppearance.Style;

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end else
    raise AssignException.Create('TLazRibbonElementAppearance.Assign: Cannot assign '+Source.ClassName+' to TLazRibbonElementAppearance!');
end;

procedure TLazRibbonElementAppearance.BrightenButtonColors(ABrightenBy: Integer;
  var ACaptionColor, AFrameColor, AInnerLightColor, AInnerDarkColor,
  AGradientFromColor, AGradientToColor: TColor);
begin
  if ABrightenBy <> 0 then
  begin
    ACaptionColor := TColorTools.Brighten(ACaptionColor, ABrightenBy);
    AFrameColor := TColorTools.Brighten(AFrameColor, ABrightenBy);
    AInnerLightColor := TColorTools.Brighten(AInnerLightColor, ABrightenBy);
    AInnerDarkColor := TColorTools.Brighten(AInnerDarkColor, ABrightenBy);
    AGradientFromColor := TColorTools.Brighten(AGradientFromColor, ABrightenBy);
    AGradientToColor := TColorTools.Brighten(AGradientToColor, ABrightenBy);
  end;
end;

procedure TLazRibbonElementAppearance.BrightenSwitchColors(ABrightenBy: Integer;
  var AKnobColor, ATrackColor: TColor);
begin
  if ABrightenBy <> 0 then
  begin
    AKnobColor := TColorTools.Brighten(AKnobColor, ABrightenBy);
    ATrackColor := TColorTools.Brighten(ATrackColor, ABrightenBy);
  end;
end;

procedure TLazRibbonElementAppearance.CaptionFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.GetActiveButtonColors(IsChecked: Boolean;
  out ACaptionColor, AFrameColor, AInnerLightColor, AInnerDarkColor,
  AGradientFromColor, AGradientToColor: TColor;
  out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = -20;
begin
  ACaptionColor := FActiveCaptionColor;
  AFrameColor := FActiveFrameColor;
  AInnerLightColor := FActiveInnerLightColor;
  AInnerDarkColor := FActiveInnerDarkColor;
  AGradientFromColor := FActiveGradientFromColor;
  AGradientToColor := FActiveGradientToColor;
  AGradientKind := FActiveGradientType;

  if IsChecked then
    ABrightenBy := DELTA + ABrightenBy;

  BrightenButtonColors(ABrightenBy, ACaptionColor, AFrameColor,
    AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor);
end;

{ To be used with the mousebutton is pressed on the toggle switch. }
procedure TLazRibbonElementAppearance.GetActiveSwitchColors(IsChecked: Boolean;
  out AKnobColor, ATrackColor: TColor; ABrightenBy: Integer = 0);
begin
  AKnobColor := FActiveKnobColor;
  ATrackColor := FActiveTrackColor;

  BrightenSwitchColors(ABrightenBy, AKnobColor, ATrackColor);
end;

procedure TLazRibbonElementAppearance.GetHotTrackButtonColors(IsChecked: Boolean;
  out ACaptionColor, AFrameColor, AInnerLightColor, AInnerDarkColor,
  AGradientFromColor, AGradientToColor: TColor; out AGradientKind: TBackgroundKind;
  ABrightenBy: Integer = 0);
const
  DELTA = 20;
begin
  if IsChecked then begin
    ABrightenBy := ABrightenBy + DELTA;
    ACaptionColor := FActiveCaptionColor;
    AFrameColor := FActiveFrameColor;
    AInnerLightColor := FActiveInnerLightColor;
    AInnerDarkColor := FActiveInnerDarkColor;
    AGradientFromColor := FActiveGradientFromColor;
    AGradientToColor := FActiveGradientToColor;
    AGradientKind := FActiveGradientType;
  end else begin
    ACaptionColor := FHotTrackCaptionColor;
    AFrameColor := FHotTrackFrameColor;
    AInnerLightColor := FHotTrackInnerLightColor;
    AInnerDarkColor := FHotTrackInnerDarkColor;
    AGradientFromColor := FHotTrackGradientFromColor;
    AGradientToColor := FHotTrackGradientToColor;
    AGradientKind := FHotTrackGradientType;
  end;

  BrightenButtonColors(ABrightenBy, ACaptionColor, AFrameColor,
    AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor);
end;

{ To be used when the mouse hovers over the toggle switch. Colors are
  derived from the Active (for ON state) and Idle (for OFF state) colors. }
procedure TLazRibbonElementAppearance.GetHotTrackSwitchColors(IsChecked: Boolean;
  out AKnobColor, ATrackColor: TColor; ABrightenBy: Integer = 0);
const
  DELTA = 20;
begin
  if IsChecked then
  begin
    AKnobColor := FActiveKnobColor;
    ATrackColor := FHotTrackTrackColor;
  end else
  begin
    AKnobColor := FIdleKnobColor;
    ATrackColor := FHotTrackTrackColor;
  end;

  ABrightenBy := DELTA + ABrightenBy;
  BrightenSwitchColors(ABrightenBy, AKnobColor, ATrackColor);
end;

procedure TLazRibbonElementAppearance.GetIdleButtonColors(IsChecked: Boolean;
  out ACaptionColor, AFrameColor, AInnerLightColor, AInnerDarkColor,
  AGradientFromColor, AGradientToColor: TColor;
  out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = 10;
begin
  if IsChecked then
  begin
    ABrightenBy := DELTA + ABrightenBy;
    ACaptionColor := FActiveCaptionColor;
    AFrameColor := FActiveFrameColor;
    AInnerLightColor := FActiveInnerLightColor;
    AInnerDarkColor := FActiveInnerDarkColor;
    AGradientFromColor := FActiveGradientFromColor;
    AGradientToColor := FActiveGradientToColor;
    AGradientKind := FActiveGradientType;
  end else
  begin
    ACaptionColor := FIdleCaptionColor;
    AFrameColor := FIdleFrameColor;
    AInnerLightColor := FIdleInnerLightColor;
    AInnerDarkColor := FIdleInnerDarkColor;
    AGradientFromColor := FIdleGradientFromColor;
    AGradientToColor := FIdleGradientToColor;
    AGradientKind := FIdleGradientType;
  end;

  BrightenButtonColors(ABrightenBy, ACaptionColor, AFrameColor,
    AInnerLightColor, AInnerDarkColor, AGradientFromColor, AGradientToColor);
end;

{ To be used when the mouse is not over the toggle switch. }
procedure TLazRibbonElementAppearance.GetIdleSwitchColors(IsChecked: Boolean;
  out AKnobColor, ATrackColor: TColor; ABrightenBy: Integer = 0);
const
  DELTA = 10;
begin
  if IsChecked then
  begin
    AKnobColor := FActiveKnobColor;
    ATrackColor := FActiveTrackColor;
  end else
  begin
    AKnobColor := FIdleKnobColor;
    ATrackColor := FIdleTrackColor;
  end;

  BrightenSwitchColors(ABrightenBy, AKnobColor, ATrackColor);
end;

procedure TLazRibbonElementAppearance.LoadFromXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['CaptionFont', false];
  if Assigned(Subnode) then
    TLazRibbonXMLTools.Load(Subnode, FCaptionFont);

  // Idle
  Subnode := Node['IdleFrameColor', false];
  if Assigned(Subnode) then
    FIdleFrameColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientFromColor', false];
  if Assigned(Subnode) then
    FIdleGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientToColor', false];
  if Assigned(Subnode) then
    FIdleGradientToColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientType', false];
  if Assigned(Subnode) then
    FIdleGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['IdleInnerLightColor', false];
  if Assigned(Subnode) then
    FIdleInnerLightColor := Subnode.TextAsColor;

  Subnode := Node['IdleInnerDarkColor', false];
  if Assigned(Subnode) then
    FIdleInnerDarkColor := Subnode.TextAsColor;

  Subnode := Node['IdleKnobColor', false];
  if Assigned(Subnode) then
    FIdleKnobColor := SubNode.TextAsColor;

  Subnode := Node['IdleTrackColor', false];
  if Assigned(Subnode) then
    FIdleTrackColor := Subnode.TextAsColor;

  Subnode := Node['IdleCaptionColor', false];
  if Assigned(Subnode) then
    FIdleCaptionColor := Subnode.TextAsColor;

  // HotTrack
  Subnode := Node['HottrackFrameColor', false];
  if Assigned(Subnode) then
    FHottrackFrameColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientFromColor', false];
  if Assigned(Subnode) then
    FHottrackGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientToColor', false];
  if Assigned(Subnode) then
    FHottrackGradientToColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientType', false];
  if Assigned(Subnode) then
    FHottrackGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['HottrackInnerLightColor', false];
  if Assigned(Subnode) then
    FHottrackInnerLightColor := Subnode.TextAsColor;

  Subnode := Node['HottrackInnerDarkColor', false];
  if Assigned(Subnode) then
    FHottrackInnerDarkColor := Subnode.TextAsColor;

  Subnode := Node['HottrackTrackColor', false];
  if Assigned(Subnode) then
    FHotTrackTrackColor := Subnode.TextAsColor;

  Subnode := Node['HottrackCaptionColor', false];
  if Assigned(Subnode) then
    FHottrackCaptionColor := Subnode.TextAsColor;

  Subnode := Node['HottrackBrightnessChange', false];
  if Assigned(Subnode) then
    FHottrackBrightnessChange := Subnode.TextAsInteger;

  // Active
  Subnode := Node['ActiveFrameColor', false];
  if Assigned(Subnode) then
    FActiveFrameColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientFromColor', false];
  if Assigned(Subnode) then
    FActiveGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientToColor', false];
  if Assigned(Subnode) then
    FActiveGradientToColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientType', false];
  if Assigned(Subnode) then
    FActiveGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['ActiveInnerLightColor', false];
  if Assigned(Subnode) then
    FActiveInnerLightColor := Subnode.TextAsColor;

  Subnode := Node['ActiveInnerDarkColor', false];
  if Assigned(Subnode) then
    FActiveInnerDarkColor := Subnode.TextAsColor;

  Subnode := Node['ActiveKnobColor', false];
  if Assigned(Subnode) then
    FActiveKnobColor := Subnode.TextAsColor;

  Subnode := Node['ActiveTrackColor', false];
  if Assigned(Subnode) then
    FActiveTrackColor := Subnode.TextAsColor;

  Subnode := Node['ActiveCaptionColor', false];
  if Assigned(Subnode) then
    FActiveCaptionColor := Subnode.TextAsColor;

  // Other
  SubNode := Node['KnobAsGradient', false];
  if Assigned(SubNode) then
    FKnobAsGradient := Subnode.TextAsBoolean;

  Subnode := Node['Style', false];
  if Assigned(SubNode) then
    FStyle := TLazRibbonElementStyle(Subnode.TextAsInteger);
end;

procedure TLazRibbonElementAppearance.Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);
begin
  SetDefaultFont(FCaptionFont);

  case AStyle of
    lazOffice2007Blue:
      begin
        FIdleFrameColor := rgb(155, 183, 224);
        FIdleGradientFromColor := rgb(200, 219, 238);
        FIdleGradientToColor := rgb(188, 208, 233);
        FIdleGradientType := bkConcave;
        FIdleInnerLightColor := rgb(213, 227, 241);
        FIdleInnerDarkColor := rgb(190, 211, 236);
        FIdleKnobColor := $B17D56;
        FIdleTrackColor := $F6EBE2;
        FIdleCaptionColor := rgb(86, 125, 177);
        FHotTrackFrameColor := rgb(221, 207, 155);
        FHotTrackGradientFromColor := rgb(255, 252, 218);
        FHotTrackGradientToColor := rgb(255, 215, 77);
        FHotTrackGradientType := bkConcave;
        FHotTrackInnerLightColor := rgb(255, 241, 197);
        FHotTrackInnerDarkColor := rgb(216, 194, 122);
        FHotTrackTrackColor := FHotTrackGradientFromColor;
        FHotTrackCaptionColor := rgb(111, 66, 135);
        FHotTrackBrightnessChange := 40;
        FActiveFrameColor := rgb(139, 118, 84);
        FActiveGradientFromColor := rgb(254, 187, 108);
        FActiveGradientToColor := rgb(252, 146, 61);
        FActiveGradientType := bkConcave;
        FActiveInnerLightColor := rgb(252, 169, 14);
        FActiveInnerDarkColor := rgb(252, 169, 14);
        FActiveKnobColor := $3D92FC;
        FActiveTrackColor := $C5F1FF; // $6CBBFF;
        FActiveCaptionColor := rgb(110, 66, 128);
        FKnobAsGradient := true;
        FStyle := esRounded;
      end;

    lazOffice2007Silver,
    lazOffice2007SilverTurquoise:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $008B4215;
        FIdleFrameColor := $00B8B1A9;
        FIdleGradientFromColor := $00F4F4F2;
        FIdleGradientToColor := $00E6E5E3;
        FIdleGradientType := bkConcave;
        FIdleInnerDarkColor := $00C7C0BA;
        FIdleInnerLightColor := $00F6F2F0;
        FIdleKnobColor := $60655F;
        FIdleTrackColor := $EAEAEA;
        FIdleCaptionColor := $0060655F;
        FHotTrackBrightnessChange := 40;
        FHotTrackFrameColor := $009BCFDD;
        FHotTrackGradientFromColor := $00DAFCFF;
        FHotTrackGradientToColor := $004DD7FF;
        FHotTrackGradientType := bkConcave;
        FHotTrackInnerDarkColor := $007AC2D8;
        FHotTrackInnerLightColor := $00C5F1FF;
        FHotTrackTrackColor := FHotTrackGradientFromColor;
        FHotTrackCaptionColor := $0087426F;
        if AStyle = lazOffice2007SilverTurquoise then
        begin
          FHotTrackFrameColor := $009E7D0E;
          FHotTrackGradientFromColor := $00FBF1D0;
          FHotTrackGradientToColor := $00F4DD8A;
          FHotTrackInnerDarkColor := $00C19A11;
          FHotTrackInnerLightColor := $00FAEFC9;
          FHotTrackTrackColor := $FDF7E1;
        end;
        FActiveFrameColor := $0054768B;
        FActiveGradientFromColor := $006CBBFE;
        FActiveGradientToColor := $003D92FC;
        FActiveGradientType := bkConcave;
        FActiveInnerDarkColor := $000EA9FC;
        FActiveInnerLightColor := $000EA9FC;
        FActiveKnobColor := $3D92FC;
        FActiveTrackColor := $C5F1FF; { was $6CBBFE }
        FActiveCaptionColor := $0080426E;
        if AStyle = lazOffice2007SilverTurquoise then
        begin
          FActiveFrameColor := $0077620B;
          FActiveGradientFromColor := $00F4DB82;
          FActiveGradientToColor := $00ECC53E;
          FActiveInnerDarkColor := $00735B0B;
          FActiveInnerLightColor := $00F3D87A;
          FActiveKnobColor := $C19A11;
          FActiveTrackColor := $FBF1D0;
        end;
        FKnobAsGradient := true;
        FStyle := esRounded;
      end;

    lazMetroLight:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $003F3F3F;
        FIdleFrameColor := $00CDCDCD;
        FIdleGradientFromColor := $00DFDFDF;
        FIdleGradientToColor := $00DFDFDF;
        FIdleGradientType := bkSolid;
        FIdleInnerDarkColor := $00CDCDCD;
        FIdleInnerLightColor := $00EBEBEB;
        FIdleKnobColor := $FFFFFF; //CDCDCD;
        FIdleTrackColor := $F7EFE8; { was $DFDFDF }
        FIdleCaptionColor := $00696969;
        FHotTrackFrameColor := $00F9CEA4;
        FHotTrackGradientFromColor := $00F7EFE8;
        FHotTrackGradientToColor := $00F7EFE8;
        FHotTrackGradientType := bkSolid;
        FHotTrackInnerDarkColor := $00F7EFE8;
        FHotTrackInnerLightColor := $00F7EFE8;
        FHotTrackTrackColor := $FBF8F4;
        FHotTrackCaptionColor := $003F3F3F;
        FHotTrackBrightnessChange := 20;
        FActiveFrameColor := $00E4A262;
        FActiveGradientFromColor := $00F7E0C9;
        FActiveGradientToColor := $00F7E0C9;
        FActiveGradientType := bkSolid;
        FActiveInnerDarkColor := $00F7E0C9;
        FActiveInnerLightColor := $00F7E0C9;
        FActiveKnobColor := $F9CDA4;
        FActiveTrackColor := $F7EFE8;
        FActiveCaptionColor := $002C2C2C;
        FKnobAsGradient := false;
        FStyle := esRectangle;
      end;

    lazMetroDark:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $003F3F3F;
        FIdleFrameColor := $008C8482;
        FIdleGradientFromColor := $00444444;
        FIdleGradientToColor := $00444444;
        FIdleGradientType := bkSolid;
        FIdleInnerDarkColor := $008C8482;
        FIdleInnerLightColor := $00444444;
        FIdleKnobColor := $8C8482;
        FIdleTrackColor := $444444;
        FIdleCaptionColor := $00B6B6B6;
        FHotTrackFrameColor := $00C4793C;
        FHotTrackGradientFromColor := $00805B3D;
        FHotTrackGradientToColor := $00805B3D;
        FHotTrackGradientType := bkSolid;
        FHotTrackInnerDarkColor := $00805B3D;
        FHotTrackInnerLightColor := $00805B3D;
        FHotTrackTrackColor := FHotTrackGradientFromColor;
        FHotTrackCaptionColor := $00F2F2F2;
        FHotTrackBrightnessChange := 10;
        FActiveFrameColor := $00000000;
        FActiveGradientFromColor := $00000000;
        FActiveGradientToColor := $00000000;
        FActiveGradientType := bkSolid;
        FActiveInnerDarkColor := $00000000;
        FActiveInnerLightColor := $00000000;
        FActiveKnobColor := $C4793C;
        FActiveTrackColor := $444444;
        FActiveCaptionColor := $00E4E4E4;
        FKnobAsGradient := false;
        FStyle := esRectangle;
      end;

    lazOffice2007Rose:
      begin
        FIdleFrameColor := rgb(224, 155, 183);
        FIdleGradientFromColor := rgb(238, 200, 219);
        FIdleGradientToColor := rgb(233, 188, 208);
        FIdleGradientType := bkConcave;
        FIdleInnerLightColor := rgb(241, 213, 227);
        FIdleInnerDarkColor := rgb(236, 190, 211);
        FIdleKnobColor := $B15678;
        FIdleTrackColor := $F6E2EB;
        FIdleCaptionColor := rgb(177, 86, 125);
        FHotTrackFrameColor := rgb(221, 207, 155);
        FHotTrackGradientFromColor := rgb(255, 252, 218);
        FHotTrackGradientToColor := rgb(255, 215, 77);
        FHotTrackGradientType := bkConcave;
        FHotTrackInnerLightColor := rgb(255, 241, 197);
        FHotTrackInnerDarkColor := rgb(216, 194, 122);
        FHotTrackTrackColor := FHotTrackGradientFromColor;
        FHotTrackCaptionColor := rgb(111, 66, 135);
        FHotTrackBrightnessChange := 40;
        FActiveFrameColor := rgb(139, 118, 84);
        FActiveGradientFromColor := rgb(254, 187, 108);
        FActiveGradientToColor := rgb(252, 146, 61);
        FActiveGradientType := bkConcave;
        FActiveInnerLightColor := rgb(252, 169, 14);
        FActiveInnerDarkColor := rgb(252, 169, 14);
        FActiveKnobColor := $3D92FC;
        FActiveTrackColor := $FFD0DC;
        FActiveCaptionColor := rgb(110, 66, 128);
        FKnobAsGradient := true;
        FStyle := esRounded;
      end;

    lazOffice2007Sage:
      begin
        FIdleFrameColor := rgb(155, 224, 183);
        FIdleGradientFromColor := rgb(200, 238, 219);
        FIdleGradientToColor := rgb(188, 233, 208);
        FIdleGradientType := bkConcave;
        FIdleInnerLightColor := rgb(213, 241, 227);
        FIdleInnerDarkColor := rgb(190, 236, 211);
        FIdleKnobColor := $56B178;
        FIdleTrackColor := $E2F6EB;
        FIdleCaptionColor := rgb(86, 177, 125);
        FHotTrackFrameColor := rgb(221, 207, 155);
        FHotTrackGradientFromColor := rgb(255, 252, 218);
        FHotTrackGradientToColor := rgb(255, 215, 77);
        FHotTrackGradientType := bkConcave;
        FHotTrackInnerLightColor := rgb(255, 241, 197);
        FHotTrackInnerDarkColor := rgb(216, 194, 122);
        FHotTrackTrackColor := FHotTrackGradientFromColor;
        FHotTrackCaptionColor := rgb(111, 66, 135);
        FHotTrackBrightnessChange := 40;
        FActiveFrameColor := rgb(139, 118, 84);
        FActiveGradientFromColor := rgb(254, 187, 108);
        FActiveGradientToColor := rgb(252, 146, 61);
        FActiveGradientType := bkConcave;
        FActiveInnerLightColor := rgb(252, 169, 14);
        FActiveInnerDarkColor := rgb(252, 169, 14);
        FActiveKnobColor := $3DFC92;
        FActiveTrackColor := $C5FFD0;
        FActiveCaptionColor := rgb(66, 110, 128);
        FKnobAsGradient := true;
        FStyle := esRounded;
      end;

    { StyleMaker:ElementReset:Begin }
    { StyleMaker:lazOffice2007Bege:Begin }
    lazOffice2007Bege:
      begin
        CaptionFont.Name := 'default';
        CaptionFont.Size := 0;
        CaptionFont.Style := [];
        CaptionFont.Color := $00000000;
        IdleFrameColor := $0093BDBD;
        IdleGradientFromColor := $00B8D4E2;
        IdleGradientToColor := $00D2E2E9;
        IdleGradientType := bkConcave;
        IdleInnerLightColor := $00DCE9ED;
        IdleInnerDarkColor := $00100B05;
        IdleKnobColor := $00B17D56;
        IdleTrackColor := $00F6EBE2;
        IdleCaptionColor := $00000000;
        HotTrackFrameColor := $0046A5EA;
        HotTrackGradientFromColor := $00A1F4FE;
        HotTrackGradientToColor := $0054C7FF;
        HotTrackGradientType := bkConcave;
        HotTrackInnerLightColor := $00C5F1FF;
        HotTrackInnerDarkColor := $007AC2D8;
        HotTrackTrackColor := $00DAFCFF;
        HotTrackCaptionColor := $00000000;
        HotTrackBrightnessChange := 30;
        ActiveFrameColor := $0046A5EA;
        ActiveGradientFromColor := $0054C7FF;
        ActiveGradientToColor := $00A1F4FE;
        ActiveGradientType := bkConcave;
        ActiveInnerLightColor := $000EA9FC;
        ActiveInnerDarkColor := $000EA9FC;
        ActiveKnobColor := $003D92FC;
        ActiveTrackColor := $00C5F1FF;
        ActiveCaptionColor := $00000000;
        KnobAsGradient := True;
        Style := esRectangle;
      end;
{ StyleMaker:lazOffice2007Bege:End }
{ StyleMaker:ElementReset:End }
  end;
end;

procedure TLazRibbonElementAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do begin
    Add('  with Element do begin');
    SaveFontToPascal(AList, FCaptionFont, '    CaptionFont');

    Add('    IdleFrameColor := $' + IntToHex(FIdleFrameColor, 8) + ';');
    Add('    IdleGradientFromColor := $' + IntToHex(FIdleGradientFromColor, 8) + ';');
    Add('    IdleGradientToColor := $' + IntToHex(FIdleGradientToColor, 8) + ';');
    Add('    IdleGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FIdleGradientType)) + ';');
    Add('    IdleInnerDarkColor := $' + IntToHex(FIdleInnerDarkColor, 8) + ';');
    Add('    IdleInnerLightColor := $' + IntToHex(FIdleInnerLightColor, 8) + ';');
    Add('    IdleKnobColor := $' + IntToHex(FIdleKnobColor, 8) + ';');
    Add('    IdleTrackColor := $' + IntToHex(FIdleTrackColor, 8) + ';');
    Add('    IdleCaptionColor := $' + IntToHex(FIdleCaptionColor, 8) + ';');

    Add('    HotTrackFrameColor := $' + IntToHex(FHotTrackFrameColor, 8) + ';');
    Add('    HotTrackGradientFromColor := $' + IntToHex(FHotTrackGradientFromColor, 8) + ';');
    Add('    HotTrackGradientToColor := $' + IntToHex(FHotTrackGradientToColor, 8) + ';');
    Add('    HotTrackGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FHotTrackGradientType)) + ';');
    Add('    HotTrackInnerDarkColor := $' + IntToHex(FHotTrackInnerDarkColor, 8) + ';');
    Add('    HotTrackInnerLightColor := $' + IntToHex(FHotTrackInnerLightColor, 8) + ';');
    Add('    HotTrackTrackColor := $' + IntToHex(FHotTrackTrackColor, 8) + ';');
    Add('    HotTrackCaptionColor := $' + IntToHex(FHotTrackCaptionColor, 8) + ';');
    Add('    HotTrackBrightnessChange := ' + IntToStr(FHotTrackBrightnessChange) + ';');

    Add('    ActiveFrameColor := $' + IntToHex(FActiveFrameColor, 8) + ';');
    Add('    ActiveGradientFromColor := $' + IntToHex(FActiveGradientFromColor, 8) + ';');
    Add('    ActiveGradientToColor := $' + IntToHex(FActiveGradientToColor, 8) + ';');
    Add('    ActiveGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FActiveGradientType)) + ';');
    Add('    ActiveInnerDarkColor := $' + IntToHex(FActiveInnerDarkColor, 8) + ';');
    Add('    ActiveInnerLightColor := $' + IntToHex(FActiveInnerLightColor, 8) + ';');
    Add('    ActiveKnobColor := $' + IntToHex(FActiveKnobColor, 8) + ';');
    Add('    ActiveTrackColor := $' + IntToHex(FActiveTrackColor, 8) + ';');
    Add('    ActiveCaptionColor := $' + IntToHex(FActiveCaptionColor, 8) + ';');

    Add('    KnobAsGradient := ' + BoolToStr(FKnobAsGradient, true) + ';');
    Add('    Style := ' + GetEnumName(TypeInfo(TLazRibbonElementStyle), ord(FStyle)) + ';');
    Add('  end;');
  end;
end;

procedure TLazRibbonElementAppearance.SaveToXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['CaptionFont', true];
  TLazRibbonXMLTools.Save(Subnode, FCaptionFont);

  // Idle
  Subnode := Node['IdleFrameColor', true];
  Subnode.TextAsColor := FIdleFrameColor;

  Subnode := Node['IdleGradientFromColor', true];
  Subnode.TextAsColor := FIdleGradientFromColor;

  Subnode := Node['IdleGradientToColor', true];
  Subnode.TextAsColor := FIdleGradientToColor;

  Subnode := Node['IdleGradientType', true];
  Subnode.TextAsInteger := integer(FIdleGradientType);

  Subnode := Node['IdleInnerLightColor', true];
  Subnode.TextAsColor := FIdleInnerLightColor;

  Subnode := Node['IdleInnerDarkColor', true];
  Subnode.TextAsColor := FIdleInnerDarkColor;

  Subnode := Node['IdleKnobColor', true];
  Subnode.TextAsColor := FIdleKnobColor;

  Subnode := Node['IdleTrackColor', true];
  Subnode.TextAsColor := FIdleTrackColor;

  Subnode := Node['IdleCaptionColor', true];
  Subnode.TextAsColor := FIdleCaptionColor;

  // HotTrack
  Subnode := Node['HottrackFrameColor', true];
  Subnode.TextAsColor := FHottrackFrameColor;

  Subnode := Node['HottrackGradientFromColor', true];
  Subnode.TextAsColor := FHottrackGradientFromColor;

  Subnode := Node['HottrackGradientToColor', true];
  Subnode.TextAsColor := FHottrackGradientToColor;

  Subnode := Node['HottrackGradientType', true];
  Subnode.TextAsInteger := integer(FHottrackGradientType);

  Subnode := Node['HottrackInnerLightColor', true];
  Subnode.TextAsColor := FHottrackInnerLightColor;

  Subnode := Node['HottrackInnerDarkColor', true];
  Subnode.TextAsColor := FHottrackInnerDarkColor;

  Subnode := Node['HottrackTrackColor', true];
  Subnode.TextAsColor := FHottrackTrackColor;

  Subnode := Node['HottrackCaptionColor', true];
  Subnode.TextAsColor := FHottrackCaptionColor;

  Subnode := Node['HottrackBrightnessChange', true];
  Subnode.TextAsInteger := FHotTrackBrightnessChange;

  // Active
  Subnode := Node['ActiveFrameColor', true];
  Subnode.TextAsColor := FActiveFrameColor;

  Subnode := Node['ActiveGradientFromColor', true];
  Subnode.TextAsColor := FActiveGradientFromColor;

  Subnode := Node['ActiveGradientToColor', true];
  Subnode.TextAsColor := FActiveGradientToColor;

  Subnode := Node['ActiveGradientType', true];
  Subnode.TextAsInteger := integer(FActiveGradientType);

  Subnode := Node['ActiveInnerLightColor', true];
  Subnode.TextAsColor := FActiveInnerLightColor;

  Subnode := Node['ActiveInnerDarkColor', true];
  Subnode.TextAsColor := FActiveInnerDarkColor;

  Subnode := Node['ActiveKnobColor', true];
  Subnode.TextAsColor := FActiveKnobColor;

  Subnode := Node['ActiveTrackColor', true];
  Subnode.TextAsColor := FActiveTrackColor;

  Subnode := Node['ActiveCaptionColor', true];
  Subnode.TextAsColor := FActiveCaptionColor;

  // Other
  SubNode := Node['KnobAsGradient', true];
  Subnode.TextAsBoolean := FKnobAsGradient;

  Subnode := Node['Style', true];
  Subnode.TextAsInteger := integer(FStyle);
end;

procedure TLazRibbonElementAppearance.SetActiveCaptionColor(const Value: TColor);
begin
  FActiveCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveFrameColor(const Value: TColor);
begin
  FActiveFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveGradientFromColor(const Value: TColor);
begin
  FActiveGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveGradientToColor(const Value: TColor);
begin
  FActiveGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveGradientType(const Value: TBackgroundKind);
begin
  FActiveGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveInnerDarkColor(const Value: TColor);
begin
  FActiveInnerDarkColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveInnerLightColor(const Value: TColor);
begin
  FActiveInnerLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveKnobColor(const Value: TColor);
begin
  FActiveKnobColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetActiveTrackColor(const Value: TColor);
begin
  FActiveTrackColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont.Assign(Value);
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackBrightnessChange(const Value: Integer);
begin
  FHotTrackBrightnessChange := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackCaptionColor(const Value: TColor);
begin
  FHotTrackCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackFrameColor(const Value: TColor);
begin
  FHotTrackFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackGradientFromColor(const Value: TColor);
begin
  FHotTrackGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackGradientToColor(const Value: TColor);
begin
  FHotTrackGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackGradientType(const Value: TBackgroundKind);
begin
  FHotTrackGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackInnerDarkColor(const Value: TColor);
begin
  FHotTrackInnerDarkColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackInnerLightColor(const Value: TColor);
begin
  FHotTrackInnerLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetHotTrackTrackColor(const Value: TColor);
begin
  FHotTrackTrackColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleCaptionColor(const Value: TColor);
begin
  FIdleCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleFrameColor(const Value: TColor);
begin
  FIdleFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleGradientFromColor(const Value: TColor);
begin
  FIdleGradientFromColor := Value;
  if FDispatch <> nil then
     FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleGradientToColor(const Value: TColor);
begin
  FIdleGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleGradientType(const Value: TBackgroundKind);
begin
  FIdleGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleInnerDarkColor(const Value: TColor);
begin
  FIdleInnerDarkColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleInnerLightColor(const Value: TColor);
begin
  FIdleInnerLightColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleKnobColor(const Value: TColor);
begin
  FIdleKnobColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetIdleTrackColor(const Value: TColor);
begin
  FIdleTrackColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetKnobAsGradient(const Value: Boolean);
begin
  FKnobAsGradient := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonElementAppearance.SetStyle(const Value: TLazRibbonElementStyle);
begin
  FStyle := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;


{ TLazRibbonPopupMenuAppearance }

constructor TLazRibbonPopupMenuAppearance.Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChange := CaptionFontChange;
  Reset;
end;

destructor TLazRibbonPopupMenuAppearance.Destroy;
begin
  FCaptionFont.Free;
  inherited Destroy;
end;

procedure TLazRibbonPopupMenuAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TLazRibbonPopupMenuAppearance;
begin
  if Source is TLazRibbonPopupMenuAppearance then
  begin
    SrcAppearance := TLazRibbonPopupMenuAppearance(Source);

    FCaptionFont.Assign(SrcAppearance.CaptionFont);

    FCheckedFrameColor := SrcAppearance.CheckedFrameColor;
    FCheckedGradientFromColor := SrcAppearance.CheckedGradientFromColor;
    FCheckedGradientToColor := SrcAppearance.CheckedGradientToColor;
    FCheckedGradientType := SrcAppearance.CheckedGradientType;

    FDisabledCaptionColor := SrcAppearance.DisabledCaptionColor;
    FDividerLineColor := SrcAppearance.DividerLineColor;

    FIdleCaptionColor := SrcAppearance.IdleCaptionColor;
    FIdleGradientFromColor := SrcAppearance.IdleGradientFromColor;
    FIdleGradientToColor := SrcAppearance.IdleGradientToColor;
    FIdleGradientType := SrcAppearance.IdleGradientType;

    FGutterFrameColor := SrcAppearance.GutterFrameColor;
    FGutterGradientFromColor := SrcAppearance.GutterGradientFromColor;
    FGutterGradientToColor := SrcAppearance.GutterGradientToColor;
    FGutterGradientType := SrcAppearance.GutterGradientType;

    FHotTrackCaptionColor := SrcAppearance.HotTrackCaptionColor;
    FHotTrackFrameColor := SrcAppearance.HotTrackFrameColor;
    FHotTrackGradientFromColor := SrcAppearance.HotTrackGradientFromColor;
    FHotTrackGradientToColor := SrcAppearance.HotTrackGradientToColor;
    FHotTrackGradientType := SrcAppearance.HotTrackGradientType;

    FSelShape := SrcAppearance.SelectionShape;
    FStyle := SrcAppearance.Style;

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end else
    raise AssignException.Create('TLazRibbonPopupMenuAppearance.Assign: Cannot assign the objecct '+Source.ClassName+' to TLazRibbonPopuMenuAppearance!');
end;

procedure TLazRibbonPopupMenuAppearance.CaptionFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.LoadFromXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['CaptionFont', false];
  if Assigned(Subnode) then
    TLazRibbonXMLTools.Load(Subnode, FCaptionFont);

  // Checkbox rectangle
  Subnode := Node['CheckedFrameColor', false];
  if Assigned(Subnode) then
    FCheckedFrameColor := Subnode.TextAsColor;

  Subnode := Node['CheckedGradientFromColor', false];
  if Assigned(Subnode) then
    FCheckedGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['CheckedGradientToColor', false];
  if Assigned(Subnode) then
    FCheckedGradientToColor := Subnode.TextAsColor;

  Subnode := Node['CheckedGradientType', false];
  if Assigned(Subnode) then
    FCheckedGradientType := TBackgroundKind(Subnode.TextAsInteger);

  // Disabled text
  Subnode := Node['DisabledCaptionColor', false];
  if Assigned(SubNode) then
    FDisabledCaptionColor := Subnode.TextAsColor;

  // Divider line
  Subnode := Node['DividerLineColor', false];
  if Assigned(Subnode) then
    FDividerLineColor := Subnode.TextAsColor;

  // Idle
  Subnode := Node['IdleCaptionColor', false];
  if Assigned(Subnode) then
    FIdleCaptionColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientFromColor', false];
  if Assigned(Subnode) then
    FIdleGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientToColor', false];
  if Assigned(Subnode) then
    FIdleGradientToColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientType', false];
  if Assigned(Subnode) then
    FIdleGradientType := TBackgroundKind(Subnode.TextAsInteger);

  // Gutter
  Subnode := Node['GutterFrameColor', false];
  if Assigned(Subnode) then
    FGutterFrameColor := Subnode.TextAsColor;

  Subnode := Node['GutterGradientFromColor', false];
  if Assigned(Subnode) then
    FGutterGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['GutterGradientToColor', false];
  if Assigned(Subnode) then
    FGutterGradientToColor := Subnode.TextAsColor;

  Subnode := Node['GuttereGradientType', false];
  if Assigned(Subnode) then
    FGutterGradientType := TBackgroundKind(Subnode.TextAsInteger);

  // HotTrack
  Subnode := Node['HottrackCaptionColor', false];
  if Assigned(Subnode) then
    FHottrackCaptionColor := Subnode.TextAsColor;

  Subnode := Node['HottrackFrameColor', false];
  if Assigned(Subnode) then
    FHottrackFrameColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientFromColor', false];
  if Assigned(Subnode) then
    FHottrackGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientToColor', false];
  if Assigned(Subnode) then
    FHottrackGradientToColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientType', false];
  if Assigned(Subnode) then
    FHottrackGradientType := TBackgroundKind(Subnode.TextAsInteger);

  // Other
  Subnode := Node['SelectionShape', false];
  if Assigned(Subnode) then
    FSelShape := TLazRibbonPopupSelectionShape(Subnode.TextAsInteger);

  Subnode := Node['Style', false];
  if Assigned(SubNode) then
    FStyle := TLazRibbonPopupStyle(Subnode.TextAsInteger);
end;

procedure TLazRibbonPopupMenuAppearance.Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);
begin
  SetDefaultFont(FCaptionFont);
  case AStyle of
    lazOffice2007Blue:
      begin
        FCaptionFont.Style := [];
        FDisabledCaptionColor := rgb(192, 192, 192);
        FCheckedFrameColor := rgb(242, 149, 54);
        FCheckedGradientFromColor := rgb(255, 227, 149);
        FCheckedGradientToColor := FCheckedGradientFromColor;
        FCheckedGradientType := bkSolid;
        FDividerLineColor := rgb(141, 178, 227);
        {
        FIdleFrameColor := rgb(155, 183, 224);
        }
        FGutterFrameColor := rgb(197, 197, 197);
        FGutterGradientFromColor := rgb(233, 238, 238);
        FGutterGradientToColor := rgb(233, 238, 238);
        FGutterGradientType := bkSolid;
        {
        FIdleInnerLightColor := rgb(213, 227, 241);
        FIdleInnerDarkColor := rgb(190, 211, 236);
        }
        FHotTrackCaptionColor := rgb(111, 66, 135);
        FHotTrackFrameColor := rgb(219, 206, 153);
        FHotTrackGradientFromColor := rgb(255, 252, 218);
        FHotTrackGradientToColor := rgb(255, 215, 77);
        FHotTrackGradientType := bkConcave;
        {
        FHotTrackInnerLightColor := rgb(255, 241, 197);
        FHotTrackInnerDarkColor := rgb(216, 194, 122);
        FHotTrackBrightnessChange := 40;
        }
        FIdleCaptionColor := rgb(86, 125, 177);
        FIdleGradientFromColor := rgb(250, 250, 250);
        FIdleGradientToColor := rgb(250, 250, 250);
        FIdleGradientType := bkSolid;
        FStyle := psGutter;
        FSelShape := ssRectangle;
      end;

    lazOffice2007Silver,
    lazOffice2007SilverTurquoise:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $008B4215;
        FDisabledCaptionColor := rgb(192, 192, 192);
        FCheckedGradientType := bkSolid;
        if AStyle = lazOffice2007SilverTurquoise then
        begin
          FCheckedFrameColor := $009E7D0E;
          FCheckedGradientFromColor := $00FBF1D0;
        end else
        begin
          FCheckedFrameColor := rgb(242, 149, 54);
          FCheckedGradientFromColor := rgb(255, 227, 149);
        end;
        FCheckedGradientToColor := FCheckedGradientFromColor;
        FDividerLineColor := $00BEBEBE;

        FIdleCaptionColor := $0060655F;
        FIdleGradientFromColor := rgb(250, 250, 250);
        FIdleGradientToColor := rgb(250, 250, 250);
        FIdleGradientType := bkSolid;
        FGutterFrameColor := rgb(197, 197, 197);
        FGutterGradientFromColor := rgb(239, 239, 239);
        FGutterGradientToColor := rgb(239, 239, 239);
        FGutterGradientType := bkSolid;
        {
        FIdleInnerDarkColor := $00C7C0BA;
        FIdleInnerLightColor := $00F6F2F0;
        FHotTrackBrightnessChange := 40;
        }
        FHotTrackCaptionColor := $0087426F;
        FHotTrackGradientType := bkConcave;
        {
        FHotTrackInnerDarkColor := $007AC2D8;
        FHotTrackInnerLightColor := $00C5F1FF;
        }
        if AStyle = lazOffice2007SilverTurquoise then
        begin
          FHotTrackFrameColor := $009E7D0E;
          FHotTrackGradientFromColor := $00FBF1D0;
          FHotTrackGradientToColor := $00F4DD8A;
//          FHotTrackInnerDarkColor := $00C19A11;
//          FHotTrackInnerLightColor := $00FAEFC9;
        end else
        begin
          FHotTrackFrameColor := rgb(219, 206, 153);  // $009BCFDD;
          FHotTrackGradientFromColor := $00DAFCFF;
          FHotTrackGradientToColor := $004DD7FF;
        end;
        FStyle := psGutter;
        FSelShape := ssRectangle;
      end;

    lazMetroLight:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $003F3F3F;
        FCheckedFrameColor := $00F9CEA4;
        FCheckedGradientFromColor := $00F7EFE8;
        FCheckedGradientToColor := FCheckedGradientFromColor;
        FCheckedGradientType := bkSolid;

        FDisabledCaptionColor := rgb(192, 192, 192);
        FDividerLineColor := $00D2D0CF;
        FGutterFrameColor := rgb(197, 197, 197);
        FGutterGradientFromColor := rgb(239, 239, 239);
        FGutterGradientToColor := rgb(239, 239, 239);
        FGutterGradientType := bkSolid;
        FHotTrackCaptionColor := $003F3F3F;
        FHotTrackFrameColor := $00F9CEA4;
        FHotTrackGradientFromColor := $00F7EFE8;
        FHotTrackGradientToColor := $00F7EFE8;
        FHotTrackGradientType := bkSolid;
        {
        FHotTrackInnerDarkColor := $00F7EFE8;
        FHotTrackInnerLightColor := $00F7EFE8;
        FHotTrackBrightnessChange := 20;
        }
        {
        FIdleFrameColor := $00CDCDCD;
        }
        FIdleCaptionColor := $00696969;
        FIdleGradientFromColor := $00F1F1F1;
        FIdleGradientToColor := $00F1F1F1;
        FIdleGradientType := bkSolid;
        {
        FIdleInnerDarkColor := $00CDCDCD;
        FIdleInnerLightColor := $00EBEBEB;
        FHotTrackInnerDarkColor := $00F7EFE8;
        FHotTrackInnerLightColor := $00F7EFE8;
        FHotTrackBrightnessChange := 20;
        }

        FStyle := psDefault;
        FSelShape := ssRectangle;
      end;

    lazMetroDark:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $003F3F3F;
        FCheckedFrameColor := $00C4793C;
        FCheckedGradientFromColor := $00805B3D;
        FCheckedGradientToColor := FCheckedGradientFromColor;
        FCheckedGradientType := bkSolid;
        FDisabledCaptionColor := $787878;
        FDividerLineColor := $000000;
        FGutterFrameColor := rgb(32, 32, 32);
        FGutterGradientFromColor := clBlack;
        FGutterGradientToColor := clBlack;
        FGutterGradientType := bkSolid;
        FHotTrackCaptionColor := $00F2F2F2;
        FHotTrackFrameColor := $00C4793C;
        FHotTrackGradientFromColor := $00805B3D;
        FHotTrackGradientToColor := $00805B3D;
        FHotTrackGradientType := bkSolid;
        {
        FHotTrackInnerDarkColor := $00805B3D;
        FHotTrackInnerLightColor := $00805B3D;
        FHotTrackBrightnessChange := 10;
        }
        {
        FIdleFrameColor := $008C8482;
        }
        FIdleCaptionColor := $00B6B6B6;
        FIdleGradientFromColor := $00444444;
        FIdleGradientToColor := $00444444;
        FIdleGradientType := bkSolid;
        {
        FIdleInnerDarkColor := $008C8482;
        FIdleInnerLightColor := $00444444;
        }
        FStyle := psDefault;
        FSelShape := ssRectangle;
      end;

    lazOffice2007Rose:
      begin
        FCaptionFont.Style := [];
        FDisabledCaptionColor := rgb(192, 192, 192);
        FCheckedFrameColor := rgb(242, 149, 54);
        FCheckedGradientFromColor := rgb(255, 227, 149);
        FCheckedGradientToColor := FCheckedGradientFromColor;
        FCheckedGradientType := bkSolid;
        FDividerLineColor := rgb(227, 141, 178);
        FGutterFrameColor := rgb(197, 197, 197);
        FGutterGradientFromColor := rgb(238, 233, 236);
        FGutterGradientToColor := rgb(238, 233, 236);
        FGutterGradientType := bkSolid;
        FHotTrackCaptionColor := rgb(111, 66, 135);
        FHotTrackFrameColor := rgb(219, 206, 153);
        FHotTrackGradientFromColor := rgb(255, 252, 218);
        FHotTrackGradientToColor := rgb(255, 215, 77);
        FHotTrackGradientType := bkConcave;
        FIdleCaptionColor := rgb(177, 86, 125);
        FIdleGradientFromColor := rgb(250, 250, 250);
        FIdleGradientToColor := rgb(250, 250, 250);
        FIdleGradientType := bkSolid;
        FStyle := psGutter;
        FSelShape := ssRectangle;
      end;

    lazOffice2007Sage:
      begin
        FCaptionFont.Style := [];
        FDisabledCaptionColor := rgb(192, 192, 192);
        FCheckedFrameColor := rgb(242, 149, 54);
        FCheckedGradientFromColor := rgb(255, 227, 149);
        FCheckedGradientToColor := FCheckedGradientFromColor;
        FCheckedGradientType := bkSolid;
        FDividerLineColor := rgb(141, 227, 178);
        FGutterFrameColor := rgb(197, 197, 197);
        FGutterGradientFromColor := rgb(233, 238, 236);
        FGutterGradientToColor := rgb(233, 238, 236);
        FGutterGradientType := bkSolid;
        FHotTrackCaptionColor := rgb(111, 66, 135);
        FHotTrackFrameColor := rgb(219, 206, 153);
        FHotTrackGradientFromColor := rgb(255, 252, 218);
        FHotTrackGradientToColor := rgb(255, 215, 77);
        FHotTrackGradientType := bkConcave;
        FIdleCaptionColor := rgb(86, 177, 125);
        FIdleGradientFromColor := rgb(250, 250, 250);
        FIdleGradientToColor := rgb(250, 250, 250);
        FIdleGradientType := bkSolid;
        FStyle := psGutter;
        FSelShape := ssRectangle;
      end;

    { StyleMaker:PopupReset:Begin }
    { StyleMaker:lazOffice2007Bege:Begin }
    lazOffice2007Bege:
      begin
        CaptionFont.Name := 'default';
        CaptionFont.Size := 0;
        CaptionFont.Style := [];
        CaptionFont.Color := $00000000;
        CheckedFrameColor := $003695F2;
        CheckedGradientFromColor := $0095E3FF;
        CheckedGradientToColor := $0095E3FF;
        CheckedGradientType := bkVerticalGradient;
        DisabledCaptionColor := $00C0C0C0;
        DividerLineColor := $00E3B28D;
        GutterFrameColor := $00C5C5C5;
        GutterGradientFromColor := $00EEEEE9;
        GutterGradientToColor := $00EEEEE9;
        GutterGradientType := bkSolid;
        IdleCaptionColor := $00B17D56;
        IdleGradientFromColor := $00FAFAFA;
        IdleGradientToColor := $00FAFAFA;
        IdleGradientType := bkSolid;
        HotTrackCaptionColor := $00000000;
        HotTrackFrameColor := $0099CEDB;
        HotTrackGradientFromColor := $00DAFCFF;
        HotTrackGradientToColor := $004DD7FF;
        HotTrackGradientType := bkConcave;
        SelectionShape := ssRectangle;
        Style := psGutter;
      end;
{ StyleMaker:lazOffice2007Bege:End }
{ StyleMaker:PopupReset:End }
  end;
end;

procedure TLazRibbonPopupMenuAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do begin
    Add('  with Popup do begin');
    SaveFontToPascal(AList, FCaptionFont, '    CaptionFont');

    Add('    CheckedFrameColor := $%.8x;', [FCheckedFrameColor]);
    Add('    CheckedGradientFromColor := $%.8x;', [FCheckedGradientFromColor]);
    Add('    CheckedGradientToColor := $%.8x;', [FCheckedGradientToColor]);
    Add('    CheckedGradientType := %s;', [GradientTypeName(FCheckedGradientType)]);

    Add('    DisabledCaptionColor := $%.8x;', [FDisabledCaptionColor]);
    Add('    DividerLineColor := $%.8x;', [FDividerLineColor]);

    Add('    GutterFrameColor := $%.8x;', [FGutterFrameColor]);
    Add('    GutterGradientFromColor := $%.8x;', [FGutterGradientFromColor]);
    Add('    GutterGradientToColor := $%.8x;', [FGutterGradientToColor]);
    Add('    GutterGradientType := %s;', [GradientTypeName(FGutterGradientType)]);

    Add('    IdleCaptionColor := $%.8x;', [FIdleCaptionColor]);
    Add('    IdleGradientFromColor := $%.8x;', [FIdleGradientFromColor]);
    Add('    IdleGradientToColor := $%.8x;', [FIdleGradientToColor]);
    Add('    IdleGradientType := %s;', [GradientTypeName(FIdleGradientType)]);

    Add('    HotTrackCaptionColor := $%.8x;', [FHotTrackCaptionColor]);
    Add('    HotTrackFrameColor := $%.8x;', [FHotTrackFrameColor]);
    Add('    HotTrackGradientFromColor := $%.8x;', [FHotTrackGradientFromColor]);
    Add('    HotTrackGradientToColor := $%.8x;', [FHotTrackGradientToColor]);
    Add('    HotTrackGradientType := %s;', [GradientTypeName(FHotTrackGradientType)]);

    Add('    SelectionShape := %s;', [GetEnumName(TypeInfo(TLazRibbonPopupSelectionShape), ord(FSelShape))]);
    Add('    Style := %s;', [GetEnumName(TypeInfo(TLazRibbonPopupStyle), ord(FStyle))]);
    Add('  end;');
  end;
end;

procedure TLazRibbonPopupMenuAppearance.SaveToXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['CaptionFont', true];
  TLazRibbonXMLTools.Save(Subnode, FCaptionFont);

  // Checkbox rectangles
  Subnode := Node['CheckedFrameColor', true];
  Subnode.TextAsColor := FCheckedFrameColor;

  Subnode := Node['CheckedGradientFromColor', true];
  Subnode.TextAsColor := FCheckedGradientFromColor;

  Subnode := Node['CheckedGradientToColor', true];
  Subnode.TextAsColor := FCheckedGradientToColor;

  Subnode := Node['DisabledCaptionColor', true];
  Subnode.TextAsColor := FDisabledCaptionColor;

  Subnode := Node['DividerLineColor', true];
  Subnode.TextAsColor := FDividerlineColor;

  Subnode := Node['IdleGradientType', true];
  Subnode.TextAsInteger := integer(FIdleGradientType);

  // Idle
  Subnode := Node['IdleCaptionColor', true];
  Subnode.TextAsColor := FIdleCaptionColor;

//  Subnode := Node['IdleFrameColor', true];
//  Subnode.TextAsColor := FIdleFrameColor;

  Subnode := Node['IdleGradientFromColor', true];
  Subnode.TextAsColor := FIdleGradientFromColor;

  Subnode := Node['IdleGradientToColor', true];
  Subnode.TextAsColor := FIdleGradientToColor;

  Subnode := Node['IdleGradientType', true];
  Subnode.TextAsInteger := integer(FIdleGradientType);
{
  Subnode := Node['IdleInnerLightColor', true];
  Subnode.TextAsColor := FIdleInnerLightColor;

  Subnode := Node['IdleInnerDarkColor', true];
  Subnode.TextAsColor := FIdleInnerDarkColor;
}

  // Gutter
  Subnode := Node['GutterFrameColor', true];
  Subnode.TextAsColor := FGutterFrameColor;

  Subnode := Node['GutterGradientFromColor', true];
  Subnode.TextAsColor := FGutterGradientFromColor;

  Subnode := Node['GutterGradientToColor', true];
  Subnode.TextAsColor := FGutterGradientToColor;

  Subnode := Node['GutterGradientType', true];
  Subnode.TextAsInteger := integer(FGutterGradientType);


  // HotTrack
  Subnode := Node['HottrackCaptionColor', true];
  Subnode.TextAsColor := FHottrackCaptionColor;

  Subnode := Node['HottrackFrameColor', true];
  Subnode.TextAsColor := FHottrackFrameColor;

  Subnode := Node['HottrackGradientFromColor', true];
  Subnode.TextAsColor := FHottrackGradientFromColor;

  Subnode := Node['HottrackGradientToColor', true];
  Subnode.TextAsColor := FHottrackGradientToColor;

  Subnode := Node['HottrackGradientType', true];
  Subnode.TextAsInteger := integer(FHottrackGradientType);
{
  Subnode := Node['HottrackInnerLightColor', true];
  Subnode.TextAsColor := FHottrackInnerLightColor;

  Subnode := Node['HottrackInnerDarkColor', true];
  Subnode.TextAsColor := FHottrackInnerDarkColor;

  Subnode := Node['HottrackBrightnessChange', true];
  Subnode.TextAsInteger := FHotTrackBrightnessChange;
}

  // Other
  Subnode := Node['SelectionShape', true];
  Subnode.TextAsInteger := integer(FSelShape);

  Subnode := Node['Style', true];
  Subnode.TextAsInteger := integer(FStyle);
end;

procedure TLazRibbonPopupMenuAppearance.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont.Assign(Value);
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetCheckedFrameColor(const Value: TColor);
begin
  FCheckedFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetCheckedGradientFromColor(const Value: TColor);
begin
  FCheckedGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetCheckedGradientToColor(const Value: TColor);
begin
  FCheckedGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetCheckedGradientType(const Value: TBackgroundKind);
begin
  FCheckedGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetDisabledCaptionColor(const Value: TColor);
begin
  FDisabledCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetDividerLineColor(const Value: TColor);
begin
  FDividerLineColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetGutterGradientFromColor(const Value: TColor);
begin
  FGutterGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetGutterGradientToColor(const Value: TColor);
begin
  FGutterGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetGutterGradientType(const Value: TBackgroundKind);
begin
  FGutterGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetGutterFrameColor(const Value: TColor);
begin
  FGutterFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetHotTrackCaptionColor(const Value: TColor);
begin
  FHotTrackCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetHotTrackFrameColor(const Value: TColor);
begin
  FHotTrackFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetHotTrackGradientFromColor(const Value: TColor);
begin
  FHotTrackGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetHotTrackGradientToColor(const Value: TColor);
begin
  FHotTrackGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetHotTrackGradientType(const Value: TBackgroundKind);
begin
  FHotTrackGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetIdleGradientFromColor(const Value: TColor);
begin
  FIdleGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetIdleCaptionColor(const Value: TColor);
begin
  FIdleCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetIdleGradientToColor(const Value: TColor);
begin
  FIdleGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetIdleGradientType(const Value: TBackgroundKind);
begin
  FIdleGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetSelShape(const Value: TLazRibbonPopupSelectionShape);
begin
  FSelShape := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonPopupMenuAppearance.SetStyle(const Value: TLazRibbonPopupStyle);
begin
  FStyle := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;


{ TLazRibbonToolbarAppearanceDispatch }

constructor TLazRibbonToolbarAppearanceDispatch.Create(
  AToolbarAppearance: TLazRibbonToolbarAppearance);
begin
  inherited Create;
  FToolbarAppearance := AToolbarAppearance;
end;

procedure TLazRibbonToolbarAppearanceDispatch.NotifyAppearanceChanged;
begin
if FToolbarAppearance <> nil then
   FToolbarAppearance.NotifyAppearanceChanged;
end;


{ TLazRibbonToolbarAppearance }

constructor TLazRibbonToolbarAppearance.Create(ADispatch : TLazRibbonBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FAppearanceDispatch := TLazRibbonToolbarAppearanceDispatch.Create(self);
  FTab := TLazRibbonTabAppearance.Create(FAppearanceDispatch);
  FMenuButton := TLazRibbonMenuButtonAppearance.Create(FAppearanceDispatch);
  FPane := TLazRibbonPaneAppearance.create(FAppearanceDispatch);
  FElement := TLazRibbonElementAppearance.create(FAppearanceDispatch);
  FPopup := TLazRibbonPopupMenuAppearance.Create(FAppearanceDispatch);
end;

destructor TLazRibbonToolbarAppearance.Destroy;
begin
  FPopup.Free;
  FElement.Free;
  FPane.Free;
  FMenuButton.Free;
  FTab.Free;
  FAppearanceDispatch.Free;
  inherited;
end;

procedure TLazRibbonToolbarAppearance.Assign(Source: TPersistent);
var
  Src: TLazRibbonToolbarAppearance;
begin
  if Source is TLazRibbonToolbarAppearance then
  begin
    Src := TLazRibbonToolbarAppearance(Source);

    self.FTab.Assign(Src.Tab);
    self.FMenuButton.Assign(Src.MenuButton);
    self.FPane.Assign(Src.Pane);
    self.FElement.Assign(Src.Element);
    self.FPopup.Assign(Src.Popup);

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end else
    raise AssignException.Create('TLazRibbonToolbarAppearance.Assign: Cannot assign the object '+Source.ClassName+' to TLazRibbonToolbarAppearance!');
end;

procedure TLazRibbonToolbarAppearance.LoadFromXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  Tab.Reset;
  MenuButton.Reset;
  Pane.Reset;
  Element.Reset;
  Popup.Reset;

  if not Assigned(Node) then
    exit;

  Subnode := Node['Tab', false];
  if Assigned(Subnode) then
    Tab.LoadFromXML(Subnode);

  Subnode := Node['MenuButton', false];
  if not Assigned(Subnode) then
    Subnode := Node['Menu Button', false];
  if Assigned(Subnode) then
    MenuButton.LoadFromXML(Subnode);

  Subnode := Node['Pane', false];
  if Assigned(Subnode) then
    Pane.LoadFromXML(Subnode);

  Subnode := Node['Element', false];
  if Assigned(Subnode) then
    Element.LoadFromXML(Subnode);

  Subnode := Node['Popup', false];
  if Assigned(Subnode) then
    Popup.LoadFromXML(Subnode);
end;

procedure TLazRibbonToolbarAppearance.NotifyAppearanceChanged;
begin
  if Assigned(FDispatch) then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonToolbarAppearance.Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);
begin
  FTab.Reset(AStyle);
  FMenuButton.Reset(AStyle);
  FPane.Reset(AStyle);
  FElement.Reset(AStyle);
  FPopup.Reset(AStyle);
  if Assigned(FAppearanceDispatch) then
    FAppearanceDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonToolbarAppearance.SaveToPascal(AList: TStrings);
begin
  AList.Add('with Appearance do begin');
  FTab.SaveToPascal(AList);
  FMenuButton.SaveToPascal(AList);
  FPane.SaveToPascal(AList);
  FElement.SaveToPascal(AList);
  FPopup.SaveToPascal(AList);
  AList.Add('end;');
end;

procedure TLazRibbonToolbarAppearance.SaveToXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  Subnode := Node['Tab',true];
  FTab.SaveToXML(Subnode);

  Subnode := Node['MenuButton', true];
  FMenuButton.SaveToXML(Subnode);

  Subnode := Node['Pane',true];
  FPane.SaveToXML(Subnode);

  Subnode := Node['Element',true];
  FElement.SaveToXML(Subnode);

  Subnode := Node['Popup', true];
  FPopup.SaveToXML(Subnode);
end;

procedure TLazRibbonToolbarAppearance.SetElementAppearance(
  const Value: TLazRibbonElementAppearance);
begin
  FElement.Assign(Value);
end;

procedure TLazRibbonToolbarAppearance.SetPaneAppearance(const Value: TLazRibbonPaneAppearance);
begin
  FPane.Assign(Value);
end;

procedure TLazRibbonToolbarAppearance.SetPopupAppearance(const Value: TLazRibbonPopupMenuAppearance);
begin
  FPopup.Assign(Value);
end;

procedure TLazRibbonToolbarAppearance.SetTabAppearance(const Value: TLazRibbonTabAppearance);
begin
  FTab.Assign(Value);
end;

procedure SetDefaultFont(AFont: TFont);
begin
  //AFont.Assign(Screen.MenuFont);  // wp: If this really is harmful this proc should be removed.
end;

procedure TLazRibbonToolbarAppearance.SetMenubuttonAppearance(const Value: TLazRibbonMenuButtonAppearance);
begin
  FMenuButton.Assign(Value);
end;

//****

constructor TLazRibbonMenuButtonAppearance.Create(ADispatch: TLazRibbonBaseAppearanceDispatch);
begin
  inherited Create;
  FDispatch := ADispatch;
  FCaptionFont := TFont.Create;
  FCaptionFont.OnChange := CaptionFontChange;
  FHotTrackBrightnessChange := 40;
  Reset;
end;

destructor TLazRibbonMenuButtonAppearance.Destroy;
begin
  FCaptionFont.Free;
  inherited Destroy;
end;

procedure TLazRibbonMenuButtonAppearance.Assign(Source: TPersistent);
var
  SrcAppearance: TLazRibbonMenuButtonAppearance;
begin
  if Source is TLazRibbonMenuButtonAppearance then
  begin
    SrcAppearance := TLazRibbonMenuButtonAppearance(Source);

    FCaptionFont.Assign(SrcAppearance.CaptionFont);
    FIdleFrameColor := SrcAppearance.IdleFrameColor;
    FIdleGradientFromColor := SrcAppearance.IdleGradientFromColor;
    FIdleGradientToColor := SrcAppearance.IdleGradientToColor;
    FIdleGradientType := SrcAppearance.IdleGradientType;
    FIdleCaptionColor := SrcAppearance.IdleCaptionColor;
    FHotTrackFrameColor := SrcAppearance.HotTrackFrameColor;
    FHotTrackGradientFromColor := SrcAppearance.HotTrackGradientFromColor;
    FHotTrackGradientToColor := SrcAppearance.HotTrackGradientToColor;
    FHotTrackGradientType := SrcAppearance.HotTrackGradientType;
    FHotTrackCaptionColor := SrcAppearance.HotTrackCaptionColor;
    FHotTrackBrightnessChange := SrcAppearance.HotTrackBrightnessChange;
    FActiveFrameColor := SrcAppearance.ActiveFrameColor;
    FActiveGradientFromColor := SrcAppearance.ActiveGradientFromColor;
    FActiveGradientToColor := SrcAppearance.ActiveGradientToColor;
    FActiveGradientType := SrcAppearance.ActiveGradientType;
    FActiveCaptionColor := SrcAppearance.ActiveCaptionColor;
    FShapeStyle := SrcAppearance.ShapeStyle;

    if FDispatch <> nil then
      FDispatch.NotifyAppearanceChanged;
  end else
    raise AssignException.Create('TLazRibbonMenuButtonAppearance.Assign: Cannot assign the objecct '+Source.ClassName+' to TLazRibbonMenuButtonAppearance!');
end;

procedure TLazRibbonMenuButtonAppearance.CaptionFontChange(Sender: TObject);
begin
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.GetActiveColors(IsChecked: Boolean;
  out ACaptionColor, AFrameColor, AGradientFromColor, AGradientToColor: TColor;
  out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = -20;
begin
  ACaptionColor := FActiveCaptionColor;
  AFrameColor := FActiveFrameColor;
  AGradientFromColor := FActiveGradientFromColor;
  AGradientToColor := FActiveGradientToColor;
  AGradientKind := FActiveGradientType;

  if IsChecked then
    ABrightenBy := DELTA + ABrightenBy;

  if ABrightenBy <> 0 then
  begin
    ACaptionColor := TColorTools.Brighten(ACaptionColor, ABrightenBy);
    AFrameColor := TColorTools.Brighten(AFrameColor, ABrightenBy);
    AGradientFromColor := TColorTools.Brighten(AGradientFromColor, ABrightenBy);
    AGradientToColor := TColorTools.Brighten(AGradientToColor, ABrightenBy);
  end;
end;

procedure TLazRibbonMenuButtonAppearance.GetIdleColors(IsChecked: Boolean;
  out ACaptionColor, AFrameColor, AGradientFromColor, AGradientToColor: TColor;
  out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = 10;
begin
  if IsChecked then
  begin
    ABrightenBy := DELTA + ABrightenBy;
    ACaptionColor := FActiveCaptionColor;
    AFrameColor := FActiveFrameColor;
    AGradientFromColor := FActiveGradientFromColor;
    AGradientToColor := FActiveGradientToColor;
    AGradientKind := FActiveGradientType;
  end else
  begin
    ACaptionColor := FIdleCaptionColor;
    AFrameColor := FIdleFrameColor;
    AGradientFromColor := FIdleGradientFromColor;
    AGradientToColor := FIdleGradientToColor;
    AGradientKind := FIdleGradientType;
  end;

  if ABrightenBy <> 0 then
  begin
    ACaptionColor := TColorTools.Brighten(ACaptionColor, ABrightenBy);
    AFrameColor := TColorTools.Brighten(AFrameColor, ABrightenBy);
    AGradientFromColor := TColorTools.Brighten(AGradientFromColor, ABrightenBy);
    AGradientToColor := TColorTools.Brighten(AGradientToColor, ABrightenBy);
  end;
end;

procedure TLazRibbonMenuButtonAppearance.GetHotTrackColors(IsChecked: Boolean;
  out ACaptionColor, AFrameColor, AGradientFromColor, AGradientToColor: TColor;
  out AGradientKind: TBackgroundKind; ABrightenBy: Integer = 0);
const
  DELTA = 20;
begin
  if IsChecked then begin
    ABrightenBy := ABrightenBy + DELTA;
    ACaptionColor := FActiveCaptionColor;
    AFrameColor := FActiveFrameColor;
    AGradientFromColor := FActiveGradientFromColor;
    AGradientToColor := FActiveGradientToColor;
    AGradientKind := FActiveGradientType;
  end else begin
    ACaptionColor := FHotTrackCaptionColor;
    AFrameColor := FHotTrackFrameColor;
    AGradientFromColor := FHotTrackGradientFromColor;
    AGradientToColor := FHotTrackGradientToColor;
    AGradientKind := FHotTrackGradientType;
  end;
  if ABrightenBy <> 0 then begin
    ACaptionColor := TColorTools.Brighten(ACaptionColor, ABrightenBy);
    AFrameColor := TColorTools.Brighten(AFrameColor, ABrightenBy);
    AGradientFromColor := TColorTools.Brighten(AGradientFromColor, ABrightenBy);
    AGradientToColor := TColorTools.Brighten(AGradientToColor, ABrightenBy);
  end;
end;

procedure TLazRibbonMenuButtonAppearance.LoadFromXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['CaptionFont', false];
  if Assigned(Subnode) then
    TLazRibbonXMLTools.Load(Subnode, FCaptionFont);

  // Idle
  Subnode := Node['IdleFrameColor', false];
  if Assigned(Subnode) then
    FIdleFrameColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientFromColor', false];
  if Assigned(Subnode) then
    FIdleGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientToColor', false];
  if Assigned(Subnode) then
    FIdleGradientToColor := Subnode.TextAsColor;

  Subnode := Node['IdleGradientType', false];
  if Assigned(Subnode) then
    FIdleGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['IdleCaptionColor', false];
  if Assigned(Subnode) then
    FIdleCaptionColor := Subnode.TextAsColor;

  // HotTrack
  Subnode := Node['HottrackFrameColor', false];
  if Assigned(Subnode) then
    FHottrackFrameColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientFromColor', false];
  if Assigned(Subnode) then
    FHottrackGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientToColor', false];
  if Assigned(Subnode) then
    FHottrackGradientToColor := Subnode.TextAsColor;

  Subnode := Node['HottrackGradientType', false];
  if Assigned(Subnode) then
    FHottrackGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['HottrackCaptionColor', false];
  if Assigned(Subnode) then
    FHottrackCaptionColor := Subnode.TextAsColor;

  Subnode := Node['HottrackBrightnessChange', false];
  if Assigned(Subnode) then
    FHottrackBrightnessChange := Subnode.TextAsInteger;

  // Active
  Subnode := Node['ActiveFrameColor', false];
  if Assigned(Subnode) then
    FActiveFrameColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientFromColor', false];
  if Assigned(Subnode) then
    FActiveGradientFromColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientToColor', false];
  if Assigned(Subnode) then
    FActiveGradientToColor := Subnode.TextAsColor;

  Subnode := Node['ActiveGradientType', false];
  if Assigned(Subnode) then
    FActiveGradientType := TBackgroundKind(Subnode.TextAsInteger);

  Subnode := Node['ActiveCaptionColor', false];
  if Assigned(Subnode) then
    FActiveCaptionColor := Subnode.TextAsColor;

  // Other
  Subnode := Node['ShapeStyle', false];
  if Assigned(SubNode) then
    FShapeStyle := TLazRibbonMenuButtonShapeStyle(Subnode.TextAsInteger);
end;

procedure TLazRibbonMenuButtonAppearance.Reset(AStyle: TLazRibbonStyle = lazOffice2007Blue);
begin
  SetDefaultFont(FCaptionFont);

  case AStyle of
    lazOffice2007Blue,
    lazOffice2007Silver,
    lazOffice2007SilverTurquoise,
    lazOffice2007Rose,
    lazOffice2007Sage:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $00FFFFFF;
        FIdleFrameColor := $00A1481F;
        FIdleGradientFromColor := $00DF8A47;
        FIdleGradientToColor := $00B76129;
        FIdleGradientType := bkConcave;
        FIdleCaptionColor := $00FFFFFF;
        FHotTrackFrameColor := $00A1481F;
        FHotTrackGradientFromColor := $00E79D5B;
        FHotTrackGradientToColor := $00BE6731;
        FHotTrackGradientType := bkConcave;
        FHotTrackCaptionColor := $00FFFFFF;
        FHotTrackBrightnessChange := 40;
        FActiveFrameColor := $00A94D1C;
        FActiveGradientFromColor := $00DD8A3E;
        FActiveGradientToColor := $00BD6126;
        FActiveGradientType := bkConcave;
        FActiveCaptionColor := $00FFFFFF;
        FShapeStyle := mbssRounded;
      end;

    lazMetroLight:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $00FFFFFF;
        FIdleFrameColor := $00B46600;
        FIdleGradientFromColor := $00B46600;
        FIdleGradientToColor := $00B46600;
        FIdleGradientType := bkSolid;
        FIdleCaptionColor := $00FFFFFF;
        FHotTrackFrameColor := $00DD7D00;
        FHotTrackGradientFromColor := $00DD7D00;
        FHotTrackGradientToColor := $00DD7D00;
        FHotTrackGradientType := bkSolid;
        FHotTrackCaptionColor := $00FFFFFF;
        FHotTrackBrightnessChange := 20;
        FActiveFrameColor := $00965500;
        FActiveGradientFromColor := $00965500;
        FActiveGradientToColor := $00965500;
        FActiveGradientType := bkSolid;
        FActiveCaptionColor := $00FFFFFF;
        FShapeStyle := mbssRectangle;
      end;

    lazMetroDark:
      begin
        FCaptionFont.Style := [];
        FCaptionFont.Color := $00FFFFFF;
        FIdleFrameColor := $00B46600;
        FIdleGradientFromColor := $00B46600;
        FIdleGradientToColor := $00B46600;
        FIdleGradientType := bkSolid;
        FIdleCaptionColor := $00FFFFFF;
        FHotTrackFrameColor := $00DD7D00;
        FHotTrackGradientFromColor := $00DD7D00;
        FHotTrackGradientToColor := $00DD7D00;
        FHotTrackGradientType := bkSolid;
        FHotTrackCaptionColor := $00FFFFFF;
        FHotTrackBrightnessChange := 10;
        FActiveFrameColor := $00965500;
        FActiveGradientFromColor := $00965500;
        FActiveGradientToColor := $00965500;
        FActiveGradientType := bkSolid;
        FActiveCaptionColor := $00FFFFFF;
        FShapeStyle := mbssRectangle;
      end;

    { StyleMaker:MenuButtonReset:Begin }
    { StyleMaker:lazOffice2007Bege:Begin }
    lazOffice2007Bege:
      begin
        CaptionFont.Name := 'default';
        CaptionFont.Size := 0;
        CaptionFont.Style := [];
        CaptionFont.Color := $00FFFFFF;
        IdleFrameColor := $00FDF9F7;
        IdleGradientFromColor := $00DF8A47;
        IdleGradientToColor := $00110A04;
        IdleGradientType := bkConcave;
        IdleCaptionColor := $00FFFFFF;
        HotTrackFrameColor := $00A1481F;
        HotTrackGradientFromColor := $00E79D5B;
        HotTrackGradientToColor := $00000000;
        HotTrackGradientType := bkConcave;
        HotTrackCaptionColor := $00FFFFFF;
        HotTrackBrightnessChange := 40;
        ActiveFrameColor := $00A94D1C;
        ActiveGradientFromColor := $00DD8A3E;
        ActiveGradientToColor := $00BD6126;
        ActiveGradientType := bkConcave;
        ActiveCaptionColor := $00FFFFFF;
        ShapeStyle := mbssRectangle;
      end;
{ StyleMaker:lazOffice2007Bege:End }
{ StyleMaker:MenuButtonReset:End }
  end;
end;

procedure TLazRibbonMenuButtonAppearance.SaveToPascal(AList: TStrings);
begin
  with AList do begin
    Add('  with MenuButton do begin');
    SaveFontToPascal(AList, FCaptionFont, '    CaptionFont');

    Add('    IdleFrameColor := $' + IntToHex(FIdleFrameColor, 8) + ';');
    Add('    IdleGradientFromColor := $' + IntToHex(FIdleGradientFromColor, 8) + ';');
    Add('    IdleGradientToColor := $' + IntToHex(FIdleGradientToColor, 8) + ';');
    Add('    IdleGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FIdleGradientType)) + ';');
    Add('    IdleCaptionColor := $' + IntToHex(FIdleCaptionColor, 8) + ';');

    Add('    HotTrackFrameColor := $' + IntToHex(FHotTrackFrameColor, 8) + ';');
    Add('    HotTrackGradientFromColor := $' + IntToHex(FHotTrackGradientFromColor, 8) + ';');
    Add('    HotTrackGradientToColor := $' + IntToHex(FHotTrackGradientToColor, 8) + ';');
    Add('    HotTrackGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FHotTrackGradientType)) + ';');
    Add('    HotTrackCaptionColor := $' + IntToHex(FHotTrackCaptionColor, 8) + ';');
    Add('    HotTrackBrightnessChange := ' + IntToStr(FHotTrackBrightnessChange) + ';');

    Add('    ActiveFrameColor := $' + IntToHex(FActiveFrameColor, 8) + ';');
    Add('    ActiveGradientFromColor := $' + IntToHex(FActiveGradientFromColor, 8) + ';');
    Add('    ActiveGradientToColor := $' + IntToHex(FActiveGradientToColor, 8) + ';');
    Add('    ActiveGradientType := ' + GetEnumName(TypeInfo(TBackgroundKind), ord(FActiveGradientType)) + ';');
    Add('    ActiveCaptionColor := $' + IntToHex(FActiveCaptionColor, 8) + ';');

    Add('    ShapeStyle := ' + GetEnumName(TypeInfo(TLazRibbonMenuButtonShapeStyle), ord(FShapeStyle)) + ';');
    Add('  end;');
  end;
end;

procedure TLazRibbonMenuButtonAppearance.SaveToXML(Node: TLazRibbonXMLNode);
var
  Subnode: TLazRibbonXMLNode;
begin
  if not Assigned(Node) then
    exit;

  Subnode := Node['CaptionFont', true];
  TLazRibbonXMLTools.Save(Subnode, FCaptionFont);

  // Idle
  Subnode := Node['IdleFrameColor', true];
  Subnode.TextAsColor := FIdleFrameColor;

  Subnode := Node['IdleGradientFromColor', true];
  Subnode.TextAsColor := FIdleGradientFromColor;

  Subnode := Node['IdleGradientToColor', true];
  Subnode.TextAsColor := FIdleGradientToColor;

  Subnode := Node['IdleGradientType', true];
  Subnode.TextAsInteger := integer(FIdleGradientType);

  Subnode := Node['IdleCaptionColor', true];
  Subnode.TextAsColor := FIdleCaptionColor;

  // HotTrack
  Subnode := Node['HottrackFrameColor', true];
  Subnode.TextAsColor := FHottrackFrameColor;

  Subnode := Node['HottrackGradientFromColor', true];
  Subnode.TextAsColor := FHottrackGradientFromColor;

  Subnode := Node['HottrackGradientToColor', true];
  Subnode.TextAsColor := FHottrackGradientToColor;

  Subnode := Node['HottrackGradientType', true];
  Subnode.TextAsInteger := integer(FHottrackGradientType);

  Subnode := Node['HottrackCaptionColor', true];
  Subnode.TextAsColor := FHottrackCaptionColor;

  Subnode := Node['HottrackBrightnessChange', true];
  Subnode.TextAsInteger := FHotTrackBrightnessChange;

  // Active
  Subnode := Node['ActiveFrameColor', true];
  Subnode.TextAsColor := FActiveFrameColor;

  Subnode := Node['ActiveGradientFromColor', true];
  Subnode.TextAsColor := FActiveGradientFromColor;

  Subnode := Node['ActiveGradientToColor', true];
  Subnode.TextAsColor := FActiveGradientToColor;

  Subnode := Node['ActiveGradientType', true];
  Subnode.TextAsInteger := integer(FActiveGradientType);

  Subnode := Node['ActiveCaptionColor', true];
  Subnode.TextAsColor := FActiveCaptionColor;

  // Other
  Subnode := Node['ShapeStyle', true];
  Subnode.TextAsInteger := integer(FShapeStyle);
end;

procedure TLazRibbonMenuButtonAppearance.SetActiveCaptionColor(const Value: TColor);
begin
  FActiveCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetActiveFrameColor(const Value: TColor);
begin
  FActiveFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetActiveGradientFromColor(const Value: TColor);
begin
  FActiveGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetActiveGradientToColor(const Value: TColor);
begin
  FActiveGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetActiveGradientType(const Value: TBackgroundKind);
begin
  FActiveGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont.Assign(Value);
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetHotTrackBrightnessChange(const Value: Integer);
begin
  FHotTrackBrightnessChange := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetHotTrackCaptionColor(const Value: TColor);
begin
  FHotTrackCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetHotTrackFrameColor(const Value: TColor);
begin
  FHotTrackFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetHotTrackGradientFromColor(const Value: TColor);
begin
  FHotTrackGradientFromColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetHotTrackGradientToColor(const Value: TColor);
begin
  FHotTrackGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetHotTrackGradientType(const Value: TBackgroundKind);
begin
  FHotTrackGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetIdleCaptionColor(const Value: TColor);
begin
  FIdleCaptionColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetIdleFrameColor(const Value: TColor);
begin
  FIdleFrameColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetIdleGradientFromColor(const Value: TColor);
begin
  FIdleGradientFromColor := Value;
  if FDispatch <> nil then
     FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetIdleGradientToColor(const Value: TColor);
begin
  FIdleGradientToColor := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetIdleGradientType(const Value: TBackgroundKind);
begin
  FIdleGradientType := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;

procedure TLazRibbonMenuButtonAppearance.SetShapeStyle(const Value: TLazRibbonMenuButtonShapeStyle);
begin
  FShapeStyle := Value;
  if FDispatch <> nil then
    FDispatch.NotifyAppearanceChanged;
end;


end.
