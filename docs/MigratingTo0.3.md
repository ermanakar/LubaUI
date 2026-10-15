# Migrating to 0.3.0

0.3.0 introduces independently selectable products and removes chart wrappers.
Existing non-chart `import LubaUI` usage remains source compatible.

## Choose a product

| Product | Import | Dependencies |
| --- | --- | --- |
| `LubaCore` | `import LubaCore` | SwiftUI and Foundation; no component target |
| `LubaComponents` | `import LubaComponents` | Core plus ready-made views |
| `LubaUI` | `import LubaUI` | Re-exports Core and Components |

Existing `import LubaUI` and `@preconcurrency import LubaUI` call sites continue
to work for non-chart APIs. Existing public type names and theme initializers
remain available. This is source compatibility for apps rebuilt with SwiftPM,
not binary compatibility for already compiled frameworks.

For a source package, choose the dependency product explicitly:

```swift
dependencies: [.package(url: "https://github.com/ermanakar/LubaUI", from: "0.3.0")],
targets: [
    .target(name: "MyFeature", dependencies: [
        .product(name: "LubaCore", package: "LubaUI")
    ])
]
```

In Xcode, add the repository URL, require version 0.3.0 or later, and select the
desired product. To test local changes, replace the remote dependency with
`.package(path: "../LubaUI")`, using your checkout’s actual directory.

Core contains colors, spacing, typography, radii, theme/configuration, motion,
haptics, accessibility helpers, localized strings, and interaction primitives.
It includes native button styles and basic expansion behavior. Card-based
expansion and accordions live in Components with the other ready-made views.

## Charts are removed

There is no `LubaCharts` product or hidden chart dependency in `LubaUI`.
The following APIs are intentionally removed:

- `LubaBarChart`, `LubaGroupedBarChart`, `LubaLineChart`, `LubaMultiLineChart`,
  `LubaPieChart`, and `LubaSparkline`.
- `LubaChartData`, `LubaSeriesChartData`, and `LubaSparklineTrend`.
- `LubaChartSkeleton`, `LubaChartEmptyState`, `LubaChartLegend`,
  `LubaChartTokens`, `LubaChartStyleModifier`, and `.lubaChartStyle()`.

Use Apple's Swift Charts directly in the app. Supply its data, marks, axes,
selection, loading, and empty states according to that app's requirements.
Existing apps that depend on the removed wrappers must migrate or remain on
0.2.0 until they do.

`LubaColors.Chart` and the theme's `chartPalette`, `chartGrid`,
`chartAxisLabel`, and `chartColor(at:)` remain as lightweight color helpers.
Existing app themes, including Wirkraum's, pass these values even without chart
views. Keeping them preserves those initializers without importing Charts.

## Behavior changes included

- Omitted button style and card elevation follow the nearest configuration.
  Pass `.primary` / `.low` explicitly to retain those choices under a custom config.
- Interactive chips expand to the configured minimum target and use separate
  native selection and dismissal buttons. Allow the additional layout height.
- Text fields grow for larger fonts and use a minimum-sized clear action.
- `luba.haptics.trigger(...)` respects the subtree's enabled state and impact
  intensity. Notification/selection feedback has system-defined strength.
  Existing static `LubaHaptics` functions retain their global fallback.
- Localized resources now belong to Core and are packaged once. Use
  `LubaStrings`; do not depend on generated resource bundle filenames.

## Validation commands

```sh
swift test
bash Scripts/check-examples.sh
bash Scripts/check-consumers.sh
cd mcp-server && npm ci && npm test
```

`check-consumers.sh` builds and runs ordinary downstream clients for all three
imports. Its fresh Core-only build fails if Components or the umbrella module
appear in the build output. It also checks that library source does not import
Charts. This proves dependency separation, not a specific app-size reduction.

For Wirkraum, `python3 Scripts/prepare-wirkraum-check.py /path/to/vogel` creates
an isolated project referencing this checkout. Source files and resources are
shared with the app repository, but its project and published dependency pin
are not edited. Build/test that returned project's `Wirkraum` scheme with a
dedicated simulator. The release review records the exact validation results.
