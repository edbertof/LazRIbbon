# LazRibbon

LazRibbon is a Lazarus/Free Pascal component package for building Office-like Ribbon interfaces in LCL applications.

The package is an independent Lazarus-oriented fork/refactoring derived from LazToolbar concepts. The current codebase includes runtime Ribbon controls, design-time editors, BackStage support, Quick Access Toolbar support, a custom Ribbon form shell, skins, skin selection components, and a skin editor tool.

## Main components

Runtime components include:

- `TLazRibbon`
- `TLazRibbonPopupMenu`
- `TLazRibbonBackstageView`
- `TLazRibbonBackstagePage`
- `TLazRibbonBackstageRecentList`
- `TLazRibbonSkinManager`
- `TLazRibbonSkinSelector`
- `TLazRibbonSkinGalleryItem`
- `TLazRibbonForm`

Design-time support is provided by `LazRibbonDesign.lpk`.

## Design-time quick creation

When `LazRibbonDesign.lpk` is installed in Lazarus, selecting a `TLazRibbon` exposes component-editor verbs such as:

- `Contents editor...`
- `Add basic tab`
- `Add contextual tab`
- `Add starter Ribbon layout`
- `Validate KeyTips`

`Add basic tab` creates a starter tab with one pane, one large command and one small command. `Add contextual tab` creates a visible contextual tab with `Contextual = True`, a group caption, a contextual color and one starter command. `Add starter Ribbon layout` creates a fuller Office-like scaffold with tabs, panes, starter commands, KeyTips, ScreenTips and title-bar QAT entries. `Validate KeyTips` audits missing, duplicated and prefix-ambiguous KeyTips in the staged overlay model. These verbs are intended as scaffolding only; developers should rename captions, assign actions, images and shortcuts according to the application.

## Package layout

```text
packages/
  LazRibbonRuntime.lpk
  LazRibbonDesign.lpk
source/runtime/
  Runtime component units
source/design/
  Design-time registration and editors
demos/
  Example projects
tools/LazRibbonSkinEditor/
  Skin editor application
```

## Current version

This distribution is **LazRibbon 1.2.38 design-time property skip audit**.

The stable 1.0.0 line remains the conservative baseline for production use. The 1.1 line is a controlled stabilization line now validated with Lazarus 4.8, with the 1.1.70 runtime behavior preserved and the 1.1.72 packaging/design-time polish applied on top. The 1.2.38 build adds a generated design-time property skip audit: `tools/export_design_time_property_skip_audit.ps1` documents properties hidden from the Lazarus Object Inspector by the design package and the consistency audit fails when that report drifts. It keeps the 1.2.37 generated Object Inspector redundancy audit, the 1.2.36 single release-candidate preflight, the 1.2.35 generated Object Inspector surface snapshot, the 1.2.34 accelerated validation workflow, the 1.2.33 `TLazRibbonControlHostItem.Control` hosted-control API, the 1.2.32 `TLazRibbonSkinManager.ActiveSkinName` cleanup, the 1.2.31 BackStage page Object Inspector cleanup, the 1.2.30 component property matrix, the 1.2.29 ControlHost metadata cleanup, the 1.2.28 BackStage page composition cleanup, the 1.2.27 component composition model, the canonical `TLazRibbon.BackstageView` link and the structural separator cleanup, the 1.2.26 BackStage `AppearanceSource` consolidation, the 1.2.25 skin identity embedded icon API, the 1.2.24 skin selection naming consolidation, the 1.2.23 gallery size naming consolidation, the 1.2.22 BackStage `BackButtonVisible` consolidation, the 1.2.21 Ribbon minimize API names, the 1.2.20 public API audit and roadmap, the 1.2.19 Skin Editor Appearance mode detection, the 1.2.18 Skin Editor minimize preview fix, the 1.2.17 Ribbon collapse/expand height fix, the 1.2.16 Office-style `bomCoverClientArea` BackStage default and the 1.2.15 SkinManager color API consolidation into `General`, `Accent`, `Backstage`, `RecentList` and `Ribbon` groups, while keeping `TLazRibbonSkinManager.Appearance` as the complete skin appearance model. It also keeps the 1.2.14 Application Button API consolidation, the 1.2.13 `TLazRibbon.Appearance` alias removal, the 1.2.12 SkinManager LFM streaming fix, the 1.2.10 compact Skin Editor layout, the 1.2.9 `TLazRibbon.RibbonAppearance` design-time API, the 1.2.8 design-time refresh fix, the 1.2.7 buffer-height fix, the 1.2.6 pane caption text rendering fix, the 1.2.5 preview height and Dialog Launcher glyph fixes, the 1.2.4 pane caption paint order fix, the 1.2.3 Appearance difference markers and filtering, the 1.2.2 per-property restore from base, the 1.2.1 base comparison report, the 1.2.0 validation report, the 1.1.78 high-DPI palette icons, the 1.1.77 tab spacing controls, the 1.1.76 Dialog Launcher rename and the 1.1.75 Skin Editor Appearance inspector work.

Highlights in the current 1.2 line:

- Pane captions are drawn above pane items so Skin Editor Ribbon group names remain visible across skins.
- The collapse/expand button minimizes the actual Ribbon height, including inside the Skin Editor live preview.
- The Ribbon minimize button API uses Office-like names: `ShowMinimizeRibbonButton`, `MinimizeRibbonHint` and `RestoreRibbonHint`.
- The BackStage return button visibility uses the single Office-like `BackButtonVisible` property.
- BackStage visuals use the single `AppearanceSource` decision with `LinkedToolbar` or `SkinManager` as source objects.
- BackStage composition is linked through `TLazRibbon.BackstageView`; `ApplicationButton` keeps button/menu behavior focused on the button itself.
- BackStage pages are content containers; `TLazRibbonBackstageView.Buttons` owns page navigation, command and separator entries.
- `TLazRibbonBackstagePage` command/navigation properties are public compatibility only, not published Object Inspector API.
- Hosted-control items use `Control` to host a real Lazarus control; `Caption` is fallback placeholder text and legacy `ControlName`/`ControlClassName` metadata is compatibility-only.
- `docs/quality/COMPONENT_PROPERTY_MATRIX_2_0.md` documents the intended Object Inspector property model for the main components.
- `docs/quality/OBJECT_INSPECTOR_PROPERTY_AUDIT_2_0.md` tracks redundant/repeated property decisions for the 2.0 freeze.
- `docs/quality/OBJECT_INSPECTOR_REDUNDANCY_AUDIT_2_0.md` classifies repeated published property names and currently reports zero unclassified redundancies.
- `docs/quality/DESIGN_TIME_PROPERTY_SKIP_AUDIT_2_0.md` documents compatibility-only, obsolete or role-inappropriate properties hidden by the design-time package.
- `TLazRibbonSeparator` is treated as a structural pane item, so inherited command and ScreenTip properties are hidden at design time.
- Gallery size names are no longer duplicated: generic galleries use `ItemWidth`/`ItemHeight`, while SkinGallery uses `IconWidth`/`IconHeight`.
- Skin selection controls use `SelectedSkinName` as the Object Inspector property, so built-in and external skins follow the same API.
- `TLazRibbonSkinManager` uses `ActiveSkinName` as the Object Inspector active-skin property; `ActiveSkin` is compatibility-only for built-in skins and old resources.
- Skin identity icons are self-contained through `Icon16Data`, `Icon24Data` and `Icon32Data`; file-name fields are retained only for import/source compatibility.
- The standalone Skin Editor starts with a smaller 1060x700 window and tighter Identity, color, BackStage, Validation and Advanced layouts.
- Pane caption text uses the package's direct fit-width drawing path instead of widgetset-dependent centered `TextRect` layout.
- The Skin Editor live Ribbon preview keeps enough height for pane captions and the Dialog Launcher across DPI/font changes.
- The Dialog Launcher glyph is drawn by canvas lines instead of depending on private-use font characters.
- Design-time edits to Ribbon captions and structure force the parent Ribbon preview to rebuild and repaint.
- `TLazRibbon.RibbonAppearance` is the Office-like design-time property for detailed Ribbon visual styling; the old `TLazRibbon.Appearance` alias is no longer published.
- Demos and tools stream `RibbonAppearance.*` for `TLazRibbon` controls and keep `Appearance.*` for `TLazRibbonSkinManager`, with a consistency audit covering both cases.
- `TLazRibbon.ApplicationButton` is the single public API for the Office Application Button, including caption, visibility, behavior mode, popup menu, caption/dropdown style and click event.
- `TLazRibbonSkinManager` exposes skin palette colors through grouped properties: `General`, `Accent`, `Backstage`, `RecentList` and `Ribbon`.
- Office-style BackStage overlay modes, with full-client-area coverage as the default.
- Quick Access Toolbar support, including title-bar hosting in `TLazRibbonForm`.
- ScreenTips, staged KeyTips, multi-character KeyTips and a design-time KeyTip validator.
- Contextual tabs with optional contextual group headers.
- Configurable Ribbon tab caption metrics through `TabCaptionHorizontalPadding`, `TabCaptionSpacing` and `MinTabCaptionWidth`.
- Office-style Dialog Launcher support on `TLazRibbonPane` through `ShowDialogLauncher`, `DialogLauncherStyle` and `OnDialogLauncherClick`.
- Built-in and external `.skin` loading through `TLazRibbonSkinManager`, with `SkinFolder = '.\Skins'` as the default external folder.
- Skin XML icon embedding through `Icon16Data`, `Icon24Data` and `Icon32Data`, with legacy file-name tags written only when embedded data is absent.
- Expanded Skin Editor Appearance inspector with all-section browsing, filtering and broader RTTI property editing.
- Skin Editor validation report for identity, image data/file state, Appearance mode and key contrast checks.
- Skin Editor Appearance mode detection when creating from a base skin or opening an external skin file.
- Skin Editor base comparison report covering metadata, icon state, palette colors and published Appearance properties.
- Skin Editor per-property Appearance restore from the focused base skin.
- Skin Editor Appearance difference markers and `Somente diferentes da base` filter.
- Unified 24/36/48 px component palette icons for the visible LazRibbon design-time components.
- A showcase demo that combines Ribbon form chrome, QAT, BackStage, recent files, skins, ScreenTips, KeyTips and contextual tabs.
- Release scripts that audit package versions, demo GUI mode and generated artifacts before creating a source ZIP.
- A full build script and demo validation matrix for accelerated 2.0 release checks.
- A generated Object Inspector surface snapshot for reviewing published properties before the 2.0 API freeze.
- A generated Object Inspector redundancy audit for keeping repeated property names intentional and documented.
- A generated design-time property skip audit for keeping hidden Object Inspector properties intentional and documented.
- A one-command release-candidate preflight script for the final 2.0 validation path.
- Public API audit and 2.0 roadmap in `docs/quality/PUBLIC_API_AUDIT_2_0.md` and `docs/release/ROADMAP_2_0.md`.
- GitHub-oriented contribution, validation and publishing documentation.

Detailed version history lives in `CHANGELOG.md`; current stability notes and recommended next steps live in `STATUS.md`.

## First Ribbon Form

After installing the runtime and design-time packages, the shortest useful
structure is:

```text
TLazRibbonForm
  -> Ribbon: TLazRibbon
       -> ApplicationButton
       -> Tabs
            -> Panes
                 -> Items
```

At design time:

1. Create a new Lazarus application.
2. Change the main form class to `TLazRibbonForm` or drop a `TLazRibbon` aligned
   to the top of a normal form.
3. Set the Ribbon `ApplicationButton.Caption` to `Arquivo`.
4. Add one tab to `Tabs`, for example `Pagina inicial`.
5. Add one pane to the tab, for example `Documento`.
6. Add large or small button items to the pane.
7. Use `TLazRibbon.BackstageView` when the File/Application button should open a
   BackStage view.

The same structure can be created at runtime with the current API names:

```pascal
var
  Tab: TLazRibbonTab;
  Pane: TLazRibbonPane;
  Button: TLazRibbonLargeButton;
begin
  LazRibbon1.ApplicationButton.Caption := 'Arquivo';

  Tab := LazRibbon1.Tabs.Add;
  Tab.Caption := 'Pagina inicial';

  Pane := Tab.Panes.Add;
  Pane.Caption := 'Documento';

  Button := Pane.Items.AddLargeButton;
  Button.Caption := 'Novo';
  Button.ScreenTipTitle := 'Novo';
  Button.ScreenTipText := 'Cria um novo documento.';
  Button.OnClick := @NewDocumentClick;
end;
```

## ScreenTips

Ribbon items now support richer ScreenTip metadata while preserving the old `Hint` behavior.

Use these properties on Ribbon items such as `TLazRibbonLargeButton` and `TLazRibbonSmallButton`. The same fields are also available on `TLazRibbonQuickAccessItem` and `TLazRibbon.ApplicationButton`:

```pascal
LazRibbonLargeButtonNew.Hint := 'Cria um novo documento.';
LazRibbonLargeButtonNew.ScreenTipTitle := 'Novo';
LazRibbonLargeButtonNew.ScreenTipText := 'Cria um novo documento usando o modelo padrÃ£o.';
LazRibbonLargeButtonNew.ScreenTipShortcut := 'Ctrl+N';
LazRibbonLargeButtonNew.ScreenTipFooter := 'Exemplo de ScreenTip enriquecido.';
```

When all ScreenTip fields are empty, LazRibbon uses the regular `Hint` exactly as before. Set `ShowScreenTip := False` to force legacy hint behavior even when ScreenTip fields were filled.

## BackStage overlay modes

`TLazRibbonBackstageView.OverlayMode` controls how the BackStage is positioned when opened from a linked `TLazRibbon`:

- `bomCoverClientArea`: default mode; covers the full parent client area, matching newer Office BackStage behavior.
- `bomCoverRibbonArea`: keeps Ribbon tab captions visible for applications that want the older tab-preserving layout.

The default is already the newer Office-style behavior. Set it explicitly when you want the form to document that choice:

```pascal
LazRibbonBackstageView1.OverlayMode := bomCoverClientArea;
```

When used inside `TLazRibbonForm`, the custom title bar remains visible and interactive while the BackStage fills the form content.

## Tab Spacing

Tab captions use Office-like spacing by default. These metrics are layout properties of `TLazRibbon`, not skin colors:

```pascal
LazRibbon1.TabCaptionHorizontalPadding := 10;
LazRibbon1.TabCaptionSpacing := 2;
LazRibbon1.MinTabCaptionWidth := 40;
```

Increase `TabCaptionHorizontalPadding` when tab text feels crowded, increase `TabCaptionSpacing` when adjacent tabs need more separation, and use `MinTabCaptionWidth` to keep short captions from becoming too narrow.

## Dialog Launcher

`TLazRibbonPane` uses Office-style Dialog Box Launcher naming for the small button in the lower corner of a Ribbon group:

```pascal
LazRibbonPaneFont.ShowDialogLauncher := True;
LazRibbonPaneFont.DialogLauncherStyle := dlsArrow;
LazRibbonPaneFont.OnDialogLauncherClick := @PaneFontDialogLauncherClick;
```

`dlsArrow` is the default Office-like glyph. `dlsPlus` remains available for applications that prefer a plus sign, but the public API now uses Dialog Launcher names only.

## Installation summary

1. Open Lazarus 4.8.
2. Open `packages/LazRibbonRuntime.lpk`.
3. Compile the runtime package.
4. Open `packages/LazRibbonDesign.lpk`.
5. Compile and install the design-time package.
6. Rebuild/restart Lazarus when prompted.
7. Check the `LazRibbon` component palette.

Detailed steps are in `INSTALL.md`.

## Recommended demos

After installation, test at least:

- `demos/showcase/project1.lpi`
- `demos/basic/project1.lpi`
- `demos/skins_gallery/project1.lpi`
- `demos/backstage/project1.lpi`

For release validation, build the complete matrix:

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_all_projects.ps1 -CleanArtifacts
```

For a complete release-candidate preflight, including consistency checks and ZIP
audit:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 1.2.38 -OutputDirectory D:\Ribbon4Lazarus
```

The purpose of each demo is documented in
`docs/release/DEMO_VALIDATION_MATRIX.md`.
- `demos/backstage_recent_files/project1.lpi`
- `demos/ribbon_form/project1.lpi`
- `demos/skin_editor_sample/project1.lpi`


## Demo overview

The demos are intended as both examples and manual regression checks for Lazarus 4.8:

- `showcase`: visual smoke test combining `TLazRibbonForm`, title-bar QAT, Ribbon, BackStage, recent list, SkinManager, SkinGallery, ScreenTips, KeyTips and contextual tabs.
- `basic`: tabs, panes and common items.
- `actions`: action-linked Ribbon items.
- `backstage`: BackStage pages and commands.
- `backstage_recent_files`: recent-files list integration.
- `quick_access_toolbar`: QAT behavior.
- `ribbon_form`: custom Ribbon form shell.
- `skins_gallery`: SkinManager, selector and gallery behavior.
- `skin_editor_sample`: sample skin file and editor-related scenario.

## Windows demo subsystem

All demo projects are configured as Windows GUI applications through `GraphicApplication=True` in their `.lpi` files. This avoids the extra console/DOS window when running demos on Windows and prevents confusion with taskbar minimize/restore behavior.

For `TLazRibbonForm`, the custom title-bar minimize button uses the native Windows minimize system command when available, so restore from the taskbar should behave like a normal sizeable application window.

## Development status

See `STATUS.md` for the current technical status, known limitations, and recommended next steps.

## Repository docs

- `CONTRIBUTING.md`: contribution and validation expectations.
- `docs/quality/VALIDATION_LAZARUS_4_8.md`: Lazarus 4.8 release validation checklist.
- `docs/release/GITHUB_PUBLISHING.md`: public repository and GitHub release checklist.
- `docs/assets/screenshots/`: recommended location for public README screenshots.

## License

The package preserves the Modified LGPL / linking-exception licensing model inherited from LazToolbar where applicable. See `LICENSE.txt` and source file headers.


## Official target environment

LazRibbon is currently developed and validated for:

- Lazarus 4.8
- The Free Pascal version bundled with Lazarus 4.8
- LCL applications
- Windows as the primary validation platform

Lazarus 4.6 was the previous validation target and may still work, but the active support target for the current 1.2 stabilization line is Lazarus 4.8.

## Release hygiene

Source ZIPs should contain source, package files, demos, tools and documentation only. Generated binaries, compiler output and Lazarus user-environment files such as `packagefiles.xml` should be excluded. Before packaging, run:

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_release_zip.ps1
```

The release builder creates a source ZIP and runs `tools/check_release_zip.ps1` against it.
By default, new release ZIPs are stored in `D:\Ribbon4Lazarus`.

## Publishing on GitHub

Before creating a public release, run the checklist in `docs/quality/VALIDATION_LAZARUS_4_8.md` and follow `docs/release/GITHUB_PUBLISHING.md`. Add screenshots under `docs/assets/screenshots/` when they are available, then reference them from this README.


## 1.1 development line

The 1.1 line is reserved for controlled architectural stabilization. The first priorities are:

- keep Lazarus 4.8 as the official target;
- preserve 1.0.0 behavior unless a change is deliberate and tested;
- reduce unsafe coupling gradually;
- plan interfaces before refactoring `LazRibbon_Core.pas`;
- avoid broad compiler-mode conversion until regression checks are stronger.

See `docs/release/ROADMAP_1_1.md`.



### Contextual tabs

`TLazRibbonTab` exposes contextual-tab metadata: `Contextual`, `ContextualGroupCaption`, and `ContextualColor`. When `Contextual = True`, the tab is drawn with a tinted face, a colored accent strip, a contextual bottom line and contextual text accent.

`TLazRibbon` also exposes explicit contextual visibility helpers: `ShowContextualTabs`, `HideContextualTabs`, `SetContextualTabsVisible`, `HideAllContextualTabs`, and `ContextualTabsVisible`. The group caption is matched against `TLazRibbonTab.ContextualGroupCaption`; passing an empty group caption affects all contextual tabs.

Example:

```pascal
LazRibbon1.ShowContextualTabs('Ferramentas de Imagem', True);
LazRibbon1.HideContextualTabs('Ferramentas de Imagem');
```

This remains explicit application logic. The Ribbon does not try to infer which object is selected. Automatic group-header layout is deferred to a later release.

### KeyTips

The `TLazRibbon.ShowKeyTips` property enables the lightweight KeyTips overlay. With the Ribbon focused, press `Alt` to show/hide KeyTips and `Esc` to hide them. `KeyTip` metadata can be set on the Application Button, tabs, Quick Access Toolbar items and Ribbon items. In 1.1.46 the keyboard path activates the Application Button, tabs, QAT items and visible/enabled command items in the active tab. In 1.1.47 the visual overlay also covers QAT items hosted by `TLazRibbonForm` in the custom title bar. Button, button-dropdown and toggle items execute through `TLazRibbonBaseItem.ExecuteKeyTip`; pure dropdown buttons open their dropdown menu when available.

