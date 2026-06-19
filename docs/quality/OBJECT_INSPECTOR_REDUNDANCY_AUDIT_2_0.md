# LazRibbon Object Inspector Redundancy Audit for 2.0

Generated from `docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` by `tools/export_object_inspector_redundancy_audit.ps1`.
It classifies repeated direct `published` property names so intentional shared vocabulary is separated from suspicious redundancy before the 2.0 API freeze.

Regenerate after refreshing the Object Inspector surface snapshot:

`powershell -ExecutionPolicy Bypass -File tools/export_object_inspector_redundancy_audit.ps1 -OutputPath docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md`

## Summary

- Published properties scanned: 307
- Repeated published property names reviewed: 48
- Unclassified repeated property names: 0
- No unclassified repeated property names were found.

## Classification Rules

| Category | Meaning |
| --- | --- |
| Inherited LCL surface | Properties inherited from standard Lazarus control/component behavior. |
| Inherited LCL and command state | Common interaction state that is meaningful on controls and command entries. |
| Command surface vocabulary | Command metadata shared by Ribbon, QAT and BackStage commands. |
| Display text vocabulary | Visible user-facing labels. |
| Office keyboard vocabulary | Office-like keyboard navigation hints. |
| Component link vocabulary | References that connect components into the Ribbon object graph. |
| Owned collection/list vocabulary | A component-owned primary collection or persisted list. |
| Visual source and appearance vocabulary | Visual model or source-selection properties. |
| Selector and gallery vocabulary | Gallery/grid and skin-selection sizing or selection properties. |
| Skin palette vocabulary | Low-level color slots inside skin palette subobjects. |

## Shared Property Names

| Property | Category | Components | Rationale |
| --- | --- | --- | --- |
| `Action` | Command surface vocabulary | `TLazRibbonBackstageButton`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `Align` | Inherited LCL surface | `TLazRibbon`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `Anchors` | Inherited LCL surface | `TLazRibbon`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `Appearance` | Visual source and appearance vocabulary | `TLazRibbonSkinDefinition`, `TLazRibbonSkinManager` | Visual model or source decision. This is acceptable only where the component owns or chooses its own appearance model. |
| `AppearanceSource` | Visual source and appearance vocabulary | `TLazRibbon`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView` | Visual model or source decision. This is acceptable only where the component owns or chooses its own appearance model. |
| `BorderSpacing` | Inherited LCL surface | `TLazRibbon`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `Caption` | Display text vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonBackstageButton`, `TLazRibbonBackstagePage`, `TLazRibbonCustomRibbonExtItem`, `TLazRibbonPane`, `TLazRibbonQuickAccessItem`, `TLazRibbonTab` | Visible text for tabs, panes, buttons and command-like items. This is the expected Pascal/LCL name for a label shown to the user. |
| `Color` | Inherited LCL surface | `TLazRibbon`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `Columns` | Selector and gallery vocabulary | `TLazRibbonGalleryItem`, `TLazRibbonSkinSelector` | Grid, icon or selection setting shared by gallery-like controls and skin selector surfaces. |
| `Constraints` | Inherited LCL surface | `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `Enabled` | Inherited LCL and command state | `TLazRibbonBackstageButton`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonQuickAccessItem`, `TLazRibbonSkinSelector` | Normal Lazarus interaction vocabulary that remains meaningful on visible controls and command entries. |
| `Font` | Inherited LCL surface | `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `Hint` | Inherited LCL and command state | `TLazRibbon`, `TLazRibbonApplicationButton`, `TLazRibbonBackstageButton`, `TLazRibbonQuickAccessItem` | Normal Lazarus interaction vocabulary that remains meaningful on visible controls and command entries. |
| `HotColor` | Skin palette vocabulary | `TLazRibbonSkinAccentColors`, `TLazRibbonSkinBackstageColors` | Low-level color slot inside skin palette subobjects, not a first-level component decision. |
| `IconHeight` | Selector and gallery vocabulary | `TLazRibbonSkinGalleryItem`, `TLazRibbonSkinSelector` | Grid, icon or selection setting shared by gallery-like controls and skin selector surfaces. |
| `IconWidth` | Selector and gallery vocabulary | `TLazRibbonSkinGalleryItem`, `TLazRibbonSkinSelector` | Grid, icon or selection setting shared by gallery-like controls and skin selector surfaces. |
| `ImageIndex` | Command surface vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonBackstageButton`, `TLazRibbonBackstageRecentList`, `TLazRibbonCustomRibbonExtItem`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `Images` | Component link vocabulary | `TLazRibbon`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonQuickAccessToolBar` | Reference to an external image list, owner Ribbon or skin manager used to connect components in the documented object graph. |
| `ItemHeight` | Selector and gallery vocabulary | `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonGalleryItem` | Grid, icon or selection setting shared by gallery-like controls and skin selector surfaces. |
| `Items` | Owned collection/list vocabulary | `TLazRibbonBackstageRecentList`, `TLazRibbonQuickAccessToolBar` | Owner-owned item/list storage. The name is acceptable when a component exposes a single primary collection or persisted list. |
| `KeyTip` | Office keyboard vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonQuickAccessItem`, `TLazRibbonTab` | Office-like keyboard hint used by Application Button, tabs and command entries. |
| `LargeImageIndex` | Command surface vocabulary | `TLazRibbonBackstageButton`, `TLazRibbonCustomRibbonExtItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `LargeImages` | Component link vocabulary | `TLazRibbon`, `TLazRibbonBackstageView` | Reference to an external image list, owner Ribbon or skin manager used to connect components in the documented object graph. |
| `LinkedItem` | Command surface vocabulary | `TLazRibbonBackstageButton`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `MutedTextColor` | Skin palette vocabulary | `TLazRibbonSkinBackstageColors`, `TLazRibbonSkinGeneralColors` | Low-level color slot inside skin palette subobjects, not a first-level component decision. |
| `NavigationColor` | Skin palette vocabulary | `TLazRibbonSkinAccentColors`, `TLazRibbonSkinBackstageColors` | Low-level color slot inside skin palette subobjects, not a first-level component decision. |
| `OnClick` | Inherited LCL and command state | `TLazRibbonApplicationButton`, `TLazRibbonBackstageView`, `TLazRibbonCustomRibbonExtItem`, `TLazRibbonSkinSelector`, `TLazRibbonTab` | Normal Lazarus interaction vocabulary that remains meaningful on visible controls and command entries. |
| `OnResize` | Inherited LCL and command state | `TLazRibbon`, `TLazRibbonBackstageView` | Normal Lazarus interaction vocabulary that remains meaningful on visible controls and command entries. |
| `OnSkinSelected` | Selector and gallery vocabulary | `TLazRibbonSkinGalleryItem`, `TLazRibbonSkinSelector` | Grid, icon or selection setting shared by gallery-like controls and skin selector surfaces. |
| `ParentColor` | Inherited LCL surface | `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `ParentFont` | Inherited LCL surface | `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `ParentShowHint` | Inherited LCL surface | `TLazRibbon`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `PopupMenu` | Inherited LCL surface | `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `Ribbon` | Component link vocabulary | `TLazRibbonForm`, `TLazRibbonSkinManager` | Reference to an external image list, owner Ribbon or skin manager used to connect components in the documented object graph. |
| `ScreenTipFooter` | Command surface vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `ScreenTipShortcut` | Command surface vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `ScreenTipText` | Command surface vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `ScreenTipTitle` | Command surface vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `SelectedColor` | Skin palette vocabulary | `TLazRibbonSkinBackstageColors`, `TLazRibbonSkinRecentListColors` | Low-level color slot inside skin palette subobjects, not a first-level component decision. |
| `SelectedFrameColor` | Skin palette vocabulary | `TLazRibbonSkinBackstageColors`, `TLazRibbonSkinRecentListColors` | Low-level color slot inside skin palette subobjects, not a first-level component decision. |
| `SelectedSkinName` | Selector and gallery vocabulary | `TLazRibbonSkinGalleryItem`, `TLazRibbonSkinSelector` | Grid, icon or selection setting shared by gallery-like controls and skin selector surfaces. |
| `ShowHint` | Inherited LCL surface | `TLazRibbon`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonSkinSelector` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |
| `ShowScreenTip` | Command surface vocabulary | `TLazRibbonApplicationButton`, `TLazRibbonQuickAccessItem` | Shared command metadata used by Ribbon, QAT and BackStage command entries. |
| `SkinManager` | Component link vocabulary | `TLazRibbon`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonForm`, `TLazRibbonSkinGalleryItem`, `TLazRibbonSkinSelector` | Reference to an external image list, owner Ribbon or skin manager used to connect components in the documented object graph. |
| `StorageSection` | Owned collection/list vocabulary | `TLazRibbonBackstageRecentList`, `TLazRibbonQuickAccessToolBar` | Owner-owned item/list storage. The name is acceptable when a component exposes a single primary collection or persisted list. |
| `Style` | Visual source and appearance vocabulary | `TLazRibbon`, `TLazRibbonApplicationButton`, `TLazRibbonBackstageView` | Visual model or source decision. This is acceptable only where the component owns or chooses its own appearance model. |
| `TextColor` | Skin palette vocabulary | `TLazRibbonSkinBackstageColors`, `TLazRibbonSkinGeneralColors` | Low-level color slot inside skin palette subobjects, not a first-level component decision. |
| `Visible` | Inherited LCL surface | `TLazRibbon`, `TLazRibbonApplicationButton`, `TLazRibbonBackstageButton`, `TLazRibbonBackstagePage`, `TLazRibbonBackstageRecentList`, `TLazRibbonBackstageView`, `TLazRibbonPane`, `TLazRibbonQuickAccessItem`, `TLazRibbonQuickAccessToolBar`, `TLazRibbonSkinSelector`, `TLazRibbonTab` | Standard Lazarus control state or layout property. It is repeated because these classes descend from LCL controls or components. |

## Watch List For Future Changes

| Property | Future rule |
| --- | --- |
| `Items` | Accept only for a single primary owned collection/list. If a component gains more than one list, prefer a specific name. |
| `Style` | Accept only when the type is local and obvious. Prefer explicit names for new visual decisions. |
| `Columns` | Accept only for gallery or selector grid layout. |
| `Appearance` | Accept only where the component owns a complete appearance model. Top-level Ribbon uses `RibbonAppearance`. |
| `SkinManager` | Accept as a component link. Do not duplicate it beside another property that answers the same visual-source question. |

## Release Gate

Before `2.0.0`, a newly repeated published property name must satisfy one of these checks:

- It fits an existing category in this audit.
- It is added to this audit with a clear rationale.
- It is renamed, hidden from the Object Inspector or moved to compatibility-only API if it duplicates another developer decision.
- The regenerated audit still reports: No unclassified repeated property names were found.
