# LazRibbon Component Composition Model for 2.0

This document defines the intended public property model for composing a
LazRibbon interface. It complements the public API audit by describing where a
developer should connect components and where repeated-looking properties are
intentional. The practical Object Inspector map for these decisions lives in
`COMPONENT_PROPERTY_MATRIX_2_0.md`.

## Composition Rules

1. Container components own composition links.
2. Visual subobjects own the settings that affect only their own visual role.
3. Command items may expose `Action` plus direct event handlers, but structural
   items should not expose command/event properties.
4. Skin selection is always name-based for public Object Inspector use.
5. Low-level appearance objects remain available for detailed styling, but the
   first-level component API should prefer Office-like concepts.
6. New published properties must fit the component property matrix before they
   are considered ready for the 2.0 API freeze.

## Primary Object Graph

```text
TLazRibbonForm
  -> Ribbon: TLazRibbon
  -> SkinManager: TLazRibbonSkinManager

TLazRibbon
  -> ApplicationButton: TLazRibbonApplicationButton
  -> QuickAccessToolBar: TLazRibbonQuickAccessToolBar
  -> BackstageView: TLazRibbonCustomBackstageView
  -> Tabs: TLazRibbonTabs

TLazRibbonPopupMenu
  -> assigned to ApplicationButton.Menu or a Ribbon button DropdownMenu

TLazRibbonTab
  -> Panes: TLazRibbonPanes

TLazRibbonPane
  -> Items: TLazRibbonItems

TLazRibbonBackstageView
  -> Buttons: TLazRibbonBackstageButtons
  -> Pages: TLazRibbonBackstagePage children
```

## Canonical Connections

- A BackStage view is attached to a Ribbon through `TLazRibbon.BackstageView`.
  The Application Button exposes its caption, mode, menu, icon, ScreenTip and
  click behavior, but it is not the canonical place to stream the BackStage
  component reference.
- `TLazRibbonPopupMenu` is not a parallel Ribbon container. It is an owner-drawn
  `TPopupMenu` used by `ApplicationButton.Menu` or a Ribbon button
  `DropdownMenu`. Its `Appearance` is propagated by the connected Ribbon/button,
  so normal form design should configure inherited menu items, images and
  events rather than treat `Appearance` as a separate first-level style source.
- BackStage navigation is composed through `TLazRibbonBackstageView.Buttons`.
  Buttons can link to pages, execute commands or draw separators. BackStage
  page components are content containers and should not be used as command or
  separator entries in new forms.
- A Ribbon receives a skin through `TLazRibbon.SkinManager` and
  `TLazRibbon.AppearanceSource`. Assigning a SkinManager automatically selects
  `AppearanceSource = asSkinManager` when the Ribbon is still in its default
  internal mode.
- A BackStage view and BackStage recent list use `AppearanceSource` plus
  `SkinManager` or `LinkedToolbar` to decide where their visual palette comes
  from.
- A skin manager exposes the active skin through `ActiveSkinName`, and a skin
  selector or skin gallery changes `SelectedSkinName`; the older enum shortcuts
  remain compatibility conveniences only outside the Object Inspector.
- Quick Access Toolbar commands are represented by
  `QuickAccessToolBar.Items`. Each item can link to a standard `Action`, to a
  Ribbon item through `LinkedItem`, or define its own caption/image fallback.
- A `TLazRibbonControlHostItem` hosts a real Lazarus control through `Control`.
  `Caption` is only fallback placeholder text when no control is assigned.
  Legacy `ControlName` and `ControlClassName` strings are compatibility
  metadata only; new projects should not require developers to synchronize
  those names manually.

## Intentional Pairs

Some property pairs look similar but describe different decisions:

- `AllowCustomizing` and `ShowCustomizeButton`: whether customization is allowed
  versus whether the small customize button is visible.
- `AllowPositionChange` and `ShowPositionMenuItem`: whether the command is
  allowed versus whether it appears in the customize menu.
- `AllowMinimizeRibbon` and `ShowMinimizeRibbonMenuItem`: whether the command is
  allowed versus whether it appears in the customize menu.
- `ApplicationButton.Menu` and `ApplicationButton.OnClick`: popup-menu mode
  versus event mode, selected by `ApplicationButton.Mode`.

## Current Cleanup Decisions

- `TLazRibbon.ApplicationButton.BackstageView` is no longer part of the
  published Object Inspector surface. `TLazRibbon.BackstageView` is the
  canonical composition property. The Application Button accessor remains public
  only as a source-level compatibility delegate.
- `TLazRibbon.RibbonAppearance` is no longer the recommended design-time style
  entry point. It remains internal/streaming-compatible rendering state so old
  `.lfm` files keep loading, while `TLazRibbonSkinManager` owns the visible
  SkinManager/SkinEditor workflow for new projects.
- `TLazRibbonSeparator` is a structural pane item. The design-time package hides
  inherited command and ScreenTip properties such as `Action`, `Caption`,
  `Enabled`, `Hint`, `KeyTip`, `ShowScreenTip`, `ScreenTip*` and `OnClick`.
- `TLazRibbonBackstagePage` is a BackStage content container. Page-level
  command/navigation properties `Action`, `Command`, `CloseBackstageOnClick`,
  `ItemKind` and `OnExecute` are public source-level compatibility only, not
  part of the published Object Inspector surface. Use
  `TLazRibbonBackstageView.Buttons` for those entries.
- `TLazRibbonControlHostItem` uses `Control` as its public hosted-control
  reference. `Caption` remains the fallback placeholder text, and `ControlName`
  and `ControlClassName` are retained as public compatibility properties and
  legacy `.lfm` readers, but are hidden from the Object Inspector.
- `TLazRibbonPopupMenu` is a palette component with no direct LazRibbon-specific
  published Object Inspector properties. It keeps inherited `TPopupMenu`
  behavior and receives its Ribbon appearance from the component that opens it.
- Generic galleries use `ItemWidth` and `ItemHeight`; skin galleries and skin
  selectors use `IconWidth` and `IconHeight`.
- `TLazRibbonSkinManager.ActiveSkinName` is the canonical active-skin property.
  The older `ActiveSkin` enum remains public only for source and legacy `.lfm`
  compatibility with built-in skins.
- Skin identity icons are embedded through `Icon16Data`, `Icon24Data` and
  `Icon32Data`.

## Follow-up Candidates

- Keep validating new published properties against the component property
  matrix before the 2.0 API freeze.
- Keep migration notes explicit whenever a compatibility-only property remains
  public in source code but hidden from the Object Inspector.
