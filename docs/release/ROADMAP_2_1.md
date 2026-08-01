# LazRibbon 2.1 Roadmap

LazRibbon 2.0.0 is the first stable API-freeze release. The 2.1 line should keep that public contract reliable while improving the developer experience around skins, demos, distribution and API clarity.

## Release Goal

Deliver a post-2.0 package that feels easier to adopt and maintain:

- the Skin Editor exposes the full skin model without feeling improvised;
- the Object Inspector property model remains clear and intentional;
- demos show realistic application composition patterns;
- documentation guides new users from install to first usable Ribbon form;
- release validation remains repeatable from a clean checkout and published ZIP.

## Scope

### 1. Skin Editor 2.1

- Keep the native `TLazRibbonToolbarAppearance` property editor as the complete low-level visual editor.
- Treat the standalone Skin Editor as the workflow editor for distributable skins: identity, icons, palette, complete `Appearance`, validation, base comparison and preview.
- Use `docs/quality/SKIN_EDITOR_APPEARANCE_COVERAGE_2_1.md` to track which `Appearance` properties are covered by the native editor, generic RTTI inspector and any dedicated standalone helpers.
- Improve the full `Appearance` inspector around search, grouping, restore-from-base, edited markers and preview feedback.
- Keep controls that define the Skin Editor layout in `.lfm` when they need design-time visibility; use runtime-created controls only for generated lists or dynamic inspectors.
- Add preview states that exercise pane captions, Dialog Launchers, minimized Ribbon, popup/menu button colors and item hot/active/disabled states.
- Keep exported `.skin` files self-contained, with icon image data embedded in XML.

### 2. Component API Clarity

- Keep the 2.0 Object Inspector surface stable unless a real defect requires a compatibility-conscious correction.
- Continue classifying repeated property names through the 2.0 quality reports before adding new published properties.
- Document any new compatibility-only alias immediately and hide it from the Object Inspector when it does not guide new projects.
- Preserve the composition model: `Ribbon -> Tabs -> Panes -> Items`, `Ribbon -> BackstageView`, `SkinManager -> skins`, `TLazRibbonForm -> Office-like shell`.

### 3. Demos And Examples

- Add focused demos that show one concept at a time: CRUD-style screen, editor-style screen, BackStage file workflow, contextual tabs, skin selection and hosted controls.
- Keep the showcase demo as the full integration example.
- Update `docs/release/DEMO_VALIDATION_MATRIX.md` whenever a demo is added or its purpose changes.

### 4. Distribution Polish

- Keep GitHub release notes, README, installation notes and generated manuals synchronized.
- Add repository issue templates for bug reports, feature requests and Lazarus compatibility reports.
- Prepare the package for a later Lazarus Online Package Manager review, including clear license notes and source-only release ZIP hygiene.
- Validate the published ZIP after every public release by downloading it from GitHub and auditing the extracted source tree.

## 2.1 Gates

- `tools/check_project_consistency.ps1 -ExpectedVersion 2.1.4` passes.
- `tools/export_skin_editor_2_1_coverage.ps1` regenerates the Skin Editor coverage report.
- The Skin Editor opens, previews built-in skins and saves a self-contained `.skin` file.
- The main demos compile with Lazarus 4.8.
- The manual and component reference remain correct for any newly exposed behavior.
- No new published Object Inspector property is added without a documented role.
- `docs/quality/LAZRIBBON_2_1_ACCELERATION_AUDIT.md` remains aligned with the
  active Skin Editor, API clarity, demo and distribution work tracks.

## First Work Items

1. Generate the Skin Editor `Appearance` coverage report.
2. Review the standalone Skin Editor layout against that report.
3. Move high-value static workflow controls into `.lfm` when they should be visible at design time.
4. Add richer preview states for panes, elements, popup/menu buttons and minimized Ribbon.
5. Add a compact demo that shows a practical form using Ribbon, BackStage, SkinManager and a normal client area together.

## 2.1.1 Snapshot

The Skin Editor live Ribbon preview now includes disabled commands, checked/toggle buttons, dropdown/button-dropdown samples, checked and disabled checkboxes, and multiple Dialog Launcher panes. These controls remain in `uSkinEditorMain.lfm`, preserving design-time visibility while giving skin authors a more realistic visual test surface.

## 2.1.2 Snapshot

The Skin Editor now presents the normal authoring path directly in the window: choose a base, create a skin from that base, edit identity/colors/BackStage, validate and save. The base selector remains visible below the live Ribbon preview, quick actions are available without opening the File tab, main pages are numbered as workflow steps, and changing the focused base preserves a skin already being edited.

## 2.1.3 Snapshot

The Skin Editor now behaves more like a normal document editor: it tracks unsaved edits, marks the window caption with `*`, shows the edited/saved state in the workflow hint, separates `Salvar` from `Salvar como...`, and asks before a close/open/new operation would discard changes.

## 2.1.4 Snapshot

The SkinManager is now the preferred design-time path for detailed visual styling: `TLazRibbon.RibbonAppearance` is hidden from the Object Inspector, while the `TLazRibbonSkinManager` component editor exposes the complete Appearance editor through `Editar Appearance completo...`. This keeps old forms readable while guiding new projects toward distributable `.skin` files.

## Current Skin Editor Workflow Pass

The standalone Skin Editor Appearance inspector now treats base comparison as an editing workflow, not only a report. A skin author can restore the selected Appearance section, or all sections when `Todas as secoes` is selected, from the focused base skin while preserving the same typed property-copying path used by single-property restore.

The Skin Editor authoring flow keeps file commands in BackStage instead of duplicating them in the top workflow strip. The `Nova skin` dialog now asks for the target `.skin` file up front, suggests a path from the selected base/name and lets `Salvar` behave as the normal document save command immediately after creation.

The main Skin Editor Ribbon now removes the hidden file/export panes from its
visual pane list. The top Ribbon is dedicated to base selection, Appearance
editing and preview samples, while BackStage owns `Nova skin`, `Abrir`,
`Salvar`, `Salvar como...` and export. The new skin dialog also exposes a
destination folder field, so changing the folder recalculates the generated
`.skin` path before the skin is created.

The live Ribbon preview now has a top-level preview mode selector. Skin authors can switch between normal, active-state, disabled-state, minimized Ribbon, open BackStage and dropdown/menu-focused scenarios while editing the same skin, making color and Appearance validation faster.

The dropdown/menu preview mode now has a fixed popup sample on the validation page. It renders normal, hot, checked, disabled, shortcut, divider and gutter states from `Appearance.Popup`, giving skin authors a direct visual check for menu colors without opening a transient system popup.

The BackStage information page now behaves as a document-status panel instead of a static help page. It shows the current skin, target file, comparison base, edit/save state and next workflow step, while the old top-strip file command residue was removed from the form class.

The dedicated BackStage editing step now has design-time controls for all BackStage navigation palette colors and a fixed preview surface. Skin authors can adjust normal, muted, hover, selected and selected-border colors while seeing a representative BackStage navigation sample without opening the real BackStage overlay.

The validation step now separates full audit details from actionable feedback. It keeps the complete memo report, but adds design-time counters for errors, warnings, informational notes and OK checks plus a short action list generated from the current validation findings.

The advanced Appearance inspector now shows a live base-difference summary beside the property list. It counts changed Appearance properties by section and, when a property is selected, shows the current value, base value and whether that property is unchanged or customized.

The 2.1 acceleration audit now consolidates the next high-value work across
Skin Editor workflow, SpkToolBar compatibility cleanup, Object Inspector
clarity, demos and distribution readiness. The repository also has a dedicated
Lazarus compatibility issue template so installation, IDE, widgetset and FPC
reports arrive with actionable environment details.

The release audit now accepts only official LazRibbon source ZIPs in the root delivery folder, using the `LazRibbon_<version>_source_<timestamp>.zip` pattern. This keeps `D:\Ribbon4Lazarus` usable as both the working delivery folder and the place where release packages are stored, while arbitrary ZIP files remain blocked from the source tree. The build cleanup also removes the Skin Editor `.lps` state file so a local Lazarus session does not block a clean source-package audit.

## Initial Coverage Snapshot

The first generated Skin Editor 2.1 coverage report finds 87 published `Appearance` properties across `Tab`, `MenuButton`, `Pane`, `Element` and `Popup`. The native appearance editor mentions all of them, and the standalone Skin Editor has generic RTTI inspector coverage for the full model. The 2.1 work should therefore focus on workflow quality, preview states and high-value direct helpers rather than manually duplicating every property as a standalone control.

## Definition Of Done For 2.1

LazRibbon 2.1 is ready when a developer can install 2.1, open the 2.1 Skin Editor, create a custom skin from a base, understand which visual groups changed, preview the result in realistic Ribbon states, save a self-contained `.skin` file and apply it in a demo without manual file copying or code changes.
