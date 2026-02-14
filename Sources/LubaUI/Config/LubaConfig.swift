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
public struct LubaConfig {
    
    // MARK: - Singleton
    
    /// Shared configuration instance
    public static var shared = LubaConfig()
    
    // MARK: - Brand Identity
    
    /// Your brand name (used in accessibility labels)
    public var brandName: String = "LubaUI"
    
    /// Primary accent color override (nil uses default sage green)
    public var accentColorLight: Color? = nil
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
    
    /// Default corner radius
    public var defaultCornerRadius: CGFloat = 12
    
    // MARK: - Debug
    
    /// Show component outlines for debugging
    public var showDebugOutlines: Bool = false
    
    /// Log accessibility warnings
    public var logA11yWarnings: Bool = false
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Convenience Methods
    
    /// Apply a custom accent color
    public mutating func setAccentColor(light: Color, dark: Color) {
        accentColorLight = light
        accentColorDark = dark
    }
    
    /// Apply animation speed multiplier to any animation.
    /// Returns nil when animations are disabled.
    public func animation(_ base: Animation = LubaAnimations.standard) -> Animation? {
        guard animationsEnabled else { return nil }
        return animationSpeed == 1.0 ? base : base.speed(1.0 / animationSpeed)
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
    static let defaultValue = LubaConfig.shared
}

public extension EnvironmentValues {
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
    func lubaConfig(_ configure: (inout LubaConfig) -> Void) -> some View {
        var config = LubaConfig.shared
        configure(&config)
        return environment(\.lubaConfig, config)
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
