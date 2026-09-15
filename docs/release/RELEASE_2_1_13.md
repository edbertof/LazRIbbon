# LazRibbon 2.1.13 Release Notes

## Summary

`2.1.13` adds a professional-readiness gate to the post-2.0 line. The package
already had API audits, Object Inspector reports, demos, screenshots and release
scripts; this release connects those pieces into one generated adoption report
so the project can be judged as a public Lazarus package instead of only as a
set of compiling units.

The package metadata is set to `2.1.13`. The public ZIP/tag/release label is
also `2.1.13`.

## What Changed

- Added `tools/export_professional_readiness_2_1.ps1`.
- Added `docs/quality/PROFESSIONAL_READINESS_2_1.md`.
- Added `SUPPORT.md` and `SECURITY.md` for public support and vulnerability
  reporting guidance.
- Extended `tools/check_project_consistency.ps1` so the professional-readiness
  report is regenerated and compared during the normal audit.
- Updated README, status, roadmap and acceleration audit documentation to treat
  professional package readiness as an explicit 2.1 gate.
- Regenerated release readiness documentation for the `2.1.13` package version.

## Professional Readiness Checks

The generated report checks these adoption surfaces together:

- repository trust files: README, license, changelog and status;
- GitHub issue and pull-request templates;
- installation and first-use onboarding;
- Markdown and DOCX manuals;
- public screenshots;
- API freeze and Object Inspector governance reports;
- Skin Editor workflow and Appearance coverage;
- demo coverage and demo validation matrix;
- release automation and clean-checkout validation scripts.

## Compatibility

No new published component API was added. Existing 2.0 forms, skin files and
component composition rules remain unchanged.

## Validation

Before publishing:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.13 -ReleaseVersion 2.1.13 -OutputDirectory D:\Ribbon4Lazarus\Releases
```

This command should run the consistency audit, full package/tool/demo build
matrix, clean-checkout validation and release ZIP hygiene checks.

## Publishing Note

Publish `2.1.13` only if the full preflight passes, the generated ZIP hash is
recorded in `docs/release/RELEASE_ZIP_AUDIT.md`, and the tag points to the same
commit as the source used to create the ZIP.
