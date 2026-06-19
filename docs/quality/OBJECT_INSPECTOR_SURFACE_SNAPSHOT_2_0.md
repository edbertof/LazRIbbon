# LazRibbon Object Inspector Surface Snapshot for 2.0

Generated from runtime source by `tools/export_object_inspector_snapshot.ps1`.
It lists direct `published` property declarations for the classes that define the package-facing Object Inspector surface.
Design-time `RegisterPropertyToSkip` rules may still hide inherited properties for narrower components; those decisions are documented in `OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md`.

Regenerate after changing published properties:

```powershell
powershell -ExecutionPolicy Bypass -File tools/export_object_inspector_snapshot.ps1 -OutputPath docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md
```

## Top-Level Shell

### TLazRibbonForm

Source: `source/runtime/LazRibbon_Form.pas`

- `Ribbon`: `property Ribbon: TLazRibbon read FRibbon write SetRibbon;`
- `SkinManager`: `property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;`
- `UseCustomTitleBar`: `property UseCustomTitleBar: Boolean read FUseCustomTitleBar write SetUseCustomTitleBar default True;`
- `TitleBarHeight`: `property TitleBarHeight: Integer read FTitleBarHeight write SetTitleBarHeight default 32;`
- `ShowSystemButtons`: `property ShowSystemButtons: Boolean read FShowSystemButtons write SetShowSystemButtons default True;`
- `ShowTitleIcon`: `property ShowTitleIcon: Boolean read FShowTitleIcon write SetShowTitleIcon default True;`
- `TitleIcon`: `property TitleIcon: TIcon read FTitleIcon write SetTitleIcon;`
- `TitleAlignment`: `property TitleAlignment: TAlignment read FTitleAlignment write SetTitleAlignment default taCenter;`

### TLazRibbon

Source: `source/runtime/LazRibbon_Core.pas`

- `ApplicationButton`: `property ApplicationButton: TLazRibbonApplicationButton read FApplicationButton write SetApplicationButton;`
- `QuickAccessToolBar`: `property QuickAccessToolBar: TLazRibbonQuickAccessToolBar read FQuickAccessToolBar write SetQuickAccessToolBar;`
- `RibbonMinimized`: `property RibbonMinimized: Boolean read FRibbonMinimized write SetRibbonMinimized default False;`
- `ShowMinimizeRibbonButton`: `property ShowMinimizeRibbonButton: Boolean read FShowMinimizeRibbonButton write SetShowMinimizeRibbonButton default True;`
- `MinimizeRibbonHint`: `property MinimizeRibbonHint: String read FMinimizeRibbonHint write SetMinimizeRibbonHint;`
- `RestoreRibbonHint`: `property RestoreRibbonHint: String read FRestoreRibbonHint write SetRestoreRibbonHint;`
- `ShowHelpButton`: `property ShowHelpButton: Boolean read FShowHelpButton write SetShowHelpButton default True;`
- `ShowKeyTips`: `property ShowKeyTips: Boolean read FShowKeyTips write SetShowKeyTips default True;`
- `ShowContextualGroupHeaders`: `property ShowContextualGroupHeaders: Boolean read FShowContextualGroupHeaders write SetShowContextualGroupHeaders default True;`
- `ContextualGroupHeaderHeight`: `property ContextualGroupHeaderHeight: Integer read FContextualGroupHeaderHeight write SetContextualGroupHeaderHeight default 18;`
- `TabCaptionHorizontalPadding`: `property TabCaptionHorizontalPadding: Integer read FTabCaptionHorizontalPadding write SetTabCaptionHorizontalPadding default LAZRIBBON_DEFAULT_TAB_CAPTION_HORIZONTAL_PADDING;`
- `TabCaptionSpacing`: `property TabCaptionSpacing: Integer read FTabCaptionSpacing write SetTabCaptionSpacing default LAZRIBBON_DEFAULT_TAB_CAPTION_SPACING;`
- `MinTabCaptionWidth`: `property MinTabCaptionWidth: Integer read FMinTabCaptionWidth write SetMinTabCaptionWidth default LAZRIBBON_DEFAULT_MIN_TAB_CAPTION_WIDTH;`
- `HelpButtonHint`: `property HelpButtonHint: String read FHelpButtonHint write SetHelpButtonHint;`
- `OnHelpButtonClick`: `property OnHelpButtonClick: TNotifyEvent read FOnHelpButtonClick write FOnHelpButtonClick;`
- `OnRibbonMinimizedChanged`: `property OnRibbonMinimizedChanged: TNotifyEvent read FOnRibbonMinimizedChanged write FOnRibbonMinimizedChanged;`
- `Color`: `property Color: TColor read GetColor write SetColor default clSkyBlue;`
- `Style`: `property Style: TLazRibbonStyle read FStyle write SetStyle default lazOffice2007Blue;`
- `AppearanceSource`: `property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asInternalStyle;`
- `SkinManager`: `property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;`
- `BackstageView`: `property BackstageView: TLazRibbonCustomBackstageView read FBackstageView write SetBackstageView;`
- `RibbonAppearance`: `property RibbonAppearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;`
- `TabIndex`: `property TabIndex: integer read FTabIndex write SetTabIndex;`
- `Images`: `property Images: TImageList read FImages write SetImages;`
- `DisabledImages`: `property DisabledImages: TImageList read FDisabledImages write SetDisabledImages;`
- `LargeImages`: `property LargeImages: TImageList read FLargeImages write SetLargeImages;`
- `DisabledLargeImages`: `property DisabledLargeImages: TImageList read FDisabledLargeImages write SetDisabledLargeImages;`
- `ImagesWidth`: `property ImagesWidth: Integer read FImagesWidth write SetImagesWidth default 16;`
- `LargeImagesWidth`: `property LargeImagesWidth: Integer read FLargeImagesWidth write SetLargeImagesWidth default 32;`
- `OnTabChanging`: `property OnTabChanging: TLazRibbonTabChangingEvent read FOnTabChanging write FOnTabChanging;`
- `OnTabChanged`: `property OnTabChanged: TNotifyEvent read FOnTabChanged write FOnTabChanged;`
- `Align`: `property Align default alTop;`
- `BiDiMode`: `property BiDiMode;`
- `BorderSpacing`: `property BorderSpacing;`
- `Anchors`: `property Anchors;`
- `Hint`: `property Hint;`
- `ParentShowHint`: `property ParentShowHint;`
- `ShowHint`: `property ShowHint;`
- `Visible`: `property Visible;`
- `OnResize`: `property OnResize;`
- `OnShowHint`: `property OnShowHint;`

### TLazRibbonApplicationButton

Source: `source/runtime/LazRibbon_Core.pas`

- `Caption`: `property Caption: String read GetCaption write SetCaption;`
- `Visible`: `property Visible: Boolean read GetVisible write SetVisible default False;`
- `Mode`: `property Mode: TLazRibbonApplicationButtonMode read GetMode write SetMode default abmEvent;`
- `Style`: `property Style: TLazRibbonMenuButtonStyle read GetStyle write SetStyle default mbsCaption;`
- `Menu`: `property Menu: TPopupMenu read GetMenu write SetMenu;`
- `Glyph`: `property Glyph: TPicture read FGlyph write SetGlyph;`
- `ImageIndex`: `property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;`
- `Hint`: `property Hint: String read FHint write SetHint;`
- `KeyTip`: `property KeyTip: String read FKeyTip write SetKeyTip;`
- `ShowScreenTip`: `property ShowScreenTip: Boolean read FShowScreenTip write SetShowScreenTip default True;`
- `ScreenTipTitle`: `property ScreenTipTitle: String read FScreenTipTitle write SetScreenTipTitle;`
- `ScreenTipText`: `property ScreenTipText: String read FScreenTipText write SetScreenTipText;`
- `ScreenTipShortcut`: `property ScreenTipShortcut: String read FScreenTipShortcut write SetScreenTipShortcut;`
- `ScreenTipFooter`: `property ScreenTipFooter: String read FScreenTipFooter write SetScreenTipFooter;`
- `OnClick`: `property OnClick: TNotifyEvent read GetOnClick write SetOnClick;`

### TLazRibbonQuickAccessToolBar

Source: `source/runtime/LazRibbon_Core.pas`

- `Visible`: `property Visible: Boolean read FVisible write SetVisible default False;`
- `Position`: `property Position: TLazRibbonQuickAccessPosition read FPosition write SetPosition default qapBeforeTabs;`
- `Items`: `property Items: TLazRibbonQuickAccessItems read FItems write SetItems;`
- `ButtonFrameStyle`: `property ButtonFrameStyle: TLazRibbonQuickAccessButtonFrameStyle read FButtonFrameStyle write SetButtonFrameStyle default qfsHotOnly;`
- `ButtonSize`: `property ButtonSize: Integer read FButtonSize write SetButtonSize default 0;`
- `Spacing`: `property Spacing: Integer read FSpacing write SetSpacing default 2;`
- `FallbackGlyphStyle`: `property FallbackGlyphStyle: TLazRibbonQuickAccessFallbackGlyphStyle read FFallbackGlyphStyle write SetFallbackGlyphStyle default qfgOfficeGlyphs;`
- `CustomizeActionList`: `property CustomizeActionList: TCustomActionList read FCustomizeActionList write SetCustomizeActionList;`
- `CustomizeMenuTitle`: `property CustomizeMenuTitle: String read FCustomizeMenuTitle write SetCustomizeMenuTitle;`
- `MoreCommandsCaption`: `property MoreCommandsCaption: String read FMoreCommandsCaption write SetMoreCommandsCaption;`
- `StorageSection`: `property StorageSection: String read FStorageSection write SetStorageSection;`
- `ShowCustomizeButton`: `property ShowCustomizeButton: Boolean read FShowCustomizeButton write SetShowCustomizeButton default True;`
- `ShowMoreCommandsItem`: `property ShowMoreCommandsItem: Boolean read FShowMoreCommandsItem write SetShowMoreCommandsItem default False;`
- `ShowPositionMenuItem`: `property ShowPositionMenuItem: Boolean read FShowPositionMenuItem write SetShowPositionMenuItem default False;`
- `ShowMinimizeRibbonMenuItem`: `property ShowMinimizeRibbonMenuItem: Boolean read FShowMinimizeRibbonMenuItem write SetShowMinimizeRibbonMenuItem default False;`
- `ShowResetToDefaultsItem`: `property ShowResetToDefaultsItem: Boolean read FShowResetToDefaultsItem write SetShowResetToDefaultsItem default True;`
- `AllowCustomizing`: `property AllowCustomizing: Boolean read FAllowCustomizing write SetAllowCustomizing default True;`
- `AllowQuickCustomizing`: `property AllowQuickCustomizing: Boolean read FAllowQuickCustomizing write SetAllowQuickCustomizing default True;`
- `AllowReset`: `property AllowReset: Boolean read FAllowReset write SetAllowReset default True;`
- `AllowPositionChange`: `property AllowPositionChange: Boolean read FAllowPositionChange write SetAllowPositionChange default False;`
- `AllowMinimizeRibbon`: `property AllowMinimizeRibbon: Boolean read FAllowMinimizeRibbon write SetAllowMinimizeRibbon default False;`
- `Images`: `property Images: TCustomImageList read FImages write SetImages;`
- `ShowAboveRibbonCaption`: `property ShowAboveRibbonCaption: String read FShowAboveRibbonCaption write SetShowAboveRibbonCaption;`
- `ShowBelowRibbonCaption`: `property ShowBelowRibbonCaption: String read FShowBelowRibbonCaption write SetShowBelowRibbonCaption;`
- `MinimizeRibbonCaption`: `property MinimizeRibbonCaption: String read FMinimizeRibbonCaption write SetMinimizeRibbonCaption;`
- `RestoreRibbonCaption`: `property RestoreRibbonCaption: String read FRestoreRibbonCaption write SetRestoreRibbonCaption;`
- `ResetToDefaultsCaption`: `property ResetToDefaultsCaption: String read FResetToDefaultsCaption write SetResetToDefaultsCaption;`
- `OnCustomizeClick`: `property OnCustomizeClick: TNotifyEvent read FOnCustomizeClick write FOnCustomizeClick;`
- `OnMoreCommandsClick`: `property OnMoreCommandsClick: TNotifyEvent read FOnMoreCommandsClick write FOnMoreCommandsClick;`

### TLazRibbonQuickAccessItem

Source: `source/runtime/LazRibbon_Core.pas`

- `Caption`: `property Caption: TCaption read FCaption write SetCaption;`
- `Action`: `property Action: TBasicAction read FAction write SetAction;`
- `LinkedItem`: `property LinkedItem: TLazRibbonBaseItem read FLinkedItem write SetLinkedItem;`
- `ImageIndex`: `property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;`
- `Enabled`: `property Enabled: Boolean read FEnabled write SetEnabled default True;`
- `Visible`: `property Visible: Boolean read FVisible write SetVisible default True;`
- `Hint`: `property Hint: String read FHint write SetHint;`
- `KeyTip`: `property KeyTip: String read FKeyTip write SetKeyTip;`
- `ShowScreenTip`: `property ShowScreenTip: Boolean read FShowScreenTip write SetShowScreenTip default True;`
- `ScreenTipTitle`: `property ScreenTipTitle: String read FScreenTipTitle write SetScreenTipTitle;`
- `ScreenTipText`: `property ScreenTipText: String read FScreenTipText write SetScreenTipText;`
- `ScreenTipShortcut`: `property ScreenTipShortcut: String read FScreenTipShortcut write SetScreenTipShortcut;`
- `ScreenTipFooter`: `property ScreenTipFooter: String read FScreenTipFooter write SetScreenTipFooter;`

## Ribbon Structure

### TLazRibbonTab

Source: `source/runtime/LazRibbon_Tabs.pas`

- `CustomAppearance`: `property CustomAppearance: TLazRibbonToolbarAppearance read FCustomAppearance write SetCustomAppearance;`
- `Caption`: `property Caption: string read FCaption write SetCaption;`
- `KeyTip`: `property KeyTip: string read FKeyTip write SetKeyTip;`
- `Contextual`: `property Contextual: Boolean read FContextual write SetContextual default False;`
- `ContextualGroupCaption`: `property ContextualGroupCaption: string read FContextualGroupCaption write SetContextualGroupCaption;`
- `ContextualColor`: `property ContextualColor: TColor read FContextualColor write SetContextualColor default clNone;`
- `OverrideAppearance`: `property OverrideAppearance: boolean read FOverrideAppearance write SetOverrideAppearance default false;`
- `Visible`: `property Visible: boolean read FVisible write SetVisible default true;`
- `OnClick`: `property OnClick: TNotifyEvent read FOnClick write FOnClick;`

### TLazRibbonPane

Source: `source/runtime/LazRibbon_Groups.pas`

- `Caption`: `property Caption: string read FCaption write SetCaption;`
- `Visible`: `property Visible: boolean read FVisible write SetVisible default true;`
- `DialogLauncherStyle`: `property DialogLauncherStyle: TLazRibbonDialogLauncherStyle read FDialogLauncherStyle write SetDialogLauncherStyle default dlsArrow;`
- `ShowDialogLauncher`: `property ShowDialogLauncher: boolean read FShowDialogLauncher write SetShowDialogLauncher default false;`
- `OnDialogLauncherClick`: `property OnDialogLauncherClick: TNotifyEvent read FOnDialogLauncherClick write FOnDialogLauncherClick;`

### TLazRibbonCustomRibbonExtItem

Source: `source/runtime/LazRibbon_RibbonExtItems.pas`

- `Caption`: `property Caption: TCaption read FCaption write SetCaption;`
- `DisplayMode`: `property DisplayMode: TLazRibbonExtItemDisplayMode read FDisplayMode write SetDisplayMode default rimNormal;`
- `ImageIndex`: `property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;`
- `LargeImageIndex`: `property LargeImageIndex: Integer read FLargeImageIndex write SetLargeImageIndex default -1;`
- `Width`: `property Width: Integer read FWidth write SetWidth default 96;`
- `OnClick`: `property OnClick: TLazRibbonExtItemEvent read FOnClick write FOnClick;`

### TLazRibbonControlHostItem

Source: `source/runtime/LazRibbon_RibbonExtItems.pas`

- `Control`: `property Control: TControl read FControl write SetControl;`

### TLazRibbonGalleryItem

Source: `source/runtime/LazRibbon_RibbonExtItems.pas`

- `Columns`: `property Columns: Integer read FColumns write SetColumns default 4;`
- `ItemWidth`: `property ItemWidth: Integer read FItemWidth write SetItemWidth default 22;`
- `ItemHeight`: `property ItemHeight: Integer read FItemHeight write SetItemHeight default 22;`
- `PopupMode`: `property PopupMode: TLazRibbonGalleryPopupMode read FPopupMode write SetPopupMode default gpmDropDown;`
- `PopupWidth`: `property PopupWidth: Integer read FPopupWidth write SetPopupWidth default 220;`
- `PopupHeight`: `property PopupHeight: Integer read FPopupHeight write SetPopupHeight default 180;`

### TLazRibbonSkinGalleryItem

Source: `source/runtime/LazRibbon_RibbonExtItems.pas`

- `SkinManager`: `property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;`
- `SelectedSkinName`: `property SelectedSkinName: String read GetSelectedSkinName write SetSelectedSkinName;`
- `ShowHints`: `property ShowHints: Boolean read FShowHints write SetShowHints default True;`
- `IconWidth`: `property IconWidth: Integer read FItemWidth write SetItemWidth default 22;`
- `IconHeight`: `property IconHeight: Integer read FItemHeight write SetItemHeight default 22;`
- `MaxVisibleItems`: `property MaxVisibleItems: Integer read FMaxVisibleItems write SetMaxVisibleItems default 12;`
- `VisibleStartIndex`: `property VisibleStartIndex: Integer read FVisibleStartIndex write SetVisibleStartIndex default 0;`
- `OverflowMode`: `property OverflowMode: TLazRibbonGalleryOverflowMode read FOverflowMode write SetOverflowMode default gomScrollButtons;`
- `OnSkinSelected`: `property OnSkinSelected: TNotifyEvent read FOnSkinSelected write FOnSkinSelected;`

## BackStage

### TLazRibbonBackstageButton

Source: `source/runtime/LazRibbon_Backstage.pas`

- `Action`: `property Action: TBasicAction read FAction write SetAction;`
- `BeginGroup`: `property BeginGroup: Boolean read FBeginGroup write SetBeginGroup default False;`
- `Caption`: `property Caption: TCaption read FCaption write SetCaption;`
- `CloseBackstageOnClick`: `property CloseBackstageOnClick: Boolean read FCloseBackstageOnClick write SetCloseBackstageOnClick default True;`
- `Enabled`: `property Enabled: Boolean read FEnabled write SetEnabled default True;`
- `Hint`: `property Hint: String read FHint write SetHint;`
- `ImageIndex`: `property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;`
- `LargeImageIndex`: `property LargeImageIndex: Integer read FLargeImageIndex write SetLargeImageIndex default -1;`
- `Kind`: `property Kind: TLazRibbonBackstageButtonKind read FKind write SetKind default bbkPage;`
- `LinkedItem`: `property LinkedItem: TLazRibbonBaseItem read FLinkedItem write SetLinkedItem;`
- `Section`: `property Section: TLazRibbonBackstageButtonSection read FSection write SetSection default bbsTop;`
- `Page`: `property Page: TLazRibbonBackstagePage read FPage write SetPage;`
- `Visible`: `property Visible: Boolean read FVisible write SetVisible default True;`
- `OnExecute`: `property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;`

### TLazRibbonBackstagePage

Source: `source/runtime/LazRibbon_Backstage.pas`

- `Caption`: `property Caption: TCaption read FCaption write SetCaption;`
- `Align`: `property Align;`
- `Anchors`: `property Anchors;`
- `BorderSpacing`: `property BorderSpacing;`
- `Color`: `property Color default clWhite;`
- `Constraints`: `property Constraints;`
- `Enabled`: `property Enabled;`
- `Font`: `property Font;`
- `ParentColor`: `property ParentColor;`
- `ParentFont`: `property ParentFont;`
- `ParentShowHint`: `property ParentShowHint;`
- `PopupMenu`: `property PopupMenu;`
- `ShowHint`: `property ShowHint;`
- `Visible`: `property Visible;`

### TLazRibbonBackstageRecentList

Source: `source/runtime/LazRibbon_Backstage.pas`

- `Align`: `property Align;`
- `Anchors`: `property Anchors;`
- `BorderSpacing`: `property BorderSpacing;`
- `Color`: `property Color default clWhite;`
- `Constraints`: `property Constraints;`
- `Enabled`: `property Enabled;`
- `Font`: `property Font;`
- `AppearanceSource`: `property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asInternalStyle;`
- `ImageIndex`: `property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;`
- `Images`: `property Images: TCustomImageList read FImages write SetImages;`
- `ItemHeight`: `property ItemHeight: Integer read FItemHeight write SetItemHeight default 58;`
- `Items`: `property Items: TStrings read GetItems write SetItems;`
- `MaxRecentItems`: `property MaxRecentItems: Integer read FMaxRecentItems write SetMaxRecentItems default 20;`
- `ParentColor`: `property ParentColor;`
- `ParentFont`: `property ParentFont;`
- `ParentShowHint`: `property ParentShowHint;`
- `PopupMenu`: `property PopupMenu;`
- `SelectedIndex`: `property SelectedIndex: Integer read FSelectedIndex write SetSelectedIndex default -1;`
- `SelectionStyle`: `property SelectionStyle: TLazRibbonBackstageRecentSelectionStyle read FSelectionStyle write SetSelectionStyle default brsSkin;`
- `ScrollBarMode`: `property ScrollBarMode: TLazRibbonBackstageRecentScrollBarMode read FScrollBarMode write SetScrollBarMode default rsmAuto;`
- `ScrollBarWidth`: `property ScrollBarWidth: Integer read FScrollBarWidth write SetScrollBarWidth default 12;`
- `SkinManager`: `property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;`
- `StorageSection`: `property StorageSection: String read FStorageSection write SetStorageSection;`
- `ShowHint`: `property ShowHint;`
- `Visible`: `property Visible;`
- `OnItemClick`: `property OnItemClick: TLazRibbonBackstageRecentItemClickEvent read FOnItemClick write FOnItemClick;`

### TLazRibbonBackstageView

Source: `source/runtime/LazRibbon_Backstage.pas`

- `ActivePageIndex`: `property ActivePageIndex: Integer read FActivePageIndex write SetActivePageIndex default 0;`
- `AppearanceSource`: `property AppearanceSource: TLazRibbonAppearanceSource read FAppearanceSource write SetAppearanceSource default asLinkedToolbar;`
- `BackstageTabCaption`: `property BackstageTabCaption: TCaption read FBackstageTabCaption write SetBackstageTabCaption;`
- `BackButtonHint`: `property BackButtonHint: String read FBackButtonHint write SetBackButtonHint;`
- `BackButtonStyle`: `property BackButtonStyle: TLazRibbonBackstageBackButtonStyle read FBackButtonStyle write SetBackButtonStyle default bbsCircleChevron;`
- `BackButtonVisible`: `property BackButtonVisible: Boolean read FBackButtonVisible write SetBackButtonVisible default True;`
- `Buttons`: `property Buttons: TLazRibbonBackstageButtons read FButtons write SetButtons;`
- `Align`: `property Align default alClient;`
- `Anchors`: `property Anchors;`
- `AutoHideAtRuntime`: `property AutoHideAtRuntime: Boolean read FAutoHideAtRuntime write FAutoHideAtRuntime default True;`
- `BorderSpacing`: `property BorderSpacing;`
- `Color`: `property Color default clWhite;`
- `CloseOnEscape`: `property CloseOnEscape: Boolean read FCloseOnEscape write SetCloseOnEscape default True;`
- `CloseOnRibbonTabClick`: `property CloseOnRibbonTabClick: Boolean read FCloseOnRibbonTabClick write SetCloseOnRibbonTabClick default True;`
- `Constraints`: `property Constraints;`
- `Enabled`: `property Enabled;`
- `Font`: `property Font;`
- `HeaderHeight`: `property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default 0;`
- `Images`: `property Images: TCustomImageList read FImages write SetImages;`
- `LargeImages`: `property LargeImages: TCustomImageList read FLargeImages write SetLargeImages;`
- `ItemHeight`: `property ItemHeight: Integer read FItemHeight write SetItemHeight default 42;`
- `LinkedToolbar`: `property LinkedToolbar: TLazRibbon read FLinkedToolbar write SetLinkedToolbar;`
- `NavigationStyle`: `property NavigationStyle: TLazRibbonBackstageNavigationStyle read FNavigationStyle write SetNavigationStyle default bnsOffice;`
- `PageButtonVisualMode`: `property PageButtonVisualMode: TLazRibbonBackstagePageButtonVisualMode read FPageButtonVisualMode write SetPageButtonVisualMode default bpvmSelectable;`
- `NavigationWidth`: `property NavigationWidth: Integer read FNavigationWidth write SetNavigationWidth default 180;`
- `OpenOnTabCaption`: `property OpenOnTabCaption: Boolean read FOpenOnTabCaption write SetOpenOnTabCaption default True;`
- `OverlayMode`: `property OverlayMode: TLazRibbonBackstageOverlayMode read FOverlayMode write SetOverlayMode default bomCoverClientArea;`
- `ParentFont`: `property ParentFont;`
- `ParentShowHint`: `property ParentShowHint;`
- `PopupMenu`: `property PopupMenu;`
- `ShowHint`: `property ShowHint;`
- `SkinManager`: `property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;`
- `Style`: `property Style: TLazRibbonStyle read FStyle write SetStyle default lazOffice2007Blue;`
- `Title`: `property Title: TCaption read FTitle write SetTitle;`
- `Visible`: `property Visible;`
- `OnClick`: `property OnClick;`
- `OnClose`: `property OnClose: TLazRibbonBackstageCloseEvent read FOnClose write FOnClose;`
- `OnClosed`: `property OnClosed: TNotifyEvent read FOnClosed write FOnClosed;`
- `OnPageChanged`: `property OnPageChanged: TLazRibbonBackstagePageChangedEvent read FOnPageChanged write FOnPageChanged;`
- `OnResize`: `property OnResize;`

## Skin Components

### TLazRibbonSkinManager

Source: `source/runtime/LazRibbon_SkinManager.pas`

- `ActiveSkinName`: `property ActiveSkinName: String read FActiveSkinName write SetActiveSkinName;`
- `SkinFolder`: `property SkinFolder: String read FSkinFolder write SetSkinFolder;`
- `AutoRefreshControls`: `property AutoRefreshControls: Boolean read FAutoRefreshControls write SetAutoRefreshControls default True;`
- `Appearance`: `property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;`
- `General`: `property General: TLazRibbonSkinGeneralColors read FGeneral;`
- `Accent`: `property Accent: TLazRibbonSkinAccentColors read FAccent;`
- `Backstage`: `property Backstage: TLazRibbonSkinBackstageColors read FBackstage;`
- `RecentList`: `property RecentList: TLazRibbonSkinRecentListColors read FRecentList;`
- `Ribbon`: `property Ribbon: TLazRibbonSkinRibbonColors read FRibbon;`
- `OnChange`: `property OnChange: TNotifyEvent read FOnChange write FOnChange;`

### TLazRibbonSkinGeneralColors

Source: `source/runtime/LazRibbon_SkinManager.pas`

- `BackColor`: `property BackColor: TColor read GetBackColor write SetBackColor;`
- `TextColor`: `property TextColor: TColor read GetTextColor write SetTextColor;`
- `MutedTextColor`: `property MutedTextColor: TColor read GetMutedTextColor write SetMutedTextColor;`
- `BorderColor`: `property BorderColor: TColor read GetBorderColor write SetBorderColor;`

### TLazRibbonSkinAccentColors

Source: `source/runtime/LazRibbon_SkinManager.pas`

- `NavigationColor`: `property NavigationColor: TColor read GetNavigationColor write SetNavigationColor;`
- `ActiveColor`: `property ActiveColor: TColor read GetActiveColor write SetActiveColor;`
- `HotColor`: `property HotColor: TColor read GetHotColor write SetHotColor;`

### TLazRibbonSkinBackstageColors

Source: `source/runtime/LazRibbon_SkinManager.pas`

- `NavigationColor`: `property NavigationColor: TColor read GetNavigationColor write SetNavigationColor;`
- `TextColor`: `property TextColor: TColor read GetTextColor write SetTextColor;`
- `MutedTextColor`: `property MutedTextColor: TColor read GetMutedTextColor write SetMutedTextColor;`
- `HotColor`: `property HotColor: TColor read GetHotColor write SetHotColor;`
- `HotTextColor`: `property HotTextColor: TColor read GetHotTextColor write SetHotTextColor;`
- `SelectedColor`: `property SelectedColor: TColor read GetSelectedColor write SetSelectedColor;`
- `SelectedTextColor`: `property SelectedTextColor: TColor read GetSelectedTextColor write SetSelectedTextColor;`
- `SelectedFrameColor`: `property SelectedFrameColor: TColor read GetSelectedFrameColor write SetSelectedFrameColor;`

### TLazRibbonSkinRecentListColors

Source: `source/runtime/LazRibbon_SkinManager.pas`

- `OddColor`: `property OddColor: TColor read GetOddColor write SetOddColor;`
- `HoverColor`: `property HoverColor: TColor read GetHoverColor write SetHoverColor;`
- `SelectedColor`: `property SelectedColor: TColor read GetSelectedColor write SetSelectedColor;`
- `SelectedFrameColor`: `property SelectedFrameColor: TColor read GetSelectedFrameColor write SetSelectedFrameColor;`
- `TitleColor`: `property TitleColor: TColor read GetTitleColor write SetTitleColor;`

### TLazRibbonSkinRibbonColors

Source: `source/runtime/LazRibbon_SkinManager.pas`

- `TopColor`: `property TopColor: TColor read GetTopColor write SetTopColor;`
- `BottomColor`: `property BottomColor: TColor read GetBottomColor write SetBottomColor;`
- `TabActiveColor`: `property TabActiveColor: TColor read GetTabActiveColor write SetTabActiveColor;`
- `TabHotColor`: `property TabHotColor: TColor read GetTabHotColor write SetTabHotColor;`
- `GroupColor`: `property GroupColor: TColor read GetGroupColor write SetGroupColor;`
- `GroupFrameColor`: `property GroupFrameColor: TColor read GetGroupFrameColor write SetGroupFrameColor;`

### TLazRibbonSkinDefinition

Source: `source/runtime/LazRibbon_SkinDefinition.pas`

- `Name`: `property Name: String read FName write FName;`
- `DisplayName`: `property DisplayName: String read FDisplayName write FDisplayName;`
- `GroupName`: `property GroupName: String read FGroupName write FGroupName;`
- `Author`: `property Author: String read FAuthor write FAuthor;`
- `Description`: `property Description: String read FDescription write FDescription;`
- `Notes`: `property Notes: String read FNotes write FNotes;`
- `FormatVersion`: `property FormatVersion: String read FFormatVersion write FFormatVersion;`
- `Icon16Data`: `property Icon16Data: String read FIcon16Data write FIcon16Data;`
- `Icon24Data`: `property Icon24Data: String read FIcon24Data write FIcon24Data;`
- `Icon32Data`: `property Icon32Data: String read FIcon32Data write FIcon32Data;`
- `PreviewImageFileName`: `property PreviewImageFileName: String read FPreviewImageFileName write FPreviewImageFileName;`
- `Source`: `property Source: TLazRibbonSkinSource read FSource write FSource default sssCustom;`
- `BuiltInSkin`: `property BuiltInSkin: TLazRibbonBuiltInSkin read FBuiltInSkin write FBuiltInSkin default sbsOfficeBlue;`
- `Appearance`: `property Appearance: TLazRibbonToolbarAppearance read FAppearance write SetAppearance;`

### TLazRibbonSkinSelector

Source: `source/runtime/LazRibbon_SkinSelector.pas`

- `SkinManager`: `property SkinManager: TLazRibbonSkinManager read FSkinManager write SetSkinManager;`
- `Columns`: `property Columns: Integer read FColumns write SetColumns default 2;`
- `IconWidth`: `property IconWidth: Integer read FItemWidth write SetItemWidth default 96;`
- `IconHeight`: `property IconHeight: Integer read FItemHeight write SetItemHeight default 34;`
- `ShowCaptions`: `property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions default True;`
- `SelectedSkinName`: `property SelectedSkinName: String read GetSelectedSkinName write SetSelectedSkinName;`
- `Align`: `property Align;`
- `Anchors`: `property Anchors;`
- `BorderSpacing`: `property BorderSpacing;`
- `Color`: `property Color default clWhite;`
- `Constraints`: `property Constraints;`
- `Enabled`: `property Enabled;`
- `Font`: `property Font;`
- `ParentColor`: `property ParentColor;`
- `ParentFont`: `property ParentFont;`
- `ParentShowHint`: `property ParentShowHint;`
- `PopupMenu`: `property PopupMenu;`
- `ShowHint`: `property ShowHint;`
- `Visible`: `property Visible;`
- `OnClick`: `property OnClick;`
- `OnSkinSelected`: `property OnSkinSelected: TNotifyEvent read FOnSkinSelected write FOnSkinSelected;`

