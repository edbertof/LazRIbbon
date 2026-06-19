# LazRibbon Object Inspector Property Audit for 2.0

This audit is the working checklist for keeping the Object Inspector surface
coherent before the 2.0 API freeze. It sits between the conceptual composition
model and the practical component property matrix.

## Palette Components Reviewed

The public palette components currently reviewed are:

- `TLazRibbon`
- `TLazRibbonPopupMenu`
- `TLazRibbonBackstageView`
- `TLazRibbonBackstagePage`
- `TLazRibbonBackstageRecentList`
- `TLazRibbonSkinManager`
- `TLazRibbonSkinSelector`

The design package also registers item classes without palette icons:

- `TLazRibbonLargeButton`
- `TLazRibbonSmallButton`
- `TLazRibbonSeparator`
- `TLazRibbonControlHostItem`
- `TLazRibbonGalleryItem`
- `TLazRibbonSkinGalleryItem`
- `TLazRibbonCheckbox`
- `TLazRibbonRadioButton`
- `TLazRibbonToggleSwitch`
- `TLazRibbonPane`
- `TLazRibbonTab`

## Current Object Inspector Rules

- A component may publish a composition link only when it owns that link.
- A command surface may publish `Action`, `Caption`, `Enabled`, `Visible`,
  `ImageIndex`, `Hint`, ScreenTip fields and execution events.
- A content container should not publish command/navigation properties just
  because older experiments used it as a command entry.
- A structural item should not publish command or ScreenTip properties.
- A selector should expose a name-based selection property when it can address
  both built-in and external data.
- Visual source decisions should be represented by one property and explicit
  source objects, not by several booleans.

## Cleaned Published Properties

| Component | Older/confusing surface | 2.0-facing surface |
| --- | --- | --- |
| `TLazRibbon` | `Appearance` alias | `RibbonAppearance` |
| `TLazRibbonApplicationButton` | Published `BackstageView` delegate | Owner `TLazRibbon.BackstageView` |
| `TLazRibbonBackstageView` | `ShowCloseButton`, `UseToolbarAppearance`, `UseSkinManager` | `BackButtonVisible`, `AppearanceSource`, `LinkedToolbar`, `SkinManager` |
| `TLazRibbonBackstagePage` | Published `Action`, `Command`, `CloseBackstageOnClick`, `ItemKind`, `OnExecute` | Content page only; use `TLazRibbonBackstageView.Buttons` for navigation/commands |
| `TLazRibbonSeparator` | Inherited command and ScreenTip properties visible at design time | Structural separator only |
| `TLazRibbonControlHostItem` | Published `ControlName`, `ControlClassName` metadata and placeholder-only workflow | `Control` hosted-control reference, with `Caption` as fallback placeholder text |
| `TLazRibbonGalleryItem` / `TLazRibbonSkinGalleryItem` | Mixed `ItemWidth`/`IconWidth` meanings | Generic gallery uses `ItemWidth`/`ItemHeight`; skin gallery uses `IconWidth`/`IconHeight` |
| `TLazRibbonSkinSelector` / `TLazRibbonSkinGalleryItem` | Built-in enum as the visible selector | `SelectedSkinName` |
| `TLazRibbonSkinManager` | `ActiveSkin` enum beside `ActiveSkinName` | `ActiveSkinName` |
| `TLazRibbonSkinDefinition` | Icon file-name fields as distributable identity | Embedded `Icon16Data`, `Icon24Data`, `Icon32Data` |

## BackStage Page Decision

`TLazRibbonBackstagePage` is a content container. Version 1.2.31 moves the old
page-as-command properties out of `published` while keeping them public for
source-level compatibility. This keeps existing Pascal code readable, but the
Object Inspector leads new developers to the clearer model:

```text
TLazRibbonBackstageView
  -> Buttons: navigation, commands and separators
  -> TLazRibbonBackstagePage children: content only
```

The consistency audit now rejects a published BackStage page command surface.

## ControlHost Decision

`TLazRibbonControlHostItem.Control` is the direct hosted-control reference for
new forms. Legacy `ControlName` and `ControlClassName` metadata stays
compatibility-only and hidden from the Object Inspector.

## Generated Surface Snapshot

`docs/quality/OBJECT_INSPECTOR_SURFACE_SNAPSHOT_2_0.md` is the generated record
of direct `published` property declarations for the package-facing classes. It is
created by `tools/export_object_inspector_snapshot.ps1` and compared by the
consistency audit so the 2.0 property model cannot silently drift from source.

## Generated Redundancy Audit

`docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` is generated from the
surface snapshot by `tools/export_object_inspector_redundancy_audit.ps1`. It
groups repeated direct `published` property names and requires each shared name
to fit a documented category. The current report reviews 48 repeated names and
reports zero unclassified redundancies.

## Generated Design-Time Skip Audit

`docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` is generated from
`source/design/LazRibbon_Register.pas` by
`tools/export_design_time_property_skip_audit.ps1`. It records the
`RegisterPropertyToSkip` and nil property-editor rules that hide obsolete,
compatibility-only or role-inappropriate properties from the Lazarus Object
Inspector. The current report documents 29 skip rules, 4 nil property-editor
hide rules and 8 affected component classes.

## Intentional Shared Names

These names are intentionally shared because they are normal Lazarus or
command-surface vocabulary:

- `Action`
- `Caption`
- `Enabled`
- `Visible`
- `Hint`
- `ImageIndex`
- `OnClick`
- ScreenTip fields
- `SkinManager`
- `AppearanceSource`

When one of these names appears on a non-command or non-visual-source component,
it must either be hidden, moved out of `published`, or explicitly justified in
the property matrix and the generated redundancy audit.

## Remaining Watch List

- Appearance subobjects still use many low-level color names inherited from the
  original SpkToolBar model. They remain acceptable because they live inside
  `RibbonAppearance` or `SkinManager.Appearance`, not as first-level component
  decisions.
