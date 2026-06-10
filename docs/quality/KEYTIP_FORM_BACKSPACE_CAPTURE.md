# KeyTips form-level Backspace capture — 1.1.70

`TLazRibbon` already handled `VK_BACK` and `#8`, but real applications often keep keyboard focus in a client control below the Ribbon. In that case Backspace can be consumed by the focused control before the Ribbon sees it.

Version 1.1.70 adds a public `TLazRibbon.ProcessKeyTipsBackspace` wrapper and routes Backspace from `TLazRibbonForm.KeyDown`/`KeyPress` while KeyTips are visible. `TLazRibbonForm` also enables `KeyPreview` at run time when a Ribbon is assigned and the custom title bar is active.

Expected test:

```text
Alt
T
E
Backspace
E
X
```

After `E`, the overlay should show only `X`. After Backspace, it should return to the full command choices such as `EX` and `PR`.
