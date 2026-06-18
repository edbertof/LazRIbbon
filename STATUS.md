# LazRibbon Status

`1.2.28 - BackStage page composition cleanup` is the current stabilization build.

The 1.2.28 build continues the component-composition cleanup for the 2.0 API freeze. `TLazRibbonBackstagePage` is treated as a BackStage content container at design time, while `TLazRibbonBackstageView.Buttons` is the public model for navigation entries, commands and separators. Page-level command/navigation properties such as `Action`, `Command`, `CloseBackstageOnClick`, `ItemKind` and `OnExecute` are hidden from the Object Inspector and protected by the consistency audit.

The 1.2.27 build starts the component-composition cleanup pass for the 2.0 API freeze. It adds `docs/quality/COMPONENT_COMPOSITION_MODEL_2_0.md`, keeps `TLazRibbon.BackstageView` as the canonical published BackStage link, removes `ApplicationButton.BackstageView` from the Object Inspector surface, and hides inherited command/ScreenTip properties from `TLazRibbonSeparator` at design time.

The 1.2.26 build completes the BackStage appearance-source cleanup from the 2.0 audit. `TLazRibbonBackstageView` and `TLazRibbonBackstageRecentList` now use `AppearanceSource` as the single published decision for internal, linked-toolbar or SkinManager visuals; the duplicated `UseToolbarAppearance` and `UseSkinManager` switches were removed from package API/resources.

The 1.2.25 build completes the skin identity icon cleanup from the 2.0 audit. `TLazRibbonSkinDefinition` now keeps `Icon16Data`, `Icon24Data` and `Icon32Data` as the canonical published icon fields; file-name fields remain public for import/source compatibility, and new `.skin` XML writes file-name tags only when embedded data is absent.

The 1.2.24 build completes the skin selection naming cleanup from the 2.0 audit. `TLazRibbonSkinGalleryItem` and `TLazRibbonSkinSelector` now expose `SelectedSkinName` as the canonical Object Inspector property, while `SelectedSkin` remains as a public built-in-skin convenience and legacy `.lfm` reader.

The 1.2.23 build completes the gallery size naming cleanup from the 2.0 audit. Generic `TLazRibbonGalleryItem` controls now expose `ItemWidth` and `ItemHeight` as the cell-size API, while `TLazRibbonSkinGalleryItem` exposes `IconWidth` and `IconHeight` for skin swatches and keeps legacy readers for old resources.

The 1.2.22 build completes the BackStage back-button naming cleanup from the 2.0 audit. `TLazRibbonBackstageView.BackButtonVisible` is now the single published Office-like property for the BackStage return button, and the consistency audit rejects the older `ShowCloseButton` name in package sources and resources.

The 1.2.21 build completes the first public API cleanup from the 2.0 audit. The Ribbon minimize button and hints now use the Office-like `ShowMinimizeRibbonButton`, `MinimizeRibbonHint` and `RestoreRibbonHint` names, and the consistency audit rejects the older collapse/expand names in package sources and resources.

The 1.2.20 build starts the formal 2.0 API-freeze pass. It adds `docs/quality/PUBLIC_API_AUDIT_2_0.md` and `docs/release/ROADMAP_2_0.md`, identifying stable API candidates and the next cleanup targets before `2.0.0`, including Office-like Ribbon minimize naming and BackStage back/close button consolidation.

The 1.2.19 build improves the standalone Skin Editor workflow when creating a new skin from a base or opening an external skin file. The editor now compares the stored `Appearance` with the model derived from the simple palette, so palette-derived skins remain palette-driven while skins with real detailed Appearance changes continue to preserve those changes.

The 1.2.18 build completes the Ribbon minimize fix inside the standalone Skin Editor. The live preview toolbar now uses `Align = alTop` and synchronizes `pnlLivePreview` when `RibbonMinimized` changes, so the preview panel no longer keeps the expanded empty area after panes are hidden.

The 1.2.17 build fixes the right-side collapse/expand button so `RibbonMinimized` changes the actual `TLazRibbon` height. The minimized state now occupies only the tab strip/QAT area, while expanding restores the prior taller preview height when one was in use.

The 1.2.16 build changes `TLazRibbonBackstageView.OverlayMode` to default to `bomCoverClientArea`, so a BackStage opened from a linked Ribbon follows the newer Office-style full client-area behavior by default. Applications that want the older tab-preserving layout can still set `OverlayMode := bomCoverRibbonArea` explicitly.

The 1.2.15 build consolidates the SkinManager color API into grouped palette objects. New projects should use `General.*`, `Accent.*`, `Backstage.*`, `RecentList.*` and `Ribbon.*` for palette colors, while `TLazRibbonSkinManager.Appearance` remains the complete skin appearance model. The published flat SkinManager palette aliases were removed as part of the pre-2.0 API cleanup.

The 1.2.14 build consolidates the Office Application Button API on `TLazRibbon.ApplicationButton.*`. New projects should use `ApplicationButton.Caption`, `ApplicationButton.Visible`, `ApplicationButton.Mode`, `ApplicationButton.Menu`, `ApplicationButton.Style` and `ApplicationButton.OnClick`; the published flattened Application/Menu Button aliases were removed as part of the pre-2.0 API cleanup.

The 1.2.13 build removes the published `TLazRibbon.Appearance` legacy alias so the Ribbon exposes only the Office-like `RibbonAppearance` styling property in new projects. `TLazRibbonSkinManager.Appearance` remains unchanged because the skin manager owns the skin appearance model and still streams `Appearance.*`.

The 1.2.12 build fixes the over-broad 1.2.11 `.lfm` migration. `TLazRibbon` resources continue to stream the Office-like `RibbonAppearance.*` name, while `TLazRibbonSkinManager` resources correctly stream `Appearance.*`; the consistency audit now checks both sides so the Skin Editor and ribbon form demo keep loading.

The 1.2.11 build continued the path toward the 2.0 API shape by migrating the package's own `.lfm` resources from legacy `Appearance.*` streaming to the Office-like `RibbonAppearance.*` property name.

The 1.2.10 build tightens the standalone `LazRibbonSkinEditor` layout and reduces its default window size to 1060x700. The Identity, Ribbon Colors, BackStage, Validation and Advanced pages use closer control spacing while preserving the 150 px live Ribbon preview height needed to inspect pane captions and Dialog Launchers.

The 1.2.9 build starts the API cleanup around the inherited SpkToolBar visual model. `TLazRibbon.RibbonAppearance` is now the official Object Inspector property for low-level Ribbon colors, fonts and gradients. The old `TLazRibbon.Appearance` name is retained only as a legacy alias for older `.lfm` files, hidden from the designer and not streamed by new forms.

The 1.2.8 build improves Lazarus IDE design-time refresh for Ribbon panes and items. Caption edits made through the Object Inspector or the LazRibbon contents editor now force the parent Ribbon to rebuild and repaint, and tabs/panes notify the Ribbon after design-time loading so pane captions and Dialog Launchers are visible when a form opens in the designer.

The 1.2.7 build fixes the remaining Skin Editor preview case where pane captions were assigned but still clipped. The Ribbon buffer now uses the actual control height when it is taller than the calculated toolbar height, and active tab contents get their own explicit clip before panes are drawn.

The 1.2.5 build fixes the remaining Skin Editor live Ribbon preview clipping case by giving the preview host enough height and synchronizing it after Ribbon metric recalculation. It also enables a real Dialog Launcher on the `Estilos` pane and draws the launcher glyph directly on the canvas instead of relying on font-specific private-use characters. The later 1.2.9 build renamed the public `TLazRibbon` design-time visual property to `RibbonAppearance`.

The 1.2.4 build fixes pane caption rendering in `TLazRibbonPane` so the Skin Editor live Ribbon preview shows group captions reliably. Pane captions are drawn after pane items, centered inside the caption band, clipped with ellipsis when needed, and kept compatible with the Dialog Launcher.

The 1.2.3 build makes the complete Appearance inspector easier to navigate by marking properties that differ from the focused base skin with `[alterado]`, showing the base value inline, and adding `Somente diferentes da base`. Runtime Ribbon UI behavior is unchanged.

The 1.2.2 build added `Restaurar da base` to the standalone Skin Editor complete Appearance inspector. A user can select a published `Appearance` property and copy its value from the focused base skin into the current skin, then immediately see the live preview and validation/comparison report update.

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
