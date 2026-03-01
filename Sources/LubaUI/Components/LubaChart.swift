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
/// ])
/// ```
public struct LubaBarChart<D: LubaChartData>: View {
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool
    private let horizontal: Bool

    @Environment(\.lubaConfig) private var config

    /// Create a bar chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaChartData``.
    ///   - height: Chart height. Defaults to ``LubaChartTokens/defaultHeight``.
    ///   - showAxes: Show axis labels. Defaults to `true`.
    ///   - horizontal: Horizontal bars. Defaults to `false`.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true,
        horizontal: Bool = false
    ) {
        self.data = data
        self.height = height
        self.showAxes = showAxes
        self.horizontal = horizontal
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
            if horizontal {
                BarMark(
                    x: .value("Value", item.value),
                    y: .value("Category", item.label)
                )
                .foregroundStyle(LubaColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: LubaChartTokens.barCornerRadius, style: .continuous))
            } else {
                BarMark(
                    x: .value("Category", item.label),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(LubaColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: LubaChartTokens.barCornerRadius, style: .continuous))
            }
        }
        .lubaChartStyle(height: height, showAxes: showAxes)
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
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool

    @Environment(\.lubaConfig) private var config

    /// Create a grouped bar chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaSeriesChartData``.
    ///   - height: Chart height.
    ///   - showAxes: Show axis labels.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true
    ) {
        self.data = data
        self.height = height
        self.showAxes = showAxes
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
            }
            .chartForegroundStyleScale(range: chartColorRange)
            .lubaChartStyle(height: height, showAxes: showAxes)
        }
    }

    private var chartColorRange: [Color] {
        let seriesCount = Set(data.map(\.series)).count
        return Array(LubaColors.Chart.palette.prefix(max(seriesCount, 1)))
    }
}

// MARK: - LubaLineChart

/// A line chart styled with LubaUI tokens.
///
/// ```swift
/// struct Point: LubaChartData {
///     let id = UUID()
///     let label: String
///     let value: Double
/// }
///
/// LubaLineChart(data: points, showArea: true)
/// ```
public struct LubaLineChart<D: LubaChartData>: View {
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool
    private let showArea: Bool
    private let showPoints: Bool

    @Environment(\.lubaConfig) private var config

    /// Create a line chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaChartData``.
    ///   - height: Chart height.
    ///   - showAxes: Show axis labels.
    ///   - showArea: Fill area under the line.
    ///   - showPoints: Show point markers on data points.
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
            chartContent
        }
    }

    private var chartContent: some View {
        Chart(data) { item in
            LineMark(
                x: .value("Category", item.label),
                y: .value("Value", item.value)
            )
            .foregroundStyle(LubaColors.accent)
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
                            LubaColors.accent.opacity(LubaChartTokens.areaOpacity),
                            LubaColors.accent.opacity(0.02)
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
                .foregroundStyle(LubaColors.accent)
                .symbolSize(LubaChartTokens.pointSize * LubaChartTokens.pointSize)
            }
        }
        .lubaChartStyle(height: height, showAxes: showAxes)
    }
}

// MARK: - LubaMultiLineChart

/// A multi-series line chart.
///
/// ```swift
/// LubaMultiLineChart(data: seriesData, showArea: true)
/// ```
public struct LubaMultiLineChart<D: LubaSeriesChartData>: View {
    private let data: [D]
    private let height: CGFloat
    private let showAxes: Bool
    private let showArea: Bool

    @Environment(\.lubaConfig) private var config

    /// Create a multi-series line chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaSeriesChartData``.
    ///   - height: Chart height.
    ///   - showAxes: Show axis labels.
    ///   - showArea: Fill area under lines.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true,
        showArea: Bool = false
    ) {
        self.data = data
        self.height = height
        self.showAxes = showAxes
        self.showArea = showArea
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
            }
            .chartForegroundStyleScale(range: chartColorRange)
            .lubaChartStyle(height: height, showAxes: showAxes)
        }
    }

    private var chartColorRange: [Color] {
        let seriesCount = Set(data.map(\.series)).count
        return Array(LubaColors.Chart.palette.prefix(max(seriesCount, 1)))
    }
}

// MARK: - LubaPieChart (iOS 17+)

/// A pie or donut chart styled with LubaUI tokens.
///
/// Requires iOS 17+ / macOS 14+ (uses `SectorMark`).
///
/// ```swift
/// LubaPieChart(data: segments, innerRadius: .ratio(0.5))
/// ```
@available(iOS 17, macOS 14, watchOS 10, tvOS 17, *)
public struct LubaPieChart<D: LubaChartData>: View {
    private let data: [D]
    private let height: CGFloat
    private let innerRadius: MarkDimension

    @Environment(\.lubaConfig) private var config

    /// Create a pie or donut chart.
    /// - Parameters:
    ///   - data: Array of data conforming to ``LubaChartData``.
    ///   - height: Chart height.
    ///   - innerRadius: Inner radius for donut style. Use `.ratio(0)` for a full pie.
    public init(
        data: [D],
        height: CGFloat = LubaChartTokens.defaultHeight,
        innerRadius: MarkDimension = .ratio(0)
    ) {
        self.data = data
        self.height = height
        self.innerRadius = innerRadius
    }

    public var body: some View {
        if data.isEmpty {
            LubaChartEmptyState(height: height)
        } else {
            Chart(data) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: innerRadius,
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("Category", item.label))
                .cornerRadius(LubaChartTokens.barCornerRadius)
            }
            .chartForegroundStyleScale(range: chartColorRange)
            .frame(height: height)
            .chartLegend(position: .bottom, spacing: LubaChartTokens.legendSpacing)
        }
    }

    private var chartColorRange: [Color] {
        let categoryCount = Set(data.map(\.label)).count
        return Array(LubaColors.Chart.palette.prefix(max(categoryCount, 1)))
    }
}

// MARK: - LubaSparkline

/// A minimal inline chart for dashboard-style layouts.
///
/// No axes, no labels — just a clean trend line with optional area fill.
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
    private let values: [Double]
    private let showArea: Bool
    private let color: Color

    /// Create a sparkline.
    /// - Parameters:
    ///   - values: Array of numeric values to plot.
    ///   - showArea: Fill area under the line. Defaults to `true`.
    ///   - color: Line color. Defaults to ``LubaColors/accent``.
    public init(
        values: [Double],
        showArea: Bool = true,
        color: Color = LubaColors.accent
    ) {
        self.values = values
        self.showArea = showArea
        self.color = color
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
                    .lineStyle(StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
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

// MARK: - LubaChartSkeleton

/// An animated loading placeholder for charts.
///
/// ```swift
/// LubaChartSkeleton(style: .bar)
/// LubaChartSkeleton(style: .line)
/// ```
public struct LubaChartSkeleton: View {

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
    @Environment(\.lubaConfig) private var config

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
            guard config.animationsEnabled else { return }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }

    private var barSkeleton: some View {
        HStack(alignment: .bottom, spacing: LubaSpacing.sm) {
            ForEach(0..<LubaChartTokens.skeletonBarCount, id: \.self) { index in
                let ratio = barRatio(for: index)
                RoundedRectangle(cornerRadius: LubaChartTokens.barCornerRadius, style: .continuous)
                    .fill(LubaColors.gray200)
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
            .stroke(LubaColors.gray200, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
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
public struct LubaChartEmptyState: View {
    private let height: CGFloat

    public init(height: CGFloat = LubaChartTokens.defaultHeight) {
        self.height = height
    }

    public var body: some View {
        VStack(spacing: LubaSpacing.sm) {
            Image(systemName: "chart.bar")
                .font(LubaTypography.title)
                .foregroundStyle(LubaColors.textDisabled)

            Text("No data")
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(LubaColors.surfaceSecondary)
        .lubaCornerRadius(LubaRadius.md)
    }
}

// MARK: - Chart Legend Helper

/// A simple custom legend row for use alongside charts.
///
/// ```swift
/// LubaChartLegend(items: [
///     ("Sales", LubaColors.Chart.palette[0]),
///     ("Marketing", LubaColors.Chart.palette[1]),
/// ])
/// ```
public struct LubaChartLegend: View {
    private let items: [(label: String, color: Color)]

    public init(items: [(label: String, color: Color)]) {
        self.items = items
    }

    public var body: some View {
        HStack(spacing: LubaChartTokens.legendSpacing) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(spacing: LubaSpacing.xs) {
                    Circle()
                        .fill(item.color)
                        .frame(width: LubaChartTokens.legendDotSize, height: LubaChartTokens.legendDotSize)

                    Text(item.label)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                }
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
        ])

        LubaSparkline(values: [4, 7, 5, 9, 6, 8, 12])
            .frame(width: 120, height: 40)
    }
    .padding()
    .background(LubaColors.background)
}
