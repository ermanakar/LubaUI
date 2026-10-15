//
//  LubaTypography.swift
//  LubaUI
//
//  Typography system using SF Rounded — friendly, premium, highly legible.
//
//  Every token is expressed *relative to an Apple text style* so it scales
//  with Dynamic Type. Custom font families use `Font.custom(_:size:relativeTo:)`,
//  which keeps the authored point size at the default content size while still
//  scaling. System fonts use `Font.system(_:design:weight:)`, which is the only
//  system-font API that participates in Dynamic Type.
//

import SwiftUI

// MARK: - Text Role

/// A semantic text role in LubaUI's type scale.
///
/// Roles — not point sizes — are what components and themes talk about.
/// Each role maps to an Apple text style so it scales with Dynamic Type,
/// plus a nominal point size used when a custom font family is configured.
public enum LubaTextRole: CaseIterable, Hashable {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case subheadline
    case body
    case bodySmall
    case caption
    case caption2
    case footnote
    case code
    case button
    case buttonSmall
    case buttonLarge

    /// The Apple text style this role scales with.
    public var textStyle: Font.TextStyle {
        switch self {
        case .largeTitle:   return .largeTitle
        case .title:        return .title
        case .title2:       return .title3
        case .title3:       return .headline
        case .headline:     return .callout
        case .subheadline:  return .subheadline
        case .body:         return .callout
        case .bodySmall:    return .subheadline
        case .caption:      return .caption
        case .caption2:     return .caption2
        case .footnote:     return .footnote
        case .code:         return .footnote
        case .button:       return .subheadline
        case .buttonSmall:  return .footnote
        case .buttonLarge:  return .body
        }
    }

    /// The nominal point size at the default (Large) content size.
    ///
    /// Used for custom font families, which are sized explicitly and scaled
    /// relative to ``textStyle``.
    public var nominalSize: CGFloat {
        switch self {
        case .largeTitle:   return 34
        case .title:        return 28
        case .title2:       return 20
        case .title3:       return 17
        case .headline:     return 16
        case .subheadline:  return 15
        case .body:         return 16
        case .bodySmall:    return 15
        case .caption:      return 12
        case .caption2:     return 11
        case .footnote:     return 13
        case .code:         return 13
        case .button:       return 15
        case .buttonSmall:  return 13
        case .buttonLarge:  return 17
        }
    }

    /// The authored weight for this role.
    public var weight: Font.Weight {
        switch self {
        case .largeTitle, .title:                       return .bold
        case .title2, .title3, .headline:               return .semibold
        case .button, .buttonSmall, .buttonLarge:       return .semibold
        case .subheadline:                              return .medium
        case .body, .bodySmall, .caption, .caption2,
             .footnote, .code:                          return .regular
        }
    }

    /// The authored design for this role.
    public var design: Font.Design {
        self == .code ? .monospaced : .rounded
    }
}

// MARK: - Typography Tokens

/// LubaUI's typography system.
/// Uses SF Rounded for a friendly, approachable, premium feel.
///
/// **Hierarchy guide — choosing the right role:**
///
/// Display tier (large, bold — structural headings):
///   `largeTitle` → `title` → `title2` → `title3`
///
/// Content tier (regular weight — running text):
///   `body` → `bodySmall` → `caption` → `caption2`
///
/// Supporting tier (specialized roles):
///   `headline` — inline emphasis, same size as `body`
///   `subheadline` — supporting labels, same size as `bodySmall`
///   `footnote` — attributions, helper text
///   `code` — monospaced code snippets
///
/// ## Dynamic Type
///
/// Every token scales. The point sizes documented on ``LubaTextRole/nominalSize``
/// are the sizes at the default content size only; at larger accessibility sizes
/// the whole scale grows with the user's setting.
///
/// ## Configuration
///
/// The static properties resolve against `LubaConfig.shared`. Inside a view,
/// prefer the environment-resolved fonts so subtree configuration applies:
///
/// ```swift
/// @LubaEnvironment private var luba
/// Text("Hello").font(luba.fonts.body)
/// ```
public enum LubaTypography {

    // MARK: - Font Resolution

    /// Resolve a semantic text role into a Dynamic Type-aware font.
    ///
    /// - Parameters:
    ///   - role: The semantic role to resolve.
    ///   - config: The configuration supplying `useRoundedFont`,
    ///     `customFontFamily`, and `useBoldText`.
    public static func font(_ role: LubaTextRole, config: LubaConfig = .shared) -> Font {
        resolve(
            textStyle: role.textStyle,
            size: role.nominalSize,
            weight: role.weight,
            design: role.design,
            config: config
        )
    }

    private static func resolve(
        textStyle: Font.TextStyle,
        size: CGFloat,
        weight: Font.Weight,
        design: Font.Design,
        config: LubaConfig
    ) -> Font {
        let resolvedWeight = accessibleWeight(weight, config: config)

        // Monospaced is always preserved — code must stay code.
        if design != .monospaced, let family = config.customFontFamily {
            return Font.custom(family, size: size, relativeTo: textStyle).weight(resolvedWeight)
        }

        let resolvedDesign: Font.Design = design == .monospaced
            ? .monospaced
            : (config.useRoundedFont ? .rounded : .default)

        return Font.system(textStyle, design: resolvedDesign, weight: resolvedWeight)
    }

    /// Bump weight one step when `useBoldText` is on, for readability.
    private static func accessibleWeight(_ weight: Font.Weight, config: LubaConfig) -> Font.Weight {
        guard config.useBoldText else { return weight }
        switch weight {
        case .regular: return .medium
        case .medium: return .semibold
        case .semibold: return .bold
        case .bold: return .heavy
        default: return weight
        }
    }

    // MARK: - Custom

    /// Config-aware font at an explicit point size, for **glyph-locked**
    /// decoration that named roles don't cover.
    ///
    /// Use this for marks whose size is dictated by the geometry around them —
    /// an SF Symbol inside a fixed-size frame, initials sized from an avatar's
    /// diameter, the label inside a progress ring. Running text should use a
    /// ``LubaTextRole`` instead, so it scales with Dynamic Type.
    ///
    /// The requested `size` is always honored. Scaling is only possible when a
    /// custom font family is configured, because `Font.system(size:weight:design:)`
    /// — the only system-font API that takes an exact size — does not
    /// participate in Dynamic Type. Passing `relativeTo:` therefore opts a
    /// *custom-family* font into scaling and has no effect on system fonts.
    ///
    /// - Parameters:
    ///   - size: The point size. Always honored.
    ///   - weight: The font weight.
    ///   - design: The font design. `.monospaced` is always preserved.
    ///   - textStyle: For custom font families only, the text style to scale
    ///     with. `nil` (the default) keeps the size fixed.
    ///   - config: The configuration to resolve against.
    public static func custom(
        size: CGFloat,
        weight: Font.Weight,
        design: Font.Design = .rounded,
        relativeTo textStyle: Font.TextStyle? = nil,
        config: LubaConfig = .shared
    ) -> Font {
        let resolvedWeight = accessibleWeight(weight, config: config)
        let resolvedDesign: Font.Design = design == .monospaced
            ? .monospaced
            : (config.useRoundedFont ? .rounded : .default)

        // Monospaced is always preserved — code must stay code.
        if design != .monospaced, let family = config.customFontFamily {
            let font = textStyle.map { Font.custom(family, size: size, relativeTo: $0) }
                ?? Font.custom(family, fixedSize: size)
            return font.weight(resolvedWeight)
        }

        return .system(size: size, weight: resolvedWeight, design: resolvedDesign)
    }

    // MARK: - Display

    /// Large display text for hero sections. Scales from `.largeTitle` (34pt).
    public static var largeTitle: Font { font(.largeTitle) }

    /// Primary title for screens and sections. Scales from `.title` (28pt).
    public static var title: Font { font(.title) }

    /// Secondary title for subsections. Scales from `.title3` (20pt).
    public static var title2: Font { font(.title2) }

    /// Tertiary title for cards and groups. Scales from `.headline` (17pt).
    public static var title3: Font { font(.title3) }

    // MARK: - Headings

    /// Headline for emphasized inline content. Scales from `.callout` (16pt).
    public static var headline: Font { font(.headline) }

    /// Subheadline for supporting content. Scales from `.subheadline` (15pt).
    public static var subheadline: Font { font(.subheadline) }

    // MARK: - Body

    /// Primary body text. Scales from `.callout` (16pt).
    public static var body: Font { font(.body) }

    /// Secondary body text. Scales from `.subheadline` (15pt).
    public static var bodySmall: Font { font(.bodySmall) }

    // MARK: - Supporting

    /// Caption text for labels and metadata. Scales from `.caption` (12pt).
    public static var caption: Font { font(.caption) }

    /// Small caption for fine print. Scales from `.caption2` (11pt).
    public static var caption2: Font { font(.caption2) }

    /// Footnote for attributions. Scales from `.footnote` (13pt).
    public static var footnote: Font { font(.footnote) }

    // MARK: - Special

    /// Monospaced font for code. Scales from `.footnote` (13pt).
    public static var code: Font { font(.code) }

    /// Button text. Scales from `.subheadline` (15pt).
    public static var button: Font { font(.button) }

    /// Small button text. Scales from `.footnote` (13pt).
    public static var buttonSmall: Font { font(.buttonSmall) }

    /// Large button text. Scales from `.body` (17pt).
    public static var buttonLarge: Font { font(.buttonLarge) }
}

// MARK: - Resolved Font Set

/// The fonts for a view subtree, resolved from the active theme and configuration.
///
/// Obtained from ``LubaContext/fonts``:
///
/// ```swift
/// @LubaEnvironment private var luba
/// Text("Title").font(luba.fonts.title)
/// ```
public struct LubaFontSet {
    private let typography: LubaThemeTypography
    private let config: LubaConfig

    public init(typography: LubaThemeTypography, config: LubaConfig) {
        self.typography = typography
        self.config = config
    }

    /// Resolve any role.
    public func callAsFunction(_ role: LubaTextRole) -> Font {
        typography.font(role, config: config)
    }

    /// Resolve any role.
    public func font(_ role: LubaTextRole) -> Font {
        typography.font(role, config: config)
    }

    /// A font at an explicit point size, for glyph-locked decoration.
    ///
    /// Running text should use a ``LubaTextRole`` so it scales with Dynamic Type.
    /// See ``LubaTypography/custom(size:weight:design:relativeTo:config:)``.
    public func custom(
        size: CGFloat,
        weight: Font.Weight,
        design: Font.Design = .rounded,
        relativeTo textStyle: Font.TextStyle? = nil
    ) -> Font {
        LubaTypography.custom(
            size: size,
            weight: weight,
            design: design,
            relativeTo: textStyle,
            config: config
        )
    }

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
