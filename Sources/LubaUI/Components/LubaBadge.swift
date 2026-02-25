//
//  LubaBadge.swift
//  LubaUI
//
//  A refined badge for status indicators and counts.
//
//  Design Decisions:
//  - Small: 11pt font, 4×8pt padding
//  - Medium: 12pt font, 5×10pt padding
//  - Corner: Full capsule
//  - Icon: Tightly spaced (3pt)
//

import SwiftUI

// MARK: - Badge Style

/// Visual style for a badge.
public enum LubaBadgeStyle {
    /// Filled accent background with contrasting text.
    case accent
    /// Light accent background with accent text.
    case subtle
    /// Gray background with secondary text.
    case neutral
    /// Green background for positive status.
    case success
    /// Amber background for warning status.
    case warning
    /// Red background for error status.
    case error
}

/// Size variant for a badge.
public enum LubaBadgeSize {
    case small
    case medium
    
    var fontSize: CGFloat {
        switch self {
        case .small: return 11
        case .medium: return 12
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return 10
        case .medium: return 11
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 3
        case .medium: return 4
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        }
    }
}

// MARK: - LubaBadge

/// A small status indicator or count label.
///
/// Badges are pill-shaped labels used for status indicators, counts, and categories.
///
/// ```swift
/// LubaBadge("New", style: .accent)
/// LubaBadge("3", style: .error, size: .small)
/// LubaBadge("Pro", style: .subtle, icon: Image(systemName: "crown"))
/// ```
public struct LubaBadge: View {
    private let text: String
    private let style: LubaBadgeStyle
    private let size: LubaBadgeSize
    private let icon: Image?
    
    /// Creates a badge.
    ///
    /// - Parameters:
    ///   - text: The text to display.
    ///   - style: The visual style.
    ///   - size: The size variant.
    ///   - icon: Optional leading icon.
    public init(
        _ text: String,
        style: LubaBadgeStyle = .accent,
        size: LubaBadgeSize = .medium,
        icon: Image? = nil
    ) {
        self.text = text
        self.style = style
        self.size = size
        self.icon = icon
    }
    
    public var body: some View {
        HStack(spacing: 3) {
            if let icon = icon {
                icon
                    .font(.system(size: size.iconSize, weight: .medium))
            }
            
            Text(text)
                .font(LubaTypography.custom(size: size.fontSize, weight: .semibold))
        }
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .clipShape(Capsule())
        .accessibilityLabel(text)
        .accessibilityAddTraits(.isStaticText)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .accent:
            return LubaColors.textOnAccent
        case .subtle:
            return LubaColors.accent
        case .neutral:
            return LubaColors.textSecondary
        case .success:
            return .white
        case .warning:
            return LubaColors.textOnAccent
        case .error:
            return .white
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .accent: return LubaColors.accent
        case .subtle: return LubaColors.accentSubtle
        case .neutral: return LubaColors.gray100
        case .success: return LubaColors.success
        case .warning: return LubaColors.warning
        case .error: return LubaColors.error
        }
    }
}

// MARK: - Preview

#Preview("Badge") {
    VStack(spacing: 16) {
        HStack(spacing: 8) {
            LubaBadge("Accent", style: .accent)
            LubaBadge("Subtle", style: .subtle)
            LubaBadge("Neutral", style: .neutral)
        }
        
        HStack(spacing: 8) {
            LubaBadge("Success", style: .success)
            LubaBadge("Warning", style: .warning)
            LubaBadge("Error", style: .error)
        }
        
        HStack(spacing: 8) {
            LubaBadge("New", style: .accent, icon: Image(systemName: "sparkles"))
            LubaBadge("Pro", style: .subtle, icon: Image(systemName: "crown"))
            LubaBadge("3", style: .error, size: .small)
        }
    }
    .padding(20)
    .background(LubaColors.background)
}
