//
//  LubaRadius.swift
//  LubaUI
//
//  Corner radius tokens for consistent roundness across components.
//

import SwiftUI

// MARK: - Radius Tokens

/// LubaUI's corner radius system.
/// Provides consistent roundness for UI elements.
public enum LubaRadius {
    
    /// 0pt - No rounding (sharp corners)
    public static let none: CGFloat = 0
    
    /// 4pt - Subtle rounding for inputs and small elements
    public static let xs: CGFloat = 4
    
    /// 8pt - Small rounding for buttons and tags
    public static let sm: CGFloat = 8
    
    /// 12pt - Medium rounding for cards
    public static let md: CGFloat = 12
    
    /// 16pt - Large rounding for prominent cards
    public static let lg: CGFloat = 16
    
    /// 24pt - Extra large rounding for modal sheets
    public static let xl: CGFloat = 24
    
    /// 9999pt - Full rounding (pill shape)
    public static let full: CGFloat = 9999
}

// MARK: - Rounded Rectangle Shape

public extension RoundedRectangle {
    /// Create a rounded rectangle with LubaUI radius
    static func luba(_ radius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
    }
}

// MARK: - View Extension

public extension View {
    /// Apply LubaUI corner radius with continuous corners
    func lubaCornerRadius(_ radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}
