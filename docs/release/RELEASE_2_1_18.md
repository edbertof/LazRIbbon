# LazRibbon 2.1.18 Release Notes

`2.1.18` completes the expected Office-like recent-document workflow in the
BackStage.

## Changes

- `TLazRibbonBackstageRecentList.CloseBackstageOnClick` is now published and
  defaults to `True`.
- Clicking a valid recent item updates `SelectedIndex` and invokes
  `OnItemClick` first, allowing the application to open the selected file.
- After the event returns, the list closes its containing
  `TLazRibbonBackstageView` and restores the main application screen.
- The BackStage lookup follows the control parent hierarchy, so the behavior
  also works when the recent list is hosted inside panels or other page
  containers.
- Set `CloseBackstageOnClick` to `False` when a specialized workflow must keep
  the BackStage visible.

## Validation

The runtime package, design-time package, Skin Editor and all demos are built
with Lazarus 4.8. The release-candidate workflow also validates a clean source
ZIP extraction before publication.

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.18 -ReleaseVersion 2.1.18 -OutputDirectory D:\Ribbon4Lazarus\Releases
```
