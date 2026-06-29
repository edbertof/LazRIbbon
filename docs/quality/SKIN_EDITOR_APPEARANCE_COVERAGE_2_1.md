# Skin Editor Appearance Coverage For 2.1

This generated report compares the published `TLazRibbonToolbarAppearance` section properties with the current appearance-editing surfaces.

- Source model: `source/runtime/LazRibbon_Appearance.pas`
- Native visual editor: `source/design/LazRibbon_AppearanceEditor.pas` and `.lfm`
- Standalone Skin Editor: `tools/LazRibbonSkinEditor/uSkinEditorMain.pas` and `.lfm`
- Generator: `tools/export_skin_editor_2_1_coverage.ps1`

## Summary

| Section | Published properties | Native visual mentions | Standalone direct mentions | Standalone RTTI inspector |
| --- | ---: | ---: | ---: | --- |
| Tab | 8 | 8 | 7 | Yes |
| MenuButton | 18 | 18 | 18 | Yes |
| Pane | 9 | 9 | 9 | Yes |
| Element | 30 | 30 | 30 | Yes |
| Popup | 22 | 22 | 22 | Yes |

## Interpretation

- The native visual appearance editor remains the reference visual editor for detailed `Appearance` tuning.
- The standalone Skin Editor has generic RTTI coverage when `GetPropList`, `AddAppearanceSectionProperties` and `EditAppearanceProperty` are present; this means every published property can be listed and edited even when it has no dedicated visual control.
- For 2.1, dedicated standalone controls should be added only where they improve workflow: base comparison, common color groups, reset/apply actions, preview states and high-frequency skin edits.
- If a new published `Appearance` property is added, regenerate this report and check whether it deserves a native visual control, a standalone direct helper, or generic RTTI-only coverage.

## Property Detail

| Property | Type | Native visual mention | Standalone direct mention | Standalone coverage | 2.1 follow-up |
| --- | --- | --- | --- | --- | --- |
| Tab.TabHeaderFont | `TFont` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Tab.BorderColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Tab.CaptionHeight | `Integer` | Yes | No | RTTI inspector | Use RTTI editor; consider visual helper only if this becomes a common skin workflow. |
| Tab.CornerRadius | `Integer` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Tab.GradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Tab.GradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Tab.GradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Tab.InactiveTabHeaderFontColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.CaptionFont | `TFont` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.IdleFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.IdleGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.IdleGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.IdleGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.IdleCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.HotTrackFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.HotTrackGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.HotTrackGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.HotTrackGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.HotTrackCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.HotTrackBrightnessChange | `Integer` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.ActiveFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.ActiveGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.ActiveGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.ActiveGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.ActiveCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| MenuButton.ShapeStyle | `TLazRibbonMenuButtonShapeStyle` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.BorderDarkColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.BorderLightColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.CaptionBgColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.CaptionFont | `TFont` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.GradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.GradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.GradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.HotTrackBrightnessChange | `Integer` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Pane.Style | `TLazRibbonPaneStyle` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.CaptionFont | `TFont` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleInnerLightColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleInnerDarkColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleKnobColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleTrackColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.IdleCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackInnerLightColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackInnerDarkColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackTrackColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.HotTrackBrightnessChange | `Integer` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveInnerLightColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveInnerDarkColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveKnobColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveTrackColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.ActiveCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.KnobAsGradient | `Boolean` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Element.Style | `TLazRibbonElementStyle` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.CaptionFont | `TFont` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.CheckedFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.CheckedGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.CheckedGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.CheckedGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.DisabledCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.DividerLineColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.GutterFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.GutterGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.GutterGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.GutterGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.HotTrackCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.HotTrackFrameColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.HotTrackGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.HotTrackGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.HotTrackGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.IdleCaptionColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.IdleGradientFromColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.IdleGradientToColor | `TColor` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.IdleGradientType | `TBackgroundKind` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.SelectionShape | `TLazRibbonPopupSelectionShape` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |
| Popup.Style | `TLazRibbonPopupStyle` | Yes | Yes | RTTI inspector | Keep direct helper synchronized. |

## 2.1 Decision

The first 2.1 Skin Editor pass should improve workflow around the existing complete RTTI inspector instead of duplicating every `Appearance` property with a hand-built control. The editor should make the full model visible, searchable, comparable against a base skin and easy to preview, while reserving custom controls for operations that are hard to express as single-property edits.
