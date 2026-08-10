//
//  LubaTheme.swift
//  LubaUI
//
//  Environment-based theming — refined greyscale with organic accent.
//
//  The theme is the *runtime* source of truth for semantic values. Static
//  tokens (`LubaColors`, `LubaTypography`, …) remain the *authoring* source
//  of truth and supply every default, so the default theme renders exactly
//  like the unthemed system.
//
//  Components never read `LubaColors` directly. They read the resolved
//  environment via `@LubaEnvironment` (see LubaThemeContext.swift) and use
//  semantic roles such as `luba.colors.accent`.
//

import SwiftUI

// MARK: - Theme Configuration

/// Full theme override for colors, typography, spacing, and radii.
///
/// Apply a theme to a view subtree using the `.lubaTheme()` modifier:
///
/// ```swift
/// let custom = LubaThemeConfiguration(
///     colors: .accented(Color(hex: 0x2F5FD0))
/// )
/// ContentView().lubaTheme(custom)
/// ```
///
/// Properties not specified fall back to LubaUI defaults.
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

/// Semantic color roles for a ``LubaThemeConfiguration``.
///
/// Every property defaults to the corresponding ``LubaColors`` token, so
/// `LubaThemeColors.default` reproduces LubaUI's stock appearance — including
/// its adaptive light/dark behavior, because the defaults are themselves
/// adaptive colors.
///
/// To rebrand, override only what you need:
///
/// ```swift
/// LubaThemeColors(accent: .blue, accentHover: .blue.opacity(0.85))
/// ```
///
/// or derive a coherent accent ramp in one call:
///
/// ```swift
/// LubaThemeColors.accented(Color(hex: 0x2F5FD0))
/// ```
public struct LubaThemeColors {

    // MARK: Brand

    /// Strongest brand/foreground tone. Legacy role, kept for compatibility.
    public let primary: Color
    /// Muted brand/foreground tone. Legacy role, kept for compatibility.
    public let secondary: Color

    /// The primary interactive color: filled buttons, selection, focus.
    public let accent: Color
    /// Accent in its pressed/hovered state.
    public let accentHover: Color
    /// Low-emphasis accent wash used behind accent content.
    public let accentSubtle: Color

    // MARK: Surfaces

    /// The furthest-back page color.
    public let background: Color
    /// The default raised container color (cards, sheets, popovers).
    public let surface: Color
    /// One step above `surface` — nested containers, inset fields.
    public let surfaceSecondary: Color
    /// Two steps above `surface` — deeply nested containers.
    public let surfaceTertiary: Color
    /// Transient fill for hover/pressed states on neutral surfaces.
    public let surfaceHover: Color

    // MARK: Text

    /// High-contrast body and heading text.
    public let textPrimary: Color
    /// Supporting text, descriptions, secondary labels.
    public let textSecondary: Color
    /// Placeholders, hints, axis labels.
    public let textTertiary: Color
    /// Text in a disabled control.
    public let textDisabled: Color
    /// Text/icons drawn on top of `accent`.
    public let textOnAccent: Color

    // MARK: Lines

    /// Default hairline border.
    public let border: Color
    /// Higher-contrast border for unselected controls (checkbox, radio).
    public let borderStrong: Color
    /// Border of a focused control.
    public let borderFocused: Color
    /// Divider / separator line.
    public let divider: Color
    /// Neutral fill for tracks, skeletons, and inactive rails.
    public let fill: Color

    // MARK: Status

    public let success: Color
    public let successSubtle: Color
    public let warning: Color
    public let warningSubtle: Color
    public let error: Color
    public let errorSubtle: Color
    /// Informational status color. Defaults to `accent`.
    public let info: Color
    /// Low-emphasis informational wash. Defaults to `accentSubtle`.
    public let infoSubtle: Color

    // MARK: Data visualization

    /// Ordered categorical palette for charts.
    public let chartPalette: [Color]
    /// Chart grid lines.
    public let chartGrid: Color
    /// Chart axis labels.
    public let chartAxisLabel: Color

    // MARK: Glass

    public let glassBorder: Color
    public let glassShadow: Color

    // swiftlint:disable:next function_body_length
    public init(
        primary: Color = LubaColors.gray900,
        secondary: Color = LubaColors.gray600,
        accent: Color = LubaColors.accent,
        background: Color = LubaColors.background,
        surface: Color = LubaColors.surface,
        textPrimary: Color = LubaColors.textPrimary,
        textSecondary: Color = LubaColors.textSecondary,
        accentHover: Color? = nil,
        accentSubtle: Color? = nil,
        surfaceSecondary: Color = LubaColors.surfaceSecondary,
        surfaceTertiary: Color = LubaColors.surfaceTertiary,
        surfaceHover: Color = LubaColors.gray100,
        textTertiary: Color = LubaColors.textTertiary,
        textDisabled: Color = LubaColors.textDisabled,
        textOnAccent: Color = LubaColors.textOnAccent,
        border: Color = LubaColors.border,
        borderStrong: Color = LubaColors.gray400,
        borderFocused: Color? = nil,
        divider: Color = LubaColors.border,
        fill: Color = LubaColors.gray200,
        success: Color = LubaColors.success,
        successSubtle: Color = LubaColors.successSubtle,
        warning: Color = LubaColors.warning,
        warningSubtle: Color = LubaColors.warningSubtle,
        error: Color = LubaColors.error,
        errorSubtle: Color = LubaColors.errorSubtle,
        info: Color? = nil,
        infoSubtle: Color? = nil,
        chartPalette: [Color]? = nil,
        chartGrid: Color = LubaColors.Chart.grid,
        chartAxisLabel: Color = LubaColors.Chart.axisLabel,
        glassBorder: Color = LubaColors.glassBorder,
        glassShadow: Color = LubaColors.glassShadow
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.accentHover = accentHover ?? (accent == LubaColors.accent ? LubaColors.accentHover : accent.opacity(0.85))
        self.accentSubtle = accentSubtle ?? (accent == LubaColors.accent ? LubaColors.accentSubtle : accent.opacity(0.12))
        self.background = background
        self.surface = surface
        self.surfaceSecondary = surfaceSecondary
        self.surfaceTertiary = surfaceTertiary
        self.surfaceHover = surfaceHover
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textDisabled = textDisabled
        self.textOnAccent = textOnAccent
        self.border = border
        self.borderStrong = borderStrong
        self.borderFocused = borderFocused ?? accent
        self.divider = divider
        self.fill = fill
        self.success = success
        self.successSubtle = successSubtle
        self.warning = warning
        self.warningSubtle = warningSubtle
        self.error = error
        self.errorSubtle = errorSubtle
        self.info = info ?? accent
        self.infoSubtle = infoSubtle ?? (accentSubtle ?? (accent == LubaColors.accent ? LubaColors.accentSubtle : accent.opacity(0.12)))
        if let chartPalette, !chartPalette.isEmpty {
            self.chartPalette = chartPalette
        } else if accent == LubaColors.accent {
            self.chartPalette = LubaColors.Chart.palette
        } else {
            // Lead the stock palette with the brand accent so charts stay on-brand.
            self.chartPalette = [accent] + LubaColors.Chart.palette.dropFirst()
        }
        self.chartGrid = chartGrid
        self.chartAxisLabel = chartAxisLabel
        self.glassBorder = glassBorder
        self.glassShadow = glassShadow
    }

    public static let `default` = LubaThemeColors()

    // MARK: - Derived Roles

    /// The elevated surface role — an alias for ``surfaceSecondary``.
    public var surfaceElevated: Color { surfaceSecondary }

    /// Build a palette from a single brand accent, deriving the accent ramp,
    /// focus border, informational color, and chart lead color from it.
    ///
    /// ```swift
    /// let theme = LubaThemeConfiguration(colors: .accented(Color(hex: 0x2F5FD0)))
    /// ```
    public static func accented(
        _ accent: Color,
        hover: Color? = nil,
        subtle: Color? = nil,
        onAccent: Color = LubaColors.textOnAccent
    ) -> LubaThemeColors {
        LubaThemeColors(
            accent: accent,
            accentHover: hover,
            accentSubtle: subtle,
            textOnAccent: onAccent
        )
    }

    /// The color for a semantic status role.
    public func status(_ role: LubaStatusRole) -> Color {
        switch role {
        case .info: return info
        case .success: return success
        case .warning: return warning
        case .error: return error
        }
    }

    /// The low-emphasis background for a semantic status role.
    public func statusSubtle(_ role: LubaStatusRole) -> Color {
        switch role {
        case .info: return infoSubtle
        case .success: return successSubtle
        case .warning: return warningSubtle
        case .error: return errorSubtle
        }
    }

    /// A categorical chart color, wrapping around the palette.
    public func chartColor(at index: Int) -> Color {
        guard !chartPalette.isEmpty else { return accent }
        return chartPalette[index % chartPalette.count]
    }

    /// The first `count` chart colors, repeating the palette if needed.
    public func chartColors(count: Int) -> [Color] {
        guard count > 0 else { return [] }
        return (0..<count).map { chartColor(at: $0) }
    }
}

// MARK: - Status Role

/// A semantic status level shared by alerts, toasts, and badges.
public enum LubaStatusRole: CaseIterable, Hashable {
    case info
    case success
    case warning
    case error
}

// MARK: - Theme Typography

/// Font overrides for a ``LubaThemeConfiguration``.
///
/// All parameters are optional. Anything left `nil` resolves through
/// ``LubaTypography`` using the *effective* ``LubaConfig`` for the current
/// view subtree, so `.lubaConfig { $0.useRoundedFont = false }` still takes
/// effect under a default theme.
public struct LubaThemeTypography {

    private let overrides: [LubaTextRole: Font]

    public init(
        title: Font? = nil,
        headline: Font? = nil,
        body: Font? = nil,
        caption: Font? = nil,
        button: Font? = nil,
        largeTitle: Font? = nil,
        title2: Font? = nil,
        title3: Font? = nil,
        subheadline: Font? = nil,
        bodySmall: Font? = nil,
        caption2: Font? = nil,
        footnote: Font? = nil,
        code: Font? = nil,
        buttonSmall: Font? = nil,
        buttonLarge: Font? = nil
    ) {
        var map: [LubaTextRole: Font] = [:]
        map[.largeTitle] = largeTitle
        map[.title] = title
        map[.title2] = title2
        map[.title3] = title3
        map[.headline] = headline
        map[.subheadline] = subheadline
        map[.body] = body
        map[.bodySmall] = bodySmall
        map[.caption] = caption
        map[.caption2] = caption2
        map[.footnote] = footnote
        map[.code] = code
        map[.button] = button
        map[.buttonSmall] = buttonSmall
        map[.buttonLarge] = buttonLarge
        self.overrides = map
    }

    public static let `default` = LubaThemeTypography()

    /// Whether this theme overrides the given role.
    public func overridesRole(_ role: LubaTextRole) -> Bool {
        overrides[role] != nil
    }

    /// Resolve a text role against this theme and a configuration.
    ///
    /// Theme overrides win. Otherwise the font comes from ``LubaTypography``,
    /// which honors `useRoundedFont`, `customFontFamily`, and `useBoldText`
    /// from `config` and scales with Dynamic Type.
    public func font(_ role: LubaTextRole, config: LubaConfig = .shared) -> Font {
        overrides[role] ?? LubaTypography.font(role, config: config)
    }

    // MARK: Legacy non-optional accessors (source compatible)

    public var largeTitle: Font { font(.largeTitle) }
    public var title: Font { font(.title) }
    public var title2: Font { font(.title2) }
    public var title3: Font { font(.title3) }
    public var headline: Font { font(.headline) }
    public var subheadline: Font { font(.subheadline) }
    public var body: Font { font(.body) }
    public var bodySmall: Font { font(.bodySmall) }
    public var caption: Font { font(.caption) }
    public var caption2: Font { font(.caption2) }
    public var footnote: Font { font(.footnote) }
    public var code: Font { font(.code) }
    public var button: Font { font(.button) }
    public var buttonSmall: Font { font(.buttonSmall) }
    public var buttonLarge: Font { font(.buttonLarge) }
}

// MARK: - Theme Spacing

/// Spacing overrides for a ``LubaThemeConfiguration``.
///
/// Each property defaults to the corresponding ``LubaSpacing`` token.
public struct LubaThemeSpacing {
    public let xxs: CGFloat
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
        huge: CGFloat = LubaSpacing.huge,
        xxs: CGFloat = LubaSpacing.xxs
    ) {
        self.xxs = xxs
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

/// Corner radius overrides for a ``LubaThemeConfiguration``.
///
/// Each property defaults to the corresponding ``LubaRadius`` token.
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
    /// The current LubaUI theme configuration.
    var lubaTheme: LubaThemeConfiguration {
        get { self[LubaThemeKey.self] }
        set { self[LubaThemeKey.self] = newValue }
    }
}

// MARK: - Theme Modifier

public extension View {
    /// Apply a custom LubaUI theme to the view hierarchy.
    func lubaTheme(_ theme: LubaThemeConfiguration) -> some View {
        environment(\.lubaTheme, theme)
    }

    /// Apply a custom LubaUI color palette to the view hierarchy,
    /// keeping the inherited typography, spacing, and radius.
    func lubaTheme(colors: LubaThemeColors) -> some View {
        transformEnvironment(\.lubaTheme) { theme in
            theme = LubaThemeConfiguration(
                colors: colors,
                typography: theme.typography,
                spacing: theme.spacing,
                radius: theme.radius
            )
        }
    }
}
