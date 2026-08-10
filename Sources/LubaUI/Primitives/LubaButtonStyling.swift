//
//  LubaButtonStyling.swift
//  LubaUI
//
//  Protocol-based button styling system.
//  Each style is a complete, cohesive definition — not scattered switch statements.
//
//  To add a new style:
//  1. Create a struct conforming to LubaButtonStyling
//  2. Define its colors for each state
//  3. Use it: LubaButton("Action", styling: MyCustomStyle()) { }
//

import SwiftUI

// MARK: - Styling Context

/// Everything a button style needs to pick its colors.
///
/// Passed to the theme-aware members of ``LubaButtonStyling``, so a custom style
/// can honor the active ``LubaThemeColors`` instead of hard-coding a palette.
public struct LubaButtonStyleContext {
    /// Whether the button is currently pressed.
    public let isPressed: Bool

    /// The active color scheme.
    public let colorScheme: ColorScheme

    /// The semantic colors for the button's view subtree.
    public let colors: LubaThemeColors

    public init(isPressed: Bool, colorScheme: ColorScheme, colors: LubaThemeColors = .default) {
        self.isPressed = isPressed
        self.colorScheme = colorScheme
        self.colors = colors
    }
}

// MARK: - Button Styling Protocol

/// Defines the visual appearance of a button.
///
/// Implement this protocol to create custom button styles. Use the `styling:` parameter
/// on ``LubaButton`` to apply your custom style.
///
/// ```swift
/// struct BrandStyle: LubaButtonStyling {
///     func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color { .white }
///     func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
///         isPressed ? .blue.opacity(0.8) : .blue
///     }
///     func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? { nil }
/// }
///
/// LubaButton("Continue", styling: BrandStyle()) { }
/// ```
///
/// ## Theme-aware styles
///
/// The `in context:` members receive the active ``LubaThemeColors``. Implement
/// those to follow the app's theme:
///
/// ```swift
/// struct BrandStyle: LubaButtonStyling {
///     func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
///         foregroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
///     }
///     func foregroundColor(in context: LubaButtonStyleContext) -> Color { context.colors.textOnAccent }
///     // …
/// }
/// ```
///
/// Styles that implement only the legacy members keep working unchanged — the
/// context-based members default to forwarding to them.
///
/// See <doc:CustomizingButtonStyles> for a full guide.
public protocol LubaButtonStyling {
    /// Foreground (text/icon) color
    func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color

    /// Background color
    func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color

    /// Border color, if any
    func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color?

    /// Theme-aware foreground color. Defaults to the legacy member.
    func foregroundColor(in context: LubaButtonStyleContext) -> Color

    /// Theme-aware background color. Defaults to the legacy member.
    func backgroundColor(in context: LubaButtonStyleContext) -> Color

    /// Theme-aware border color. Defaults to the legacy member.
    func borderColor(in context: LubaButtonStyleContext) -> Color?

    /// Border width (default: 1)
    var borderWidth: CGFloat { get }

    /// Whether this style should be full-width by default
    var defaultsToFullWidth: Bool { get }

    /// The haptic feedback for this style
    var haptic: LubaHapticStyle { get }
}

// Default implementations
public extension LubaButtonStyling {
    var borderWidth: CGFloat { 1 }
    var defaultsToFullWidth: Bool { false }
    var haptic: LubaHapticStyle { .light }

    func foregroundColor(in context: LubaButtonStyleContext) -> Color {
        foregroundColor(isPressed: context.isPressed, colorScheme: context.colorScheme)
    }

    func backgroundColor(in context: LubaButtonStyleContext) -> Color {
        backgroundColor(isPressed: context.isPressed, colorScheme: context.colorScheme)
    }

    func borderColor(in context: LubaButtonStyleContext) -> Color? {
        borderColor(isPressed: context.isPressed, colorScheme: context.colorScheme)
    }
}

// MARK: - Built-in Styles

/// Primary button: filled accent background, prominent
public struct LubaPrimaryStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        foregroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        backgroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public func foregroundColor(in context: LubaButtonStyleContext) -> Color {
        context.colors.textOnAccent
    }

    public func backgroundColor(in context: LubaButtonStyleContext) -> Color {
        context.isPressed ? context.colors.accentHover : context.colors.accent
    }

    public func borderColor(in context: LubaButtonStyleContext) -> Color? {
        nil
    }

    public var defaultsToFullWidth: Bool { true }
    public var haptic: LubaHapticStyle { .medium }
}

/// Secondary button: bordered, surface background
public struct LubaSecondaryStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        foregroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        backgroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        borderColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func foregroundColor(in context: LubaButtonStyleContext) -> Color {
        context.colors.textPrimary
    }

    public func backgroundColor(in context: LubaButtonStyleContext) -> Color {
        context.isPressed ? context.colors.surfaceHover : context.colors.surface
    }

    public func borderColor(in context: LubaButtonStyleContext) -> Color? {
        context.isPressed ? context.colors.borderStrong : context.colors.border
    }

    public var haptic: LubaHapticStyle { .light }
}

/// Ghost button: text only, minimal presence
public struct LubaGhostStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        foregroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        backgroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public func foregroundColor(in context: LubaButtonStyleContext) -> Color {
        context.isPressed ? context.colors.accentHover : context.colors.accent
    }

    public func backgroundColor(in context: LubaButtonStyleContext) -> Color {
        context.isPressed ? context.colors.accentSubtle : .clear
    }

    public func borderColor(in context: LubaButtonStyleContext) -> Color? {
        nil
    }

    public var haptic: LubaHapticStyle { .soft }
}

/// Destructive button: for dangerous actions
public struct LubaDestructiveStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        .white
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        backgroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public func foregroundColor(in context: LubaButtonStyleContext) -> Color {
        .white
    }

    public func backgroundColor(in context: LubaButtonStyleContext) -> Color {
        let base = context.colors.error
        return context.isPressed ? base.opacity(0.85) : base
    }

    public func borderColor(in context: LubaButtonStyleContext) -> Color? {
        nil
    }

    public var defaultsToFullWidth: Bool { true }
    public var haptic: LubaHapticStyle { .warning }
}

/// Subtle button: minimal, for secondary actions
public struct LubaSubtleStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        foregroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        backgroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public func foregroundColor(in context: LubaButtonStyleContext) -> Color {
        context.isPressed ? context.colors.textPrimary : context.colors.textSecondary
    }

    public func backgroundColor(in context: LubaButtonStyleContext) -> Color {
        context.isPressed ? context.colors.surfaceHover : .clear
    }

    public func borderColor(in context: LubaButtonStyleContext) -> Color? {
        nil
    }

    public var haptic: LubaHapticStyle { .soft }
}

/// Glass button: translucent glass background for overlay contexts
public struct LubaGlassButtonStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        foregroundColor(in: LubaButtonStyleContext(isPressed: isPressed, colorScheme: colorScheme))
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        // Glass modifier handles the visual background; use clear here
        .clear
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public func foregroundColor(in context: LubaButtonStyleContext) -> Color {
        context.colorScheme == .dark ? .white : context.colors.textPrimary
    }

    public func backgroundColor(in context: LubaButtonStyleContext) -> Color {
        .clear
    }

    public func borderColor(in context: LubaButtonStyleContext) -> Color? {
        nil
    }

    public var haptic: LubaHapticStyle { .light }
}

// MARK: - Style Enum (Convenience)

/// Convenience enum wrapping the built-in styles.
/// Use this for quick access, or use the structs directly for type safety.
public enum LubaButtonStyleType {
    case primary
    case secondary
    case ghost
    case destructive
    case subtle
    case glass

    public var styling: any LubaButtonStyling {
        switch self {
        case .primary: return LubaPrimaryStyle()
        case .secondary: return LubaSecondaryStyle()
        case .ghost: return LubaGhostStyle()
        case .destructive: return LubaDestructiveStyle()
        case .subtle: return LubaSubtleStyle()
        case .glass: return LubaGlassButtonStyle()
        }
    }
}
