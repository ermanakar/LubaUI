//
//  LubaChartTokens.swift
//  LubaUI
//
//  Design tokens for chart components.
//  Centralizes dimensions, spacing, and animation values for data visualization.
//

import SwiftUI

// MARK: - Chart Tokens

/// Design tokens for LubaUI chart components.
///
/// These Tier 3 tokens define the visual properties of bar charts, line charts,
/// pie charts, and sparklines. All values reference Tier 2 tokens where applicable.
public enum LubaChartTokens {

    // MARK: - Height Presets

    /// Default chart height — 200pt balances visibility with page real estate
    public static let defaultHeight: CGFloat = 200

    /// Compact chart height — 140pt for dashboard cards
    public static let compactHeight: CGFloat = 140

    /// Expanded chart height — 300pt for detail views
    public static let expandedHeight: CGFloat = 300

    /// Sparkline height — 40pt for inline trend indicators
    public static let sparklineHeight: CGFloat = 40

    // MARK: - Mark Dimensions

    /// Bar corner radius — 4pt (LubaRadius.xs) for subtle rounding
    public static let barCornerRadius: CGFloat = LubaRadius.xs

    /// Line stroke width — 2.5pt provides clear visibility without heaviness
    public static let lineWidth: CGFloat = 2.5

    /// Point marker diameter — 6pt is visible without obscuring data
    public static let pointSize: CGFloat = 6

    /// Area fill opacity — 15% provides subtle fill without obscuring grid
    public static let areaOpacity: Double = 0.15

    // MARK: - Spacing

    /// Padding between axis labels and chart content
    public static let axisPadding: CGFloat = LubaSpacing.xs

    /// Spacing between legend items
    public static let legendSpacing: CGFloat = LubaSpacing.md

    /// Legend dot size
    public static let legendDotSize: CGFloat = 8

    // MARK: - Grid & Axes

    /// Grid line opacity — subtle enough to not compete with data
    public static let gridOpacity: Double = 0.12

    /// Grid line width
    public static let gridLineWidth: CGFloat = 0.5

    // MARK: - Animation

    /// Chart reveal animation duration
    public static let revealDuration: Double = 0.6

    // MARK: - Empty State

    /// Placeholder bar count for skeleton loading
    public static let skeletonBarCount: Int = 5

    /// Placeholder bar max height ratio (proportion of chart height)
    public static let skeletonBarMaxRatio: CGFloat = 0.85

    /// Placeholder bar min height ratio
    public static let skeletonBarMinRatio: CGFloat = 0.3

    /// Number of points in sparkline skeleton
    public static let skeletonLinePointCount: Int = 8
}
