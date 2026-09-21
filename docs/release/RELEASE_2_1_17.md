# LazRibbon 2.1.17 Release Notes

`2.1.17` standardizes BackStage navigation icons and lets each page define its
own navigation icon.

## What changed

- `bbkPage` no longer selects `LargeImages` automatically.
- Page and command entries use `BackstageView.Images` and `ImageIndex` by
  default.
- `LargeImageIndex` selects `LargeImages` only when assigned explicitly, for
  either page or command items.
- `TLazRibbonBackstagePage` now publishes `ImageIndex`.
- A page button with `ImageIndex = -1` inherits the linked page's image index.
- An image index defined directly on the button remains the highest priority.

## Compatibility

Existing forms continue to load. A page item that relied on the old implicit
large-image behavior will now use its normal `ImageIndex`, which is the intended
uniform navigation behavior. Applications that deliberately need a large icon
can assign `LargeImageIndex` explicitly.

## Validation

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_release_candidate.ps1 -Version 2.1.17 -ReleaseVersion 2.1.17 -OutputDirectory D:\Ribbon4Lazarus\Releases
```
