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

- `tools/check_project_consistency.ps1 -ExpectedVersion 2.1.0` passes.
- `tools/export_skin_editor_2_1_coverage.ps1` regenerates the Skin Editor coverage report.
- The Skin Editor opens, previews built-in skins and saves a self-contained `.skin` file.
- The main demos compile with Lazarus 4.8.
- The manual and component reference remain correct for any newly exposed behavior.
- No new published Object Inspector property is added without a documented role.

## First Work Items

1. Generate the Skin Editor `Appearance` coverage report.
2. Review the standalone Skin Editor layout against that report.
3. Move high-value static workflow controls into `.lfm` when they should be visible at design time.
4. Add richer preview states for panes, elements, popup/menu buttons and minimized Ribbon.
5. Add a compact demo that shows a practical form using Ribbon, BackStage, SkinManager and a normal client area together.

## Initial Coverage Snapshot

The first generated Skin Editor 2.1 coverage report finds 87 published `Appearance` properties across `Tab`, `MenuButton`, `Pane`, `Element` and `Popup`. The native appearance editor mentions all of them, and the standalone Skin Editor has generic RTTI inspector coverage for the full model. The 2.1 work should therefore focus on workflow quality, preview states and high-value direct helpers rather than manually duplicating every property as a standalone control.

## Definition Of Done For 2.1

LazRibbon 2.1 is ready when a developer can install 2.1, open the 2.1 Skin Editor, create a custom skin from a base, understand which visual groups changed, preview the result in realistic Ribbon states, save a self-contained `.skin` file and apply it in a demo without manual file copying or code changes.
