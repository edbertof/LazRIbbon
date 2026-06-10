# Staged KeyTips navigation

Version 1.1.64 changed the runtime KeyTips overlay to follow the Office-like staged flow. Version 1.1.65 refines command execution so the overlay is closed before a command selected by KeyTip runs.

## Behavior

1. Press Alt.
2. The root overlay appears with Application Button, visible tabs and QAT KeyTips only.
3. Press a tab KeyTip.
4. The tab is selected and the overlay changes to command KeyTips for that tab only.
5. Press a command KeyTip. The overlay closes immediately, then the command executes.
6. Press Esc from the command stage to return to the root overlay. Press Esc again to hide KeyTips.

This avoids the visual clutter of showing root and command KeyTips simultaneously and matches the navigation model expected by users familiar with Microsoft Office.

## 1.1.65 command execution rule

Selecting a tab KeyTip is navigation and keeps KeyTips active by moving to the command stage. Selecting a command KeyTip is terminal: command-level KeyTips must disappear before the command handler, dropdown or modal dialog runs.
