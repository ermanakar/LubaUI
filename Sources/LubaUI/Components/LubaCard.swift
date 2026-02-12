//
//  LubaCard.swift
//  LubaUI
//
//  A refined container component — subtle, elevated, premium.
//
//  Architecture:
//  - Elevation tokens define shadow behavior
//  - Uses LubaMotion for animations
//  - Pressable via `.lubaPressable()` modifier (composable)
//
//  To make a card tappable:
//  ```swift
//  LubaCard { content }
//      .lubaPressable(scale: LubaMotion.pressScaleProminent) { action() }
//  ```
//

import SwiftUI

// MARK: - Card Elevation

/// Elevation levels for LubaCard.
/// Each level defines shadow radius, opacity, and Y offset for realistic depth.
public enum LubaCardElevation {
    case flat       // No shadow — flush with surface
    case low        // Subtle lift — default for content cards
    case medium     // Moderate emphasis — selected states, hover
    case high       // Prominent — modals, popovers, dialogs

    /// Shadow blur radius
    public var shadowRadius: CGFloat {
        switch self {
        case .flat: return 0
        case .low: return 4
        case .medium: return 12
        case .high: return 24
        }
    }

    /// Shadow opacity (before color scheme adjustment)
    public var shadowOpacity: Double {
        switch self {
        case .flat: return 0
        case .low: return 0.06
        case .medium: return 0.10
        case .high: return 0.15
        }
    }

    /// Shadow Y offset (light comes from above)
    public var shadowY: CGFloat {
        switch self {
        case .flat: return 0
        case .low: return 2
        case .medium: return 6
        case .high: return 12
        }
    }

    /// Adjusted shadow opacity for dark mode (shadows need to be stronger)
    public func adjustedOpacity(for colorScheme: ColorScheme) -> Double {
        colorScheme == .dark ? shadowOpacity * 1.5 : shadowOpacity
    }
}

// MARK: - Card Style

/// Visual style presets for cards.
public enum LubaCardStyle {
    case filled     // Solid surface background
    case outlined   // Border only, transparent background
    case ghost      // No border, no background (content only)

    var hasBackground: Bool {
        switch self {
        case .filled: return true
        case .outlined: return false
        case .ghost: return false
        }
    }

    var hasBorder: Bool {
        switch self {
        case .filled: return false
        case .outlined: return true
        case .ghost: return false
        }
    }
}

// MARK: - Card Constants

/// Layout constants for cards
public enum LubaCardTokens {
    /// Default corner radius
    public static let cornerRadius: CGFloat = 14

    /// Default content padding
    public static let padding: CGFloat = LubaSpacing.lg

    /// Compact padding for dense layouts
    public static let paddingCompact: CGFloat = LubaSpacing.md

    /// Large padding for hero cards
    public static let paddingLarge: CGFloat = LubaSpacing.xl

    /// Border width
    public static let borderWidth: CGFloat = 1

    /// Border opacity in dark mode
    public static let darkModeBorderOpacity: Double = 0.6
}

// MARK: - LubaCard

/// A refined container component with subtle elevation.
///
/// Basic usage:
/// ```swift
/// LubaCard {
///     Text("Card content")
/// }
/// ```
///
/// With customization:
/// ```swift
/// LubaCard(elevation: .medium, style: .outlined) {
///     VStack { ... }
/// }
/// ```
///
/// Make it tappable (composable):
/// ```swift
/// LubaCard { content }
///     .lubaPressable(scale: LubaMotion.pressScaleProminent) { action() }
/// ```
public struct LubaCard<Content: View>: View {
    private let elevation: LubaCardElevation
    private let style: LubaCardStyle
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let content: Content

    @Environment(\.colorScheme) private var colorScheme

    public init(
        elevation: LubaCardElevation = .low,
        style: LubaCardStyle = .filled,
        cornerRadius: CGFloat = LubaCardTokens.cornerRadius,
        padding: CGFloat = LubaCardTokens.padding,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    /// Backwards-compatible initializer with hasBorder parameter.
    public init(
        elevation: LubaCardElevation = .low,
        cornerRadius: CGFloat = LubaCardTokens.cornerRadius,
        padding: CGFloat = LubaCardTokens.padding,
        hasBorder: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.style = hasBorder ? .outlined : .filled
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(borderOverlay)
            .shadow(
                color: shadowColor,
                radius: elevation.shadowRadius,
                x: 0,
                y: elevation.shadowY
            )
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        style.hasBackground ? LubaColors.surface : .clear
    }

    private var shadowColor: Color {
        Color.black.opacity(elevation.adjustedOpacity(for: colorScheme))
    }

    @ViewBuilder
    private var borderOverlay: some View {
        // Show border if style requires it, or always in dark mode for filled cards
        let showBorder = style.hasBorder || (style == .filled && colorScheme == .dark)
        if showBorder {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(
                    LubaColors.border.opacity(colorScheme == .dark ? LubaCardTokens.darkModeBorderOpacity : 1),
                    lineWidth: LubaCardTokens.borderWidth
                )
        }
    }
}

// MARK: - Convenience Modifiers

public extension LubaCard {
    /// Make this card tappable with press feedback.
    /// Shorthand for `.lubaPressable(scale:haptic:action:)`.
    func onTap(
        scale: CGFloat = LubaMotion.pressScaleProminent,
        haptic: LubaHapticStyle = .light,
        action: @escaping () -> Void
    ) -> some View {
        self.lubaPressable(scale: scale, haptic: haptic, action: action)
    }
}

// MARK: - Backwards Compatibility

/// A tappable card with press animation.
/// Deprecated: Use `LubaCard { }.lubaPressable { }` instead.
@available(*, deprecated, message: "Use LubaCard with .lubaPressable() modifier instead")
public struct LubaTappableCard<Content: View>: View {
    private let elevation: LubaCardElevation
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let action: () -> Void
    private let content: Content

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.lubaConfig) private var config

    public init(
        elevation: LubaCardElevation = .low,
        cornerRadius: CGFloat = LubaCardTokens.cornerRadius,
        padding: CGFloat = LubaCardTokens.padding,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.action = action
        self.content = content()
    }

    public var body: some View {
        LubaCard(elevation: elevation, cornerRadius: cornerRadius, padding: padding) {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .lubaPressable(
            scale: LubaMotion.pressScaleProminent,
            haptic: .light,
            action: action
        )
    }
}

// MARK: - Preview

#Preview("Card Elevations") {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(["Flat", "Low", "Medium", "High"], id: \.self) { name in
                LubaCard(elevation: cardElevation(for: name)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(name)
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("Shadow radius: \(Int(cardElevation(for: name).shadowRadius))pt")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
    }
    .background(LubaColors.background)
}

private func cardElevation(for name: String) -> LubaCardElevation {
    switch name {
    case "Flat": return .flat
    case "Low": return .low
    case "Medium": return .medium
    case "High": return .high
    default: return .low
    }
}

#Preview("Card Styles") {
    VStack(spacing: 16) {
        LubaCard(style: .filled) {
            Text("Filled (default)")
                .font(LubaTypography.body)
        }

        LubaCard(style: .outlined) {
            Text("Outlined")
                .font(LubaTypography.body)
        }

        LubaCard(style: .ghost, padding: 0) {
            Text("Ghost (no background)")
                .font(LubaTypography.body)
        }
    }
    .padding(20)
    .background(LubaColors.background)
}

#Preview("Tappable Card (New Pattern)") {
    LubaCard {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Tappable Card")
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text("Using .lubaPressable() modifier")
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(LubaColors.textTertiary)
        }
    }
    .lubaPressable(scale: LubaMotion.pressScaleProminent) {
        print("Tapped!")
    }
    .padding(20)
    .background(LubaColors.background)
}
