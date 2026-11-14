# LazRibbon regression tests

Target: Windows x64, Lazarus 4.8 and its bundled Free Pascal 3.2.2.

Run the complete package/tool/demo build and test sequence from clean source:

```powershell
powershell -ExecutionPolicy Bypass -File tools/verify_clean_checkout.ps1
```

Run the runtime checks independently:

```powershell
powershell -ExecutionPolicy Bypass -File tools/run_runtime_audit_tests.ps1
```

This compiles `runtime_audit.lpr` against the current runtime sources, with
range and integer-overflow checks, and runs geometry, color conversion,
collection lifetime, XML persistence/indexing, skin notifications and form streaming in
separate processes. Build products and test fixtures go to `.tools/` by
default. `-OutputDirectory` selects another output folder.

The `controls` group also checks native Ribbon inputs: keyboard focus, change
events, item/pane/tab/minimized visibility, removal and destruction, and a
form-streaming round trip with combo choices, spin limits, captions and progress.
It also checks automatic installed-font enumeration, font-name selection and
change events, font refresh, missing fonts and name-based form persistence.
The date editor checks cover focus, date changes, keyboard clearing, read-only
behavior and streaming of selected and empty dates.

The `popup` group checks gallery form streaming, opening via a Ribbon
KeyTip, keyboard selection, scrolling, dismissal and component cleanup.
It also checks the color combo's custom swatches, automatic color, contrast
filter, gradient selection and split-button apply event.

`design_audit.lpi` compiles the contents editor against IDEIntf and exercises its
editor deletion handler: 20 tab/pane/button subtrees, totaling 320 component
removals. The clean-checkout validator compiles and executes this program.
It also checks image-index editor registration, image-preview dropdown values,
small/large list selection, Quick Access list overrides, linked ActionList
fallbacks and missing image lists across Ribbon and BackStage properties.
The contents-editor checks also cover the labels and order of the shared item
actions, reopening without duplicate entries and native control subtree deletion.

Run the ZIP audit checks independently:

```powershell
powershell -ExecutionPolicy Bypass -File tests/release_audit.ps1
```

These checks verify acceptance of ordinary source and rejection of generated
units, local tool data, Git metadata and Lazarus profiles in archives.
Deliberately invalid fixture ZIPs are retained only in the ignored test output
directory. No test requires modifying the installed IDE profile.
