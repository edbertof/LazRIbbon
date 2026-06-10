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
