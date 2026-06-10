# KeyTips Backspace delivery hotfix — 1.1.69

This build keeps the staged, Office-like KeyTips model introduced in 1.1.64 and the multi-character KeyTips introduced in 1.1.66.

The refinement is behavioral:

- mouse interaction exits KeyTips mode before the normal click is processed;
- this applies to the main `TLazRibbon` surface and to the `TLazRibbonForm` custom title bar/QAT;
- `Backspace` removes the last typed KeyTip prefix character during a multi-character KeyTip sequence.

The goal is to avoid leaving stale KeyTip overlays visible after the user switches from keyboard navigation back to mouse interaction, while making multi-character KeyTips less rigid during manual testing.
