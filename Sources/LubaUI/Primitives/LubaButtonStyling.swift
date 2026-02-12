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

// MARK: - Button Styling Protocol

/// Defines the visual appearance of a button.
/// Implement this to create custom button styles.
public protocol LubaButtonStyling {
    /// Foreground (text/icon) color
    func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color

    /// Background color
    func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color

    /// Border color, if any
    func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color?

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
}

// MARK: - Built-in Styles

/// Primary button: filled accent background, prominent
public struct LubaPrimaryStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        LubaColors.textOnAccent
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.accentHover : LubaColors.accent
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public var defaultsToFullWidth: Bool { true }
    public var haptic: LubaHapticStyle { .medium }
}

/// Secondary button: bordered, surface background
public struct LubaSecondaryStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        LubaColors.textPrimary
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.gray100 : LubaColors.surface
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        isPressed ? LubaColors.gray400 : LubaColors.border
    }

    public var haptic: LubaHapticStyle { .light }
}

/// Ghost button: text only, minimal presence
public struct LubaGhostStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.accentHover : LubaColors.accent
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.accentSubtle : .clear
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
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
        let base = LubaColors.error
        return isPressed ? base.opacity(0.85) : base
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public var defaultsToFullWidth: Bool { true }
    public var haptic: LubaHapticStyle { .warning }
}

/// Subtle button: minimal, for secondary actions
public struct LubaSubtleStyle: LubaButtonStyling {
    public init() {}

    public func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.textPrimary : LubaColors.textSecondary
    }

    public func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.gray100 : .clear
    }

    public func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    public var haptic: LubaHapticStyle { .soft }
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

    public var styling: any LubaButtonStyling {
        switch self {
        case .primary: return LubaPrimaryStyle()
        case .secondary: return LubaSecondaryStyle()
        case .ghost: return LubaGhostStyle()
        case .destructive: return LubaDestructiveStyle()
        case .subtle: return LubaSubtleStyle()
        }
    }
}
