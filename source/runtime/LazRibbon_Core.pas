unit LazRibbon_Core;

{$mode delphi}
{$codepage utf8}

{.$DEFINE EnhancedRecordSupport}
{.$DEFINE DELAYRUNTIMER}

//Translation from Polish into English by Raf20076, Poland, 2016
//I do my best but if you find any mistakes in English comments
//please correct it.

(*******************************************************************************
*                                                                              *
*  File: LazRibbon_Core.pas                                                        *
*  Description: Main toolbar component                                         *
*  Copyright: (c) 2009 by Spook.                                               *
*  License:   Modified LGPL (with linking exception, like Lazarus LCL)         *
*             See "license.txt" in this installation                           *
*                                                                              *
*  Lazarus port and contributions: Luiz Américo, Werner Pamler, Husker         *
*                                                                              *
*******************************************************************************)

interface

uses
  {$IFDEF LCLCocoa}
  CocoaGDIObjects, MacOSAll,
  {$ENDIF}
  LCLType, LMessages, LCLVersion, Graphics, SysUtils, Controls, Classes, Math,
  Dialogs, Forms, Types, ExtCtrls, Menus, ImgList, ActnList, IniFiles,
  LazRibbon_GraphTools, LazRibbon_GUITools, LazRibbon_Math, LazRibbon_Appearance, LazRibbon_BaseItem, LazRibbon_Const,
  LazRibbon_Dispatch, LazRibbon_Tabs, LazRibbon_Groups, LazRibbon_Types, LazRibbon_SkinManager,
  LazRibbon_BackstageBase;

type
  { Type describes regions of the toolbar which are used during handling
    of interaction with the mouse }
  TLazRibbonMouseToolbarElement = (teNone, teToolbarArea, teTabs, teTabContents, teMenuButton, teQuickAccessToolBar, teCollapseButton, teHelpButton);

  TLazRibbonTabChangingEvent = procedure(Sender: TObject; OldIndex, NewIndex: integer;
    var Allowed: boolean) of object;

  { Type describes Menu Button style }
  TLazRibbonMenuButtonStyle = (mbsCaption, mbsCaptionDropdown);

  { Defines how the Office-like Application Button behaves when clicked.
    abmEvent keeps the legacy event-driven behavior.
    abmPopupMenu shows ApplicationMenu/MenuButtonDropdownMenu.
    abmBackstage delegates the click to the linked BackstageView. }
  TLazRibbonApplicationButtonMode = (abmEvent, abmPopupMenu, abmBackstage);

  { Internal state of the Office-like KeyTips overlay. TopLevel shows the
    Application Button, tabs and QAT. ActiveTabCommands shows only commands
    from the currently selected tab, matching the staged Office behavior. }
  TLazRibbonKeyTipsStage = (rktsTopLevel, rktsActiveTabCommands);

  { Type describes Menu Button states }
  TLazRibbonMenuButtonState = (mbtIdle, mbtHottrack, mbtPressed);

const
  LAZRIBBON_DEFAULT_TAB_CAPTION_HORIZONTAL_PADDING = TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING;
  LAZRIBBON_DEFAULT_TAB_CAPTION_SPACING = TOOLBAR_TAB_CAPTIONS_HSPACING;
  LAZRIBBON_DEFAULT_MIN_TAB_CAPTION_WIDTH = TOOLBAR_MIN_TAB_CAPTION_WIDTH;

type
  TLazRibbon = class;

  { Persistent subobject that exposes the Office-like Application Button in the
    Object Inspector.  It deliberately delegates the operational properties to
    TLazRibbon so the older MenuButton*/ApplicationButton* properties keep
    working with existing projects. }
  TLazRibbonApplicationButton = class(TPersistent)
  private
    FOwner: TLazRibbon;
    FGlyph: TPicture;
    FImageIndex: Integer;
    FHint: String;
    FKeyTip: String;
    FShowScreenTip: Boolean;
    FScreenTipTitle: String;
    FScreenTipText: String;
    FScreenTipShortcut: String;
    FScreenTipFooter: String;
    procedure GlyphChanged(Sender: TObject);
    function GetCaption: String;
    function GetVisible: Boolean;
    function GetMode: TLazRibbonApplicationButtonMode;
    function GetMenu: TPopupMenu;
    function GetBackstageView: TLazRibbonCustomBackstageView;
    function GetOnClick: TNotifyEvent;
    procedure SetCaption(const AValue: String);
    procedure SetVisible(AValue: Boolean);
    procedure SetMode(AValue: TLazRibbonApplicationButtonMode);
    procedure SetMenu(AValue: TPopupMenu);
    procedure SetBackstageView(AValue: TLazRibbonCustomBackstageView);
    procedure SetOnClick(AValue: TNotifyEvent);
    procedure SetGlyph(AValue: TPicture);
    procedure SetImageIndex(AValue: Integer);
    procedure SetHint(const AValue: String);
    procedure SetKeyTip(const AValue: String);
    procedure SetShowScreenTip(AValue: Boolean);
    procedure SetScreenTipTitle(const AValue: String);
    procedure SetScreenTipText(const AValue: String);
    procedure SetScreenTipShortcut(const AValue: String);
    procedure SetScreenTipFooter(const AValue: String);
    procedure Changed;
  public
    constructor Create(AOwner: TLazRibbon); reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function EffectiveHint: String;
  published
    property Caption: String read GetCaption write SetCaption;
    property Visible: Boolean read GetVisible write SetVisible default False;
    property Mode: TLazRibbonApplicationButtonMode read GetMode write SetMode default abmEvent;
    property BackstageView: TLazRibbonCustomBackstageView read GetBackstageView write SetBackstageView;
    property Menu: TPopupMenu read GetMenu write SetMenu;
    property Glyph: TPicture read FGlyph write SetGlyph;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property Hint: String read FHint write SetHint;
    property KeyTip: String read FKeyTip write SetKeyTip;
    property ShowScreenTip: Boolean read FShowScreenTip write SetShowScreenTip default True;
    property ScreenTipTitle: String read FScreenTipTitle write SetScreenTipTitle;
    property ScreenTipText: String read FScreenTipText write SetScreenTipText;
    property ScreenTipShortcut: String read FScreenTipShortcut write SetScreenTipShortcut;
    property ScreenTipFooter: String read FScreenTipFooter write SetScreenTipFooter;
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;


  { Defines where the Quick Access Toolbar is drawn. The first implementation
    uses the Office-like position before the Ribbon tabs; more positions can be
    added later without changing the object model. }
  TLazRibbonQuickAccessPosition = (qapBeforeTabs, qapBelowRibbon, qapTitleBar);

  { Controls how the Quick Access Toolbar draws the face of its small
    command buttons. qfsHotOnly is closer to Office: idle buttons remain
    flat and only show a frame/background on hover or pressed. }
  TLazRibbonQuickAccessButtonFrameStyle = (qfsHotOnly, qfsAlways);

  { Controls what is drawn when a Quick Access item has no ImageIndex/ImageList.
    qfgOfficeGlyphs keeps the QAT icon-oriented by drawing small vector glyphs
    from the command caption/action; qfgCaptionInitial preserves the older
    letter fallback; qfgNone leaves the button empty. }
  TLazRibbonQuickAccessFallbackGlyphStyle = (qfgOfficeGlyphs, qfgCaptionInitial, qfgNone);

  TLazRibbonQuickAccessToolBar = class;

  { Item shown in the Quick Access Toolbar. It can be configured manually or it
    can delegate to an Action/LinkedItem, mirroring the BackStage command model. }
  TLazRibbonQuickAccessItem = class(TCollectionItem)
  private
    FAction: TBasicAction;
    FCaption: TCaption;
    FEnabled: Boolean;
    FHint: String;
    FKeyTip: String;
    FImageIndex: Integer;
    FLinkedItem: TLazRibbonBaseItem;
    FVisible: Boolean;
    FShowScreenTip: Boolean;
    FScreenTipTitle: String;
    FScreenTipText: String;
    FScreenTipShortcut: String;
    FScreenTipFooter: String;
    function OwnerRibbon: TLazRibbon;
    procedure SetAction(AValue: TBasicAction);
    procedure SetCaption(const AValue: TCaption);
    procedure SetEnabled(AValue: Boolean);
    procedure SetHint(const AValue: String);
    procedure SetKeyTip(const AValue: String);
    procedure SetImageIndex(AValue: Integer);
    procedure SetLinkedItem(AValue: TLazRibbonBaseItem);
    procedure SetVisible(AValue: Boolean);
    procedure SetShowScreenTip(AValue: Boolean);
    procedure SetScreenTipTitle(const AValue: String);
    procedure SetScreenTipText(const AValue: String);
    procedure SetScreenTipShortcut(const AValue: String);
    procedure SetScreenTipFooter(const AValue: String);
  protected
    function GetDisplayName: string; override;
    procedure Changed;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function EffectiveCaption: TCaption;
    function EffectiveEnabled: Boolean;
    function EffectiveHint: String;
    function EffectiveImageIndex: Integer;
    function EffectiveVisible: Boolean;
    function HasLinkedDropDown: Boolean;
    function EffectiveDropDownMenu: TPopupMenu;
    procedure Execute;
    procedure ExecuteAt(const AScreenPoint: TPoint);
  published
    property Caption: TCaption read FCaption write SetCaption;
    property Action: TBasicAction read FAction write SetAction;
    property LinkedItem: TLazRibbonBaseItem read FLinkedItem write SetLinkedItem;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Hint: String read FHint write SetHint;
    property KeyTip: String read FKeyTip write SetKeyTip;
    property ShowScreenTip: Boolean read FShowScreenTip write SetShowScreenTip default True;
    property ScreenTipTitle: String read FScreenTipTitle write SetScreenTipTitle;
    property ScreenTipText: String read FScreenTipText write SetScreenTipText;
    property ScreenTipShortcut: String read FScreenTipShortcut write SetScreenTipShortcut;
    property ScreenTipFooter: String read FScreenTipFooter write SetScreenTipFooter;
  end;

  TLazRibbonQuickAccessItems = class(TOwnedCollection)
  private
    FOwnerToolBar: TLazRibbonQuickAccessToolBar;
    function GetItem(Index: Integer): TLazRibbonQuickAccessItem;
    procedure SetItem(Index: Integer; AValue: TLazRibbonQuickAccessItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent); reintroduce;
    function Add: TLazRibbonQuickAccessItem;
    function AddAction(AAction: TBasicAction): TLazRibbonQuickAccessItem;
    function AddLinkedItem(AItem: TLazRibbonBaseItem): TLazRibbonQuickAccessItem;
    property OwnerToolBar: TLazRibbonQuickAccessToolBar read FOwnerToolBar;
    property Items[Index: Integer]: TLazRibbonQuickAccessItem read GetItem write SetItem; default;
  end;

  TLazRibbonQuickAccessToolBar = class(TPersistent)
  private
    FItems: TLazRibbonQuickAccessItems;
    FOwner: TLazRibbon;
    FPosition: TLazRibbonQuickAccessPosition;
    FShowCustomizeButton: Boolean;
    FVisible: Boolean;
    FButtonFrameStyle: TLazRibbonQuickAccessButtonFrameStyle;
    FButtonSize: Integer;
    FSpacing: Integer;
    FFallbackGlyphStyle: TLazRibbonQuickAccessFallbackGlyphStyle;
    FCustomizeActionList: TCustomActionList;
    FCustomizeMenuTitle: String;
    FMoreCommandsCaption: String;
    FStorageSection: String;
    FShowMoreCommandsItem: Boolean;
    FShowPositionMenuItem: Boolean;
    FShowMinimizeRibbonMenuItem: Boolean;
    FShowResetToDefaultsItem: Boolean;
    FAllowCustomizing: Boolean;
    FAllowQuickCustomizing: Boolean;
    FAllowReset: Boolean;
    FAllowPositionChange: Boolean;
    FAllowMinimizeRibbon: Boolean;
    FImages: TCustomImageList;
    FShowAboveRibbonCaption: String;
    FShowBelowRibbonCaption: String;
    FMinimizeRibbonCaption: String;
    FRestoreRibbonCaption: String;
    FResetToDefaultsCaption: String;
    FDefaultItems: TStringList;
    FDefaultItemsCaptured: Boolean;
    FOnCustomizeClick: TNotifyEvent;
    FOnMoreCommandsClick: TNotifyEvent;
    procedure Changed;
    procedure SetButtonFrameStyle(AValue: TLazRibbonQuickAccessButtonFrameStyle);
    procedure SetCustomizeActionList(AValue: TCustomActionList);
    procedure SetCustomizeMenuTitle(const AValue: String);
    procedure SetMoreCommandsCaption(const AValue: String);
    procedure SetStorageSection(const AValue: String);
    procedure SetShowMoreCommandsItem(AValue: Boolean);
    procedure SetShowPositionMenuItem(AValue: Boolean);
    procedure SetShowMinimizeRibbonMenuItem(AValue: Boolean);
    procedure SetShowResetToDefaultsItem(AValue: Boolean);
    procedure SetAllowCustomizing(AValue: Boolean);
    procedure SetAllowQuickCustomizing(AValue: Boolean);
    procedure SetAllowReset(AValue: Boolean);
    procedure SetAllowPositionChange(AValue: Boolean);
    procedure SetAllowMinimizeRibbon(AValue: Boolean);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetShowAboveRibbonCaption(const AValue: String);
    procedure SetShowBelowRibbonCaption(const AValue: String);
    procedure SetMinimizeRibbonCaption(const AValue: String);
    procedure SetRestoreRibbonCaption(const AValue: String);
    procedure SetResetToDefaultsCaption(const AValue: String);
    procedure SetButtonSize(AValue: Integer);
    procedure SetFallbackGlyphStyle(AValue: TLazRibbonQuickAccessFallbackGlyphStyle);
    procedure SetItems(AValue: TLazRibbonQuickAccessItems);
    procedure SetPosition(AValue: TLazRibbonQuickAccessPosition);
    procedure SetShowCustomizeButton(AValue: Boolean);
    procedure SetSpacing(AValue: Integer);
    procedure SetVisible(AValue: Boolean);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TLazRibbon); reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure ClearReferencesToComponent(AComponent: TComponent);
    function AddAction(AAction: TBasicAction): TLazRibbonQuickAccessItem;
    function ContainsAction(AAction: TBasicAction): Boolean;
    function FindItemByAction(AAction: TBasicAction): TLazRibbonQuickAccessItem;
    procedure RemoveAction(AAction: TBasicAction);
    procedure ToggleAction(AAction: TBasicAction);
    procedure CaptureDefaultItems;
    function ResetToDefaultItems(AActionList: TCustomActionList = nil): Boolean;
    procedure SaveToIniFile(const AFileName: String; const ASection: String = '');
    function LoadFromIniFile(const AFileName: String; AActionList: TCustomActionList; const ASection: String = ''): Boolean;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property Position: TLazRibbonQuickAccessPosition read FPosition write SetPosition default qapBeforeTabs;
    property Items: TLazRibbonQuickAccessItems read FItems write SetItems;
    property ButtonFrameStyle: TLazRibbonQuickAccessButtonFrameStyle read FButtonFrameStyle write SetButtonFrameStyle default qfsHotOnly;
    property ButtonSize: Integer read FButtonSize write SetButtonSize default 0;
    property Spacing: Integer read FSpacing write SetSpacing default 2;
    property FallbackGlyphStyle: TLazRibbonQuickAccessFallbackGlyphStyle read FFallbackGlyphStyle write SetFallbackGlyphStyle default qfgOfficeGlyphs;
    property CustomizeActionList: TCustomActionList read FCustomizeActionList write SetCustomizeActionList;
    property CustomizeMenuTitle: String read FCustomizeMenuTitle write SetCustomizeMenuTitle;
    property MoreCommandsCaption: String read FMoreCommandsCaption write SetMoreCommandsCaption;
    property StorageSection: String read FStorageSection write SetStorageSection;
    property ShowCustomizeButton: Boolean read FShowCustomizeButton write SetShowCustomizeButton default True;
    property ShowMoreCommandsItem: Boolean read FShowMoreCommandsItem write SetShowMoreCommandsItem default False;
    property ShowPositionMenuItem: Boolean read FShowPositionMenuItem write SetShowPositionMenuItem default False;
    property ShowMinimizeRibbonMenuItem: Boolean read FShowMinimizeRibbonMenuItem write SetShowMinimizeRibbonMenuItem default False;
    property ShowResetToDefaultsItem: Boolean read FShowResetToDefaultsItem write SetShowResetToDefaultsItem default True;
    property AllowCustomizing: Boolean read FAllowCustomizing write SetAllowCustomizing default True;
    property AllowQuickCustomizing: Boolean read FAllowQuickCustomizing write SetAllowQuickCustomizing default True;
    property AllowReset: Boolean read FAllowReset write SetAllowReset default True;
    property AllowPositionChange: Boolean read FAllowPositionChange write SetAllowPositionChange default False;
    property AllowMinimizeRibbon: Boolean read FAllowMinimizeRibbon write SetAllowMinimizeRibbon default False;
    property Images: TCustomImageList read FImages write SetImages;
    property ShowAboveRibbonCaption: String read FShowAboveRibbonCaption write SetShowAboveRibbonCaption;
    property ShowBelowRibbonCaption: String read FShowBelowRibbonCaption write SetShowBelowRibbonCaption;
    property MinimizeRibbonCaption: String read FMinimizeRibbonCaption write SetMinimizeRibbonCaption;
    property RestoreRibbonCaption: String read FRestoreRibbonCaption write SetRestoreRibbonCaption;
    property ResetToDefaultsCaption: String read FResetToDefaultsCaption write SetResetToDefaultsCaption;
    property OnCustomizeClick: TNotifyEvent read FOnCustomizeClick write FOnCustomizeClick;
    property OnMoreCommandsClick: TNotifyEvent read FOnMoreCommandsClick write FOnMoreCommandsClick;
  end;

  { TLazRibbonToolbarSkinProvider

    Small adapter introduced in the 1.1 line to isolate SkinManager access
    behind an interface.  It intentionally does not own the toolbar. }
  TLazRibbonToolbarSkinProvider = class(TInterfacedObject, ILazRibbonSkinProvider)
  private
    FToolbar: TLazRibbon;
  public
    constructor Create(AToolbar: TLazRibbon);
    procedure ClearToolbar;
    function GetSkinManagerObject: TObject;
  end;

  { Dispatcher class which is used for safe accepting of information
    and requests from sub-elements. }

  TLazRibbonToolbarDispatch = class(TLazRibbonBaseToolbarDispatch)
  private
    { Toolbar component which is accepting information and
      requests from sub-elements }
    FToolbar: TLazRibbon;
    FSkinProviderAdapter: TLazRibbonToolbarSkinProvider;
    FSkinProvider: ILazRibbonSkinProvider;
  protected

  public
    // *******************
    // *** Constructor ***
    // *******************

    //Constructor
    constructor Create(AToolbar: TLazRibbon);

    //Destructor
    destructor Destroy; override;

    // ******************************************************************
    // *** Implementation of abstract methods TLazRibbonBaseToolbarDispatch ***
    // ******************************************************************

    { Method (NotifyAppearanceChanged) called when a content of the
      object of the appearance changes
      The object of the appearance contains colours and fonts used
      to draw the toolbar }
    procedure NotifyAppearanceChanged; override;

    { Method (NotifyItemsChanged) called when list of the sub-elements
      of one of toolbar elements changes }
    procedure NotifyItemsChanged; override;

    { Method (NotifyMetricsChanged) called when the size and position (metric)
      of one of toolbar elements change }
    procedure NotifyMetricsChanged; override;

    { Method (NotifyVisualsChanged) called when the appearance of one of
      toolbar elements changes
      if the toolbar element however doesn't need rebuilding of metrics }
    procedure NotifyVisualsChanged; override;

    { Method (GetTempBitmap) requests for suppporting bitmap delivered by toolbar
      For example, used to calculate the size of rendered text }
    function GetTempBitmap: TBitmap; override;

    { Method (ClientToScreen) converts the toolbar coordinates to screen coordinates
      For example, used to unfold popup menu }
    function ClientToScreen(Point: T2DIntPoint): T2DIntPoint; override;

    { Provides the toolbar SkinManager to internal Ribbon items without forcing
      those units to use LazRibbon_Core and create circular unit references. }
    function GetSkinProvider: ILazRibbonSkinProvider; override;
    function GetSkinManagerObject: TObject; override;
  end;

  //Extended toolbar inspired by Microsoft Fluent UI

  { TLazRibbon }

  TLazRibbon = class(TCustomControl)
  private

    { Instance of dispatcher object
      Dispatcher is transfered to toolbar elements }
    FToolbarDispatch: TLazRibbonToolbarDispatch;

    { Buffer bitmap to which toolbar is drawn }
    FBuffer: TBitmap;

    { Supporting bitmap is sent when toolbar elements request it }
    FTemporary: TBitmap;
   {$IFDEF DELAYRUNTIMER}
    FDelayRunTimer: TTimer;
   {$ENDIF}

    { Array of Rects of "handles" of tabs }
    FTabRects: array of T2DIntRect;

    { Cliprect region of "handles" of tabs }
    FTabClipRect: T2DIntRect;

    { ClipRect of region content of tab }
    FTabContentsClipRect: T2DIntRect;

    { Rect of the Menu Button }
    FMenuButtonRect: T2DIntRect;

    { The element over which the mouse pointer is }
    FMouseHoverElement: TLazRibbonMouseToolbarElement;

    { The element over which the mouse pointer is and in which a mouse
      button is pressed }
    FMouseActiveElement: TLazRibbonMouseToolbarElement;

    { The mouse pointer is now on the "handle" of tab }
    FTabHover: integer;

    { Flag which informs about validity of metrics of toolbar and its elements }
    FMetricsValid: boolean;

    { Flag which informs about validity of buffer content }
    FBufferValid: boolean;

    { Flag FInternalUpdating allows to block the validation of metrics and buffer
      when component is rebuilding its content
      The flag is switched on and off internally by component }
    FInternalUpdating: boolean;

    { Flag FUpdating allows to block the validation of metrics and buffer
      when user is rebuilding content of the component.
      FUpdating is controlled by user }
    FUpdating: boolean;

    { Quick selection of different appearances }
    FStyle: TLazRibbonStyle;

    { Optional skin integration }
    FAppearanceSource: TLazRibbonAppearanceSource;
    FSkinManager: TLazRibbonSkinManager;
    FLastSkinPalette: TLazRibbonSkinPalette;
    FLastSkinApplied: Boolean;

    FOnTabChanging: TLazRibbonTabChangingEvent;
    FOnTabChanged: TNotifyEvent;

    { Office-like Application Button subobject shown in the Object Inspector }
    FApplicationButton: TLazRibbonApplicationButton;

    { Office-like Quick Access Toolbar subobject shown in the Object Inspector }
    FQuickAccessToolBar: TLazRibbonQuickAccessToolBar;
    FQuickAccessRects: array of TRect;
    FQuickAccessCustomizeRect: TRect;
    FQuickAccessCustomizePopup: TPopupMenu;
    FQuickAccessHoverIndex: Integer;
    FQuickAccessActiveIndex: Integer;

    { Lightweight Office-like KeyTips overlay. }
    FShowKeyTips: Boolean;
    FKeyTipsVisible: Boolean;
    FKeyTipsStage: TLazRibbonKeyTipsStage;
    FKeyTipsPrefix: String;

    { Visual headers shown above visible contextual tab groups. }
    FShowContextualGroupHeaders: Boolean;
    FContextualGroupHeaderHeight: Integer;
    FTabCaptionHorizontalPadding: Integer;
    FTabCaptionSpacing: Integer;
    FMinTabCaptionWidth: Integer;

    { Application/Menu Button mode }
    FApplicationButtonMode: TLazRibbonApplicationButtonMode;

    { Ribbon collapse/minimize state. When True only the tab strip and optional
      Quick Access Toolbar rows remain visible; pane contents are hidden. }
    FRibbonMinimized: Boolean;
    FOnRibbonMinimizedChanged: TNotifyEvent;

    { Office-like collapse/expand button at the right side of the tab strip }
    FShowCollapseButton: Boolean;
    FCollapseButtonRect: TRect;
    FCollapseButtonState: TLazRibbonMenuButtonState;
    FCollapseRibbonHint: String;
    FExpandRibbonHint: String;

    { Office-like help button at the right side of the tab strip }
    FShowHelpButton: Boolean;
    FHelpButtonRect: TRect;
    FHelpButtonState: TLazRibbonMenuButtonState;
    FHelpButtonHint: String;
    FOnHelpButtonClick: TNotifyEvent;

    { Menu Button image index }
    FMenuButtonCaption: String;

    { Menu Button dropdown menu }
    FMenuButtonDropdownMenu: TPopupMenu;

    { Flag to manage visibility of dropdown arrow on Menu Button }
    FMenuButtonStyle: TLazRibbonMenuButtonStyle;

    { Flag to manage visibility of Menu Button }
    FShowMenuButton: Boolean;

    { Menu Button state }
    FMenuButtonState: TLazRibbonMenuButtonState;

    { Menu Button click event }
    FOnMenuButtonClick: TNotifyEvent;

    { Optional BackStage integration.  Kept in a base unit to avoid a circular
      dependency between LazRibbon_Core and LazRibbon_Backstage. }
    FBackstageView: TLazRibbonCustomBackstageView;

   {$IFDEF DELAYRUNTIMER}
    procedure DelayRunTimer(Sender: TObject);
   {$ENDIF}

  protected

    { Instance of the Appearance object storing colours and fonts used during
      rendering of the component }
    FAppearance: TLazRibbonToolbarAppearance;

    { Tabs of the toolbar }
    FTabs: TLazRibbonTabs;

    { Index of the selected tab }
    FTabIndex: integer;

    { Imagelist of the small pictures of toolbar elements }
    FImages: TImageList;

    { Image list of the small pictures in the state "disabled".
      If the list is not assigned, small "disabled" pictures will be generated
      automatically }
    FDisabledImages: TImageList;

    { Imagelist of the large pictures of toolbar elements }
    FLargeImages: TImageList;

    { Image list of the large pictures in the state "disabled".
      If the list is not assigned, large "disabled" pictures will be generated
      automatically }
    FDisabledLargeImages: TImageList;

    { Unscaled width of the small images }
    FImagesWidth: Integer;

    { Unscaled width of the large images }
    FLargeImagesWidth: Integer;

    function DoTabChanging(OldIndex, NewIndex: integer): boolean;

    // *****************************************************
    // *** Management of the metric and the buffer state ***
    // *****************************************************

    { Method switches flags FMetricsValid and FBufferValid off }
    procedure SetMetricsInvalid;

    { Method swiches flag FBufferValid off }
    procedure SetBufferInvalid;

    { Method validates toolbar metrics and toolbar elements }
    procedure ValidateMetrics;

    { Method validates the content of the buffer }
    procedure ValidateBuffer;

    { Method switches on the mode of internal rebuilding
      and swiches flag FInternalUpdating on }
    procedure InternalBeginUpdate;

    { Method switches on the mode of internal rebuilding
      and swiches the flag FInternalUpdating off}
    procedure InternalEndUpdate;

    { Function calculates Menu Button dropdown point }
    function GetMenuButtonDropdownPoint: T2DIntPoint;

    // ************************************************
    // *** Covering of methods from derived classes ***
    // ************************************************

    { The Change of component size }
    procedure DoOnResize; override;

    { Method called when mouse pointer left component region }
    procedure MouseLeave; override;

    { Method called when mouse button is pressed }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;

    { Method called when mouse pointer is moved over component }
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;

    { Method called when the mouse button is released }
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;

    { Method called when the whole component has finished loading from LFM file }
    procedure Loaded; override;

    { Method called when component becomes the owner of other component,
      or one of its sub-components is released }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    // ******************************************
    // *** Handling of mouse events for tabs  ***
    // ******************************************

    { Method called when mouse pointer left the region of tab "handles" }
    procedure TabMouseLeave;

    { Method called when the mouse button is pressed
      and at the same time the mouse pointer is over the region of tabs }
    procedure TabMouseDown(Button: TMouseButton; {%H-}Shift: TShiftState;
      X, Y: integer);

    { Method called when the mouse will move over the region of tab "handles" }
    procedure TabMouseMove({%H-}Shift: TShiftState; X, Y: integer);

    { Method called when one of the mouse buttons is released
      and at the same time the region of tabs was active element of toolbar }
    procedure TabMouseUp({%H-}Button: TMouseButton; {%H-}Shift: TShiftState;
      {%H-}X, {%H-}Y: integer);

    // *************************************************
    // *** Handling of mouse events for Menu Button  ***
    // *************************************************

    { Method called when the mouse will move over the region of Menu Button }
    procedure MenuButtonMouseMove({%H-}Shift: TShiftState; {%H-}X, {%H-}Y: integer);

    { Method called when mouse pointer left the region of Menu Button }
    procedure MenuButtonMouseLeave;

    { Method called when the mouse button is pressed
      and at the same time the mouse pointer is over the region of Menu Button }
    procedure MenuButtonMouseDown({%H-}Button: TMouseButton; {%H-}Shift: TShiftState;
      {%H-}X, {%H-}Y: integer);

    { Method called when one of the mouse buttons is released
      and at the same time the region of Menu Button was active element of toolbar }
    procedure MenuButtonMouseUp({%H-}Button: TMouseButton; {%H-}Shift: TShiftState;
      {%H-}X, {%H-}Y: integer);

    // *********************
    // *** Extra support ***
    // *********************

    { Metchod checks if at least one of the tabs is switched on by flag Visible }
    function AtLeastOneTabVisible: boolean;

    // ****************
    // *** Messages ***
    // ****************

    { Message is received when mouse left the region of component }
    procedure CMMouseLeave(var msg: TLMessage); message CM_MOUSELEAVE;

    procedure CMHintShow(var Message: TLMessage); message CM_HINTSHOW;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function HandleKeyTipsBackspace: Boolean;

    // **************************
    // *** Designtime and LFM ***
    // **************************

    {Method gives back elements which will be saved as sub-elements of component }
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;

    { Method allows for saving and reading additional properties of component }
    procedure DefineProperties(Filer: TFiler); override;

    // ***************************
    // *** Getters and setters ***
    // ***************************

    { Setter for property Appearance }
    procedure SetAppearance(const Value: TLazRibbonToolbarAppearance);

    { Getter for property Color }
    function GetColor: TColor;

    { Setter for property Color }
    procedure SetColor(Value: TColor); reintroduce;  // "override" will overflow the stack.

    { Setter for property TabIndex }
    procedure SetTabIndex(const Value: integer);

    { Setter for property Images }
    procedure SetImages(const Value: TImageList);

    { Setter for property DisabledImages }
    procedure SetDisabledImages(const Value: TImageList);

    { Setter for property LargeImages }
    procedure SetLargeImages(const Value: TImageList);

    { Setter for property DisabledLargeImages }
    procedure SetDisabledLargeImages(const Value: TImageList);

    { Setter for toolbar style, i.e. quick selection of new appearance theme }
    procedure SetStyle(const Value: TLazRibbonStyle);
    procedure SetAppearanceSource(AValue: TLazRibbonAppearanceSource);
    procedure SetSkinManager(AValue: TLazRibbonSkinManager);
    procedure SkinManagerChanged(Sender: TObject);
    procedure ApplySkinManagerAppearance;
    procedure SetBackstageView(AValue: TLazRibbonCustomBackstageView);
    procedure ConfigureBackstageView;
    procedure SetApplicationButton(AValue: TLazRibbonApplicationButton);
    procedure SetApplicationButtonMode(AValue: TLazRibbonApplicationButtonMode);
    procedure SetQuickAccessToolBar(AValue: TLazRibbonQuickAccessToolBar);
    procedure SetRibbonMinimized(AValue: Boolean);
    procedure SetShowCollapseButton(AValue: Boolean);
    procedure SetCollapseRibbonHint(const AValue: String);
    procedure SetExpandRibbonHint(const AValue: String);
    function CollapseButtonHitTest(X, Y: Integer): Boolean;
    procedure CollapseButtonMouseLeave;
    procedure CollapseButtonMouseMove({%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure CollapseButtonMouseDown({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure CollapseButtonMouseUp({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure SetShowHelpButton(AValue: Boolean);
    procedure SetHelpButtonHint(const AValue: String);
    function HelpButtonHitTest(X, Y: Integer): Boolean;
    procedure HelpButtonMouseLeave;
    procedure HelpButtonMouseMove({%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure HelpButtonMouseDown({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure HelpButtonMouseUp({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure SetShowKeyTips(AValue: Boolean);
    procedure SetKeyTipsVisible(AValue: Boolean);
    procedure SetShowContextualGroupHeaders(AValue: Boolean);
    procedure SetContextualGroupHeaderHeight(AValue: Integer);
    procedure SetTabCaptionHorizontalPadding(AValue: Integer);
    procedure SetTabCaptionSpacing(AValue: Integer);
    procedure SetMinTabCaptionWidth(AValue: Integer);
    function EffectiveContextualGroupHeaderHeight: Integer;
    procedure InvalidateHostedTitleBar;
    function QuickAccessHitTest(X, Y: Integer): Integer;
    procedure QuickAccessMouseLeave;
    procedure QuickAccessMouseMove({%H-}Shift: TShiftState; X, Y: Integer);
    procedure QuickAccessMouseDown({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure QuickAccessMouseUp({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; X, Y: Integer);
    function FindQuickAccessLinkedItemForAction(AAction: TBasicAction): TLazRibbonBaseItem;
    procedure ShowQuickAccessCustomizeMenu;
    procedure QuickAccessCustomizeActionMenuClick(Sender: TObject);
    procedure QuickAccessMoreCommandsMenuClick(Sender: TObject);
    procedure QuickAccessPositionMenuClick(Sender: TObject);
    procedure QuickAccessMinimizeRibbonMenuClick(Sender: TObject);
    procedure QuickAccessResetToDefaultMenuClick(Sender: TObject);
    function IsSkinPaletteChanged(const APalette: TLazRibbonSkinPalette): Boolean;

    { Setter for Menu Button caption }
    procedure SetMenuButtonCaption(Value: String);

    { Setter for Menu Button dropdown menu }
    procedure SetMenuButtonDropdownMenu(const Value: TPopupMenu);

    { Setter for style of Menu Button }
    procedure SetMenuButtonStyle(Value: TLazRibbonMenuButtonStyle);

    { Setter for visibility of Menu Button }
    procedure SetShowMenuButton(Value: Boolean);

    { Setter for BiDiMode (left-to-right or right-to-left writing direction) }
    procedure SetBiDiMode(Value: TBiDiMode); override;

    { Calculates the height of the entire toolbar }
    function CalcToolbarHeight: Integer;

    { LCL Scaling }
    {$IF lcl_fullversion >= 1080000}
    procedure DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
      const AXProportion, AYProportion: Double); override;
    {$IFEND}

    { Hi-DPI image list support }
    procedure SetImagesWidth(const AValue: Integer);
    procedure SetLargeImagesWidth(const AValue: Integer);

  public

    // **********************************
    // *** Constructor and Destructor ***
    // **********************************

    { Constructor }
    constructor Create(AOwner: TComponent); override;

    { Destructor }
    destructor Destroy; override;


    { LCL Scaling }
    {$IF lcl_fullversion >= 1080000}
    {$IF lcl_fullversion < 1080100}
    procedure ScaleFontsPPI(const AProportion: Double); override;
    {$ELSE}
    procedure FixDesignFontsPPI(const ADesignTimePPI: Integer); override;
    procedure ScaleFontsPPI(const AToPPI: Integer; const AProportion: Double); override;
    {$ENDIF}
    {$ENDIF}

    // *************************
    // *** Dispatcher events ***
    // *************************

    { Reaction to change of toolbar elements structure }
    procedure NotifyItemsChanged;

    { Reaction to change of toolbar elements metric }
    procedure NotifyMetricsChanged;

    { Reaction to change of toolbar elements appearance }
    procedure NotifyVisualsChanged;

    { Reaction to change of content of toolbar class appearance }
    procedure NotifyAppearanceChanged;

    { Method gives back the instance of supporting bitmap }
    function GetTempBitmap: TBitmap;


    // ***************
    // *** Drawing ***
    // ***************

//    procedure EraseBackground(DC: HDC); override;

    { Method draws the content of the component }
    procedure Paint; override;

    { Method enforces the rebuilding of metrics and buffer }
    procedure ForceRepaint;

    { Method swiches over the component in update mode of the content
      by switching on flag FUpdating }
    procedure BeginUpdate;

    { Method switches off the update mode of the content
      by switching off flag FUpdating }
    procedure EndUpdate;

    // ****************
    // *** Elements ***
    // ****************

    { Method called when one of the tabs is released
      You cannot call method FreeingTab from code (by writing it in code)
      It's called internally and its purpuse is to update internal list of tabs }
    procedure FreeingTab(ATab: TLazRibbonTab);

    // **********************
    // *** Access to tabs ***
    // **********************

    { Property gives accesss to tabs in runtime mode
      To edit tabs in designtime mode use proper editor
      Savings and readings from LFM is done manually }
    property Tabs: TLazRibbonTabs read FTabs;

    // *** Menu Button ***
    procedure DoMenuButtonClick;

    { Shows the Quick Access customization menu at a screen coordinate.
      Used by TLazRibbonForm when the QAT is hosted in the custom title bar. }
    procedure ShowQuickAccessCustomizeMenuAtScreen(const AScreenPoint: TPoint);

    function ElementAt(X, Y: Integer): TLazRibbonComponent;
    procedure ShowKeyTipsOverlay;
    procedure HideKeyTips;
    procedure ToggleKeyTips;
    function KeyTipsTopLevelVisible: Boolean;
    function KeyTipsActiveTabCommandsVisible: Boolean;
    function KeyTipsPrefix: String;
    function ProcessKeyTipsBackspace: Boolean;
    property KeyTipsVisible: Boolean read FKeyTipsVisible write SetKeyTipsVisible;

    { Contextual tabs are tabs marked with TLazRibbonTab.Contextual=True.
      The group caption is matched case-insensitively against
      TLazRibbonTab.ContextualGroupCaption.  Passing an empty group caption
      affects all contextual tabs.  The methods return the number of tabs whose
      Visible state was changed. }
    function SetContextualTabsVisible(const AGroupCaption: String; AVisible: Boolean;
      ASelectFirstTab: Boolean = False): Integer;
    function ShowContextualTabs(const AGroupCaption: String;
      ASelectFirstTab: Boolean = False): Integer;
    function HideContextualTabs(const AGroupCaption: String): Integer;
    procedure HideAllContextualTabs;
    function ContextualTabsVisible(const AGroupCaption: String): Boolean;

  published

    { Office-like Application Button. New code should prefer the persistent
      subobject below. The flattened properties are kept for compatibility and
      delegate to the same internal state. }
    property ApplicationButton: TLazRibbonApplicationButton read FApplicationButton write SetApplicationButton;
    property QuickAccessToolBar: TLazRibbonQuickAccessToolBar read FQuickAccessToolBar write SetQuickAccessToolBar;
    property ApplicationButtonCaption: String read FMenuButtonCaption write SetMenuButtonCaption;
    property ApplicationButtonVisible: Boolean read FShowMenuButton write SetShowMenuButton default False;
    property ApplicationButtonMode: TLazRibbonApplicationButtonMode read FApplicationButtonMode write SetApplicationButtonMode default abmEvent;
    property ApplicationMenu: TPopupMenu read FMenuButtonDropdownMenu write SetMenuButtonDropdownMenu;
    property OnApplicationButtonClick: TNotifyEvent read FOnMenuButtonClick write FOnMenuButtonClick;

    { Collapses the Ribbon so only the tab strip and optional Quick Access
      Toolbar remain visible. This is the Office-like "Minimize Ribbon" state. }
    property RibbonMinimized: Boolean read FRibbonMinimized write SetRibbonMinimized default False;
    property ShowCollapseButton: Boolean read FShowCollapseButton write SetShowCollapseButton default True;
    property CollapseRibbonHint: String read FCollapseRibbonHint write SetCollapseRibbonHint;
    property ExpandRibbonHint: String read FExpandRibbonHint write SetExpandRibbonHint;
    property ShowHelpButton: Boolean read FShowHelpButton write SetShowHelpButton default True;
    property ShowKeyTips: Boolean read FShowKeyTips write SetShowKeyTips default True;
    property ShowContextualGroupHeaders: Boolean read FShowContextualGroupHeaders write SetShowContextualGroupHeaders default True;
    property ContextualGroupHeaderHeight: Integer read FContextualGroupHeaderHeight write SetContextualGroupHeaderHeight default 18;
    property TabCaptionHorizontalPadding: Integer
      read FTabCaptionHorizontalPadding write SetTabCaptionHorizontalPadding
      default LAZRIBBON_DEFAULT_TAB_CAPTION_HORIZONTAL_PADDING;
    property TabCaptionSpacing: Integer
      read FTabCaptionSpacing write SetTabCaptionSpacing
      default LAZRIBBON_DEFAULT_TAB_CAPTION_SPACING;
    property MinTabCaptionWidth: Integer
      read FMinTabCaptionWidth write SetMinTabCaptionWidth
      default LAZRIBBON_DEFAULT_MIN_TAB_CAPTION_WIDTH;
    property HelpButtonHint: String read FHelpButtonHint write SetHelpButtonHint;
    property OnHelpButtonClick: TNotifyEvent read FOnHelpButtonClick write FOnHelpButtonClick;
    property OnRibbonMinimizedChanged: TNotifyEvent read FOnRibbonMinimizedChanged write FOnRibbonMinimizedChanged;

    { Component background color }
    property Color: TColor read GetColor write SetColor default clSkyBlue;

    { Appearance style - don't move after Appearance! }
    property Style: TLazRibbonStyle read FStyle write SetStyle default lazOffice2007Blue;

    { Skin integration. asInternalStyle preserves the original LazRibbon_Core behavior. }
    property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asInternalStyle;
    property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;

    { Optional BackStage view linked to the Application Button. Assigning this
      property automatically shows the Application Button, switches the mode to
      abmBackstage, hooks its click handler and passes the Ribbon SkinManager to
      the BackStage view when available. }
    property BackstageView: TLazRibbonCustomBackstageView read FBackstageView write SetBackstageView;

    { Object containing attributes of toolbar appearance }
    property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;

    { Index of active tab }
    property TabIndex: integer read FTabIndex write SetTabIndex;

    { ImageList with the small pictures }
    property Images: TImageList read FImages write SetImages;

    { ImageList with the small pictures in state "disabled" }
    property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;

    { ImageList with the large pictures }
    property LargeImages: TImageList read FLargeImages write SetLargeImages;

    { ImageList with the large pictures in state "disabled" }
    property DisabledLargeImages: TImageList
      read FDisabledLargeImages write SetDisabledLargeImages;

    { Unscaled size of the small images }
    property ImagesWidth: Integer read FImagesWidth write SetImagesWidth default 16;

    { Unscaled size of the large images }
    property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth default 32;

    { Menu Button caption }
    property MenuButtonCaption: String read FMenuButtonCaption write SetMenuButtonCaption;

    { Menu Button dropdown menu }
    property MenuButtonDropdownMenu: TPopupMenu read FMenuButtonDropdownMenu write SetMenuButtonDropdownMenu;

    { Menu Button style }
    property MenuButtonStyle: TLazRibbonMenuButtonStyle read FMenuButtonStyle write SetMenuButtonStyle default mbsCaption;

    { Show Menu Button flag }
    property ShowMenuButton: Boolean read FShowMenuButton write SetShowMenuButton default False;

    { Event called on Menu Button clik }
    property OnMenuButtonClick: TNotifyEvent
      read FOnMenuButtonClick write FOnMenuButtonClick;

    { Events called before and after another tab is selected }
    property OnTabChanging: TLazRibbonTabChangingEvent
      read FOnTabChanging write FOnTabChanging;
    property OnTabChanged: TNotifyEvent read FOnTabChanged write FOnTabChanged;

    { inherited properties }
    property Align default alTop;
    property BiDiMode;
    property BorderSpacing;
    property Anchors;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property OnResize;
    property OnShowHint;

  end;


implementation

uses
  LCLIntf, LCLProc, Themes, LazRibbon_Buttons, LazRibbon_Popup;


{ TLazRibbonApplicationButton }

constructor TLazRibbonApplicationButton.Create(AOwner: TLazRibbon);
begin
  inherited Create;
  FOwner := AOwner;
  FImageIndex := -1;
  FShowScreenTip := True;
  FGlyph := TPicture.Create;
  FGlyph.OnChange := GlyphChanged;
end;

destructor TLazRibbonApplicationButton.Destroy;
begin
  { Avoid an OnChange callback reaching the Ribbon while it is being
    destroyed. TPicture/graphic teardown can emit change notifications on
    some widgetset/RTL combinations. }
  FOwner := nil;
  if FGlyph <> nil then
    FGlyph.OnChange := nil;
  FreeAndNil(FGlyph);
  inherited Destroy;
end;

procedure TLazRibbonApplicationButton.Assign(Source: TPersistent);
begin
  if Source is TLazRibbonApplicationButton then
  begin
    Caption := TLazRibbonApplicationButton(Source).Caption;
    Visible := TLazRibbonApplicationButton(Source).Visible;
    Mode := TLazRibbonApplicationButton(Source).Mode;
    BackstageView := TLazRibbonApplicationButton(Source).BackstageView;
    Menu := TLazRibbonApplicationButton(Source).Menu;
    Glyph := TLazRibbonApplicationButton(Source).Glyph;
    ImageIndex := TLazRibbonApplicationButton(Source).ImageIndex;
    Hint := TLazRibbonApplicationButton(Source).Hint;
    KeyTip := TLazRibbonApplicationButton(Source).KeyTip;
    ShowScreenTip := TLazRibbonApplicationButton(Source).ShowScreenTip;
    ScreenTipTitle := TLazRibbonApplicationButton(Source).ScreenTipTitle;
    ScreenTipText := TLazRibbonApplicationButton(Source).ScreenTipText;
    ScreenTipShortcut := TLazRibbonApplicationButton(Source).ScreenTipShortcut;
    ScreenTipFooter := TLazRibbonApplicationButton(Source).ScreenTipFooter;
    OnClick := TLazRibbonApplicationButton(Source).OnClick;
  end
  else
    inherited Assign(Source);
end;

procedure TLazRibbonApplicationButton.Changed;
begin
  if (FOwner <> nil) and not (csDestroying in FOwner.ComponentState) then
    FOwner.ForceRepaint;
end;

procedure TLazRibbonApplicationButton.GlyphChanged(Sender: TObject);
begin
  Changed;
end;

function TLazRibbonApplicationButton.GetCaption: String;
begin
  if FOwner <> nil then
    Result := FOwner.FMenuButtonCaption
  else
    Result := '';
end;

function TLazRibbonApplicationButton.GetVisible: Boolean;
begin
  Result := (FOwner <> nil) and FOwner.FShowMenuButton;
end;

function TLazRibbonApplicationButton.GetMode: TLazRibbonApplicationButtonMode;
begin
  if FOwner <> nil then
    Result := FOwner.FApplicationButtonMode
  else
    Result := abmEvent;
end;

function TLazRibbonApplicationButton.GetMenu: TPopupMenu;
begin
  if FOwner <> nil then
    Result := FOwner.FMenuButtonDropdownMenu
  else
    Result := nil;
end;

function TLazRibbonApplicationButton.GetBackstageView: TLazRibbonCustomBackstageView;
begin
  if FOwner <> nil then
    Result := FOwner.FBackstageView
  else
    Result := nil;
end;

function TLazRibbonApplicationButton.GetOnClick: TNotifyEvent;
begin
  if FOwner <> nil then
    Result := FOwner.FOnMenuButtonClick
  else
    Result := nil;
end;

procedure TLazRibbonApplicationButton.SetCaption(const AValue: String);
begin
  if FOwner <> nil then
    FOwner.SetMenuButtonCaption(AValue);
end;

procedure TLazRibbonApplicationButton.SetVisible(AValue: Boolean);
begin
  if FOwner <> nil then
    FOwner.SetShowMenuButton(AValue);
end;

procedure TLazRibbonApplicationButton.SetMode(AValue: TLazRibbonApplicationButtonMode);
begin
  if FOwner <> nil then
    FOwner.SetApplicationButtonMode(AValue);
end;

procedure TLazRibbonApplicationButton.SetMenu(AValue: TPopupMenu);
begin
  if FOwner <> nil then
    FOwner.SetMenuButtonDropdownMenu(AValue);
end;

procedure TLazRibbonApplicationButton.SetBackstageView(AValue: TLazRibbonCustomBackstageView);
begin
  if FOwner <> nil then
    FOwner.SetBackstageView(AValue);
end;

procedure TLazRibbonApplicationButton.SetOnClick(AValue: TNotifyEvent);
begin
  if FOwner <> nil then
    FOwner.FOnMenuButtonClick := AValue;
end;

procedure TLazRibbonApplicationButton.SetGlyph(AValue: TPicture);
begin
  FGlyph.Assign(AValue);
  Changed;
end;

procedure TLazRibbonApplicationButton.SetImageIndex(AValue: Integer);
begin
  if FImageIndex = AValue then Exit;
  FImageIndex := AValue;
  Changed;
end;

procedure TLazRibbonApplicationButton.SetHint(const AValue: String);
begin
  if FHint = AValue then Exit;
  FHint := AValue;
  Changed;
end;

procedure TLazRibbonApplicationButton.SetKeyTip(const AValue: String);
begin
  if FKeyTip = AValue then Exit;
  FKeyTip := AValue;
  Changed;
end;

procedure TLazRibbonApplicationButton.SetShowScreenTip(AValue: Boolean);
begin
  if FShowScreenTip = AValue then Exit;
  FShowScreenTip := AValue;
  Changed;
end;

procedure TLazRibbonApplicationButton.SetScreenTipTitle(const AValue: String);
begin
  if FScreenTipTitle = AValue then Exit;
  FScreenTipTitle := AValue;
  Changed;
end;

procedure TLazRibbonApplicationButton.SetScreenTipText(const AValue: String);
begin
  if FScreenTipText = AValue then Exit;
  FScreenTipText := AValue;
  Changed;
end;

procedure TLazRibbonApplicationButton.SetScreenTipShortcut(const AValue: String);
begin
  if FScreenTipShortcut = AValue then Exit;
  FScreenTipShortcut := AValue;
  Changed;
end;

procedure TLazRibbonApplicationButton.SetScreenTipFooter(const AValue: String);
begin
  if FScreenTipFooter = AValue then Exit;
  FScreenTipFooter := AValue;
  Changed;
end;

function TLazRibbonApplicationButton.EffectiveHint: String;
var
  TitleText, BodyText, ScreenTipText: String;

  procedure AddLine(const ALine: String);
  begin
    if ALine = '' then
      Exit;
    if ScreenTipText <> '' then
      ScreenTipText := ScreenTipText + LineEnding;
    ScreenTipText := ScreenTipText + ALine;
  end;

begin
  if FShowScreenTip and
     ((FScreenTipTitle <> '') or (FScreenTipText <> '') or
      (FScreenTipShortcut <> '') or (FScreenTipFooter <> '')) then
  begin
    ScreenTipText := '';
    TitleText := FScreenTipTitle;
    if TitleText = '' then
      TitleText := Caption;

    BodyText := FScreenTipText;
    if (BodyText = '') and (FHint <> '') and not SameText(FHint, TitleText) then
      BodyText := FHint;

    AddLine(TitleText);
    AddLine(BodyText);
    AddLine(FScreenTipShortcut);

    if (FScreenTipFooter <> '') and (ScreenTipText <> '') then
      ScreenTipText := ScreenTipText + LineEnding;
    AddLine(FScreenTipFooter);

    Result := ScreenTipText;
  end
  else
    Result := FHint;
end;



{ TLazRibbonQuickAccessItem }

constructor TLazRibbonQuickAccessItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEnabled := True;
  FVisible := True;
  FImageIndex := -1;
  FShowScreenTip := True;
end;

destructor TLazRibbonQuickAccessItem.Destroy;
var
  Ribbon: TLazRibbon;
begin
  Ribbon := OwnerRibbon;
  if (FAction <> nil) and (Ribbon <> nil) and
     (not (csDestroying in FAction.ComponentState)) then
    FAction.RemoveFreeNotification(Ribbon);
  if (FLinkedItem <> nil) and (Ribbon <> nil) and
     (not (csDestroying in FLinkedItem.ComponentState)) then
    FLinkedItem.RemoveFreeNotification(Ribbon);
  FAction := nil;
  FLinkedItem := nil;
  inherited Destroy;
end;

function TLazRibbonQuickAccessItem.OwnerRibbon: TLazRibbon;
begin
  Result := nil;
  if (Collection is TLazRibbonQuickAccessItems) and
     (TLazRibbonQuickAccessItems(Collection).OwnerToolBar <> nil) then
    Result := TLazRibbonQuickAccessItems(Collection).OwnerToolBar.FOwner;
end;

procedure TLazRibbonQuickAccessItem.Changed;
begin
  inherited Changed(False);
end;

function TLazRibbonQuickAccessItem.GetDisplayName: string;
begin
  Result := '';

  if (FAction is TCustomAction) and (TCustomAction(FAction).Caption <> '') then
    Result := TCustomAction(FAction).Caption
  else if (FAction <> nil) and (FAction.Name <> '') then
    Result := 'Action: ' + FAction.Name
  else if (FLinkedItem is TLazRibbonBaseButton) and
          (TLazRibbonBaseButton(FLinkedItem).Caption <> '') then
    Result := TLazRibbonBaseButton(FLinkedItem).Caption
  else if (FLinkedItem <> nil) and (FLinkedItem.Name <> '') then
    Result := 'LinkedItem: ' + FLinkedItem.Name
  else if FCaption <> '' then
    Result := FCaption;

  if Result = '' then
    Result := inherited GetDisplayName;
end;

procedure TLazRibbonQuickAccessItem.SetAction(AValue: TBasicAction);
var
  Ribbon: TLazRibbon;
begin
  if FAction = AValue then Exit;

  Ribbon := OwnerRibbon;
  if (FAction <> nil) and (Ribbon <> nil) and
     (not (csDestroying in FAction.ComponentState)) then
    FAction.RemoveFreeNotification(Ribbon);

  FAction := AValue;

  if (FAction <> nil) and (Ribbon <> nil) and
     (not (csDestroying in Ribbon.ComponentState)) then
    FAction.FreeNotification(Ribbon);

  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetEnabled(AValue: Boolean);
begin
  if FEnabled = AValue then Exit;
  FEnabled := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetHint(const AValue: String);
begin
  if FHint = AValue then Exit;
  FHint := AValue;
  Changed;
end;


procedure TLazRibbonQuickAccessItem.SetKeyTip(const AValue: String);
begin
  if FKeyTip = AValue then Exit;
  FKeyTip := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetImageIndex(AValue: Integer);
begin
  if FImageIndex = AValue then Exit;
  FImageIndex := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetLinkedItem(AValue: TLazRibbonBaseItem);
var
  Ribbon: TLazRibbon;
begin
  if FLinkedItem = AValue then Exit;

  Ribbon := OwnerRibbon;
  if (FLinkedItem <> nil) and (Ribbon <> nil) and
     (not (csDestroying in FLinkedItem.ComponentState)) then
    FLinkedItem.RemoveFreeNotification(Ribbon);

  FLinkedItem := AValue;

  if (FLinkedItem <> nil) and (Ribbon <> nil) and
     (not (csDestroying in Ribbon.ComponentState)) then
    FLinkedItem.FreeNotification(Ribbon);

  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetVisible(AValue: Boolean);
begin
  if FVisible = AValue then Exit;
  FVisible := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetShowScreenTip(AValue: Boolean);
begin
  if FShowScreenTip = AValue then Exit;
  FShowScreenTip := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetScreenTipTitle(const AValue: String);
begin
  if FScreenTipTitle = AValue then Exit;
  FScreenTipTitle := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetScreenTipText(const AValue: String);
begin
  if FScreenTipText = AValue then Exit;
  FScreenTipText := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetScreenTipShortcut(const AValue: String);
begin
  if FScreenTipShortcut = AValue then Exit;
  FScreenTipShortcut := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessItem.SetScreenTipFooter(const AValue: String);
begin
  if FScreenTipFooter = AValue then Exit;
  FScreenTipFooter := AValue;
  Changed;
end;

function TLazRibbonQuickAccessItem.EffectiveCaption: TCaption;
begin
  Result := FCaption;
  if (FAction is TCustomAction) and (TCustomAction(FAction).Caption <> '') then
    Result := TCustomAction(FAction).Caption
  else if (FLinkedItem is TLazRibbonBaseButton) and (TLazRibbonBaseButton(FLinkedItem).Caption <> '') then
    Result := TLazRibbonBaseButton(FLinkedItem).Caption;
end;

function TLazRibbonQuickAccessItem.EffectiveEnabled: Boolean;
begin
  Result := FEnabled;
  if FAction is TCustomAction then
    Result := Result and TCustomAction(FAction).Enabled;
  if FLinkedItem <> nil then
    Result := Result and FLinkedItem.Enabled;
  if (FLinkedItem is TLazRibbonBaseButton) and (TLazRibbonBaseButton(FLinkedItem).Action is TCustomAction) then
    Result := Result and TCustomAction(TLazRibbonBaseButton(FLinkedItem).Action).Enabled;
end;

function TLazRibbonQuickAccessItem.EffectiveHint: String;
var
  TitleText, BodyText, BaseHint, ScreenTipText: String;

  procedure AddLine(const ALine: String);
  begin
    if ALine = '' then
      Exit;
    if ScreenTipText <> '' then
      ScreenTipText := ScreenTipText + LineEnding;
    ScreenTipText := ScreenTipText + ALine;
  end;

begin
  BaseHint := FHint;
  if (FAction is TCustomAction) and (TCustomAction(FAction).Hint <> '') then
    BaseHint := TCustomAction(FAction).Hint
  else if FLinkedItem <> nil then
  begin
    BaseHint := FLinkedItem.EffectiveScreenTip;
    if BaseHint = '' then
      BaseHint := FLinkedItem.Hint;
  end;

  if FShowScreenTip and
     ((FScreenTipTitle <> '') or (FScreenTipText <> '') or
      (FScreenTipShortcut <> '') or (FScreenTipFooter <> '')) then
  begin
    ScreenTipText := '';
    TitleText := FScreenTipTitle;
    if TitleText = '' then
      TitleText := EffectiveCaption;

    BodyText := FScreenTipText;
    if (BodyText = '') and (BaseHint <> '') and not SameText(BaseHint, TitleText) then
      BodyText := BaseHint;

    AddLine(TitleText);
    AddLine(BodyText);
    AddLine(FScreenTipShortcut);

    if (FScreenTipFooter <> '') and (ScreenTipText <> '') then
      ScreenTipText := ScreenTipText + LineEnding;
    AddLine(FScreenTipFooter);

    Result := ScreenTipText;
  end
  else
    Result := BaseHint;

  if (Result <> '') and (FScreenTipShortcut = '') and
     (FAction is TCustomAction) and Application.HintShortCuts and
     (TCustomAction(FAction).ShortCut <> scNone) then
  begin
    if Pos(LineEnding, Result) > 0 then
      Result := Result + LineEnding + ShortCutToText(TCustomAction(FAction).ShortCut)
    else
      Result := Format('%s (%s)', [Result, ShortCutToText(TCustomAction(FAction).ShortCut)]);
  end;
end;

function TLazRibbonQuickAccessItem.EffectiveImageIndex: Integer;
begin
  Result := FImageIndex;
  if (Result < 0) and (FAction is TCustomAction) then
    Result := TCustomAction(FAction).ImageIndex;
  if (Result < 0) and (FLinkedItem is TLazRibbonSmallButton) then
    Result := TLazRibbonSmallButton(FLinkedItem).ImageIndex;
  if (Result < 0) and (FLinkedItem is TLazRibbonLargeButton) then
    Result := TLazRibbonLargeButton(FLinkedItem).LargeImageIndex;
end;

function TLazRibbonQuickAccessItem.EffectiveVisible: Boolean;
begin
  Result := FVisible;
  if FAction is TCustomAction then
    Result := Result and TCustomAction(FAction).Visible;

  { Do not inherit LinkedItem.Visible here.  The QAT is allowed to expose
    commands that are not currently visible in a Ribbon pane.  The LinkedItem
    is a command source/representation, not necessarily the visible instance. }
end;

function TLazRibbonQuickAccessItem.EffectiveDropDownMenu: TPopupMenu;
begin
  Result := nil;

  if FLinkedItem is TLazRibbonLargeButton then
  begin
    if TLazRibbonLargeButton(FLinkedItem).ButtonKind in [bkDropdown, bkButtonDropdown] then
      Result := TLazRibbonLargeButton(FLinkedItem).DropdownMenu;
    Exit;
  end;

  if FLinkedItem is TLazRibbonSmallButton then
  begin
    if TLazRibbonSmallButton(FLinkedItem).ButtonKind in [bkDropdown, bkButtonDropdown] then
      Result := TLazRibbonSmallButton(FLinkedItem).DropdownMenu;
    Exit;
  end;
end;

function TLazRibbonQuickAccessItem.HasLinkedDropDown: Boolean;
begin
  Result := EffectiveDropDownMenu <> nil;
end;

procedure TLazRibbonQuickAccessItem.Execute;
begin
  ExecuteAt(Point(0, 0));
end;

procedure TLazRibbonQuickAccessItem.ExecuteAt(const AScreenPoint: TPoint);
var
  B: TLazRibbonBaseButton;
  M: TPopupMenu;
  P: TPoint;
begin
  if not EffectiveVisible or not EffectiveEnabled then Exit;

  { A QAT item linked to an existing Ribbon dropdown must behave as the
    compact representation of that dropdown, not as a separate command. }
  M := EffectiveDropDownMenu;
  if M <> nil then
  begin
    P := AScreenPoint;
    if (P.X = 0) and (P.Y = 0) then
      P := Mouse.CursorPos;
    if (OwnerRibbon <> nil) and OwnerRibbon.IsRightToLeft then
      M.BiDiMode := bdRightToLeft
    else
      M.BiDiMode := bdLeftToRight;
    M.Popup(P.X, P.Y);
    Exit;
  end;

  if FAction <> nil then
  begin
    FAction.Execute;
    Exit;
  end;

  if FLinkedItem is TLazRibbonBaseButton then
  begin
    B := TLazRibbonBaseButton(FLinkedItem);
    if B.Action <> nil then
      B.Action.Execute
    else if Assigned(B.OnClick) then
      B.OnClick(B);
  end;
end;

{ TLazRibbonQuickAccessItems }

constructor TLazRibbonQuickAccessItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TLazRibbonQuickAccessItem);
  FOwnerToolBar := nil;
  if AOwner is TLazRibbonQuickAccessToolBar then
    FOwnerToolBar := TLazRibbonQuickAccessToolBar(AOwner);
end;

function TLazRibbonQuickAccessItems.Add: TLazRibbonQuickAccessItem;
begin
  Result := TLazRibbonQuickAccessItem(inherited Add);
end;

function TLazRibbonQuickAccessItems.AddAction(AAction: TBasicAction): TLazRibbonQuickAccessItem;
begin
  Result := Add;
  Result.Action := AAction;
end;

function TLazRibbonQuickAccessItems.AddLinkedItem(AItem: TLazRibbonBaseItem): TLazRibbonQuickAccessItem;
begin
  Result := Add;
  Result.LinkedItem := AItem;
end;

function TLazRibbonQuickAccessItems.GetItem(Index: Integer): TLazRibbonQuickAccessItem;
begin
  Result := TLazRibbonQuickAccessItem(inherited Items[Index]);
end;

procedure TLazRibbonQuickAccessItems.SetItem(Index: Integer; AValue: TLazRibbonQuickAccessItem);
begin
  inherited Items[Index] := AValue;
end;

procedure TLazRibbonQuickAccessItems.Update(Item: TCollectionItem);
var
  OwnerObj: TPersistent;
begin
  inherited Update(Item);
  OwnerObj := Owner;
  if OwnerObj is TLazRibbonQuickAccessToolBar then
    TLazRibbonQuickAccessToolBar(OwnerObj).Changed;
end;

{ TLazRibbonQuickAccessToolBar }

constructor TLazRibbonQuickAccessToolBar.Create(AOwner: TLazRibbon);
begin
  inherited Create;
  FOwner := AOwner;
  FVisible := False;
  FPosition := qapBeforeTabs;
  FButtonFrameStyle := qfsHotOnly;
  FButtonSize := 0;
  FSpacing := 2;
  FFallbackGlyphStyle := qfgOfficeGlyphs;
  FCustomizeMenuTitle := 'Personalizar Barra de Ferramentas de Acesso Rápido';
  FMoreCommandsCaption := 'Mais Comandos...';
  FShowBelowRibbonCaption := 'Mostrar Abaixo da Faixa de Opções';
  FShowAboveRibbonCaption := 'Mostrar Acima da Faixa de Opções';
  FMinimizeRibbonCaption := 'Minimizar a Faixa de Opções';
  FRestoreRibbonCaption := 'Restaurar a Faixa de Opções';
  FResetToDefaultsCaption := 'Restaurar Barra de Acesso Rápido';
  FStorageSection := 'QuickAccessToolBar';
  FShowCustomizeButton := True;
  FShowMoreCommandsItem := False;
  FShowPositionMenuItem := False;
  FShowMinimizeRibbonMenuItem := False;
  FShowResetToDefaultsItem := True;
  FAllowCustomizing := True;
  FAllowQuickCustomizing := True;
  FAllowReset := True;
  FAllowPositionChange := False;
  FAllowMinimizeRibbon := False;
  FDefaultItems := TStringList.Create;
  FDefaultItemsCaptured := False;
  FItems := TLazRibbonQuickAccessItems.Create(Self);
end;

destructor TLazRibbonQuickAccessToolBar.Destroy;
begin
  if (FCustomizeActionList <> nil) and (FOwner <> nil) and
     (not (csDestroying in FCustomizeActionList.ComponentState)) then
    FCustomizeActionList.RemoveFreeNotification(FOwner);
  FCustomizeActionList := nil;

  if (FImages <> nil) and (FOwner <> nil) and
     (not (csDestroying in FImages.ComponentState)) then
    FImages.RemoveFreeNotification(FOwner);
  FImages := nil;

  { Do not simply nil item references here. Each TLazRibbonQuickAccessItem
    destructor must be allowed to unregister its FreeNotification links.
    Otherwise Actions or LinkedItems can keep stale notification/event links
    during form shutdown. }
  FDefaultItems.Free;
  FItems.Free;
  inherited Destroy;
end;

procedure TLazRibbonQuickAccessToolBar.Assign(Source: TPersistent);
begin
  if Source is TLazRibbonQuickAccessToolBar then
  begin
    Visible := TLazRibbonQuickAccessToolBar(Source).Visible;
    Position := TLazRibbonQuickAccessToolBar(Source).Position;
    Items.Assign(TLazRibbonQuickAccessToolBar(Source).Items);
    ButtonFrameStyle := TLazRibbonQuickAccessToolBar(Source).ButtonFrameStyle;
    ButtonSize := TLazRibbonQuickAccessToolBar(Source).ButtonSize;
    Spacing := TLazRibbonQuickAccessToolBar(Source).Spacing;
    FallbackGlyphStyle := TLazRibbonQuickAccessToolBar(Source).FallbackGlyphStyle;
    CustomizeActionList := TLazRibbonQuickAccessToolBar(Source).CustomizeActionList;
    CustomizeMenuTitle := TLazRibbonQuickAccessToolBar(Source).CustomizeMenuTitle;
    MoreCommandsCaption := TLazRibbonQuickAccessToolBar(Source).MoreCommandsCaption;
    StorageSection := TLazRibbonQuickAccessToolBar(Source).StorageSection;
    ShowCustomizeButton := TLazRibbonQuickAccessToolBar(Source).ShowCustomizeButton;
    ShowMoreCommandsItem := TLazRibbonQuickAccessToolBar(Source).ShowMoreCommandsItem;
    ShowPositionMenuItem := TLazRibbonQuickAccessToolBar(Source).ShowPositionMenuItem;
    ShowMinimizeRibbonMenuItem := TLazRibbonQuickAccessToolBar(Source).ShowMinimizeRibbonMenuItem;
    ShowResetToDefaultsItem := TLazRibbonQuickAccessToolBar(Source).ShowResetToDefaultsItem;
    AllowCustomizing := TLazRibbonQuickAccessToolBar(Source).AllowCustomizing;
    AllowQuickCustomizing := TLazRibbonQuickAccessToolBar(Source).AllowQuickCustomizing;
    AllowReset := TLazRibbonQuickAccessToolBar(Source).AllowReset;
    AllowPositionChange := TLazRibbonQuickAccessToolBar(Source).AllowPositionChange;
    AllowMinimizeRibbon := TLazRibbonQuickAccessToolBar(Source).AllowMinimizeRibbon;
    Images := TLazRibbonQuickAccessToolBar(Source).Images;
    ShowAboveRibbonCaption := TLazRibbonQuickAccessToolBar(Source).ShowAboveRibbonCaption;
    ShowBelowRibbonCaption := TLazRibbonQuickAccessToolBar(Source).ShowBelowRibbonCaption;
    MinimizeRibbonCaption := TLazRibbonQuickAccessToolBar(Source).MinimizeRibbonCaption;
    RestoreRibbonCaption := TLazRibbonQuickAccessToolBar(Source).RestoreRibbonCaption;
    ResetToDefaultsCaption := TLazRibbonQuickAccessToolBar(Source).ResetToDefaultsCaption;
    OnCustomizeClick := TLazRibbonQuickAccessToolBar(Source).OnCustomizeClick;
    OnMoreCommandsClick := TLazRibbonQuickAccessToolBar(Source).OnMoreCommandsClick;
  end
  else
    inherited Assign(Source);
end;

procedure TLazRibbonQuickAccessToolBar.Changed;
begin
  if (FOwner <> nil) and not (csDestroying in FOwner.ComponentState) then
    FOwner.NotifyMetricsChanged;
end;

function TLazRibbonQuickAccessToolBar.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TLazRibbonQuickAccessToolBar.SetButtonFrameStyle(AValue: TLazRibbonQuickAccessButtonFrameStyle);
begin
  if FButtonFrameStyle = AValue then Exit;
  FButtonFrameStyle := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetCustomizeActionList(AValue: TCustomActionList);
begin
  if FCustomizeActionList = AValue then Exit;
  if (FCustomizeActionList <> nil) and (FOwner <> nil) then
    FCustomizeActionList.RemoveFreeNotification(FOwner);
  FCustomizeActionList := AValue;
  if (FCustomizeActionList <> nil) and (FOwner <> nil) then
    FCustomizeActionList.FreeNotification(FOwner);
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetCustomizeMenuTitle(const AValue: String);
begin
  if FCustomizeMenuTitle = AValue then Exit;
  FCustomizeMenuTitle := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetMoreCommandsCaption(const AValue: String);
begin
  if FMoreCommandsCaption = AValue then Exit;
  FMoreCommandsCaption := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetStorageSection(const AValue: String);
begin
  if FStorageSection = AValue then Exit;
  FStorageSection := AValue;
end;

procedure TLazRibbonQuickAccessToolBar.SetShowMoreCommandsItem(AValue: Boolean);
begin
  if FShowMoreCommandsItem = AValue then Exit;
  FShowMoreCommandsItem := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetShowPositionMenuItem(AValue: Boolean);
begin
  if FShowPositionMenuItem = AValue then Exit;
  FShowPositionMenuItem := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetShowMinimizeRibbonMenuItem(AValue: Boolean);
begin
  if FShowMinimizeRibbonMenuItem = AValue then Exit;
  FShowMinimizeRibbonMenuItem := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetShowResetToDefaultsItem(AValue: Boolean);
begin
  if FShowResetToDefaultsItem = AValue then Exit;
  FShowResetToDefaultsItem := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetAllowCustomizing(AValue: Boolean);
begin
  if FAllowCustomizing = AValue then Exit;
  FAllowCustomizing := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetAllowQuickCustomizing(AValue: Boolean);
begin
  if FAllowQuickCustomizing = AValue then Exit;
  FAllowQuickCustomizing := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetAllowReset(AValue: Boolean);
begin
  if FAllowReset = AValue then Exit;
  FAllowReset := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetAllowPositionChange(AValue: Boolean);
begin
  if FAllowPositionChange = AValue then Exit;
  FAllowPositionChange := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetAllowMinimizeRibbon(AValue: Boolean);
begin
  if FAllowMinimizeRibbon = AValue then Exit;
  FAllowMinimizeRibbon := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetImages(AValue: TCustomImageList);
begin
  if FImages = AValue then Exit;
  if (FImages <> nil) and (FOwner <> nil) then
    FImages.RemoveFreeNotification(FOwner);
  FImages := AValue;
  if (FImages <> nil) and (FOwner <> nil) then
    FImages.FreeNotification(FOwner);
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetShowAboveRibbonCaption(const AValue: String);
begin
  if FShowAboveRibbonCaption = AValue then Exit;
  FShowAboveRibbonCaption := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetShowBelowRibbonCaption(const AValue: String);
begin
  if FShowBelowRibbonCaption = AValue then Exit;
  FShowBelowRibbonCaption := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetMinimizeRibbonCaption(const AValue: String);
begin
  if FMinimizeRibbonCaption = AValue then Exit;
  FMinimizeRibbonCaption := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetRestoreRibbonCaption(const AValue: String);
begin
  if FRestoreRibbonCaption = AValue then Exit;
  FRestoreRibbonCaption := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetResetToDefaultsCaption(const AValue: String);
begin
  if FResetToDefaultsCaption = AValue then Exit;
  FResetToDefaultsCaption := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetButtonSize(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  if AValue > 40 then
    AValue := 40;
  if FButtonSize = AValue then Exit;
  FButtonSize := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetFallbackGlyphStyle(AValue: TLazRibbonQuickAccessFallbackGlyphStyle);
begin
  if FFallbackGlyphStyle = AValue then Exit;
  FFallbackGlyphStyle := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetItems(AValue: TLazRibbonQuickAccessItems);
begin
  FItems.Assign(AValue);
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetPosition(AValue: TLazRibbonQuickAccessPosition);
begin
  if FPosition = AValue then Exit;
  FPosition := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetShowCustomizeButton(AValue: Boolean);
begin
  if FShowCustomizeButton = AValue then Exit;
  FShowCustomizeButton := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetSpacing(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  if AValue > 12 then
    AValue := 12;
  if FSpacing = AValue then Exit;
  FSpacing := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SetVisible(AValue: Boolean);
begin
  if FVisible = AValue then Exit;
  FVisible := AValue;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.ClearReferencesToComponent(AComponent: TComponent);
var
  I: Integer;
  ChangedRefs: Boolean;
begin
  if AComponent = nil then Exit;

  ChangedRefs := False;

  if AComponent = FCustomizeActionList then
  begin
    FCustomizeActionList := nil;
    ChangedRefs := True;
  end;

  if AComponent = FImages then
  begin
    FImages := nil;
    ChangedRefs := True;
  end;

  if FItems <> nil then
    for I := 0 to FItems.Count - 1 do
    begin
      if FItems[I].FAction = AComponent then
      begin
        FItems[I].FAction := nil;
        ChangedRefs := True;
      end;
      if FItems[I].FLinkedItem = AComponent then
      begin
        FItems[I].FLinkedItem := nil;
        ChangedRefs := True;
      end;
    end;

  { Menu items store Action pointers in Tag. If an Action/ActionList is being
    destroyed, discard the temporary customization menu to avoid stale pointers
    during shutdown. }
  if ChangedRefs and (FOwner <> nil) then
    FreeAndNil(FOwner.FQuickAccessCustomizePopup);

  if ChangedRefs and (FOwner <> nil) and
     (not (csDestroying in FOwner.ComponentState)) then
    Changed;
end;

function TLazRibbonQuickAccessToolBar.FindItemByAction(AAction: TBasicAction): TLazRibbonQuickAccessItem;
var
  I: Integer;
begin
  Result := nil;
  if AAction = nil then Exit;
  for I := 0 to FItems.Count - 1 do
  begin
    if FItems[I].Action = AAction then
    begin
      Result := FItems[I];
      Exit;
    end;
    if (FItems[I].LinkedItem is TLazRibbonBaseButton) and
       (TLazRibbonBaseButton(FItems[I].LinkedItem).Action = AAction) then
    begin
      Result := FItems[I];
      Exit;
    end;
  end;
end;

function TLazRibbonQuickAccessToolBar.ContainsAction(AAction: TBasicAction): Boolean;
begin
  Result := FindItemByAction(AAction) <> nil;
end;

function TLazRibbonQuickAccessToolBar.AddAction(AAction: TBasicAction): TLazRibbonQuickAccessItem;
var
  Linked: TLazRibbonBaseItem;
begin
  Result := FindItemByAction(AAction);
  if Result <> nil then Exit;

  Linked := nil;
  if FOwner <> nil then
    Linked := FOwner.FindQuickAccessLinkedItemForAction(AAction);

  Result := FItems.Add;
  if Linked <> nil then
    Result.LinkedItem := Linked
  else
    Result.Action := AAction;
  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.RemoveAction(AAction: TBasicAction);
var
  Item: TLazRibbonQuickAccessItem;
begin
  Item := FindItemByAction(AAction);
  if Item <> nil then
  begin
    Item.Free;
    Changed;
  end;
end;

procedure TLazRibbonQuickAccessToolBar.ToggleAction(AAction: TBasicAction);
begin
  if ContainsAction(AAction) then
    RemoveAction(AAction)
  else
    AddAction(AAction);
end;


procedure TLazRibbonQuickAccessToolBar.CaptureDefaultItems;
var
  I: Integer;
  A: TBasicAction;
  Item: TLazRibbonQuickAccessItem;
  S: String;
begin
  if FDefaultItems = nil then
    Exit;

  FDefaultItems.Clear;
  for I := 0 to FItems.Count - 1 do
  begin
    Item := FItems[I];
    A := Item.Action;
    if (A = nil) and (Item.LinkedItem is TLazRibbonBaseButton) then
      A := TLazRibbonBaseButton(Item.LinkedItem).Action;

    if (A <> nil) and (A.Name <> '') then
      S := 'A:' + A.Name
    else if (Item.LinkedItem <> nil) and (Item.LinkedItem.Name <> '') then
      S := 'L:' + Item.LinkedItem.Name
    else
      S := 'C:' + Item.Caption + '|' + IntToStr(Item.ImageIndex) + '|' + Item.Hint;

    FDefaultItems.Add(S);
  end;
  FDefaultItemsCaptured := True;
end;

function TLazRibbonQuickAccessToolBar.ResetToDefaultItems(AActionList: TCustomActionList): Boolean;
var
  I, J: Integer;
  S, Kind, Value, Rest, ImgText, HintText: String;
  A: TBasicAction;
  C: TComponent;
  Item: TLazRibbonQuickAccessItem;
begin
  Result := False;
  if (FDefaultItems = nil) or (not FDefaultItemsCaptured) then
    Exit;

  if AActionList = nil then
    AActionList := FCustomizeActionList;

  FItems.Clear;

  for I := 0 to FDefaultItems.Count - 1 do
  begin
    S := FDefaultItems[I];
    if Length(S) < 3 then
      Continue;
    Kind := Copy(S, 1, 2);
    Value := Copy(S, 3, MaxInt);

    if Kind = 'A:' then
    begin
      if AActionList <> nil then
        for J := 0 to AActionList.ActionCount - 1 do
        begin
          A := AActionList.Actions[J];
          if (A <> nil) and SameText(A.Name, Value) then
          begin
            AddAction(A);
            Result := True;
            Break;
          end;
        end;
    end
    else if Kind = 'L:' then
    begin
      if (FOwner <> nil) and (FOwner.Owner <> nil) then
      begin
        C := FOwner.Owner.FindComponent(Value);
        if C is TLazRibbonBaseItem then
        begin
          Item := FItems.Add;
          Item.LinkedItem := TLazRibbonBaseItem(C);
          Result := True;
        end;
      end;
    end
    else if Kind = 'C:' then
    begin
      Item := FItems.Add;
      Rest := Value;
      J := Pos('|', Rest);
      if J > 0 then
      begin
        Item.Caption := Copy(Rest, 1, J - 1);
        Delete(Rest, 1, J);
        J := Pos('|', Rest);
        if J > 0 then
        begin
          ImgText := Copy(Rest, 1, J - 1);
          HintText := Copy(Rest, J + 1, MaxInt);
          Item.ImageIndex := StrToIntDef(ImgText, -1);
          Item.Hint := HintText;
        end
        else
          Item.ImageIndex := StrToIntDef(Rest, -1);
      end
      else
        Item.Caption := Rest;
      Result := True;
    end;
  end;

  Changed;
end;

procedure TLazRibbonQuickAccessToolBar.SaveToIniFile(const AFileName: String; const ASection: String);
var
  Ini: TIniFile;
  SectionName: String;
  I, CountSaved: Integer;
  A: TBasicAction;
begin
  SectionName := ASection;
  if SectionName = '' then
    SectionName := FStorageSection;
  if SectionName = '' then
    SectionName := 'QuickAccessToolBar';

  Ini := TIniFile.Create(AFileName);
  try
    Ini.EraseSection(SectionName);
    { Only the user's chosen QAT commands are persisted here. Layout and
      policy options remain application-defined properties from the LFM/code. }
    CountSaved := 0;
    for I := 0 to FItems.Count - 1 do
    begin
      A := FItems[I].Action;
      if (A = nil) and (FItems[I].LinkedItem is TLazRibbonBaseButton) then
        A := TLazRibbonBaseButton(FItems[I].LinkedItem).Action;
      if (A <> nil) and (A.Name <> '') then
      begin
        Ini.WriteString(SectionName, 'Item' + IntToStr(CountSaved), A.Name);
        Inc(CountSaved);
      end;
    end;
    Ini.WriteInteger(SectionName, 'Count', CountSaved);
  finally
    Ini.Free;
  end;
end;

function TLazRibbonQuickAccessToolBar.LoadFromIniFile(const AFileName: String; AActionList: TCustomActionList; const ASection: String): Boolean;
var
  Ini: TIniFile;
  SectionName, ActionName, CountText: String;
  I, J, CountLoaded: Integer;
  A: TBasicAction;
begin
  Result := False;
  if (AActionList = nil) then
    AActionList := FCustomizeActionList;
  if (AActionList = nil) or (not FileExists(AFileName)) then Exit;

  SectionName := ASection;
  if SectionName = '' then
    SectionName := FStorageSection;
  if SectionName = '' then
    SectionName := 'QuickAccessToolBar';

  Ini := TIniFile.Create(AFileName);
  try
    CountText := Ini.ReadString(SectionName, 'Count', '');
    if CountText = '' then
      Exit;

    { A saved user configuration replaces only the QAT item list. }
    FItems.Clear;
    CountLoaded := StrToIntDef(CountText, 0);
    for I := 0 to CountLoaded - 1 do
    begin
      ActionName := Ini.ReadString(SectionName, 'Item' + IntToStr(I), '');
      if ActionName = '' then Continue;
      for J := 0 to AActionList.ActionCount - 1 do
      begin
        A := AActionList.Actions[J];
        if (A <> nil) and SameText(A.Name, ActionName) then
        begin
          AddAction(A);
          Break;
        end;
      end;
    end;
    Changed;
    Result := True;
  finally
    Ini.Free;
  end;
end;

{ TLazRibbonToolbarDispatch }

function TLazRibbonToolbarDispatch.ClientToScreen(Point: T2DIntPoint): T2DIntPoint;
begin
  {$IFDEF EnhancedRecordSupport}
  if FToolbar <> nil then
    Result := FToolbar.ClientToScreen(Point)
  else
    Result := T2DIntPoint.Create(-1, -1);
  {$ELSE}
  if FToolbar <> nil then
    Result := FToolbar.ClientToScreen(Point)
  else
    Result.Create(-1, -1);
  {$ENDIF}
end;

constructor TLazRibbonToolbarSkinProvider.Create(AToolbar: TLazRibbon);
begin
  inherited Create;
  FToolbar := AToolbar;
end;

procedure TLazRibbonToolbarSkinProvider.ClearToolbar;
begin
  FToolbar := nil;
end;

function TLazRibbonToolbarSkinProvider.GetSkinManagerObject: TObject;
begin
  if (FToolbar <> nil) and not (csDestroying in FToolbar.ComponentState) then
    Result := FToolbar.SkinManager
  else
    Result := nil;
end;

constructor TLazRibbonToolbarDispatch.Create(AToolbar: TLazRibbon);
begin
  inherited Create;
  FToolbar := AToolbar;
  FSkinProviderAdapter := TLazRibbonToolbarSkinProvider.Create(AToolbar);
  FSkinProvider := FSkinProviderAdapter;
end;

destructor TLazRibbonToolbarDispatch.Destroy;
begin
  if FSkinProviderAdapter <> nil then
    FSkinProviderAdapter.ClearToolbar;
  FSkinProvider := nil;
  FSkinProviderAdapter := nil;
  inherited Destroy;
end;

function TLazRibbonToolbarDispatch.GetTempBitmap: TBitmap;
begin
  if (FToolbar <> nil) and not (csDestroying in FToolbar.ComponentState) then
    Result := FToolbar.GetTempBitmap
  else
    Result := nil;
end;

function TLazRibbonToolbarDispatch.GetSkinProvider: ILazRibbonSkinProvider;
begin
  Result := FSkinProvider;
end;

function TLazRibbonToolbarDispatch.GetSkinManagerObject: TObject;
var
  Provider: ILazRibbonSkinProvider;
begin
  Provider := GetSkinProvider;
  if Provider <> nil then
    Result := Provider.GetSkinManagerObject
  else
    Result := nil;
end;

procedure TLazRibbonToolbarDispatch.NotifyAppearanceChanged;
begin
  if (FToolbar <> nil) and not (csDestroying in FToolbar.ComponentState) then
    FToolbar.NotifyAppearanceChanged;
end;

procedure TLazRibbonToolbarDispatch.NotifyMetricsChanged;
begin
  if (FToolbar <> nil) and not (csDestroying in FToolbar.ComponentState) then
    FToolbar.NotifyMetricsChanged;
end;

procedure TLazRibbonToolbarDispatch.NotifyItemsChanged;
begin
  if (FToolbar <> nil) and not (csDestroying in FToolbar.ComponentState) then
    FToolbar.NotifyItemsChanged;
end;

procedure TLazRibbonToolbarDispatch.NotifyVisualsChanged;
begin
  if (FToolbar <> nil) and not (csDestroying in FToolbar.ComponentState) then
    FToolbar.NotifyVisualsChanged;
end;


{ TLazRibbon }

function TLazRibbon.AtLeastOneTabVisible: boolean;
var
  i: integer;
  TabVisible: boolean;
begin
  Result := (FTabs <> nil) and (FTabs.Count > 0);
  if Result then
  begin
    TabVisible := False;
    i := FTabs.Count - 1;
    while (i >= 0) and not TabVisible do
    begin
      TabVisible := FTabs[i].Visible;
      Dec(i);
    end;
    Result := Result and TabVisible;
  end;
end;

procedure TLazRibbon.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TLazRibbon.CMMouseLeave(var msg: TLMessage);
begin
  inherited;
  MouseLeave;
end;

procedure TLazRibbon.CMHintShow(var Message: TLMessage);
var
  PanelIdx, ItemIdx: Integer;
  Item: TLazRibbonBaseItem;
  ItemHint: TTranslateString;
  ItemHintRect: TRect;
begin
  with TCMHintShow(Message).HintInfo^ do
    if HintStr <> '' then
      CursorRect := Rect(CursorPos.X, CursorPos.Y, CursorPos.X, CursorPos.Y);

  inherited;

  if FShowMenuButton and
     (TCMHintShow(Message).HintInfo^.CursorPos.X >= FMenuButtonRect.Left) and
     (TCMHintShow(Message).HintInfo^.CursorPos.X < FMenuButtonRect.Right) and
     (TCMHintShow(Message).HintInfo^.CursorPos.Y >= FMenuButtonRect.Top) and
     (TCMHintShow(Message).HintInfo^.CursorPos.Y < FMenuButtonRect.Bottom) then
  begin
    with TCMHintShow(Message).HintInfo^ do
    begin
      HintStr := FApplicationButton.EffectiveHint;
      if HintStr = '' then
        HintStr := FMenuButtonCaption;
      CursorRect := FMenuButtonRect.ForWinAPI;
      ReshowTimeout := 40;
      HideTimeout := 3000;
      Exit;
    end;
  end;

  if HelpButtonHitTest(TCMHintShow(Message).HintInfo^.CursorPos.X,
    TCMHintShow(Message).HintInfo^.CursorPos.Y) then
  begin
    with TCMHintShow(Message).HintInfo^ do
    begin
      HintStr := FHelpButtonHint;
      CursorRect := FHelpButtonRect;
      ReshowTimeout := 40;
      HideTimeout := 3000;
      Exit;
    end;
  end;

  if CollapseButtonHitTest(TCMHintShow(Message).HintInfo^.CursorPos.X,
    TCMHintShow(Message).HintInfo^.CursorPos.Y) then
  begin
    with TCMHintShow(Message).HintInfo^ do
    begin
      if FRibbonMinimized then
        HintStr := FExpandRibbonHint
      else
        HintStr := FCollapseRibbonHint;
      CursorRect := FCollapseButtonRect;
      ReshowTimeout := 40;
      HideTimeout := 3000;
      Exit;
    end;
  end;

  if QuickAccessHitTest(TCMHintShow(Message).HintInfo^.CursorPos.X,
    TCMHintShow(Message).HintInfo^.CursorPos.Y) >= 0 then
  begin
    with TCMHintShow(Message).HintInfo^ do
    begin
      ItemIdx := QuickAccessHitTest(CursorPos.X, CursorPos.Y);
      if (ItemIdx >= 0) and (ItemIdx < QuickAccessToolBar.Items.Count) then
      begin
        HintStr := QuickAccessToolBar.Items[ItemIdx].EffectiveHint;
        if HintStr = '' then
          HintStr := QuickAccessToolBar.Items[ItemIdx].EffectiveCaption;
        CursorRect := Rect(CursorPos.X, CursorPos.Y, CursorPos.X, CursorPos.Y);
        ReshowTimeout := 40;
        HideTimeout := 3000;
        Exit;
      end;
    end;
  end;

  if TabIndex >= 0 then
  begin
    PanelIdx := Tabs[TabIndex].FindPaneAt(TCMHintShow(Message).HintInfo^.CursorPos.X,
      TCMHintShow(Message).HintInfo^.CursorPos.Y);
    if PanelIdx >= 0 then
    begin
      ItemIdx := Tabs[TabIndex].Panes[PanelIdx].FindItemAt(TCMHintShow(Message).HintInfo^.CursorPos.X,
        TCMHintShow(Message).HintInfo^.CursorPos.Y);
      if ItemIdx >= 0 then
      begin
        Item := Tabs[TabIndex].Panes[PanelIdx].Items[ItemIdx];
        with TCMHintShow(Message).HintInfo^ do
        begin
          if Item.GetHintAtPos(CursorPos.X, CursorPos.Y, ItemHint, ItemHintRect) then
          begin
            HintStr := ItemHint;
            CursorRect := ItemHintRect;
            ReshowTimeout := 40;
            HideTimeout := 3000;

            if Item is TLazRibbonBaseButton then
              with Item as TLazRibbonBaseButton do
                if (ActionLink <> nil) then
                  ActionLink.DoShowHint(HintStr);
          end
          else
          begin
            HintStr := '';
            CursorRect := Rect(CursorPos.X, CursorPos.Y, CursorPos.X, CursorPos.Y);
            ReshowTimeout := 40;
          end;
        end;
      end;
    end;
  end;
end;
constructor TLazRibbon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FImagesWidth := 16;
  FLargeImagesWidth := 32;

  // Initialization of inherited property
  Align := alTop;

  //todo: not found in lcl
  //inherited AlignWithMargins:=true;

  LazInitLayoutConsts(96, Screen.PixelsPerInch);

//  Height := CalcToolbarHeight;

  //inherited Doublebuffered:=true;

  // Initialization of internal data fields
  FToolbarDispatch := TLazRibbonToolbarDispatch.Create(self);

  FBuffer := TBitmap.Create;
  FTemporary := TBitmap.Create;

  SetLength(FTabRects, 0);

  {$IFDEF EnhancedRecordSupport}
  FTabClipRect := T2DIntRect.Create(0, 0, 0, 0);
  FTabContentsClipRect := T2DIntRect.Create(0, 0, 0, 0);
  FMenuButtonRect := T2DIntRect.Create(0, 0, 0, 0);
  {$ELSE}
  FTabClipRect.Create(0, 0, 0, 0);
  FTabContentsClipRect.Create(0, 0, 0, 0);
  FMenuButtonRect.Create(0, 0, 0, 0);
  {$ENDIF}

  FMouseHoverElement := teNone;
  FMouseActiveElement := teNone;

  FTabHover := -1;

  // Initialization of fields
  FAppearance := TLazRibbonToolbarAppearance.Create(FToolbarDispatch);
  FAppearanceSource := asInternalStyle;
  FSkinManager := nil;
  FBackstageView := nil;
  FApplicationButtonMode := abmEvent;
  FRibbonMinimized := False;
  FOnRibbonMinimizedChanged := nil;
  FShowCollapseButton := True;
  FCollapseButtonState := mbtIdle;
  FCollapseButtonRect := Rect(-1, -1, -1, -1);
  FCollapseRibbonHint := 'Minimizar a Faixa de Opções';
  FExpandRibbonHint := 'Restaurar a Faixa de Opções';
  FShowHelpButton := True;
  FHelpButtonState := mbtIdle;
  FHelpButtonRect := Rect(-1, -1, -1, -1);
  FHelpButtonHint := 'Ajuda';
  FOnHelpButtonClick := nil;
  FApplicationButton := TLazRibbonApplicationButton.Create(Self);
  FQuickAccessToolBar := TLazRibbonQuickAccessToolBar.Create(Self);
  SetLength(FQuickAccessRects, 0);
  FQuickAccessCustomizeRect := Rect(-1, -1, -1, -1);
  FQuickAccessCustomizePopup := nil;
  FQuickAccessHoverIndex := -1;
  FQuickAccessActiveIndex := -1;
  FShowKeyTips := True;
  FKeyTipsVisible := False;
  FKeyTipsStage := rktsTopLevel;
  FKeyTipsPrefix := '';
  FShowContextualGroupHeaders := True;
  FContextualGroupHeaderHeight := 18;
  FTabCaptionHorizontalPadding := LAZRIBBON_DEFAULT_TAB_CAPTION_HORIZONTAL_PADDING;
  FTabCaptionSpacing := LAZRIBBON_DEFAULT_TAB_CAPTION_SPACING;
  FMinTabCaptionWidth := LAZRIBBON_DEFAULT_MIN_TAB_CAPTION_WIDTH;
  TabStop := True;
  FLastSkinApplied := False;

  FTabs := TLazRibbonTabs.Create(self);
  FTabs.ToolbarDispatch := FToolbarDispatch;
  FTabs.Appearance := FAppearance;
  FTabs.ImagesWidth := FImagesWidth;
  FTabs.LargeImagesWidth := FLargeImagesWidth;

  FTabIndex := -1;
  Color := clSkyBlue;

  FMenuButtonCaption := 'Menu';
  FMenuButtonDropdownMenu := nil;
  FMenuButtonStyle := mbsCaption;
  FShowMenuButton := False;
  FMenuButtonState := mbtIdle;

  {$IFDEF DELAYRUNTIMER}
  FDelayRunTimer := TTimer.Create(nil);
  FDelayRunTimer.Interval := 36;
  FDelayRunTimer.Enabled := False;
  FDelayRunTimer.OnTimer := DelayRunTimer
 {$ENDIF}

  Height := CalcToolbarHeight;
end;

function TLazRibbon.CalcToolbarHeight: Integer;
var
  QATExtraHeight: Integer;
begin
  if FAppearance = nil then
    Exit(0);
  Result := EffectiveContextualGroupHeaderHeight + FAppearance.Tab.CalcCaptionHeight;
  if not FRibbonMinimized then
    Inc(Result, TabHeight);
  if (FQuickAccessToolBar <> nil) and FQuickAccessToolBar.Visible and
     (FQuickAccessToolBar.Position = qapBelowRibbon) then
  begin
    if FQuickAccessToolBar.ButtonSize > 0 then
      QATExtraHeight := FQuickAccessToolBar.ButtonSize
    else
      QATExtraHeight := Max(18, FAppearance.Tab.CalcCaptionHeight - 6);
    Inc(Result, QATExtraHeight + 6);
  end;
end;

{$IFDEF DELAYRUNTIMER}
procedure TLazRibbon.DelayRunTimer(Sender: TObject);
begin
  SetMetricsInvalid;
  SetBufferInvalid;
  invalidate;
  FDelayRunTimer.Enabled := False;
end;
{$ENDIF}

procedure TLazRibbon.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Tabs', FTabs.ReadNames, FTabs.WriteNames, True);
end;

destructor TLazRibbon.Destroy;
begin
  { Descendant destructors run before TComponent.Destroy sets csDestroying.
    The QAT and skin handlers test ComponentState to avoid repaint/metric calls
    during shutdown, so set the flag before freeing internal objects. }
  Destroying;

  LazUnregisterSkinChangeHandler(Self);

  {$IFDEF DELAYRUNTIMER}
  if FDelayRunTimer <> nil then
    FDelayRunTimer.Enabled := False;
  {$ENDIF}

  { Detach callbacks and owner back-pointers before freeing subobjects.
    The AV at application close was consistent with a late notification
    reaching a Ribbon subobject after the form was already shutting down. }
  if FApplicationButton <> nil then
    FApplicationButton.FOwner := nil;

  if FQuickAccessCustomizePopup <> nil then
    FQuickAccessCustomizePopup.Items.Clear;

  FreeAndNil(FQuickAccessCustomizePopup);
  FreeAndNil(FQuickAccessToolBar);
  FreeAndNil(FTabs);
  FreeAndNil(FAppearance);
  FreeAndNil(FApplicationButton);

  if FToolbarDispatch <> nil then
  begin
    FToolbarDispatch.FToolbar := nil;
    if FToolbarDispatch.FSkinProviderAdapter <> nil then
      FToolbarDispatch.FSkinProviderAdapter.ClearToolbar;
  end;

  // Release the internal fields
  FreeAndNil(FTemporary);
  FreeAndNil(FBuffer);
  FreeAndNil(FToolbarDispatch);

 {$IFDEF DELAYRUNTIMER}
  FreeAndNil(FDelayRunTimer);
 {$ENDIF}

  inherited Destroy;
end;

procedure TLazRibbon.EndUpdate;
begin
  FUpdating := False;
  if csDestroying in ComponentState then Exit;
  ValidateMetrics;
  ValidateBuffer;
  Repaint;
end;

procedure TLazRibbon.ForceRepaint;
begin
  if csDestroying in ComponentState then Exit;
  SetMetricsInvalid;
  SetBufferInvalid;
  Repaint;
end;

procedure TLazRibbon.FreeingTab(ATab: TLazRibbonTab);
begin
  if (csDestroying in ComponentState) or (FTabs = nil) then Exit;
  FTabs.RemoveReference(ATab);
end;

function TLazRibbon.SetContextualTabsVisible(const AGroupCaption: String;
  AVisible: Boolean; ASelectFirstTab: Boolean): Integer;
var
  I: Integer;
  FirstMatchedTab: Integer;
  OldTabIndex: Integer;
  Matched: Boolean;
begin
  Result := 0;
  FirstMatchedTab := -1;

  if (csDestroying in ComponentState) or (FTabs = nil) then
    Exit;

  OldTabIndex := FTabIndex;

  for I := 0 to FTabs.Count - 1 do
  begin
    Matched := FTabs[I].Contextual and
      ((AGroupCaption = '') or SameText(FTabs[I].ContextualGroupCaption, AGroupCaption));

    if Matched then
    begin
      if FirstMatchedTab < 0 then
        FirstMatchedTab := I;

      if FTabs[I].Visible <> AVisible then
      begin
        FTabs[I].Visible := AVisible;
        Inc(Result);
      end;
    end;
  end;

  { Showing a contextual group may optionally move the selection to its first
    contextual tab.  Hiding the group must never leave the Ribbon pointing to a
    hidden tab. }
  if AVisible and ASelectFirstTab and (FirstMatchedTab >= 0) then
    TabIndex := FirstMatchedTab
  else if (not AVisible) and (OldTabIndex >= 0) and (OldTabIndex < FTabs.Count) and
          (not FTabs[OldTabIndex].Visible) then
    SetTabIndex(OldTabIndex);

  SetMetricsInvalid;
  SetBufferInvalid;
  if not (FInternalUpdating or FUpdating) then
    Invalidate;
end;

function TLazRibbon.ShowContextualTabs(const AGroupCaption: String;
  ASelectFirstTab: Boolean): Integer;
begin
  Result := SetContextualTabsVisible(AGroupCaption, True, ASelectFirstTab);
end;

function TLazRibbon.HideContextualTabs(const AGroupCaption: String): Integer;
begin
  Result := SetContextualTabsVisible(AGroupCaption, False, False);
end;

procedure TLazRibbon.HideAllContextualTabs;
begin
  SetContextualTabsVisible('', False, False);
end;

function TLazRibbon.ContextualTabsVisible(const AGroupCaption: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  if (FTabs = nil) then
    Exit;

  for I := 0 to FTabs.Count - 1 do
    if FTabs[I].Contextual and FTabs[I].Visible and
       ((AGroupCaption = '') or SameText(FTabs[I].ContextualGroupCaption, AGroupCaption)) then
      Exit(True);
end;

procedure TLazRibbon.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: integer;
begin
  inherited;
  if FTabs = nil then Exit;
  for i := 0 to FTabs.Count - 1 do
    Proc(FTabs.Items[i]);
end;

function TLazRibbon.GetColor: TColor;
begin
  Result := inherited Color;
end;

function TLazRibbon.GetTempBitmap: TBitmap;
begin
  if csDestroying in ComponentState then
    Result := nil
  else
    Result := FTemporary;
end;

procedure TLazRibbon.InternalBeginUpdate;
begin
  FInternalUpdating := True;
end;

procedure TLazRibbon.InternalEndUpdate;
begin
  FInternalUpdating := False;

  if csDestroying in ComponentState then Exit;

  //After internal changes the metrics and buffers are refreshed
  ValidateMetrics;
  ValidateBuffer;
  Repaint;
end;

procedure TLazRibbon.Loaded;
{$IF LCL_FULLVERSION = 1090000}
const
  SM_REMOTESESSION = $1000;
  // is defined only after Lazarus r57304
{$ENDIF}
begin
  inherited;

  {$IF LCL_FULLVERSION >= 1090000}
  // Needed due to changes of doublebuffering in Laz r57267
  // force DoubleBuffered if not used in remote session
  if not (csDesigning in ComponentState) then
    DoubleBuffered := DoubleBuffered or (GetSystemMetrics(SM_REMOTESESSION)=0);
  {$ENDIF}

  InternalBeginUpdate;

  if FTabs.ListState = lsNeedsProcessing then
    FTabs.ProcessNames(self.Owner);

  if FQuickAccessToolBar <> nil then
    FQuickAccessToolBar.CaptureDefaultItems;

  InternalEndUpdate;

  //The process of internal update always refreshes metrics and buffer at the end
  //and draws component
end;

procedure TLazRibbon.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  inherited MouseDown(Button, Shift, X, Y);

  if CanFocus then
    SetFocus;

  { Office-like KeyTips are keyboard navigation aids. Any mouse action leaves
    the keyboard navigation mode and returns the Ribbon to its normal visual
    state before processing the click. }
  if FKeyTipsVisible then
    HideKeyTips;

  //It is possible that the other mouse button was pressed
  //In this situation active object receives next notification
  if FMouseActiveElement = teTabs then
  begin
    TabMouseDown(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teCollapseButton then
  begin
    CollapseButtonMouseDown(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teHelpButton then
  begin
    HelpButtonMouseDown(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teQuickAccessToolBar then
  begin
    QuickAccessMouseDown(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teMenuButton then
  begin
    MenuButtonMouseDown(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teTabContents then
  begin
    if FTabIndex <> -1 then
      FTabs[FTabIndex].MouseDown(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teToolbarArea then
  begin
    //Placeholder if there will be need to use this event
  end
  else
  //If there is no active element, the active element will be one
  //which is now under the mouse
  if FMouseActiveElement = teNone then
  begin
    if FMouseHoverElement = teTabs then
    begin
      FMouseActiveElement := teTabs;
      TabMouseDown(Button, Shift, X, Y);
    end
    else
    if FMouseHoverElement = teCollapseButton then
    begin
      FMouseActiveElement := teCollapseButton;
      CollapseButtonMouseDown(Button, Shift, X, Y);
    end
    else
    if FMouseHoverElement = teHelpButton then
    begin
      FMouseActiveElement := teHelpButton;
      HelpButtonMouseDown(Button, Shift, X, Y);
    end
    else
    if FMouseHoverElement = teQuickAccessToolBar then
    begin
      FMouseActiveElement := teQuickAccessToolBar;
      QuickAccessMouseDown(Button, Shift, X, Y);
    end
    else
    if FMouseHoverElement = teMenuButton then
    begin
      FMouseActiveElement := teMenuButton;
      MenuButtonMouseDown(Button, Shift, X, Y);
    end
    else
    if FMouseHoverElement = teTabContents then
    begin
      FMouseActiveElement := teTabContents;
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseDown(Button, Shift, X, Y);
    end
    else
    if FMouseHoverElement = teToolbarArea then
    begin
      FMouseActiveElement := teToolbarArea;
      //Placeholder if there will be need to use this event
    end;
  end;
end;

procedure TLazRibbon.MouseLeave;
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  //MouseLeave has no chance to be called for active object
  //because when the mouse button is pressed every mouse move is transfered
  //as MouseMove. If the mouse left from component region then
  //MouseLeave will be called just after MouseUp but MouseUp cleans the
  //active object
  if FMouseActiveElement = teNone then
  begin
    //If there is no active element, the elements under mouse will be supported
    if FMouseHoverElement = teTabs then
    begin
      TabMouseLeave;
    end
    else
    if FMouseHoverElement = teCollapseButton then
    begin
      CollapseButtonMouseLeave;
    end
    else
    if FMouseHoverElement = teHelpButton then
    begin
      HelpButtonMouseLeave;
    end
    else
    if FMouseHoverElement = teQuickAccessToolBar then
    begin
      QuickAccessMouseLeave;
    end
    else
    if FMouseHoverElement = teMenuButton then
    begin
      MenuButtonMouseLeave;
    end
    else
    if FMouseHoverElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseLeave;
    end
    else
    if FMouseHoverElement = teToolbarArea then
    begin
      //Placeholder if there will be need to use this event
    end;
  end;

  FMouseHoverElement := teNone;
end;

procedure TLazRibbon.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewMouseHoverElement: TLazRibbonMouseToolbarElement;
  MousePoint: T2DIntVector;
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  inherited MouseMove(Shift, X, Y);

  //Checking which element is under the mouse
  {$IFDEF EnhancedRecordSupport}
  MousePoint := T2DIntVector.Create(x, y);
  {$ELSE}
  MousePoint.Create(x, y);
  {$ENDIF}

  // QuickAccessToolBar can be drawn either on the tab strip (qapBeforeTabs)
  // or in its own row below the tabs (qapBelowRibbon). Therefore its hit-test
  // must be evaluated before the generic tab/tab-content regions. Otherwise,
  // when it is below the ribbon tabs, clicks are incorrectly routed to the
  // active tab contents and the QAT buttons stop responding.
  if QuickAccessHitTest(X, Y) <> -1 then
    NewMouseHoverElement := teQuickAccessToolBar
  else if HelpButtonHitTest(X, Y) then
    NewMouseHoverElement := teHelpButton
  else if CollapseButtonHitTest(X, Y) then
    NewMouseHoverElement := teCollapseButton
  else if FTabClipRect.Contains(MousePoint) then
  begin
    NewMouseHoverElement := teTabs;
    if FMenuButtonRect.Contains(MousePoint) and FShowMenuButton then
      NewMouseHoverElement := teMenuButton;
  end
  else
  if FTabContentsClipRect.Contains(MousePoint) then
    NewMouseHoverElement := teTabContents
  else
  if (X >= 0) and (Y >= 0) and (X < self.Width) and (Y < self.Height) then
    NewMouseHoverElement := teToolbarArea
  else
    NewMouseHoverElement := teNone;

  //If there is an active element then it has exlusiveness for messages
  if FMouseActiveElement = teTabs then
  begin
    TabMouseMove(Shift, X, Y);
  end
  else
  if FMouseActiveElement = teCollapseButton then
  begin
    CollapseButtonMouseMove(Shift, X, Y);
  end
  else
  if FMouseActiveElement = teHelpButton then
  begin
    HelpButtonMouseMove(Shift, X, Y);
  end
  else
  if FMouseActiveElement = teQuickAccessToolBar then
  begin
    QuickAccessMouseMove(Shift, X, Y);
  end
  else
  if FMouseActiveElement = teMenuButton then
  begin
    MenuButtonMouseMove(Shift, X, Y);
  end
  else
  if FMouseActiveElement = teTabContents then
  begin
    if FTabIndex <> -1 then
      FTabs[FTabIndex].MouseMove(Shift, X, Y);
  end
  else
  if FMouseActiveElement = teToolbarArea then
  begin
    //Placeholder if there will be need to use this event
  end
  else
  if FMouseActiveElement = teNone then
  begin
    //If element changes under the mouse, then previous element will be informed
    //that mouse is leaving its region
    if NewMouseHoverElement <> FMouseHoverElement then
    begin
      if FMouseHoverElement = teTabs then
      begin
        TabMouseLeave;
      end
      else
      if FMouseHoverElement = teCollapseButton then
      begin
        CollapseButtonMouseLeave;
      end
      else
      if FMouseHoverElement = teHelpButton then
      begin
        HelpButtonMouseLeave;
      end
      else
      if FMouseHoverElement = teQuickAccessToolBar then
      begin
        QuickAccessMouseLeave;
      end
      else
      if FMouseHoverElement = teMenuButton then
      begin
        MenuButtonMouseLeave;
      end
      else
      if FMouseHoverElement = teTabContents then
      begin
        if FTabIndex <> -1 then
          FTabs[FTabIndex].MouseLeave;
      end
      else
      if FMouseHoverElement = teToolbarArea then
      begin
        //Placeholder if there will be need to use this event
      end;
    end;

    //Element under mouse receives MouseMove
    if NewMouseHoverElement = teTabs then
    begin
      TabMouseMove(Shift, X, Y);
    end
    else
    if NewMouseHoverElement = teCollapseButton then
    begin
      CollapseButtonMouseMove(Shift, X, Y);
    end
    else
    if NewMouseHoverElement = teHelpButton then
    begin
      HelpButtonMouseMove(Shift, X, Y);
    end
    else
    if NewMouseHoverElement = teQuickAccessToolBar then
    begin
      QuickAccessMouseMove(Shift, X, Y);
    end
    else
    if NewMouseHoverElement = teMenuButton then
    begin
      MenuButtonMouseMove(Shift, X, Y);
    end
    else
    if NewMouseHoverElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseMove(Shift, X, Y);
    end
    else
    if NewMouseHoverElement = teToolbarArea then
    begin
      //Placeholder if there will be need to use this event
    end;
  end;

  FMouseHoverElement := NewMouseHoverElement;
end;

procedure TLazRibbon.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ClearActive: boolean;
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  inherited MouseUp(Button, Shift, X, Y);

  ClearActive := not (ssLeft in Shift) and not (ssMiddle in Shift) and not (ssRight in Shift);

  //If there is an active element then it has exlusiveness for messages
  if FMouseActiveElement = teTabs then
  begin
    TabMouseUp(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teCollapseButton then
  begin
    CollapseButtonMouseUp(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teHelpButton then
  begin
    HelpButtonMouseUp(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teQuickAccessToolBar then
  begin
    QuickAccessMouseUp(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teMenuButton then
  begin
    MenuButtonMouseUp(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teTabContents then
  begin
    if FTabIndex <> -1 then
      FTabs[FTabIndex].MouseUp(Button, Shift, X, Y);
  end
  else
  if FMouseActiveElement = teToolbarArea then
  begin
    //Placeholder if there will be need to use this event
  end;

  //If the last mouse button is released and mouse doesn't locate over
  //the active object, it must additionally call MouseLeave for active one
  //and MouseMove for object being under mouse
  if ClearActive and (FMouseActiveElement <> FMouseHoverElement) then
  begin
    if FMouseActiveElement = teTabs then
      TabMouseLeave
    else
    if FMouseActiveElement = teCollapseButton then
      CollapseButtonMouseLeave
    else
    if FMouseActiveElement = teHelpButton then
      HelpButtonMouseLeave
    else
    if FMouseActiveElement = teQuickAccessToolBar then
      QuickAccessMouseLeave
    else
    if FMouseActiveElement = teMenuButton then
      MenuButtonMouseLeave
    else
    if FMouseActiveElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseLeave;
    end
    else
    if FMouseActiveElement = teToolbarArea then
    begin
      //Placeholder if there will be need to use this event
    end;

    if FMouseHoverElement = teTabs then
      TabMouseMove(Shift, X, Y)
    else
    if FMouseHoverElement = teCollapseButton then
      CollapseButtonMouseMove(Shift, X, Y)
    else
    if FMouseHoverElement = teHelpButton then
      HelpButtonMouseMove(Shift, X, Y)
    else
    if FMouseHoverElement = teQuickAccessToolBar then
      QuickAccessMouseMove(Shift, X, Y)
    else
    if FMouseHoverElement = teMenuButton then
      MenuButtonMouseMove(Shift, X, Y)
    else
    if FMouseHoverElement = teTabContents then
    begin
      if FTabIndex <> -1 then
        FTabs[FTabIndex].MouseMove(Shift, X, Y);
    end
    else
    if FMouseHoverElement = teToolbarArea then
    begin
      //Placeholder if there will be need to use this event
    end;
  end;

  //MouseUp swiches off active object, when all mouse buttons were released
  if ClearActive then
    FMouseActiveElement := teNone;
end;

procedure TLazRibbon.Notification(AComponent: TComponent; Operation: TOperation);
var
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Item: TLazRibbonBaseItem;
begin
  inherited;

  if Operation <> opRemove then
    exit;

  { During destruction the internal collections (tabs, panes, QAT popup,
    appearance and buffers) can already be partially freed.  Do not route
    component-removal notifications back into those collections.  Only clear
    direct references that are safe and then leave. }
  if csDestroying in ComponentState then
  begin
    if AComponent = FSkinManager then
    begin
      LazUnregisterSkinChangeHandler(Self);
      FSkinManager := nil;
      FLastSkinApplied := False;
    end;
    if AComponent = FBackstageView then
      FBackstageView := nil;
    if AComponent = FMenuButtonDropDownMenu then
      FMenuButtonDropDownMenu := nil;
    if AComponent = DisabledImages then
      DisabledImages := nil;
    if AComponent = DisabledLargeImages then
      DisabledLargeImages := nil;
    if AComponent = Images then
      Images := nil;
    if AComponent = LargeImages then
      LargeImages := nil;
    Exit;
  end;

  if FQuickAccessToolBar <> nil then
    FQuickAccessToolBar.ClearReferencesToComponent(AComponent);

  if AComponent = FSkinManager then
  begin
    LazUnregisterSkinChangeHandler(Self);
    FSkinManager := nil;
    FLastSkinApplied := False;
    ConfigureBackstageView;
  end;

  if AComponent = FBackstageView then
  begin
    FBackstageView := nil;
    if FApplicationButtonMode = abmBackstage then
      FApplicationButtonMode := abmEvent;
  end;

  if AComponent is TLazRibbonTab then
  begin
    FreeingTab(AComponent as TLazRibbonTab);
  end
  else
  if AComponent is TLazRibbonPane then
  begin
    Pane := AComponent as TLazRibbonPane;
    if (Pane.Parent <> nil) and (Pane.Parent is TLazRibbonTab) then
    begin
      Tab := Pane.Parent as TLazRibbonTab;
      Tab.FreeingPane(Pane);
    end;
  end
  else
  if AComponent is TLazRibbonBaseItem then
  begin
    Item := AComponent as TLazRibbonBaseItem;
    if (Item.Parent <> nil) and (Item.Parent is TLazRibbonPane) then
    begin
      Pane := Item.Parent as TLazRibbonPane;
      Pane.FreeingItem(Item);
    end;
  end else
  if AComponent is TCustomImageList then
  begin
    if AComponent = DisabledImages then
      DisabledImages := nil;
    if AComponent = DisabledLargeImages then
      DisabledLargeImages := nil;
    if AComponent = Images then
      Images := nil;
    if AComponent = LargeImages then
      LargeImages := nil;
  end else
  if AComponent = FMenuButtonDropDownMenu then
  begin
    FMenuButtonDropDownMenu := nil;
    if FApplicationButtonMode = abmPopupMenu then
      FApplicationButtonMode := abmEvent;
  end;

  // Remove DropdownMenu from button items.
  if AComponent is TPopupMenu then
    Tabs.Notify(AComponent, Operation);
end;

procedure TLazRibbon.NotifyAppearanceChanged;
begin
  if csDestroying in ComponentState then Exit;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.NotifyMetricsChanged;
begin
  if csDestroying in ComponentState then Exit;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.NotifyItemsChanged;
var
  OldTabIndex: integer;
begin
  if csDestroying in ComponentState then Exit;
  OldTabIndex := FTabIndex;
  // Fixed TabIndex when you need it
  if not (AtLeastOneTabVisible) then
    FTabIndex := -1
  else
  begin
    FTabIndex := max(0, min(FTabs.Count - 1, FTabIndex));

    //I know that at least one tab is visible (from previous condition)
    //so below loop will finish
    while not (FTabs[FTabIndex].Visible) do
      FTabIndex := (FTabIndex + 1) mod FTabs.Count;
  end;
  FTabHover := -1;

  if DoTabChanging(OldTabIndex, FTabIndex) then
  begin
    SetMetricsInvalid;

    if not (FInternalUpdating or FUpdating) then
      Repaint;

    if Assigned(FOnTabChanged) then
      FOnTabChanged(self);
  end
  else
    FTabIndex := OldTabIndex;

end;

procedure TLazRibbon.NotifyVisualsChanged;
begin
  if csDestroying in ComponentState then Exit;
  SetBufferInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.Paint;
begin
  if (csDestroying in ComponentState) or (FBuffer = nil) then Exit;

  //If the rebuilding process (internal or by user) is running now
  //then validation of metrics and buffer is not running, however
  //the buffer is drawn in a shape what was remembered before rebuilding process
  if not (FInternalUpdating or FUpdating) then
  begin
    ApplySkinManagerAppearance;
    if not (FMetricsValid) then
      ValidateMetrics;
    if not (FBufferValid) then
      ValidateBuffer;
  end;

 {$IFDEF LCLCocoa}
  StretchBlt(
    Canvas.Handle, 0, 0, Width, Height,
    FBuffer.Canvas.Handle, 0, 0, FBuffer.Width, FBuffer.Height,
    SRCCOPY
  );
 {$ELSE}
  Canvas.Draw(0, 0, FBuffer);
 {$ENDIF}
end;

procedure TLazRibbon.DoOnResize;
begin
  {
  if Height <> ToolbarHeight then
    Height := ToolbarHeight;
  }

 {$IFDEF DELAYRUNTIMER}
  FDelayRunTimer.Enabled := False;
  FDelayRunTimer.Enabled := True;
 {$ELSE}
  SetMetricsInvalid;
  SetBufferInvalid;
 {$ENDIF}

  if not (FInternalUpdating or FUpdating) then
    invalidate;

  inherited;
end;
                      (*
procedure TLazRibbon.EraseBackground(DC: HDC);
begin
  // The correct implementation is doing nothing
  if ThemeServices.ThemesEnabled then
    inherited;   // wp: this calls FillRect!
  // "inherited" removed in case of no themes to fix issue #0025047 (flickering
  // when using standard windows theme or when manifest file is off)
end;                    *)

procedure TLazRibbon.SetBufferInvalid;
begin
  FBufferValid := False;
end;

procedure TLazRibbon.SetColor(Value: TColor);
begin
  inherited Color := Value;
  SetBufferInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.SetDisabledImages(const Value: TImageList);
begin
  FDisabledImages := Value;
  FTabs.DisabledImages := Value;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.SetDisabledLargeImages(const Value: TImageList);
begin
  FDisabledLargeImages := Value;
  FTabs.DisabledLargeImages := Value;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.SetImages(const Value: TImageList);
begin
  FImages := Value;
  FTabs.Images := Value;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.SetLargeImages(const Value: TImageList);
begin
  FLargeImages := Value;
  FTabs.LargeImages := Value;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;


procedure TLazRibbon.ApplySkinManagerAppearance;
begin
  if (FAppearanceSource <> asSkinManager) or (FSkinManager = nil) then
    Exit;

  { The SkinManager now owns a full TLazRibbonToolbarAppearance object. Do not
    rebuild the toolbar appearance on every Paint; Apply is triggered when the
    manager notifies a change and resets FLastSkinApplied. }
  if FLastSkinApplied then
    Exit;

  FLastSkinPalette := FSkinManager.Palette;
  FLastSkinApplied := True;

  Color := FSkinManager.Palette.RibbonTopColor;
  FAppearance.Assign(FSkinManager.Appearance);

  SetMetricsInvalid;
  SetBufferInvalid;
end;

function TLazRibbon.IsSkinPaletteChanged(const APalette: TLazRibbonSkinPalette): Boolean;
begin
  Result := (not FLastSkinApplied) or
    (FLastSkinPalette.BackColor <> APalette.BackColor) or
    (FLastSkinPalette.NavigationColor <> APalette.NavigationColor) or
    (FLastSkinPalette.ActiveColor <> APalette.ActiveColor) or
    (FLastSkinPalette.HotColor <> APalette.HotColor) or
    (FLastSkinPalette.FrameColor <> APalette.FrameColor) or
    (FLastSkinPalette.TextColor <> APalette.TextColor) or
    (FLastSkinPalette.MutedTextColor <> APalette.MutedTextColor) or
    (FLastSkinPalette.RibbonTopColor <> APalette.RibbonTopColor) or
    (FLastSkinPalette.RibbonBottomColor <> APalette.RibbonBottomColor) or
    (FLastSkinPalette.RibbonTabActiveColor <> APalette.RibbonTabActiveColor) or
    (FLastSkinPalette.RibbonTabHotColor <> APalette.RibbonTabHotColor) or
    (FLastSkinPalette.RibbonGroupColor <> APalette.RibbonGroupColor) or
    (FLastSkinPalette.RibbonGroupFrameColor <> APalette.RibbonGroupFrameColor);
end;

procedure TLazRibbon.SetAppearanceSource(AValue: TLazRibbonAppearanceSource);
begin
  if FAppearanceSource = AValue then Exit;
  FAppearanceSource := AValue;
  FLastSkinApplied := False;
  if FAppearanceSource = asSkinManager then
    ApplySkinManagerAppearance
  else
    SetStyle(FStyle);
  ForceRepaint;
end;

procedure TLazRibbon.SetSkinManager(AValue: TLazRibbonSkinManager);
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
  end;
  { When a SkinManager is assigned, the toolbar should use it immediately.
    Requiring the user to also set AppearanceSource=asSkinManager makes the
    SkinGallery update the manager while the Ribbon keeps painting the old
    internal style.  Keep existing explicit modes, but switch the default
    internal mode to the SkinManager mode automatically. }
  if (FSkinManager <> nil) and (FAppearanceSource = asInternalStyle) then
    FAppearanceSource := asSkinManager;

  FLastSkinApplied := False;
  if FAppearanceSource = asSkinManager then
    ApplySkinManagerAppearance;
  ConfigureBackstageView;
  ForceRepaint;
end;

procedure TLazRibbon.ConfigureBackstageView;
begin
  if FBackstageView = nil then
    Exit;

  FBackstageView.AttachToRibbonComponent(Self, FMenuButtonCaption);
  FBackstageView.SetRibbonSkinProvider(FToolbarDispatch.GetSkinProvider);
end;

procedure TLazRibbon.SetBackstageView(AValue: TLazRibbonCustomBackstageView);
begin
  if FBackstageView = AValue then Exit;

  if FBackstageView <> nil then
  begin
    FBackstageView.DetachFromRibbonComponent(Self);
    FBackstageView.RemoveFreeNotification(Self);
  end;

  FBackstageView := AValue;

  if FBackstageView <> nil then
  begin
    FBackstageView.FreeNotification(Self);
    FApplicationButtonMode := abmBackstage;
    SetShowMenuButton(True);
    ConfigureBackstageView;
  end
  else if FApplicationButtonMode = abmBackstage then
    FApplicationButtonMode := abmEvent;
end;

procedure TLazRibbon.SkinManagerChanged(Sender: TObject);
begin
  if Sender <> FSkinManager then
    Exit;
  FLastSkinApplied := False;
  if FAppearanceSource = asSkinManager then
    ApplySkinManagerAppearance;
  if FBackstageView <> nil then
    FBackstageView.Invalidate;
  ForceRepaint;
end;

procedure TLazRibbon.SetApplicationButton(AValue: TLazRibbonApplicationButton);
begin
  if (AValue <> nil) and (FApplicationButton <> nil) then
    FApplicationButton.Assign(AValue);
end;

procedure TLazRibbon.SetApplicationButtonMode(AValue: TLazRibbonApplicationButtonMode);
begin
  if FApplicationButtonMode = AValue then Exit;
  FApplicationButtonMode := AValue;

  if FApplicationButtonMode in [abmPopupMenu, abmBackstage] then
    SetShowMenuButton(True);

  if FApplicationButtonMode = abmBackstage then
    ConfigureBackstageView;
end;


procedure TLazRibbon.SetQuickAccessToolBar(AValue: TLazRibbonQuickAccessToolBar);
begin
  if (AValue <> nil) and (FQuickAccessToolBar <> nil) then
    FQuickAccessToolBar.Assign(AValue);
end;

procedure TLazRibbon.SetRibbonMinimized(AValue: Boolean);
begin
  if FRibbonMinimized = AValue then Exit;
  FRibbonMinimized := AValue;

  { The BackStage remains controlled by its own close logic.  RibbonMinimized
    only affects the visibility/layout of the normal Ribbon pane area. }
  SetMetricsInvalid;
  SetBufferInvalid;
  Invalidate;
  if Assigned(FOnRibbonMinimizedChanged) then
    FOnRibbonMinimizedChanged(Self);
end;

procedure TLazRibbon.SetShowCollapseButton(AValue: Boolean);
begin
  if FShowCollapseButton = AValue then Exit;
  FShowCollapseButton := AValue;
  FCollapseButtonState := mbtIdle;
  SetMetricsInvalid;
  SetBufferInvalid;
  Invalidate;
end;

procedure TLazRibbon.SetCollapseRibbonHint(const AValue: String);
begin
  if FCollapseRibbonHint = AValue then Exit;
  FCollapseRibbonHint := AValue;
end;

procedure TLazRibbon.SetExpandRibbonHint(const AValue: String);
begin
  if FExpandRibbonHint = AValue then Exit;
  FExpandRibbonHint := AValue;
end;

function TLazRibbon.CollapseButtonHitTest(X, Y: Integer): Boolean;
begin
  Result := FShowCollapseButton and
    (FCollapseButtonRect.Right > FCollapseButtonRect.Left) and
    (FCollapseButtonRect.Bottom > FCollapseButtonRect.Top) and
    PtInRect(FCollapseButtonRect, Point(X, Y));
end;

procedure TLazRibbon.CollapseButtonMouseLeave;
begin
  if csDestroying in ComponentState then Exit;
  if FCollapseButtonState <> mbtIdle then
  begin
    FCollapseButtonState := mbtIdle;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.CollapseButtonMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if csDestroying in ComponentState then Exit;
  if FCollapseButtonState <> mbtHottrack then
  begin
    FCollapseButtonState := mbtHottrack;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.CollapseButtonMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if csDestroying in ComponentState then Exit;
  if Button <> mbLeft then Exit;
  FCollapseButtonState := mbtPressed;
  SetBufferInvalid;
  Repaint;
end;

procedure TLazRibbon.CollapseButtonMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if csDestroying in ComponentState then Exit;
  if Button = mbLeft then
  begin
    if CollapseButtonHitTest(X, Y) then
    begin
      RibbonMinimized := not RibbonMinimized;
      FCollapseButtonState := mbtHottrack;
    end
    else
      FCollapseButtonState := mbtIdle;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.SetShowHelpButton(AValue: Boolean);
begin
  if FShowHelpButton = AValue then Exit;
  FShowHelpButton := AValue;
  FHelpButtonState := mbtIdle;
  SetMetricsInvalid;
  SetBufferInvalid;
  Invalidate;
end;

procedure TLazRibbon.SetHelpButtonHint(const AValue: String);
begin
  if FHelpButtonHint = AValue then Exit;
  FHelpButtonHint := AValue;
end;

function TLazRibbon.HelpButtonHitTest(X, Y: Integer): Boolean;
begin
  Result := FShowHelpButton and
    (FHelpButtonRect.Right > FHelpButtonRect.Left) and
    (FHelpButtonRect.Bottom > FHelpButtonRect.Top) and
    PtInRect(FHelpButtonRect, Point(X, Y));
end;

procedure TLazRibbon.HelpButtonMouseLeave;
begin
  if FHelpButtonState <> mbtIdle then
  begin
    FHelpButtonState := mbtIdle;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.HelpButtonMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FHelpButtonState <> mbtHottrack then
  begin
    FHelpButtonState := mbtHottrack;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.HelpButtonMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then Exit;
  FHelpButtonState := mbtPressed;
  SetBufferInvalid;
  Repaint;
end;

procedure TLazRibbon.HelpButtonMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if HelpButtonHitTest(X, Y) then
    begin
      FHelpButtonState := mbtHottrack;
      if Assigned(FOnHelpButtonClick) then
        FOnHelpButtonClick(Self);
    end
    else
      FHelpButtonState := mbtIdle;
    SetBufferInvalid;
    Repaint;
  end;
end;

function TLazRibbon.FindQuickAccessLinkedItemForAction(AAction: TBasicAction): TLazRibbonBaseItem;
var
  I, J, K: Integer;
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Item: TLazRibbonBaseItem;
begin
  Result := nil;
  if (AAction = nil) or (FTabs = nil) then
    Exit;

  for I := 0 to FTabs.Count - 1 do
  begin
    Tab := FTabs[I];
    if (Tab = nil) or (Tab.Panes = nil) then
      Continue;
    for J := 0 to Tab.Panes.Count - 1 do
    begin
      Pane := Tab.Panes[J];
      if (Pane = nil) or (Pane.Items = nil) then
        Continue;
      for K := 0 to Pane.Items.Count - 1 do
      begin
        Item := Pane.Items[K];
        if (Item is TLazRibbonBaseButton) and
           (TLazRibbonBaseButton(Item).Action = AAction) then
        begin
          Result := Item;
          Exit;
        end;
      end;
    end;
  end;
end;



procedure TLazRibbon.InvalidateHostedTitleBar;
var
  HostForm: TCustomForm;

  procedure InvalidateTitleBarsIn(AParent: TWinControl);
  var
    I: Integer;
    C: TControl;
  begin
    if AParent = nil then Exit;

    for I := 0 to AParent.ControlCount - 1 do
    begin
      C := AParent.Controls[I];
      if SameText(C.ClassName, 'TLazRibbonTitleBar') then
        C.Invalidate;
      if C is TWinControl then
        InvalidateTitleBarsIn(TWinControl(C));
    end;
  end;

begin
  HostForm := GetParentForm(Self);
  if HostForm <> nil then
    InvalidateTitleBarsIn(HostForm)
  else if Parent <> nil then
    InvalidateTitleBarsIn(Parent);
end;

procedure TLazRibbon.SetShowKeyTips(AValue: Boolean);
begin
  if FShowKeyTips = AValue then Exit;
  FShowKeyTips := AValue;
  if not FShowKeyTips then
  begin
    FKeyTipsVisible := False;
    FKeyTipsStage := rktsTopLevel;
    FKeyTipsPrefix := '';
  end;
  SetBufferInvalid;
  Invalidate;
  InvalidateHostedTitleBar;
end;

procedure TLazRibbon.SetKeyTipsVisible(AValue: Boolean);
var
  DesiredVisible: Boolean;
begin
  DesiredVisible := AValue and FShowKeyTips;

  if FKeyTipsVisible = DesiredVisible then
  begin
    if DesiredVisible and (FKeyTipsStage <> rktsTopLevel) then
    begin
      { Reopening an already visible overlay through the public property should
        still return to the root KeyTips map. }
      FKeyTipsStage := rktsTopLevel;
      FKeyTipsPrefix := '';
      SetBufferInvalid;
      Invalidate;
      InvalidateHostedTitleBar;
    end;
    Exit;
  end;

  FKeyTipsVisible := DesiredVisible;
  { Opening the overlay always starts with the Office-like top-level map:
    Application Button, visible tabs and QAT.  After a tab KeyTip is pressed,
    the overlay advances to the active-tab command map. }
  FKeyTipsStage := rktsTopLevel;
  FKeyTipsPrefix := '';
  SetBufferInvalid;
  Invalidate;
  InvalidateHostedTitleBar;
end;

function TLazRibbon.KeyTipsTopLevelVisible: Boolean;
begin
  Result := FShowKeyTips and FKeyTipsVisible and (FKeyTipsStage = rktsTopLevel);
end;

function TLazRibbon.KeyTipsActiveTabCommandsVisible: Boolean;
begin
  Result := FShowKeyTips and FKeyTipsVisible and (FKeyTipsStage = rktsActiveTabCommands);
end;

function TLazRibbon.KeyTipsPrefix: String;
begin
  Result := FKeyTipsPrefix;
end;

function TLazRibbon.EffectiveContextualGroupHeaderHeight: Integer;
var
  I: Integer;
begin
  Result := 0;
  if (not FShowContextualGroupHeaders) or
     (FContextualGroupHeaderHeight <= 0) or
     (FTabs = nil) then
    Exit;

  for I := 0 to FTabs.Count - 1 do
    if FTabs[I].Visible and FTabs[I].Contextual and
       (Trim(FTabs[I].ContextualGroupCaption) <> '') then
    begin
      Result := FContextualGroupHeaderHeight;
      Exit;
    end;
end;

procedure TLazRibbon.SetShowContextualGroupHeaders(AValue: Boolean);
begin
  if FShowContextualGroupHeaders = AValue then Exit;
  FShowContextualGroupHeaders := AValue;
  SetMetricsInvalid;
  SetBufferInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.SetContextualGroupHeaderHeight(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  if AValue > 48 then
    AValue := 48;
  if FContextualGroupHeaderHeight = AValue then Exit;
  FContextualGroupHeaderHeight := AValue;
  SetMetricsInvalid;
  SetBufferInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.SetTabCaptionHorizontalPadding(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  if AValue > 64 then
    AValue := 64;
  if FTabCaptionHorizontalPadding = AValue then Exit;
  FTabCaptionHorizontalPadding := AValue;
  NotifyMetricsChanged;
end;

procedure TLazRibbon.SetTabCaptionSpacing(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  if AValue > 32 then
    AValue := 32;
  if FTabCaptionSpacing = AValue then Exit;
  FTabCaptionSpacing := AValue;
  NotifyMetricsChanged;
end;

procedure TLazRibbon.SetMinTabCaptionWidth(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  if AValue > 300 then
    AValue := 300;
  if FMinTabCaptionWidth = AValue then Exit;
  FMinTabCaptionWidth := AValue;
  NotifyMetricsChanged;
end;

procedure TLazRibbon.ShowKeyTipsOverlay;
begin
  KeyTipsVisible := True;
end;

procedure TLazRibbon.HideKeyTips;
begin
  KeyTipsVisible := False;
end;

procedure TLazRibbon.ToggleKeyTips;
begin
  KeyTipsVisible := not FKeyTipsVisible;
end;

function TLazRibbon.HandleKeyTipsBackspace: Boolean;
begin
  Result := False;
  if (not FShowKeyTips) or (not FKeyTipsVisible) then
    Exit;

  if FKeyTipsPrefix <> '' then
    Delete(FKeyTipsPrefix, Length(FKeyTipsPrefix), 1)
  else if FKeyTipsStage = rktsActiveTabCommands then
    FKeyTipsStage := rktsTopLevel
  else
    Exit;

  SetBufferInvalid;
  Invalidate;
  InvalidateHostedTitleBar;
  Result := True;
end;

function TLazRibbon.ProcessKeyTipsBackspace: Boolean;
begin
  Result := HandleKeyTipsBackspace;
end;

procedure TLazRibbon.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);

  { Some Lazarus/LCL widgetsets deliver Backspace as a character event instead
    of, or in addition to, VK_BACK in KeyDown.  Keep the KeyTips prefix editor
    robust by handling #8 here as well. }
  if (Key = #8) and HandleKeyTipsBackspace then
    Key := #0;
end;

procedure TLazRibbon.KeyDown(var Key: Word; Shift: TShiftState);
var
  I: Integer;
  Pressed: String;
  NextPrefix: String;
  Tip: String;

  function CleanKeyTip(const S: String): String;
  begin
    Result := UpperCase(Trim(StringReplace(S, '&', '', [rfReplaceAll])));
  end;

  function FirstCaptionKey(const S: String): String;
  var
    Clean: String;
  begin
    Clean := StringReplace(Trim(S), '&', '', [rfReplaceAll]);
    if Clean <> '' then
      Result := UpperCase(Copy(Clean, 1, 1))
    else
      Result := '';
  end;

  function KeyTipStartsWith(const ATip, APrefix: String): Boolean;
  begin
    Result := (ATip <> '') and (APrefix <> '') and
      (Copy(ATip, 1, Length(APrefix)) = APrefix);
  end;

  function ApplicationKeyTipText: String;
  begin
    Result := CleanKeyTip(FApplicationButton.KeyTip);
    if Result = '' then
      Result := FirstCaptionKey(FMenuButtonCaption);
    if Result = '' then
      Result := 'F';
  end;

  function TabKeyTipText(ATab: TLazRibbonTab): String;
  begin
    Result := CleanKeyTip(ATab.KeyTip);
    if Result = '' then
      Result := FirstCaptionKey(ATab.Caption);
  end;

  function ItemKeyTipText(AItem: TLazRibbonBaseItem): String;
  begin
    Result := CleanKeyTip(AItem.KeyTip);
    if (Result = '') and (AItem is TLazRibbonBaseButton) then
      Result := FirstCaptionKey(TLazRibbonBaseButton(AItem).Caption);
  end;

  procedure ResetKeyTipPrefix;
  begin
    if FKeyTipsPrefix <> '' then
    begin
      FKeyTipsPrefix := '';
      SetBufferInvalid;
      Invalidate;
      InvalidateHostedTitleBar;
    end;
  end;

  function ActiveTabHasKeyTipPrefix(const APrefix: String): Boolean;
  var
    J, K: Integer;
    Pane: TLazRibbonPane;
    Item: TLazRibbonBaseItem;
  begin
    Result := False;
    if (APrefix = '') or (FRibbonMinimized) or (FTabs = nil) or
       (FTabIndex < 0) or (FTabIndex >= FTabs.Count) then
      Exit;

    for J := 0 to FTabs[FTabIndex].Panes.Count - 1 do
    begin
      Pane := FTabs[FTabIndex].Panes[J];
      if (Pane = nil) or (not Pane.Visible) or (Pane.Items = nil) then
        Continue;
      for K := 0 to Pane.Items.Count - 1 do
      begin
        Item := Pane.Items[K];
        if (Item = nil) or (not Item.Visible) or (not Item.Enabled) then
          Continue;
        if KeyTipStartsWith(ItemKeyTipText(Item), APrefix) then
        begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;

  function TryExecuteActiveTabItemKeyTip(const APrefix: String): Boolean;
  var
    J, K: Integer;
    Pane: TLazRibbonPane;
    Item: TLazRibbonBaseItem;
  begin
    Result := False;
    if (APrefix = '') or (FRibbonMinimized) or (FTabs = nil) or
       (FTabIndex < 0) or (FTabIndex >= FTabs.Count) then
      Exit;

    for J := 0 to FTabs[FTabIndex].Panes.Count - 1 do
    begin
      Pane := FTabs[FTabIndex].Panes[J];
      if (Pane = nil) or (not Pane.Visible) or (Pane.Items = nil) then
        Continue;
      for K := 0 to Pane.Items.Count - 1 do
      begin
        Item := Pane.Items[K];
        if (Item = nil) or (not Item.Visible) or (not Item.Enabled) then
          Continue;
        if ItemKeyTipText(Item) = APrefix then
        begin
          { Office-like behavior: once a command KeyTip is accepted, close the
            KeyTips overlay before executing the command. This also supports
            multi-character KeyTips such as BA, OO or NS: the command is
            terminal only when the complete KeyTip has been typed. }
          HideKeyTips;
          Item.ExecuteKeyTip;
          Result := True;
          Exit;
        end;
      end;
    end;
  end;

  function RootHasKeyTipPrefix(const APrefix: String): Boolean;
  var
    J: Integer;
    RootTip: String;
  begin
    Result := False;
    if APrefix = '' then Exit;

    if FShowMenuButton and KeyTipStartsWith(ApplicationKeyTipText, APrefix) then
    begin
      Result := True;
      Exit;
    end;

    if (FQuickAccessToolBar <> nil) and FQuickAccessToolBar.Visible then
      for J := 0 to FQuickAccessToolBar.Items.Count - 1 do
        if FQuickAccessToolBar.Items[J].EffectiveVisible then
        begin
          RootTip := CleanKeyTip(FQuickAccessToolBar.Items[J].FKeyTip);
          if RootTip = '' then
            RootTip := IntToStr(J + 1);
          if KeyTipStartsWith(RootTip, APrefix) then
          begin
            Result := True;
            Exit;
          end;
        end;

    if FTabs <> nil then
      for J := 0 to FTabs.Count - 1 do
        if FTabs[J].Visible and KeyTipStartsWith(TabKeyTipText(FTabs[J]), APrefix) then
        begin
          Result := True;
          Exit;
        end;
  end;

  function TryExecuteRootKeyTip(const APrefix: String): Boolean;
  var
    J: Integer;
    RootTip: String;
  begin
    Result := False;
    if APrefix = '' then Exit;

    if FShowMenuButton and (ApplicationKeyTipText = APrefix) then
    begin
      HideKeyTips;
      DoMenuButtonClick;
      Result := True;
      Exit;
    end;

    if (FQuickAccessToolBar <> nil) and FQuickAccessToolBar.Visible then
      for J := 0 to FQuickAccessToolBar.Items.Count - 1 do
        if FQuickAccessToolBar.Items[J].EffectiveVisible then
        begin
          RootTip := CleanKeyTip(FQuickAccessToolBar.Items[J].FKeyTip);
          if RootTip = '' then
            RootTip := IntToStr(J + 1);
          if RootTip = APrefix then
          begin
            HideKeyTips;
            FQuickAccessToolBar.Items[J].Execute;
            Result := True;
            Exit;
          end;
        end;

    if FTabs <> nil then
      for J := 0 to FTabs.Count - 1 do
        if FTabs[J].Visible and (TabKeyTipText(FTabs[J]) = APrefix) then
        begin
          TabIndex := J;
          if not FRibbonMinimized then
          begin
            FKeyTipsStage := rktsActiveTabCommands;
            FKeyTipsPrefix := '';
            SetBufferInvalid;
            Invalidate;
            InvalidateHostedTitleBar;
          end
          else
          begin
            FKeyTipsStage := rktsTopLevel;
            FKeyTipsPrefix := '';
          end;
          Result := True;
          Exit;
        end;
  end;

begin
  inherited KeyDown(Key, Shift);

  if not FShowKeyTips then
    Exit;

  if Key = VK_ESCAPE then
  begin
    if FKeyTipsVisible and (FKeyTipsPrefix <> '') then
    begin
      ResetKeyTipPrefix;
    end
    else if FKeyTipsVisible and (FKeyTipsStage = rktsActiveTabCommands) then
    begin
      { First Esc returns from command-level KeyTips to the top-level map.
        A second Esc hides the overlay. }
      FKeyTipsStage := rktsTopLevel;
      FKeyTipsPrefix := '';
      SetBufferInvalid;
      Invalidate;
      InvalidateHostedTitleBar;
    end
    else
      HideKeyTips;
    Key := 0;
    Exit;
  end;

  if Key = VK_BACK then
  begin
    if HandleKeyTipsBackspace then
      Key := 0;
    Exit;
  end;

  if Key = VK_MENU then
  begin
    ToggleKeyTips;
    Key := 0;
    Exit;
  end;

  if not FKeyTipsVisible then
    Exit;

  if Key <= 255 then
    Pressed := UpperCase(Chr(Key))
  else
    Pressed := '';
  if Pressed = '' then
    Exit;

  NextPrefix := FKeyTipsPrefix + Pressed;

  if FKeyTipsStage = rktsActiveTabCommands then
  begin
    if TryExecuteActiveTabItemKeyTip(NextPrefix) then
    begin
      Key := 0;
      Exit;
    end;

    if ActiveTabHasKeyTipPrefix(NextPrefix) then
    begin
      FKeyTipsPrefix := NextPrefix;
      SetBufferInvalid;
      Invalidate;
      InvalidateHostedTitleBar;
      Key := 0;
    end;
    Exit;
  end;

  { Top-level stage: Application Button, QAT and tabs are valid.  Multi-key
    KeyTips are accepted incrementally; partial matches keep the overlay open
    and redraw it with the already typed prefix removed from matching labels. }
  if TryExecuteRootKeyTip(NextPrefix) then
  begin
    Key := 0;
    Exit;
  end;

  if RootHasKeyTipPrefix(NextPrefix) then
  begin
    FKeyTipsPrefix := NextPrefix;
    SetBufferInvalid;
    Invalidate;
    InvalidateHostedTitleBar;
    Key := 0;
    Exit;
  end;
end;

function TLazRibbon.QuickAccessHitTest(X, Y: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  if (FQuickAccessToolBar = nil) or (not FQuickAccessToolBar.Visible) then Exit;

  if FQuickAccessToolBar.AllowQuickCustomizing and
     PtInRect(FQuickAccessCustomizeRect, Point(X, Y)) then
  begin
    Result := -2;
    Exit;
  end;

  for I := 0 to High(FQuickAccessRects) do
    if PtInRect(FQuickAccessRects[I], Point(X, Y)) then
    begin
      Result := I;
      Exit;
    end;
end;

procedure TLazRibbon.QuickAccessMouseLeave;
begin
  if csDestroying in ComponentState then Exit;
  if (FQuickAccessHoverIndex <> -1) or (FQuickAccessActiveIndex <> -1) then
  begin
    FQuickAccessHoverIndex := -1;
    FQuickAccessActiveIndex := -1;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.QuickAccessMouseMove(Shift: TShiftState; X, Y: Integer);
var
  Hit: Integer;
begin
  if csDestroying in ComponentState then Exit;
  Hit := QuickAccessHitTest(X, Y);
  if FQuickAccessHoverIndex <> Hit then
  begin
    FQuickAccessHoverIndex := Hit;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.QuickAccessMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if csDestroying in ComponentState then Exit;
  FQuickAccessActiveIndex := QuickAccessHitTest(X, Y);
  SetBufferInvalid;
  Repaint;
end;

procedure TLazRibbon.QuickAccessMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Hit: Integer;
  PopupPoint: TPoint;
begin
  if csDestroying in ComponentState then Exit;
  Hit := QuickAccessHitTest(X, Y);
  if (Button = mbLeft) and (Hit = FQuickAccessActiveIndex) then
  begin
    if Hit = -2 then
    begin
      FQuickAccessActiveIndex := -1;
      FQuickAccessHoverIndex := -1;
      SetBufferInvalid;
      Repaint;
      ShowQuickAccessCustomizeMenu;
    end
    else if (Hit >= 0) and (Hit < FQuickAccessToolBar.Items.Count) then
    begin
      PopupPoint := ClientToScreen(Point(FQuickAccessRects[Hit].Left, FQuickAccessRects[Hit].Bottom));
      FQuickAccessToolBar.Items[Hit].ExecuteAt(PopupPoint);
    end;
  end;

  FQuickAccessActiveIndex := -1;
  FQuickAccessHoverIndex := Hit;
  SetBufferInvalid;
  Repaint;
end;

procedure TLazRibbon.QuickAccessCustomizeActionMenuClick(Sender: TObject);
var
  A: TBasicAction;
begin
  if (FQuickAccessToolBar = nil) or not (Sender is TMenuItem) then Exit;
  A := TBasicAction(Pointer(TMenuItem(Sender).Tag));
  if A <> nil then
  begin
    FQuickAccessToolBar.ToggleAction(A);
    SetBufferInvalid;
    Invalidate;
  end;
end;

procedure TLazRibbon.QuickAccessMoreCommandsMenuClick(Sender: TObject);
begin
  if (FQuickAccessToolBar <> nil) and Assigned(FQuickAccessToolBar.OnMoreCommandsClick) then
    FQuickAccessToolBar.OnMoreCommandsClick(FQuickAccessToolBar);
end;

procedure TLazRibbon.QuickAccessPositionMenuClick(Sender: TObject);
begin
  if FQuickAccessToolBar = nil then Exit;
  if FQuickAccessToolBar.Position = qapBelowRibbon then
    FQuickAccessToolBar.Position := qapBeforeTabs
  else
    FQuickAccessToolBar.Position := qapBelowRibbon;
  SetMetricsInvalid;
  Invalidate;
end;

procedure TLazRibbon.QuickAccessMinimizeRibbonMenuClick(Sender: TObject);
begin
  RibbonMinimized := not RibbonMinimized;
end;

procedure TLazRibbon.QuickAccessResetToDefaultMenuClick(Sender: TObject);
begin
  if FQuickAccessToolBar = nil then Exit;
  FQuickAccessToolBar.ResetToDefaultItems(FQuickAccessToolBar.CustomizeActionList);
  SetMetricsInvalid;
  SetBufferInvalid;
  Invalidate;
end;

procedure TLazRibbon.ShowQuickAccessCustomizeMenu;
var
  P: TPoint;
begin
  if (FQuickAccessCustomizeRect.Right > FQuickAccessCustomizeRect.Left) then
    P := ClientToScreen(Point(FQuickAccessCustomizeRect.Left, FQuickAccessCustomizeRect.Bottom))
  else
    P := ClientToScreen(Point(4, 24));
  ShowQuickAccessCustomizeMenuAtScreen(P);
end;

procedure TLazRibbon.ShowQuickAccessCustomizeMenuAtScreen(const AScreenPoint: TPoint);
var
  Popup: TPopupMenu;
  MI: TMenuItem;
  I: Integer;
  A: TBasicAction;

  function CleanCaption(const S: String): String;
  begin
    Result := StringReplace(S, '&', '', [rfReplaceAll]);
  end;

  function ActionCaption(AAction: TBasicAction): String;
  begin
    Result := '';
    if AAction is TCustomAction then
      Result := CleanCaption(TCustomAction(AAction).Caption);
    if Result = '' then
      Result := AAction.Name;
  end;

  procedure AddSeparator;
  begin
    MI := TMenuItem.Create(Popup);
    MI.Caption := '-';
    Popup.Items.Add(MI);
  end;

begin
  if csDestroying in ComponentState then Exit;
  if FQuickAccessToolBar = nil then Exit;
  if not FQuickAccessToolBar.AllowQuickCustomizing then Exit;

  FreeAndNil(FQuickAccessCustomizePopup);
  Popup := TPopupMenu.Create(Self);
  FQuickAccessCustomizePopup := Popup;

  if FQuickAccessToolBar.AllowCustomizing and
     (FQuickAccessToolBar.CustomizeActionList <> nil) then
  begin
    if FQuickAccessToolBar.CustomizeMenuTitle <> '' then
    begin
      MI := TMenuItem.Create(Popup);
      MI.Caption := FQuickAccessToolBar.CustomizeMenuTitle;
      MI.Enabled := False;
      Popup.Items.Add(MI);
    end;

    for I := 0 to FQuickAccessToolBar.CustomizeActionList.ActionCount - 1 do
    begin
      A := FQuickAccessToolBar.CustomizeActionList.Actions[I];
      if A = nil then Continue;
      if (A is TCustomAction) and (not TCustomAction(A).Visible) then Continue;

      MI := TMenuItem.Create(Popup);
      MI.Caption := ActionCaption(A);
      MI.Checked := FQuickAccessToolBar.ContainsAction(A);
      MI.Tag := PtrInt(Pointer(A));
      MI.OnClick := QuickAccessCustomizeActionMenuClick;
      MI.Enabled := True;
      Popup.Items.Add(MI);
    end;
  end
  else if Assigned(FQuickAccessToolBar.OnCustomizeClick) then
    FQuickAccessToolBar.OnCustomizeClick(FQuickAccessToolBar);

  if FQuickAccessToolBar.AllowCustomizing and FQuickAccessToolBar.AllowReset and
     FQuickAccessToolBar.ShowResetToDefaultsItem then
  begin
    AddSeparator;
    MI := TMenuItem.Create(Popup);
    MI.Caption := FQuickAccessToolBar.ResetToDefaultsCaption;
    MI.OnClick := QuickAccessResetToDefaultMenuClick;
    Popup.Items.Add(MI);
  end;

  if FQuickAccessToolBar.AllowCustomizing and FQuickAccessToolBar.ShowMoreCommandsItem then
  begin
    AddSeparator;
    MI := TMenuItem.Create(Popup);
    MI.Caption := FQuickAccessToolBar.MoreCommandsCaption;
    MI.OnClick := QuickAccessMoreCommandsMenuClick;
    Popup.Items.Add(MI);
  end;

  if FQuickAccessToolBar.AllowPositionChange and FQuickAccessToolBar.ShowPositionMenuItem then
  begin
    AddSeparator;
    MI := TMenuItem.Create(Popup);
    if FQuickAccessToolBar.Position = qapBelowRibbon then
      MI.Caption := FQuickAccessToolBar.ShowAboveRibbonCaption
    else
      MI.Caption := FQuickAccessToolBar.ShowBelowRibbonCaption;
    MI.OnClick := QuickAccessPositionMenuClick;
    Popup.Items.Add(MI);
  end;

  if FQuickAccessToolBar.AllowMinimizeRibbon and FQuickAccessToolBar.ShowMinimizeRibbonMenuItem then
  begin
    MI := TMenuItem.Create(Popup);
    if FRibbonMinimized then
      MI.Caption := FQuickAccessToolBar.RestoreRibbonCaption
    else
      MI.Caption := FQuickAccessToolBar.MinimizeRibbonCaption;
    MI.OnClick := QuickAccessMinimizeRibbonMenuClick;
    Popup.Items.Add(MI);
  end;

  Popup.Popup(AScreenPoint.X, AScreenPoint.Y);
end;

procedure TLazRibbon.SetStyle(const Value: TLazRibbonStyle);
begin
  FStyle := Value;
  FAppearance.Reset(FStyle);
  ForceRepaint;
end;

function TLazRibbon.DoTabChanging(OldIndex, NewIndex: integer): boolean;
begin
  Result := True;
  if Assigned(FOnTabChanging) then
    FOnTabChanging(Self, OldIndex, NewIndex, Result);
end;

procedure TLazRibbon.SetMetricsInvalid;
begin
  FMetricsValid := False;
  FBufferValid := False;
end;

procedure TLazRibbon.SetTabIndex(const Value: integer);
var
  OldTabIndex: integer;
begin
  OldTabIndex := FTabIndex;

  if not (AtLeastOneTabVisible) then
    FTabIndex := -1
  else
  begin
    FTabIndex := max(0, min(FTabs.Count - 1, Value));

    //I know that at least one tab is visible (from previous condition)
    //so below loop will finish
    while not (FTabs[FTabIndex].Visible) do
      FTabIndex := (FTabIndex + 1) mod FTabs.Count;
  end;
  FTabHover := -1;

  if DoTabChanging(OldTabIndex, FTabIndex) then
  begin
    SetMetricsInvalid;
    if not (FInternalUpdating or FUpdating) then
      Repaint;
    if Assigned(FOnTabChanged) then
      FOnTabChanged(self);
  end
  else
    FTabIndex := OldTabIndex;
end;

procedure TLazRibbon.TabMouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  SelTab: integer;
  TabRect: T2DIntRect;
  i: integer;
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  SelTab := -1;
  if AtLeastOneTabVisible then
    for i := 0 to FTabs.Count - 1 do
      if FTabs[i].Visible then
      begin
        if FTabClipRect.IntersectsWith(FTabRects[i], TabRect) then
             {$IFDEF EnhancedRecordSupport}
          if TabRect.Contains(T2DIntPoint.Create(x, y)) then
             {$ELSE}
            if TabRect.Contains(x, y) then
             {$ENDIF}
              SelTab := i;
      end;

  { Let an attached BackStage inspect clicks on the current tab too.  Without
    this, when the BackStage is opened through a pseudo/compatibility "Arquivo"
    tab while the real selected tab remains "Página Inicial", clicking "Página
    Inicial" again does not fire OnTabChanging and the BackStage stays open. }
  if (Button = mbLeft) and (SelTab <> -1) and (SelTab = FTabIndex) and
     (FBackstageView <> nil) then
  begin
    if not FBackstageView.HandleRibbonTabClick(SelTab, FTabs[SelTab].Caption, True) then
      Exit;
  end;

  //If any tab was clicked but one (not being selected) then change selection
  if (Button = mbLeft) and (SelTab <> -1) and (SelTab <> FTabIndex) then
  begin
    if DoTabChanging(FTabIndex, SelTab) then
    begin
      FTabIndex := SelTab;
      SetMetricsInvalid;
      Repaint;
      if Assigned(FOnTabChanged) then
        FOnTabChanged(self);
    end;
  end;
end;

procedure TLazRibbon.TabMouseLeave;
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  if FTabHover <> -1 then
  begin
    FTabHover := -1;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.TabMouseMove(Shift: TShiftState; X, Y: integer);
var
  NewTabHover: integer;
  TabRect: T2DIntRect;
  i: integer;
begin
 //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  NewTabHover := -1;
  if AtLeastOneTabVisible then
    for i := 0 to FTabs.Count - 1 do
      if FTabs[i].Visible then
      begin
        if FTabClipRect.IntersectsWith(FTabRects[i], TabRect) then
             {$IFDEF EnhancedRecordSupport}
          if TabRect.Contains(T2DIntPoint.Create(x, y)) then
             {$ELSE}
            if TabRect.Contains(x, y) then
             {$ENDIF}
              NewTabHover := i;
      end;

  if NewTabHover <> FTabHover then
  begin
    FTabHover := NewTabHover;
    SetBufferInvalid;
    Repaint;
  end;
end;

procedure TLazRibbon.TabMouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
 //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  if (FTabIndex > -1) then
    FTabs[FTabIndex].ExecOnClick;

  //Tabs don't need MouseUp
end;

procedure TLazRibbon.SetAppearance(const Value: TLazRibbonToolbarAppearance);
begin
  FAppearance.Assign(Value);
  SetBufferInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

procedure TLazRibbon.ValidateBuffer;

  procedure DrawBackgroundColor;
  begin
    FBuffer.Canvas.Brush.Color := Color;
    FBuffer.Canvas.Brush.Style := bsSolid;
    FBuffer.Canvas.FillRect(Rect(0, 0, self.Width, self.Height));
  end;

  procedure DrawBody;
  var
    FocusedAppearance: TLazRibbonToolbarAppearance;
    i, j: integer;
    tabHeight: Integer;
  begin
    //Loading appearance of selected tab
    //or FToolbarAppearance if selected tab has no set OverrideAppearance
    if (FTabIndex <> -1) and (FTabs[FTabIndex].OverrideAppearance) then
      FocusedAppearance := FTabs[FTabIndex].CustomAppearance
    else
      FocusedAppearance := FAppearance;

    tabHeight := EffectiveContextualGroupHeaderHeight + FocusedAppearance.Tab.CalcCaptionHeight;

    TGuiTools.DrawRoundRect(FBuffer.Canvas,
                          {$IFDEF EnhancedRecordSupport}
      T2DIntRect.Create(0, tabHeight, self.Width - 1, self.Height - 1),
                          {$ELSE}
      Create2DIntRect(0, tabHeight, self.Width - 1, self.Height - 1),
                          {$ENDIF}
      FocusedAppearance.Tab.CornerRadius,
      FocusedAppearance.Tab.GradientFromColor,
      FocusedAppearance.Tab.GradientToColor,
      FocusedAppearance.Tab.GradientType);

    TGuiTools.DrawAARoundCorner(FBuffer,
                              {$IFDEF EnhancedRecordSupport}
      T2DIntPoint.Create(0, tabHeight),
                              {$ELSE}
      Create2DIntPoint(0, tabHeight),
                              {$ENDIF}
      FocusedAppearance.Tab.CornerRadius,
      cpLeftTop,
      FocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawAARoundCorner(FBuffer,
                              {$IFDEF EnhancedRecordSupport}
      T2DIntPoint.Create(self.Width - FocusedAppearance.Tab.CornerRadius, tabHeight),
                              {$ELSE}
      Create2DIntPoint(self.Width - FocusedAppearance.Tab.CornerRadius, tabHeight),
                              {$ENDIF}
      FocusedAppearance.Tab.CornerRadius,
      cpRightTop,
      FocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawAARoundCorner(FBuffer,
                              {$IFDEF EnhancedRecordSupport}
      T2DIntPoint.Create(0, self.Height - FocusedAppearance.Tab.CornerRadius),
                              {$ELSE}
      Create2DIntPoint(0, self.Height - FocusedAppearance.Tab.CornerRadius),
                              {$ENDIF}
      FocusedAppearance.Tab.CornerRadius,
      cpLeftBottom,
      FocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawAARoundCorner(FBuffer,
                              {$IFDEF EnhancedRecordSupport}
      T2DIntPoint.Create(self.Width - FocusedAppearance.Tab.CornerRadius, self.Height - FocusedAppearance.Tab.CornerRadius),
                              {$ELSE}
      Create2DIntPoint(self.Width - FocusedAppearance.Tab.CornerRadius, self.Height - FocusedAppearance.Tab.CornerRadius),
                              {$ENDIF}
      FocusedAppearance.Tab.CornerRadius,
      cpRightBottom,
      FocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawVLine(FBuffer, 0,
      tabHeight + FocusedAppearance.Tab.CornerRadius,
      self.Height - FocusedAppearance.Tab.CornerRadius,
      FocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawHLine(FBuffer, FocusedAppearance.Tab.CornerRadius,
      self.Width - FocusedAppearance.Tab.CornerRadius,
      self.Height - 1, FocusedAppearance.Tab.BorderColor);

    TGuiTools.DrawVLine(FBuffer, self.Width - 1,
      tabHeight + FocusedAppearance.Tab.CornerRadius,
      self.Height - FocusedAppearance.Tab.CornerRadius,
      FocusedAppearance.Tab.BorderColor);

    if not (AtLeastOneTabVisible) then
    begin

      //If there are no tabs then the horizontal line will be drawn
      TGuiTools.DrawHLine(FBuffer, FocusedAppearance.Tab.CornerRadius, self.Width -
        FocusedAppearance.Tab.CornerRadius, tabHeight, FocusedAppearance.Tab.BorderColor);
    end
    else
    begin
      //If there are tabs then the place will be left for them
      //Last visible tab is looked for
      i := FTabs.Count - 1;
      while not (FTabs[i].Visible) do
        Dec(i);

      // First visible tab is looked for
      j := 0;
      while not (FTabs[j].Visible) do
        Inc(j);

      //Only right part, the rest will be drawn with tabs
      if FTabRects[i].Right < self.Width - FocusedAppearance.Tab.CornerRadius - 1 then
      begin
        TGuiTools.DrawHLine(FBuffer, FTabRects[i].Right + 1, self.Width -
          FocusedAppearance.Tab.CornerRadius, tabHeight, FocusedAppearance.Tab.BorderColor);
        //...But left part should be drawn if FShowMenuButton = True
        if FShowMenuButton then
          TGuiTools.DrawHLine(FBuffer, 0, FTabRects[j].Left, tabHeight, FocusedAppearance.Tab.BorderColor);
      end;
    end;
  end;

  procedure DrawContextualGroupHeaders;
  var
    HeaderHeight: Integer;
    I, J: Integer;
    GroupCaption: String;
    GroupColor: TColor;
    R, TextR: TRect;
    CaptionWidth, DesiredWidth, AvailableWidth: Integer;

    function ContextualColorForHeader(index: integer): TColor;
    begin
      Result := FTabs[index].ContextualColor;
      if Result = clNone then
        Result := $00800080; { default purple accent }
    end;

    procedure NormalizeHeaderRectForCaption(var ARect: TRect; const ACaption: String);
    begin
      { The header must describe the contextual tab group, not float as an
        independent label.  Earlier versions expanded the header rectangle
        during painting when the caption was wider than the tab, which made
        single-tab contextual groups look detached.  The tab metrics are now
        expanded before painting, so this routine only clamps the band to the
        Ribbon client area and lets DrawText clip with ellipsis if the whole
        Ribbon is too narrow. }
      CaptionWidth := FBuffer.Canvas.TextWidth(ACaption);
      DesiredWidth := CaptionWidth + 16;
      AvailableWidth := Max(1, Self.Width - 2);

      if ARect.Left < 1 then
        ARect.Left := 1;
      if ARect.Right > Self.Width - 1 then
        ARect.Right := Self.Width - 1;

      if (ARect.Right - ARect.Left) > AvailableWidth then
        ARect.Right := ARect.Left + AvailableWidth;

      if ARect.Right <= ARect.Left then
        ARect.Right := Min(Self.Width - 1, ARect.Left + 1);
    end;

  begin
    HeaderHeight := EffectiveContextualGroupHeaderHeight;
    if (HeaderHeight <= 0) or (FTabs = nil) then
      Exit;

    I := 0;
    while I < FTabs.Count do
    begin
      if (not FTabs[I].Visible) or (not FTabs[I].Contextual) or
         (Trim(FTabs[I].ContextualGroupCaption) = '') then
      begin
        Inc(I);
        Continue;
      end;

      GroupCaption := FTabs[I].ContextualGroupCaption;
      GroupColor := ContextualColorForHeader(I);
      J := I;
      while (J + 1 < FTabs.Count) and FTabs[J + 1].Visible and
            FTabs[J + 1].Contextual and
            SameText(FTabs[J + 1].ContextualGroupCaption, GroupCaption) do
        Inc(J);

      R := Rect(FTabRects[I].Left, 0, FTabRects[J].Right + 1, HeaderHeight);
      if R.Right > R.Left then
      begin
        FBuffer.Canvas.Font.Assign(FAppearance.Tab.TabHeaderFont);
        FBuffer.Canvas.Font.Style := [];
        NormalizeHeaderRectForCaption(R, GroupCaption);

        { Modern contextual headers should look like a light contextual band,
          not like a heavy framed label.  Keep a subtle wash, a thin accent
          line and clipped centered text, closer to current Office behavior. }
        FBuffer.Canvas.Brush.Style := bsSolid;
        FBuffer.Canvas.Brush.Color := TColorTools.Shade(GroupColor, clWhite, 94);
        FBuffer.Canvas.Pen.Style := psClear;
        FBuffer.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

        TGuiTools.DrawHLine(FBuffer.Canvas, R.Left, R.Right - 1, R.Top,
          TColorTools.Shade(GroupColor, clWhite, 42));
        if R.Bottom - R.Top > 3 then
          TGuiTools.DrawHLine(FBuffer.Canvas, R.Left, R.Right - 1, R.Top + 1,
            TColorTools.Shade(GroupColor, clWhite, 70));
        TGuiTools.DrawHLine(FBuffer.Canvas, R.Left, R.Right - 1, R.Bottom - 1,
          TColorTools.Shade(GroupColor, clWhite, 82));

        FBuffer.Canvas.Brush.Style := bsClear;
        FBuffer.Canvas.Font.Assign(FAppearance.Tab.TabHeaderFont);
        FBuffer.Canvas.Font.Style := [];
        FBuffer.Canvas.Font.Color := TColorTools.Shade(GroupColor, clBlack, 10);
        TextR := R;
        InflateRect(TextR, -5, 0);
        DrawText(FBuffer.Canvas.Handle, PChar(GroupCaption), Length(GroupCaption),
          TextR, DT_SINGLELINE or DT_VCENTER or DT_CENTER or DT_END_ELLIPSIS);
        FBuffer.Canvas.Brush.Style := bsSolid;
        FBuffer.Canvas.Pen.Style := psSolid;
      end;

      I := J + 1;
    end;
  end;

  procedure DrawTabs;
  var
    i: integer;
//    TabRect: T2DIntRect;
    CurrentAppearance: TLazRibbonToolbarAppearance;
    FocusedAppearance: TLazRibbonToolbarAppearance;

    procedure DrawTabText(index: integer; AFont: TFont; AOverrideTextColor: TColor = clNone);
    var
      x, y: integer;
      TabRect: T2DIntRect;
      clr: TColor;
      ts: TTextStyle;
    begin
      TabRect := FTabRects[index];

      FBuffer.Canvas.Font.Assign(AFont);
      ts := FBuffer.Canvas.TextStyle;
      ts.RightToLeft := IsRightToLeft;
      FBuffer.Canvas.TextStyle := ts;

      if AOverrideTextColor <> clNone then
        clr := AOverrideTextColor else
        clr := AFont.Color;
      x := TabRect.left + (TabRect.Width - FBuffer.Canvas.textwidth(
        FTabs[index].Caption)) div 2;
      y := TabRect.top + (TabRect.Height - FBuffer.Canvas.Textheight('Wy')) div 2;

      TGuiTools.DrawText(FBuffer.Canvas,
        x,
        y,
        FTabs[index].Caption,
        clr,
        FTabClipRect);
    end;

    procedure DrawTab(index: integer;
      Border, GradientFrom, GradientTo: TColor; ATabCornerRadius: Integer);
    var
      TabRect: T2DIntRect;
      TabRegion: HRGN;
      TmpRegion, TmpRegion2: HRGN;
    begin
      //Note!! Tabs cover one pixel of toolbar region, because
      // the they must draw edge, which fits in with region edge
      TabRect := FTabRects[index];

      //Middle rectangle
      TabRegion := CreateRectRgn(
        TabRect.Left + ATabCornerRadius - 1,
        TabRect.Top + ATabCornerRadius,
        TabRect.Right - ATabCornerRadius + 1 + 1,
        TabRect.Bottom + 1
      );

      //Top part with top convex curves
      TmpRegion := CreateRectRgn(
        TabRect.Left + 2 * ATabCornerRadius - 1,
        TabRect.Top,
        TabRect.Right - 2 * ATabCornerRadius + 1 + 1,
        TabRect.Top + ATabCornerRadius
      );
      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
      DeleteObject(TmpRegion);

      TmpRegion := CreateEllipticRgn(
        TabRect.Left + ATabCornerRadius - 1,
        TabRect.Top,
        TabRect.Left + 3 * ATabCornerRadius,
        TabRect.Top + 2 * ATabCornerRadius + 1
      );
      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
      DeleteObject(TmpRegion);

      TmpRegion := CreateEllipticRgn(
        TabRect.Right - 3 * ATabCornerRadius + 2,
        TabRect.Top,
        TabRect.Right - ATabCornerRadius + 3,
        TabRect.Top + 2 * ATabCornerRadius + 1
      );
      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
      DeleteObject(TmpRegion);

      //Bottom part with bottom convex curves
      TmpRegion := CreateRectRgn(
        TabRect.Left,
        TabRect.Bottom - ATabCornerRadius,
        TabRect.Right + 1,
        TabRect.Bottom + 1
      );

      TmpRegion2 := CreateEllipticRgn(
        TabRect.Left - ATabCornerRadius,
        TabRect.Bottom - 2 * ATabCornerRadius + 1,
        TabRect.Left + ATabCornerRadius + 1,
        TabRect.Bottom + 2
      );
      CombineRgn(TmpRegion, TmpRegion, TmpRegion2, RGN_DIFF);
      DeleteObject(TmpRegion2);

      TmpRegion2 := CreateEllipticRgn(
        TabRect.Right - ATabCornerRadius + 1,
        TabRect.Bottom - 2 * ATabCornerRadius + 1,
        TabRect.Right + ATabCornerRadius + 2,
        TabRect.Bottom + 2
      );
      CombineRgn(TmpRegion, TmpRegion, TmpRegion2, RGN_DIFF);
      DeleteObject(TmpRegion2);

      CombineRgn(TabRegion, TabRegion, TmpRegion, RGN_OR);
      DeleteObject(TmpRegion);

      TGUITools.DrawRegion(FBuffer.Canvas,
        TabRegion,
        TabRect,
        GradientFrom,
        GradientTo,
        bkVerticalGradient);

      DeleteObject(TabRegion);

      // Frame
      TGuiTools.DrawAARoundCorner(FBuffer,
                                {$IFDEF EnhancedRecordSupport}
        T2DIntPoint.Create(TabRect.left, TabRect.bottom - ATabCornerRadius + 1),
                                {$ELSE}
        Create2DIntPoint(TabRect.left, TabRect.bottom - ATabCornerRadius + 1),
                                {$ENDIF}
        ATabCornerRadius,
        cpRightBottom,
        Border,
        FTabClipRect);

      TGuiTools.DrawAARoundCorner(FBuffer,
                                {$IFDEF EnhancedRecordSupport}
        T2DIntPoint.Create(TabRect.right - ATabCornerRadius + 1, TabRect.bottom - ATabCornerRadius + 1),
                                {$ELSE}
        Create2DIntPoint(TabRect.right - ATabCornerRadius + 1, TabRect.bottom - ATabCornerRadius + 1),
                                {$ENDIF}
        TabCornerRadius,
        cpLeftBottom,
        Border,
        FTabClipRect);

      TGuiTools.DrawVLine(FBuffer,
        TabRect.left + ATabCornerRadius - 1,
        TabRect.top + ATabCornerRadius,
        TabRect.Bottom - ATabCornerRadius + 1,
        Border,
        FTabClipRect);

      TGuiTools.DrawVLine(FBuffer,
        TabRect.Right - ATabCornerRadius + 1,
        TabRect.top + ATabCornerRadius,
        TabRect.Bottom - ATabCornerRadius + 1,
        Border,
        FTabClipRect);

      TGuiTools.DrawAARoundCorner(FBuffer,
                                {$IFDEF EnhancedRecordSupport}
        T2DIntPoint.Create(TabRect.Left + ATabCornerRadius - 1, TabRect.Top),
                                {$ELSE}
        Create2DIntPoint(TabRect.Left + ATabCornerRadius - 1, TabRect.Top),
                                {$ENDIF}
        ATabCornerRadius,
        cpLeftTop,
        Border,
        FTabClipRect);

      TGuiTools.DrawAARoundCorner(FBuffer,
                                {$IFDEF EnhancedRecordSupport}
        T2DIntPoint.Create(TabRect.Right - 2 * ATabCornerRadius + 2, TabRect.Top),
                                {$ELSE}
        Create2DIntPoint(TabRect.Right - 2 * ATabCornerRadius + 2, TabRect.Top),
                                {$ENDIF}
        ATabCornerRadius,
        cpRightTop,
        Border,
        FTabClipRect);

      TGuiTools.DrawHLine(FBuffer,
        TabRect.Left + 2 * ATabCornerRadius - 1,
//        TabRect.Right - 2 * ATabCornerRadius + 2,
        TabRect.Right - 2 * ATabCornerRadius + 1,
        TabRect.Top,
        Border,
        FTabClipRect);
    end;

    procedure DrawBottomLine(index: integer;
      Border: TColor);
    var
      TabRect: T2DIntRect;
    begin
      TabRect := FTabRects[index];

      TGUITools.DrawHLine(FBuffer,
        TabRect.left,
        TabRect.right,
        TabRect.bottom,
        Border,
        FTabClipRect);
    end;

    function ContextualColorForTab(index: integer): TColor;
    begin
      Result := FTabs[index].ContextualColor;
      if Result = clNone then
        Result := $00800080; { default purple accent }
    end;

    procedure DrawContextualAccent(index: integer; AColor: TColor; AActive: Boolean);
    var
      TabRect: T2DIntRect;
      R: TRect;
      AccentHeight: Integer;
    begin
      if (index < 0) or (index >= FTabs.Count) or (not FTabs[index].Contextual) then
        Exit;

      TabRect := FTabRects[index];
      if TabRect.Right <= TabRect.Left then Exit;

      if AActive then
        AccentHeight := 3
      else
        AccentHeight := 2;

      R := Rect(
        TabRect.Left + CurrentAppearance.Tab.CornerRadius,
        TabRect.Top,
        TabRect.Right - CurrentAppearance.Tab.CornerRadius + 1,
        TabRect.Top + AccentHeight
      );

      FBuffer.Canvas.Brush.Style := bsSolid;
      FBuffer.Canvas.Brush.Color := AColor;
      FBuffer.Canvas.Pen.Style := psClear;
      FBuffer.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      FBuffer.Canvas.Pen.Style := psSolid;
    end;

  var
    delta: Integer;
    ContextColor: TColor;
  begin
    //I assume that the tabs size is reasonable

    //Loading appearance of selected now tab (her appearance, if
    //its flag - OverrideAppearance is switched on otherwise
    //FToolbarAppearance
    if (FTabIndex <> -1) and (FTabs[FTabIndex].OverrideAppearance) then
      FocusedAppearance := FTabs[FTabIndex].CustomAppearance
    else
      FocusedAppearance := FAppearance;

    if FTabs.Count > 0 then
      for i := 0 to FTabs.Count - 1 do
        if FTabs[i].Visible then
        begin
          // Is there any sense to draw?
          if not (FTabClipRect.IntersectsWith(FTabRects[i])) then
            continue;

          //Loading appearance of now drawn tab
          if (FTabs[i].OverrideAppearance) then
            CurrentAppearance := FTabs[i].CustomAppearance
          else
            CurrentAppearance := FAppearance;

          if CurrentAppearance.Tab.GradientType = bkSolid then
            delta := 0
          else
            delta := 50;

          //TabRect := FTabRects[i];

          // Tab is drawn
          if i = FTabIndex then      // active tab
          begin
            if FTabs[i].Contextual then
            begin
              ContextColor := ContextualColorForTab(i);
              DrawTab(i,
                TColorTools.Shade(ContextColor, clWhite, IfThen(i = FTabHover, 62, 74)),
                TColorTools.Shade(ContextColor, clWhite, IfThen(i = FTabHover, 92, 97)),
                TColorTools.Shade(ContextColor, clWhite, IfThen(i = FTabHover, 88, 94)),
                CurrentAppearance.Tab.CornerRadius);
              DrawContextualAccent(i, ContextColor, True);
              DrawTabText(i, CurrentAppearance.Tab.TabHeaderFont, ContextColor);
            end
            else
            begin
              if i = FTabHover then
              begin
                DrawTab(i,
                  CurrentAppearance.Tab.BorderColor,
                  TColorTools.Brighten(TColorTools.Brighten(
                    CurrentAppearance.Tab.GradientFromColor, delta), delta),
                  CurrentAppearance.Tab.GradientFromColor,
                  CurrentAppearance.Tab.CornerRadius);
              end
              else
              begin
                DrawTab(i,
                  CurrentAppearance.Tab.BorderColor,
                  TColorTools.Brighten(
                    CurrentAppearance.Tab.GradientFromColor, delta),
                  CurrentAppearance.Tab.GradientFromColor,
                  CurrentAppearance.Tab.CornerRadius);
              end;

              DrawTabText(i, CurrentAppearance.Tab.TabHeaderFont);
            end;
          end
          else
          begin                     // inactive tab
            if FTabs[i].Contextual then
            begin
              ContextColor := ContextualColorForTab(i);
              DrawTab(i,
                TColorTools.Shade(ContextColor, clWhite, IfThen(i = FTabHover, 70, 84)),
                TColorTools.Shade(ContextColor, clWhite, IfThen(i = FTabHover, 94, 98)),
                TColorTools.Shade(ContextColor, clWhite, IfThen(i = FTabHover, 90, 96)),
                CurrentAppearance.Tab.CornerRadius);
              DrawContextualAccent(i, ContextColor, False);
            end
            else if i = FTabHover then
            begin
              DrawTab(i,
                TColorTools.Shade(
                  self.Color, CurrentAppearance.Tab.BorderColor, delta),
                TColorTools.Shade(self.color,
                  TColorTools.Brighten(CurrentAppearance.Tab.GradientFromColor, delta), 50),
                TColorTools.Shade(
                  self.color, CurrentAppearance.Tab.GradientFromColor, 50),
                CurrentAppearance.Tab.CornerRadius);
            end;

            // Bottom line
            //Warning!! Irrespective of tab , the appearance will be drawn
            //with color now selected tab
            if FTabs[i].Contextual then
              DrawBottomLine(i, TColorTools.Shade(ContextualColorForTab(i), clWhite, 72))
            else
              DrawBottomLine(i, FocusedAppearance.Tab.BorderColor);

            // Text
            if FTabs[i].Contextual then
              DrawTabText(i, CurrentAppearance.Tab.TabHeaderFont, ContextualColorForTab(i))
            else
              DrawTabText(i, CurrentAppearance.Tab.TabHeaderFont,
                CurrentAppearance.Tab.InactiveTabHeaderFontColor);
          end;
        end;
  end;

  procedure DrawTabContents;
  begin
    if (FTabIndex <> -1) and (not FRibbonMinimized) then
      FTabs[FTabIndex].Draw(FBuffer, FTabContentsClipRect);
  end;

  // Drawing procedures for Menu Button
  procedure DrawMenuButton;

    procedure DrawMenuButtonBackground(BorderColor, GradientFrom, GradientTo: TColor; GradientKind: TBackgroundKind);
    var
      MenuButtonRegion: HRGN;
      TmpRegion: HRGN;
      aCornerRadius: Integer;
      DrawRounded: Boolean;
    begin

      case FAppearance.MenuButton.ShapeStyle of
        mbssRounded:
          begin
            aCornerRadius := MenuButtonCornerRadius;
            DrawRounded := True;
          end;
        mbssRectangle:
          begin
            aCornerRadius := 0;
            DrawRounded := False;
          end;
      end;

      //Middle rectangle
      MenuButtonRegion := CreateRectRgn(
        FMenuButtonRect.Left + aCornerRadius - 1,
        FMenuButtonRect.Top + aCornerRadius,
        FMenuButtonRect.Right - aCornerRadius + 1 + 1,
        FMenuButtonRect.Bottom
      );

      //Top part with top convex curves
      TmpRegion := CreateRectRgn(
        FMenuButtonRect.Left + 2 * aCornerRadius - 1,
        FMenuButtonRect.Top,
        FMenuButtonRect.Right - 2 * aCornerRadius + 1 + 1,
        FMenuButtonRect.Top + aCornerRadius
      );
      CombineRgn(MenuButtonRegion, MenuButtonRegion, TmpRegion, RGN_OR);
      DeleteObject(TmpRegion);

      TmpRegion := CreateEllipticRgn(
        FMenuButtonRect.Left + aCornerRadius - 1,
        FMenuButtonRect.Top,
        FMenuButtonRect.Left + 3 * aCornerRadius,
        FMenuButtonRect.Top + 2 * aCornerRadius + 1
      );
      CombineRgn(MenuButtonRegion, MenuButtonRegion, TmpRegion, RGN_OR);
      DeleteObject(TmpRegion);

      TmpRegion := CreateEllipticRgn(
        FMenuButtonRect.Right - 3 * aCornerRadius + 2,
        FMenuButtonRect.Top,
        FMenuButtonRect.Right - aCornerRadius + 3,
        FMenuButtonRect.Top + 2 * aCornerRadius + 1
      );
      CombineRgn(MenuButtonRegion, MenuButtonRegion, TmpRegion, RGN_OR);
      DeleteObject(TmpRegion);

      TGUITools.DrawRegion(FBuffer.Canvas,
        MenuButtonRegion,
        FMenuButtonRect,
        GradientFrom,
        GradientTo,
        GradientKind);

      DeleteObject(MenuButtonRegion);

      // Draw left vertical line of Menu Button
      if DrawRounded then
        TGuiTools.DrawVLine(FBuffer,
          FMenuButtonRect.Left + aCornerRadius - 1,
          FMenuButtonRect.Top + aCornerRadius,
          FMenuButtonRect.Bottom - 1,
          BorderColor,
          FTabClipRect)
      else
        TGuiTools.DrawVLine(FBuffer,
          FMenuButtonRect.left,
          FMenuButtonRect.top,
          FMenuButtonRect.Bottom - 1,
          BorderColor,
          FTabClipRect);

      // Draw right vertical line of Menu Button
      if DrawRounded then
        TGuiTools.DrawVLine(FBuffer,
          FMenuButtonRect.Right - aCornerRadius + 1,
          FMenuButtonRect.top + aCornerRadius,
          FMenuButtonRect.Bottom - 1,
          BorderColor,
          FTabClipRect)
      else
      TGuiTools.DrawVLine(FBuffer,
        FMenuButtonRect.Right,
        FMenuButtonRect.top,
        FMenuButtonRect.Bottom - 1,
        BorderColor,
        FTabClipRect);

      // Draw left top corner of Menu Button
      if DrawRounded then
        TGuiTools.DrawAARoundCorner(FBuffer,
                                  {$IFDEF EnhancedRecordSupport}
          T2DIntPoint.Create(FMenuButtonRect.Left + aCornerRadius - 1, FMenuButtonRect.Top),
                                  {$ELSE}
          Create2DIntPoint(FMenuButtonRect.Left + aCornerRadius - 1, FMenuButtonRect.Top),
                                  {$ENDIF}
          aCornerRadius,
          cpLeftTop,
          BorderColor,
          FTabClipRect);

      // Draw right top corner of Menu Button
      if DrawRounded then
        TGuiTools.DrawAARoundCorner(FBuffer,
                                  {$IFDEF EnhancedRecordSupport}
          T2DIntPoint.Create(FMenuButtonRect.Right - 2 * aCornerRadius + 2, FMenuButtonRect.Top),
                                  {$ELSE}
          Create2DIntPoint(FMenuButtonRect.Right - 2 * aCornerRadius + 2, FMenuButtonRect.Top),
                                  {$ENDIF}
          aCornerRadius,
          cpRightTop,
          BorderColor,
          FTabClipRect);

      // Draw horizontal top line of Menu Button
      if DrawRounded then
        TGuiTools.DrawHLine(FBuffer,
          FMenuButtonRect.Left + 2 * aCornerRadius - 1,
          FMenuButtonRect.Right - 2 * aCornerRadius + 1,
          FMenuButtonRect.Top,
          BorderColor,
          FTabClipRect)
      else
        TGuiTools.DrawHLine(FBuffer,
          FMenuButtonRect.Left,
          FMenuButtonRect.Right,
          FMenuButtonRect.Top,
          BorderColor,
          FTabClipRect);

    end;

    procedure DrawMenuButtonText(AFont: TFont; AOverrideTextColor: TColor = clNone);
    var
      x, y: integer;
      clr: TColor;
    begin
      FBuffer.canvas.font.Assign(AFont);

      if AOverrideTextColor <> clNone then
        clr := AOverrideTextColor
      else
        clr := AFont.Color;

      Case FMenuButtonStyle of
      mbsCaption:
        begin
          x := FMenuButtonRect.Left + (FMenuButtonRect.Width - FBuffer.Canvas.textwidth(
            FMenuButtonCaption)) div 2;
          y := FMenuButtonRect.Top + (FMenuButtonRect.Height - FBuffer.Canvas.Textheight('Wy')) div 2;
        end;
      mbsCaptionDropdown:
        begin
          x := FMenuButtonRect.Left + (FMenuButtonRect.Width - FBuffer.Canvas.textwidth(
            FMenuButtonCaption) - SmallButtonDropdownWidth) div 2;
          y := FMenuButtonRect.Top + (FMenuButtonRect.Height - FBuffer.Canvas.Textheight('Wy')) div 2;
        end;
      end;

      TGuiTools.DrawText(FBuffer.Canvas,
        x,
        y,
        FMenuButtonCaption,
        clr,
        FTabClipRect);
    end;

    procedure DrawMenuButtonDropdownArrow(AFont: TFont; AOverrideTextColor: TColor = clNone);
    var
      dx: Integer;
      ARect: TRect;
      clr: TColor;
      P: array[0..3] of TPoint;
    begin
      dx := SmallButtonDropdownWidth;
      inc(dx, SmallButtonBorderWidth);

      ARect := Classes.Rect(FMenuButtonRect.Right - dx - ToolbarTabCaptionsTextHPadding - SmallButtonPadding,
        FMenuButtonRect.Top, FMenuButtonRect.Right, FMenuButtonRect.Bottom);

      if AOverrideTextColor <> clNone then
        clr := AOverrideTextColor
      else
        clr := AFont.Color;

      P[2].x := ARect.Left + (ARect.Right - ARect.Left) div 2;
      P[2].y := ARect.Top + (ARect.Bottom - ARect.Top + DropDownArrowHeight) div 2 - 1;
      P[0] := Point(P[2].x - DropDownArrowWidth div 2, P[2].y - DropDownArrowHeight div 2);
      P[1] := Point(P[2].x + DropDownArrowWidth div 2, P[0].y);
      P[3] := P[0];
      FBuffer.Canvas.Brush.Color := clr;
      FBuffer.Canvas.Pen.Style := psClear;
      FBuffer.Canvas.Polygon(P);
    end;

  var
    aMenuButtonBorderColor: TColor;
    aMenuButtonGradientFrom: TColor;
    aMenuButtonGradientTo: TColor;
    aMenuButtonGradientKind: TBackgroundKind;
    aMenuButtonCaptionFont: TFont;
    aMenuButtonCaptionFontAltColor: TColor;
  begin
    // Choose colors according to Menu Button state
    case FMenuButtonState of
      mbtIdle:
      begin
        //aMenuButtonBorderColor := clGreen;
        //aMenuButtonGradientFrom := clRed;
        //aMenuButtonGradientTo := clYellow;
        //aMenuButtonGradientKind := bkVerticalGradient;
        //aMenuButtonCaptionFont := FAppearance.Tab.TabHeaderFont;
        //aMenuButtonCaptionFontAltColor := clWhite;
        aMenuButtonCaptionFont := FAppearance.MenuButton.CaptionFont;
        FAppearance.MenuButton.GetIdleColors(False, aMenuButtonCaptionFontAltColor,
          aMenuButtonBorderColor, aMenuButtonGradientFrom, aMenuButtonGradientTo,
          aMenuButtonGradientKind, 0);
      end;
      mbtHottrack:
      begin
        //aMenuButtonBorderColor := clRed;
        //aMenuButtonGradientFrom := clNavy;
        //aMenuButtonGradientTo := clBlue;
        //aMenuButtonGradientKind := bkVerticalGradient;
        //aMenuButtonCaptionFont := FAppearance.Tab.TabHeaderFont;
        //aMenuButtonCaptionFontAltColor := clWhite;
        aMenuButtonCaptionFont := FAppearance.MenuButton.CaptionFont;
        FAppearance.MenuButton.GetHotTrackColors(False, aMenuButtonCaptionFontAltColor,
          aMenuButtonBorderColor, aMenuButtonGradientFrom, aMenuButtonGradientTo,
          aMenuButtonGradientKind, 0);
      end;
      mbtPressed:
      begin
        //aMenuButtonBorderColor := clYellow;
        //aMenuButtonGradientFrom := clGreen;
        //aMenuButtonGradientTo := clRed;
        //aMenuButtonGradientKind := bkVerticalGradient;
        //aMenuButtonCaptionFont := FAppearance.Tab.TabHeaderFont;
        //aMenuButtonCaptionFontAltColor := clWhite;
        aMenuButtonCaptionFont := FAppearance.MenuButton.CaptionFont;
        FAppearance.MenuButton.GetActiveColors (False, aMenuButtonCaptionFontAltColor,
          aMenuButtonBorderColor, aMenuButtonGradientFrom, aMenuButtonGradientTo,
          aMenuButtonGradientKind, 0);
      end;
    end;

    // *** Menu button background ***
    DrawMenuButtonBackground(aMenuButtonBorderColor, aMenuButtonGradientFrom, aMenuButtonGradientTo, aMenuButtonGradientKind);

    // *** Menu button caption ***
    DrawMenuButtonText(aMenuButtonCaptionFont, aMenuButtonCaptionFontAltColor);

    // *** Menu button dropdown arrow ***
    if FMenuButtonStyle = mbsCaptionDropdown then
        DrawMenuButtonDropdownArrow(aMenuButtonCaptionFont, aMenuButtonCaptionFontAltColor);
  end;


  procedure DrawQuickAccessToolBar;
  var
    I, Img, Sz, X, Y: Integer;
    R, GlyphRect: TRect;
    Item: TLazRibbonQuickAccessItem;
    Hot, Down, Enabled, HasDropDown: Boolean;
    Fill1, Fill2, Border, GlyphColor: TColor;
    QImages: TCustomImageList;

    procedure DrawBelowRibbonStrip;
    var
      StripTop, StripBottom: Integer;
      J: Integer;
    begin
      if (FQuickAccessToolBar = nil) or
         (FQuickAccessToolBar.Position <> qapBelowRibbon) then
        Exit;

      StripBottom := Self.Height - 1;
      StripTop := StripBottom;
      for J := 0 to High(FQuickAccessRects) do
        if (FQuickAccessRects[J].Right > FQuickAccessRects[J].Left) and
           (FQuickAccessRects[J].Bottom > FQuickAccessRects[J].Top) then
          StripTop := Min(StripTop, FQuickAccessRects[J].Top - 3);

      if (FQuickAccessCustomizeRect.Right > FQuickAccessCustomizeRect.Left) and
         (FQuickAccessCustomizeRect.Bottom > FQuickAccessCustomizeRect.Top) then
        StripTop := Min(StripTop, FQuickAccessCustomizeRect.Top - 3);

      if (StripTop < 0) or (StripTop >= Self.Height) then
        Exit;

      FBuffer.Canvas.Brush.Style := bsSolid;
      FBuffer.Canvas.Brush.Color := TColorTools.Shade(FAppearance.Tab.GradientToColor, clWhite, 8);
      FBuffer.Canvas.FillRect(Rect(0, StripTop, Self.Width, Self.Height));
      TGuiTools.DrawHLine(FBuffer, 0, Self.Width - 1, StripTop,
        FAppearance.Tab.BorderColor);
      TGuiTools.DrawHLine(FBuffer, 0, Self.Width - 1, StripBottom,
        TColorTools.Shade(FAppearance.Tab.BorderColor, clWhite, 30));
    end;

    procedure DrawButtonFace(const ARect: TRect; AHot, ADown, AEnabled: Boolean);
    begin
      if (FQuickAccessToolBar.ButtonFrameStyle = qfsHotOnly) and AEnabled and (not AHot) and (not ADown) then
        Exit;

      if not AEnabled then
      begin
        Fill1 := TColorTools.Shade(Color, clWhite, 30);
        Fill2 := Fill1;
        Border := TColorTools.Shade(Color, clGray, 25);
      end
      else if ADown then
      begin
        Fill1 := TColorTools.Shade(FAppearance.MenuButton.ActiveGradientFromColor, clWhite, 18);
        Fill2 := FAppearance.MenuButton.ActiveGradientToColor;
        Border := FAppearance.MenuButton.ActiveFrameColor;
      end
      else if AHot then
      begin
        Fill1 := TColorTools.Shade(FAppearance.MenuButton.HotTrackGradientFromColor, clWhite, 20);
        Fill2 := FAppearance.MenuButton.HotTrackGradientToColor;
        Border := FAppearance.MenuButton.HotTrackFrameColor;
      end
      else
      begin
        Fill1 := TColorTools.Shade(Color, clWhite, 8);
        Fill2 := TColorTools.Shade(Color, clBlack, 4);
        Border := TColorTools.Shade(Color, FAppearance.Tab.BorderColor, 20);
      end;

      TGuiTools.DrawRoundRect(FBuffer.Canvas,
        {$IFDEF EnhancedRecordSupport}
        T2DIntRect.Create(ARect.Left, ARect.Top, ARect.Right - 1, ARect.Bottom - 1),
        {$ELSE}
        Create2DIntRect(ARect.Left, ARect.Top, ARect.Right - 1, ARect.Bottom - 1),
        {$ENDIF}
        3, Fill1, Fill2, bkVerticalGradient);
      FBuffer.Canvas.Brush.Style := bsClear;
      FBuffer.Canvas.Pen.Color := Border;
      FBuffer.Canvas.RoundRect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom, 5, 5);
    end;

    procedure DrawCaptionInitialGlyph(const ARect: TRect; const ACaption: String; AColor: TColor);
    var
      S: String;
    begin
      if ACaption <> '' then
        S := Copy(ACaption, 1, 1)
      else
        S := '•';
      FBuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
      FBuffer.Canvas.Font.Style := [fsBold];
      FBuffer.Canvas.Font.Color := AColor;
      X := ARect.Left + (ARect.Right - ARect.Left - FBuffer.Canvas.TextWidth(S)) div 2;
      Y := ARect.Top + (ARect.Bottom - ARect.Top - FBuffer.Canvas.TextHeight(S)) div 2;
      FBuffer.Canvas.TextOut(X, Y, S);
    end;

    procedure DrawOfficeFallbackGlyph(const ARect: TRect; const ACaption, AHint: String; AColor: TColor);
    var
      Key: String;
      CX, CY: Integer;
      P3: array[0..2] of TPoint;

      function ContainsAny(const AText: String; const Tokens: array of String): Boolean;
      var
        K: Integer;
      begin
        Result := False;
        for K := Low(Tokens) to High(Tokens) do
          if Pos(Tokens[K], AText) > 0 then
          begin
            Result := True;
            Exit;
          end;
      end;

      procedure SetPen(AWidth: Integer);
      begin
        FBuffer.Canvas.Pen.Color := AColor;
        FBuffer.Canvas.Pen.Width := AWidth;
        FBuffer.Canvas.Pen.Style := psSolid;
        FBuffer.Canvas.Brush.Style := bsClear;
      end;

      procedure DrawDocument;
      begin
        SetPen(1);
        FBuffer.Canvas.Rectangle(CX - 5, CY - 7, CX + 5, CY + 7);
        FBuffer.Canvas.Line(CX + 1, CY - 7, CX + 5, CY - 3);
        FBuffer.Canvas.Line(CX + 1, CY - 7, CX + 1, CY - 3);
        FBuffer.Canvas.Line(CX + 1, CY - 3, CX + 5, CY - 3);
        FBuffer.Canvas.Line(CX - 3, CY - 1, CX + 3, CY - 1);
        FBuffer.Canvas.Line(CX - 3, CY + 3, CX + 3, CY + 3);
      end;

      procedure DrawNew;
      begin
        DrawDocument;
        SetPen(2);
        FBuffer.Canvas.Line(CX + 6, CY + 2, CX + 12, CY + 2);
        FBuffer.Canvas.Line(CX + 9, CY - 1, CX + 9, CY + 5);
      end;

      procedure DrawOpen;
      begin
        SetPen(1);
        FBuffer.Canvas.Rectangle(CX - 7, CY - 4, CX + 7, CY + 6);
        FBuffer.Canvas.MoveTo(CX - 7, CY - 4);
        FBuffer.Canvas.LineTo(CX - 3, CY - 8);
        FBuffer.Canvas.LineTo(CX + 7, CY - 8);
        FBuffer.Canvas.LineTo(CX + 9, CY - 4);
        FBuffer.Canvas.LineTo(CX - 7, CY - 4);
      end;

      procedure DrawSave;
      begin
        SetPen(1);
        FBuffer.Canvas.Rectangle(CX - 7, CY - 7, CX + 7, CY + 7);
        FBuffer.Canvas.Rectangle(CX - 4, CY - 6, CX + 4, CY - 2);
        FBuffer.Canvas.Rectangle(CX - 4, CY + 2, CX + 4, CY + 7);
      end;

      procedure DrawUndoRedo(ARedo: Boolean);
      begin
        SetPen(2);
        if ARedo then
        begin
          FBuffer.Canvas.Arc(CX - 8, CY - 7, CX + 8, CY + 9, CX + 6, CY - 4, CX - 5, CY + 5);
          P3[0] := Point(CX + 5, CY - 7);
          P3[1] := Point(CX + 10, CY - 5);
          P3[2] := Point(CX + 6, CY - 1);
        end
        else
        begin
          FBuffer.Canvas.Arc(CX - 8, CY - 7, CX + 8, CY + 9, CX - 6, CY - 4, CX + 5, CY + 5);
          P3[0] := Point(CX - 5, CY - 7);
          P3[1] := Point(CX - 10, CY - 5);
          P3[2] := Point(CX - 6, CY - 1);
        end;
        FBuffer.Canvas.Brush.Color := AColor;
        FBuffer.Canvas.Pen.Style := psClear;
        FBuffer.Canvas.Polygon(P3);
        FBuffer.Canvas.Pen.Style := psSolid;
      end;

      procedure DrawPrint;
      begin
        SetPen(1);
        FBuffer.Canvas.Rectangle(CX - 6, CY - 7, CX + 6, CY - 2);
        FBuffer.Canvas.Rectangle(CX - 8, CY - 2, CX + 8, CY + 5);
        FBuffer.Canvas.Rectangle(CX - 5, CY + 3, CX + 5, CY + 8);
      end;

      procedure DrawCloseExit;
      begin
        SetPen(2);
        FBuffer.Canvas.Line(CX - 5, CY - 5, CX + 5, CY + 5);
        FBuffer.Canvas.Line(CX + 5, CY - 5, CX - 5, CY + 5);
      end;

      procedure DrawOptions;
      var
        A, PX, PY: Integer;
      begin
        SetPen(1);
        for A := 0 to 7 do
        begin
          PX := CX + Round(Cos(A * Pi / 4) * 6);
          PY := CY + Round(Sin(A * Pi / 4) * 6);
          FBuffer.Canvas.Ellipse(PX - 1, PY - 1, PX + 2, PY + 2);
        end;
        FBuffer.Canvas.Ellipse(CX - 3, CY - 3, CX + 4, CY + 4);
      end;

    begin
      Key := LowerCase(ACaption + ' ' + AHint);
      CX := (ARect.Left + ARect.Right) div 2;
      CY := (ARect.Top + ARect.Bottom) div 2;

      if ContainsAny(Key, ['novo', 'new']) then
        DrawNew
      else if ContainsAny(Key, ['abrir', 'open']) then
        DrawOpen
      else if ContainsAny(Key, ['salvar', 'save']) then
        DrawSave
      else if ContainsAny(Key, ['desfazer', 'undo']) then
        DrawUndoRedo(False)
      else if ContainsAny(Key, ['refazer', 'redo']) then
        DrawUndoRedo(True)
      else if ContainsAny(Key, ['imprimir', 'print']) then
        DrawPrint
      else if ContainsAny(Key, ['sair', 'exit', 'fechar', 'close']) then
        DrawCloseExit
      else if ContainsAny(Key, ['opções', 'opcoes', 'options', 'config']) then
        DrawOptions
      else
        DrawDocument;

      FBuffer.Canvas.Pen.Width := 1;
      FBuffer.Canvas.Pen.Style := psSolid;
      FBuffer.Canvas.Brush.Style := bsSolid;
    end;

    procedure DrawCustomizeArrow(const ARect: TRect; AColor: TColor);
    var
      P: array[0..3] of TPoint;
      CX, CY: Integer;
    begin
      CX := (ARect.Left + ARect.Right) div 2;
      CY := (ARect.Top + ARect.Bottom) div 2 + 1;
      P[0] := Point(CX - 4, CY - 2);
      P[1] := Point(CX + 4, CY - 2);
      P[2] := Point(CX, CY + 3);
      P[3] := P[0];
      FBuffer.Canvas.Brush.Color := AColor;
      FBuffer.Canvas.Pen.Style := psClear;
      FBuffer.Canvas.Polygon(P);
      FBuffer.Canvas.Pen.Style := psSolid;
    end;

    procedure DrawItemDropdownArrow(const ARect: TRect; AColor: TColor);
    var
      P: array[0..2] of TPoint;
      CX, CY: Integer;
    begin
      CX := ARect.Right - 5;
      CY := (ARect.Top + ARect.Bottom) div 2 + 1;
      P[0] := Point(CX - 3, CY - 2);
      P[1] := Point(CX + 3, CY - 2);
      P[2] := Point(CX, CY + 2);
      FBuffer.Canvas.Brush.Color := AColor;
      FBuffer.Canvas.Pen.Style := psClear;
      FBuffer.Canvas.Polygon(P);
      FBuffer.Canvas.Pen.Style := psSolid;
    end;

  begin
    if (FQuickAccessToolBar = nil) or (not FQuickAccessToolBar.Visible) then Exit;

    DrawBelowRibbonStrip;

    for I := 0 to High(FQuickAccessRects) do
    begin
      if (I >= FQuickAccessToolBar.Items.Count) then Continue;
      R := FQuickAccessRects[I];
      if (R.Right <= R.Left) or (R.Bottom <= R.Top) then Continue;
      Item := FQuickAccessToolBar.Items[I];
      if not Item.EffectiveVisible then Continue;

      Hot := FQuickAccessHoverIndex = I;
      Down := (FQuickAccessActiveIndex = I) and Hot;
      Enabled := Item.EffectiveEnabled;
      DrawButtonFace(R, Hot, Down, Enabled);

      if Enabled then
        GlyphColor := FAppearance.Element.CaptionFont.Color
      else
        GlyphColor := clGray;

      HasDropDown := Item.HasLinkedDropDown;
      GlyphRect := R;
      if HasDropDown then
        Dec(GlyphRect.Right, 6);

      Img := Item.EffectiveImageIndex;
      QImages := FQuickAccessToolBar.Images;
      if QImages = nil then
        QImages := FImages;
      if (Img >= 0) and (QImages <> nil) and (Img < QImages.Count) then
      begin
        Sz := Max(16, QImages.Width);
        X := GlyphRect.Left + ((GlyphRect.Right - GlyphRect.Left) - Sz) div 2;
        Y := GlyphRect.Top + ((GlyphRect.Bottom - GlyphRect.Top) - Sz) div 2;
        QImages.Draw(FBuffer.Canvas, X, Y, Img, Enabled);
      end
      else
      begin
        case FQuickAccessToolBar.FallbackGlyphStyle of
          qfgOfficeGlyphs:
            DrawOfficeFallbackGlyph(GlyphRect, Item.EffectiveCaption, Item.EffectiveHint, GlyphColor);
          qfgCaptionInitial:
            DrawCaptionInitialGlyph(GlyphRect, Item.EffectiveCaption, GlyphColor);
          qfgNone:
            ;
        end;
      end;

      if HasDropDown then
        DrawItemDropdownArrow(R, GlyphColor);
    end;

    if (FQuickAccessToolBar.ShowCustomizeButton) and
       (FQuickAccessToolBar.AllowQuickCustomizing) and
       (FQuickAccessCustomizeRect.Right > FQuickAccessCustomizeRect.Left) then
    begin
      R := FQuickAccessCustomizeRect;
      Hot := FQuickAccessHoverIndex = -2;
      Down := (FQuickAccessActiveIndex = -2) and Hot;
      DrawButtonFace(R, Hot, Down, True);
      DrawCustomizeArrow(R, FAppearance.Element.CaptionFont.Color);
    end;
  end;

  procedure DrawCollapseButton;
  var
    R: TRect;
    Fill1, Fill2, Border, GlyphColor: TColor;
    CX, CY: Integer;
    P: array[0..2] of TPoint;
  begin
    if (not FShowCollapseButton) or
       (FCollapseButtonRect.Right <= FCollapseButtonRect.Left) then
      Exit;

    R := FCollapseButtonRect;
    case FCollapseButtonState of
      mbtPressed:
        begin
          Fill1 := FAppearance.MenuButton.ActiveGradientFromColor;
          Fill2 := FAppearance.MenuButton.ActiveGradientToColor;
          Border := FAppearance.MenuButton.ActiveFrameColor;
        end;
      mbtHottrack:
        begin
          Fill1 := FAppearance.MenuButton.HotTrackGradientFromColor;
          Fill2 := FAppearance.MenuButton.HotTrackGradientToColor;
          Border := FAppearance.MenuButton.HotTrackFrameColor;
        end;
    else
      begin
        Fill1 := TColorTools.Shade(Color, clWhite, 18);
        Fill2 := TColorTools.Shade(Color, clBlack, 4);
        Border := TColorTools.Shade(FAppearance.Tab.BorderColor, clWhite, 10);
      end;
    end;

    TGuiTools.DrawRoundRect(FBuffer.Canvas,
      {$IFDEF EnhancedRecordSupport}
      T2DIntRect.Create(R.Left, R.Top, R.Right - 1, R.Bottom - 1),
      {$ELSE}
      Create2DIntRect(R.Left, R.Top, R.Right - 1, R.Bottom - 1),
      {$ENDIF}
      2, Fill1, Fill2, bkVerticalGradient);
    FBuffer.Canvas.Brush.Style := bsClear;
    FBuffer.Canvas.Pen.Color := Border;
    FBuffer.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

    if FRibbonMinimized then
      GlyphColor := FAppearance.Element.CaptionFont.Color
    else
      GlyphColor := FAppearance.Element.CaptionFont.Color;

    CX := (R.Left + R.Right) div 2;
    CY := (R.Top + R.Bottom) div 2;
    if FRibbonMinimized then
    begin
      { Expand: arrow down }
      P[0] := Point(CX - 4, CY - 2);
      P[1] := Point(CX + 4, CY - 2);
      P[2] := Point(CX, CY + 3);
    end
    else
    begin
      { Collapse: arrow up }
      P[0] := Point(CX - 4, CY + 2);
      P[1] := Point(CX + 4, CY + 2);
      P[2] := Point(CX, CY - 3);
    end;
    FBuffer.Canvas.Brush.Style := bsSolid;
    FBuffer.Canvas.Brush.Color := GlyphColor;
    FBuffer.Canvas.Pen.Style := psClear;
    FBuffer.Canvas.Polygon(P);
    FBuffer.Canvas.Pen.Style := psSolid;
  end;

  procedure DrawHelpButton;
  var
    R: TRect;
    Fill1, Fill2, Border, GlyphColor: TColor;
    Txt: String;
    TX, TY: Integer;
  begin
    if (not FShowHelpButton) or
       (FHelpButtonRect.Right <= FHelpButtonRect.Left) then
      Exit;

    R := FHelpButtonRect;
    case FHelpButtonState of
      mbtPressed:
        begin
          Fill1 := FAppearance.MenuButton.ActiveGradientFromColor;
          Fill2 := FAppearance.MenuButton.ActiveGradientToColor;
          Border := FAppearance.MenuButton.ActiveFrameColor;
        end;
      mbtHottrack:
        begin
          Fill1 := FAppearance.MenuButton.HotTrackGradientFromColor;
          Fill2 := FAppearance.MenuButton.HotTrackGradientToColor;
          Border := FAppearance.MenuButton.HotTrackFrameColor;
        end;
    else
      begin
        Fill1 := TColorTools.Shade(Color, clWhite, 18);
        Fill2 := TColorTools.Shade(Color, clBlack, 4);
        Border := TColorTools.Shade(FAppearance.Tab.BorderColor, clWhite, 10);
      end;
    end;

    TGuiTools.DrawRoundRect(FBuffer.Canvas,
      {$IFDEF EnhancedRecordSupport}
      T2DIntRect.Create(R.Left, R.Top, R.Right - 1, R.Bottom - 1),
      {$ELSE}
      Create2DIntRect(R.Left, R.Top, R.Right - 1, R.Bottom - 1),
      {$ENDIF}
      2, Fill1, Fill2, bkVerticalGradient);
    FBuffer.Canvas.Brush.Style := bsClear;
    FBuffer.Canvas.Pen.Color := Border;
    FBuffer.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

    GlyphColor := FAppearance.Element.CaptionFont.Color;
    Txt := '?';
    FBuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
    FBuffer.Canvas.Font.Style := [fsBold];
    FBuffer.Canvas.Font.Color := GlyphColor;
    TX := R.Left + ((R.Right - R.Left) - FBuffer.Canvas.TextWidth(Txt)) div 2;
    TY := R.Top + ((R.Bottom - R.Top) - FBuffer.Canvas.TextHeight(Txt)) div 2;
    FBuffer.Canvas.TextOut(TX, TY, Txt);
  end;


  procedure DrawKeyTipsOverlay;
  var
    I, J, K: Integer;
    Tip: String;
    R: TRect;
    Pane: TLazRibbonPane;
    Item: TLazRibbonBaseItem;

    function CleanKeyTip(const S: String): String;
    begin
      Result := UpperCase(Trim(StringReplace(S, '&', '', [rfReplaceAll])));
    end;

    function FirstCaptionKey(const S: String): String;
    var
      Clean: String;
    begin
      Clean := StringReplace(Trim(S), '&', '', [rfReplaceAll]);
      if Clean <> '' then
        Result := UpperCase(Copy(Clean, 1, 1))
      else
        Result := '';
    end;

    function ApplicationKeyTipText: String;
    begin
      Result := CleanKeyTip(FApplicationButton.KeyTip);
      if Result = '' then
        Result := FirstCaptionKey(FMenuButtonCaption);
      if Result = '' then
        Result := 'F';
    end;

    function TabKeyTipText(ATab: TLazRibbonTab): String;
    begin
      Result := CleanKeyTip(ATab.KeyTip);
      if Result = '' then
        Result := FirstCaptionKey(ATab.Caption);
    end;

    function ItemKeyTipText(AItem: TLazRibbonBaseItem): String;
    begin
      Result := CleanKeyTip(AItem.KeyTip);
      if (Result = '') and (AItem is TLazRibbonBaseButton) then
        Result := FirstCaptionKey(TLazRibbonBaseButton(AItem).Caption);
    end;

    function VisibleKeyTipText(const ATip: String): String;
    begin
      if ATip = '' then
        Exit('');

      if FKeyTipsPrefix = '' then
        Exit(ATip);

      if Copy(ATip, 1, Length(FKeyTipsPrefix)) <> FKeyTipsPrefix then
        Exit('');

      Result := Copy(ATip, Length(FKeyTipsPrefix) + 1, MaxInt);
      if Result = '' then
        Result := ATip;
    end;

    procedure DrawKeyTipBox(const AText: String; const AAnchor: TRect; ATopPreferred: Boolean);
    var
      Box: TRect;
      W, H, X, Y: Integer;
    begin
      if AText = '' then Exit;

      FBuffer.Canvas.Font.Assign(FAppearance.Element.CaptionFont);
      FBuffer.Canvas.Font.Style := [fsBold];
      W := FBuffer.Canvas.TextWidth(AText) + 12;
      H := FBuffer.Canvas.TextHeight('Wy') + 6;
      X := AAnchor.Left + ((AAnchor.Right - AAnchor.Left) - W) div 2;
      if ATopPreferred then
        Y := AAnchor.Top + 3
      else
        Y := AAnchor.Bottom - H - 3;

      if X < 2 then X := 2;
      if X + W > Width - 2 then X := Width - W - 2;
      if Y < 2 then Y := 2;
      if Y + H > Height - 2 then Y := Height - H - 2;

      Box := Rect(X, Y, X + W, Y + H);
      FBuffer.Canvas.Brush.Style := bsSolid;
      FBuffer.Canvas.Brush.Color := clInfoBk;
      FBuffer.Canvas.Pen.Style := psSolid;
      FBuffer.Canvas.Pen.Color := clGray;
      FBuffer.Canvas.Rectangle(Box.Left, Box.Top, Box.Right, Box.Bottom);
      FBuffer.Canvas.Font.Color := clBlack;
      FBuffer.Canvas.TextOut(Box.Left + 6, Box.Top + 3, AText);
    end;

  begin
    if (not FShowKeyTips) or (not FKeyTipsVisible) then Exit;

    if FKeyTipsStage = rktsTopLevel then
    begin
      if FShowMenuButton then
        DrawKeyTipBox(VisibleKeyTipText(ApplicationKeyTipText), FMenuButtonRect.ForWinAPI, False);

      if (FQuickAccessToolBar <> nil) and FQuickAccessToolBar.Visible and
         (FQuickAccessToolBar.Position <> qapTitleBar) then
        for I := 0 to High(FQuickAccessRects) do
        begin
          if I >= FQuickAccessToolBar.Items.Count then Continue;
          if not FQuickAccessToolBar.Items[I].EffectiveVisible then Continue;
          R := FQuickAccessRects[I];
          if (R.Right <= R.Left) or (R.Bottom <= R.Top) then Continue;
          Tip := CleanKeyTip(FQuickAccessToolBar.Items[I].FKeyTip);
          if Tip = '' then
            Tip := IntToStr(I + 1);
          DrawKeyTipBox(VisibleKeyTipText(Tip), R, False);
        end;

      if FTabs <> nil then
        for I := 0 to FTabs.Count - 1 do
          if FTabs[I].Visible then
            DrawKeyTipBox(VisibleKeyTipText(TabKeyTipText(FTabs[I])), FTabRects[I].ForWinAPI, False);
      Exit;
    end;

    if (FKeyTipsStage = rktsActiveTabCommands) and
       (FTabIndex >= 0) and (FTabs <> nil) and (FTabIndex < FTabs.Count) and
       (not FRibbonMinimized) then
      for J := 0 to FTabs[FTabIndex].Panes.Count - 1 do
      begin
        Pane := FTabs[FTabIndex].Panes[J];
        if (Pane = nil) or (not Pane.Visible) then Continue;
        for K := 0 to Pane.Items.Count - 1 do
        begin
          Item := Pane.Items[K];
          if (Item = nil) or (not Item.Visible) then Continue;
          Tip := VisibleKeyTipText(ItemKeyTipText(Item));
          if Tip <> '' then
          begin
            R := Item.Rect.ForWinAPI;
            DrawKeyTipBox(Tip, R, True);
          end;
        end;
      end;
  end;

begin
  if (csDestroying in ComponentState) or FInternalUpdating or FUpdating or (FBuffer = nil) then
    exit;
  if FBufferValid then
    exit;

  // ValidateBuffer could be called only when metrics is calulated
  //Method assumes that buffer has proper sizes and all rects of toolbar and
  //sub-elements are correctly calculated

  // *** Component background ***
  DrawBackgroundColor;

  // *** The toolbar background is generated ***
  DrawBody;

  // *** Contextual tab group headers ***
  DrawContextualGroupHeaders;

  // *** Tabs ***
  DrawTabs;

  // *** Quick Access Toolbar ***
  DrawQuickAccessToolBar;

  // *** Collapse/expand Ribbon button ***
  DrawCollapseButton;

  // *** Help button ***
  DrawHelpButton;

  // *** Tabs content ***
  DrawTabContents;

  // *** Menu button ***
  if FShowMenuButton then
    DrawMenuButton;

  // *** KeyTips overlay ***
  DrawKeyTipsOverlay;

  // Buffer is correct
  FBufferValid := True;
end;

procedure TLazRibbon.ValidateMetrics;
var
  i: integer;
  x: integer;
  TabWidth: integer;
  TabAppearance: TLazRibbonToolbarAppearance;
  MenuButtonWidth: Integer;
  AdditionalPadding: Boolean;
  MenuButtonTextWidth: Integer;
  ToolbarHeight: Integer;
  sgn: Integer;
  isRTL: Boolean;
  QATButtonSize, QATGap, QATX, QATY, QATI, QATWidth, QATExtraHeight: Integer;
  CollapseButtonSize, CollapseButtonReserve: Integer;
  RightButtonLeft, RightButtonRight: Integer;
  ContextHeaderHeight: Integer;
  HeaderCaptionWidth: Integer;
  HeaderDesiredWidth: Integer;
  GroupNaturalWidth: Integer;
  GroupIndex: Integer;
  GroupTabAppearance: TLazRibbonToolbarAppearance;
  PrevVisibleTabIndex: Integer;
  ContextualGroupGap: Integer;
  ScaledTabCaptionHorizontalPadding: Integer;
  ScaledTabCaptionSpacing: Integer;
  ScaledMinTabCaptionWidth: Integer;
 {$IFDEF LCLCocoa}
  scalefactor: Double;
 {$ENDIF}

  function CalculateTabCaptionWidth(AAppearance: TLazRibbonToolbarAppearance;
    const ACaption: String): Integer;
  begin
    FBuffer.Canvas.Font.Assign(AAppearance.Tab.TabHeaderFont);
    Result := 2 +  // Frame
      2 * AAppearance.Tab.CornerRadius +
      2 * ScaledTabCaptionHorizontalPadding +
      Max(ScaledMinTabCaptionWidth, FBuffer.Canvas.TextWidth(ACaption));
  end;
begin
  if (csDestroying in ComponentState) or FInternalUpdating or FUpdating then
    exit;
  if FMetricsValid then
    exit;

  FreeAndNil(FBuffer);
  FBuffer := TBitmap.Create;
  ToolbarHeight := CalcToolbarHeight;
 {$IFDEF LCLCocoa}
  scalefactor := GetCanvasScaleFactor;
  FBuffer.SetSize(round(scaleFactor*Width), round(scaleFactor*ToolbarHeight));
  CGContextScaleCTM(TCocoaBitmapContext(FBuffer.Canvas.Handle).CGContext, scaleFactor, scaleFactor);
 {$ELSE}
  FBuffer.SetSize(Width, ToolbarHeight);
 {$ENDIF}
  SetBounds(Left, Top, FBuffer.Width, ToolbarHeight);

  isRTL := IsRightToLeft;
  sgn := IfThen(isRTL, -1, +1);

  // *** Tabs ***

  TabAppearance := FAppearance;
  ContextHeaderHeight := EffectiveContextualGroupHeaderHeight;
  ContextualGroupGap := 4;
  ScaledTabCaptionHorizontalPadding := Max(0,
    LazScaleX(FTabCaptionHorizontalPadding, 96, Screen.PixelsPerInch));
  ScaledTabCaptionSpacing := Max(0,
    LazScaleX(FTabCaptionSpacing, 96, Screen.PixelsPerInch));
  ScaledMinTabCaptionWidth := Max(0,
    LazScaleX(FMinTabCaptionWidth, 96, Screen.PixelsPerInch));

  CollapseButtonReserve := 0;
  CollapseButtonSize := Max(18, TabAppearance.Tab.CalcCaptionHeight - 6);
  FCollapseButtonRect := Rect(-1, -1, -1, -1);
  FHelpButtonRect := Rect(-1, -1, -1, -1);
  if FShowCollapseButton then
    Inc(CollapseButtonReserve, CollapseButtonSize + 4);
  if FShowHelpButton then
    Inc(CollapseButtonReserve, CollapseButtonSize + 4);
  if CollapseButtonReserve > 0 then
    Inc(CollapseButtonReserve, 4);

  if isRTL then
  begin
    RightButtonLeft := ToolbarCornerRadius + 4;
    if FShowHelpButton then
    begin
      FHelpButtonRect := Rect(RightButtonLeft, ContextHeaderHeight + 3, RightButtonLeft + CollapseButtonSize, ContextHeaderHeight + 3 + CollapseButtonSize);
      Inc(RightButtonLeft, CollapseButtonSize + 4);
    end;
    if FShowCollapseButton then
      FCollapseButtonRect := Rect(RightButtonLeft, ContextHeaderHeight + 3, RightButtonLeft + CollapseButtonSize, ContextHeaderHeight + 3 + CollapseButtonSize);
  end
  else
  begin
    RightButtonRight := Self.Width - ToolbarCornerRadius - 4;
    if FShowHelpButton then
    begin
      FHelpButtonRect := Rect(RightButtonRight - CollapseButtonSize, ContextHeaderHeight + 3, RightButtonRight, ContextHeaderHeight + 3 + CollapseButtonSize);
      Dec(RightButtonRight, CollapseButtonSize + 4);
    end;
    if FShowCollapseButton then
      FCollapseButtonRect := Rect(RightButtonRight - CollapseButtonSize, ContextHeaderHeight + 3, RightButtonRight, ContextHeaderHeight + 3 + CollapseButtonSize);
  end;

  // Cliprect of tabs (containg top frame of component)
{$IFDEF EnhancedRecordSupport}
  FTabClipRect := T2DIntRect.Create(
    ToolbarCornerRadius + IfThen(isRTL, CollapseButtonReserve, 0),
    0,
    self.Width - ToolbarCornerRadius - 1 - IfThen(not isRTL, CollapseButtonReserve, 0),
    ContextHeaderHeight + TabAppearance.Tab.CalcCaptionHeight);
{$ELSE}
  FTabClipRect.Create(
    ToolbarCornerRadius + IfThen(isRTL, CollapseButtonReserve, 0),
    0,
    self.Width - ToolbarCornerRadius - 1 - IfThen(not isRTL, CollapseButtonReserve, 0),
    ContextHeaderHeight + TabAppearance.Tab.CalcCaptionHeight);
{$ENDIF}

  // *** Menu button ***
  // Had to be calculated first, to adjust Tabs rects
  MenuButtonWidth := 0;
  AdditionalPadding := false;

  // Text
  FBuffer.Canvas.Font.Assign(TabAppearance.Element.CaptionFont);
  MenuButtonTextWidth := FBuffer.Canvas.TextWidth(FMenuButtonCaption);

  MenuButtonWidth := MenuButtonWidth + SmallButtonPadding + MenuButtonTextWidth;
  AdditionalPadding := true;

  // Padding behind the text or icon
  if AdditionalPadding then
    MenuButtonWidth := MenuButtonWidth + SmallButtonPadding;

  // The width of the Menu button content must be at least MENUBUTTON_MIN_WIDTH
  MenuButtonWidth := Max(MenuButtonMinWidth, MenuButtonWidth);

  // *** Dropdown ***
  case FMenuButtonStyle of
    mbsCaption:
      begin
        MenuButtonWidth := 2 + // Frame
          2 * TabAppearance.Tab.CornerRadius +
          // Curves
          2 * ToolbarTabCaptionsTextHPadding +
          // Internal margins
          Max(MenuButtonWidth, MenuButtonMinWidth);
      end;
    mbsCaptionDropdown:
      begin
        MenuButtonWidth := 2 + // Frame
          2 * TabAppearance.Tab.CornerRadius +
          // Curves
          2 * ToolbarTabCaptionsTextHPadding +
          // Internal margins
          Max(MenuButtonWidth + SmallButtonDropdownWidth, MenuButtonMinWidth);
      end;
  end;

  // Set Menu Button rect
  if isRTL then
  begin
    FMenuButtonRect.Right := Width;
    FMenuButtonRect.Left := Width - MenuButtonWidth;
  end else
  begin
    FMenuButtonRect.Left := 0;
    FMenuButtonRect.Right := MenuButtonWidth;
  end;
  FMenuButtonRect.Top := ContextHeaderHeight;
  FMenuButtonRect.Bottom := ContextHeaderHeight + FAppearance.Tab.CalcCaptionHeight;

  // *** Quick Access Toolbar ***
  if (FQuickAccessToolBar <> nil) and (FQuickAccessToolBar.ButtonSize > 0) then
    QATButtonSize := FQuickAccessToolBar.ButtonSize
  else
    QATButtonSize := Max(18, FAppearance.Tab.CalcCaptionHeight - 6);
  if FQuickAccessToolBar <> nil then
    QATGap := FQuickAccessToolBar.Spacing
  else
    QATGap := 2;
  SetLength(FQuickAccessRects, 0);
  FQuickAccessCustomizeRect := Rect(-1, -1, -1, -1);
  QATWidth := 0;
  QATExtraHeight := 0;

  if (FQuickAccessToolBar <> nil) and (FQuickAccessToolBar.Visible) then
  begin
    SetLength(FQuickAccessRects, FQuickAccessToolBar.Items.Count);
    for QATI := 0 to High(FQuickAccessRects) do
      FQuickAccessRects[QATI] := Rect(-1, -1, -1, -1);

    if FQuickAccessToolBar.Position = qapBelowRibbon then
    begin
      { The Office/DevExpress behavior is: "show below the Ribbon" means a
        narrow row below all panes/groups, not a row between the tab captions
        and the pane area.  CalcToolbarHeight already reserves this extra
        height; here the buttons are placed in that reserved bottom strip. }
      QATExtraHeight := QATButtonSize + 6;
      QATY := ToolbarHeight - QATExtraHeight + 3;
      if isRTL then
        QATX := Width - ToolbarCornerRadius - QATButtonSize - 4
      else
        QATX := ToolbarCornerRadius + 4;

      for QATI := 0 to FQuickAccessToolBar.Items.Count - 1 do
        if FQuickAccessToolBar.Items[QATI].EffectiveVisible then
        begin
          FQuickAccessRects[QATI] := Rect(QATX, QATY, QATX + QATButtonSize, QATY + QATButtonSize);
          if isRTL then
            Dec(QATX, QATButtonSize + QATGap)
          else
            Inc(QATX, QATButtonSize + QATGap);
          Inc(QATWidth, QATButtonSize + QATGap);
        end;
      if FQuickAccessToolBar.ShowCustomizeButton then
      begin
        FQuickAccessCustomizeRect := Rect(QATX, QATY, QATX + QATButtonSize, QATY + QATButtonSize);
        Inc(QATWidth, QATButtonSize + QATGap);
      end;
    end
    else if FQuickAccessToolBar.Position = qapBeforeTabs then
    begin
      if isRTL then
      begin
        if FShowMenuButton then
          QATX := FMenuButtonRect.Left - QATGap - QATButtonSize
        else
          QATX := Width - ToolbarCornerRadius - QATButtonSize - 2;

        for QATI := 0 to FQuickAccessToolBar.Items.Count - 1 do
          if FQuickAccessToolBar.Items[QATI].EffectiveVisible then
          begin
            FQuickAccessRects[QATI] := Rect(QATX, ContextHeaderHeight + 3, QATX + QATButtonSize, ContextHeaderHeight + 3 + QATButtonSize);
            Dec(QATX, QATButtonSize + QATGap);
            Inc(QATWidth, QATButtonSize + QATGap);
          end;
        if FQuickAccessToolBar.ShowCustomizeButton then
        begin
          FQuickAccessCustomizeRect := Rect(QATX, ContextHeaderHeight + 3, QATX + QATButtonSize, ContextHeaderHeight + 3 + QATButtonSize);
          Inc(QATWidth, QATButtonSize + QATGap);
        end;
      end
      else
      begin
        if FShowMenuButton then
          QATX := FMenuButtonRect.Right + QATGap + 2
        else
          QATX := ToolbarCornerRadius + 2;

        for QATI := 0 to FQuickAccessToolBar.Items.Count - 1 do
          if FQuickAccessToolBar.Items[QATI].EffectiveVisible then
          begin
            FQuickAccessRects[QATI] := Rect(QATX, ContextHeaderHeight + 3, QATX + QATButtonSize, ContextHeaderHeight + 3 + QATButtonSize);
            Inc(QATX, QATButtonSize + QATGap);
            Inc(QATWidth, QATButtonSize + QATGap);
          end;
        if FQuickAccessToolBar.ShowCustomizeButton then
        begin
          FQuickAccessCustomizeRect := Rect(QATX, ContextHeaderHeight + 3, QATX + QATButtonSize, ContextHeaderHeight + 3 + QATButtonSize);
          Inc(QATWidth, QATButtonSize + QATGap);
        end;
      end;
    end;
    { qapTitleBar is intentionally not laid out inside TLazRibbon. It is drawn
      and handled by TLazRibbonForm's custom title bar when the Ribbon property
      of the form points to this TLazRibbon instance. }
  end;

  // Rects of tabs headings (containg top frame of component)
  Setlength(FTabRects, FTabs.Count);
  if FTabs.Count > 0 then
  begin
    if isRTL then
      x := Width
    else
      x := 0;

    // Add left space for Application Button and Quick Access Toolbar before Tabs.
    if FShowMenuButton then
      inc(x, sgn * (ToolbarCornerRadius + (FMenuButtonRect.Right - FMenuButtonRect.Left) + 2))
    else
      inc(x, sgn * (ToolbarCornerRadius + 1));

    if (FQuickAccessToolBar <> nil) and (FQuickAccessToolBar.Visible) and
       (FQuickAccessToolBar.Position = qapBeforeTabs) and (QATWidth > 0) then
      inc(x, sgn * (QATWidth + 4));

    PrevVisibleTabIndex := -1;
    for i := 0 to FTabs.Count - 1 do
      if FTabs[i].Visible then
      begin
        { Give adjacent contextual groups a small visual breathing space.
          Without this, two visible contextual groups look like one continuous
          colored band even though their captions and colors are different. }
        if (ContextHeaderHeight > 0) and FTabs[i].Contextual and
           (Trim(FTabs[i].ContextualGroupCaption) <> '') and
           (PrevVisibleTabIndex >= 0) and FTabs[PrevVisibleTabIndex].Contextual and
           (not SameText(FTabs[PrevVisibleTabIndex].ContextualGroupCaption,
             FTabs[i].ContextualGroupCaption)) then
          Inc(x, sgn * ContextualGroupGap);

        // Loading appearance of tab
        if FTabs[i].OverrideAppearance then
          TabAppearance := FTabs[i].CustomAppearance
        else
          TabAppearance := FAppearance;
        FBuffer.Canvas.Font.Assign(TabAppearance.Tab.TabHeaderFont);

        TabWidth := CalculateTabCaptionWidth(TabAppearance, FTabs.Items[i].Caption);

        { Contextual group headers must not look like labels hanging outside
          the tab.  If a contextual group starts at this tab and its header
          caption is wider than the natural group width, expand the first tab
          enough for the header band to fit the group rectangle.  This keeps
          the visual group coherent even when there is only one contextual tab. }
        if (ContextHeaderHeight > 0) and FTabs[i].Contextual and
           (Trim(FTabs[i].ContextualGroupCaption) <> '') and
           ((i = 0) or (not FTabs[i - 1].Visible) or
            (not FTabs[i - 1].Contextual) or
            (not SameText(FTabs[i - 1].ContextualGroupCaption,
              FTabs[i].ContextualGroupCaption))) then
        begin
          FBuffer.Canvas.Font.Assign(FAppearance.Tab.TabHeaderFont);
          FBuffer.Canvas.Font.Style := [];
          HeaderCaptionWidth := FBuffer.Canvas.TextWidth(FTabs[i].ContextualGroupCaption);
          HeaderDesiredWidth := HeaderCaptionWidth + 16;

          GroupNaturalWidth := 0;
          GroupIndex := i;
          while (GroupIndex < FTabs.Count) and FTabs[GroupIndex].Visible and
                FTabs[GroupIndex].Contextual and
                SameText(FTabs[GroupIndex].ContextualGroupCaption,
                  FTabs[i].ContextualGroupCaption) do
          begin
            if GroupIndex > i then
              Inc(GroupNaturalWidth, ScaledTabCaptionSpacing);
            if FTabs[GroupIndex].OverrideAppearance then
              GroupTabAppearance := FTabs[GroupIndex].CustomAppearance
            else
              GroupTabAppearance := FAppearance;
            Inc(GroupNaturalWidth, CalculateTabCaptionWidth(GroupTabAppearance,
              FTabs.Items[GroupIndex].Caption));
            Inc(GroupIndex);
          end;

          if HeaderDesiredWidth > GroupNaturalWidth then
            Inc(TabWidth, HeaderDesiredWidth - GroupNaturalWidth);

          FBuffer.Canvas.Font.Assign(TabAppearance.Tab.TabHeaderFont);
        end;

        if isRTL then
        begin
          FTabRects[i].Right := x;
          FTabRects[i].Left := x - TabWidth + 1;
          x := FTabRects[i].Left - 1 - ScaledTabCaptionSpacing;
        end else
        begin
          FTabRects[i].Left := x;
          FTabRects[i].Right := x + TabWidth - 1;
          x := FTabRects[i].Right + 1 + ScaledTabCaptionSpacing;
        end;
        FTabRects[i].Top := ContextHeaderHeight;
        FTabRects[i].Bottom := ContextHeaderHeight + TabAppearance.Tab.CalcCaptionHeight;
        PrevVisibleTabIndex := i;
      end
      else
      begin
          {$IFDEF EnhancedRecordSupport}
        FTabRects[i] := T2DIntRect.Create(-1, -1, -1, -1);
          {$ELSE}
        FTabRects[i].Create(-1, -1, -1, -1);
          {$ENDIF}
      end;
  end;

  // *** Panes ***

  if (FTabIndex <> -1) and (not FRibbonMinimized) then
  begin
    // Rect of tab region
   {$IFDEF EnhancedRecordSupport}
    FTabContentsClipRect := T2DIntRect.Create(ToolbarBorderWidth + TabPaneLeftPadding,
      ContextHeaderHeight + TabAppearance.Tab.CalcCaptionHeight + ToolbarBorderWidth + TabPaneTopPadding,
      self.Width - 1 - ToolbarBorderWidth - TabPaneRightPadding,
      self.Height - 1 - ToolbarBorderWidth - TabPaneBottomPadding - QATExtraHeight);
   {$ELSE}
    FTabContentsClipRect.Create(ToolbarBorderWidth + TabPaneLeftPadding,
      ContextHeaderHeight + TabAppearance.Tab.CalcCaptionHeight + ToolbarBorderWidth + TabPaneTopPadding,
      self.Width - 1 - ToolbarBorderWidth - TabPaneRightPadding,
      self.Height - 1 - ToolbarBorderWidth - TabPaneBottomPadding - QATExtraHeight);
   {$ENDIF}

    FTabs[FTabIndex].Rect := FTabContentsClipRect;
  end
  else
  begin
   {$IFDEF EnhancedRecordSupport}
    FTabContentsClipRect := T2DIntRect.Create(-1, -1, -1, -1);
   {$ELSE}
    FTabContentsClipRect.Create(-1, -1, -1, -1);
   {$ENDIF}
  end;

  FMetricsValid := True;
end;

{$IF lcl_fullversion >= 1080000}
procedure TLazRibbon.DoAutoAdjustLayout(const AMode: TLayoutAdjustmentPolicy;
  const AXProportion, AYProportion: Double);
begin
  inherited;

  if not (AMode in [lapAutoAdjustWithoutHorizontalScrolling, lapAutoAdjustForDPI]) then
    exit;

  // Layout variables are global. Having multiple instances of LazToolbars in
  // the project would apply scaling for each instance in a accumulating way.
  LazInitLayoutConsts(96, Screen.PixelsPerInch);

  if ToolbartabCaptionsHeight > 0 then
    Appearance.Tab.CaptionHeight := ToolbarTabCaptionsHeight;
end;

{$IF lcl_fullversion < 1080100}
procedure TLazRibbon.ScaleFontsPPI(const AProportion: Double);
begin
  inherited;
  DoScaleFontPPI(FAppearance.Tab.TabHeaderFont, AProportion);
  DoScaleFontPPI(FAppearance.Pane.CaptionFont, AProportion);
  DoScaleFontPPI(FAppearance.Element.CaptionFont, AProportion);
  DoScaleFontPPI(FAppearance.MenuButton.CaptionFont, AProportion);
end;
{$ELSE}
procedure TLazRibbon.FixDesignFontsPPI(const ADesignTimePPI: Integer);
begin
  inherited;
  DoFixDesignFontPPI(FAppearance.Tab.TabHeaderFont, ADesignTimePPI);
  DoFixDesignFontPPI(FAppearance.Pane.CaptionFont, ADesignTimePPI);
  DoFixDesignFontPPI(FAppearance.Element.CaptionFont, ADesignTimePPI);
  DoFixDesignFontPPI(FAppearance.MenuButton.CaptionFont, ADesignTimePPI);
end;

procedure TLazRibbon.ScaleFontsPPI(const AToPPI: Integer;
  const AProportion: Double);
begin
  inherited;
  DoScaleFontPPI(FAppearance.Tab.TabHeaderFont, AToPPI, AProportion);
  DoScaleFontPPI(FAppearance.Pane.CaptionFont, AToPPI, AProportion);
  DoScaleFontPPI(FAppearance.Element.CaptionFont, AToPPI, AProportion);
  DoScaleFontPPI(FAppearance.MenuButton.CaptionFont, AToPPI, AProportion);
end;
{$ENDIF}
{$ENDIF}

{ Hi-DPI image list support }

procedure TLazRibbon.SetImagesWidth(const AValue: Integer);
begin
  if FImagesWidth = AValue then Exit;
  FImagesWidth := AValue;
  NotifyMetricsChanged
end;

procedure TLazRibbon.SetLargeImagesWidth(const AValue: Integer);
begin
  if FLargeImagesWidth = AValue then Exit;
  FLargeImagesWidth := AValue;
  NotifyMetricsChanged
end;

//************************************************************
//*** All added procs and funcs for Menu Button management ***
//************************************************************

// Setter for MenuButtonCaption
procedure TLazRibbon.SetMenuButtonCaption(Value: String);
begin
  if FMenuButtonCaption = Value then Exit;
  FMenuButtonCaption := Value;
  ConfigureBackstageView;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

// Setter for MenuButtonDropdownMenu
procedure TLazRibbon.SetMenuButtonDropdownMenu(const Value: TPopupMenu);
begin
  FMenuButtonDropdownMenu := Value;
  if (FMenuButtonDropdownMenu is TLazRibbonPopupMenu) then
    TLazRibbonPopupMenu(FMenuButtonDropdownMenu).Appearance := Self.Appearance;

  { Backwards compatibility: older projects used MenuButtonDropdownMenu as the
    signal that the menu button should open a popup. Keep that behavior, but
    expose the clearer ApplicationButtonMode/ApplicationMenu API for new code. }
  if (FMenuButtonDropdownMenu <> nil) and (FApplicationButtonMode = abmEvent) then
    FApplicationButtonMode := abmPopupMenu
  else if (FMenuButtonDropdownMenu = nil) and (FApplicationButtonMode = abmPopupMenu) then
    FApplicationButtonMode := abmEvent;

  //if Assigned(FToolbarDispatch) then
  //   FToolbarDispatch.NotifyMetricsChanged;
end;

// Setter for MenuButtonStyle
procedure TLazRibbon.SetMenuButtonStyle(Value: TLazRibbonMenuButtonStyle);
begin
  FMenuButtonStyle := Value;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

// Setter for ShowMenuButton
procedure TLazRibbon.SetShowMenuButton(Value: Boolean);
begin
  FShowMenuButton := Value;
  SetMetricsInvalid;
  if not (FInternalUpdating or FUpdating) then
    Repaint;
end;

// Get the point to dropdown menu of Menu Button. Match the left bottom
// corner of FMenuButtonRect.
function TLazRibbon.GetMenuButtonDropdownPoint: T2DIntPoint;
begin
  {$IFDEF EnhancedRecordSupport}
    Result := T2DIntPoint.Create(FMenuButtonRect.left, FMenuButtonRect.Bottom+1);
  {$ELSE}
    Result.Create(FMenuButtonRect.left, FMenuButtonRect.Bottom+1);
  {$ENDIF}
end;

// MouseMove to support Menu Button
procedure TLazRibbon.MenuButtonMouseMove(Shift: TShiftState; X, Y: integer);
begin
   //During rebuilding procees the mouse is ignored
   if FInternalUpdating or FUpdating then
     exit;

   // Change Menu Button state and repaint
   FMenuButtonState := mbtHottrack;
   SetMetricsInvalid;
   Repaint;
end;

// MouseLeave to support Menu Button
procedure TLazRibbon.MenuButtonMouseLeave;
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  // Change Menu Button state and repaint
  FMenuButtonState := mbtIdle;
  SetMetricsInvalid;
  Repaint;
end;

// MouseDown to support Menu Button
procedure TLazRibbon.MenuButtonMouseDown(Button: TMouseButton; {%H-}Shift: TShiftState;
  X, Y: integer);
begin
  //During rebuilding procees the mouse is ignored
   if FInternalUpdating or FUpdating then
     exit;

   // Change Menu Button state and repaint
   FMenuButtonState := mbtPressed;
   SetMetricsInvalid;
   Repaint;
end;

// MouseUp to support Menu Button
procedure TLazRibbon.MenuButtonMouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  aPopupPoint: TPoint;
begin
  //During rebuilding procees the mouse is ignored
  if FInternalUpdating or FUpdating then
    exit;

  // Change Menu Button state and repaint
  FMenuButtonState := mbtHottrack;
  SetMetricsInvalid;
  Repaint;

  case FApplicationButtonMode of
    abmPopupMenu:
      begin
        if Assigned(FMenuButtonDropdownMenu) and (FShowMenuButton) then
        begin
          aPopupPoint := ClientToScreen(GetMenuButtonDropdownPoint);
          TPopupMenu(FMenuButtonDropdownMenu).PopUp(aPopupPoint.X, aPopupPoint.Y);
        end
        else
          DoMenuButtonClick;
      end;

    abmBackstage:
      begin
        { The BackStage view hooks OnMenuButtonClick when attached.  Calling
          DoMenuButtonClick here preserves the previous integration and avoids
          a direct dependency on LazRibbon_Backstage in this unit. }
        DoMenuButtonClick;
      end;

  else
    DoMenuButtonClick;
  end;
end;

// Support for Menu Button click
procedure TLazRibbon.DoMenuButtonClick;
begin
  if Assigned(FOnMenuButtonClick) then
    FOnMenuButtonClick(self);
end;

function TLazRibbon.ElementAt(X, Y: Integer): TLazRibbonComponent;
var
  PaneIdx, ItemIdx: Integer;
begin
  if TabIndex < 0 then
    Result := nil
  else
  begin
    PaneIdx := Tabs[TabIndex].FindPaneAt(X, Y);
    if PaneIdx < 0 then
      Result := Tabs[TabIndex]
    else
    begin
      ItemIdx := Tabs[TabIndex].Panes[PaneIdx].FindItemAt(X, Y);
      if ItemIdx < 0 then
        Result := Tabs[TabIndex].Panes[PaneIdx]
      else
        Result := Tabs[TabIndex].Panes[PaneIdx].Items[TabIndex];
    end;
  end;
end;

procedure TLazRibbon.SetBiDiMode(Value: TBiDiMode);
begin
  if BiDiMode <> Value then
  begin
    inherited SetBiDiMode(Value);
    SetMetricsInvalid;
    if not (FInternalUpdating or FUpdating) then
      Repaint;
  end;
end;

end.
