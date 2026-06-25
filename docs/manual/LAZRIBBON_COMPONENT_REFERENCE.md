# LazRibbon Component Reference

Target: LazRibbon 2.0.0-rc3.

This reference describes the purpose of each package component, published
property and published event. It complements `LAZRIBBON_MANUAL.md` and the
generated Object Inspector snapshot in
`docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md`.

## Reading This Reference

- "Palette" means the component is registered on the Lazarus component palette.
- "Designer item" means the class is created through the Ribbon editor,
  collection editors or object editors, not dropped directly on a form.
- "Inherited LCL property" means the property keeps its normal Lazarus/LCL
  meaning.
- Compatibility-only names are documented where they matter, but new projects
  should prefer the canonical names shown here.

## Palette And Designer Classes

| Class | Kind | Purpose |
| --- | --- | --- |
| `TLazRibbon` | Palette | Main Ribbon control. |
| `TLazRibbonPopupMenu` | Palette | Owner-drawn popup menu with Ribbon appearance support. |
| `TLazRibbonBackstageView` | Palette | Office-like BackStage overlay. |
| `TLazRibbonBackstagePage` | Palette | Content page hosted by BackStage. |
| `TLazRibbonBackstageRecentList` | Palette | Recent-file/document list for BackStage pages. |
| `TLazRibbonSkinManager` | Palette | Skin repository and active appearance source. |
| `TLazRibbonSkinSelector` | Palette | Standalone skin selector control. |
| `TLazRibbonForm` | Designer base class | Ribbon-aware form shell with custom title bar. |
| `TLazRibbonTab` | Designer item | Ribbon page. |
| `TLazRibbonPane` | Designer item | Group inside a Ribbon tab. |
| `TLazRibbonLargeButton` | Designer item | Large pane command button. |
| `TLazRibbonSmallButton` | Designer item | Compact pane command button. |
| `TLazRibbonSeparator` | Designer item | Structural separator inside a pane. |
| `TLazRibbonCheckbox` | Designer item | Checkable pane item. |
| `TLazRibbonRadioButton` | Designer item | Mutually exclusive pane item. |
| `TLazRibbonToggleSwitch` | Designer item | Switch-style toggle pane item. |
| `TLazRibbonControlHostItem` | Designer item | Hosts a real Lazarus control inside a pane. |
| `TLazRibbonGalleryItem` | Designer item | Generic Ribbon gallery item. |
| `TLazRibbonSkinGalleryItem` | Designer item | Ribbon skin gallery item. |

## Common Property Groups

### Common Pane Item Properties

| Property | Description |
| --- | --- |
| `Visible` | Includes or hides the item in the pane layout. |
| `Enabled` | Enables or disables interaction and disabled rendering. |
| `Hint` | Fallback hint text and fallback ScreenTip body. |
| `KeyTip` | Keyboard hint used when Ribbon KeyTips are active. |
| `ShowScreenTip` | Enables the richer ScreenTip text for the item. |
| `ScreenTipTitle` | Main ScreenTip title. |
| `ScreenTipText` | ScreenTip body text. |
| `ScreenTipShortcut` | Shortcut/help line displayed in the ScreenTip. |
| `ScreenTipFooter` | Footer line displayed after the main ScreenTip text. |

### Common Button Properties

| Property/Event | Description |
| --- | --- |
| `Action` | Links the item to a standard Lazarus action. |
| `Caption` | Visible command text and default ScreenTip title. |
| `Checked` | Checked/toggled state for toggle-capable button kinds. |
| `OnClick` | Fires when the command is activated. |

### Inherited Layout Properties

| Property | Description |
| --- | --- |
| `Align` | Standard LCL alignment inside the parent. |
| `Anchors` | Standard LCL anchoring. |
| `BorderSpacing` | Standard LCL spacing around the control. |
| `Color` | Control background color where the component publishes it. |
| `Constraints` | Standard LCL size constraints. |
| `Enabled` | Standard LCL enabled state. |
| `Font` | Standard LCL font. |
| `ParentColor` | Uses parent background color when enabled. |
| `ParentFont` | Uses parent font when enabled. |
| `ParentShowHint` | Inherits the parent's hint behavior. |
| `PopupMenu` | Standard LCL popup menu. |
| `ShowHint` | Standard LCL hint visibility. |
| `Visible` | Standard LCL visibility. |

## TLazRibbonForm

Purpose: form shell with optional custom title bar and Ribbon integration.

| Property | Description |
| --- | --- |
| `Ribbon` | Associated `TLazRibbon`; used for skin/title integration. |
| `SkinManager` | Optional skin source for the custom title bar. |
| `UseCustomTitleBar` | Enables the custom client-area title bar. |
| `TitleBarHeight` | Height of the custom title bar. |
| `ShowSystemButtons` | Shows minimize/maximize/close buttons in the custom title bar. |
| `ShowTitleIcon` | Shows an icon at the left of the custom title bar. |
| `TitleIcon` | Explicit icon used by the custom title bar. |
| `TitleAlignment` | Alignment of the title text. |

Events: inherits normal `TForm` events from Lazarus.

## TLazRibbon

Purpose: main Ribbon root and owner of tabs, panes, BackStage link and QAT.

| Property | Description |
| --- | --- |
| `ApplicationButton` | Office File/Application button configuration object. |
| `QuickAccessToolBar` | Quick Access Toolbar configuration object. |
| `RibbonMinimized` | Collapses or restores the Ribbon content area. |
| `ShowMinimizeRibbonButton` | Shows the small minimize/restore button. |
| `MinimizeRibbonHint` | Hint shown for the minimize action. |
| `RestoreRibbonHint` | Hint shown for the restore action. |
| `ShowHelpButton` | Shows the help button at the right side of the Ribbon. |
| `ShowKeyTips` | Enables Office-like KeyTip overlays. |
| `ShowContextualGroupHeaders` | Shows contextual tab group headers. |
| `ContextualGroupHeaderHeight` | Height of contextual group headers. |
| `TabCaptionHorizontalPadding` | Horizontal padding inside tab captions. |
| `TabCaptionSpacing` | Space between adjacent tab captions. |
| `MinTabCaptionWidth` | Minimum tab caption width. |
| `HelpButtonHint` | Hint for the help button. |
| `Color` | Base Ribbon background color for built-in styles. |
| `Style` | Built-in style selector when no skin manager is used. |
| `AppearanceSource` | Chooses internal style, local appearance or skin manager. |
| `SkinManager` | Skin manager supplying the active skin. |
| `BackstageView` | BackStage overlay associated with the Ribbon. |
| `RibbonAppearance` | Detailed local appearance object for this Ribbon. |
| `TabIndex` | Active tab index. |
| `Images` | Shared small image list for items. |
| `DisabledImages` | Shared disabled small image list. |
| `LargeImages` | Shared large image list for large buttons. |
| `DisabledLargeImages` | Shared disabled large image list. |
| `ImagesWidth` | Logical width used for small images. |
| `LargeImagesWidth` | Logical width used for large images. |
| `Align`, `BiDiMode`, `BorderSpacing`, `Anchors`, `Hint`, `ParentShowHint`, `ShowHint`, `Visible` | Standard LCL properties published by the control. |

| Event | Description |
| --- | --- |
| `OnHelpButtonClick` | Fires when the Ribbon help button is clicked. |
| `OnRibbonMinimizedChanged` | Fires after `RibbonMinimized` changes. |
| `OnTabChanging` | Fires before the active tab changes. |
| `OnTabChanged` | Fires after the active tab changes. |
| `OnResize`, `OnShowHint` | Standard LCL events. |

## TLazRibbonApplicationButton

Purpose: Office File/Application button at the left side of the Ribbon.

| Property | Description |
| --- | --- |
| `Caption` | Visible text when the selected style displays a caption. |
| `Visible` | Shows or hides the button. |
| `Mode` | Chooses event or popup menu behavior. |
| `Style` | Controls glyph/caption/dropdown rendering. |
| `Menu` | Popup menu opened when the mode uses a menu. |
| `Glyph` | Picture drawn on the button. |
| `ImageIndex` | Image index from the Ribbon image list. |
| `Hint` | Fallback hint text. |
| `KeyTip` | KeyTip for keyboard activation. |
| `ShowScreenTip`, `ScreenTipTitle`, `ScreenTipText`, `ScreenTipShortcut`, `ScreenTipFooter` | ScreenTip configuration. |

| Event | Description |
| --- | --- |
| `OnClick` | Fires when the button is activated in event mode. |

## TLazRibbonQuickAccessToolBar

Purpose: Quick Access Toolbar shown before tabs, above the Ribbon or below it.

| Property | Description |
| --- | --- |
| `Visible` | Shows or hides the QAT. |
| `Position` | Selects the QAT placement. |
| `Items` | Collection of `TLazRibbonQuickAccessItem` entries. |
| `ButtonFrameStyle` | Controls when item frames are drawn. |
| `ButtonSize` | Explicit button size; `0` uses default metrics. |
| `Spacing` | Space between QAT buttons. |
| `FallbackGlyphStyle` | Fallback glyph style when no image is assigned. |
| `CustomizeActionList` | Action list used to populate customization choices. |
| `CustomizeMenuTitle` | Caption for the customization menu. |
| `MoreCommandsCaption` | Caption for the "more commands" item. |
| `StorageSection` | Persistence section name for future customization storage. |
| `ShowCustomizeButton` | Shows the dropdown customization button. |
| `ShowMoreCommandsItem` | Shows the "more commands" entry. |
| `ShowPositionMenuItem` | Shows the position-change menu entry. |
| `ShowMinimizeRibbonMenuItem` | Shows the minimize/restore entry. |
| `ShowResetToDefaultsItem` | Shows the reset entry. |
| `AllowCustomizing` | Allows customization commands. |
| `AllowQuickCustomizing` | Allows quick add/remove behavior. |
| `AllowReset` | Allows resetting customizations. |
| `AllowPositionChange` | Allows changing QAT position. |
| `AllowMinimizeRibbon` | Allows the QAT menu to minimize/restore the Ribbon. |
| `Images` | Image list used by QAT items. |
| `ShowAboveRibbonCaption`, `ShowBelowRibbonCaption`, `MinimizeRibbonCaption`, `RestoreRibbonCaption`, `ResetToDefaultsCaption` | Captions used by the customization menu. |

| Event | Description |
| --- | --- |
| `OnCustomizeClick` | Fires when the customize button is invoked. |
| `OnMoreCommandsClick` | Fires when the "more commands" item is invoked. |

## TLazRibbonQuickAccessItem

Purpose: single item inside the QAT.

| Property | Description |
| --- | --- |
| `Caption` | Menu/ScreenTip caption. |
| `Action` | Standard Lazarus action supplying state and execute logic. |
| `LinkedItem` | Ribbon item mirrored by this QAT item. |
| `ImageIndex` | Image index for the button. |
| `Enabled` | Enables or disables the item. |
| `Visible` | Shows or hides the item. |
| `Hint` | Hint text. |
| `KeyTip` | KeyTip used from the QAT/title bar. |
| `ShowScreenTip`, `ScreenTipTitle`, `ScreenTipText`, `ScreenTipShortcut`, `ScreenTipFooter` | ScreenTip configuration. |

## TLazRibbonPopupMenu

Purpose: popup menu that can draw items with the Ribbon appearance.

| Property | Description |
| --- | --- |
| `Appearance` | Appearance object used to draw menu items. |
| inherited `TPopupMenu` properties | Normal Lazarus menu behavior, images and items. |

Events: inherited `TPopupMenu` events.

## TLazRibbonTab

Purpose: page inside the Ribbon.

| Property | Description |
| --- | --- |
| `CustomAppearance` | Appearance override for the tab. |
| `Caption` | Text shown in the tab header. |
| `KeyTip` | KeyTip for selecting the tab. |
| `Contextual` | Marks the tab as contextual. |
| `ContextualGroupCaption` | Header text for the contextual group. |
| `ContextualColor` | Header color for the contextual group. |
| `OverrideAppearance` | Uses `CustomAppearance` instead of inherited appearance. |
| `Visible` | Shows or hides the tab. |

| Event | Description |
| --- | --- |
| `OnClick` | Fires when the tab is clicked/selected. |

## TLazRibbonPane

Purpose: command group inside a tab.

| Property | Description |
| --- | --- |
| `Caption` | Group caption shown at the bottom of the pane. |
| `Visible` | Shows or hides the pane. |
| `DialogLauncherStyle` | Glyph style for the pane Dialog Launcher. |
| `ShowDialogLauncher` | Shows the small Office-style launcher button. |

| Event | Description |
| --- | --- |
| `OnDialogLauncherClick` | Fires when the launcher button is clicked. |

## TLazRibbonLargeButton

Purpose: large primary command.

| Property/Event | Description |
| --- | --- |
| common pane item properties | Visibility, enabled state, hints, KeyTips and ScreenTips. |
| common button properties/events | `Action`, `Caption`, `Checked`, `OnClick`. |
| `AllowAllUp` | Allows all buttons in a group to be unchecked. |
| `ButtonKind` | Selects normal, dropdown, toggle or separator-like behavior. |
| `DropdownMenu` | Menu opened by dropdown button kinds. |
| `GroupIndex` | Toggle/radio group index. |
| `LargeImageIndex` | Image index from the Ribbon large image list. |

## TLazRibbonSmallButton

Purpose: compact command for rows inside a pane.

| Property/Event | Description |
| --- | --- |
| common pane item properties | Visibility, enabled state, hints, KeyTips and ScreenTips. |
| common button properties/events | `Action`, `Caption`, `Checked`, `OnClick`. |
| `GroupBehaviour` | Defines how this item visually groups with neighbors. |
| `HideFrameWhenIdle` | Hides the button frame until hover/pressed state. |
| `ImageIndex` | Image index from the Ribbon small image list. |
| `ShowCaption` | Shows or hides text next to the image. |
| `TableBehaviour` | Begins/continues row or column layout inside the pane. |
| `AllowAllUp`, `ButtonKind`, `DropdownMenu`, `GroupIndex` | Same meaning as on large buttons. |

## TLazRibbonSeparator

Purpose: visual separator between pane items.

| Property/Event | Description |
| --- | --- |
| design-time surface | Command, hint and ScreenTip properties are hidden because separators do not execute commands. |
| normal use | Add the separator only to organize layout. |

## TLazRibbonCheckbox

Purpose: checkable pane item.

| Property/Event | Description |
| --- | --- |
| common pane item properties | Visibility, enabled state, hints, KeyTips and ScreenTips. |
| common button properties/events | `Action`, `Caption`, `Checked`, `OnClick`. |
| `TableBehaviour` | Row/column behavior in the pane. |
| `State` | `cbUnchecked`, `cbChecked` or `cbGrayed`. |

## TLazRibbonRadioButton

Purpose: mutually exclusive checkable pane item.

| Property/Event | Description |
| --- | --- |
| common pane item properties | Visibility, enabled state, hints, KeyTips and ScreenTips. |
| common button properties/events | `Action`, `Caption`, `Checked`, `OnClick`. |
| `AllowAllUp` | Allows every item in the group to become unchecked. |
| `GroupIndex` | Radio group index. |
| `State` | Current check state. |
| `TableBehaviour` | Row/column behavior in the pane. |

## TLazRibbonToggleSwitch

Purpose: switch-style toggle pane item.

| Property/Event | Description |
| --- | --- |
| common pane item properties | Visibility, enabled state, hints, KeyTips and ScreenTips. |
| common button properties/events | `Action`, `Caption`, `Checked`, `OnClick`. |
| `AllowAllUp` | Allows all toggle items in the group to be off. |
| `GroupIndex` | Toggle group index. |
| `TableBehaviour` | Row/column behavior in the pane. |

## TLazRibbonCustomRibbonExtItem

Purpose: base for extended pane items.

| Property | Description |
| --- | --- |
| `Caption` | Text or placeholder text. |
| `DisplayMode` | Compact, normal or large display mode. |
| `ImageIndex` | Small image index. |
| `LargeImageIndex` | Large image index. |
| `Width` | Requested item width. |

| Event | Description |
| --- | --- |
| `OnClick` | Fires when the item is activated. |

## TLazRibbonControlHostItem

Purpose: embeds an existing Lazarus control inside the Ribbon.

| Property | Description |
| --- | --- |
| inherited extended item properties | Caption, display mode, images, width and click behavior. |
| `Control` | Control hosted inside the Ribbon pane. |

Compatibility: `ControlName` and `ControlClassName` are source/streaming
compatibility helpers only. New projects should assign `Control`.

## TLazRibbonGalleryItem

Purpose: generic gallery/grid item.

| Property | Description |
| --- | --- |
| inherited extended item properties | Caption, display mode, images, width and click behavior. |
| `Columns` | Number of columns in the gallery. |
| `ItemWidth` | Width of each gallery cell. |
| `ItemHeight` | Height of each gallery cell. |
| `PopupMode` | Enables/disables dropdown popup behavior. |
| `PopupWidth` | Width of the popup gallery. |
| `PopupHeight` | Height of the popup gallery. |

## TLazRibbonSkinGalleryItem

Purpose: Ribbon item for choosing skins from a pane.

| Property | Description |
| --- | --- |
| inherited extended/gallery properties | Layout, width, display mode and click behavior. |
| `SkinManager` | Skin manager supplying available skins. |
| `SelectedSkinName` | Canonical active skin name. |
| `ShowHints` | Shows skin names as hints while hovering. |
| `IconWidth` | Width of each skin swatch. |
| `IconHeight` | Height of each skin swatch. |
| `MaxVisibleItems` | Maximum number of visible swatches. |
| `VisibleStartIndex` | First visible skin index when scrolling. |
| `OverflowMode` | Overflow behavior, normally scroll buttons. |

| Event | Description |
| --- | --- |
| `OnSkinSelected` | Fires after a skin is selected. |

## TLazRibbonBackstageView

Purpose: Office-like BackStage overlay.

| Property | Description |
| --- | --- |
| `ActivePageIndex` | Index of the active BackStage page. |
| `AppearanceSource` | Chooses internal, linked Ribbon or skin-manager visuals. |
| `BackstageTabCaption` | Caption used by the Ribbon Application/File tab. |
| `BackButtonHint` | Hint for the BackStage return button. |
| `BackButtonStyle` | Visual style of the return button. |
| `BackButtonVisible` | Shows or hides the return button. |
| `Buttons` | Navigation/command/separator item collection. |
| `AutoHideAtRuntime` | Starts hidden at runtime. |
| `CloseOnEscape` | Closes BackStage when Escape is pressed. |
| `CloseOnRibbonTabClick` | Closes BackStage when a Ribbon tab is clicked. |
| `HeaderHeight` | Optional explicit header height. |
| `Images` | Small images for navigation items. |
| `LargeImages` | Large images for navigation items. |
| `ItemHeight` | Height of navigation items. |
| `LinkedToolbar` | Ribbon that owns/opens this BackStage. |
| `NavigationStyle` | Office-like navigation rendering style. |
| `PageButtonVisualMode` | How page buttons look selected/clickable. |
| `NavigationWidth` | Width of the left navigation column. |
| `OpenOnTabCaption` | Opens BackStage when the Application/File tab is clicked. |
| `OverlayMode` | Area covered by BackStage; `bomCoverClientArea` is the modern Office-like default. |
| `SkinManager` | Skin manager used when appearance comes from skins. |
| `Style` | Built-in style fallback. |
| `Title` | Optional BackStage title. |
| inherited LCL layout properties | `Align`, `Anchors`, `BorderSpacing`, `Color`, `Constraints`, `Enabled`, `Font`, `ParentFont`, `ParentShowHint`, `PopupMenu`, `ShowHint`, `Visible`. |

| Event | Description |
| --- | --- |
| `OnClick` | Standard click event. |
| `OnClose` | Fires before closing; can participate in close control. |
| `OnClosed` | Fires after BackStage closes. |
| `OnPageChanged` | Fires after the active page changes. |
| `OnResize` | Standard resize event. |

## TLazRibbonBackstageButton

Purpose: one item in `TLazRibbonBackstageView.Buttons`.

| Property | Description |
| --- | --- |
| `Action` | Standard Lazarus action. |
| `BeginGroup` | Starts a visual group/separator before this item. |
| `Caption` | Navigation or command caption. |
| `CloseBackstageOnClick` | Closes BackStage after command execution. |
| `Enabled` | Enables or disables the item. |
| `Hint` | Hint text. |
| `ImageIndex` | Small image index. |
| `LargeImageIndex` | Large image index. |
| `Kind` | Page link, command or separator behavior. |
| `LinkedItem` | Optional linked Ribbon item. |
| `Section` | Top or bottom navigation section. |
| `Page` | BackStage page activated by a page item. |
| `Visible` | Shows or hides the item. |

| Event | Description |
| --- | --- |
| `OnExecute` | Fires when a command-style item executes. |

## TLazRibbonBackstagePage

Purpose: content page shown inside BackStage.

| Property | Description |
| --- | --- |
| `Caption` | Page caption used by designers and page links. |
| inherited LCL layout properties | `Align`, `Anchors`, `BorderSpacing`, `Color`, `Constraints`, `Enabled`, `Font`, `ParentColor`, `ParentFont`, `ParentShowHint`, `PopupMenu`, `ShowHint`, `Visible`. |

Events: inherited control events.

## TLazRibbonBackstageRecentList

Purpose: recent-file/document list for BackStage.

| Property | Description |
| --- | --- |
| `AppearanceSource` | Chooses internal, linked or skin-manager visuals. |
| `ImageIndex` | Default image index for entries. |
| `Images` | Image list for entries. |
| `ItemHeight` | Height of each recent item. |
| `Items` | String list containing recent entries. |
| `MaxRecentItems` | Maximum number of entries shown. |
| `SelectedIndex` | Currently selected recent entry. |
| `SelectionStyle` | Selection rendering mode. |
| `ScrollBarMode` | Scrollbar visibility behavior. |
| `ScrollBarWidth` | Width of the custom scrollbar. |
| `SkinManager` | Skin manager used for visuals. |
| `StorageSection` | Persistence section name for future storage. |
| inherited LCL layout properties | `Align`, `Anchors`, `BorderSpacing`, `Color`, `Constraints`, `Enabled`, `Font`, `ParentColor`, `ParentFont`, `ParentShowHint`, `PopupMenu`, `ShowHint`, `Visible`. |

| Event | Description |
| --- | --- |
| `OnItemClick` | Fires when a recent entry is clicked. |

## TLazRibbonSkinManager

Purpose: loads skins, exposes grouped palette colors and notifies linked
controls when the active skin changes.

| Property | Description |
| --- | --- |
| `ActiveSkinName` | Canonical active skin name for built-in or external skins. |
| `SkinFolder` | Folder searched for external `.skin` files. |
| `AutoRefreshControls` | Refreshes linked controls after skin changes. |
| `Appearance` | Complete Ribbon appearance model for the active skin. |
| `General` | General color group. |
| `Accent` | Accent/navigation color group. |
| `Backstage` | BackStage color group. |
| `RecentList` | Recent-list color group. |
| `Ribbon` | Ribbon header/group color group. |

| Event | Description |
| --- | --- |
| `OnChange` | Fires when the active skin or palette changes. |

## TLazRibbonSkinDefinition

Purpose: serializable skin identity and visual definition.

| Property | Description |
| --- | --- |
| `Name` | Internal skin identifier. |
| `DisplayName` | User-visible skin name. |
| `GroupName` | Group shown by selectors/editors. |
| `Author` | Skin author. |
| `Description` | Skin description. |
| `Notes` | Additional notes. |
| `FormatVersion` | Skin file format version. |
| `Icon16Data`, `Icon24Data`, `Icon32Data` | Embedded base64-like icon data for skin identity. |
| `PreviewImageFileName` | Optional preview image file path/name for editor workflows. |
| `Source` | Built-in or custom source marker. |
| `BuiltInSkin` | Built-in skin enum when applicable. |
| `Appearance` | Full appearance object stored in the skin. |

Events: none.

## TLazRibbonSkinSelector

Purpose: standalone visual skin selector.

| Property | Description |
| --- | --- |
| `SkinManager` | Skin manager supplying the available skins. |
| `Columns` | Number of selector columns. |
| `IconWidth` | Width of each skin item. |
| `IconHeight` | Height of each skin item. |
| `ShowCaptions` | Shows visible skin captions. |
| `SelectedSkinName` | Canonical selected skin name. |
| inherited LCL layout properties | `Align`, `Anchors`, `BorderSpacing`, `Color`, `Constraints`, `Enabled`, `Font`, `ParentColor`, `ParentFont`, `ParentShowHint`, `PopupMenu`, `ShowHint`, `Visible`. |

| Event | Description |
| --- | --- |
| `OnClick` | Standard click event. |
| `OnSkinSelected` | Fires after the selected skin changes. |

## Skin Color Groups

| Group | Properties | Description |
| --- | --- | --- |
| `General` | `BackColor`, `TextColor`, `MutedTextColor`, `BorderColor` | General surface, text and border colors. |
| `Accent` | `NavigationColor`, `ActiveColor`, `HotColor` | Navigation/accent colors. |
| `Backstage` | `NavigationColor`, `TextColor`, `MutedTextColor`, `HotColor`, `HotTextColor`, `SelectedColor`, `SelectedTextColor`, `SelectedFrameColor` | BackStage navigation colors. |
| `RecentList` | `OddColor`, `HoverColor`, `SelectedColor`, `SelectedFrameColor`, `TitleColor` | Recent-list row and title colors. |
| `Ribbon` | `TopColor`, `BottomColor`, `TabActiveColor`, `TabHotColor`, `GroupColor`, `GroupFrameColor` | Ribbon header, tab and group colors. |

## Optional Command Layer

These classes are public in `LazRibbon_RibbonCommands` for projects that want a
small reusable command abstraction.

### TLazRibbonCommand

| Property/Event | Description |
| --- | --- |
| `Caption` | Command caption. |
| `Hint` | Command hint. |
| `Enabled` | Enables command execution. |
| `Visible` | Marks command as visible/available. |
| `Checked` | Checked state. |
| `ShortCut` | Keyboard shortcut. |
| `ImageIndex` | Image index in the command list. |
| `OnChange` | Fires after command state changes. |
| `OnExecute` | Fires when `Execute` is called and the command is enabled/visible. |

### TLazRibbonCommandList

| Property | Description |
| --- | --- |
| `Images` | Image list shared by commands. |
