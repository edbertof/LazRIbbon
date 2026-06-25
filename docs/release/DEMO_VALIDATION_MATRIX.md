# LazRibbon Demo Validation Matrix

This matrix turns the examples into release checks. It complements
`tools/build_all_projects.ps1`, which compiles every listed project plus the
runtime and design-time packages.
The same build matrix is also exercised from a temporary clean source tree by
`tools/verify_clean_checkout.ps1`.

## Build Command

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_all_projects.ps1 -CleanArtifacts
```

Use `-CleanArtifacts` for release validation so generated `bin`, `lib`, `obj`,
`.res` and executable files are removed after the build.

## Package And Tool Targets

| Target | Validates |
| --- | --- |
| `packages/LazRibbonRuntime.lpk` | Runtime units, public component API and LCL integration. |
| `packages/LazRibbonDesign.lpk` | Design-time registration, Object Inspector property hiding and palette component registration. |
| `tools/LazRibbonSkinEditor/LazRibbonSkinEditor.lpi` | Skin Manager, Skin Editor, Ribbon preview, embedded icon identity and Appearance editing flow. |

## Demo Targets

| Demo | Project | Primary validation |
| --- | --- | --- |
| Showcase | `demos/showcase/project1.lpi` | Combined Ribbon form chrome, QAT, BackStage, recent files, skins, ScreenTips, KeyTips and contextual tabs. |
| Ribbon Form | `demos/ribbon_form/project1.lpi` | `TLazRibbonForm`, custom title bar, Ribbon alignment and form-level integration. |
| Basic | `demos/basic/Project1.lpi` | Minimal design-time component streaming and package installation sanity. |
| Runtime | `demos/runtime/project1.lpi` | Runtime creation of Ribbon, tabs, panes and items using current API names such as `RibbonAppearance`. |
| Application Button | `demos/application_button/project1.lpi` | Office Application Button caption, menu/event modes and button-focused API. |
| Quick Access Toolbar | `demos/quick_access_toolbar/project1.lpi` | QAT item composition, command links and customize/minimize menu behavior. |
| BackStage | `demos/backstage/project1.lpi` | `TLazRibbon.BackstageView`, BackStage buttons and Office-style overlay behavior. |
| BackStage Recent Files | `demos/backstage_recent_files/project1.lpi` | Recent list rendering, BackStage appearance source and recent-item events. |
| Skins Gallery | `demos/skins_gallery/project1.lpi` | SkinManager active skin names, skin gallery selection and external/built-in skin display. |
| Skin Editor Sample | `demos/skin_editor_sample/project1.lpi` | Consumer-side skin loading and sample skin application. |
| Actions | `demos/actions/project1.lpi` | Lazarus `Action` integration with Ribbon command items. |
| Actions HiDPI | `demos/actions_hidpi/project1.lpi` | Action images and Ribbon command rendering under HiDPI-oriented resources. |
| Styles | `demos/styles/project1.lpi` | Built-in style switching and legacy-style visual coverage. |
| LCL Scaling | `demos/lclscaling/project1.lpi` | LCL scaling behavior, grid/content coexistence and high-DPI layout sanity. |
| Popup Menu | `demos/popup_menu/project1.lpi` | `TLazRibbonPopupMenu`, popup appearance and Ribbon popup integration. |

## Release Rule

Before publishing a stabilization build or `2.0.0-rc2`, the full build matrix
should pass with Lazarus 4.8. A demo may still emit Lazarus CodeTools hints, but
the FPC compile/link result must be successful.
For release-candidate validation, the matrix should also pass through
`tools/verify_clean_checkout.ps1` so the package is proven from an extracted
release-style source tree.
