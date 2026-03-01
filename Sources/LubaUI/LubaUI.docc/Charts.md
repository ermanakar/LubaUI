# Charts

Add pre-styled data visualizations to your app with LubaUI's chart components.

## Overview

LubaUI's chart components wrap Apple's Swift Charts framework with the design system's token layer. Colors, radii, line widths, and grid styling all come from ``LubaChartTokens`` and ``LubaColors/Chart`` — so charts look cohesive with the rest of your UI in both light and dark mode.

### Quick Start

Conform your data model to ``LubaChartData`` and pass it to any chart component:

```swift
import LubaUI
import Charts

struct Revenue: LubaChartData {
    let id = UUID()
    let label: String
    let value: Double
}

let data = [
    Revenue(label: "Jan", value: 120),
    Revenue(label: "Feb", value: 180),
    Revenue(label: "Mar", value: 150),
]

// Bar chart
LubaBarChart(data: data)

// Line chart with area fill
LubaLineChart(data: data, showArea: true, showPoints: true)
```

### Multi-Series Data

For grouped or multi-line charts, conform to ``LubaSeriesChartData``:

```swift
struct DeptRevenue: LubaSeriesChartData {
    let id = UUID()
    let label: String
    let value: Double
    let series: String
}

LubaGroupedBarChart(data: deptData)
LubaMultiLineChart(data: deptData)
```

### Pie & Donut Charts

``LubaPieChart`` uses `SectorMark` and requires iOS 17+ / macOS 14+:

```swift
if #available(iOS 17, *) {
    LubaPieChart(data: segments)
    LubaPieChart(data: segments, innerRadius: .ratio(0.55))  // donut
}
```

### Sparklines

``LubaSparkline`` is a minimal inline chart for dashboards — no axes, no labels:

```swift
HStack {
    Text("Revenue")
    Spacer()
    LubaSparkline(values: [4, 7, 5, 9, 6, 8, 12])
        .frame(width: 80)
}
```

### Loading & Empty States

```swift
// Animated skeleton placeholder
LubaChartSkeleton(style: .bar)
LubaChartSkeleton(style: .line)

// Empty state (shown automatically when data is empty)
LubaChartEmptyState()
```

### Styling Raw Charts

Apply LubaUI's design language to any `Chart` using the `.lubaChartStyle()` modifier:

```swift
Chart {
    ForEach(data) { item in
        BarMark(x: .value("X", item.label), y: .value("Y", item.value))
    }
}
.lubaChartStyle(height: LubaChartTokens.compactHeight, showAxes: true)
```

### Color Palette

``LubaColors/Chart`` provides a 6-color adaptive palette designed for data visualization:

1. Sage green (accent)
2. Slate blue
3. Terracotta
4. Dusty violet
5. Teal
6. Warm sand

All colors are WCAG AA compliant and adapt between light and dark mode.

## Topics

### Charts

- ``LubaBarChart``
- ``LubaGroupedBarChart``
- ``LubaLineChart``
- ``LubaMultiLineChart``
- ``LubaSparkline``

### Pie Charts (iOS 17+)

- ``LubaPieChart``

### Supporting Views

- ``LubaChartSkeleton``
- ``LubaChartEmptyState``
- ``LubaChartLegend``

### Styling

- ``LubaChartStyleModifier``
- ``LubaChartTokens``

### Data Protocols

- ``LubaChartData``
- ``LubaSeriesChartData``
