# LazRibbon 2.1.14 Release Notes

`2.1.14` adds a generated component API governance gate to the post-2.0 line.
The release does not add new published component API; it makes the existing
Object Inspector surface easier to maintain by documenting how every
package-facing component should fit into the LazRibbon composition model.

The package metadata is set to `2.1.14`. The public ZIP/tag/release label is
also `2.1.14`.

## What Changed

- Added `tools/export_component_api_governance_2_1.ps1`.
- Added `docs/quality/COMPONENT_API_GOVERNANCE_2_1.md`.
- Mapped the main component roles: form shell, Ribbon root, Application Button,
  Quick Access Toolbar, tabs, panes, Ribbon items, BackStage and skin system.
- Checked the canonical connection/configuration properties for the governed
  components.
- Checked that compatibility-only or role-inappropriate properties remain out
  of the effective Object Inspector surface.
- Extended `tools/check_project_consistency.ps1` so the component API
  governance report is regenerated and compared during the normal audit.
- Extended the professional-readiness report so component API governance is part
  of the package adoption gate.
- Updated README, status, roadmap, manuals and release documentation for the
  `2.1.14` package line.

## Component API Governance Checks

The new generated report confirms:

- 24 components are inventoried from the effective Object Inspector snapshot.
- 306 effective Object Inspector properties are inventoried.
- 23 governed component roles are mapped.
- 111 canonical component property checks are ready.
- 0 forbidden visible compatibility properties are present.
- 0 unexpected `Appearance` owners are present.
- 0 legacy `SelectedSkin` properties are visible.
- 0 governance gates need review.

## Validation Command

Run the release candidate preflight from the source root:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.14 -ReleaseVersion 2.1.14 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

Publish `2.1.14` only if the full preflight passes, the generated ZIP hash is
recorded in `docs/release/RELEASE_ZIP_AUDIT.md`, and the GitHub tag points to
the validated commit.
