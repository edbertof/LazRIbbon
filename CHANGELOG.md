## 1.2.17 - Ribbon minimize height fix

- Fixes the collapse/expand button so `TLazRibbon.RibbonMinimized` reduces the Ribbon control height instead of only hiding panes.
- Restores the previous expanded height when the Ribbon is expanded again, preserving taller hosted previews such as the Skin Editor preview.
- Normalizes minimized height after `.lfm` loading when a Ribbon is persisted with `RibbonMinimized = True`.
- Updates the consistency audit to protect the minimize-height behavior.
- Updates runtime and design-time package versions to 1.2.17.

## 1.2.16 - Office-style BackStage default

- Changes `TLazRibbonBackstageView.OverlayMode` default from `bomCoverRibbonArea` to `bomCoverClientArea`.
- Keeps `bomCoverRibbonArea` available for applications that explicitly want the older tab-preserving BackStage layout.
- Updates the project consistency audit to protect the new Office-style BackStage default.
- Updates runtime and design-time package versions to 1.2.16.

## 1.2.15 - SkinManager palette API consolidation

- Adds `TLazRibbonSkinManager.Accent` for the generic navigation/active/hot palette colors used by command, popup and highlight surfaces.
- Keeps `TLazRibbonSkinManager.Appearance` as the complete skin appearance model, but removes the published flat palette aliases from `TLazRibbonSkinManager`.
- Removes the `TLazRibbonSkinManager.Backstage.ActiveColor` and `Backstage.FrameColor` aliases; use `Backstage.SelectedColor` and `Backstage.SelectedFrameColor`.
- Migrates package demos and tools to stream `General.*`, `Accent.*` and `RecentList.*` palette groups.
- Updates the consistency audit to reject legacy flat SkinManager palette streaming.
- Updates runtime and design-time package versions to 1.2.15.

## 1.2.14 - ApplicationButton API consolidation

- Adds `TLazRibbon.ApplicationButton.Style` so the Application Button caption/dropdown style lives on the Office-like persistent subobject.
- Removes the published flattened `TLazRibbon` Application/Menu Button aliases: `ApplicationButtonCaption`, `ApplicationButtonVisible`, `ApplicationButtonMode`, `ApplicationMenu`, `OnApplicationButtonClick`, `MenuButtonCaption`, `MenuButtonDropdownMenu`, `MenuButtonStyle`, `ShowMenuButton` and `OnMenuButtonClick`.
- Migrates package demos, tools and design resources to stream and use `ApplicationButton.*`.
- Updates the consistency audit to reject legacy Application/Menu Button streaming in `TLazRibbon` resources.
- Updates runtime and design-time package versions to 1.2.14.

## 1.2.13 - TLazRibbon Appearance alias removal

- Removes the published `TLazRibbon.Appearance` legacy alias from the runtime component API.
- Keeps `TLazRibbon.RibbonAppearance` as the only public Object Inspector property for Ribbon visual styling.
- Keeps `TLazRibbonSkinManager.Appearance` unchanged, because the skin manager owns and streams a skin appearance model.
- Updates runtime and design-time package versions to 1.2.13.

## 1.2.12 - SkinManager LFM streaming fix

- Restores `TLazRibbonSkinManager.Appearance.*` streaming in the standalone Skin Editor and `demos/ribbon_form`, fixing the 1.2.11 `Unknown property: "RibbonAppearance"` load error.
- Keeps `TLazRibbon.RibbonAppearance.*` streaming for actual Ribbon controls.
- Tightens the project consistency audit so it rejects `RibbonAppearance.*` on non-`TLazRibbon` resources and legacy `Appearance.*` on `TLazRibbon`.
- Updates runtime and design-time package versions to 1.2.12.

## 1.2.11 - LFM RibbonAppearance migration

- Migrates the package's own Lazarus form resources from the legacy `Appearance.*` streaming name to `RibbonAppearance.*`.
- Updates demos, the standalone Skin Editor and the design-time Appearance editor form resource so project examples exercise the Office-like property name.
- Adds a project consistency audit that rejects new `.lfm` files containing legacy `Appearance.*` TLazRibbon streaming lines.
- Updates runtime and design-time package versions to 1.2.11.

## 1.2.10 - Compact Skin Editor layout

- Reduces the standalone `LazRibbonSkinEditor` initial window size from 1180x820 to 1060x700.
- Tightens the Identity, Ribbon Colors, BackStage, Validation and Advanced editor layouts so controls sit closer together without changing the live Ribbon preview height.
- Keeps pane captions and Dialog Launcher validation visible in the Skin Editor preview while using a smaller editor surface.
- Updates runtime and design-time package versions to 1.2.10.

## 1.2.9 - RibbonAppearance design-time API

- Adds `TLazRibbon.RibbonAppearance` as the official published Object Inspector property for the Ribbon visual model.
- Keeps `TLazRibbon.Appearance` as a legacy alias for older `.lfm` files, but hides it from the Lazarus designer and prevents new forms from streaming the old name.
- Registers the full visual appearance editor on `RibbonAppearance`.
- Updates runtime and design-time package versions to 1.2.9.

## 1.2.8 - Design-time pane refresh fix

- Improves design-time refresh for `TLazRibbonTab`, `TLazRibbonPane` and Ribbon items when captions, structure or Appearance values are edited in the Lazarus IDE.
- Registers a Ribbon-aware `Caption` property editor for tabs, panes, buttons and extended Ribbon items so Object Inspector changes force the parent Ribbon to repaint.
- Updates the contents editor to call `ForceRepaint` after adding, removing, moving or renaming tabs, panes and items.
- Notifies the parent Ribbon after tabs and panes finish loading in design-time mode, so pane captions and Dialog Launchers appear when a form is opened in the designer.
- Changes the release ZIP default output folder to `D:\Ribbon4Lazarus`.
- Updates runtime and design-time package versions to 1.2.8.

## 1.2.7 - Pane caption buffer height fix

- Fixes the remaining Skin Editor live preview case where pane captions were still clipped when the Ribbon control was taller than the calculated default toolbar height.
- Sizes the Ribbon back buffer to the actual control height when it is larger than `CalcToolbarHeight`, so pane layout and painting use the same vertical range.
- Clips active tab contents explicitly before drawing panes, preventing tab-header clipping state from leaking into pane rendering.
- Keeps the direct pane caption drawing and canvas-drawn Dialog Launcher glyph from 1.2.6/1.2.5.
- Updates runtime and design-time package versions to 1.2.7.

## 1.2.6 - Pane caption text rendering fix

- Replaces the pane caption `Canvas.TextRect` rendering path with the package's direct fit-width text routine.
- Keeps pane captions vertically centered inside the caption band while avoiding widgetset-dependent `TTextStyle.Layout` behavior.
- Fixes the Skin Editor live Ribbon preview case where pane captions were assigned but not painted.
- Updates runtime and design-time package versions to 1.2.6.

## 1.2.5 - Skin Editor pane preview height and launcher fix

- Increases and synchronizes the Skin Editor live Ribbon preview height so pane captions and the Dialog Launcher are not clipped.
- Enables `ShowDialogLauncher` on the Skin Editor `Estilos` pane and routes it to the complete Appearance editor on the Pane section.
- Replaces the font-dependent Dialog Launcher glyph with canvas-drawn Office-style lines.
- Keeps `TLazRibbon.Appearance` as the active low-level visual model used by internal styles and `TLazRibbonSkinManager` in this version; the later 1.2.9 build exposes the public Ribbon property as `RibbonAppearance`.
- Updates runtime and design-time package versions to 1.2.5.

## 1.2.4 - Pane captions paint order fix

- Fixes `TLazRibbonPane` drawing so pane captions are rendered above pane items.
- Centers pane captions inside the caption band and clips them with ellipsis when space is tight.
- Keeps the Dialog Launcher visible on top of the caption band.
- Fixes the Skin Editor live Ribbon preview when pane captions were not visible.
- Updates runtime and design-time package versions to 1.2.4.

## 1.2.3 - Skin Editor Appearance differences filter

- Marks Appearance inspector rows that differ from the focused base skin with `[alterado]`.
- Shows the corresponding base value inline for changed Appearance properties.
- Adds `Somente diferentes da base` to the Skin Editor complete Appearance inspector.
- Keeps the per-property restore workflow from 1.2.2 and the validation/comparison report from 1.2.1.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.3.

## 1.2.2 - Skin Editor restore Appearance property from base

- Adds `Restaurar da base` to the Skin Editor complete Appearance inspector.
- The action copies the selected published `Appearance` property from the focused base skin into the current skin.
- Supports colors, numbers, enums, booleans, sets, strings, characters and fonts through the same RTTI model used by the inspector.
- Refreshes the live preview, Appearance inspector and validation/comparison report after restoring or editing an Appearance property.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.2.

## 1.2.1 - Skin Editor base comparison report

- Extends the `LazRibbonSkinEditor` validation report with a comparison against the focused base skin.
- The comparison reports changes in identity metadata, icon file/data state, palette colors and published `Appearance` properties.
- Limits detailed difference output so heavily changed skins remain readable while still showing the full difference count.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.1.

## 1.2.0 - Skin Editor validation report

- Adds a validation report to the standalone `LazRibbonSkinEditor`.
- The report audits skin identity, optional metadata, icon file/data state, Appearance editing mode and key contrast pairs before saving.
- Adds design-time visible validation controls to the Skin Editor `.lfm` instead of creating them only at run time.
- Keeps runtime Ribbon UI behavior unchanged.
- Updates runtime and design-time package versions to 1.2.0.

## 1.1.78 - Unified component palette icons

- Replaces the visible LazRibbon component palette icons with a unified Office-like visual family.
- Adds 24 px, 36 px and 48 px PNG variants for the palette components so Lazarus can use sharper icons at normal, 150% and 200% scales.
- Regenerates the component `.lrs` resources with `ClassName`, `ClassName_150` and `ClassName_200` entries.
- Updates `source/design/icons/make_res.bat` so future icon resource regeneration follows the current Lazarus high-DPI pattern.
- Keeps runtime UI behavior unchanged.
- Updates runtime and design-time package versions to 1.1.78.

## 1.1.77 - Office-like tab spacing controls

- Adds `TLazRibbon.TabCaptionHorizontalPadding`, `TabCaptionSpacing` and `MinTabCaptionWidth` so developers can tune Ribbon tab geometry from the Object Inspector.
- Changes the default tab caption metrics to a more Office-like layout: 10 px horizontal padding, 2 px spacing between tabs and 40 px minimum caption width.
- Applies the same metrics to contextual-tab header width calculations so contextual groups continue to size coherently.
- Keeps skin color/font behavior unchanged; tab geometry is now controlled by the new Ribbon properties rather than by skin selection.
- Updates runtime and design-time package versions to 1.1.77.

## 1.1.76 - Office-style Dialog Launcher rename

- Renames the `TLazRibbonPane` More Options API to Office-style Dialog Launcher naming: `ShowDialogLauncher`, `DialogLauncherStyle` and `OnDialogLauncherClick`.
- Renames the related runtime types and constants to `TLazRibbonDialogLauncherState`, `TLazRibbonDialogLauncherStyle` and `PaneDialogLauncherWidth`.
- Changes the default `DialogLauncherStyle` to `dlsArrow`, matching the Office Dialog Box Launcher glyph.
- Updates the active demos to use the new property, event and enum names.
- Intentionally removes the old More Options names; this build is not source-compatible with the earlier unfinished API.
- Updates runtime and design-time package versions to 1.1.76.

## 1.1.75 - Skin Editor Appearance inspector pass

- Expands the standalone `LazRibbonSkinEditor` Appearance inspector with an all-sections view for Tab, MenuButton, Pane, Element and Popup.
- Adds a filter box so Skin Editor users can search published Appearance properties by section, property name, type or current value.
- Shows the RTTI type beside each listed Appearance property.
- Extends direct property editing to cover floats, strings, characters and sets in addition to the existing colors, fonts, integers, booleans and enums.
- Keeps runtime UI behavior unchanged.
- Updates runtime and design-time package versions to 1.1.75.

## 1.1.74 - GitHub readiness pass

- Adds `CONTRIBUTING.md` with Lazarus 4.8 setup, change discipline and release hygiene expectations.
- Adds `docs/quality/VALIDATION_LAZARUS_4_8.md` as the active public validation checklist.
- Adds `docs/release/GITHUB_PUBLISHING.md` with repository, release-note and screenshot guidance.
- Adds `.github` issue and pull-request templates for public collaboration.
- Adds `docs/assets/screenshots/README.md` as the placeholder and guidance folder for public screenshots.
- Keeps runtime UI behavior unchanged.
- Updates runtime and design-time package versions to 1.1.74.

## 1.1.73 - Lazarus 4.8 validation baseline

- Moves the active documentation and validation baseline from Lazarus 4.6 to Lazarus 4.8.
- Keeps Lazarus 4.6 references in older historical release notes, but updates README, INSTALL, STATUS and the 1.1 roadmap to use Lazarus 4.8 as the current target.
- Preserves runtime UI behavior from 1.1.70 and the release-hygiene/palette-icon work from 1.1.72.
- Updates runtime and design-time package versions to 1.1.73.

## 1.1.72 - Release hygiene and palette icons pass

- Fixes `tools/check_project_consistency.ps1` so demo `.lpi` files are filtered correctly and `GraphicApplication Value="True"` is read from the XML attribute.
- Normalizes source-audit reporting for generated directories, generated files and local-environment path checks.
- Adds missing Lazarus palette icon resources for `TLazRibbonPopupMenu`, `TLazRibbonSkinManager` and `TLazRibbonSkinSelector`.
- Keeps runtime UI behavior unchanged; this release focuses on distribution quality and design-time polish.
- Updates runtime and design-time package versions to 1.1.72.

## 1.1.71 - Stability and regression audit pass

- Adds `tools/check_project_consistency.ps1` to audit package versions, GUI demo configuration, local-environment paths and generated artifacts before release packaging.
- Updates `tools/build_release_zip.ps1` so the consistency audit runs before the ZIP is created.
- Adds `docs/quality/STABILITY_REGRESSION_PASS_1_1_71.md` as the current stabilization checklist for packages, showcase runtime, KeyTips, contextual tabs, BackStage, skins and design-time verbs.
- Does not change runtime UI behavior; the 1.1.70 Backspace, resize, minimize/restore, contextual-tab and KeyTips behavior is preserved.
- Updates runtime and design-time package versions to 1.1.71.

## 1.1.70 - TLazRibbonForm KeyTips Backspace capture fix

- Adds a public `TLazRibbon.ProcessKeyTipsBackspace` wrapper so host controls can route Backspace into the KeyTip prefix editor safely.
- Makes `TLazRibbonForm` handle `VK_BACK` in `KeyDown` and `#8` in `KeyPress` while KeyTips are visible, because the focused client control can consume Backspace before `TLazRibbon` receives it.
- Enables `KeyPreview` at run time for `TLazRibbonForm` when it uses the custom title bar and has an associated Ribbon, so Backspace reaches the form-level KeyTips handler.
- Leaves the staged/multi-character KeyTips model, resize/minimize behavior, contextual tabs and design-time verbs unchanged.
- Updates runtime and design-time package versions to 1.1.70.

## 1.1.69 - KeyTips Backspace delivery hotfix

- Adds a shared `HandleKeyTipsBackspace` runtime helper so Backspace behavior is consistent across `KeyDown` and `KeyPress`.
- Handles `#8` in `KeyPress` for Lazarus/LCL widgetsets that deliver Backspace as a character event rather than only as `VK_BACK`.
- Keeps the staged, multi-character KeyTips model introduced in 1.1.66 and refined in 1.1.68.
- Updates runtime and design-time package versions to 1.1.69.

## 1.1.68 - KeyTips mouse cancellation and prefix backspace refinement

- Closes the KeyTips overlay on any mouse click inside `TLazRibbon` before the normal click action is processed.
- Closes the KeyTips overlay when the user clicks the `TLazRibbonForm` custom title bar, title-bar QAT or system buttons.
- Adds `Backspace` support while typing multi-character KeyTips, allowing the user to remove the last typed prefix character without leaving the KeyTips session.
- Keeps the 1.1.66 multi-character KeyTips and the 1.1.67 design-time validator hotfix unchanged.
- Updates runtime and design-time package versions to 1.1.68.

## 1.1.67 - Design-time System.Copy qualification hotfix

- Fixes LazRibbonDesign compilation under Lazarus/FPC where unqualified `Copy` inside `LazRibbon_Editor.pas` resolved to `TComponentEditor.Copy` instead of the string-copy routine.
- Qualifies the two prefix-ambiguity checks as `System.Copy(...)`.
- Keeps the 1.1.66 multi-character KeyTips runtime behavior unchanged.
- Updates runtime and design-time package versions to 1.1.67.

## 1.1.66 - Multi-character KeyTips support

- Adds incremental KeyTips prefix handling for root-level and command-level overlays.
- Supports multi-character KeyTips such as `EX`, `PR`, `RV` and `HP`, closer to the Office Ribbon model.
- Redraws matching KeyTips with the already typed prefix removed, so after typing `E` a command key `EX` is shown as `X`.
- Updates the design-time `Validate KeyTips` verb to report prefix ambiguities such as `B` versus `BA` inside the same overlay scope.
- Updates the showcase demo with multi-character command KeyTips.
- Updates runtime and design-time package versions to 1.1.66.

## 1.1.65 - KeyTips hide before command execution

- Refines the staged KeyTips flow so command-level KeyTips are closed before executing a command selected by KeyTip.
- This matches the Office behavior more closely: choosing a tab KeyTip is navigation and advances to the command stage, but choosing a command KeyTip ends the current KeyTip session.
- Prevents command KeyTips from remaining visible while a command handler, modal dialog or dropdown action runs.
- Keeps the 1.1.64 root-overlay/command-overlay split unchanged.
- Updates runtime and design-time package versions to 1.1.65.

## 1.1.64 - Staged Office-like KeyTips navigation

- Changes runtime KeyTips to a staged Office-like model: pressing Alt first shows only the root overlay (Application Button, visible tabs and QAT).
- Pressing a tab KeyTip selects that tab and advances the overlay to the selected tab's command KeyTips, instead of showing all command KeyTips immediately.
- QAT KeyTips hosted in `TLazRibbonForm` title bar now appear only in the root overlay, not during the active-tab command stage.
- Pressing Esc from the command stage returns to the root overlay; pressing Esc again hides KeyTips.
- Updates the design-time `Validate KeyTips` verb so command KeyTips are checked per tab as second-stage scopes, not against root-level QAT/tab/Application KeyTips.
- Updates runtime and design-time package versions to 1.1.64.

## 1.1.63 - Design-time KeyTip validation verb

- Adds a new `TLazRibbon` component-editor verb, `Validate KeyTips`, for design-time auditing in the Lazarus IDE.
- The validator checks visible Application Button, tabs, QAT entries and visible commands inside each tab for duplicated or missing KeyTips in the currently supported overlay model.
- QAT entries without explicit KeyTips are validated using the same numeric fallback convention (`1`, `2`, `3`, ...) used by the title-bar QAT overlay.
- Keeps runtime behavior unchanged: no changes to `TLazRibbonForm`, resize/minimize, contextual tabs, QAT painting or KeyTip execution.
- Updates runtime and design-time package versions to 1.1.63.

## 1.1.62 - Design-time starter layout BaseItem dependency hotfix

- Fixes the Lazarus design package compilation error in `LazRibbon_Editor.pas` by importing `LazRibbon_BaseItem`, where `TLazRibbonBaseItem` is declared.
- Keeps the `Add starter Ribbon layout` verb and all runtime behavior unchanged.
- Updates runtime and design-time package versions to 1.1.62.

## 1.1.61 - Design-time starter Ribbon layout verb

- Adds a third `TLazRibbon` component-editor scaffold action: `Add starter Ribbon layout`.
- The new verb creates a more complete Office-like starter structure with Application Button, title-bar QAT, Home/Insert/View tabs, a contextual Image tab, panes, commands, KeyTips and ScreenTips.
- QAT starter entries are linked to the generated `Novo`, `Abrir` and `Salvar` commands and receive numeric KeyTips `1`, `2`, `3`.
- Keeps runtime behavior unchanged: no changes to `TLazRibbonForm`, custom resize/minimize, contextual-tab rendering, KeyTips execution or demo projects.
- Updates runtime and design-time package versions to 1.1.61.

## 1.1.60 - GUI demo subsystem and custom minimize restoration pass

- Sets all demo projects to Windows GUI application mode (`GraphicApplication=True`) so running demos from Lazarus/Windows does not create an extra console/DOS window.
- Changes the custom title-bar minimize button to post the native Windows `SC_MINIMIZE` system command instead of only assigning `WindowState := wsMinimized`. This keeps minimize/restore on the normal Windows taskbar path for `TLazRibbonForm`.
- Keeps the 1.1.54 custom-chrome resize strategy and the 1.1.57 KeyTips fix unchanged.
- Updates runtime and design-time package versions to 1.1.60.

## 1.1.59 - Design-time Designer.Modified hotfix

- Fixes Lazarus design-time package compilation by replacing the invalid local `IDesigner` declaration in `TLazRibbonEditor.MarkDesignerModified` with the existing `TComponentEditor.Designer` property.
- Keeps the 1.1.58 quick creation verbs unchanged.
- Updates runtime and design-time package versions to 1.1.59.

## 1.1.58 - Design-time quick creation verbs

- Adds two `TLazRibbon` component-editor verbs in the Lazarus IDE: `Add basic tab` and `Add contextual tab`.
- `Add basic tab` creates a starter tab with one pane, one large command and one small command, including default KeyTips and ScreenTip metadata.
- `Add contextual tab` creates a contextual tab with group caption, contextual color, one pane and a starter contextual command.
- Keeps runtime behavior unchanged: no changes to `TLazRibbonForm` resize handling, contextual-tab drawing, KeyTips execution or BackStage.
- Updates runtime and design-time package versions to 1.1.58.

## 1.1.57 - Title-bar QAT KeyTips duplicate overlay fix

- Fixes duplicate/overlapped QAT KeyTips when `QuickAccessToolBar.Position = qapTitleBar`.
- `TLazRibbon` no longer draws QAT KeyTips for title-bar-hosted QAT items; those are drawn exclusively by `TLazRibbonTitleBar`.
- Adds a defensive valid-rectangle check before drawing Ribbon-hosted QAT KeyTips.
- Keeps the 1.1.54 `TLazRibbonForm` resize strategy and the 1.1.56 multi-contextual-group showcase behavior unchanged.
- Updates runtime and design-time package versions to 1.1.57.

## 1.1.56 - Multiple contextual groups sanity pass

- Updates the showcase demo to exercise two independent contextual tab groups: `Ferramentas de Imagem` and `Ferramentas de Tabela`.
- Adds a small layout gap between adjacent visible contextual groups so two groups do not visually merge into a single band.
- Updates the showcase workflow with `Selecionar imagem`, `Selecionar tabela` and `Limpar contexto` buttons for manual contextual-tab regression testing.
- Keeps the `TLazRibbonForm` custom-chrome resize strategy from 1.1.54 unchanged.
- Updates runtime and design-time package versions to 1.1.56.

## 1.1.55 - Contextual tabs visual refinement

- Refines contextual group header styling to be lighter and less boxy, closer to the visual behavior of modern Office contextual tabs.
- Removes the heavy framed-label look from contextual headers and replaces it with a pale contextual band, subtle accent lines, centered clipped text and softer typography.
- Softens contextual tab borders, fills and accent bars so contextual tabs do not look visually heavier than normal Ribbon tabs.
- Keeps the 1.1.54 `TLazRibbonForm` resize strategy unchanged because it restored reliable window resizing.
- Updates runtime and design-time package versions to 1.1.55.

## 1.1.54 - Custom chrome resize strategy correction

- Changes `TLazRibbonForm` custom chrome on Windows so it no longer depends on a pure `BorderStyle = bsNone` top-level window for sizeable forms.
- Keeps the original LCL border policy (`bsSizeable`/`bsSizeToolWin`) and removes only the native Windows caption style, preserving a real sizing frame while the LazRibbon client title bar paints the visible chrome.
- Keeps `WM_NCHITTEST` support for the custom title bar/top edge.
- Makes `demos/showcase` explicitly `BorderStyle = bsSizeable` to validate resize behavior.
- Updates runtime and design-time package versions to 1.1.54.
