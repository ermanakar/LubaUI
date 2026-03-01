//
//  ChartsScreen.swift
//  LubaUIShowcase
//
//  Showcase for LubaUI chart components — bar, line, pie, and sparkline.
//

import SwiftUI
import LubaUI
import Charts

// MARK: - Sample Data

private struct SalesData: LubaChartData {
    let id = UUID()
    let label: String
    let value: Double
}

private struct DepartmentData: LubaSeriesChartData {
    let id = UUID()
    let label: String
    let value: Double
    let series: String
}

// MARK: - Static Data

private let monthlySales: [SalesData] = [
    SalesData(label: "Jan", value: 120),
    SalesData(label: "Feb", value: 180),
    SalesData(label: "Mar", value: 150),
    SalesData(label: "Apr", value: 210),
    SalesData(label: "May", value: 165),
    SalesData(label: "Jun", value: 195),
]

private let weeklyTrend: [SalesData] = [
    SalesData(label: "Mon", value: 45),
    SalesData(label: "Tue", value: 62),
    SalesData(label: "Wed", value: 55),
    SalesData(label: "Thu", value: 78),
    SalesData(label: "Fri", value: 68),
    SalesData(label: "Sat", value: 42),
    SalesData(label: "Sun", value: 35),
]

private let categoryBreakdown: [SalesData] = [
    SalesData(label: "Design", value: 35),
    SalesData(label: "Engineering", value: 45),
    SalesData(label: "Marketing", value: 20),
]

private let multiSeriesData: [DepartmentData] = [
    DepartmentData(label: "Q1", value: 120, series: "Design"),
    DepartmentData(label: "Q2", value: 140, series: "Design"),
    DepartmentData(label: "Q3", value: 160, series: "Design"),
    DepartmentData(label: "Q4", value: 135, series: "Design"),
    DepartmentData(label: "Q1", value: 90, series: "Engineering"),
    DepartmentData(label: "Q2", value: 110, series: "Engineering"),
    DepartmentData(label: "Q3", value: 145, series: "Engineering"),
    DepartmentData(label: "Q4", value: 170, series: "Engineering"),
]

private let sparklineValues: [Double] = [4, 7, 5, 9, 6, 8, 12, 10, 14, 11]

// MARK: - Screen

struct ChartsScreen: View {
    var body: some View {
        ShowcaseScreen("Charts") {
            ShowcaseHeader(
                title: "Charts",
                description: "Data visualization with bar, line, pie, and sparkline charts — all styled with LubaUI tokens."
            )

            // Bar Chart
            DemoSection(title: "Bar Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Monthly Sales")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaBarChart(data: monthlySales)
                    }
                }
            }

            // Horizontal Bar Chart
            DemoSection(title: "Horizontal Bars") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("By Department")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaBarChart(
                            data: categoryBreakdown,
                            height: LubaChartTokens.compactHeight,
                            horizontal: true
                        )
                    }
                }
            }

            // Grouped Bar Chart
            DemoSection(title: "Grouped Bar Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Quarterly by Team")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaGroupedBarChart(data: multiSeriesData)
                    }
                }
            }

            // Line Chart
            DemoSection(title: "Line Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Weekly Trend")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaLineChart(data: weeklyTrend, showPoints: true)
                    }
                }
            }

            // Line Chart with Area
            DemoSection(title: "Area Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Sales with Area Fill")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaLineChart(
                            data: monthlySales,
                            showArea: true,
                            showPoints: true
                        )
                    }
                }
            }

            // Multi-Line Chart
            DemoSection(title: "Multi-Line Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Design vs Engineering")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaMultiLineChart(data: multiSeriesData)
                    }
                }
            }

            // Pie Chart (iOS 17+)
            piechartSection

            // Sparkline
            DemoSection(title: "Sparkline") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        sparklineRow(title: "Revenue", value: "$12.4k", values: sparklineValues, color: LubaColors.Chart.palette[0])
                        LubaDivider()
                        sparklineRow(title: "Users", value: "1,284", values: [3, 5, 4, 8, 6, 7, 9], color: LubaColors.Chart.palette[1])
                        LubaDivider()
                        sparklineRow(title: "Orders", value: "342", values: [8, 6, 7, 4, 5, 3, 2], color: LubaColors.Chart.palette[2])
                    }
                }
            }

            // Skeleton Loading
            DemoSection(title: "Chart Skeleton") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Bar skeleton")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                            LubaChartSkeleton(style: .bar, height: LubaChartTokens.compactHeight)
                        }

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Line skeleton")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                            LubaChartSkeleton(style: .line, height: LubaChartTokens.compactHeight)
                        }
                    }
                }
            }

            // Empty State
            DemoSection(title: "Empty State") {
                LubaChartEmptyState()
            }

            // Legend
            DemoSection(title: "Custom Legend") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaChartLegend(items: [
                        ("Design", LubaColors.Chart.palette[0]),
                        ("Engineering", LubaColors.Chart.palette[1]),
                        ("Marketing", LubaColors.Chart.palette[2]),
                    ])
                    .frame(maxWidth: .infinity)
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "chart.xyaxis.line",
                title: "Token-Driven Visualization",
                description: "Every chart dimension — bar radius, line width, point size, grid opacity — comes from LubaChartTokens. Colors use the Chart palette for automatic light/dark adaptation."
            )
        }
    }

    // MARK: - Pie Chart Section

    @ViewBuilder
    private var piechartSection: some View {
        if #available(iOS 17, macOS 14, watchOS 10, tvOS 17, *) {
            DemoSection(title: "Pie & Donut Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                            Text("Pie Chart")
                                .font(LubaTypography.subheadline)
                                .foregroundStyle(LubaColors.textPrimary)

                            LubaPieChart(data: categoryBreakdown)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                            Text("Donut Chart")
                                .font(LubaTypography.subheadline)
                                .foregroundStyle(LubaColors.textPrimary)

                            LubaPieChart(
                                data: categoryBreakdown,
                                innerRadius: .ratio(0.55)
                            )
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func sparklineRow(title: String, value: String, values: [Double], color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: LubaSpacing.xxs) {
                Text(title)
                    .font(LubaTypography.subheadline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(value)
                    .font(LubaTypography.title3)
                    .foregroundStyle(LubaColors.textPrimary)
            }

            Spacer()

            LubaSparkline(values: values, color: color)
                .frame(width: 100, height: LubaChartTokens.sparklineHeight)
        }
    }
}
