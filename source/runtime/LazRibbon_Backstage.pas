unit LazRibbon_Backstage;

{$mode Delphi}{$H+}

(*******************************************************************************
*                                                                              *
*  File:        LazRibbon_Backstage.pas                                             *
*  Description: Backstage view component for LazRibbon_Core-style Ribbon UIs       *
*  License:     Modified LGPL (with linking exception, like Lazarus LCL)       *
*                                                                              *
*******************************************************************************)

interface

uses
  Classes, SysUtils, Math, Graphics, Controls, Forms, StdCtrls, Types, LCLType, LCLIntf, ActnList, ImgList, IniFiles,
  LazRibbon_Core, LazRibbon_Appearance, LazRibbon_Dispatch, LazRibbon_RibbonCommands, LazRibbon_SkinManager,
  LazRibbon_GUITools, LazRibbon_BackstageBase, LazRibbon_BaseItem, LazRibbon_Buttons;

type
  TLazRibbonBackstageView = class;
  TLazRibbonBackstagePage = class;
  TLazRibbonBackstageButton = class;

  TLazRibbonBackstageCloseEvent = procedure(Sender: TObject; var CanClose: Boolean) of object;
  TLazRibbonBackstagePageChangedEvent = procedure(Sender: TObject; OldIndex, NewIndex: Integer) of object;
  TLazRibbonBackstageRecentItemClickEvent = procedure(Sender: TObject; Index: Integer; const Title, Detail: String) of object;

  { Defines how BackStage is positioned when it is opened at runtime.
    bomNone keeps the component in its normal design-time position.
    bomCoverRibbonArea keeps the tab captions visible and covers the ribbon body
    plus the client area for applications that want the older tab-preserving
    layout.
    bomCoverClientArea covers the full parent client area and is the default
    newer Office-style BackStage behavior. }
  TLazRibbonBackstageOverlayMode = (bomNone, bomCoverRibbonArea,
    bomCoverClientArea);

  { Defines what a left navigation entry represents.
    bpkPage shows a content page.
    bpkCommand executes Action, Command or OnExecute without switching page.
    bpkSeparator draws a visual separator in the navigation column. }
  TLazRibbonBackstagePageKind = (bpkPage, bpkCommand, bpkSeparator);

  { Defines how the BackStage navigation column is painted. }
  TLazRibbonBackstageNavigationStyle = (bnsClassic, bnsOffice);

  { Defines how the BackStage return button is painted. }
  TLazRibbonBackstageBackButtonStyle = (bbsPlainChevron, bbsCircleChevron);

  { Defines how BackStage entries linked to pages are painted.
    bpvmSelectable is the recommended/default behavior for this package: every
    BackStage option linked to a page acts as a selectable navigation entry and
    changes the content panel at the right.
    bpvmFixedHeader is kept only for compatibility with the earlier single-page
    DevExpress-like experiment, where page entries behave as fixed anchors. }
  TLazRibbonBackstagePageButtonVisualMode = (bpvmFixedHeader, bpvmSelectable);

  { Defines how recent-file rows highlight selection and hover.
    brsSkin uses the active skin palette.
    brsOfficeGold uses the Office/DevExpress-like gold highlight. }
  TLazRibbonBackstageRecentSelectionStyle = (brsSkin, brsOfficeGold);

  { Defines whether TLazRibbonBackstageRecentList shows its internal vertical scrollbar. }
  TLazRibbonBackstageRecentScrollBarMode = (rsmAuto, rsmAlways, rsmNever);

  { Defines what a BackStage navigation button represents. }
  TLazRibbonBackstageButtonKind = (bbkPage, bbkCommand, bbkSeparator);

  { Defines where a BackStage navigation button is placed. }
  TLazRibbonBackstageButtonSection = (bbsTop, bbsBottom);

  { TLazRibbonBackstageButton }

  TLazRibbonBackstageButton = class(TCollectionItem)
  private
    FAction: TBasicAction;
    FBeginGroup: Boolean;
    FCaption: TCaption;
    FCloseBackstageOnClick: Boolean;
    FEnabled: Boolean;
    FHint: String;
    FImageIndex: Integer;
    FLargeImageIndex: Integer;
    FKind: TLazRibbonBackstageButtonKind;
    FLinkedItem: TLazRibbonBaseItem;
    FSection: TLazRibbonBackstageButtonSection;
    FPage: TLazRibbonBackstagePage;
    FVisible: Boolean;
    FOnExecute: TNotifyEvent;
    procedure Changed;
    procedure SetAction(AValue: TBasicAction);
    procedure SetBeginGroup(AValue: Boolean);
    procedure SetCaption(const AValue: TCaption);
    procedure SetCloseBackstageOnClick(AValue: Boolean);
    procedure SetEnabled(AValue: Boolean);
    procedure SetHint(const AValue: String);
    procedure SetImageIndex(AValue: Integer);
    procedure SetLargeImageIndex(AValue: Integer);
    procedure SetKind(AValue: TLazRibbonBackstageButtonKind);
    procedure SetLinkedItem(AValue: TLazRibbonBaseItem);
    procedure SetSection(AValue: TLazRibbonBackstageButtonSection);
    procedure SetPage(AValue: TLazRibbonBackstagePage);
    procedure SetVisible(AValue: Boolean);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    function EffectiveCaption: TCaption; virtual;
    function EffectiveEnabled: Boolean; virtual;
    function EffectiveHint: String; virtual;
    function EffectiveImageIndex: Integer; virtual;
    function EffectiveLargeImageIndex: Integer; virtual;
    function EffectiveVisible: Boolean; virtual;
    procedure Execute; virtual;
  published
    property Action: TBasicAction read FAction write SetAction;
    property BeginGroup: Boolean read FBeginGroup write SetBeginGroup default False;
    property Caption: TCaption read FCaption write SetCaption;
    property CloseBackstageOnClick: Boolean read FCloseBackstageOnClick write SetCloseBackstageOnClick default True;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Hint: String read FHint write SetHint;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property LargeImageIndex: Integer read FLargeImageIndex write SetLargeImageIndex default -1;
    property Kind: TLazRibbonBackstageButtonKind read FKind write SetKind default bbkPage;
    property LinkedItem: TLazRibbonBaseItem read FLinkedItem write SetLinkedItem;
    property Section: TLazRibbonBackstageButtonSection read FSection write SetSection default bbsTop;
    property Page: TLazRibbonBackstagePage read FPage write SetPage;
    property Visible: Boolean read FVisible write SetVisible default True;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
  end;

  { TLazRibbonBackstageButtons }

  TLazRibbonBackstageButtons = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TLazRibbonBackstageButton;
    procedure SetItem(Index: Integer; AValue: TLazRibbonBackstageButton);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TLazRibbonBackstageButton;
    function AddCommand(AAction: TBasicAction; const ACaption: TCaption = ''): TLazRibbonBackstageButton;
    function AddPage(APage: TLazRibbonBackstagePage; const ACaption: TCaption = ''): TLazRibbonBackstageButton;
    function AddSeparator: TLazRibbonBackstageButton;
    function OwnerView: TLazRibbonBackstageView;
    property Items[Index: Integer]: TLazRibbonBackstageButton read GetItem write SetItem; default;
  end;

  { TLazRibbonBackstagePage }

  TLazRibbonBackstagePage = class(TCustomControl)
  private
    FCaption: TCaption;
    FCloseBackstageOnClick: Boolean;
    FCommand: TLazRibbonCommand;
    FItemKind: TLazRibbonBackstagePageKind;
    FOnExecute: TNotifyEvent;
    procedure SetCaption(const AValue: TCaption);
    procedure SetCommand(AValue: TLazRibbonCommand);
    procedure SetItemKind(AValue: TLazRibbonBackstagePageKind);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetParent(NewParent: TWinControl); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    function EffectiveCaption: TCaption; virtual;
    function EffectiveEnabled: Boolean; virtual;
    function EffectiveHint: String; virtual;
    function EffectiveImageIndex: Integer; virtual;
    function EffectiveVisible: Boolean; virtual;
    procedure Execute; virtual;
    { Source-level compatibility for the older page-as-command model. New forms
      should compose BackStage navigation and commands through
      TLazRibbonBackstageView.Buttons. }
    property Action;
    property Command: TLazRibbonCommand read FCommand write SetCommand;
    property CloseBackstageOnClick: Boolean read FCloseBackstageOnClick write FCloseBackstageOnClick default True;
    property ItemKind: TLazRibbonBackstagePageKind read FItemKind write SetItemKind default bpkPage;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
  published
    property Caption: TCaption read FCaption write SetCaption;
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color default clWhite;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;


  { TLazRibbonBackstageRecentList }

  TLazRibbonBackstageRecentList = class(TCustomControl)
  private
    FAppearanceSource: TLazRibbonAppearanceSource;
    FHoverIndex: Integer;
    FImageIndex: Integer;
    FImages: TCustomImageList;
    FItemHeight: Integer;
    FItems: TStringList;
    FMaxRecentItems: Integer;
    FSkinManager: TLazRibbonSkinManager;
    FScrollBar: TScrollBar;
    FScrollBarMode: TLazRibbonBackstageRecentScrollBarMode;
    FScrollBarWidth: Integer;
    FScrollOffset: Integer;
    FSelectedIndex: Integer;
    FSelectionStyle: TLazRibbonBackstageRecentSelectionStyle;
    FStorageSection: String;
    FOnItemClick: TLazRibbonBackstageRecentItemClickEvent;
    procedure ItemsChanged(Sender: TObject);
    function GetItems: TStrings;
    function GetMaxScrollOffset: Integer;
    function GetVisibleRight: Integer;
    procedure ClampScrollOffset;
    procedure EnsureItemVisible(AIndex: Integer);
    procedure ParseItem(AIndex: Integer; out ATitle, ADetail: String);
    function GetItemRect(AIndex: Integer): TRect;
    procedure ScrollBarChange(Sender: TObject);
    procedure SetAppearanceSource(AValue: TLazRibbonAppearanceSource);
    procedure SetImageIndex(AValue: Integer);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetItemHeight(AValue: Integer);
    procedure SetItems(AValue: TStrings);
    procedure SetMaxRecentItems(AValue: Integer);
    procedure SetScrollBarMode(AValue: TLazRibbonBackstageRecentScrollBarMode);
    procedure SetScrollBarWidth(AValue: Integer);
    procedure SetSelectedIndex(AValue: Integer);
    procedure SetSelectionStyle(AValue: TLazRibbonBackstageRecentSelectionStyle);
    procedure SetSkinManager(AValue: TLazRibbonSkinManager);
    procedure SetStorageSection(const AValue: String);
    procedure UpdateScrollBar;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddRecent(const ATitle, ADetail: String); virtual;
    procedure ClearRecent; virtual;
    procedure DeleteRecent(AIndex: Integer); virtual;
    function ItemAtPos(X, Y: Integer): Integer;
    function ItemTitle(AIndex: Integer): String;
    function ItemDetail(AIndex: Integer): String;
    procedure LoadFromIniFile(const AFileName: String; const ASection: String = ''); virtual;
    procedure SaveToIniFile(const AFileName: String; const ASection: String = ''); virtual;
  published
    property Align;
    property Anchors;
    property BorderSpacing;
    property Color default clWhite;
    property Constraints;
    property Enabled;
    property Font;
    property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asInternalStyle;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property Images: TCustomImageList read FImages write SetImages;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 58;
    property Items: TStrings read GetItems write SetItems;
    property MaxRecentItems: Integer read FMaxRecentItems write SetMaxRecentItems default 20;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedIndex: Integer read FSelectedIndex write SetSelectedIndex default -1;
    property SelectionStyle: TLazRibbonBackstageRecentSelectionStyle read FSelectionStyle write SetSelectionStyle default brsSkin;
    property ScrollBarMode: TLazRibbonBackstageRecentScrollBarMode read FScrollBarMode write SetScrollBarMode default rsmAuto;
    property ScrollBarWidth: Integer read FScrollBarWidth write SetScrollBarWidth default 12;
    property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;
    property StorageSection: String read FStorageSection write SetStorageSection;
    property ShowHint;
    property Visible;
    property OnItemClick: TLazRibbonBackstageRecentItemClickEvent read FOnItemClick write FOnItemClick;
  end;

  { TLazRibbonBackstageView }

  TLazRibbonBackstageView = class(TLazRibbonCustomBackstageView)
  private
    FActivePageIndex: Integer;
    FAppearanceSource: TLazRibbonAppearanceSource;
    FAutoHideAtRuntime: Boolean;
    FBackstageTabCaption: TCaption;
    FBackButtonHint: String;
    FBackButtonStyle: TLazRibbonBackstageBackButtonStyle;
    FButtons: TLazRibbonBackstageButtons;
    FCloseButtonAreaHeight: Integer;
    FCloseOnEscape: Boolean;
    FCloseOnRibbonTabClick: Boolean;
    FHeaderHeight: Integer;
    FHoverPageIndex: Integer;
    FImages: TCustomImageList;
    FLargeImages: TCustomImageList;
    FItemHeight: Integer;
    FLinkedToolbar: TLazRibbon;
    FNavigationStyle: TLazRibbonBackstageNavigationStyle;
    FPageButtonVisualMode: TLazRibbonBackstagePageButtonVisualMode;
    FNavigationWidth: Integer;
    FOldToolbarMenuButtonClick: TNotifyEvent;
    FOldToolbarTabChanging: TLazRibbonTabChangingEvent;
    FOpenOnTabCaption: Boolean;
    FOverlayActive: Boolean;
    FOverlayMode: TLazRibbonBackstageOverlayMode;
    FPressedPageIndex: Integer;
    FSavedAlign: TAlign;
    FSavedAnchors: TAnchors;
    FSavedBounds: TRect;
    FBackButtonVisible: Boolean;
    FSkinManager: TLazRibbonSkinManager;
    FStyle: TLazRibbonStyle;
    FTitle: TCaption;
    FToolbarEventsHooked: Boolean;
    FOnClose: TLazRibbonBackstageCloseEvent;
    FOnClosed: TNotifyEvent;
    FOnPageChanged: TLazRibbonBackstagePageChangedEvent;
    procedure SetActivePageIndex(AValue: Integer);
    procedure SetAppearanceSource(AValue: TLazRibbonAppearanceSource);
    procedure SetBackstageTabCaption(const AValue: TCaption);
    procedure SetBackButtonHint(const AValue: String);
    procedure SetBackButtonStyle(AValue: TLazRibbonBackstageBackButtonStyle);
    procedure SetButtons(AValue: TLazRibbonBackstageButtons);
    procedure SetCloseButtonAreaHeight(AValue: Integer);
    procedure SetCloseOnEscape(AValue: Boolean);
    procedure SetCloseOnRibbonTabClick(AValue: Boolean);
    procedure SetHeaderHeight(AValue: Integer);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetLargeImages(AValue: TCustomImageList);
    procedure SetItemHeight(AValue: Integer);
    procedure SetLinkedToolbar(AValue: TLazRibbon);
    procedure SetNavigationStyle(AValue: TLazRibbonBackstageNavigationStyle);
    procedure SetPageButtonVisualMode(AValue: TLazRibbonBackstagePageButtonVisualMode);
    procedure SetNavigationWidth(AValue: Integer);
    procedure SetOpenOnTabCaption(AValue: Boolean);
    procedure SetOverlayMode(AValue: TLazRibbonBackstageOverlayMode);
    procedure SetBackButtonVisible(AValue: Boolean);
    procedure SetSkinManager(AValue: TLazRibbonSkinManager);
    procedure SetStyle(AValue: TLazRibbonStyle);
    procedure SetTitle(const AValue: TCaption);
    procedure ToolbarMenuButtonClick(Sender: TObject);
    procedure ToolbarTabChanging(Sender: TObject; OldIndex, NewIndex: integer; var Allowed: boolean);
    procedure HookToolbarEvents;
    procedure UnhookToolbarEvents;
    procedure NormalizePageParents;
    function GetOverlayTop: Integer;
    function GetClientOverlayTopInset: Integer;
    procedure BringParentClientChromeToFront;
    procedure ApplyOverlayBounds;
    procedure RestoreOverlayBounds;
  protected
    function GetLinkedAppearance: TLazRibbonToolbarAppearance; virtual;
    procedure GetColors(out ABackColor, ANavColor, AActiveColor, AHotColor,
      AFrameColor, ATextColor, AMutedTextColor: TColor); virtual;
    function GetPage(AIndex: Integer): TLazRibbonBackstagePage;
    function GetPageCount: Integer;
    function GetPageIndex(APage: TLazRibbonBackstagePage): Integer;
    function GetContentRect: TRect; virtual;
    function GetCloseButtonRect: TRect; virtual;
    procedure DrawBackButton(ACanvas: TCanvas; const R: TRect; ABackColor, AFrameColor, ATextColor: TColor; AHot, APressed: Boolean); virtual;
    procedure DrawChevronLeft(ACanvas: TCanvas; const R: TRect; AColor: TColor; AThickness: Integer); virtual;
    function GetNavItemCount: Integer; virtual;
    function GetNavButton(AIndex: Integer): TLazRibbonBackstageButton; virtual;
    function GetEffectiveHeaderHeight: Integer; virtual;
    function GetNavItemHeight(AIndex: Integer): Integer; virtual;
    function GetNavItemRect(AIndex: Integer): TRect; virtual;
    function GetNavItemTop(AIndex: Integer): Integer; virtual;
    function HitTestPage(X, Y: Integer): Integer; virtual;
    function IsSelectableNavItem(AIndex: Integer): Boolean; virtual;
    function IsCommandNavItem(AIndex: Integer): Boolean; virtual;
    procedure ExecuteNavItem(AIndex: Integer); virtual;
    function IsSelectablePage(AIndex: Integer): Boolean; virtual;
    function FirstSelectablePageIndex: Integer; virtual;
    function IsCloseButtonAt(X, Y: Integer): Boolean; virtual;
    procedure AttachToRibbonComponent(AToolbar: TCustomControl; const AMenuCaption: String); override;
    procedure DetachFromRibbonComponent(AToolbar: TCustomControl); override;
    procedure SetRibbonSkinProvider(ASkinProvider: ILazRibbonSkinProvider); override;
    procedure SetRibbonSkinManagerObject(ASkinManager: TObject); override;
    function HandleRibbonTabClick(ATabIndex: Integer; const ATabCaption: String;
      AIsCurrentTab: Boolean): Boolean; override;
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure UpdatePages; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AttachToToolbar(AToolbar: TLazRibbon; const AMenuCaption: String = 'Arquivo');
    procedure HideBackstage;
    procedure ShowBackstage;
    function AddPage(const ACaption: String): TLazRibbonBackstagePage;
    function GetPageBackColor: TColor; virtual;
    property PageCount: Integer read GetPageCount;
    property Pages[AIndex: Integer]: TLazRibbonBackstagePage read GetPage;
  published
    property ActivePageIndex: Integer read FActivePageIndex write SetActivePageIndex default 0;
    property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asLinkedToolbar;
    property BackstageTabCaption: TCaption read FBackstageTabCaption write SetBackstageTabCaption;
    property BackButtonHint: String read FBackButtonHint write SetBackButtonHint;
    property BackButtonStyle: TLazRibbonBackstageBackButtonStyle read FBackButtonStyle write SetBackButtonStyle default bbsCircleChevron;
    property BackButtonVisible: Boolean read FBackButtonVisible write SetBackButtonVisible default True;
    property Buttons: TLazRibbonBackstageButtons read FButtons write SetButtons;
    property Align default alClient;
    property Anchors;
    property AutoHideAtRuntime: Boolean read FAutoHideAtRuntime write FAutoHideAtRuntime default True;
    property BorderSpacing;
    property Color default clWhite;
    property CloseOnEscape: Boolean read FCloseOnEscape write SetCloseOnEscape default True;
    property CloseOnRibbonTabClick: Boolean read FCloseOnRibbonTabClick write SetCloseOnRibbonTabClick default True;
    property Constraints;
    property Enabled;
    property Font;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default 0;
    property Images: TCustomImageList read FImages write SetImages;
    property LargeImages: TCustomImageList read FLargeImages write SetLargeImages;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 42;
    property LinkedToolbar: TLazRibbon read FLinkedToolbar write SetLinkedToolbar;
    property NavigationStyle: TLazRibbonBackstageNavigationStyle read FNavigationStyle write SetNavigationStyle default bnsOffice;
    property PageButtonVisualMode: TLazRibbonBackstagePageButtonVisualMode read FPageButtonVisualMode write SetPageButtonVisualMode default bpvmSelectable;
    property NavigationWidth: Integer read FNavigationWidth write SetNavigationWidth default 180;
    property OpenOnTabCaption: Boolean read FOpenOnTabCaption write SetOpenOnTabCaption default True;
    property OverlayMode: TLazRibbonBackstageOverlayMode read FOverlayMode write SetOverlayMode default bomCoverClientArea;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;
    property Style: TLazRibbonStyle read FStyle write SetStyle default lazOffice2007Blue;
    property Title: TCaption read FTitle write SetTitle;
    property Visible;
    property OnClick;
    property OnClose: TLazRibbonBackstageCloseEvent read FOnClose write FOnClose;
    property OnClosed: TNotifyEvent read FOnClosed write FOnClosed;
    property OnPageChanged: TLazRibbonBackstagePageChangedEvent read FOnPageChanged write FOnPageChanged;
    property OnResize;
  end;

implementation

function LazDarker(AColor: TColor; ADelta: Byte): TColor;
var
  C: LongInt;
  R, G, B: Byte;
begin
  C := ColorToRGB(AColor);
  R := C and $FF;
  G := (C shr 8) and $FF;
  B := (C shr 16) and $FF;
  if R > ADelta then Dec(R, ADelta) else R := 0;
  if G > ADelta then Dec(G, ADelta) else G := 0;
  if B > ADelta then Dec(B, ADelta) else B := 0;
  Result := RGBToColor(R, G, B);
end;

function LazLighter(AColor: TColor; ADelta: Byte): TColor;
var
  C: LongInt;
  R, G, B: Byte;
begin
  C := ColorToRGB(AColor);
  R := C and $FF;
  G := (C shr 8) and $FF;
  B := (C shr 16) and $FF;
  if R < 255 - ADelta then Inc(R, ADelta) else R := 255;
  if G < 255 - ADelta then Inc(G, ADelta) else G := 255;
  if B < 255 - ADelta then Inc(B, ADelta) else B := 255;
  Result := RGBToColor(R, G, B);
end;

function LazMixColor(AColor1, AColor2: TColor; APercentColor2: Integer): TColor;
var
  C1, C2: LongInt;
  R1, G1, B1, R2, G2, B2: Integer;
begin
  if APercentColor2 < 0 then APercentColor2 := 0;
  if APercentColor2 > 100 then APercentColor2 := 100;

  C1 := ColorToRGB(AColor1);
  C2 := ColorToRGB(AColor2);
  R1 := C1 and $FF;
  G1 := (C1 shr 8) and $FF;
  B1 := (C1 shr 16) and $FF;
  R2 := C2 and $FF;
  G2 := (C2 shr 8) and $FF;
  B2 := (C2 shr 16) and $FF;

  Result := RGBToColor(
    (R1 * (100 - APercentColor2) + R2 * APercentColor2) div 100,
    (G1 * (100 - APercentColor2) + G2 * APercentColor2) div 100,
    (B1 * (100 - APercentColor2) + B2 * APercentColor2) div 100
  );
end;

function LazColorBrightness(AColor: TColor): Integer;
var
  C: LongInt;
begin
  C := ColorToRGB(AColor);
  Result := ((C and $FF) * 299 + ((C shr 8) and $FF) * 587 +
    ((C shr 16) and $FF) * 114) div 1000;
end;

function LazIsDarkColor(AColor: TColor): Boolean;
begin
  Result := LazColorBrightness(AColor) < 128;
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

function LazTextColorWithMinContrast(ABackColor, APreferred: TColor;
  AMinRatio: Double = 4.5): TColor;
var
  PreferredRGB, BackRGB: TColor;
  BlackRatio, WhiteRatio: Double;
begin
  BackRGB := ColorToRGB(ABackColor);
  PreferredRGB := ColorToRGB(APreferred);

  { WCAG contrast guard.  Skins may suggest a text color, but the runtime must
    never allow normal captions to become illegible.  Use the skin text color
    only when the real painted background reaches the minimum 4.5:1 ratio.
    Otherwise choose the better of black/white against the actual surface. }
  if LazContrastRatio(PreferredRGB, BackRGB) >= AMinRatio then
    Exit(PreferredRGB);

  BlackRatio := LazContrastRatio(clBlack, BackRGB);
  WhiteRatio := LazContrastRatio(clWhite, BackRGB);
  if BlackRatio >= WhiteRatio then
    Result := clBlack
  else
    Result := clWhite;
end;

function LazReadableTextColor(ABackColor, APreferred: TColor): TColor;
begin
  Result := LazTextColorWithMinContrast(ABackColor, APreferred, 4.5);
end;

function LazReadableMutedTextColor(ABackColor, APreferred: TColor): TColor;
begin
  { Disabled BackStage captions must remain visibly disabled, but not disappear.
    Some linked Ribbon appearances expose a very light caption color even on a
    light navigation surface.  Derive the muted tone from the readable text color
    for the actual background, then verify the contrast direction. }
  if LazIsDarkColor(ABackColor) then
    Result := LazMixColor(LazReadableTextColor(ABackColor, APreferred), ABackColor, 38)
  else
    Result := LazMixColor(LazReadableTextColor(ABackColor, APreferred), ABackColor, 45);

  if LazIsDarkColor(Result) = LazIsDarkColor(ABackColor) then
  begin
    if LazIsDarkColor(ABackColor) then
      Result := LazLighter(ABackColor, 92)
    else
      Result := LazDarker(ABackColor, 92);
  end;

  { Even muted BackStage text should remain legible in runtime navigation. }
  Result := LazTextColorWithMinContrast(ABackColor, Result, 4.5);
end;

function LazBackstageSelectedBackColor(ANavColor, AActiveColor, AFrameColor: TColor): TColor;
var
  NB, AB: Integer;
begin
  { Resolve the real selected BackStage navigation surface.  A skin can choose
    a subtle selected surface, but it cannot be allowed to become visually
    indistinguishable from the navigation background.  When that happens, use
    the frame/accent color as a controlled source of separation. }
  Result := AActiveColor;

  NB := LazColorBrightness(ANavColor);
  AB := LazColorBrightness(Result);

  if Abs(NB - AB) < 34 then
  begin
    if LazIsDarkColor(ANavColor) then
      Result := LazMixColor(ANavColor, AFrameColor, 32)
    else
      Result := LazMixColor(ANavColor, AFrameColor, 24);
  end;

  { A very light selected surface with a light navigation area is the case that
    made the caption disappear in Office Blue/Light skins.  Darken it just
    enough to distinguish the item, while still allowing black text. }
  if (not LazIsDarkColor(ANavColor)) and (LazColorBrightness(Result) > 218) then
    Result := LazMixColor(Result, AFrameColor, 18);

  { Conversely, on dark skins keep the selected surface from collapsing into
    black. }
  if LazIsDarkColor(ANavColor) and (LazColorBrightness(Result) < 52) then
    Result := LazMixColor(Result, AFrameColor, 24);
end;

function LazBackstageCaptionColorFor(ABackColor, APreferredTextColor: TColor): TColor;
begin
  { Background-aware caption selection using the WCAG relative-luminance
    contrast formula.  The selected/backstage caption is computed against the
    actual surface that was painted, not against a nominal skin color. }
  Result := LazTextColorWithMinContrast(ABackColor, APreferredTextColor, 4.5);
end;

function LazBackstageAccentForStyle(AStyle: TLazRibbonStyle): TColor;
begin
  { Stable accent used by BackStage when the view is driven by the linked
    toolbar appearance instead of a SkinManager palette.  Linked toolbar colors
    are useful for the general surface, but their active tab colors can be too
    close to the BackStage navigation background.  The selected BackStage page
    must therefore use an explicit accent, otherwise it can oscillate between a
    white selection and a colored selection during mouse hover. }
  case AStyle of
    lazOffice2007Silver, lazOffice2007SilverTurquoise:
      Result := RGBToColor(120, 132, 148);
    lazMetroLight:
      Result := RGBToColor(0, 120, 215);
    lazMetroDark:
      Result := RGBToColor(0, 122, 204);
    lazOffice2007Rose:
      Result := RGBToColor(136, 72, 180);
    lazOffice2007Sage:
      Result := RGBToColor(116, 145, 62);
    lazOffice2007Bege:
      Result := RGBToColor(168, 125, 76);
  else
    Result := RGBToColor(49, 106, 197);
  end;
end;

function LazBackstageEnsureSelectedSurface(ANavColor, ASelectedColor,
  AFrameColor: TColor; AStyle: TLazRibbonStyle): TColor;
var
  R: Double;
begin
  { The selected navigation item needs visual separation from the navigation
    column before the text color is decided.  A WCAG text contrast check alone
    cannot fix a selected item whose surface is almost the same as the column. }
  Result := LazBackstageSelectedBackColor(ANavColor, ASelectedColor, AFrameColor);
  R := LazContrastRatio(Result, ANavColor);
  if R < 1.45 then
    Result := LazBackstageAccentForStyle(AStyle);

  { If the style accent is still too close to the navigation surface, push it
    away deterministically. }
  if LazContrastRatio(Result, ANavColor) < 1.45 then
  begin
    if LazIsDarkColor(ANavColor) then
      Result := LazLighter(ANavColor, 68)
    else
      Result := LazDarker(ANavColor, 74);
  end;
end;

function LazSubtleFrameColor(ABaseColor: TColor): TColor;
begin
  if LazIsDarkColor(ABaseColor) then
    Result := LazLighter(ABaseColor, 58)
  else
    Result := LazDarker(ABaseColor, 42);
end;

procedure LazFillRectByKind(ACanvas: TCanvas; const ARect: TRect;
  AColorFrom, AColorTo: TColor; AKind: TBackgroundKind);
var
  I, Count, Pos, Mid: Integer;
  R: TRect;
  C: TColor;
begin
  if (ARect.Right <= ARect.Left) or (ARect.Bottom <= ARect.Top) then Exit;

  case AKind of
    bkSolid:
      begin
        ACanvas.Brush.Color := AColorFrom;
        ACanvas.FillRect(ARect);
      end;
    bkHorizontalGradient:
      begin
        Count := ARect.Right - ARect.Left;
        if Count <= 1 then
        begin
          ACanvas.Brush.Color := AColorFrom;
          ACanvas.FillRect(ARect);
        end
        else
          for I := 0 to Count - 1 do
          begin
            C := LazMixColor(AColorFrom, AColorTo, (I * 100) div (Count - 1));
            ACanvas.Pen.Color := C;
            ACanvas.Line(ARect.Left + I, ARect.Top, ARect.Left + I, ARect.Bottom);
          end;
      end;
    bkConcave:
      begin
        Mid := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
        R := Rect(ARect.Left, ARect.Top, ARect.Right, Mid);
        LazFillRectByKind(ACanvas, R, LazLighter(AColorFrom, 18), AColorFrom, bkVerticalGradient);
        R := Rect(ARect.Left, Mid, ARect.Right, ARect.Bottom);
        LazFillRectByKind(ACanvas, R, AColorTo, LazDarker(AColorTo, 8), bkVerticalGradient);
      end;
  else
    begin
      Count := ARect.Bottom - ARect.Top;
      if Count <= 1 then
      begin
        ACanvas.Brush.Color := AColorFrom;
        ACanvas.FillRect(ARect);
      end
      else
        for I := 0 to Count - 1 do
        begin
          Pos := (I * 100) div (Count - 1);
          C := LazMixColor(AColorFrom, AColorTo, Pos);
          ACanvas.Pen.Color := C;
          ACanvas.Line(ARect.Left, ARect.Top + I, ARect.Right, ARect.Top + I);
        end;
    end;
  end;
end;

{ TLazRibbonBackstageButton }

function LazRibbonActionCaption(AAction: TBasicAction): String;
begin
  Result := '';
  if AAction is TAction then
    Result := TAction(AAction).Caption;
end;

function LazRibbonActionHint(AAction: TBasicAction): String;
begin
  Result := '';
  if AAction is TAction then
    Result := TAction(AAction).Hint;
end;

function LazRibbonActionImageIndex(AAction: TBasicAction): Integer;
begin
  Result := -1;
  if AAction is TAction then
    Result := TAction(AAction).ImageIndex;
end;

function LazRibbonActionVisible(AAction: TBasicAction): Boolean;
begin
  Result := True;
  if AAction is TAction then
    Result := TAction(AAction).Visible;
end;

function LazRibbonActionEnabled(AAction: TBasicAction): Boolean;
begin
  Result := True;
  if AAction is TAction then
    Result := TAction(AAction).Enabled;
end;

function LazRibbonLinkedCaption(AItem: TLazRibbonBaseItem): String;
begin
  Result := '';
  if AItem is TLazRibbonBaseButton then
    Result := TLazRibbonBaseButton(AItem).Caption;
end;

function LazRibbonLinkedAction(AItem: TLazRibbonBaseItem): TBasicAction;
begin
  Result := nil;
  if AItem is TLazRibbonBaseButton then
    Result := TLazRibbonBaseButton(AItem).Action;
end;

function LazRibbonLinkedHint(AItem: TLazRibbonBaseItem): String;
var
  A: TBasicAction;
begin
  Result := '';
  if AItem = nil then Exit;
  A := LazRibbonLinkedAction(AItem);
  if A <> nil then
    Result := LazRibbonActionHint(A);
  if Result = '' then
    Result := AItem.Hint;
end;

function LazRibbonLinkedImageIndex(AItem: TLazRibbonBaseItem): Integer;
var
  A: TBasicAction;
begin
  Result := -1;
  if AItem = nil then Exit;

  A := LazRibbonLinkedAction(AItem);
  if A <> nil then
    Result := LazRibbonActionImageIndex(A);

  if Result >= 0 then Exit;

  if AItem is TLazRibbonSmallButton then
    Result := TLazRibbonSmallButton(AItem).ImageIndex
  else if AItem is TLazRibbonLargeButton then
    Result := TLazRibbonLargeButton(AItem).LargeImageIndex;
end;

function LazRibbonLinkedLargeImageIndex(AItem: TLazRibbonBaseItem): Integer;
var
  A: TBasicAction;
begin
  Result := -1;
  if AItem = nil then Exit;

  A := LazRibbonLinkedAction(AItem);
  if A <> nil then
    Result := LazRibbonActionImageIndex(A);

  if Result >= 0 then Exit;

  if AItem is TLazRibbonLargeButton then
    Result := TLazRibbonLargeButton(AItem).LargeImageIndex
  else if AItem is TLazRibbonSmallButton then
    Result := TLazRibbonSmallButton(AItem).ImageIndex;
end;

function LazRibbonLinkedEnabled(AItem: TLazRibbonBaseItem): Boolean;
var
  A: TBasicAction;
begin
  Result := True;
  if AItem = nil then Exit;
  Result := AItem.Enabled;
  A := LazRibbonLinkedAction(AItem);
  if A <> nil then
    Result := Result and LazRibbonActionEnabled(A);
end;

function LazRibbonLinkedVisible(AItem: TLazRibbonBaseItem): Boolean;
var
  A: TBasicAction;
begin
  Result := True;
  if AItem = nil then Exit;
  Result := AItem.Visible;
  A := LazRibbonLinkedAction(AItem);
  if A <> nil then
    Result := Result and LazRibbonActionVisible(A);
end;

procedure LazRibbonExecuteLinkedItem(AItem: TLazRibbonBaseItem);
var
  B: TLazRibbonBaseButton;
  A: TBasicAction;
begin
  if AItem = nil then Exit;
  A := LazRibbonLinkedAction(AItem);
  if A <> nil then
  begin
    A.Execute;
    Exit;
  end;

  if AItem is TLazRibbonBaseButton then
  begin
    B := TLazRibbonBaseButton(AItem);
    if Assigned(B.OnClick) then
      B.OnClick(B);
  end;
end;

constructor TLazRibbonBackstageButton.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBeginGroup := False;
  FCloseBackstageOnClick := True;
  FEnabled := True;
  FImageIndex := -1;
  FLargeImageIndex := -1;
  FKind := bbkPage;
  FSection := bbsTop;
  FVisible := True;
end;

procedure TLazRibbonBackstageButton.Changed;
begin
  inherited Changed(False);
end;

function TLazRibbonBackstageButton.EffectiveCaption: TCaption;
begin
  Result := FCaption;
  if (FAction <> nil) and (LazRibbonActionCaption(FAction) <> '') then
    Result := LazRibbonActionCaption(FAction)
  else if (FLinkedItem <> nil) and (LazRibbonLinkedCaption(FLinkedItem) <> '') then
    Result := LazRibbonLinkedCaption(FLinkedItem)
  else if (Result = '') and (FPage <> nil) then
    Result := FPage.EffectiveCaption;
end;

function TLazRibbonBackstageButton.EffectiveEnabled: Boolean;
begin
  Result := FEnabled;
  if FAction <> nil then
    Result := Result and LazRibbonActionEnabled(FAction);
  if FLinkedItem <> nil then
    Result := Result and LazRibbonLinkedEnabled(FLinkedItem);
  if FPage <> nil then
    Result := Result and FPage.EffectiveEnabled;
end;

function TLazRibbonBackstageButton.EffectiveHint: String;
begin
  Result := FHint;
  if (FAction <> nil) and (LazRibbonActionHint(FAction) <> '') then
    Result := LazRibbonActionHint(FAction)
  else if (FLinkedItem <> nil) and (LazRibbonLinkedHint(FLinkedItem) <> '') then
    Result := LazRibbonLinkedHint(FLinkedItem)
  else if (Result = '') and (FPage <> nil) then
    Result := FPage.EffectiveHint;
end;

function TLazRibbonBackstageButton.EffectiveImageIndex: Integer;
begin
  Result := FImageIndex;
  if (Result < 0) and (FAction <> nil) then
    Result := LazRibbonActionImageIndex(FAction);
  if (Result < 0) and (FLinkedItem <> nil) then
    Result := LazRibbonLinkedImageIndex(FLinkedItem);
end;

function TLazRibbonBackstageButton.EffectiveLargeImageIndex: Integer;
begin
  Result := FLargeImageIndex;
  if (Result < 0) and (FLinkedItem <> nil) then
    Result := LazRibbonLinkedLargeImageIndex(FLinkedItem);
  if Result < 0 then
    Result := EffectiveImageIndex;
end;

function TLazRibbonBackstageButton.EffectiveVisible: Boolean;
begin
  Result := FVisible;
  if FAction <> nil then
    Result := Result and LazRibbonActionVisible(FAction);
  if FLinkedItem <> nil then
    Result := Result and LazRibbonLinkedVisible(FLinkedItem);
  if FPage <> nil then
    Result := Result and FPage.EffectiveVisible;
end;

procedure TLazRibbonBackstageButton.Execute;
begin
  if not EffectiveEnabled then Exit;
  if not EffectiveVisible then Exit;

  if FAction <> nil then
    FAction.Execute
  else if FLinkedItem <> nil then
    LazRibbonExecuteLinkedItem(FLinkedItem)
  else if FPage <> nil then
    FPage.Execute
  else if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

function TLazRibbonBackstageButton.GetDisplayName: string;
begin
  if FKind = bbkSeparator then
    Result := '--- separador ---'
  else
    Result := EffectiveCaption;

  if Result = '' then
  begin
    case FKind of
      bbkPage: Result := 'Página';
      bbkCommand: Result := 'Comando';
    else
      Result := inherited GetDisplayName;
    end;
  end;
end;

procedure TLazRibbonBackstageButton.SetAction(AValue: TBasicAction);
var
  V: TLazRibbonBackstageView;
begin
  if FAction = AValue then Exit;
  V := nil;
  if Collection is TLazRibbonBackstageButtons then
    V := TLazRibbonBackstageButtons(Collection).OwnerView;
  if (FAction <> nil) and (V <> nil) then
    FAction.RemoveFreeNotification(V);
  FAction := AValue;
  if (FAction <> nil) and (V <> nil) then
    FAction.FreeNotification(V);
  Changed;
end;

procedure TLazRibbonBackstageButton.SetBeginGroup(AValue: Boolean);
begin
  if FBeginGroup = AValue then Exit;
  FBeginGroup := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetCloseBackstageOnClick(AValue: Boolean);
begin
  if FCloseBackstageOnClick = AValue then Exit;
  FCloseBackstageOnClick := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetEnabled(AValue: Boolean);
begin
  if FEnabled = AValue then Exit;
  FEnabled := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetHint(const AValue: String);
begin
  if FHint = AValue then Exit;
  FHint := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetImageIndex(AValue: Integer);
begin
  if FImageIndex = AValue then Exit;
  FImageIndex := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetLargeImageIndex(AValue: Integer);
begin
  if FLargeImageIndex = AValue then Exit;
  FLargeImageIndex := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetKind(AValue: TLazRibbonBackstageButtonKind);
begin
  if FKind = AValue then Exit;
  FKind := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetLinkedItem(AValue: TLazRibbonBaseItem);
var
  V: TLazRibbonBackstageView;
begin
  if FLinkedItem = AValue then Exit;
  V := nil;
  if Collection is TLazRibbonBackstageButtons then
    V := TLazRibbonBackstageButtons(Collection).OwnerView;
  if (FLinkedItem <> nil) and (V <> nil) then
    FLinkedItem.RemoveFreeNotification(V);
  FLinkedItem := AValue;
  if (FLinkedItem <> nil) and (V <> nil) then
    FLinkedItem.FreeNotification(V);
  Changed;
end;

procedure TLazRibbonBackstageButton.SetSection(AValue: TLazRibbonBackstageButtonSection);
begin
  if FSection = AValue then Exit;
  FSection := AValue;
  Changed;
end;

procedure TLazRibbonBackstageButton.SetPage(AValue: TLazRibbonBackstagePage);
var
  V: TLazRibbonBackstageView;
begin
  if FPage = AValue then Exit;
  V := nil;
  if Collection is TLazRibbonBackstageButtons then
    V := TLazRibbonBackstageButtons(Collection).OwnerView;
  if (FPage <> nil) and (V <> nil) then
    FPage.RemoveFreeNotification(V);
  FPage := AValue;
  if (FPage <> nil) and (V <> nil) then
    FPage.FreeNotification(V);
  Changed;
end;

procedure TLazRibbonBackstageButton.SetVisible(AValue: Boolean);
begin
  if FVisible = AValue then Exit;
  FVisible := AValue;
  Changed;
end;

{ TLazRibbonBackstageButtons }

constructor TLazRibbonBackstageButtons.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TLazRibbonBackstageButton);
end;

function TLazRibbonBackstageButtons.Add: TLazRibbonBackstageButton;
begin
  Result := TLazRibbonBackstageButton(inherited Add);
end;

function TLazRibbonBackstageButtons.AddCommand(AAction: TBasicAction; const ACaption: TCaption): TLazRibbonBackstageButton;
begin
  Result := Add;
  Result.Kind := bbkCommand;
  Result.Action := AAction;
  if ACaption <> '' then
    Result.Caption := ACaption;
end;

function TLazRibbonBackstageButtons.AddPage(APage: TLazRibbonBackstagePage; const ACaption: TCaption): TLazRibbonBackstageButton;
begin
  Result := Add;
  Result.Kind := bbkPage;
  Result.Page := APage;
  if ACaption <> '' then
    Result.Caption := ACaption
  else if APage <> nil then
    Result.Caption := APage.Caption;
end;

function TLazRibbonBackstageButtons.AddSeparator: TLazRibbonBackstageButton;
begin
  Result := Add;
  Result.Kind := bbkSeparator;
  Result.Enabled := False;
end;

function TLazRibbonBackstageButtons.GetItem(Index: Integer): TLazRibbonBackstageButton;
begin
  Result := TLazRibbonBackstageButton(inherited GetItem(Index));
end;

function TLazRibbonBackstageButtons.OwnerView: TLazRibbonBackstageView;
begin
  if GetOwner is TLazRibbonBackstageView then
    Result := TLazRibbonBackstageView(GetOwner)
  else
    Result := nil;
end;

procedure TLazRibbonBackstageButtons.SetItem(Index: Integer; AValue: TLazRibbonBackstageButton);
begin
  inherited SetItem(Index, AValue);
end;

procedure TLazRibbonBackstageButtons.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if OwnerView <> nil then
  begin
    OwnerView.UpdatePages;
    OwnerView.Invalidate;
  end;
end;

{ TLazRibbonBackstagePage }

constructor TLazRibbonBackstagePage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csNoFocus];
  Width := 360;
  Height := 240;
  Color := clWhite;
  ParentColor := False;
  FCaption := Name;
  FCloseBackstageOnClick := True;
  FCommand := nil;
  FItemKind := bpkPage;
end;

function TLazRibbonBackstagePage.EffectiveCaption: TCaption;
begin
  Result := FCaption;

  { Prefer the native Lazarus TAction/TActionList mechanism. }
  if (Action is TAction) and (TAction(Action).Caption <> '') then
    Result := TAction(Action).Caption
  else if (FCommand <> nil) and (FCommand.Caption <> '') then
    Result := FCommand.Caption;
end;

function TLazRibbonBackstagePage.EffectiveEnabled: Boolean;
begin
  Result := Enabled;

  if Action is TAction then
    Result := Result and TAction(Action).Enabled
  else if FCommand <> nil then
    Result := Result and FCommand.Enabled;
end;

function TLazRibbonBackstagePage.EffectiveHint: String;
begin
  Result := Hint;

  if (Action is TAction) and (TAction(Action).Hint <> '') then
    Result := TAction(Action).Hint
  else if (FCommand <> nil) and (FCommand.Hint <> '') then
    Result := FCommand.Hint;
end;

function TLazRibbonBackstagePage.EffectiveImageIndex: Integer;
begin
  Result := -1;

  if Action is TAction then
    Result := TAction(Action).ImageIndex
  else if FCommand <> nil then
    Result := FCommand.ImageIndex;
end;

function TLazRibbonBackstagePage.EffectiveVisible: Boolean;
begin
  { Do not use the control Visible property here. UpdatePages uses Visible
    internally to show only the active content page; using it for the
    navigation entry would hide inactive pages from the left menu. }
  Result := True;

  if Action is TAction then
    Result := TAction(Action).Visible
  else if FCommand <> nil then
    Result := FCommand.Visible;
end;

procedure TLazRibbonBackstagePage.Execute;
begin
  if not EffectiveEnabled then Exit;
  if not EffectiveVisible then Exit;

  if Action <> nil then
    Action.Execute
  else if FCommand <> nil then
    FCommand.Execute
  else if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

procedure TLazRibbonBackstagePage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FCommand) then
  begin
    FCommand := nil;
    if Parent is TLazRibbonBackstageView then
      TLazRibbonBackstageView(Parent).Invalidate;
    Invalidate;
  end;
end;

procedure TLazRibbonBackstagePage.SetParent(NewParent: TWinControl);
var
  W: TWinControl;
begin
  if NewParent is TLazRibbonBackstagePage then
  begin
    W := NewParent;
    while (W <> nil) and not (W is TLazRibbonBackstageView) do
      W := W.Parent;
    if W is TLazRibbonBackstageView then
      NewParent := W;
  end;

  inherited SetParent(NewParent);

  if Parent is TLazRibbonBackstageView then
  begin
    if FItemKind = bpkPage then
      TLazRibbonBackstageView(Parent).ActivePageIndex :=
        TLazRibbonBackstageView(Parent).GetPageIndex(Self);
    TLazRibbonBackstageView(Parent).UpdatePages;
    TLazRibbonBackstageView(Parent).Invalidate;
  end;
end;

procedure TLazRibbonBackstagePage.Paint;
var
  R: TRect;
  View: TLazRibbonBackstageView;
  BackColor, NavColor, ActiveColor, HotColor, FrameColor, TextColor, MutedTextColor: TColor;
  S: String;
begin
  inherited Paint;
  View := nil;
  if Parent is TLazRibbonBackstageView then
  begin
    View := TLazRibbonBackstageView(Parent);
    Canvas.Brush.Color := View.GetPageBackColor;
  end
  else
    Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);

  if ControlCount = 0 then
  begin
    BackColor := Canvas.Brush.Color;
    FrameColor := clSilver;
    TextColor := LazReadableTextColor(BackColor, Font.Color);
    MutedTextColor := LazReadableMutedTextColor(BackColor, TextColor);
    if View <> nil then
    begin
      View.GetColors(BackColor, NavColor, ActiveColor, HotColor, FrameColor, TextColor, MutedTextColor);
      TextColor := LazReadableTextColor(Canvas.Brush.Color, TextColor);
      MutedTextColor := LazReadableMutedTextColor(Canvas.Brush.Color, TextColor);
    end;

    R := ClientRect;
    InflateRect(R, -28, -24);
    if (R.Right <= R.Left) or (R.Bottom <= R.Top) then Exit;

    Canvas.Brush.Style := bsClear;
    Canvas.Font.Assign(Font);
    if Canvas.Font.Size = 0 then
      Canvas.Font.Size := 9;
    Canvas.Font.Size := Canvas.Font.Size + 9;
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    Canvas.Font.Color := TextColor;
    Canvas.TextOut(R.Left, R.Top, EffectiveCaption);

    Canvas.Pen.Color := LazMixColor(FrameColor, Canvas.Brush.Color, 35);
    Canvas.Line(R.Left, R.Top + Canvas.TextHeight(EffectiveCaption) + 16,
      R.Right, R.Top + Canvas.TextHeight(EffectiveCaption) + 16);

    Canvas.Font.Assign(Font);
    if Canvas.Font.Size = 0 then
      Canvas.Font.Size := 9;
    Canvas.Font.Size := Canvas.Font.Size + 1;
    Canvas.Font.Style := Canvas.Font.Style - [fsBold];
    Canvas.Font.Color := MutedTextColor;
    if csDesigning in ComponentState then
      S := 'Adicione controles nesta página do BackStage.'
    else
      S := 'Nenhum conteúdo configurado para esta página.';
    Canvas.TextRect(R, R.Left, R.Top + 54, S);
    Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TLazRibbonBackstagePage.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  if Parent is TLazRibbonBackstageView then
    TLazRibbonBackstageView(Parent).Invalidate;
  Invalidate;
end;

procedure TLazRibbonBackstagePage.SetCommand(AValue: TLazRibbonCommand);
begin
  if FCommand = AValue then Exit;
  if FCommand <> nil then
    FCommand.RemoveFreeNotification(Self);
  FCommand := AValue;
  if FCommand <> nil then
    FCommand.FreeNotification(Self);
  if Parent is TLazRibbonBackstageView then
  begin
    TLazRibbonBackstageView(Parent).UpdatePages;
    TLazRibbonBackstageView(Parent).Invalidate;
  end;
  Invalidate;
end;

procedure TLazRibbonBackstagePage.SetItemKind(AValue: TLazRibbonBackstagePageKind);
begin
  if FItemKind = AValue then Exit;
  FItemKind := AValue;
  if Parent is TLazRibbonBackstageView then
  begin
    if (FItemKind <> bpkPage) and
      (TLazRibbonBackstageView(Parent).ActivePageIndex = TLazRibbonBackstageView(Parent).GetPageIndex(Self)) then
      TLazRibbonBackstageView(Parent).ActivePageIndex := TLazRibbonBackstageView(Parent).FirstSelectablePageIndex;
    TLazRibbonBackstageView(Parent).UpdatePages;
    TLazRibbonBackstageView(Parent).Invalidate;
  end;
  Invalidate;
end;

{ TLazRibbonBackstageRecentList }

constructor TLazRibbonBackstageRecentList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csAcceptsControls];
  FAppearanceSource := asInternalStyle;
  Color := clWhite;
  ParentFont := False;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FHoverIndex := -1;
  FImageIndex := -1;
  FImages := nil;
  FItemHeight := 58;
  FMaxRecentItems := 20;
  FSkinManager := nil;
  FScrollBarMode := rsmAuto;
  FScrollBarWidth := 12;
  FScrollOffset := 0;
  FSelectedIndex := -1;
  FSelectionStyle := brsSkin;
  FStorageSection := 'RecentFiles';
  FItems := TStringList.Create;
  FItems.OnChange := ItemsChanged;

  FScrollBar := TScrollBar.Create(Self);
  FScrollBar.Parent := Self;
  FScrollBar.Kind := sbVertical;
  FScrollBar.Visible := False;
  FScrollBar.Width := FScrollBarWidth;
  FScrollBar.OnChange := ScrollBarChange;

  Width := 420;
  Height := 260;
end;

destructor TLazRibbonBackstageRecentList.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TLazRibbonBackstageRecentList.ItemsChanged(Sender: TObject);
begin
  if FSelectedIndex >= FItems.Count then
    FSelectedIndex := -1;
  if FHoverIndex >= FItems.Count then
    FHoverIndex := -1;
  ClampScrollOffset;
  UpdateScrollBar;
  Invalidate;
end;

function TLazRibbonBackstageRecentList.GetItems: TStrings;
begin
  Result := FItems;
end;

function TLazRibbonBackstageRecentList.GetMaxScrollOffset: Integer;
var
  TotalHeight: Integer;
begin
  TotalHeight := 16 + (FItems.Count * FItemHeight);
  Result := TotalHeight - ClientHeight;
  if Result < 0 then
    Result := 0;
end;

function TLazRibbonBackstageRecentList.GetVisibleRight: Integer;
begin
  Result := ClientWidth - 8;
  if (FScrollBar <> nil) and FScrollBar.Visible then
    Dec(Result, FScrollBar.Width + 2);
  if Result < 8 then
    Result := 8;
end;

procedure TLazRibbonBackstageRecentList.ClampScrollOffset;
var
  MaxScroll: Integer;
begin
  MaxScroll := GetMaxScrollOffset;
  if FScrollOffset < 0 then
    FScrollOffset := 0;
  if FScrollOffset > MaxScroll then
    FScrollOffset := MaxScroll;
end;

procedure TLazRibbonBackstageRecentList.EnsureItemVisible(AIndex: Integer);
var
  ItemTop, ItemBottom: Integer;
begin
  if (AIndex < 0) or (AIndex >= FItems.Count) then
    Exit;

  ItemTop := 8 + (AIndex * FItemHeight);
  ItemBottom := ItemTop + FItemHeight;

  if ItemTop < FScrollOffset then
    FScrollOffset := ItemTop
  else if ItemBottom > FScrollOffset + ClientHeight then
    FScrollOffset := ItemBottom - ClientHeight + 8;

  ClampScrollOffset;
  UpdateScrollBar;
end;

procedure TLazRibbonBackstageRecentList.ParseItem(AIndex: Integer; out ATitle, ADetail: String);
var
  S: String;
  P: Integer;
begin
  ATitle := '';
  ADetail := '';
  if (AIndex < 0) or (AIndex >= FItems.Count) then
    Exit;

  S := FItems[AIndex];
  P := Pos('=', S);
  if P > 0 then
  begin
    ATitle := Copy(S, 1, P - 1);
    ADetail := Copy(S, P + 1, Length(S));
  end
  else
    ATitle := S;
end;

function TLazRibbonBackstageRecentList.GetItemRect(AIndex: Integer): TRect;
var
  Y: Integer;
begin
  if (AIndex < 0) or (AIndex >= FItems.Count) then
    Result := Rect(0, 0, 0, 0)
  else
  begin
    Y := 8 + (AIndex * FItemHeight) - FScrollOffset;
    Result := Rect(8, Y, GetVisibleRight, Y + FItemHeight);
  end;
end;

function TLazRibbonBackstageRecentList.ItemAtPos(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if PtInRect(GetItemRect(I), Point(X, Y)) then
    begin
      Result := I;
      Exit;
    end;
end;

function TLazRibbonBackstageRecentList.ItemTitle(AIndex: Integer): String;
var
  Detail: String;
begin
  ParseItem(AIndex, Result, Detail);
end;

function TLazRibbonBackstageRecentList.ItemDetail(AIndex: Integer): String;
var
  Title: String;
begin
  ParseItem(AIndex, Title, Result);
end;

procedure TLazRibbonBackstageRecentList.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
  TitleText, DetailText: String;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button <> mbLeft then
    Exit;

  Index := ItemAtPos(X, Y);
  if Index < 0 then
    Exit;

  SelectedIndex := Index;
  ParseItem(Index, TitleText, DetailText);
  if Assigned(FOnItemClick) then
    FOnItemClick(Self, Index, TitleText, DetailText);
end;

procedure TLazRibbonBackstageRecentList.MouseLeave;
begin
  inherited MouseLeave;
  if FHoverIndex <> -1 then
  begin
    FHoverIndex := -1;
    Invalidate;
  end;
end;

procedure TLazRibbonBackstageRecentList.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  Index := ItemAtPos(X, Y);
  if FHoverIndex <> Index then
  begin
    FHoverIndex := Index;
    Invalidate;
  end;
end;

procedure TLazRibbonBackstageRecentList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
  if (Operation = opRemove) and (AComponent = FSkinManager) then
    FSkinManager := nil;
end;

procedure TLazRibbonBackstageRecentList.Paint;
var
  I, IconX, IconY, TextX: Integer;
  R, IconR, DocR, DbR: TRect;
  TitleText, DetailText: String;
  P: TLazRibbonSkinPalette;
  BackColor, OddColor, HoverColor, SelectedColor, SelectedFrameColor: TColor;
  TitleColor, DetailColor, RowFromColor, RowToColor, IconFrameColor, IconFillColor: TColor;
begin
  inherited Paint;

  if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
  begin
    P := FSkinManager.Palette;
    BackColor := P.BackColor;
    OddColor := P.RecentOddColor;
    HoverColor := P.RecentHoverColor;
    SelectedColor := P.RecentSelectedColor;
    SelectedFrameColor := P.RecentSelectedFrameColor;
    TitleColor := P.RecentTitleColor;
    DetailColor := P.MutedTextColor;
  end
  else
  begin
    BackColor := Color;
    OddColor := RGBToColor(248, 250, 253);
    HoverColor := RGBToColor(236, 244, 253);
    SelectedColor := RGBToColor(219, 235, 252);
    SelectedFrameColor := RGBToColor(126, 169, 219);
    TitleColor := RGBToColor(0, 60, 130);
    DetailColor := RGBToColor(90, 90, 90);
  end;

  if FSelectionStyle = brsOfficeGold then
  begin
    if LazIsDarkColor(BackColor) then
    begin
      HoverColor := RGBToColor(96, 78, 38);
      SelectedColor := RGBToColor(215, 154, 34);
      SelectedFrameColor := RGBToColor(247, 202, 82);
    end
    else
    begin
      HoverColor := RGBToColor(255, 241, 190);
      SelectedColor := RGBToColor(255, 220, 93);
      SelectedFrameColor := RGBToColor(229, 159, 35);
    end;
  end;

  Canvas.Brush.Color := BackColor;
  Canvas.FillRect(ClientRect);

  { Make the native scrollbar less visually intrusive by reserving a narrower
    strip and drawing a subtle skin-derived separator beside it. }
  if (FScrollBar <> nil) and FScrollBar.Visible then
  begin
    Canvas.Pen.Color := LazMixColor(DetailColor, BackColor, 78);
    Canvas.Line(FScrollBar.Left - 2, 0, FScrollBar.Left - 2, ClientHeight);
  end;

  for I := 0 to FItems.Count - 1 do
  begin
    R := GetItemRect(I);
    if R.Bottom < 0 then
      Continue;
    if R.Top >= ClientHeight then
      Break;

    ParseItem(I, TitleText, DetailText);

    if I = FSelectedIndex then
    begin
      if LazIsDarkColor(SelectedColor) then
      begin
        RowFromColor := LazLighter(SelectedColor, 18);
        RowToColor := SelectedColor;
      end
      else
      begin
        RowFromColor := LazMixColor(SelectedColor, clWhite, 38);
        RowToColor := SelectedColor;
      end;
      LazFillRectByKind(Canvas, R, RowFromColor, RowToColor, bkVerticalGradient);
      Canvas.Pen.Color := SelectedFrameColor;
      Canvas.Rectangle(R);
      Canvas.Pen.Color := LazMixColor(RowFromColor, clWhite, 35);
      Canvas.Line(R.Left + 1, R.Top + 1, R.Right - 2, R.Top + 1);
    end
    else if I = FHoverIndex then
    begin
      if LazIsDarkColor(HoverColor) then
      begin
        RowFromColor := LazLighter(HoverColor, 10);
        RowToColor := HoverColor;
      end
      else
      begin
        RowFromColor := LazMixColor(HoverColor, clWhite, 30);
        RowToColor := HoverColor;
      end;
      LazFillRectByKind(Canvas, R, RowFromColor, RowToColor, bkVerticalGradient);
      Canvas.Pen.Color := LazMixColor(SelectedFrameColor, BackColor, 25);
      Canvas.Rectangle(R);
    end
    else if I mod 2 = 1 then
    begin
      Canvas.Brush.Color := OddColor;
      Canvas.FillRect(R);
    end;

    IconX := R.Left + 8;
    if (FImages <> nil) and (FImageIndex >= 0) and (FImageIndex < FImages.Count) then
    begin
      IconY := R.Top + (FItemHeight - FImages.Height) div 2;
      FImages.Draw(Canvas, IconX, IconY, FImageIndex);
      TextX := IconX + FImages.Width + 12;
    end
    else
    begin
      IconR := Rect(IconX + 3, R.Top + 10, IconX + 31, R.Top + 44);
      DocR := IconR;
      IconFrameColor := LazMixColor(DetailColor, BackColor, 22);
      IconFillColor := LazMixColor(BackColor, clWhite, 70);
      Canvas.Brush.Color := IconFillColor;
      Canvas.Pen.Color := IconFrameColor;
      Canvas.Rectangle(DocR);
      { Folded file corner. }
      Canvas.Brush.Color := LazMixColor(IconFillColor, IconFrameColor, 14);
      Canvas.Polygon([Point(DocR.Right - 8, DocR.Top + 1),
        Point(DocR.Right - 1, DocR.Top + 8), Point(DocR.Right - 8, DocR.Top + 8)]);
      Canvas.Pen.Color := IconFrameColor;
      Canvas.Line(DocR.Right - 8, DocR.Top + 1, DocR.Right - 1, DocR.Top + 8);
      { Small database cylinder inside the file, closer to database examples. }
      DbR := Rect(DocR.Left + 5, DocR.Top + 12, DocR.Right - 5, DocR.Bottom - 5);
      Canvas.Brush.Color := LazMixColor(SelectedFrameColor, BackColor, 48);
      Canvas.Pen.Color := IconFrameColor;
      Canvas.Ellipse(DbR.Left, DbR.Top, DbR.Right, DbR.Top + 8);
      Canvas.MoveTo(DbR.Left, DbR.Top + 4);
      Canvas.LineTo(DbR.Left, DbR.Bottom - 4);
      Canvas.MoveTo(DbR.Right - 1, DbR.Top + 4);
      Canvas.LineTo(DbR.Right - 1, DbR.Bottom - 4);
      Canvas.Arc(DbR.Left, DbR.Bottom - 9, DbR.Right, DbR.Bottom - 1,
        DbR.Right, DbR.Bottom - 5, DbR.Left, DbR.Bottom - 5);
      TextX := IconX + 44;
    end;

    Canvas.Brush.Style := bsClear;
    Canvas.Font.Assign(Font);
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    Canvas.Font.Color := TitleColor;
    Canvas.TextOut(TextX, R.Top + 9, TitleText);

    Canvas.Font.Assign(Font);
    Canvas.Font.Color := DetailColor;
    if DetailText <> '' then
      Canvas.TextOut(TextX, R.Top + 29, DetailText);
    Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TLazRibbonBackstageRecentList.ScrollBarChange(Sender: TObject);
begin
  if FScrollBar = nil then
    Exit;
  if FScrollOffset = FScrollBar.Position then
    Exit;
  FScrollOffset := FScrollBar.Position;
  ClampScrollOffset;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetAppearanceSource(AValue: TLazRibbonAppearanceSource);
begin
  if FAppearanceSource = AValue then Exit;
  FAppearanceSource := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetImageIndex(AValue: Integer);
begin
  if FImageIndex = AValue then Exit;
  FImageIndex := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetImages(AValue: TCustomImageList);
begin
  if FImages = AValue then Exit;
  if FImages <> nil then
    FImages.RemoveFreeNotification(Self);
  FImages := AValue;
  if FImages <> nil then
    FImages.FreeNotification(Self);
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetItemHeight(AValue: Integer);
begin
  if AValue < 34 then AValue := 34;
  if FItemHeight = AValue then Exit;
  FItemHeight := AValue;
  ClampScrollOffset;
  UpdateScrollBar;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetMaxRecentItems(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  if FMaxRecentItems = AValue then Exit;
  FMaxRecentItems := AValue;
  if FMaxRecentItems > 0 then
    while FItems.Count > FMaxRecentItems do
      FItems.Delete(FItems.Count - 1);
  UpdateScrollBar;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetScrollBarMode(AValue: TLazRibbonBackstageRecentScrollBarMode);
begin
  if FScrollBarMode = AValue then Exit;
  FScrollBarMode := AValue;
  UpdateScrollBar;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetStorageSection(const AValue: String);
begin
  if FStorageSection = AValue then Exit;
  FStorageSection := AValue;
end;

procedure TLazRibbonBackstageRecentList.UpdateScrollBar;
var
  MaxScroll: Integer;
  NeedVisible: Boolean;
begin
  if FScrollBar = nil then
    Exit;

  MaxScroll := GetMaxScrollOffset;
  NeedVisible := False;
  case FScrollBarMode of
    rsmAuto: NeedVisible := MaxScroll > 0;
    rsmAlways: NeedVisible := True;
    rsmNever: NeedVisible := False;
  end;

  if NeedVisible then
  begin
    FScrollBar.Width := FScrollBarWidth;
    FScrollBar.SetBounds(ClientWidth - FScrollBar.Width, 0, FScrollBar.Width, ClientHeight);
    FScrollBar.Min := 0;
    FScrollBar.Max := MaxScroll;
    FScrollBar.SmallChange := FItemHeight;
    FScrollBar.LargeChange := FItemHeight * 3;
    ClampScrollOffset;
    if FScrollBar.Position <> FScrollOffset then
      FScrollBar.Position := FScrollOffset;
    FScrollBar.Visible := True;
    FScrollBar.BringToFront;
  end
  else
  begin
    FScrollBar.Visible := False;
    if FScrollOffset <> 0 then
    begin
      FScrollOffset := 0;
      Invalidate;
    end;
  end;
end;

procedure TLazRibbonBackstageRecentList.Resize;
begin
  inherited Resize;
  ClampScrollOffset;
  UpdateScrollBar;
end;

procedure TLazRibbonBackstageRecentList.AddRecent(const ATitle, ADetail: String);
var
  I: Integer;
  TitleText, DetailText, S: String;
begin
  if Trim(ATitle) = '' then
    Exit;

  S := ATitle;
  if ADetail <> '' then
    S := S + '=' + ADetail;

  FItems.BeginUpdate;
  try
    for I := FItems.Count - 1 downto 0 do
    begin
      ParseItem(I, TitleText, DetailText);
      if SameText(TitleText, ATitle) and SameText(DetailText, ADetail) then
        FItems.Delete(I);
    end;
    FItems.Insert(0, S);
    if FMaxRecentItems > 0 then
      while FItems.Count > FMaxRecentItems do
        FItems.Delete(FItems.Count - 1);
  finally
    FItems.EndUpdate;
  end;
end;

procedure TLazRibbonBackstageRecentList.ClearRecent;
begin
  FItems.Clear;
end;

procedure TLazRibbonBackstageRecentList.DeleteRecent(AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= FItems.Count) then
    Exit;
  FItems.Delete(AIndex);
end;

procedure TLazRibbonBackstageRecentList.LoadFromIniFile(const AFileName: String; const ASection: String);
var
  Ini: TIniFile;
  SectionName, S: String;
  Count, I: Integer;
begin
  SectionName := ASection;
  if SectionName = '' then
    SectionName := FStorageSection;
  if SectionName = '' then
    SectionName := 'RecentFiles';

  if not FileExists(AFileName) then
    Exit;

  Ini := TIniFile.Create(AFileName);
  try
    Count := Ini.ReadInteger(SectionName, 'Count', 0);
    FItems.BeginUpdate;
    try
      FItems.Clear;
      for I := 0 to Count - 1 do
      begin
        S := Ini.ReadString(SectionName, 'Item' + IntToStr(I), '');
        if S <> '' then
          FItems.Add(S);
      end;
    finally
      FItems.EndUpdate;
    end;
  finally
    Ini.Free;
  end;
  ClampScrollOffset;
  UpdateScrollBar;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SaveToIniFile(const AFileName: String; const ASection: String);
var
  Ini: TIniFile;
  SectionName: String;
  I: Integer;
begin
  SectionName := ASection;
  if SectionName = '' then
    SectionName := FStorageSection;
  if SectionName = '' then
    SectionName := 'RecentFiles';

  if ExtractFileDir(AFileName) <> '' then
    ForceDirectories(ExtractFileDir(AFileName));
  Ini := TIniFile.Create(AFileName);
  try
    Ini.EraseSection(SectionName);
    Ini.WriteInteger(SectionName, 'Count', FItems.Count);
    for I := 0 to FItems.Count - 1 do
      Ini.WriteString(SectionName, 'Item' + IntToStr(I), FItems[I]);
  finally
    Ini.Free;
  end;
end;

procedure TLazRibbonBackstageRecentList.SetScrollBarWidth(AValue: Integer);
begin
  if AValue < 8 then
    AValue := 8;
  if AValue > 24 then
    AValue := 24;
  if FScrollBarWidth = AValue then Exit;
  FScrollBarWidth := AValue;
  if FScrollBar <> nil then
    FScrollBar.Width := FScrollBarWidth;
  UpdateScrollBar;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetSelectedIndex(AValue: Integer);
begin
  if AValue >= FItems.Count then
    AValue := -1;
  if AValue < -1 then
    AValue := -1;
  if FSelectedIndex = AValue then Exit;
  FSelectedIndex := AValue;
  EnsureItemVisible(FSelectedIndex);
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetSelectionStyle(AValue: TLazRibbonBackstageRecentSelectionStyle);
begin
  if FSelectionStyle = AValue then Exit;
  FSelectionStyle := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetSkinManager(AValue: TLazRibbonSkinManager);
begin
  if FSkinManager = AValue then Exit;
  if FSkinManager <> nil then
    FSkinManager.RemoveFreeNotification(Self);
  FSkinManager := AValue;
  if FSkinManager <> nil then
  begin
    FSkinManager.FreeNotification(Self);
    FAppearanceSource := asSkinManager;
  end;
  if (FSkinManager = nil) and (FAppearanceSource = asSkinManager) then
    FAppearanceSource := asInternalStyle;
  Invalidate;
end;

procedure TLazRibbonBackstageRecentList.SetItems(AValue: TStrings);
begin
  FItems.Assign(AValue);
  if FMaxRecentItems > 0 then
    while FItems.Count > FMaxRecentItems do
      FItems.Delete(FItems.Count - 1);
  ClampScrollOffset;
  UpdateScrollBar;
  Invalidate;
end;

{ TLazRibbonBackstageView }

constructor TLazRibbonBackstageView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque];
  FAppearanceSource := asLinkedToolbar;
  Align := alClient;
  Color := clWhite;
  ParentFont := False;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FActivePageIndex := 0;
  FAutoHideAtRuntime := True;
  FBackstageTabCaption := 'Arquivo';
  FBackButtonHint := 'Voltar';
  FBackButtonStyle := bbsCircleChevron;
  FButtons := TLazRibbonBackstageButtons.Create(Self);
  FCloseButtonAreaHeight := 34;
  FCloseOnEscape := True;
  FCloseOnRibbonTabClick := True;
  FHeaderHeight := 0;
  FHoverPageIndex := -1;
  FImages := nil;
  FLargeImages := nil;
  FItemHeight := 42;
  FNavigationStyle := bnsOffice;
  FPageButtonVisualMode := bpvmSelectable;
  FNavigationWidth := 180;
  FOldToolbarMenuButtonClick := nil;
  FOldToolbarTabChanging := nil;
  FOpenOnTabCaption := True;
  FOverlayActive := False;
  FOverlayMode := bomCoverClientArea;
  FPressedPageIndex := -1;
  FSavedAlign := alNone;
  FSavedAnchors := [];
  FSavedBounds := Rect(0, 0, 0, 0);
  FBackButtonVisible := True;
  FSkinManager := nil;
  FStyle := lazOffice2007Blue;
  FTitle := '';
  FToolbarEventsHooked := False;
  TabStop := True;
  ShowHint := True;
  Width := 700;
  Height := 420;
end;

destructor TLazRibbonBackstageView.Destroy;
begin
  FButtons.Free;
  inherited Destroy;
end;

function TLazRibbonBackstageView.AddPage(const ACaption: String): TLazRibbonBackstagePage;
begin
  Result := TLazRibbonBackstagePage.Create(Owner);
  Result.Caption := ACaption;
  Result.Parent := Self;
  Result.Align := alNone;
  if PageCount = 1 then
    FActivePageIndex := 0;
  UpdatePages;
  Invalidate;
end;

procedure TLazRibbonBackstageView.AttachToToolbar(AToolbar: TLazRibbon; const AMenuCaption: String);
begin
  BackstageTabCaption := AMenuCaption;
  { A BackStage opened from a Ribbon must always have an obvious way back.
    Without this, the view covers the tab contents and the user is trapped in
    the BackStage unless the application provides its own close command. }
  FBackButtonVisible := True;
  LinkedToolbar := AToolbar;
  if FLinkedToolbar <> nil then
  begin
    FLinkedToolbar.ApplicationButton.Visible := True;
    FLinkedToolbar.ApplicationButton.Caption := AMenuCaption;
    FStyle := FLinkedToolbar.Style;
    HookToolbarEvents;
    Invalidate;
  end;
end;

procedure TLazRibbonBackstageView.AttachToRibbonComponent(AToolbar: TCustomControl; const AMenuCaption: String);
begin
  if AToolbar is TLazRibbon then
    AttachToToolbar(TLazRibbon(AToolbar), AMenuCaption);
end;

procedure TLazRibbonBackstageView.DetachFromRibbonComponent(AToolbar: TCustomControl);
begin
  if (AToolbar = nil) or (AToolbar = FLinkedToolbar) then
    LinkedToolbar := nil;
end;

procedure TLazRibbonBackstageView.SetRibbonSkinProvider(ASkinProvider: ILazRibbonSkinProvider);
var
  Obj: TObject;
begin
  Obj := nil;
  if ASkinProvider <> nil then
    Obj := ASkinProvider.GetSkinManagerObject;
  SetRibbonSkinManagerObject(Obj);
end;

procedure TLazRibbonBackstageView.SetRibbonSkinManagerObject(ASkinManager: TObject);
begin
  if ASkinManager is TLazRibbonSkinManager then
    SkinManager := TLazRibbonSkinManager(ASkinManager)
  else
    SkinManager := nil;
end;

function TLazRibbonBackstageView.GetLinkedAppearance: TLazRibbonToolbarAppearance;
begin
  Result := nil;
  if (FAppearanceSource = asLinkedToolbar) and (FLinkedToolbar <> nil) then
    Result := FLinkedToolbar.RibbonAppearance;
end;

function TLazRibbonBackstageView.GetPageBackColor: TColor;
var
  A: TLazRibbonToolbarAppearance;
  P: TLazRibbonSkinPalette;
begin
  if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
  begin
    P := FSkinManager.Palette;
    Result := P.BackColor;
    Exit;
  end;

  A := GetLinkedAppearance;
  if A <> nil then
  begin
    if LazIsDarkColor(A.Pane.GradientFromColor) then
      Result := LazMixColor(A.Pane.GradientFromColor, clBlack, 18)
    else
      Result := LazMixColor(A.Pane.GradientFromColor, clWhite, 62);
  end
  else
    Result := Color;
end;

procedure TLazRibbonBackstageView.GetColors(out ABackColor, ANavColor, AActiveColor,
  AHotColor, AFrameColor, ATextColor, AMutedTextColor: TColor);
var
  A: TLazRibbonToolbarAppearance;
  P: TLazRibbonSkinPalette;
begin
  if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
  begin
    P := FSkinManager.Palette;
    ABackColor := P.BackColor;
    ANavColor := P.BackstageNavColor;
    AFrameColor := P.BackstageNavSelectedFrameColor;
    AActiveColor := LazBackstageEnsureSelectedSurface(ANavColor,
      P.BackstageNavSelectedColor, AFrameColor, FStyle);
    AHotColor := P.BackstageNavHoverColor;
    ATextColor := P.BackstageNavTextColor;
    AMutedTextColor := P.BackstageNavMutedTextColor;
    Exit;
  end;

  A := GetLinkedAppearance;
  if A <> nil then
  begin
    { Do not reuse MenuButton painting colors directly here. The BackStage
      navigation needs a flatter Office-like palette; otherwise some LazRibbon_Core
      themes produce dark blocks and a broken-looking close/back button. Use the
      toolbar appearance only as a color source. }
    ABackColor := GetPageBackColor;
    ANavColor := LazMixColor(A.Tab.GradientFromColor, A.Tab.GradientToColor, 35);

    if LazIsDarkColor(ANavColor) then
    begin
      AHotColor := LazLighter(ANavColor, 20);
      AFrameColor := LazLighter(ANavColor, 52);
    end
    else
    begin
      AHotColor := LazMixColor(ANavColor, clWhite, 42);
      AFrameColor := LazSubtleFrameColor(ANavColor);
    end;

    { The linked-toolbar active tab color is frequently a pale surface, not a
      real BackStage selection color.  Use a stable style accent for selected
      page items so the selection does not change when the mouse moves over
      other BackStage commands. }
    AActiveColor := LazBackstageEnsureSelectedSurface(ANavColor,
      LazBackstageAccentForStyle(FStyle), AFrameColor, FStyle);

    ATextColor := LazReadableTextColor(ANavColor, A.Tab.TabHeaderFont.Color);
    AMutedTextColor := LazReadableMutedTextColor(ANavColor, ATextColor);
    Exit;
  end;

  case FStyle of
    lazMetroDark:
      begin
        ABackColor := $002B2B2B;
        ANavColor := $00202020;
        AActiveColor := $00404040;
        AHotColor := $00353535;
        AFrameColor := $00606060;
        ATextColor := clWhite;
        AMutedTextColor := $00C0C0C0;
      end;
    lazMetroLight:
      begin
        ABackColor := clWhite;
        ANavColor := $00F3F3F3;
        AActiveColor := $00E5E5E5;
        AHotColor := $00EEEEEE;
        AFrameColor := $00C8C8C8;
        ATextColor := $00202020;
        AMutedTextColor := $00606060;
      end;
    lazOffice2007Silver, lazOffice2007SilverTurquoise:
      begin
        ABackColor := clWhite;
        ANavColor := $00F1F2F4;
        AActiveColor := $00DADDE4;
        AHotColor := $00E8EBF0;
        AFrameColor := $00A9B1C0;
        ATextColor := $00202020;
        AMutedTextColor := $00606060;
      end;
    lazOffice2007Rose:
      begin
        ABackColor := clWhite;
        ANavColor := $00F7EEF2;
        AActiveColor := $00ECD7E0;
        AHotColor := $00F3E3EA;
        AFrameColor := $00C99CAF;
        ATextColor := $00202020;
        AMutedTextColor := $00606060;
      end;
    lazOffice2007Sage:
      begin
        ABackColor := clWhite;
        ANavColor := $00EEF5EE;
        AActiveColor := $00D8E8D8;
        AHotColor := $00E5F0E5;
        AFrameColor := $0099B799;
        ATextColor := $00202020;
        AMutedTextColor := $00606060;
      end;
    lazOffice2007Bege:
      begin
        ABackColor := clWhite;
        ANavColor := $00F5F0E4;
        AActiveColor := $00E8DCC6;
        AHotColor := $00EFE6D5;
        AFrameColor := $00B9A77E;
        ATextColor := $00202020;
        AMutedTextColor := $00606060;
      end;
  else
    begin
      ABackColor := clWhite;
      ANavColor := $00F2F7FC;
      AActiveColor := $00DCEBFA;
      AHotColor := $00EAF3FC;
      AFrameColor := $0094B6D2;
      ATextColor := $001E395B;
      AMutedTextColor := $005F6F7F;
    end;
  end;
end;

function TLazRibbonBackstageView.GetCloseButtonRect: TRect;
var
  S, HeaderContentHeight, TopInset, TopY: Integer;
begin
  { Keep the BackStage return button compact.  It should be a small title-area
    command, not a large navigation item competing with the menu entries. }
  if FBackButtonStyle = bbsCircleChevron then
    S := 22
  else
    S := 22;
  TopInset := GetClientOverlayTopInset;
  HeaderContentHeight := GetEffectiveHeaderHeight - TopInset;
  TopY := TopInset + (HeaderContentHeight - S) div 2;
  if TopY < TopInset + 7 then
    TopY := TopInset + 7;
  Result := Rect(15, TopY, 15 + S, TopY + S);
end;

procedure TLazRibbonBackstageView.DrawChevronLeft(ACanvas: TCanvas; const R: TRect;
  AColor: TColor; AThickness: Integer);
var
  CX, CY: Integer;
  S, HalfH, HalfW, StrokeW: Integer;
  XLeft, XRight, YTop, YBottom: Integer;
  OldBrushStyle: TBrushStyle;
  OldPenColor: TColor;
  OldPenWidth: Integer;
begin
  { A clean Office-like chevron.  The previous version used several shadow
    strokes and still looked almost the same as before.  Here the idle BackStage
    glyph is deliberately simple: two firm vector strokes, no filled shaft, no
    character-like artefact. }
  S := R.Right - R.Left;
  if (R.Bottom - R.Top) < S then
    S := R.Bottom - R.Top;
  if S < 14 then
    S := 14;

  CX := (R.Left + R.Right) div 2 - 1;
  CY := (R.Top + R.Bottom) div 2;

  HalfH := S div 4;
  if HalfH < 5 then HalfH := 5;
  HalfW := S div 4;
  if HalfW < 5 then HalfW := 5;

  XLeft := CX - HalfW + 1;
  XRight := CX + HalfW - 1;
  YTop := CY - HalfH;
  YBottom := CY + HalfH;

  StrokeW := AThickness;
  if StrokeW < 2 then StrokeW := 2;
  if StrokeW > 3 then StrokeW := 3;

  OldBrushStyle := ACanvas.Brush.Style;
  OldPenColor := ACanvas.Pen.Color;
  OldPenWidth := ACanvas.Pen.Width;

  ACanvas.Brush.Style := bsClear;
  ACanvas.Pen.Width := StrokeW;
  ACanvas.Pen.Color := AColor;
  ACanvas.Line(XRight, YTop, XLeft, CY);
  ACanvas.Line(XLeft, CY, XRight, YBottom);

  ACanvas.Pen.Width := OldPenWidth;
  ACanvas.Pen.Color := OldPenColor;
  ACanvas.Brush.Style := OldBrushStyle;
end;

procedure TLazRibbonBackstageView.DrawBackButton(ACanvas: TCanvas; const R: TRect;
  ABackColor, AFrameColor, ATextColor: TColor; AHot, APressed: Boolean);
var
  FillColor, BorderColor, GlyphColor: TColor;
  OldBrushStyle: TBrushStyle;
  OldPenWidth: Integer;
begin
  FillColor := ABackColor;
  BorderColor := AFrameColor;

  if APressed then
  begin
    if LazIsDarkColor(FillColor) then
      FillColor := LazLighter(FillColor, 28)
    else
      FillColor := LazDarker(FillColor, 10);
  end
  else if AHot then
  begin
    if LazIsDarkColor(FillColor) then
      FillColor := LazLighter(FillColor, 16)
    else
      FillColor := LazMixColor(FillColor, clWhite, 30);
  end;

  GlyphColor := LazReadableTextColor(FillColor, ATextColor);
  if (not AHot) and (not APressed) then
  begin
    { In idle state, the Office/DevExpress-like BackStage button should not look
      like a heavy toolbar button.  Keep only a faint ring and the chevron. }
    if LazIsDarkColor(ABackColor) then
      BorderColor := LazLighter(ABackColor, 42)
    else
      BorderColor := LazMixColor(ABackColor, AFrameColor, 42);
  end
  else if LazIsDarkColor(FillColor) then
    BorderColor := LazLighter(BorderColor, 32)
  else
    BorderColor := LazDarker(BorderColor, 12);

  OldBrushStyle := ACanvas.Brush.Style;
  OldPenWidth := ACanvas.Pen.Width;
  ACanvas.Pen.Width := 1;

  if FBackButtonStyle = bbsCircleChevron then
  begin
    if AHot or APressed then
    begin
      ACanvas.Brush.Style := bsSolid;
      ACanvas.Brush.Color := FillColor;
      ACanvas.Pen.Color := BorderColor;
      ACanvas.Ellipse(R);
    end
    else
    begin
      ACanvas.Brush.Style := bsClear;
      ACanvas.Pen.Color := BorderColor;
      ACanvas.Ellipse(R);
    end;
  end
  else
  begin
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := FillColor;
    ACanvas.Pen.Color := BorderColor;
    ACanvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 6, 6);
  end;

  DrawChevronLeft(ACanvas, R, GlyphColor, 2);

  ACanvas.Pen.Width := OldPenWidth;
  ACanvas.Brush.Style := OldBrushStyle;
end;

function TLazRibbonBackstageView.GetContentRect: TRect;
var
  TopInset: Integer;
begin
  TopInset := GetClientOverlayTopInset;
  if FNavigationStyle = bnsOffice then
    Result := Rect(FNavigationWidth + 12, TopInset, ClientWidth, ClientHeight)
  else
    Result := Rect(FNavigationWidth, TopInset, ClientWidth, ClientHeight);
end;

function TLazRibbonBackstageView.GetEffectiveHeaderHeight: Integer;
var
  TopInset: Integer;
begin
  { Do not apply HeaderHeight blindly. BackStage can have three distinct
    states: no header, compact return-button header, or full title header.
    The previous implementation used 56 pixels whenever BackButtonVisible was
    True, leaving too much space between the return arrow and the first item. }
  TopInset := GetClientOverlayTopInset;
  if FTitle <> '' then
  begin
    if FHeaderHeight > 0 then
      Result := FHeaderHeight
    else
      Result := 56;
  end
  else if FBackButtonVisible then
  begin
    Result := FCloseButtonAreaHeight;
    if Result < 32 then
      Result := 32;
  end
  else
    Result := 0;
  Inc(Result, TopInset);
end;

function TLazRibbonBackstageView.GetNavItemCount: Integer;
begin
  if (FButtons <> nil) and (FButtons.Count > 0) then
    Result := FButtons.Count
  else
    Result := PageCount;
end;

function TLazRibbonBackstageView.GetNavButton(AIndex: Integer): TLazRibbonBackstageButton;
begin
  Result := nil;
  if (FButtons <> nil) and (FButtons.Count > 0) and
    (AIndex >= 0) and (AIndex < FButtons.Count) then
    Result := FButtons[AIndex];
end;

function LazRibbonBackstageButtonEffectiveKind(ABtn: TLazRibbonBackstageButton): TLazRibbonBackstageButtonKind;
begin
  if ABtn = nil then
  begin
    Result := bbkSeparator;
    Exit;
  end;

  Result := ABtn.Kind;

  { Compatibility guard. Older demos/forms may have persisted a button with
    Kind=bbkCommand and Page assigned. In practice, a BackStage entry with a
    Page is a navigation/page item. Treating it as a command made hover and
    active painting follow two different visual paths, which is why "Recentes"
    could become dark blue when the mouse moved over "Abrir". }
  if (Result <> bbkSeparator) and (ABtn.Page <> nil) then
    Result := bbkPage;
end;

function TLazRibbonBackstageView.GetNavItemHeight(AIndex: Integer): Integer;
var
  Page: TLazRibbonBackstagePage;
  Btn: TLazRibbonBackstageButton;
begin
  Result := FItemHeight;

  Btn := GetNavButton(AIndex);
  if Btn <> nil then
  begin
    if not Btn.EffectiveVisible then
    begin
      Result := 0;
      Exit;
    end;
    case LazRibbonBackstageButtonEffectiveKind(Btn) of
      bbkSeparator: Result := 14;
      bbkCommand: Result := 30;
      bbkPage:
        if FItemHeight > 44 then
          Result := FItemHeight
        else
          Result := 44;
    else
      Result := FItemHeight;
    end;
    Exit;
  end;

  Page := GetPage(AIndex);
  if (Page <> nil) and not Page.EffectiveVisible then
  begin
    Result := 0;
    Exit;
  end;
  if Page <> nil then
    case Page.ItemKind of
      bpkSeparator: Result := 14;
      bpkCommand: Result := 30;
      bpkPage:
        if FItemHeight > 44 then
          Result := FItemHeight
        else
          Result := 44;
    end;
end;

function TLazRibbonBackstageView.GetNavItemTop(AIndex: Integer): Integer;
var
  I: Integer;
  Btn: TLazRibbonBackstageButton;
begin
  Btn := GetNavButton(AIndex);
  if (Btn <> nil) and (Btn.Section = bbsBottom) then
  begin
    Result := ClientHeight;
    for I := GetNavItemCount - 1 downto AIndex do
    begin
      Btn := GetNavButton(I);
      if (Btn <> nil) and (Btn.Section = bbsBottom) then
        Dec(Result, GetNavItemHeight(I));
    end;
    Exit;
  end;

  Result := GetEffectiveHeaderHeight;
  for I := 0 to AIndex - 1 do
  begin
    Btn := GetNavButton(I);
    if (Btn = nil) or (Btn.Section = bbsTop) then
      Inc(Result, GetNavItemHeight(I));
  end;
end;

function TLazRibbonBackstageView.GetNavItemRect(AIndex: Integer): TRect;
var
  TopY: Integer;
begin
  TopY := GetNavItemTop(AIndex);
  Result := Rect(0, TopY, FNavigationWidth, TopY + GetNavItemHeight(AIndex));
end;

function TLazRibbonBackstageView.GetPage(AIndex: Integer): TLazRibbonBackstagePage;
var
  I, N: Integer;
begin
  Result := nil;
  N := -1;
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TLazRibbonBackstagePage then
    begin
      Inc(N);
      if N = AIndex then
      begin
        Result := TLazRibbonBackstagePage(Controls[I]);
        Exit;
      end;
    end;
end;

function TLazRibbonBackstageView.GetPageCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TLazRibbonBackstagePage then
      Inc(Result);
end;

function TLazRibbonBackstageView.GetPageIndex(APage: TLazRibbonBackstagePage): Integer;
var
  I, N: Integer;
begin
  Result := -1;
  N := -1;
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TLazRibbonBackstagePage then
    begin
      Inc(N);
      if Controls[I] = APage then
      begin
        Result := N;
        Exit;
      end;
    end;
end;

procedure TLazRibbonBackstageView.HideBackstage;
var
  CanClose: Boolean;
begin
  CanClose := True;
  if Assigned(FOnClose) then
    FOnClose(Self, CanClose);
  if not CanClose then Exit;

  Visible := False;
  RestoreOverlayBounds;
  if Assigned(FOnClosed) then
    FOnClosed(Self);
end;

function TLazRibbonBackstageView.HitTestPage(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to GetNavItemCount - 1 do
    if PtInRect(GetNavItemRect(I), Point(X, Y)) then
    begin
      if IsSelectableNavItem(I) or IsCommandNavItem(I) then
        Result := I;
      Exit;
    end;
end;

function TLazRibbonBackstageView.IsSelectableNavItem(AIndex: Integer): Boolean;
var
  Btn: TLazRibbonBackstageButton;
begin
  Btn := GetNavButton(AIndex);
  if Btn <> nil then
  begin
    Result := (LazRibbonBackstageButtonEffectiveKind(Btn) = bbkPage) and (Btn.Page <> nil) and
      Btn.EffectiveVisible and Btn.EffectiveEnabled;
    Exit;
  end;
  Result := IsSelectablePage(AIndex);
end;

function TLazRibbonBackstageView.IsCommandNavItem(AIndex: Integer): Boolean;
var
  Btn: TLazRibbonBackstageButton;
  Page: TLazRibbonBackstagePage;
begin
  Btn := GetNavButton(AIndex);
  if Btn <> nil then
  begin
    Result := (LazRibbonBackstageButtonEffectiveKind(Btn) = bbkCommand) and Btn.EffectiveVisible and Btn.EffectiveEnabled;
    Exit;
  end;

  Page := GetPage(AIndex);
  Result := (Page <> nil) and (Page.ItemKind = bpkCommand) and
    Page.EffectiveVisible and Page.EffectiveEnabled;
end;

procedure TLazRibbonBackstageView.ExecuteNavItem(AIndex: Integer);
var
  Btn: TLazRibbonBackstageButton;
  Page: TLazRibbonBackstagePage;
begin
  Btn := GetNavButton(AIndex);
  if Btn <> nil then
  begin
    if LazRibbonBackstageButtonEffectiveKind(Btn) = bbkPage then
    begin
      if Btn.Page <> nil then
        ActivePageIndex := GetPageIndex(Btn.Page);
    end
    else if LazRibbonBackstageButtonEffectiveKind(Btn) = bbkCommand then
    begin
      Btn.Execute;
      if Btn.CloseBackstageOnClick then
        HideBackstage;
    end;
    Exit;
  end;

  if IsSelectablePage(AIndex) then
    ActivePageIndex := AIndex
  else
  begin
    Page := GetPage(AIndex);
    if (Page <> nil) and (Page.ItemKind = bpkCommand) then
    begin
      Page.Execute;
      if Page.CloseBackstageOnClick then
        HideBackstage;
    end;
  end;
end;

function TLazRibbonBackstageView.IsSelectablePage(AIndex: Integer): Boolean;
var
  Page: TLazRibbonBackstagePage;
begin
  Page := GetPage(AIndex);
  Result := (Page <> nil) and (Page.ItemKind = bpkPage) and
    Page.EffectiveVisible and Page.EffectiveEnabled;
end;

function TLazRibbonBackstageView.FirstSelectablePageIndex: Integer;
var
  I, PageIndex: Integer;
  Btn: TLazRibbonBackstageButton;
begin
  Result := -1;

  if (FButtons <> nil) and (FButtons.Count > 0) then
  begin
    for I := 0 to FButtons.Count - 1 do
    begin
      Btn := FButtons[I];
      if (Btn <> nil) and (LazRibbonBackstageButtonEffectiveKind(Btn) = bbkPage) and (Btn.Page <> nil) and
        Btn.EffectiveVisible and Btn.EffectiveEnabled then
      begin
        PageIndex := GetPageIndex(Btn.Page);
        if PageIndex >= 0 then
        begin
          Result := PageIndex;
          Exit;
        end;
      end;
    end;
    Exit;
  end;

  for I := 0 to PageCount - 1 do
    if IsSelectablePage(I) then
    begin
      Result := I;
      Exit;
    end;
end;

function TLazRibbonBackstageView.IsCloseButtonAt(X, Y: Integer): Boolean;
begin
  Result := FBackButtonVisible and PtInRect(GetCloseButtonRect, Point(X, Y));
end;

function TLazRibbonBackstageView.GetOverlayTop: Integer;
var
  TabCaptionHeight: Integer;
begin
  Result := 0;
  if (FLinkedToolbar = nil) or (FLinkedToolbar.Parent <> Parent) then
    Exit;

  case FOverlayMode of
    bomCoverClientArea:
      Result := 0;

    bomCoverRibbonArea:
      begin
        TabCaptionHeight := FLinkedToolbar.RibbonAppearance.Tab.CalcCaptionHeight;
        Result := FLinkedToolbar.Top + TabCaptionHeight;
      end;
  else
    Result := Top;
  end;

  if Result < 0 then
    Result := 0;
  if (Parent <> nil) and (Result > Parent.ClientHeight) then
    Result := 0;
end;

function TLazRibbonBackstageView.GetClientOverlayTopInset: Integer;
var
  I: Integer;
  Ctrl: TControl;
begin
  Result := 0;
  if FOverlayMode <> bomCoverClientArea then Exit;
  if Parent = nil then Exit;

  for I := 0 to Parent.ControlCount - 1 do
  begin
    Ctrl := Parent.Controls[I];
    if (Ctrl <> Self) and Ctrl.Visible and
       SameText(Ctrl.ClassName, 'TLazRibbonTitleBar') then
    begin
      if Ctrl.Align = alTop then
        Result := Max(Result, Ctrl.Top + Ctrl.Height)
      else if Ctrl.Top <= 0 then
        Result := Max(Result, Ctrl.Height);
    end;
  end;
end;

procedure TLazRibbonBackstageView.BringParentClientChromeToFront;
var
  I: Integer;
  Ctrl: TControl;
begin
  if FOverlayMode <> bomCoverClientArea then Exit;
  if Parent = nil then Exit;

  for I := 0 to Parent.ControlCount - 1 do
  begin
    Ctrl := Parent.Controls[I];
    if (Ctrl <> Self) and Ctrl.Visible and
       SameText(Ctrl.ClassName, 'TLazRibbonTitleBar') then
    begin
      Ctrl.BringToFront;
      Ctrl.Invalidate;
    end;
  end;
end;

procedure TLazRibbonBackstageView.ApplyOverlayBounds;
var
  OverlayTop: Integer;
begin
  if (csDesigning in ComponentState) then Exit;
  if FOverlayMode = bomNone then Exit;
  if (Parent = nil) or (FLinkedToolbar = nil) then Exit;
  if FLinkedToolbar.Parent <> Parent then Exit;

  if not FOverlayActive then
  begin
    FSavedAlign := Align;
    FSavedAnchors := Anchors;
    FSavedBounds := BoundsRect;
    FOverlayActive := True;
  end;

  OverlayTop := GetOverlayTop;
  Align := alNone;
  Anchors := [akLeft, akTop, akRight, akBottom];
  if (Left <> 0) or (Top <> OverlayTop) or
     (Width <> Parent.ClientWidth) or (Height <> Parent.ClientHeight - OverlayTop) then
    SetBounds(0, OverlayTop, Parent.ClientWidth, Parent.ClientHeight - OverlayTop);
  BringParentClientChromeToFront;
end;

procedure TLazRibbonBackstageView.RestoreOverlayBounds;
begin
  if not FOverlayActive then Exit;

  Align := alNone;
  BoundsRect := FSavedBounds;
  Anchors := FSavedAnchors;
  Align := FSavedAlign;
  FOverlayActive := False;
  BringParentClientChromeToFront;
end;

procedure TLazRibbonBackstageView.Loaded;
begin
  inherited Loaded;
  NormalizePageParents;
  if (PageCount > 0) and ((FActivePageIndex < 0) or not IsSelectablePage(FActivePageIndex)) then
    FActivePageIndex := FirstSelectablePageIndex;
  UpdatePages;
  if FAutoHideAtRuntime and not (csDesigning in ComponentState) then
    Visible := False;
end;

procedure TLazRibbonBackstageView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FCloseOnEscape and (Key = VK_ESCAPE) and Visible then
  begin
    Key := 0;
    HideBackstage;
  end;
end;

procedure TLazRibbonBackstageView.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button <> mbLeft then Exit;
  if IsCloseButtonAt(X, Y) then
  begin
    FPressedPageIndex := -2;
    Invalidate;
    Exit;
  end;
  FPressedPageIndex := HitTestPage(X, Y);
  if FPressedPageIndex >= 0 then
    Invalidate;
end;

procedure TLazRibbonBackstageView.MouseLeave;
begin
  inherited MouseLeave;
  if FHoverPageIndex <> -1 then
  begin
    FHoverPageIndex := -1;
    Invalidate;
  end;
end;

procedure TLazRibbonBackstageView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewHover: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  if IsCloseButtonAt(X, Y) then
    NewHover := -2
  else
    NewHover := HitTestPage(X, Y);

  if NewHover <> FHoverPageIndex then
  begin
    FHoverPageIndex := NewHover;
    if NewHover = -2 then
      Hint := FBackButtonHint
    else
      Hint := '';
    Invalidate;
  end;
end;

procedure TLazRibbonBackstageView.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Hit: Integer;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button <> mbLeft then Exit;

  if (FPressedPageIndex = -2) and IsCloseButtonAt(X, Y) then
  begin
    FPressedPageIndex := -1;
    HideBackstage;
    Exit;
  end;

  Hit := HitTestPage(X, Y);
  if (FPressedPageIndex >= 0) and (Hit = FPressedPageIndex) then
    ExecuteNavItem(Hit);
  FPressedPageIndex := -1;
  Invalidate;
end;

procedure TLazRibbonBackstageView.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FLinkedToolbar) then
  begin
    FLinkedToolbar := nil;
    FOldToolbarMenuButtonClick := nil;
    FOldToolbarTabChanging := nil;
    FToolbarEventsHooked := False;
    Invalidate;
  end;

  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
  if (Operation = opRemove) and (AComponent = FLargeImages) then
    FLargeImages := nil;
  if (Operation = opRemove) and (AComponent = FSkinManager) then
    FSkinManager := nil;

  if (Operation = opRemove) and (FButtons <> nil) then
    for I := 0 to FButtons.Count - 1 do
    begin
      if FButtons[I].Action = AComponent then
        FButtons[I].Action := nil;
      if FButtons[I].Page = AComponent then
        FButtons[I].Page := nil;
      if FButtons[I].LinkedItem = AComponent then
        FButtons[I].LinkedItem := nil;
    end;
end;

procedure TLazRibbonBackstageView.NormalizePageParents;

  procedure Scan(AParent: TWinControl);
  var
    I: Integer;
    C: TControl;
  begin
    for I := AParent.ControlCount - 1 downto 0 do
    begin
      C := AParent.Controls[I];
      if C is TLazRibbonBackstagePage then
      begin
        if C.Parent <> Self then
          C.Parent := Self
        else
          Scan(TWinControl(C));
      end
      else if C is TWinControl then
        Scan(TWinControl(C));
    end;
  end;

begin
  if csDestroying in ComponentState then Exit;
  Scan(Self);
end;

procedure TLazRibbonBackstageView.Paint;
var
  BackColor, NavColor, ActiveColor, HotColor, FrameColor, TextColor, MutedTextColor: TColor;
  R, CR, PaintR, SepR: TRect;
  I, J, MidY, IconIndex, IconX, IconY, ActiveNavIndex: Integer;
  FirstBottom: Boolean;
  IconList: TCustomImageList;
  S: String;
  Page, ActivePaintPage: TLazRibbonBackstagePage;
  Btn: TLazRibbonBackstageButton;
  CloseR: TRect;
  A: TLazRibbonToolbarAppearance;
  IdleCaptionColor, HotCaptionColor, ActiveCaptionColor, SelectedCaptionColor: TColor;
  ActiveFrameColor, SelectedBackColor, HoverBackColor, HoverFrameColor, CaptionBackColor, CaptionTextColor: TColor;
  IsPageItem, IsCommandItem, IsActive, IsHot, IsPressed, IsEnabled, IsBeginGroup: Boolean;
  IsFixedPageItem, VisualActive, VisualHot, VisualPressed: Boolean;

  function GetActiveNavIndex: Integer;
  var
    ActivePage: TLazRibbonBackstagePage;
    K: Integer;
    B: TLazRibbonBackstageButton;
  begin
    Result := -1;
    if (FActivePageIndex < 0) or (FActivePageIndex >= PageCount) then
      Exit;

    ActivePage := GetPage(FActivePageIndex);
    if ActivePage = nil then
      Exit;

    if (FButtons <> nil) and (FButtons.Count > 0) then
    begin
      for K := 0 to FButtons.Count - 1 do
      begin
        B := FButtons[K];
        if (B <> nil) and B.EffectiveVisible and
          (LazRibbonBackstageButtonEffectiveKind(B) = bbkPage) and (B.Page = ActivePage) then
        begin
          Result := K;
          Exit;
        end;
      end;
      Exit;
    end;

    Result := FActivePageIndex;
  end;

  function ResolveSelectedBackColor: TColor;
  var
    ContentSurface: TColor;
  begin
    { Stable selected page surface.

      The active BackStage entry is a persistent navigation anchor. It must not
      be recomputed from hover/accent/MenuButton colors, otherwise a selected
      item such as "Recentes" can repaint dark when the mouse merely moves
      over "Novo" or "Abrir". Keep the selected page surface tied to the
      content area and navigation column only. }
    ContentSurface := ColorToRGB(GetPageBackColor);

    if LazIsDarkColor(NavColor) then
    begin
      Result := LazMixColor(ContentSurface, NavColor, 58);
      if not LazIsDarkColor(Result) then
        Result := LazLighter(NavColor, 20);
      if LazContrastRatio(Result, NavColor) < 1.12 then
        Result := LazLighter(NavColor, 30);
    end
    else
    begin
      Result := LazMixColor(ContentSurface, NavColor, 12);
      if LazColorBrightness(Result) < 238 then
        Result := LazMixColor(ContentSurface, clWhite, 90);
      if LazContrastRatio(Result, NavColor) < 1.08 then
        Result := LazMixColor(NavColor, clWhite, 94);
    end;
  end;

  function ResolveSelectedFrameColor(const ASurface: TColor): TColor;
  begin
    if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
      Result := FSkinManager.Palette.BackstageNavSelectedFrameColor
    else
      Result := FrameColor;

    if LazContrastRatio(Result, ASurface) < 1.35 then
    begin
      if LazIsDarkColor(ASurface) then
        Result := LazLighter(ASurface, 55)
      else
        Result := LazDarker(ASurface, 55);
    end;
  end;

  function ResolveSelectedTextColor(const ASurface: TColor): TColor;
  var
    Preferred: TColor;
  begin
    Preferred := TextColor;
    if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
      Preferred := FSkinManager.Palette.BackstageNavSelectedTextColor;
    Result := LazBackstageCaptionColorFor(ASurface, Preferred);
  end;

  function ResolveHoverBackColor(const ASelectedSurface: TColor): TColor;
  var
    Preferred: TColor;
  begin
    { Hover is a transient state and must be the same for every non-selected
      page item, independently from which page is currently active.  Earlier
      versions let different button sources/actions fall through to different
      visual surfaces. }
    Preferred := HotColor;
    if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
      Preferred := FSkinManager.Palette.BackstageNavHoverColor;

    Result := Preferred;

    if LazContrastRatio(Result, NavColor) < 1.18 then
    begin
      if LazIsDarkColor(NavColor) then
        Result := LazLighter(NavColor, 32)
      else
        Result := LazMixColor(ASelectedSurface, NavColor, 78);
    end;

    { Keep hover visually below the selected page.  This prevents the hovered
      item from looking selected, while still making hover visible. }
    if (not LazIsDarkColor(NavColor)) and (LazColorBrightness(Result) < 175) then
      Result := LazMixColor(ASelectedSurface, clWhite, 68);

    if LazIsDarkColor(NavColor) and (LazColorBrightness(Result) < LazColorBrightness(NavColor) + 18) then
      Result := LazLighter(NavColor, 34);

    if LazContrastRatio(Result, NavColor) < 1.18 then
    begin
      if LazIsDarkColor(NavColor) then
        Result := LazLighter(NavColor, 46)
      else
        Result := LazDarker(NavColor, 32);
    end;
  end;

  function ResolveHoverFrameColor(const AHoverSurface: TColor): TColor;
  begin
    Result := FrameColor;
    if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
      Result := FSkinManager.Palette.BackstageNavSelectedFrameColor;

    if LazContrastRatio(Result, AHoverSurface) < 1.30 then
    begin
      if LazIsDarkColor(AHoverSurface) then
        Result := LazLighter(AHoverSurface, 45)
      else
        Result := LazDarker(AHoverSurface, 45);
    end;
  end;

  procedure DrawNavFill(const ARect: TRect; ABaseColor, ABorderColor: TColor;
    AActive, AHot, APressed, APageItem: Boolean);
  var
    C1, C2, Accent, Border: TColor;
    RR: TRect;
    TipY: Integer;
  begin
    if (ARect.Right <= ARect.Left) or (ARect.Bottom <= ARect.Top) then Exit;

    C1 := ABaseColor;
    C2 := ABaseColor;
    Border := ABorderColor;

    if AActive then
    begin
      { The selected BackStage page is a persistent navigation state, not a
        mouse state.  Draw it from one resolved surface only.  Earlier versions
        applied gradient/lightening here and ended up with a white selected
        item in some skins while the selected text remained white. }
      Accent := ColorToRGB(ABaseColor);
      C1 := Accent;
      C2 := Accent;
      Border := ColorToRGB(ABorderColor);
    end
    else if APressed then
    begin
      if LazIsDarkColor(ABaseColor) then
      begin
        C1 := LazLighter(ABaseColor, 22);
        C2 := LazLighter(ABaseColor, 10);
      end
      else
      begin
        C1 := LazDarker(ABaseColor, 10);
        C2 := LazDarker(ABaseColor, 20);
      end;
    end
    else if AHot then
    begin
      if LazIsDarkColor(ABaseColor) then
      begin
        C1 := LazLighter(ABaseColor, 12);
        C2 := LazLighter(ABaseColor, 4);
      end
      else
      begin
        C1 := LazMixColor(ABaseColor, clWhite, 48);
        C2 := LazMixColor(ABaseColor, clWhite, 18);
      end;
      if not APageItem then
        Border := C2;
    end;

    if AActive or AHot or APressed then
    begin
      LazFillRectByKind(Canvas, ARect, C1, C2, bkVerticalGradient);

      if APageItem then
      begin
        Canvas.Pen.Color := Border;
        Canvas.Rectangle(ARect);

        { Subtle highlight line; it makes the selected page look like a real
          surface instead of a plain filled rectangle. }
        Canvas.Pen.Color := LazMixColor(C1, clWhite, 45);
        Canvas.Line(ARect.Left + 1, ARect.Top + 1, ARect.Right - 2, ARect.Top + 1);
      end;
    end
    else if APageItem and (FNavigationStyle = bnsClassic) then
    begin
      Canvas.Brush.Color := NavColor;
      Canvas.Pen.Color := FrameColor;
      Canvas.Rectangle(ARect);
    end;

    if AActive and APageItem and (FNavigationStyle = bnsOffice) then
    begin
      Accent := Border;
      if LazIsDarkColor(Accent) then
        Accent := LazLighter(Accent, 38)
      else
        Accent := LazDarker(Accent, 10);

      RR := Rect(ARect.Left, ARect.Top + 2, ARect.Left + 4, ARect.Bottom - 2);
      Canvas.Brush.Color := Accent;
      Canvas.Pen.Color := Accent;
      Canvas.FillRect(RR);

      { A small connector reduces the visual break between the selected menu
        item and the content area. }
      Canvas.Brush.Color := BackColor;
      Canvas.Pen.Color := BackColor;
      Canvas.FillRect(Rect(FNavigationWidth - 2, ARect.Top + 2, FNavigationWidth, ARect.Bottom - 2));

      { Skin-aware, narrower Office-like pointer.  The older 12px pointer was
        visually too aggressive, especially with blue Office skins. }
      TipY := (ARect.Top + ARect.Bottom) div 2;
      Canvas.Brush.Color := LazMixColor(C2, BackColor, 18);
      Canvas.Pen.Color := LazMixColor(Border, BackColor, 36);
      Canvas.Polygon([Point(FNavigationWidth - 1, ARect.Top + 7),
        Point(FNavigationWidth + 8, TipY), Point(FNavigationWidth - 1, ARect.Bottom - 7)]);
    end
    else if AHot and not APageItem then
    begin
      RR := Rect(ARect.Left + 10, ARect.Top + 3, ARect.Left + 13, ARect.Bottom - 3);
      Canvas.Brush.Color := FrameColor;
      Canvas.Pen.Color := FrameColor;
      Canvas.FillRect(RR);
    end;
  end;

  procedure DrawStableSelectedPage(const ARect: TRect);
  var
    Accent, Highlight: TColor;
    RR: TRect;
    TipY: Integer;
  begin
    if (ARect.Right <= ARect.Left) or (ARect.Bottom <= ARect.Top) then Exit;

    { Paint the selected page with one stable neutral surface. Do not call the
      generic hot/active drawing helper here: that helper also serves buttons
      and hover states. Keeping selected-page painting isolated prevents the
      active BackStage item from changing color when another item is hovered. }
    Canvas.Brush.Color := SelectedBackColor;
    Canvas.Pen.Color := ActiveFrameColor;
    Canvas.Rectangle(ARect);

    Highlight := LazMixColor(SelectedBackColor, clWhite, 55);
    Canvas.Pen.Color := Highlight;
    Canvas.Line(ARect.Left + 1, ARect.Top + 1, ARect.Right - 2, ARect.Top + 1);

    if FNavigationStyle = bnsOffice then
    begin
      Accent := ActiveFrameColor;
      if LazIsDarkColor(Accent) then
        Accent := LazLighter(Accent, 38)
      else
        Accent := LazDarker(Accent, 10);

      RR := Rect(ARect.Left, ARect.Top + 2, ARect.Left + 4, ARect.Bottom - 2);
      Canvas.Brush.Color := Accent;
      Canvas.Pen.Color := Accent;
      Canvas.FillRect(RR);

      Canvas.Brush.Color := BackColor;
      Canvas.Pen.Color := BackColor;
      Canvas.FillRect(Rect(FNavigationWidth - 2, ARect.Top + 2, FNavigationWidth, ARect.Bottom - 2));

      TipY := (ARect.Top + ARect.Bottom) div 2;
      Canvas.Brush.Color := SelectedBackColor;
      Canvas.Pen.Color := LazMixColor(ActiveFrameColor, BackColor, 36);
      Canvas.Polygon([Point(FNavigationWidth - 1, ARect.Top + 7),
        Point(FNavigationWidth + 8, TipY), Point(FNavigationWidth - 1, ARect.Bottom - 7)]);
    end;
  end;

  function CurrentCaption: String;
  begin
    if Btn <> nil then
      Result := Btn.EffectiveCaption
    else if Page <> nil then
      Result := Page.EffectiveCaption
    else
      Result := '';
  end;

  function SamplePaintedNavColor(const ARect: TRect; AFallback: TColor): TColor;
  var
    X, Y: Integer;
  begin
    Result := ColorToRGB(AFallback);
    if (ARect.Right <= ARect.Left) or (ARect.Bottom <= ARect.Top) then Exit;
    if (ClientWidth <= 0) or (ClientHeight <= 0) then Exit;

    X := (ARect.Left + ARect.Right) div 2;
    Y := (ARect.Top + ARect.Bottom) div 2;

    if X < 0 then X := 0;
    if Y < 0 then Y := 0;
    if X >= ClientWidth then X := ClientWidth - 1;
    if Y >= ClientHeight then Y := ClientHeight - 1;

    { The real painted surface is the only reliable basis for caption contrast.
      Several skins and linked toolbar appearances produce selected colors that
      are transformed by DrawNavFill before the caption is drawn.  Sampling the
      already-painted rectangle avoids white-on-white and black-on-dark cases. }
    try
      Result := ColorToRGB(Canvas.Pixels[X, Y]);
    except
      Result := ColorToRGB(AFallback);
    end;
  end;

begin
  inherited Paint;
  GetColors(BackColor, NavColor, ActiveColor, HotColor, FrameColor, TextColor, MutedTextColor);

  A := GetLinkedAppearance;

  IdleCaptionColor := TextColor;
  HotCaptionColor := TextColor;
  if LazIsDarkColor(ActiveColor) then
    ActiveCaptionColor := clWhite
  else
    ActiveCaptionColor := TextColor;

  ActiveFrameColor := FrameColor;
  ActiveNavIndex := GetActiveNavIndex;
  ActivePaintPage := nil;
  if (FActivePageIndex >= 0) and (FActivePageIndex < PageCount) then
    ActivePaintPage := GetPage(FActivePageIndex);
  SelectedBackColor := ResolveSelectedBackColor;
  ActiveFrameColor := ResolveSelectedFrameColor(SelectedBackColor);
  SelectedCaptionColor := ResolveSelectedTextColor(SelectedBackColor);
  HoverBackColor := ResolveHoverBackColor(SelectedBackColor);
  HoverFrameColor := ResolveHoverFrameColor(HoverBackColor);

  Canvas.Brush.Color := BackColor;
  Canvas.FillRect(ClientRect);

  R := Rect(0, 0, FNavigationWidth, ClientHeight);
  LazFillRectByKind(Canvas, R, NavColor,
    LazMixColor(NavColor, BackColor, 18), bkVerticalGradient);

  Canvas.Pen.Color := FrameColor;
  Canvas.Line(FNavigationWidth - 1, 0, FNavigationWidth - 1, ClientHeight);

  if FBackButtonVisible then
  begin
    CloseR := GetCloseButtonRect;
    DrawBackButton(Canvas, CloseR, NavColor, FrameColor, TextColor,
      FHoverPageIndex = -2, FPressedPageIndex = -2);
  end;

  if FTitle <> '' then
  begin
    if A <> nil then
      Canvas.Font.Assign(A.MenuButton.CaptionFont)
    else
      Canvas.Font.Assign(Font);
    if Canvas.Font.Size = 0 then
      Canvas.Font.Size := Font.Size;
    Canvas.Font.Size := Canvas.Font.Size + 5;
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    if A <> nil then
      Canvas.Font.Color := IdleCaptionColor
    else
      Canvas.Font.Color := TextColor;
    Canvas.Brush.Style := bsClear;
    if FBackButtonVisible then
      Canvas.TextOut(GetCloseButtonRect.Right + 10, 17, FTitle)
    else
      Canvas.TextOut(18, 17, FTitle);
    Canvas.Brush.Style := bsSolid;
  end;

  for I := 0 to GetNavItemCount - 1 do
  begin
    R := GetNavItemRect(I);
    Page := nil;
    Btn := GetNavButton(I);
    if Btn <> nil then
    begin
      if not Btn.EffectiveVisible then
        Continue;
      if Btn.Page <> nil then
        Page := Btn.Page;
    end
    else
      Page := Pages[I];

    if (GetNavButton(I) = nil) and (Page <> nil) and not Page.EffectiveVisible then
      Continue;

    if ((Btn <> nil) and (LazRibbonBackstageButtonEffectiveKind(Btn) = bbkSeparator)) or
       ((Btn = nil) and (Page <> nil) and (Page.ItemKind = bpkSeparator)) then
    begin
      SepR := R;
      SepR.Left := SepR.Left + 18;
      SepR.Right := SepR.Right - 18;
      MidY := (SepR.Top + SepR.Bottom) div 2;
      Canvas.Pen.Color := LazMixColor(FrameColor, NavColor, 30);
      Canvas.Line(SepR.Left, MidY, SepR.Right, MidY);
      Continue;
    end;

    if (Btn <> nil) and (Btn.Section = bbsBottom) then
    begin
      FirstBottom := True;
      for J := 0 to I - 1 do
        if (GetNavButton(J) <> nil) and (GetNavButton(J).Section = bbsBottom) and GetNavButton(J).EffectiveVisible then
        begin
          FirstBottom := False;
          Break;
        end;
      if FirstBottom then
      begin
        Canvas.Pen.Color := LazMixColor(FrameColor, NavColor, 35);
        Canvas.Line(18, R.Top - 8, FNavigationWidth - 18, R.Top - 8);
      end;
    end;

    IsBeginGroup := (Btn <> nil) and Btn.BeginGroup;
    if IsBeginGroup and (R.Top > GetEffectiveHeaderHeight + 1) then
    begin
      Canvas.Pen.Color := LazMixColor(FrameColor, NavColor, 35);
      Canvas.Line(18, R.Top - 1, FNavigationWidth - 18, R.Top - 1);
    end;

    IsPageItem := ((Btn <> nil) and (LazRibbonBackstageButtonEffectiveKind(Btn) = bbkPage)) or
      ((Btn = nil) and (Page <> nil) and (Page.ItemKind = bpkPage));
    IsCommandItem := ((Btn <> nil) and (LazRibbonBackstageButtonEffectiveKind(Btn) = bbkCommand)) or
      ((Btn = nil) and (Page <> nil) and (Page.ItemKind = bpkCommand));

    { Determine the active page item by page identity, not only by the cached
      navigation index. With explicit Buttons + Page references, the same page
      can be represented by different collections; relying only on I =
      ActiveNavIndex made "Novo" and "Recentes" pass through different visual
      paths in some skins. }
    IsActive := IsPageItem and
      ((I = ActiveNavIndex) or
       ((ActivePaintPage <> nil) and (Page = ActivePaintPage)));

    IsHot := (I = FHoverPageIndex) and not IsActive;
    IsPressed := (I = FPressedPageIndex) and not IsActive;
    IsFixedPageItem := IsPageItem and (FPageButtonVisualMode = bpvmFixedHeader);
    VisualActive := IsActive and not IsFixedPageItem;
    VisualHot := IsHot and not IsFixedPageItem;
    VisualPressed := IsPressed and not IsFixedPageItem;
    IsEnabled := True;
    if Btn <> nil then
      IsEnabled := Btn.EffectiveEnabled
    else if Page <> nil then
      IsEnabled := Page.EffectiveEnabled;

    if IsPageItem then
      CR := Rect(R.Left + 8, R.Top + 3, R.Right - 4, R.Bottom - 3)
    else
      CR := Rect(R.Left + 2, R.Top + 1, R.Right - 3, R.Bottom - 1);

    if IsBeginGroup then
      Inc(CR.Top, 2);

    if IsFixedPageItem then
    begin
      { DevExpress/Office BackStage treats page entries such as "Recentes"
        as stable content anchors, not as hover/selection buttons.  Draw a
        fixed surface and keep it independent from the current mouse item. }
      Canvas.Brush.Color := NavColor;
      Canvas.Pen.Color := LazMixColor(FrameColor, NavColor, 28);
      Canvas.Rectangle(CR);
    end
    else if VisualActive then
    begin
      { The active page stays selected even while the mouse is over another
        item.  Paint it with the isolated selected-page routine so hover never
        changes its surface. }
      if IsPageItem then
        DrawStableSelectedPage(CR)
      else
        DrawNavFill(CR, SelectedBackColor, ActiveFrameColor, True, False, False, IsPageItem);
    end
    else if VisualHot then
    begin
      { Non-selected page entries must use the same hover grammar as command
        entries.  Earlier versions drew page hover with the selected-page
        rectangle/pointer grammar, while commands such as Abrir used the
        lighter Office-like hover strip.  That made the hover result depend on
        which page was active.  Selection is the only state that may use the
        page rectangle/pointer; hover is transient and therefore uniform. }
      if IsPageItem then
      begin
        PaintR := Rect(R.Left + 2, R.Top + 1, R.Right - 3, R.Bottom - 1);
        if IsBeginGroup then
          Inc(PaintR.Top, 2);
        DrawNavFill(PaintR, HoverBackColor, HoverFrameColor, False, True, VisualPressed, False);
      end
      else
        DrawNavFill(CR, HoverBackColor, HoverFrameColor, False, True, VisualPressed, False);
    end
    else if VisualPressed then
    begin
      if IsPageItem then
      begin
        PaintR := Rect(R.Left + 2, R.Top + 1, R.Right - 3, R.Bottom - 1);
        if IsBeginGroup then
          Inc(PaintR.Top, 2);
        DrawNavFill(PaintR, HoverBackColor, HoverFrameColor, False, False, True, False);
      end
      else
        DrawNavFill(CR, HoverBackColor, HoverFrameColor, False, False, True, False);
    end
    else
      DrawNavFill(CR, NavColor, FrameColor, False, False, False, IsPageItem);

    S := CurrentCaption;

    IconList := FImages;
    if Btn <> nil then
    begin
      if LazRibbonBackstageButtonEffectiveKind(Btn) = bbkPage then
      begin
        IconIndex := Btn.EffectiveLargeImageIndex;
        if (FLargeImages <> nil) and (IconIndex >= 0) and (IconIndex < FLargeImages.Count) then
          IconList := FLargeImages
        else
        begin
          IconIndex := Btn.EffectiveImageIndex;
          IconList := FImages;
        end;
      end
      else
        IconIndex := Btn.EffectiveImageIndex;
    end
    else if (Page <> nil) and (Page.Action is TAction) then
      IconIndex := TAction(Page.Action).ImageIndex
    else if Page <> nil then
      IconIndex := Page.EffectiveImageIndex
    else
      IconIndex := -1;

    if A <> nil then
      Canvas.Font.Assign(A.Tab.TabHeaderFont)
    else
      Canvas.Font.Assign(Font);
    if Canvas.Font.Size = 0 then
      Canvas.Font.Size := Font.Size;

    if IsPageItem and IsActive and not IsFixedPageItem then
      Canvas.Font.Style := Canvas.Font.Style + [fsBold]
    else if IsCommandItem or IsFixedPageItem then
      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

    if IsFixedPageItem then
      CaptionBackColor := NavColor
    else if VisualActive then
      { Selected page entries use the stable surface resolved above. Do not
        resample/reinterpret the canvas here; hover invalidation must never
        change the active item caption color. }
      CaptionBackColor := SelectedBackColor
    else if VisualHot or VisualPressed then
      CaptionBackColor := HoverBackColor
    else
      CaptionBackColor := NavColor;

    if IsFixedPageItem then
    begin
      { Fixed page anchors use the navigation column as their real background.
        The caption is still protected by WCAG contrast, but it no longer
        participates in selected/hover color transitions. }
      if not IsEnabled then
        CaptionTextColor := LazReadableMutedTextColor(CaptionBackColor, TextColor)
      else
        CaptionTextColor := LazBackstageCaptionColorFor(CaptionBackColor, TextColor);
    end
    else if VisualActive then
    begin
      { Selected page captions must be calculated from the surface actually
        painted on the canvas, not from the nominal skin color.  Keep the skin
        selected text color as preference, but enforce WCAG contrast against
        CaptionBackColor. }
      if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
        CaptionTextColor := LazBackstageCaptionColorFor(CaptionBackColor,
          FSkinManager.Palette.BackstageNavSelectedTextColor)
      else
        CaptionTextColor := LazBackstageCaptionColorFor(CaptionBackColor,
          SelectedCaptionColor);
    end
    else if not IsEnabled then
      CaptionTextColor := LazReadableMutedTextColor(CaptionBackColor, TextColor)
    else if VisualHot then
    begin
      if (FAppearanceSource = asSkinManager) and (FSkinManager <> nil) then
        CaptionTextColor := LazBackstageCaptionColorFor(CaptionBackColor,
          FSkinManager.Palette.BackstageNavHoverTextColor)
      else
        CaptionTextColor := LazBackstageCaptionColorFor(CaptionBackColor, HotCaptionColor);
    end
    else
      CaptionTextColor := LazBackstageCaptionColorFor(CaptionBackColor, TextColor);

    Canvas.Font.Color := CaptionTextColor;

    if IsPageItem then
      CR := Rect(CR.Left + 16, CR.Top, CR.Right - 14, CR.Bottom)
    else
      CR := Rect(CR.Left + 22, CR.Top, CR.Right - 12, CR.Bottom);

    if (IconList <> nil) and (IconIndex >= 0) and (IconIndex < IconList.Count) then
    begin
      IconX := CR.Left;
      IconY := R.Top + (GetNavItemHeight(I) - IconList.Height) div 2;
      IconList.Draw(Canvas, IconX, IconY, IconIndex);
      Inc(CR.Left, IconList.Width + 9);
    end;

    { Some widgetsets/skin paths can reset the text color after drawing the
      item image.  Reapply it immediately before TextRect and also update the
      underlying canvas handle.  This fixes light skins where the active
      BackStage caption was painted almost white over a very light selection. }
    Canvas.Font.Color := CaptionTextColor;
    SetTextColor(Canvas.Handle, ColorToRGB(CaptionTextColor));
    Canvas.Brush.Style := bsClear;
    Canvas.TextRect(CR, CR.Left, CR.Top + (GetNavItemHeight(I) - Canvas.TextHeight(S)) div 2, S);
    Canvas.Brush.Style := bsSolid;
  end;

  if (PageCount = 0) and ((FButtons = nil) or (FButtons.Count = 0)) then
  begin
    R := GetContentRect;
    InflateRect(R, -24, -24);
    Canvas.Font.Assign(Font);
    Canvas.Font.Color := MutedTextColor;
    Canvas.Brush.Style := bsClear;
    Canvas.TextRect(R, R.Left, R.Top,
      'Adicione componentes TLazRibbonBackstagePage dentro deste BackStage.');
    Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TLazRibbonBackstageView.Resize;
begin
  inherited Resize;
  if Visible and FOverlayActive then
    ApplyOverlayBounds;
  UpdatePages;
end;

procedure TLazRibbonBackstageView.SetActivePageIndex(AValue: Integer);
var
  OldIndex, MaxIndex: Integer;
begin
  MaxIndex := PageCount - 1;
  if AValue > MaxIndex then AValue := MaxIndex;
  if AValue < -1 then AValue := -1;
  if (AValue >= 0) and not IsSelectablePage(AValue) then
    AValue := FirstSelectablePageIndex;
  if FActivePageIndex = AValue then Exit;
  OldIndex := FActivePageIndex;
  FActivePageIndex := AValue;
  UpdatePages;
  Invalidate;
  if Assigned(FOnPageChanged) then
    FOnPageChanged(Self, OldIndex, FActivePageIndex);
end;

procedure TLazRibbonBackstageView.SetAppearanceSource(AValue: TLazRibbonAppearanceSource);
begin
  if FAppearanceSource = AValue then Exit;
  FAppearanceSource := AValue;
  UpdatePages;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetBackstageTabCaption(const AValue: TCaption);
begin
  if FBackstageTabCaption = AValue then Exit;
  FBackstageTabCaption := AValue;
  if FLinkedToolbar <> nil then
    FLinkedToolbar.ApplicationButton.Caption := AValue;
end;

procedure TLazRibbonBackstageView.SetBackButtonHint(const AValue: String);
begin
  if FBackButtonHint = AValue then Exit;
  FBackButtonHint := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetBackButtonStyle(AValue: TLazRibbonBackstageBackButtonStyle);
begin
  if FBackButtonStyle = AValue then Exit;
  FBackButtonStyle := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetButtons(AValue: TLazRibbonBackstageButtons);
begin
  FButtons.Assign(AValue);
  UpdatePages;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetCloseButtonAreaHeight(AValue: Integer);
begin
  if AValue < 32 then AValue := 32;
  if FCloseButtonAreaHeight = AValue then Exit;
  FCloseButtonAreaHeight := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetCloseOnEscape(AValue: Boolean);
begin
  if FCloseOnEscape = AValue then Exit;
  FCloseOnEscape := AValue;
end;

procedure TLazRibbonBackstageView.SetCloseOnRibbonTabClick(AValue: Boolean);
begin
  if FCloseOnRibbonTabClick = AValue then Exit;
  FCloseOnRibbonTabClick := AValue;
end;

procedure TLazRibbonBackstageView.SetHeaderHeight(AValue: Integer);
begin
  if AValue < 0 then AValue := 0;
  if FHeaderHeight = AValue then Exit;
  FHeaderHeight := AValue;
  UpdatePages;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetImages(AValue: TCustomImageList);
begin
  if FImages = AValue then Exit;
  if FImages <> nil then
    FImages.RemoveFreeNotification(Self);
  FImages := AValue;
  if FImages <> nil then
    FImages.FreeNotification(Self);
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetLargeImages(AValue: TCustomImageList);
begin
  if FLargeImages = AValue then Exit;
  if FLargeImages <> nil then
    FLargeImages.RemoveFreeNotification(Self);
  FLargeImages := AValue;
  if FLargeImages <> nil then
    FLargeImages.FreeNotification(Self);
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetItemHeight(AValue: Integer);
begin
  if AValue < 24 then AValue := 24;
  if FItemHeight = AValue then Exit;
  FItemHeight := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetLinkedToolbar(AValue: TLazRibbon);
begin
  if FLinkedToolbar = AValue then Exit;
  UnhookToolbarEvents;
  if FLinkedToolbar <> nil then
    FLinkedToolbar.RemoveFreeNotification(Self);
  FLinkedToolbar := AValue;
  if FLinkedToolbar <> nil then
  begin
    FLinkedToolbar.FreeNotification(Self);
    FStyle := FLinkedToolbar.Style;
    HookToolbarEvents;
  end;
  Invalidate;
  UpdatePages;
end;


procedure TLazRibbonBackstageView.SetNavigationStyle(AValue: TLazRibbonBackstageNavigationStyle);
begin
  if FNavigationStyle = AValue then Exit;
  FNavigationStyle := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetPageButtonVisualMode(AValue: TLazRibbonBackstagePageButtonVisualMode);
begin
  if FPageButtonVisualMode = AValue then Exit;
  FPageButtonVisualMode := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetNavigationWidth(AValue: Integer);
begin
  if AValue < 96 then AValue := 96;
  if FNavigationWidth = AValue then Exit;
  FNavigationWidth := AValue;
  UpdatePages;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetOpenOnTabCaption(AValue: Boolean);
begin
  if FOpenOnTabCaption = AValue then Exit;
  FOpenOnTabCaption := AValue;
  HookToolbarEvents;
end;

procedure TLazRibbonBackstageView.SetOverlayMode(AValue: TLazRibbonBackstageOverlayMode);
begin
  if FOverlayMode = AValue then Exit;
  FOverlayMode := AValue;
  if Visible then
  begin
    if FOverlayMode = bomNone then
      RestoreOverlayBounds
    else
      ApplyOverlayBounds;
    UpdatePages;
    Invalidate;
  end;
end;

procedure TLazRibbonBackstageView.SetBackButtonVisible(AValue: Boolean);
begin
  if FBackButtonVisible = AValue then Exit;
  FBackButtonVisible := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetSkinManager(AValue: TLazRibbonSkinManager);
begin
  if FSkinManager = AValue then Exit;
  if FSkinManager <> nil then
    FSkinManager.RemoveFreeNotification(Self);
  FSkinManager := AValue;
  if FSkinManager <> nil then
  begin
    FSkinManager.FreeNotification(Self);
    FAppearanceSource := asSkinManager;
  end
  else if FAppearanceSource = asSkinManager then
    FAppearanceSource := asLinkedToolbar;
  UpdatePages;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetStyle(AValue: TLazRibbonStyle);
begin
  if FStyle = AValue then Exit;
  FStyle := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.SetTitle(const AValue: TCaption);
begin
  if FTitle = AValue then Exit;
  FTitle := AValue;
  Invalidate;
end;

procedure TLazRibbonBackstageView.ShowBackstage;
begin
  if FLinkedToolbar <> nil then
    FStyle := FLinkedToolbar.Style;

  if PageCount > 0 then
  begin
    if (FActivePageIndex < 0) or (FActivePageIndex >= PageCount) or
      not IsSelectablePage(FActivePageIndex) then
      FActivePageIndex := FirstSelectablePageIndex;
  end;

  ApplyOverlayBounds;
  Visible := True;
  BringToFront;
  BringParentClientChromeToFront;
  if CanFocus then
    SetFocus;
  UpdatePages;
  Invalidate;
end;

procedure TLazRibbonBackstageView.ToolbarMenuButtonClick(Sender: TObject);
begin
  { The BackStage hooks the Ribbon Application Button. When the same button is
    switched to PopupMenu or Event mode, the BackStage must not toggle itself. }
  if (FLinkedToolbar <> nil) and
     (FLinkedToolbar.ApplicationButton.Mode <> abmBackstage) then
  begin
    if Assigned(FOldToolbarMenuButtonClick) then
      FOldToolbarMenuButtonClick(Sender);
    Exit;
  end;

  { In BackStage mode the Application Button action is the BackStage toggle
    itself. Do not also fire a previous Application Button event, otherwise the
    same click can execute an unrelated command before opening the BackStage. }
  if Visible then
    HideBackstage
  else
    ShowBackstage;
end;

procedure TLazRibbonBackstageView.ToolbarTabChanging(Sender: TObject; OldIndex,
  NewIndex: integer; var Allowed: boolean);
var
  TabCaption: String;
begin
  if Assigned(FOldToolbarTabChanging) then
    FOldToolbarTabChanging(Sender, OldIndex, NewIndex, Allowed);

  if not Allowed then Exit;
  if FLinkedToolbar = nil then Exit;
  if (NewIndex < 0) or (NewIndex >= FLinkedToolbar.Tabs.Count) then Exit;

  TabCaption := FLinkedToolbar.Tabs[NewIndex].Caption;

  { Compatibility mode: older projects could expose a real tab named
    "Arquivo". Selecting that tab should toggle the BackStage instead of
    changing the selected Ribbon tab. }
  if FOpenOnTabCaption and SameText(TabCaption, FBackstageTabCaption) then
  begin
    Allowed := False;
    if Visible then
      HideBackstage
    else
      ShowBackstage;
    Exit;
  end;

  { Office-like behavior: once the BackStage is visible, selecting any other
    Ribbon tab must close it and then let the normal tab selection proceed.
    If OnClose cancels the closing, block the tab change to avoid leaving the
    UI in an inconsistent state. }
  if Visible and FCloseOnRibbonTabClick then
  begin
    HideBackstage;
    if Visible then
      Allowed := False;
  end;
end;

function TLazRibbonBackstageView.HandleRibbonTabClick(ATabIndex: Integer;
  const ATabCaption: String; AIsCurrentTab: Boolean): Boolean;
begin
  Result := True;

  { The OnTabChanging hook is not called when the user clicks the tab that is
    already selected.  This method is called directly by TLazRibbon for that
    case, so a visible BackStage still closes when the user clicks the current
    Ribbon tab, e.g. "Página Inicial". }
  if FOpenOnTabCaption and SameText(ATabCaption, FBackstageTabCaption) then
  begin
    Result := False;
    if Visible then
      HideBackstage
    else
      ShowBackstage;
    Exit;
  end;

  if AIsCurrentTab and Visible and FCloseOnRibbonTabClick then
  begin
    HideBackstage;
    if Visible then
      Result := False;
  end;
end;

procedure TLazRibbonBackstageView.HookToolbarEvents;
begin
  if FLinkedToolbar = nil then Exit;

  if not FToolbarEventsHooked then
  begin
    FOldToolbarMenuButtonClick := FLinkedToolbar.ApplicationButton.OnClick;
    FOldToolbarTabChanging := FLinkedToolbar.OnTabChanging;
    FToolbarEventsHooked := True;
  end;

  FLinkedToolbar.ApplicationButton.OnClick := ToolbarMenuButtonClick;
  if FOpenOnTabCaption then
    FLinkedToolbar.OnTabChanging := ToolbarTabChanging
  else
    FLinkedToolbar.OnTabChanging := FOldToolbarTabChanging;
end;

procedure TLazRibbonBackstageView.UnhookToolbarEvents;
begin
  if (FLinkedToolbar = nil) or not FToolbarEventsHooked then Exit;

  FLinkedToolbar.ApplicationButton.OnClick := FOldToolbarMenuButtonClick;
  FLinkedToolbar.OnTabChanging := FOldToolbarTabChanging;

  FOldToolbarMenuButtonClick := nil;
  FOldToolbarTabChanging := nil;
  FToolbarEventsHooked := False;
end;



procedure TLazRibbonBackstageView.UpdatePages;
var
  I: Integer;
  R: TRect;
  Page: TLazRibbonBackstagePage;
  NewVisible: Boolean;
  NewWidth, NewHeight: Integer;
begin
  if csDestroying in ComponentState then Exit;
  if csLoading in ComponentState then Exit;

  NormalizePageParents;
  R := GetContentRect;
  NewWidth := R.Right - R.Left;
  NewHeight := R.Bottom - R.Top;

  for I := 0 to PageCount - 1 do
  begin
    Page := Pages[I];
    if Page <> nil then
    begin
      { Avoid calling SetBounds/Visible/BringToFront unconditionally.  On LCL
        this can invalidate the preferred size repeatedly during the layout
        pass and raise TLayoutException: InvalidatedPreferredSize loop. }
      if (Page.Left <> R.Left) or (Page.Top <> R.Top) or
         (Page.Width <> NewWidth) or (Page.Height <> NewHeight) then
        Page.SetBounds(R.Left, R.Top, NewWidth, NewHeight);

      NewVisible := (I = FActivePageIndex) and (Page.ItemKind = bpkPage) and Page.EffectiveVisible;
      if Page.Visible <> NewVisible then
        Page.Visible := NewVisible;

      if NewVisible then
        Page.Invalidate;
      { Do not call BringToFront here. It changes the internal child order,
        and PageCount/Pages[] are based on that order. Since only the active
        page is visible, z-order changes are unnecessary and harmful. }
    end;
  end;
end;

end.
