# Compiler Mode Audit — LazRibbon 0.3.57

This audit documents compiler-mode usage only. Version 0.3.57 does **not** change runtime behavior and does **not** mass-convert units between compiler modes.

## Summary

| Area | delphi | delphi {$H+} | objfpc | objfpc {$H+} | no explicit mode |
|---|---:|---:|---:|---:|---:|
| Runtime | 17 | 5 | 7 | 0 | 0 |
| Design-time | 4 | 0 | 1 | 0 | 0 |
| Tools | 0 | 0 | 1 | 0 | 0 |
| Package stubs | 0 | 0 | 0 | 0 | 2 |
| Demos | 7 | 0 | 10 | 0 | 0 |

## Findings

- The runtime is mixed: most core Ribbon units are still in Delphi mode, while utility/XML/math units and some newer code use ObjFPC mode.
- Design-time code is also mixed, but less severely.
- Demo units are mixed and should not drive runtime policy.
- Package stub units have no explicit compiler mode; this is normal for generated package source, but should be watched if manual code is added there.

## Recommendation

Do not mass-convert the project to `{$mode objfpc}{$H+}` yet. The safer policy is:

1. Keep existing modes in stable runtime units until regression tests exist.
2. Use `{$mode objfpc}{$H+}` for new independent units unless they must inherit Delphi-mode semantics from legacy classes.
3. Convert only small leaf units first, one unit per validation cycle.
4. Avoid converting `LazRibbon_Core.pas`, `LazRibbon_Backstage.pas`, and persistence units before tests exist.

## Unit inventory

| Area | Unit | Mode |
|---|---|---|
| Demos | `demos/actions/unit1.pas` | `objfpc` |
| Demos | `demos/actions/unit2.pas` | `objfpc` |
| Demos | `demos/actions_hidpi/unit1.pas` | `objfpc` |
| Demos | `demos/actions_hidpi/unit2.pas` | `objfpc` |
| Demos | `demos/application_button/unit1.pas` | `delphi` |
| Demos | `demos/backstage/unit1.pas` | `delphi` |
| Demos | `demos/backstage_recent_files/unit1.pas` | `delphi` |
| Demos | `demos/basic/Unit1.pas` | `delphi` |
| Demos | `demos/lclscaling/unit1.pas` | `objfpc` |
| Demos | `demos/popup_menu/unit1.pas` | `delphi` |
| Demos | `demos/quick_access_toolbar/unit1.pas` | `delphi` |
| Demos | `demos/ribbon_form/backup/unit1.pas` | `objfpc` |
| Demos | `demos/ribbon_form/unit1.pas` | `objfpc` |
| Demos | `demos/runtime/unit1.pas` | `objfpc` |
| Demos | `demos/skins_gallery/unit1.pas` | `delphi` |
| Demos | `demos/styles/unit1.pas` | `objfpc` |
| Demos | `demos/skin_editor_sample/unit1.pas` | `objfpc` |
| Package stubs | `packages/LazRibbonDesign.pas` | `no explicit mode` |
| Package stubs | `packages/LazRibbonRuntime.pas` | `no explicit mode` |
| Design-time | `source/design/LazRibbon_AppearanceEditor.pas` | `delphi` |
| Design-time | `source/design/LazRibbon_EditWindow.pas` | `delphi` |
| Design-time | `source/design/LazRibbon_Editor.pas` | `delphi` |
| Design-time | `source/design/LazRibbon_Register.pas` | `objfpc` |
| Design-time | `source/design/LazRibbon_SkinManagerEditor.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Appearance.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Backstage.pas` | `delphi {$H+}` |
| Runtime | `source/runtime/LazRibbon_BackstageBase.pas` | `delphi {$H+}` |
| Runtime | `source/runtime/LazRibbon_BaseItem.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Buttons.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Checkboxes.pas` | `objfpc` |
| Runtime | `source/runtime/LazRibbon_Const.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Core.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Dispatch.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Exceptions.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Form.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_GUITools.pas` | `objfpc` |
| Runtime | `source/runtime/LazRibbon_GraphTools.pas` | `objfpc` |
| Runtime | `source/runtime/LazRibbon_Groups.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Items.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Math.pas` | `objfpc` |
| Runtime | `source/runtime/LazRibbon_Popup.pas` | `objfpc` |
| Runtime | `source/runtime/LazRibbon_RibbonCommands.pas` | `delphi {$H+}` |
| Runtime | `source/runtime/LazRibbon_RibbonExtItems.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_SkinDefinition.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_SkinManager.pas` | `delphi {$H+}` |
| Runtime | `source/runtime/LazRibbon_SkinSelector.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_SkinSelectorItem.pas` | `delphi {$H+}` |
| Runtime | `source/runtime/LazRibbon_Tabs.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Tools.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_Types.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_XMLIni.pas` | `objfpc` |
| Runtime | `source/runtime/LazRibbon_XMLParser.pas` | `delphi` |
| Runtime | `source/runtime/LazRibbon_XMLTools.pas` | `objfpc` |
| Tools | `tools/LazRibbonSkinEditor/uSkinEditorMain.pas` | `objfpc` |
