//
//  LubaChart.swift
//  LubaUI
//
//  Pre-styled chart components wrapping Apple's Swift Charts.
//  Provides bar, line, pie, and sparkline charts with LubaUI tokens.
//
//  Architecture:
//  - Uses LubaChartTokens for all dimensions
//  - Uses LubaColors.Chart for palette
//  - Uses LubaMotion / LubaAnimations for animation
//  - Respects LubaConfig for reduced motion
//

import SwiftUI
import Charts

// MARK: - Data Protocol

/// A single data point for LubaUI charts.
/// Conform your model to this protocol for the simplest API.
public protocol LubaChartData: Identifiable {
    var label: String { get }
    var value: Double { get }
}

/// A data point with an optional series key for multi-series charts.
public protocol LubaSeriesChartData: LubaChartData {
    var series: String { get }
}

// MARK: - LubaBarChart

/// A bar chart styled with LubaUI tokens.
///
/// Supports vertical/horizontal orientation, value annotations,
/// interactive selection with a rule mark, and custom colors.
///
/// ```swift
/// struct Revenue: LubaChartData {
///     let id = UUID()
///     let label: String
///     let value: Double
/// }
///
/// LubaBarChart(data: [
///     Revenue(label: "Jan", value: 120),
///     Revenue(label: "Feb", value: 180),
///     Revenue(label: "Mar", value: 150),
/// ], showAnnotations: true)
/// ```
public struct LubaBarChart<D: LubaChartData>: View {
    @LubaEnvironment private var luba
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool
    private let horizontal: Bool
    private let showAnnotations: Bool
    private let explicitColor: Color?

    /// The resolved mark color — the caller's override, or the theme accent.
    private var color: Color { explicitColor ?? luba.colors.accent }

    @State private var selectedLabel: String?
    @State private var animatedData: [D] = []

    /// Create a bar chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaChartData``.
    ///   - height: Chart height. Defaults to ``LubaChartTokens/defaultHeight``.
    ///   - showAxes: Show axis labels. Defaults to `true`.
    ///   - horizontal: Horizontal bars. Defaults to `false`.
    ///   - showAnnotations: Show value labels above bars. Defaults to `false`.
    ///   - color: Bar fill color. Defaults to the theme accent.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true,
        horizontal: Bool = false,
        showAnnotations: Bool = false,
        color: Color? = nil
    ) {
        self.data = data
        self.height = height
        self.showAxes = showAxes
        self.horizontal = horizontal
        self.showAnnotations = showAnnotations
        self.explicitColor = color
    }

    public var body: some View {
        if data.isEmpty {
            LubaChartEmptyState(height: height)
        } else {
            chartContent
                .onAppear {
                    guard animatedData.isEmpty else { return }
                    luba.motion.run(.easeOut(duration: LubaChartTokens.revealDuration)) {
                        animatedData = data
                    }
                }
                .onChange(of: data.map(\.label)) { _ in
                    animatedData = data
                }
        }
    }

    private var chartContent: some View {
        Chart(animatedData.isEmpty ? data : animatedData) { item in
            if horizontal {
                BarMark(
                    x: .value("Value", item.value),
                    y: .value("Category", item.label)
                )
                .foregroundStyle(barColor(for: item))
                .clipShape(RoundedRectangle(cornerRadius: LubaChartTokens.barCornerRadius, style: .continuous))
            } else {
                BarMark(
                    x: .value("Category", item.label),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(barColor(for: item))
                .clipShape(RoundedRectangle(cornerRadius: LubaChartTokens.barCornerRadius, style: .continuous))
                .annotation(position: .top) {
                    if showAnnotations {
                        Text(formattedValue(item.value))
                            .font(luba.fonts.caption2)
                            .foregroundStyle(luba.colors.textSecondary)
                            .offset(y: LubaChartTokens.annotationOffset)
                    }
                }
            }
        }
        .chartOverlay { proxy in
            if !horizontal {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let x = value.location.x - geometry[proxy.plotAreaFrame].origin.x
                                    if let label: String = proxy.value(atX: x) {
                                        selectedLabel = label
                                    }
                                }
                                .onEnded { _ in
                                    selectedLabel = nil
                                }
                        )
                }
            }
        }
        .lubaChartStyle(height: height, showAxes: showAxes)
    }

    private func barColor(for item: D) -> Color {
        if let selected = selectedLabel {
            return item.label == selected ? color : color.opacity(0.3)
        }
        return color
    }

    private func formattedValue(_ value: Double) -> String {
        if value == value.rounded() {
            return String(format: "%.0f", value)
        }
        return String(format: "%.1f", value)
    }
}

// MARK: - LubaGroupedBarChart

/// A grouped or stacked bar chart for multi-series data.
///
/// ```swift
/// struct DeptRevenue: LubaSeriesChartData {
///     let id = UUID()
///     let label: String   // e.g. "Q1"
///     let value: Double
///     let series: String  // e.g. "Engineering"
/// }
///
/// LubaGroupedBarChart(data: revenues)
/// ```
public struct LubaGroupedBarChart<D: LubaSeriesChartData>: View {
    @LubaEnvironment private var luba
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool
    private let showAnnotations: Bool


    /// Create a grouped bar chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaSeriesChartData``.
    ///   - height: Chart height.
    ///   - showAxes: Show axis labels.
    ///   - showAnnotations: Show value labels above bars. Defaults to `false`.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true,
        showAnnotations: Bool = false
    ) {
        self.data = data
        self.height = height
        self.showAxes = showAxes
        self.showAnnotations = showAnnotations
    }

    public var body: some View {
        if data.isEmpty {
            LubaChartEmptyState(height: height)
        } else {
            Chart(data) { item in
                BarMark(
                    x: .value("Category", item.label),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(by: .value("Series", item.series))
                .clipShape(RoundedRectangle(cornerRadius: LubaChartTokens.barCornerRadius, style: .continuous))
                .annotation(position: .top) {
                    if showAnnotations {
                        Text(formattedValue(item.value))
                            .font(luba.fonts.caption2)
                            .foregroundStyle(luba.colors.textTertiary)
                            .offset(y: LubaChartTokens.annotationOffset)
                    }
                }
            }
            .chartForegroundStyleScale(range: chartColorRange)
            .lubaChartStyle(height: height, showAxes: showAxes)
        }
    }

    private var chartColorRange: [Color] {
        let seriesCount = Set(data.map(\.series)).count
        return Array(luba.colors.chartPalette.prefix(max(seriesCount, 1)))
    }

    private func formattedValue(_ value: Double) -> String {
        if value == value.rounded() {
            return String(format: "%.0f", value)
        }
        return String(format: "%.1f", value)
    }
}

// MARK: - LubaLineChart

/// A line chart styled with LubaUI tokens.
///
/// Supports area fill, point markers, interactive selection with
/// a vertical rule mark, and custom line color.
///
/// ```swift
/// struct Point: LubaChartData {
///     let id = UUID()
///     let label: String
///     let value: Double
/// }
///
/// LubaLineChart(data: points, showArea: true, showPoints: true)
/// ```
public struct LubaLineChart<D: LubaChartData>: View {
    @LubaEnvironment private var luba
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool
    private let showArea: Bool
    private let showPoints: Bool
    private let explicitColor: Color?

    /// The resolved mark color — the caller's override, or the theme accent.
    private var color: Color { explicitColor ?? luba.colors.accent }

    @State private var selectedLabel: String?

    /// Create a line chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaChartData``.
    ///   - height: Chart height.
    ///   - showAxes: Show axis labels.
    ///   - showArea: Fill area under the line.
    ///   - showPoints: Show point markers on data points.
    ///   - color: Line and area color. Defaults to the theme accent.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true,
        showArea: Bool = false,
        showPoints: Bool = false,
        color: Color? = nil
    ) {
        self.data = data
        self.height = height
        self.showAxes = showAxes
        self.showArea = showArea
        self.showPoints = showPoints
        self.explicitColor = color
    }

    public var body: some View {
        if data.isEmpty {
            LubaChartEmptyState(height: height)
        } else {
            chartContent
        }
    }

    private var chartContent: some View {
        Chart(data) { item in
            LineMark(
                x: .value("Category", item.label),
                y: .value("Value", item.value)
            )
            .foregroundStyle(color)
            .lineStyle(StrokeStyle(lineWidth: LubaChartTokens.lineWidth, lineCap: .round, lineJoin: .round))
            .interpolationMethod(.catmullRom)

            if showArea {
                AreaMark(
                    x: .value("Category", item.label),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            color.opacity(LubaChartTokens.areaOpacity),
                            color.opacity(0.02)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }

            if showPoints {
                PointMark(
                    x: .value("Category", item.label),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(selectedLabel == item.label ? color : color.opacity(showPoints ? 1 : 0))
                .symbolSize(selectedLabel == item.label
                    ? LubaChartTokens.pointSize * LubaChartTokens.pointSize * 2
                    : LubaChartTokens.pointSize * LubaChartTokens.pointSize)
            }

            // Selection rule mark
            if let selected = selectedLabel, selected == item.label {
                RuleMark(x: .value("Selected", item.label))
                    .foregroundStyle(luba.colors.textTertiary)
                    .lineStyle(StrokeStyle(
                        lineWidth: LubaChartTokens.selectionLineWidth,
                        dash: LubaChartTokens.selectionDashPattern
                    ))
                    .annotation(position: .top, alignment: .center) {
                        Text(formattedValue(item.value))
                            .font(luba.fonts.caption2.weight(.medium))
                            .foregroundStyle(luba.colors.textPrimary)
                            .padding(.horizontal, LubaSpacing.xs)
                            .padding(.vertical, LubaSpacing.xxs)
                            .background(luba.colors.surface)
                            .lubaCornerRadius(LubaRadius.xs)
                            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                    }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let x = value.location.x - geometry[proxy.plotAreaFrame].origin.x
                                if let label: String = proxy.value(atX: x) {
                                    selectedLabel = label
                                }
                            }
                            .onEnded { _ in
                                selectedLabel = nil
                            }
                    )
            }
        }
        .lubaChartStyle(height: height, showAxes: showAxes)
    }

    private func formattedValue(_ value: Double) -> String {
        if value == value.rounded() {
            return String(format: "%.0f", value)
        }
        return String(format: "%.1f", value)
    }
}

// MARK: - LubaMultiLineChart

/// A multi-series line chart.
///
/// ```swift
/// LubaMultiLineChart(data: seriesData, showArea: true, showPoints: true)
/// ```
public struct LubaMultiLineChart<D: LubaSeriesChartData>: View {
    @LubaEnvironment private var luba
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool
    private let showArea: Bool
    private let showPoints: Bool


    /// Create a multi-series line chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaSeriesChartData``.
    ///   - height: Chart height.
    ///   - showAxes: Show axis labels.
    ///   - showArea: Fill area under lines.
    ///   - showPoints: Show point markers on data points. Defaults to `false`.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true,
        showArea: Bool = false,
        showPoints: Bool = false
    ) {
        self.data = data
        self.height = height
        self.showAxes = showAxes
        self.showArea = showArea
        self.showPoints = showPoints
    }

    public var body: some View {
        if data.isEmpty {
            LubaChartEmptyState(height: height)
        } else {
            Chart(data) { item in
                LineMark(
                    x: .value("Category", item.label),
                    y: .value("Value", item.value),
                    series: .value("Series", item.series)
                )
                .foregroundStyle(by: .value("Series", item.series))
                .lineStyle(StrokeStyle(lineWidth: LubaChartTokens.lineWidth, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)

                if showArea {
                    AreaMark(
                        x: .value("Category", item.label),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(by: .value("Series", item.series))
                    .interpolationMethod(.catmullRom)
                    .opacity(LubaChartTokens.areaOpacity)
                }

                if showPoints {
                    PointMark(
                        x: .value("Category", item.label),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(by: .value("Series", item.series))
                    .symbolSize(LubaChartTokens.pointSize * LubaChartTokens.pointSize)
                }
            }
            .chartForegroundStyleScale(range: chartColorRange)
            .lubaChartStyle(height: height, showAxes: showAxes)
        }
    }

    private var chartColorRange: [Color] {
        let seriesCount = Set(data.map(\.series)).count
        return Array(luba.colors.chartPalette.prefix(max(seriesCount, 1)))
    }
}

// MARK: - LubaPieChart (iOS 17+)

/// A pie or donut chart styled with LubaUI tokens.
///
/// Requires iOS 17+ / macOS 14+ (uses `SectorMark`).
/// Supports an optional center label for donut charts.
///
/// ```swift
/// LubaPieChart(data: segments, innerRadius: .ratio(0.55))
/// LubaPieChart(data: segments, innerRadius: .ratio(0.55), centerLabel: "Total")
/// ```
@available(iOS 17, macOS 14, watchOS 10, tvOS 17, *)
public struct LubaPieChart<D: LubaChartData>: View {
    @LubaEnvironment private var luba
    private let data: [D]
    private let height: CGFloat
    private let innerRadius: MarkDimension
    private let centerLabel: String?


    /// Create a pie or donut chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaChartData``.
    ///   - height: Chart height.
    ///   - innerRadius: Inner radius for donut style. Use `.ratio(0)` for a full pie.
    ///   - centerLabel: Optional text displayed in the center of donut charts.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        innerRadius: MarkDimension = .ratio(0),
        centerLabel: String? = nil
    ) {
        self.data = data
        self.height = height
        self.innerRadius = innerRadius
        self.centerLabel = centerLabel
    }

    public var body: some View {
        if data.isEmpty {
            LubaChartEmptyState(height: height)
        } else {
            chartBody
        }
    }

    private var chartBody: some View {
        ZStack {
            Chart(data) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: innerRadius,
                    angularInset: LubaChartTokens.sectorAngularInset
                )
                .foregroundStyle(by: .value("Category", item.label))
                .cornerRadius(LubaChartTokens.barCornerRadius)
            }
            .chartForegroundStyleScale(range: chartColorRange)
            .frame(height: height)
            .chartLegend(position: .bottom, spacing: LubaChartTokens.legendSpacing)

            if let centerLabel {
                VStack(spacing: LubaSpacing.xxs) {
                    Text(centerLabel)
                        .font(luba.fonts.caption)
                        .foregroundStyle(luba.colors.textTertiary)
                    Text(formattedTotal)
                        .font(luba.fonts.title3.weight(.semibold))
                        .foregroundStyle(luba.colors.textPrimary)
                }
            }
        }
    }

    private var formattedTotal: String {
        let total = data.reduce(0) { $0 + $1.value }
        if total == total.rounded() {
            return String(format: "%.0f", total)
        }
        return String(format: "%.1f", total)
    }

    private var chartColorRange: [Color] {
        let categoryCount = Set(data.map(\.label)).count
        return Array(luba.colors.chartPalette.prefix(max(categoryCount, 1)))
    }
}

// MARK: - LubaSparkline

/// A minimal inline chart for dashboard-style layouts.
///
/// No axes, no labels — just a clean trend line with optional area fill.
/// Includes a computed ``trend`` property for detecting direction.
///
/// ```swift
/// HStack {
///     Text("Revenue")
///     Spacer()
///     LubaSparkline(values: [4, 7, 5, 9, 6, 8, 12])
///         .frame(width: 80)
/// }
/// ```
public struct LubaSparkline: View {
    @LubaEnvironment private var luba
    private let values: [Double]
    private let showArea: Bool
    private let explicitColor: Color?

    /// The resolved mark color — the caller's override, or the theme accent.
    private var color: Color { explicitColor ?? luba.colors.accent }

    /// Create a sparkline.
    /// - Parameters:
    ///   - values: Array of numeric values to plot.
    ///   - showArea: Fill area under the line. Defaults to `true`.
    ///   - color: Line color. Defaults to the theme accent.
    public init(
        values: [Double],
        showArea: Bool = true,
        color: Color? = nil
    ) {
        self.values = values
        self.showArea = showArea
        self.explicitColor = color
    }

    /// The trend direction based on the first and last values.
    public var trend: LubaSparklineTrend {
        guard let first = values.first, let last = values.last else { return .flat }
        if last > first { return .up }
        if last < first { return .down }
        return .flat
    }

    public var body: some View {
        if values.isEmpty {
            Color.clear.frame(height: LubaChartTokens.sparklineHeight)
        } else {
            Chart {
                ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(color)
                    .lineStyle(StrokeStyle(lineWidth: LubaChartTokens.sparklineLineWidth, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)

                    if showArea {
                        AreaMark(
                            x: .value("Index", index),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color.opacity(0.2), color.opacity(0.02)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartLegend(.hidden)
            .frame(height: LubaChartTokens.sparklineHeight)
        }
    }
}

/// Trend direction for a sparkline.
public enum LubaSparklineTrend {
    /// Values are increasing overall
    case up
    /// Values are decreasing overall
    case down
    /// Values are flat or unchanged
    case flat

    /// SF Symbol name for the trend direction.
    public var iconName: String {
        switch self {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .flat: return "arrow.right"
        }
    }

    /// Semantic color for the trend direction, resolved against a theme palette.
    ///
    /// Inside a view, pass the active palette:
    /// ```swift
    /// @LubaEnvironment private var luba
    /// Image(systemName: trend.iconName).foregroundStyle(trend.color(luba.colors))
    /// ```
    public func color(_ colors: LubaThemeColors) -> Color {
        switch self {
        case .up: return colors.success
        case .down: return colors.error
        case .flat: return colors.textTertiary
        }
    }

    /// Semantic color using the default palette.
    public var color: Color { color(.default) }
}

// MARK: - LubaChartSkeleton

/// An animated loading placeholder for charts.
///
/// ```swift
/// LubaChartSkeleton(style: .bar)
/// LubaChartSkeleton(style: .line)
/// ```
public struct LubaChartSkeleton: View {
    @LubaEnvironment private var luba

    /// The visual style of the skeleton placeholder.
    public enum Style {
        /// Animated placeholder bars
        case bar
        /// Animated placeholder line
        case line
    }

    private let style: Style
    private let height: CGFloat

    @State private var isAnimating = false

    /// Create a chart skeleton.
    /// - Parameters:
    ///   - style: Bar or line skeleton style.
    ///   - height: Height of the placeholder.
    public init(style: Style = .bar, height: CGFloat = LubaChartTokens.defaultHeight) {
        self.style = style
        self.height = height
    }

    public var body: some View {
        Group {
            switch style {
            case .bar:
                barSkeleton
            case .line:
                lineSkeleton
            }
        }
        .frame(height: height)
        .onAppear {
            guard let pulse = luba.motion.repeatingOpacity(
                .easeInOut(duration: 1.2).repeatForever(autoreverses: true)
            ) else { return }
            withAnimation(pulse) {
                isAnimating = true
            }
        }
    }

    private var barSkeleton: some View {
        HStack(alignment: .bottom, spacing: LubaSpacing.sm) {
            ForEach(0..<LubaChartTokens.skeletonBarCount, id: \.self) { index in
                let ratio = barRatio(for: index)
                RoundedRectangle(cornerRadius: LubaChartTokens.barCornerRadius, style: .continuous)
                    .fill(luba.colors.fill)
                    .frame(height: height * ratio)
                    .opacity(isAnimating ? 0.4 : 0.8)
            }
        }
        .padding(.horizontal, LubaSpacing.xs)
    }

    private var lineSkeleton: some View {
        GeometryReader { geometry in
            let points = linePoints(in: geometry.size)
            Path { path in
                guard let first = points.first else { return }
                path.move(to: first)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(luba.colors.fill, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .opacity(isAnimating ? 0.4 : 0.8)
        }
    }

    private func barRatio(for index: Int) -> CGFloat {
        // Deterministic pseudo-random heights
        let ratios: [CGFloat] = [0.6, 0.85, 0.45, 0.7, 0.55]
        return ratios[index % ratios.count]
    }

    private func linePoints(in size: CGSize) -> [CGPoint] {
        let count = LubaChartTokens.skeletonLinePointCount
        let ratios: [CGFloat] = [0.6, 0.4, 0.55, 0.3, 0.5, 0.35, 0.45, 0.25]
        return (0..<count).map { i in
            let x = size.width * CGFloat(i) / CGFloat(count - 1)
            let y = size.height * ratios[i % ratios.count]
            return CGPoint(x: x, y: y)
        }
    }
}

// MARK: - LubaChartEmptyState

/// Placeholder shown when chart data is empty.
///
/// Customizable message and icon for contextual empty states.
///
/// ```swift
/// LubaChartEmptyState()
/// LubaChartEmptyState(message: "No sales this week", icon: "chart.line.downtrend.xyaxis")
/// ```
public struct LubaChartEmptyState: View {
    @LubaEnvironment private var luba
    private let height: CGFloat
    private let message: String
    private let icon: String

    /// Create a chart empty state.
    /// - Parameters:
    ///   - height: Height of the placeholder.
    ///   - message: Description text. Defaults to `"No data"`.
    ///   - icon: SF Symbol name. Defaults to `"chart.bar"`.
    public init(
        height: CGFloat = LubaChartTokens.defaultHeight,
        message: String = LubaStrings.noData,
        icon: String = "chart.bar"
    ) {
        self.height = height
        self.message = message
        self.icon = icon
    }

    public var body: some View {
        VStack(spacing: LubaSpacing.sm) {
            Image(systemName: icon)
                .font(luba.fonts.title)
                .foregroundStyle(luba.colors.textDisabled)

            Text(message)
                .font(luba.fonts.caption)
                .foregroundStyle(luba.colors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(luba.colors.surfaceSecondary)
        .lubaCornerRadius(LubaRadius.md)
    }
}

// MARK: - Chart Legend Helper

/// A custom legend for use alongside charts.
///
/// Supports horizontal (default) and vertical layouts.
///
/// ```swift
/// LubaChartLegend(items: [
///     ("Sales", LubaColors.Chart.palette[0]),
///     ("Marketing", LubaColors.Chart.palette[1]),
/// ])
///
/// LubaChartLegend(items: [...], layout: .vertical)
/// ```
public struct LubaChartLegend: View {
    @LubaEnvironment private var luba

    /// Legend layout direction.
    public enum Layout {
        /// Items arranged horizontally (default)
        case horizontal
        /// Items arranged vertically
        case vertical
    }

    private let items: [(label: String, color: Color)]
    private let layout: Layout

    /// Create a chart legend.
    /// - Parameters:
    ///   - items: Array of label/color pairs.
    ///   - layout: Horizontal or vertical arrangement. Defaults to `.horizontal`.
    public init(items: [(label: String, color: Color)], layout: Layout = .horizontal) {
        self.items = items
        self.layout = layout
    }

    public var body: some View {
        switch layout {
        case .horizontal:
            HStack(spacing: LubaChartTokens.legendSpacing) {
                legendItems
            }
        case .vertical:
            VStack(alignment: .leading, spacing: LubaChartTokens.legendRowSpacing) {
                legendItems
            }
        }
    }

    @ViewBuilder
    private var legendItems: some View {
        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
            HStack(spacing: LubaSpacing.xs) {
                Circle()
                    .fill(item.color)
                    .frame(width: LubaChartTokens.legendDotSize, height: LubaChartTokens.legendDotSize)

                Text(item.label)
                    .font(luba.fonts.caption)
                    .foregroundStyle(luba.colors.textSecondary)
            }
        }
    }
}

// MARK: - Preview

#Preview("Bar Chart") {
    struct SampleData: LubaChartData {
        let id = UUID()
        let label: String
        let value: Double
    }

    return VStack(spacing: LubaSpacing.xl) {
        LubaBarChart(data: [
            SampleData(label: "Jan", value: 120),
            SampleData(label: "Feb", value: 180),
            SampleData(label: "Mar", value: 150),
            SampleData(label: "Apr", value: 210),
            SampleData(label: "May", value: 165),
        ], showAnnotations: true)

        LubaSparkline(values: [4, 7, 5, 9, 6, 8, 12])
            .frame(width: 120, height: 40)
    }
    .padding()
    .background(LubaColors.background)
}
