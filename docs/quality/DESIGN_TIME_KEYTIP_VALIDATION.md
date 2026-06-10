# Design-time KeyTip validation

Version 1.1.63 added a `Validate KeyTips` verb to the `TLazRibbon` component editor. Version 1.1.64 makes the validator stage-aware.

The command is intended as a fast IDE-side audit after using `Add basic tab`, `Add contextual tab`, `Add starter Ribbon layout`, or after manually editing Ribbon commands.

The validator checks:

- Application Button KeyTip when visible;
- visible tab KeyTips;
- visible Quick Access Toolbar items, using explicit `KeyTip` when present or numeric fallback (`1`, `2`, `3`, ...) when empty;
- visible command items inside each visible tab.

It reports:

- duplicated KeyTips in the root overlay scope;
- duplicated KeyTips between root overlay entries and commands in each visible tab;
- duplicated KeyTips among commands in the same visible tab;
- missing KeyTips on visible tabs and visible commands.

This is a design-time validation helper only. It does not change runtime KeyTip drawing or execution.


## 1.1.64 staged validation rule

The runtime KeyTips model is now two-stage. Root-level KeyTips cover the Application Button, tabs and QAT. Command KeyTips are displayed only after a tab KeyTip is chosen. Therefore, the validator treats each tab's command KeyTips as a separate scope and no longer flags a command KeyTip merely because it duplicates a root-level tab or QAT KeyTip.
