# LazRibbon 2.1 Acceleration Audit

This report keeps the accelerated post-2.0 work organized across the five
tracks that matter for a shared/public package: Skin Editor workflow,
SpkToolBar compatibility cleanup, Object Inspector clarity, demos and
distribution readiness.
The `docs/quality/PROFESSIONAL_READINESS_2_1.md` report turns that broader
package polish into an explicit generated gate.

## Current Direction

LazRibbon should keep reading legacy forms and source code, but new projects
should follow the Office-like composition model:

```text
TLazRibbonForm
  -> TLazRibbon
       -> SkinManager
       -> BackstageView
       -> Tabs -> Panes -> Items
```

Visual styling for new work should be authored through `TLazRibbonSkinManager`
and `.skin` files. `TLazRibbon.RibbonAppearance` remains streaming-compatible
internal rendering state, hidden from the Object Inspector.

## Work Tracks

| Track | Current state | 2.1 rule |
| --- | --- | --- |
| Skin Editor | Workflow covers base selection, identity, icons, palette, BackStage colors, full Appearance inspector, validation and base difference summaries. | Continue moving user-facing workflow controls into clear pages and keep generated/dynamic controls only where lists are inherently runtime data. |
| SpkToolBar inheritance cleanup | Low-level `TLazRibbonToolbarAppearance` still exists as the internal render model and complete editor surface. | Do not expose it as the normal Ribbon design-time path; keep SkinManager as the visible skin authoring surface. |
| Object Inspector clarity | Redundancy and property-skip audits classify repeated or compatibility-only properties. | Any new published property must be classified before release and must fit the composition model. |
| Demos | Showcase plus focused demos cover the main integration points. | Keep Showcase as the full integration smoke test and use focused demos to document one concept at a time. |
| Distribution | Source ZIP audit, clean checkout validation, manuals, screenshots, GitHub docs and professional readiness evidence exist. | Keep GitHub templates, release notes and generated readiness reports aligned with Lazarus/FPC compatibility reports. |

## Skin Editor Workflow Update

The Skin Editor now treats file/project commands as BackStage-owned commands.
The visible Ribbon keeps base selection, Appearance tools and preview samples;
`Nova skin`, `Abrir`, `Salvar`, `Salvar como...` and built-in skin export stay
in the `Arquivo` BackStage surface.

The `Nova skin` dialog now follows a project-style flow: choose the base skin,
define internal/display names, choose the target folder and confirm the exact
`.skin` file that will be created. Selecting a folder updates the suggested
file path, while choosing an explicit file keeps the destination folder
synchronized.

The main Skin Editor window now separates the everyday authoring path from the
technical model. Palette pages, preview modes and validation use workflow
language, while the complete low-level `Appearance` surface remains available
as `Ajuste avancado` for detailed edits.

The base difference summary in `Ajuste avancado` is now navigable: clicking a
changed property selects the matching Appearance property in the inspector, and
double-clicking it opens the property editor.

The Workbench CRUD demo now provides the practical application shell requested
for the 2.1 line. It combines `TLazRibbonForm`, `TLazRibbon`, QAT, BackStage,
recent files, `TLazRibbonSkinManager`, `TLazRibbonSkinGalleryItem`,
`TLazRibbonPopupMenu` and normal LCL CRUD controls in one build target.

The Skin Editor Sample demo now uses valid skin XML metadata. Its distributed
`MeuSkin.lazskin` file writes author data as `<Author>...</Author>`, matching
the loader and avoiding the parser exception previously caused by the malformed
`<Autor>...<Author/>` tag.

The Skin Editor document workflow now resolves unsaved edits before launching
the next `Nova skin` or `Abrir` dialog. Save/open commands share the same
default skin-folder logic, save targets without an extension are normalized to
`.skin`, and the top workflow strip, BackStage status panel and window caption
use the same current-skin, target-file, base and edit-state text helpers.

The validation page now gives skin authors an always-visible visual review
surface beside the audit text. It draws normal Ribbon, minimized Ribbon,
BackStage navigation and contrast swatches from the current skin, and keeps the
Popup/Menu state sample on the same page for menu-specific Appearance checks.

The color page now gives skin authors a palette map while they edit simple
colors. It draws a compact Ribbon sample, command states, BackStage selection
and contrast ratios beside the color controls, keeping the visual feedback in
the same workflow step where the palette is changed.

The validation page now compares the selected base and current skin side by
side. The `Base x skin atual` panel draws representative Ribbon, pane,
command-state, BackStage and contrast samples for each palette and reports how
many palette colors differ from the base before the skin is saved.

The validation action area now behaves as a decision panel. It starts with a
save-readiness status, groups blocking issues separately from warnings worth
reviewing before distribution, and keeps the next normal workflow step visible
without requiring the user to interpret the full audit memo.

The advanced Appearance inspector now gives context for the selected property.
It preserves the selected item across refreshes when possible, disables
edit/reset actions until a valid editable property is selected, and shows the
property section, type, current value, base value and editing path in the
difference/detail panel.

The project now has a generated professional readiness report. It checks the
repository trust files, onboarding documentation, manuals, screenshots, GitHub
templates, API governance reports, Skin Editor workflow coverage, demo matrix
and release automation as one adoption-readiness surface. The main consistency
audit regenerates this report and fails when it drifts from the checked-in
version.

## Safe Cleanup Decisions

- Keep `RibbonAppearance` readable in old `.lfm` files.
- Keep `RibbonAppearance` hidden from the Object Inspector for `TLazRibbon`.
- Keep the complete Appearance editor reachable from `TLazRibbonSkinManager`.
- Prefer `ActiveSkinName` and `SelectedSkinName` over enum-only shortcuts.
- Keep page navigation and BackStage commands in
  `TLazRibbonBackstageView.Buttons`; pages remain content containers.
- Keep `Control` as the public hosted-control reference; legacy control-name
  strings remain compatibility metadata only.

## Next High-Value Increments

1. Regenerate the Object Inspector snapshot after each meaningful API-surface
   change.
2. Keep the manual and component reference synchronized with every new
   design-time workflow.
3. Regenerate `docs/quality/PROFESSIONAL_READINESS_2_1.md` whenever repository
   trust files, demos, manuals, screenshots or release scripts change.
4. Validate every public ZIP from an extracted clean source tree before tagging.

## Release Gate

For a 2.1 stabilization build, these commands must pass from the source root:

```powershell
powershell -ExecutionPolicy Bypass -File tools\check_project_consistency.ps1 -ExpectedVersion 2.1.13
powershell -ExecutionPolicy Bypass -File tools\export_professional_readiness_2_1.ps1 -OutputPath docs\quality\PROFESSIONAL_READINESS_2_1.md
powershell -ExecutionPolicy Bypass -File tools\build_all_projects.ps1 -CleanArtifacts
```
