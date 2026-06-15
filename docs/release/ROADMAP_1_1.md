# LazRibbon 1.1 Roadmap

## Purpose

LazRibbon 1.1 is the first post-1.0 development line. Its goal is not to add a large set of new Ribbon features. Its goal is to make the package easier to maintain without destabilizing the validated 1.0 behavior.

## Official target

- Lazarus 4.8
- Free Pascal bundled with Lazarus 4.8
- LCL
- Windows as the primary validation platform

## Priorities

### 1. Safer skin access

The current dispatch layer avoids circular dependencies by exposing skin access through object-level indirection. The 1.1 line should investigate a small, low-level skin provider interface before altering item/rendering units.

Do not replace the current mechanism in one large step. Introduce the interface first, then migrate consumers gradually.

### 2. Controlled Core decomposition

`LazRibbon_Core.pas` is functional but too large. Do not split it immediately. First identify stable extraction boundaries:

- Quick Access Toolbar support;
- Application Button support;
- dispatch implementation;
- hit-testing helpers;
- paint/layout helpers.

Each extraction must preserve demos and the manual regression checklist.

### 3. Regression discipline

Before structural changes, the manual checklist should be treated as mandatory. Any new architectural change should be validated against at least:

- package compile/install;
- `demos/basic`;
- `demos/backstage`;
- `demos/backstage_recent_files`;
- `demos/skins_gallery`;
- `demos/ribbon_form`;
- `tools/LazRibbonSkinEditor`.

### 4. No broad compiler-mode conversion yet

The mixed compiler-mode situation is documented. Do not convert all units to a single mode until the code has stronger regression coverage.

### 5. XML parser replacement deferred

The custom XML layer is technical debt, but it touches `.lazskin` persistence. Replacement is not an early 1.1 task.

## Out of scope for early 1.1

- complete DevExpress feature parity;
- new large item families;
- parser replacement;
- broad mode conversion;
- major visual redesign;
- breaking 1.0 LFM compatibility without an explicit migration step.

## First recommended implementation steps

1. Add a low-level skin provider interface. **Started in 1.1.1 with `ILazRibbonSkinProvider`.**
2. Add focused regression notes for QAT, BackStage and SkinGallery.
3. Extract small non-visual helper code only after step 1 compiles cleanly.
4. Postpone large `LazRibbon_Core.pas` decomposition until there is a validated extraction plan.


## 1.1.2 stabilization note

1.1.2 adds a targeted SkinGallery hover hit-test refinement. The fix is intentionally local to `TLazRibbonSkinGalleryItem.SkinIndexAtPos` and does not change the skin provider architecture introduced in 1.1.1.

## 1.1.3 stabilization note

1.1.3 fixes a SkinEditor-only regression: runtime-created handler assignments must use explicit method pointers in ObjFPC mode. It also moves the real Ribbon preview into a fixed live preview strip above the editor tabs. This is intentionally limited to the tool and does not broaden the 1.1 architectural refactoring scope.

## 1.1.4 stabilization note

1.1.4 refines the SkinEditor UI by moving its primary commands into the live `TLazRibbon` surface. This keeps the editor visually coherent with the component being edited while avoiding a broader runtime refactor. The base-skin ComboBox remains outside the Ribbon until hosted controls are properly implemented.
## 1.1.5 stabilization note

1.1.5 adds a controlled bridge from the standalone SkinEditor to the complete `TLazRibbonToolbarAppearance` editor. This is deliberately not a full redesign of the inherited Appearance editor. The safe palette workflow remains the default path; the full editor is exposed as an advanced option because subsequent palette changes can recalculate part of the Appearance object.


## 1.1.6 stabilization note

1.1.6 addresses two SkinEditor regressions: the command Ribbon is now streamed in `uSkinEditorMain.lfm` instead of being created entirely at runtime, and the complete Appearance dialog now guards against invalid page/list/combo indexes during creation and loading. This is still a SkinEditor/design-time stabilization step, not a broad runtime refactor.

## 1.1.7 stabilization note

1.1.7 fixes the remaining complete Appearance dialog crash reported in the SkinEditor. The defect was not merely a missing runtime guard: the `.lfm` still persisted `ActivePage`, `TabIndex` and several `ItemIndex` values. Lazarus can stream these index properties before the PageControl pages or ComboBox items are fully available, producing `List index (0) out of bounds`. The fix removes those persisted indexes from the form resource and centralizes safe ComboBox index assignment in code.

## 1.1.8 stabilization note

1.1.8 corrects the remaining complete Appearance dialog crash. The 1.1.7 patch removed unsafe persisted indexes, but the dialog still had a direct runtime assumption in `UpdateSizes`: `tbPreview.Tabs[0].Panes[2]`. Opening the dialog from the SkinEditor can activate sizing code before the embedded preview Ribbon has fully streamed or rebuilt its child collections. The fix replaces that direct access with a guarded preview-width calculation.

## 1.1.9 stabilization note

1.1.9 corrects the remaining complete Appearance dialog crash observed from the SkinEditor. The repeated error was not caused by persisted `ItemIndex` values nor by `tbPreview.Tabs[0]` sizing after the previous guards. The remaining unsafe assumption was in `UpdateImages`: it copied `Application.Icon` into preview image lists without checking whether the SkinEditor executable actually provided a valid icon. Missing icons are now ignored; preview sample images are optional.


## 1.1.10 stabilization note

1.1.10 consolidates the SkinEditor workflow around palette editing and the complete Appearance editor. The main risk after 1.1.9 was silent loss of advanced Appearance edits when the user later changed a simple color. The editor now preserves the full Appearance after advanced editing and requires an explicit palette reapply command before palette-derived values overwrite the detailed Appearance model.


## 1.1.11 stabilization note

1.1.11 addresses the main usability problem of the SkinEditor. The editor no longer presents palette editing, BackStage editing, preview and full Appearance editing as one flat set of options. It now follows a step-oriented workflow: identify the skin, edit Ribbon colors, edit BackStage colors, validate in the real LazRibbon preview, then use technical Appearance controls only when necessary.


## 1.1.12 stabilization note

1.1.12 clarifies the SkinEditor interaction model. The `Appearance` property is preserved as the detailed rendering model. The skin palette is the safer user-facing editing layer, not a deletion path for `Appearance`. Main editor commands now live in the Application Button / BackStage, leaving the regular Ribbon tabs to act as live visual feedback.

## 1.1.14 stabilization note

1.1.14 fixes the SkinEditor BackStage command entry point. The editor intentionally uses the Ribbon `Arquivo` Application Button as the access point for create/open/save/export commands, so `ApplicationButton.Visible` must remain enabled at runtime. Regular Ribbon tabs remain dedicated to live skin preview.


## 1.1.19 stabilization note

1.1.19 does not add a new feature. It addresses a presentation problem: the SkinEditor was functioning, but the form still looked like an internal utility. The layout is now cleaner, the wording is more consistent, the base-selection strip is less noisy, the editing tabs use clearer names, and the BackStage wording better matches an end-user tool.


## 1.1.20 stabilization note

1.1.20 improves the SkinEditor interaction model by moving base selection into the Ribbon itself. Instead of relying on a side `TListBox`, the editor now uses `TLazRibbonSkinGalleryItem` as the visible selector for built-in base skins. This makes the selection surface more consistent with the visual nature of skins and reduces the form-like feel of the editor.


## 1.1.21 stabilization note

1.1.21 fixes a file-format regression in the SkinEditor. The inherited Appearance serializer was writing the menu button appearance as `<Menu Button>`, which is not a legal XML element name. New files are saved as `<MenuButton>`, and the loader performs a narrow compatibility normalization so files saved by 1.1.20 can be opened and re-saved.


## 1.1.22 stabilization note

1.1.22 focuses on the SkinEditor internal tab experience. After moving base selection to the Ribbon gallery and fixing `.skin` XML serialization, the remaining weakness was the form-like layout of the editing tabs. This version reorganizes those tabs into clearer sections while keeping the existing skin model, BackStage command surface and Appearance technical layer unchanged.


## 1.1.23 stabilization note

1.1.23 addresses a UX/layout regression in the SkinEditor. The previous build hid the old base strip and side list at runtime, which made design time look very different from runtime and removed the visible `Base em foco` information. This build restores a compact base-focus strip, removes hidden legacy panels from the visual layout, and moves the editor tabs closer to the Ribbon preview.


## 1.1.24 stabilization note

1.1.24 fixes a SkinEditor design-time issue introduced by making the BackStage mostly runtime-oriented. The `EditorBackstage` was persisted too narrow for its navigation/page geometry, which made Lazarus calculate a negative page width while reading `uSkinEditorMain.lfm`. The persisted BackStage bounds are now safe for the designer; runtime alignment remains controlled by `SetupPreviewToolbar`.


## 1.1.25 stabilization note

1.1.25 is a runtime layout polish pass for the SkinEditor. It keeps the 1.1.24 designer fix, preserves the Ribbon SkinGallery and BackStage command model, and focuses only on reducing visual dead space and making the base-context strip visible without returning to the older side-list workflow.


## 1.1.26 stabilization note

1.1.26 adds a minimal validation layer to the SkinEditor save workflow. The purpose is to stop the editor from producing `.skin` files with empty or technically unsafe identifiers. The change is intentionally local to the editor and does not alter XML, SkinManager, SkinGallery, BackStage or the Palette/Appearance model.

## 1.1.27 stabilization note

1.1.27 prepares the package for public repository sharing. It adds a clean source ZIP builder, tightens release ZIP auditing, aligns active documentation with the current 1.1 line, and removes Lazarus 4.6 runtime package warnings without changing Ribbon, BackStage, SkinManager, SkinGallery or SkinEditor behavior.

## 1.1.28 stabilization note

1.1.28 adds a configurable full-client BackStage overlay for newer Office-style applications. The existing `bomCoverRibbonArea` default remains compatible, while `TLazRibbonBackstageView.OverlayMode = bomCoverClientArea` lets applications cover the full form client area. `TLazRibbonForm` keeps its custom title text and window buttons available when this mode is active.

## 1.1.29 stabilization note

1.1.29 cleans up the BackStage overlay naming introduced around the full-client overlay work. The intermediate mode is now `bomCoverRibbonAndClient`, making it clear that the overlay starts at the linked Ribbon top; `bomCoverClientArea` remains the mode for covering the full parent client area.

## 1.1.30 stabilization note

1.1.30 simplifies the public BackStage overlay API after review. The intermediate mode was removed because it overlapped conceptually with the full-client overlay. Public choices are now the legacy `bomCoverRibbonArea` mode and the newer Office-style `bomCoverClientArea` mode.

## 1.1.31 stabilization note

1.1.31 starts tightening the Skin Editor. New skins created from a base now preserve the full `Appearance` object instead of behaving like palette-only derivatives, and the technical Appearance editor exposes the missing `Popup.Style` option.

## 1.1.32 stabilization note

1.1.32 reduces the gap between the Skin Editor and the design-time `Appearance` property editor. The Skin Editor now has an embedded RTTI-based inspector for the full published `Appearance` model while still keeping the visual technical editor available.

## 1.1.33 stabilization note

1.1.33 makes the SpkToolBar-style visual `Appearance` editor the primary detailed-editing path in the Skin Editor. The advanced tab now opens the full editor directly or jumps to Menu Button, Tab, Pane, Item, Dropdown, Import/Export, and Tools pages, while the RTTI inspector remains available for precise published-property edits.

## 1.1.34 stabilization note

1.1.34 aligns runtime folder loading with the current Skin Editor file format. `TLazRibbonSkinManager.SkinFolder` now defaults to `.\Skins`, loads `.skin` files first, still accepts legacy `.lazskin` files, falls back to the executable folder when the configured folder does not exist, and built-in skin export now writes `.skin` files.

## 1.1.35 stabilization note

1.1.35 makes skin identity icons self-contained. Saved skin XML now includes `Icon16Data`, `Icon24Data`, and `Icon32Data` Base64 fields generated from the selected icon files, while the existing filename tags remain available for compatibility and editing. Runtime icon drawing and the Skin Editor preview prefer embedded data and fall back to external files only when embedded data is absent.

## 1.1.36 stabilization note

1.1.36 moves the Skin Editor identity asset controls into the form resource. The group, icon filename fields, browse buttons, preview image field, and icon preview image are now visible in `uSkinEditorMain.lfm` and therefore editable in the Lazarus designer. The runtime layout pass still reparents them into the polished section layout when the editor runs.
