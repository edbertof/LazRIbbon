# LazRibbon 2.1 Acceleration Audit

This report keeps the accelerated post-2.0 work organized across the five
tracks that matter for a shared/public package: Skin Editor workflow,
SpkToolBar compatibility cleanup, Object Inspector clarity, demos and
distribution readiness.

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
| Distribution | Source ZIP audit, clean checkout validation, manuals, screenshots and GitHub docs exist. | Keep GitHub templates and release notes aligned with Lazarus/FPC compatibility reports. |

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
3. Validate every public ZIP from an extracted clean source tree before tagging.

## Release Gate

For a 2.1 stabilization build, these commands must pass from the source root:

```powershell
powershell -ExecutionPolicy Bypass -File tools\check_project_consistency.ps1 -ExpectedVersion 2.1.5
powershell -ExecutionPolicy Bypass -File tools\build_all_projects.ps1 -CleanArtifacts
```
