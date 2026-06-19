# LazRibbon Design-Time Property Skip Audit for 2.0

Generated from `source/design/LazRibbon_Register.pas` by `tools/export_design_time_property_skip_audit.ps1`.
It records design-time Object Inspector hiding rules so compatibility-only, structural or obsolete properties stay out of the new-project workflow.

Regenerate after changing design-time property hiding:

`powershell -ExecutionPolicy Bypass -File tools/export_design_time_property_skip_audit.ps1 -OutputPath docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md`

## Summary

- RegisterPropertyToSkip rules: 29
- Nil property-editor hide rules: 4
- Components with hidden design-time properties: 8

## Hidden Object Inspector Properties

| Component | Property | Mechanism | Reason |
| --- | --- | --- | --- |
| `TLazRibbonBackstagePage` | `Action` | RegisterPropertyToSkip | BackStage pages are content containers. Use BackstageView.Buttons for commands. |
| `TLazRibbonBackstagePage` | `CloseBackstageOnClick` | RegisterPropertyToSkip | BackStage pages are content containers. Use BackstageView.Buttons for command close behavior. |
| `TLazRibbonBackstagePage` | `Command` | RegisterPropertyToSkip | BackStage pages are content containers. Use BackstageView.Buttons for commands. |
| `TLazRibbonBackstagePage` | `ItemKind` | RegisterPropertyToSkip | BackStage pages are content containers. Use BackstageView.Buttons to create page, command and separator navigation items. |
| `TLazRibbonBackstagePage` | `OnExecute` | RegisterPropertyToSkip | BackStage pages are content containers. Use BackstageView.Buttons.OnExecute for commands. |
| `TLazRibbonCheckbox` | `GroupBehaviour` | RegisterPropertyToSkip | GroupBehaviour is not needed. |
| `TLazRibbonControlHostItem` | `ControlClassName` | RegisterPropertyToSkip | ControlClassName is legacy metadata and is not needed in new forms. |
| `TLazRibbonControlHostItem` | `ControlName` | RegisterPropertyToSkip | Use Control to assign the hosted control. ControlName is legacy metadata. |
| `TLazRibbonRadioButton` | `GroupBehaviour` | RegisterPropertyToSkip | GroupBehaviour is not needed. |
| `TLazRibbonSeparator` | `Action` | RegisterPropertyToSkip | Separators are structural items and do not execute actions. |
| `TLazRibbonSeparator` | `Caption` | RegisterPropertyToSkip | Separators are structural items and do not display captions. |
| `TLazRibbonSeparator` | `Enabled` | RegisterPropertyToSkip | Separators are structural items. Use Visible to include or hide them. |
| `TLazRibbonSeparator` | `Hint` | RegisterPropertyToSkip | Separators are structural items and do not show hints. |
| `TLazRibbonSeparator` | `KeyTip` | RegisterPropertyToSkip | Separators are structural items and do not participate in KeyTips. |
| `TLazRibbonSeparator` | `OnClick` | RegisterPropertyToSkip | Separators are structural items and do not execute click handlers. |
| `TLazRibbonSeparator` | `ScreenTipFooter` | RegisterPropertyToSkip | Separators are structural items and do not show ScreenTips. |
| `TLazRibbonSeparator` | `ScreenTipShortcut` | RegisterPropertyToSkip | Separators are structural items and do not show ScreenTips. |
| `TLazRibbonSeparator` | `ScreenTipText` | RegisterPropertyToSkip | Separators are structural items and do not show ScreenTips. |
| `TLazRibbonSeparator` | `ScreenTipTitle` | RegisterPropertyToSkip | Separators are structural items and do not show ScreenTips. |
| `TLazRibbonSeparator` | `ShowScreenTip` | RegisterPropertyToSkip | Separators are structural items and do not show ScreenTips. |
| `TLazRibbonSkinGalleryItem` | `Hint` | RegisterPropertyToSkip | Hint is generated dynamically from ShowHints and the skin under the mouse. |
| `TLazRibbonSkinGalleryItem` | `ItemHeight` | Nil property editor | Reliable hide path for inherited properties when RegisterPropertyToSkip alone is not enough in some Lazarus versions. |
| `TLazRibbonSkinGalleryItem` | `ItemHeight` | RegisterPropertyToSkip | ItemHeight is internal for skin galleries. Use IconHeight instead. |
| `TLazRibbonSkinGalleryItem` | `ItemWidth` | Nil property editor | Reliable hide path for inherited properties when RegisterPropertyToSkip alone is not enough in some Lazarus versions. |
| `TLazRibbonSkinGalleryItem` | `ItemWidth` | RegisterPropertyToSkip | ItemWidth is internal for skin galleries. Use IconWidth instead. |
| `TLazRibbonSkinGalleryItem` | `SelectedSkin` | RegisterPropertyToSkip | SelectedSkin is a built-in-skin compatibility shortcut. Use SelectedSkinName instead. |
| `TLazRibbonSkinGalleryItem` | `ShowCaptions` | RegisterPropertyToSkip | ShowCaptions was removed. Use ShowHints to show skin names as tooltips. |
| `TLazRibbonSkinManager` | `ActiveSkin` | RegisterPropertyToSkip | ActiveSkin is a built-in-skin compatibility shortcut. Use ActiveSkinName instead. |
| `TLazRibbonSkinSelector` | `ItemHeight` | Nil property editor | Reliable hide path for inherited properties when RegisterPropertyToSkip alone is not enough in some Lazarus versions. |
| `TLazRibbonSkinSelector` | `ItemHeight` | RegisterPropertyToSkip | ItemHeight was removed. Use IconHeight instead. |
| `TLazRibbonSkinSelector` | `ItemWidth` | Nil property editor | Reliable hide path for inherited properties when RegisterPropertyToSkip alone is not enough in some Lazarus versions. |
| `TLazRibbonSkinSelector` | `ItemWidth` | RegisterPropertyToSkip | ItemWidth was removed. Use IconWidth instead. |
| `TLazRibbonSkinSelector` | `SelectedSkin` | RegisterPropertyToSkip | SelectedSkin is a built-in-skin compatibility shortcut. Use SelectedSkinName instead. |

## Component Summary

| Component | Hidden properties |
| --- | --- |
| `TLazRibbonBackstagePage` | `Action`, `CloseBackstageOnClick`, `Command`, `ItemKind`, `OnExecute` |
| `TLazRibbonCheckbox` | `GroupBehaviour` |
| `TLazRibbonControlHostItem` | `ControlClassName`, `ControlName` |
| `TLazRibbonRadioButton` | `GroupBehaviour` |
| `TLazRibbonSeparator` | `Action`, `Caption`, `Enabled`, `Hint`, `KeyTip`, `OnClick`, `ScreenTipFooter`, `ScreenTipShortcut`, `ScreenTipText`, `ScreenTipTitle`, `ShowScreenTip` |
| `TLazRibbonSkinGalleryItem` | `Hint`, `ItemHeight`, `ItemWidth`, `SelectedSkin`, `ShowCaptions` |
| `TLazRibbonSkinManager` | `ActiveSkin` |
| `TLazRibbonSkinSelector` | `ItemHeight`, `ItemWidth`, `SelectedSkin` |

## Release Gate

Before `2.0.0`, any design-time hidden property should satisfy one of these rules:

- It is obsolete and has a clearer replacement in the Object Inspector.
- It is compatibility-only for old source or old `.lfm` resources.
- It is inherited from a broader base class but does not match the narrower component role.
- It is documented in this generated audit and protected by the consistency audit.
