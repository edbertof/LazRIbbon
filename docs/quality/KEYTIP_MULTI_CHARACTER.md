# Multi-character KeyTips

Version 1.1.66 adds incremental KeyTip prefix handling.

Expected behavior:

1. `Alt` opens the root KeyTips overlay.
2. A tab KeyTip opens that tab and switches to the command overlay.
3. A command KeyTip may contain one or more characters.
4. When the typed characters are only a prefix of a longer KeyTip, the overlay remains visible.
5. Matching labels are redrawn with the already typed prefix removed. For example, `EX` is shown as `X` after `E` has been typed.
6. When the full command KeyTip is accepted, the overlay is hidden before the command executes.
7. `Esc` clears the current typed prefix first. A subsequent `Esc` returns to the root overlay or closes KeyTips.

Design-time validation now reports exact collisions and prefix ambiguities inside each overlay scope. Avoid `B` and `BA` in the same command scope.


## 1.1.67 design-time hotfix

The design-time validator now qualifies prefix checks with `System.Copy(...)` to avoid resolving `Copy` to `TComponentEditor.Copy` inside `LazRibbon_Editor.pas`. Runtime KeyTip behavior is unchanged.
