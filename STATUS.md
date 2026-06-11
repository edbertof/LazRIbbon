# LazRibbon Status

`1.2.2 - Skin Editor restore Appearance property from base` is the current stabilization build.


The 1.2.2 build adds `Restaurar da base` to the standalone Skin Editor complete Appearance inspector. A user can select a published `Appearance` property and copy its value from the focused base skin into the current skin, then immediately see the live preview and validation/comparison report update. Runtime Ribbon UI behavior is unchanged.

The 1.2.1 build extended the standalone `LazRibbonSkinEditor` validation report with a comparison against the focused base skin. It reports changes in identity metadata, icon file/data state, palette colors and the published `Appearance` model, helping users understand what a custom skin changed before saving.

The 1.2.0 build began the Skin Editor polish line with a validation report that audits skin identity, optional metadata, icon file/data state, Appearance editing mode and key text contrast pairs before saving.

The 1.1.78 build replaced the visible LazRibbon component palette icons with a unified Office-like family and added 24 px, 36 px and 48 px resources for sharper normal, 150% and 200% Lazarus UI scales.

The 1.1.77 build adds explicit `TLazRibbon` tab geometry controls: `TabCaptionHorizontalPadding`, `TabCaptionSpacing` and `MinTabCaptionWidth`. The defaults are now more Office-like, so tabs no longer appear visually squeezed together, and developers can tune this directly in the Object Inspector. Skin changes still control colors, fonts and gradients; these tab metrics are Ribbon layout properties.

The 1.1.76 build intentionally renamed the unfinished `TLazRibbonPane` More Options API to the Office-style Dialog Launcher terminology. Use `ShowDialogLauncher`, `DialogLauncherStyle` and `OnDialogLauncherClick`; the default style is now `dlsArrow`, matching the classic Office Dialog Box Launcher glyph. This is a deliberate breaking change because the package is still pre-adoption in this project.

The 1.1.75 build expanded the standalone Skin Editor Appearance inspector. It can browse all published `Appearance` sections together, filter properties by section/name/type/value, show property types in the list and edit additional RTTI-supported value kinds. It preserves the 1.1.73 Lazarus 4.8 baseline, the 1.1.74 public-repository documentation, and the formal regression checklist around the behavior stabilized in 1.1.70.
The main runtime behavior remains the staged KeyTips flow, with multi-character KeyTips. The 1.1.70 build keeps the mouse-cancel behavior and fixes Backspace routing when a `TLazRibbonForm` contains focused client controls:

- Alt now opens a root-level overlay with Application Button, visible tabs and QAT only;
- choosing a tab KeyTip selects that tab and changes the overlay to show the commands of the selected tab;
- command KeyTips are no longer shown immediately with the tab/QAT root overlay;
- title-bar QAT KeyTips are hidden during the command stage;
- Esc from the command stage returns to the root overlay, and Esc again hides KeyTips.

The design-time `Validate KeyTips` verb was adjusted to this staged model: root-level KeyTips and per-tab command KeyTips are now validated as separate scopes.

The 1.1.54 resize strategy, 1.1.57 title-bar QAT overlay fix, 1.1.60 GUI/minimize fix, contextual tabs and design-time creation verbs are preserved.

The 1.1.70 build specifically moves Backspace capture to `TLazRibbonForm` as well as `TLazRibbon`, because in real applications focused client controls can consume Backspace before the Ribbon receives it. It does not change the resize/minimize strategy, contextual tabs, design-time creation verbs or design-time KeyTip validation rules.
