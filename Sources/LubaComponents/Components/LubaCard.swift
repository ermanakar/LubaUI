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
import LubaCore

// MARK: - Card Style

/// Visual style presets for cards.
public enum LubaCardStyle {
    case filled     // Solid surface background
    case outlined   // Border only, transparent background
    case ghost      // No border, no background (content only)
    case glass      // Translucent glass background

    var hasBackground: Bool {
        switch self {
        case .filled: return true
        case .outlined, .ghost, .glass: return false
        }
    }

    var hasBorder: Bool {
        switch self {
        case .outlined: return true
        case .filled, .ghost, .glass: return false
        }
    }

    var isGlass: Bool { self == .glass }
}

// MARK: - Card Constants

/// Layout constants for cards
public enum LubaCardTokens {
    /// Default corner radius (on the LubaRadius grid)
    public static let cornerRadius: CGFloat = LubaRadius.lg
    /// Resolved against a theme's radius scale.
    public static func cornerRadius(_ radius: LubaThemeRadius) -> CGFloat { radius.lg }

    /// Default content padding
    public static let padding: CGFloat = LubaSpacing.lg
    /// Resolved against a theme's spacing scale.
    public static func padding(_ spacing: LubaThemeSpacing) -> CGFloat { spacing.lg }

    /// Compact padding for dense layouts
    public static let paddingCompact: CGFloat = LubaSpacing.md
    /// Resolved against a theme's spacing scale.
    public static func paddingCompact(_ spacing: LubaThemeSpacing) -> CGFloat { spacing.md }

    /// Large padding for hero cards
    public static let paddingLarge: CGFloat = LubaSpacing.xl
    /// Resolved against a theme's spacing scale.
    public static func paddingLarge(_ spacing: LubaThemeSpacing) -> CGFloat { spacing.xl }

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
    @LubaEnvironment private var luba
    private let explicitElevation: LubaCardElevation?
    private let style: LubaCardStyle
    private let explicitCornerRadius: CGFloat?
    private let explicitPadding: CGFloat?
    private let clipsContent: Bool
    private let content: Content

    @Environment(\.colorScheme) private var colorScheme

    /// An omitted elevation follows `defaultCardElevation` in the nearest config.
    public init(
        elevation: LubaCardElevation? = nil,
        style: LubaCardStyle = .filled,
        cornerRadius: CGFloat? = nil,
        padding: CGFloat? = nil,
        clipsContent: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.explicitElevation = elevation
        self.style = style
        self.explicitCornerRadius = cornerRadius
        self.explicitPadding = padding
        self.clipsContent = clipsContent
        self.content = content()
    }

    func resolvedElevation(in config: LubaConfig) -> LubaCardElevation {
        explicitElevation ?? config.defaultCardElevation
    }

    private var elevation: LubaCardElevation { resolvedElevation(in: luba.config) }

    /// An explicit override, else the theme's card radius.
    private var cornerRadius: CGFloat {
        explicitCornerRadius ?? LubaCardTokens.cornerRadius(luba.radius)
    }

    /// An explicit override, else the theme's card padding.
    private var padding: CGFloat {
        explicitPadding ?? LubaCardTokens.padding(luba.spacing)
    }

    public var body: some View {
        if style.isGlass {
            content
                .padding(padding)
                .lubaGlass(.regular, cornerRadius: cornerRadius)
        } else {
            if clipsContent {
                content
                    .padding(padding)
                    .background(cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .overlay(borderOverlay)
                    .shadow(
                        color: shadowColor,
                        radius: elevation.shadowRadius,
                        x: 0,
                        y: elevation.shadowY
                    )
            } else {
                content
                    .padding(padding)
                    .background(cardBackground)
                    .overlay(borderOverlay)
                    .shadow(
                        color: shadowColor,
                        radius: elevation.shadowRadius,
                        x: 0,
                        y: elevation.shadowY
                    )
            }
        }
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        style.hasBackground ? luba.colors.surface : .clear
    }

    @ViewBuilder
    private var cardBackground: some View {
        if style.hasBackground {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(backgroundColor)
        } else {
            Color.clear
        }
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
                    luba.colors.border.opacity(colorScheme == .dark ? LubaCardTokens.darkModeBorderOpacity : 1),
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
