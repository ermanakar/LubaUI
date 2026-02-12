//
//  LubaAccessibility.swift
//  LubaUI
//
//  Accessibility utilities and enforcement.
//

import SwiftUI

// MARK: - Accessibility Label Protocol

/// Protocol for components that require accessibility labels.
public protocol LubaAccessible {
    /// The accessibility label for this component
    var accessibilityLabel: String { get }
    
    /// The accessibility hint (optional)
    var accessibilityHint: String? { get }
}

public extension LubaAccessible {
    var accessibilityHint: String? { nil }
}

// MARK: - Accessibility Modifiers

public extension View {
    /// Apply standard LubaUI accessibility configuration.
    func lubaAccessible(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = []
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }
    
    /// Mark as a button for accessibility.
    func lubaAccessibleButton(_ label: String, hint: String? = nil) -> some View {
        lubaAccessible(label: label, hint: hint, traits: .isButton)
    }
    
    /// Mark as a header for accessibility.
    func lubaAccessibleHeader(_ label: String) -> some View {
        lubaAccessible(label: label, traits: .isHeader)
    }
    
    /// Ensure minimum touch target size.
    func lubaMinTouchTarget() -> some View {
        self.frame(
            minWidth: LubaConfig.shared.minimumTouchTarget,
            minHeight: LubaConfig.shared.minimumTouchTarget
        )
    }
}

// MARK: - Reduced Motion

/// Utilities for respecting the user's reduced motion preference.
///
/// For SwiftUI views, prefer reading `@Environment(\.accessibilityReduceMotion)` directly.
/// Use these helpers in non-View contexts or when you need a quick config check.
public enum LubaReducedMotion {
    /// Returns the animation if animations are enabled in LubaConfig, otherwise nil.
    /// Components should also check `@Environment(\.accessibilityReduceMotion)` in views.
    public static func animation(_ animation: Animation) -> Animation? {
        LubaConfig.shared.animationsEnabled ? animation : nil
    }

    /// A safe, minimal animation that respects config settings.
    /// Falls back to a quick ease-out when animations are enabled, nil otherwise.
    public static var safe: Animation? {
        LubaConfig.shared.animationsEnabled ? .easeOut(duration: 0.2) : nil
    }
}

// MARK: - Accessibility Announcements

public struct LubaAnnounce {
    /// Announce a message to VoiceOver
    public static func message(_ text: String) {
        #if os(iOS)
        UIAccessibility.post(notification: .announcement, argument: text)
        #endif
    }
    
    /// Announce a screen change
    public static func screenChanged(_ text: String? = nil) {
        #if os(iOS)
        UIAccessibility.post(notification: .screenChanged, argument: text)
        #endif
    }
    
    /// Announce a layout change
    public static func layoutChanged(_ element: Any? = nil) {
        #if os(iOS)
        UIAccessibility.post(notification: .layoutChanged, argument: element)
        #endif
    }
}

// MARK: - Focus Management

public extension View {
    /// Mark this element for accessibility focus.
    /// Note: Focus management should be handled by the system in most cases.
    @ViewBuilder
    func lubaAccessibilityFocusable() -> some View {
        self.accessibilityElement(children: .contain)
    }
}

// MARK: - Contrast Checker

/// WCAG 2.1 contrast ratio checking.
///
/// Usage:
/// ```swift
/// let ratio = LubaContrast.contrastRatio(foreground: .white, background: .black) // 21.0
/// let passes = LubaContrast.meetsAA(foreground: LubaColors.textPrimary, background: LubaColors.background)
/// ```
public enum LubaContrast {
    /// Calculate the contrast ratio between two colors (1:1 to 21:1).
    public static func contrastRatio(foreground: Color, background: Color) -> Double {
        let fgLum = relativeLuminance(of: foreground)
        let bgLum = relativeLuminance(of: background)
        let lighter = max(fgLum, bgLum)
        let darker = min(fgLum, bgLum)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// Check if two colors meet WCAG AA contrast ratio (4.5:1 for normal text, 3:1 for large text).
    public static func meetsAA(foreground: Color, background: Color, largeText: Bool = false) -> Bool {
        contrastRatio(foreground: foreground, background: background) >= (largeText ? 3.0 : 4.5)
    }

    /// Check if two colors meet WCAG AAA contrast ratio (7:1 for normal text, 4.5:1 for large text).
    public static func meetsAAA(foreground: Color, background: Color, largeText: Bool = false) -> Bool {
        contrastRatio(foreground: foreground, background: background) >= (largeText ? 4.5 : 7.0)
    }

    /// Calculate relative luminance per WCAG 2.1.
    /// https://www.w3.org/TR/WCAG21/#dfn-relative-luminance
    private static func relativeLuminance(of color: Color) -> Double {
        #if canImport(UIKit)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        #elseif canImport(AppKit)
        let nsColor = NSColor(color).usingColorSpace(.sRGB) ?? NSColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        #else
        // Fallback: assume mid-gray
        return 0.2
        #endif
        let rLinear = linearize(Double(r))
        let gLinear = linearize(Double(g))
        let bLinear = linearize(Double(b))
        return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear
    }

    /// Linearize an sRGB channel value per WCAG 2.1.
    private static func linearize(_ value: Double) -> Double {
        value <= 0.04045
            ? value / 12.92
            : pow((value + 0.055) / 1.055, 2.4)
    }
}

// MARK: - A11y Debug View

/// Debug overlay showing accessibility information
public struct LubaA11yDebugView: View {
    let label: String
    let traits: [String]
    
    public init(label: String, traits: [String] = []) {
        self.label = label
        self.traits = traits
    }
    
    public var body: some View {
        if LubaConfig.shared.showDebugOutlines {
            VStack(alignment: .leading, spacing: 2) {
                Text("A11y: \(label)")
                    .font(.system(size: 8, design: .monospaced))
                
                if !traits.isEmpty {
                    Text(traits.joined(separator: ", "))
                        .font(.system(size: 7, design: .monospaced))
                }
            }
            .padding(2)
            .background(Color.purple.opacity(0.3))
            .foregroundStyle(.purple)
        }
    }
}
