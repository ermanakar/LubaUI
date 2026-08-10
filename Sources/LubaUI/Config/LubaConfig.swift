//
//  LubaConfig.swift
//  LubaUI
//
//  Central configuration for the entire design system.
//  Modify this file to customize the system for your brand.
//

import SwiftUI

// MARK: - LubaConfig

/// Central configuration for LubaUI.
/// Modify these values to customize the design system for your brand.
public struct LubaConfig: Equatable {
    
    // MARK: - Singleton
    
    /// Shared configuration instance
    public static var shared = LubaConfig()
    
    // MARK: - Brand Identity
    
    /// Your brand name (used in accessibility labels)
    public var brandName: String = "LubaUI"

    /// Primary accent color override (nil uses default sage green).
    ///
    /// - Warning: Superseded by ``LubaThemeColors``. These fields were never
    ///   consumed by components; set the accent on the theme instead:
    ///   `.lubaTheme(LubaThemeConfiguration(colors: .accented(myAccent)))`.
    @available(*, deprecated, message: "Use .lubaTheme(LubaThemeConfiguration(colors: .accented(color))) instead. This value is not read by components.")
    public var accentColorLight: Color? = nil

    /// See ``accentColorLight``.
    @available(*, deprecated, message: "Use .lubaTheme(LubaThemeConfiguration(colors: .accented(color))) instead. This value is not read by components.")
    public var accentColorDark: Color? = nil

    // MARK: - Haptics
    
    /// Enable haptic feedback globally
    public var hapticsEnabled: Bool = true
    
    /// Intensity of haptic feedback (0.0 - 1.0)
    public var hapticIntensity: CGFloat = 1.0
    
    // MARK: - Animations
    
    /// Enable animations globally
    public var animationsEnabled: Bool = true
    
    /// Respect reduced motion system setting
    public var respectReducedMotion: Bool = true
    
    /// Default animation duration multiplier
    public var animationSpeed: Double = 1.0
    
    // MARK: - Accessibility
    
    /// Minimum touch target size (Apple recommends 44pt)
    public var minimumTouchTarget: CGFloat = 44
    
    /// Enable bold text for better readability
    public var useBoldText: Bool = false
    
    /// Increase contrast for semantic colors
    public var highContrastMode: Bool = false
    
    // MARK: - Typography
    
    /// Use SF Rounded (true) or SF Pro (false)
    public var useRoundedFont: Bool = true
    
    /// Custom font family override (nil uses system)
    public var customFontFamily: String? = nil
    
    // MARK: - Component Defaults
    
    /// Default button style
    public var defaultButtonStyle: LubaButtonStyle = .primary
    
    /// Default card elevation
    public var defaultCardElevation: LubaCardElevation = .low

    /// Default corner radius.
    ///
    /// - Warning: Superseded by ``LubaThemeRadius``. Set radii on the theme:
    ///   `LubaThemeConfiguration(radius: LubaThemeRadius(md: 16))`.
    @available(*, deprecated, message: "Use LubaThemeRadius on the theme instead. This value is not read by components.")
    public var defaultCornerRadius: CGFloat = 12

    // MARK: - Debug
    
    /// Show component outlines for debugging
    public var showDebugOutlines: Bool = false
    
    /// Log accessibility warnings
    public var logA11yWarnings: Bool = false
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Convenience Methods
    
    /// Apply a custom accent color.
    ///
    /// - Warning: Superseded by ``LubaThemeColors/accented(_:hover:subtle:onAccent:)``.
    @available(*, deprecated, message: "Use .lubaTheme(LubaThemeConfiguration(colors: .accented(color))) instead.")
    public mutating func setAccentColor(light: Color, dark: Color) {
        accentColorLight = light
        accentColorDark = dark
    }

    /// Apply animation speed multiplier to any animation.
    /// Returns nil when animations are disabled.
    ///
    /// - Note: This does not know about the system Reduce Motion setting.
    ///   Inside a view, prefer ``LubaContext/motion``, which does.
    public func animation(_ base: Animation = LubaAnimations.standard) -> Animation? {
        guard animationsEnabled else { return nil }
        return animationSpeed == 1.0 ? base : base.speed(1.0 / animationSpeed)
    }

    /// The motion policy implied by this configuration and a system Reduce Motion value.
    public func motionPolicy(systemReduceMotion: Bool) -> LubaMotionPolicy {
        LubaMotionPolicy(config: self, systemReduceMotion: systemReduceMotion)
    }

    /// Disable all animations
    public mutating func disableAnimations() {
        animationsEnabled = false
        hapticsEnabled = false
    }
    
    /// Enable high accessibility mode
    public mutating func enableHighAccessibility() {
        highContrastMode = true
        useBoldText = true
        minimumTouchTarget = 48
    }
}

// MARK: - Environment Key

private struct LubaConfigKey: EnvironmentKey {
    /// Computed, not stored: `LubaConfig.shared` is the *global fallback*, and a
    /// stored default would freeze whatever value existed at first environment
    /// access. Any `.lubaConfig(…)` in the hierarchy overrides this.
    static var defaultValue: LubaConfig { LubaConfig.shared }
}

public extension EnvironmentValues {
    /// The configuration in effect for this view subtree.
    ///
    /// Precedence: the nearest `.lubaConfig(…)` ancestor wins; with no ancestor,
    /// the value falls back to `LubaConfig.shared`.
    var lubaConfig: LubaConfig {
        get { self[LubaConfigKey.self] }
        set { self[LubaConfigKey.self] = newValue }
    }
}

// MARK: - View Extension

public extension View {
    /// Apply a custom LubaUI configuration to this view hierarchy.
    func lubaConfig(_ config: LubaConfig) -> some View {
        environment(\.lubaConfig, config)
    }
    
    /// Customize LubaUI configuration inline.
    ///
    /// The closure receives the configuration *inherited from the enclosing
    /// subtree*, so nested calls compose instead of resetting to the global
    /// defaults.
    func lubaConfig(_ configure: @escaping (inout LubaConfig) -> Void) -> some View {
        transformEnvironment(\.lubaConfig) { config in
            configure(&config)
        }
    }
}

// MARK: - Quick Configuration Presets

public extension LubaConfig {
    /// Minimal, reduced motion configuration
    static var minimal: LubaConfig {
        var config = LubaConfig()
        config.animationsEnabled = false
        config.hapticsEnabled = false
        return config
    }
    
    /// High accessibility configuration
    static var accessible: LubaConfig {
        var config = LubaConfig()
        config.highContrastMode = true
        config.useBoldText = true
        config.minimumTouchTarget = 48
        return config
    }
    
    /// Debug configuration
    static var debug: LubaConfig {
        var config = LubaConfig()
        config.showDebugOutlines = true
        config.logA11yWarnings = true
        return config
    }
}
