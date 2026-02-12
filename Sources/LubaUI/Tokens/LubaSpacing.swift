//
//  LubaSpacing.swift
//  LubaUI
//
//  Consistent spacing scale for harmonious layouts.
//

import SwiftUI

// MARK: - Spacing Tokens

/// LubaUI's spacing system.
/// Uses a 4-point base unit for consistent, harmonious spacing.
///
/// Scale progression: 4, 8, 12, 16, 24, 32, 48, 64
/// After the initial 2× jump (4→8), the scale alternates between
/// ×1.5 and ×1.33 — landing on clean multiples of 4 that are practical
/// for layout while maintaining perceptible visual gaps between steps.
///
/// Ratios: 2.0×, 1.5×, 1.33×, 1.5×, 1.33×, 1.5×, 1.33×
public enum LubaSpacing {
    
    /// 4pt - Extra small spacing for tight layouts
    public static let xs: CGFloat = 4
    
    /// 8pt - Small spacing for compact elements
    public static let sm: CGFloat = 8
    
    /// 12pt - Medium-small spacing
    public static let md: CGFloat = 12
    
    /// 16pt - Default spacing for most use cases
    public static let lg: CGFloat = 16
    
    /// 24pt - Large spacing for section separation
    public static let xl: CGFloat = 24
    
    /// 32pt - Extra large spacing for major sections
    public static let xxl: CGFloat = 32
    
    /// 48pt - Huge spacing for hero content
    public static let xxxl: CGFloat = 48
    
    /// 64pt - Maximum spacing for dramatic separation
    public static let huge: CGFloat = 64
}

// MARK: - Spacing Convenience

public extension LubaSpacing {
    
    /// Returns spacing value for a given multiplier of the base unit (4pt)
    /// - Parameter multiplier: Number of base units
    /// - Returns: The calculated spacing value
    static func custom(_ multiplier: Int) -> CGFloat {
        CGFloat(multiplier) * 4
    }
    
    /// Edge insets with uniform spacing
    static func insets(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }
    
    /// Edge insets with horizontal and vertical spacing
    static func insets(horizontal: CGFloat, vertical: CGFloat) -> EdgeInsets {
        EdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}

// MARK: - Padding Modifier

public extension View {
    /// Apply LubaUI spacing as padding
    func lubaPadding(_ spacing: CGFloat) -> some View {
        padding(spacing)
    }
    
    /// Apply LubaUI horizontal and vertical padding
    func lubaPadding(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> some View {
        padding(.horizontal, horizontal)
            .padding(.vertical, vertical)
    }
}
