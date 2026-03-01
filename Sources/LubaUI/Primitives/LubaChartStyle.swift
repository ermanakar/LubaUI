//
//  LubaChartStyle.swift
//  LubaUI
//
//  A view modifier that applies LubaUI's design language to any Swift Charts `Chart`.
//  Use `.lubaChartStyle()` to get tokenized axes, grid, and color treatment.
//

import SwiftUI
import Charts

// MARK: - Chart Style Modifier

/// Applies LubaUI styling to a Swift Charts `Chart` view.
///
/// Configures:
/// - Height via ``LubaChartTokens``
/// - Axis labels using ``LubaTypography`` and ``LubaColors``
/// - Grid lines with token-based opacity
/// - Color palette from ``LubaColors/Chart``
///
/// ```swift
/// Chart {
///     ForEach(data) { item in
///         BarMark(x: .value("Name", item.name), y: .value("Value", item.value))
///     }
/// }
/// .lubaChartStyle()
/// ```
public struct LubaChartStyleModifier: ViewModifier {
    let height: CGFloat
    let showAxes: Bool

    public func body(content: Content) -> some View {
        content
            .frame(height: height)
            .chartXAxis(showAxes ? .automatic : .hidden)
            .chartYAxis(showAxes ? .automatic : .hidden)
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: LubaChartTokens.gridLineWidth))
                        .foregroundStyle(LubaColors.Chart.grid.opacity(LubaChartTokens.gridOpacity))
                    AxisValueLabel()
                        .font(LubaTypography.caption2)
                        .foregroundStyle(LubaColors.Chart.axisLabel)
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(LubaTypography.caption2)
                        .foregroundStyle(LubaColors.Chart.axisLabel)
                }
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Apply LubaUI styling to a Swift Charts `Chart`.
    ///
    /// - Parameters:
    ///   - height: Chart height. Defaults to ``LubaChartTokens/defaultHeight``.
    ///   - showAxes: Whether to show axis labels and grid. Defaults to `true`.
    func lubaChartStyle(
        height: CGFloat = LubaChartTokens.defaultHeight,
        showAxes: Bool = true
    ) -> some View {
        modifier(LubaChartStyleModifier(height: height, showAxes: showAxes))
    }
}
