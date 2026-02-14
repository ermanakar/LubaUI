//
//  LubaTheme.swift
//  LubaUI
//
//  Environment-based theming — refined greyscale with organic accent.
//

import SwiftUI

// MARK: - Theme Configuration

/// LubaUI theme configuration
public struct LubaThemeConfiguration {
    public let colors: LubaThemeColors
    public let typography: LubaThemeTypography
    public let spacing: LubaThemeSpacing
    public let radius: LubaThemeRadius
    
    public init(
        colors: LubaThemeColors = .default,
        typography: LubaThemeTypography = .default,
        spacing: LubaThemeSpacing = .default,
        radius: LubaThemeRadius = .default
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
    }
    
    public static let `default` = LubaThemeConfiguration()
}

// MARK: - Theme Colors

public struct LubaThemeColors {
    public let primary: Color
    public let secondary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color
    public let textPrimary: Color
    public let textSecondary: Color
    
    public init(
        primary: Color = LubaColors.gray900,
        secondary: Color = LubaColors.gray600,
        accent: Color = LubaColors.accent,
        background: Color = LubaColors.background,
        surface: Color = LubaColors.surface,
        textPrimary: Color = LubaColors.textPrimary,
        textSecondary: Color = LubaColors.textSecondary
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
    }
    
    public static let `default` = LubaThemeColors()
}

// MARK: - Theme Typography

public struct LubaThemeTypography {
    public let title: Font
    public let headline: Font
    public let body: Font
    public let caption: Font
    public let button: Font
    
    public init(
        title: Font = LubaTypography.title,
        headline: Font = LubaTypography.headline,
        body: Font = LubaTypography.body,
        caption: Font = LubaTypography.caption,
        button: Font = LubaTypography.button
    ) {
        self.title = title
        self.headline = headline
        self.body = body
        self.caption = caption
        self.button = button
    }
    
    public static let `default` = LubaThemeTypography()
}

// MARK: - Theme Spacing

public struct LubaThemeSpacing {
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let xxxl: CGFloat
    public let huge: CGFloat

    public init(
        xs: CGFloat = LubaSpacing.xs,
        sm: CGFloat = LubaSpacing.sm,
        md: CGFloat = LubaSpacing.md,
        lg: CGFloat = LubaSpacing.lg,
        xl: CGFloat = LubaSpacing.xl,
        xxl: CGFloat = LubaSpacing.xxl,
        xxxl: CGFloat = LubaSpacing.xxxl,
        huge: CGFloat = LubaSpacing.huge
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
        self.huge = huge
    }

    public static let `default` = LubaThemeSpacing()
}

// MARK: - Theme Radius

public struct LubaThemeRadius {
    public let none: CGFloat
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let full: CGFloat

    public init(
        none: CGFloat = LubaRadius.none,
        xs: CGFloat = LubaRadius.xs,
        sm: CGFloat = LubaRadius.sm,
        md: CGFloat = LubaRadius.md,
        lg: CGFloat = LubaRadius.lg,
        xl: CGFloat = LubaRadius.xl,
        full: CGFloat = LubaRadius.full
    ) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.full = full
    }

    public static let `default` = LubaThemeRadius()
}

// MARK: - Environment Key

private struct LubaThemeKey: EnvironmentKey {
    static let defaultValue = LubaThemeConfiguration.default
}

public extension EnvironmentValues {
    var lubaTheme: LubaThemeConfiguration {
        get { self[LubaThemeKey.self] }
        set { self[LubaThemeKey.self] = newValue }
    }
}

// MARK: - Theme Modifier

public extension View {
    /// Apply a custom LubaUI theme to the view hierarchy
    func lubaTheme(_ theme: LubaThemeConfiguration) -> some View {
        environment(\.lubaTheme, theme)
    }
}
