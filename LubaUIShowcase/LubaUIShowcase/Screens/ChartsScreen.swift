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

private let multiLineData: [DepartmentData] = [
    DepartmentData(label: "Jan", value: 40, series: "Web"),
    DepartmentData(label: "Feb", value: 55, series: "Web"),
    DepartmentData(label: "Mar", value: 48, series: "Web"),
    DepartmentData(label: "Apr", value: 72, series: "Web"),
    DepartmentData(label: "May", value: 65, series: "Web"),
    DepartmentData(label: "Jun", value: 80, series: "Web"),
    DepartmentData(label: "Jan", value: 25, series: "Mobile"),
    DepartmentData(label: "Feb", value: 35, series: "Mobile"),
    DepartmentData(label: "Mar", value: 50, series: "Mobile"),
    DepartmentData(label: "Apr", value: 45, series: "Mobile"),
    DepartmentData(label: "May", value: 60, series: "Mobile"),
    DepartmentData(label: "Jun", value: 75, series: "Mobile"),
    DepartmentData(label: "Jan", value: 10, series: "Desktop"),
    DepartmentData(label: "Feb", value: 15, series: "Desktop"),
    DepartmentData(label: "Mar", value: 12, series: "Desktop"),
    DepartmentData(label: "Apr", value: 18, series: "Desktop"),
    DepartmentData(label: "May", value: 22, series: "Desktop"),
    DepartmentData(label: "Jun", value: 20, series: "Desktop"),
]

private let sparklineRevenue: [Double] = [4, 7, 5, 9, 6, 8, 12, 10, 14, 11]
private let sparklineUsers: [Double] = [3, 5, 4, 8, 6, 7, 9, 11, 13, 15]
private let sparklineOrders: [Double] = [8, 6, 7, 4, 5, 3, 2, 4, 3, 2]

// MARK: - Screen

struct ChartsScreen: View {
    var body: some View {
        ShowcaseScreen("Charts") {
            ShowcaseHeader(
                title: "Charts",
                description: "Data visualization with bar, line, pie, and sparkline charts. Touch any chart to interact — bar charts highlight on tap, line charts show a value callout."
            )

            // Bar Chart with Annotations
            DemoSection(title: "Bar Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Monthly Sales")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        Text("Tap and drag to highlight")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)

                        LubaBarChart(
                            data: monthlySales,
                            showAnnotations: true
                        )
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

            // Custom Color Bar Chart
            DemoSection(title: "Custom Colors") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Slate Blue Bars")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaBarChart(
                            data: weeklyTrend,
                            height: LubaChartTokens.compactHeight,
                            color: LubaColors.Chart.palette[1]
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

            // Interactive Line Chart
            DemoSection(title: "Line Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Weekly Trend")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        Text("Drag to see values")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)

                        LubaLineChart(
                            data: weeklyTrend,
                            showPoints: true
                        )
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

            // Multi-Line Chart with Points
            DemoSection(title: "Multi-Line Chart") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Platform Traffic")
                            .font(LubaTypography.subheadline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaMultiLineChart(
                            data: multiLineData,
                            showArea: true,
                            showPoints: true
                        )
                    }
                }
            }

            // Pie Chart (iOS 17+)
            piechartSection

            // Sparkline Dashboard
            DemoSection(title: "Sparkline Dashboard") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        sparklineRow(
                            title: "Revenue",
                            value: "$12.4k",
                            values: sparklineRevenue,
                            color: LubaColors.Chart.palette[0]
                        )
                        LubaDivider()
                        sparklineRow(
                            title: "Users",
                            value: "1,284",
                            values: sparklineUsers,
                            color: LubaColors.Chart.palette[1]
                        )
                        LubaDivider()
                        sparklineRow(
                            title: "Orders",
                            value: "342",
                            values: sparklineOrders,
                            color: LubaColors.Chart.palette[2]
                        )
                    }
                }
            }

            // Height Comparison
            DemoSection(title: "Height Presets") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Compact (140pt)")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                            LubaLineChart(
                                data: weeklyTrend,
                                height: LubaChartTokens.compactHeight,
                                showArea: true
                            )
                        }

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Expanded (300pt)")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                            LubaLineChart(
                                data: monthlySales,
                                height: LubaChartTokens.expandedHeight,
                                showArea: true,
                                showPoints: true
                            )
                        }
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

            // Empty State variations
            DemoSection(title: "Empty States") {
                VStack(spacing: LubaSpacing.md) {
                    LubaChartEmptyState()

                    LubaChartEmptyState(
                        height: LubaChartTokens.compactHeight,
                        message: "No sales this week",
                        icon: "chart.line.downtrend.xyaxis"
                    )
                }
            }

            // Legend layouts
            DemoSection(title: "Legend") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Horizontal")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)

                            LubaChartLegend(items: [
                                ("Design", LubaColors.Chart.palette[0]),
                                ("Engineering", LubaColors.Chart.palette[1]),
                                ("Marketing", LubaColors.Chart.palette[2]),
                            ])
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Vertical")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)

                            LubaChartLegend(items: [
                                ("Web", LubaColors.Chart.palette[0]),
                                ("Mobile", LubaColors.Chart.palette[1]),
                                ("Desktop", LubaColors.Chart.palette[2]),
                            ], layout: .vertical)
                        }
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "chart.xyaxis.line",
                title: "Token-Driven Visualization",
                description: "Every chart dimension — bar radius, line width, point size, grid opacity — comes from LubaChartTokens. Interaction patterns (selection rule marks, value callouts) use the same token layer for consistent, system-wide styling."
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
                            Text("Donut with Center Label")
                                .font(LubaTypography.subheadline)
                                .foregroundStyle(LubaColors.textPrimary)

                            LubaPieChart(
                                data: categoryBreakdown,
                                innerRadius: .ratio(0.55),
                                centerLabel: "Total"
                            )
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func sparklineRow(title: String, value: String, values: [Double], color: Color) -> some View {
        let sparkline = LubaSparkline(values: values, color: color)
        let trend = sparkline.trend

        return HStack {
            VStack(alignment: .leading, spacing: LubaSpacing.xxs) {
                Text(title)
                    .font(LubaTypography.subheadline)
                    .foregroundStyle(LubaColors.textPrimary)

                HStack(spacing: LubaSpacing.xs) {
                    Text(value)
                        .font(LubaTypography.title3)
                        .foregroundStyle(LubaColors.textPrimary)

                    Image(systemName: trend.iconName)
                        .font(LubaTypography.caption2)
                        .foregroundStyle(trend.color)
                }
            }

            Spacer()

            sparkline
                .frame(width: 100, height: LubaChartTokens.sparklineHeight)
        }
    }
}
