# Charts

Add pre-styled, interactive data visualizations to your app with LubaUI's chart components.

## Overview

LubaUI's chart components wrap Apple's Swift Charts framework with the design system's token layer. Colors, radii, line widths, grid styling, and interaction patterns all come from ``LubaChartTokens`` and ``LubaColors/Chart`` — so charts look cohesive with the rest of your UI in both light and dark mode.

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

// Bar chart with value annotations
LubaBarChart(data: data, showAnnotations: true)

// Line chart with area fill and interactive selection
LubaLineChart(data: data, showArea: true, showPoints: true)
```

### Interactive Selection

Line charts show a dashed rule mark with a value callout when dragged. Bar charts highlight the selected bar while dimming others. Both use `chartOverlay` for gesture handling — no extra setup required.

### Value Annotations

Bar charts and grouped bar charts support `showAnnotations: true` to display value labels above each bar. Annotation positioning and offset use ``LubaChartTokens/annotationOffset``.

### Custom Colors

Bar and line charts accept a `color` parameter to override the default accent:

```swift
LubaBarChart(data: data, color: LubaColors.Chart.palette[1])
LubaLineChart(data: data, showArea: true, color: LubaColors.Chart.palette[2])
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
LubaMultiLineChart(data: deptData, showArea: true, showPoints: true)
```

### Pie & Donut Charts

``LubaPieChart`` uses `SectorMark` and requires iOS 17+ / macOS 14+. Donut charts can display a center label:

```swift
if #available(iOS 17, *) {
    LubaPieChart(data: segments)
    LubaPieChart(data: segments, innerRadius: .ratio(0.55), centerLabel: "Total")
}
```

### Sparklines

``LubaSparkline`` is a minimal inline chart for dashboards — no axes, no labels. Access the ``LubaSparkline/trend`` property to get direction (up/down/flat) with semantic color and SF Symbol:

```swift
let spark = LubaSparkline(values: [4, 7, 5, 9, 6, 8, 12])

HStack {
    Text("Revenue")
    Spacer()
    Image(systemName: spark.trend.iconName)
        .foregroundStyle(spark.trend.color)
    spark.frame(width: 80)
}
```

### Loading & Empty States

```swift
// Animated skeleton placeholder
LubaChartSkeleton(style: .bar)
LubaChartSkeleton(style: .line)

// Customizable empty state
LubaChartEmptyState()
LubaChartEmptyState(message: "No sales this week", icon: "chart.line.downtrend.xyaxis")
```

### Legend

``LubaChartLegend`` supports horizontal and vertical layouts:

```swift
LubaChartLegend(items: [
    ("Sales", LubaColors.Chart.palette[0]),
    ("Marketing", LubaColors.Chart.palette[1]),
], layout: .vertical)
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

### Data Protocols & Types

- ``LubaChartData``
- ``LubaSeriesChartData``
- ``LubaSparklineTrend``
