//
//  LubaColors.swift
//  LubaUI
//
//  A refined, greyscale-first color system with organic warmth.
//  Inspired by Notion and Apple — minimalist, understated, premium.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Color Tokens

/// LubaUI's semantic color system.
/// Greyscale-first design with a subtle sage accent.
public enum LubaColors {
    
    // MARK: - Greyscale (The Heroes)
    
    /// Pure black for maximum contrast
    public static let black = Color(hex: 0x000000)
    
    /// Near-black for primary text
    /// Light: #1A1A1A, Dark: #F5F5F5 (increased brightness for better readability)
    public static let gray900 = adaptive(
        light: Color(hex: 0x1A1A1A),
        dark: Color(hex: 0xF5F5F5)
    )
    
    /// Dark gray for headings
    /// Light: #2E2E2E, Dark: #E5E5E5
    public static let gray800 = adaptive(
        light: Color(hex: 0x2E2E2E),
        dark: Color(hex: 0xE5E5E5)
    )
    
    /// Medium-dark gray for secondary text
    /// Light: #525252, Dark: #B3B3B3 (brighter for dark mode)
    public static let gray600 = adaptive(
        light: Color(hex: 0x525252),
        dark: Color(hex: 0xB3B3B3)
    )
    
    /// Medium gray for placeholders/tertiary
    /// Light: #737373, Dark: #8A8A8A (now adaptive for better visibility)
    public static let gray500 = adaptive(
        light: Color(hex: 0x737373),
        dark: Color(hex: 0x8A8A8A)
    )
    
    /// Light gray for disabled states
    /// Light: #A3A3A3, Dark: #5C5C5C
    public static let gray400 = adaptive(
        light: Color(hex: 0xA3A3A3),
        dark: Color(hex: 0x5C5C5C)
    )
    
    /// Subtle gray for borders
    /// Light: #E5E5E5, Dark: #333333 (slightly brighter for visibility)
    public static let gray200 = adaptive(
        light: Color(hex: 0xE5E5E5),
        dark: Color(hex: 0x333333)
    )
    
    /// Very light gray for hover states / subtle backgrounds
    /// Light: #F5F5F5, Dark: #1C1C1C
    public static let gray100 = adaptive(
        light: Color(hex: 0xF5F5F5),
        dark: Color(hex: 0x1C1C1C)
    )
    
    /// Off-white for subtle backgrounds
    /// Light: #FAFAFA, Dark: #161616
    public static let gray50 = adaptive(
        light: Color(hex: 0xFAFAFA),
        dark: Color(hex: 0x161616)
    )
    
    /// Pure white
    public static let white = Color.white
    
    // MARK: - Backgrounds
    
    /// Main background — warm off-white / rich black
    /// Light: #FAFAFA, Dark: #0D0D0D (slightly lifted from pure black)
    public static let background = adaptive(
        light: Color(hex: 0xFAFAFA),
        dark: Color(hex: 0x0D0D0D)
    )
    
    /// Surface color for cards — floats above background
    /// Light: #FFFFFF, Dark: #171717 (clear elevation from background)
    public static let surface = adaptive(
        light: Color.white,
        dark: Color(hex: 0x171717)
    )
    
    /// Secondary surface for nested elements
    /// Light: #F5F5F5, Dark: #212121 (clear step up from surface)
    public static let surfaceSecondary = adaptive(
        light: Color(hex: 0xF5F5F5),
        dark: Color(hex: 0x212121)
    )
    
    /// Tertiary surface for deeply nested elements
    /// Light: #EFEFEF, Dark: #2A2A2A
    public static let surfaceTertiary = adaptive(
        light: Color(hex: 0xEFEFEF),
        dark: Color(hex: 0x2A2A2A)
    )
    
    // MARK: - Accent (Sage Green — Organic, Understated)
    
    /// Primary accent — sage green (WCAG AA compliant: ≥4.5:1 on #FAFAFA and with white text)
    /// Light: #5F7360, Dark: #9AB897 (brighter for dark backgrounds)
    public static let accent = adaptive(
        light: Color(hex: 0x5F7360),
        dark: Color(hex: 0x9AB897)
    )

    /// Accent hover/pressed state
    /// Light: #506350, Dark: #AAC8A7
    public static let accentHover = adaptive(
        light: Color(hex: 0x506350),
        dark: Color(hex: 0xAAC8A7)
    )
    
    /// Subtle accent background
    /// Light: #EDF2EC, Dark: #1D261D (richer green tint)
    public static let accentSubtle = adaptive(
        light: Color(hex: 0xEDF2EC),
        dark: Color(hex: 0x1D261D)
    )
    
    // MARK: - Text
    
    /// Primary text — high contrast
    /// Light: #1A1A1A, Dark: #F5F5F5
    public static let textPrimary = gray900
    
    /// Secondary text — for descriptions
    /// Light: #525252, Dark: #B3B3B3
    public static let textSecondary = gray600
    
    /// Tertiary text — placeholders, hints
    /// Light: #737373, Dark: #8A8A8A
    public static let textTertiary = gray500
    
    /// Disabled text
    /// Light: #A3A3A3, Dark: #5C5C5C
    public static let textDisabled = gray400
    
    /// Text/icon color when placed on the accent background.
    /// Ensures legible contrast in both light and dark modes.
    /// Light: white, Dark: #1A1A1A
    public static let textOnAccent = adaptive(
        light: Color.white,
        dark: Color(hex: 0x1A1A1A)
    )
    
    // MARK: - Semantic
    
    /// Success — muted green
    /// Light: #4A7C59, Dark: #7CB88D (brighter for visibility)
    public static let success = adaptive(
        light: Color(hex: 0x4A7C59),
        dark: Color(hex: 0x7CB88D)
    )
    
    /// Warning — warm amber
    /// Light: #B8860B, Dark: #E0A832 (brighter for visibility)
    public static let warning = adaptive(
        light: Color(hex: 0xB8860B),
        dark: Color(hex: 0xE0A832)
    )
    
    /// Error — muted red
    /// Light: #B54A4A, Dark: #E07A7A (brighter for visibility)
    public static let error = adaptive(
        light: Color(hex: 0xB54A4A),
        dark: Color(hex: 0xE07A7A)
    )
    
    // MARK: - Semantic Subtle Backgrounds

    /// Subtle success background
    /// Light: #EFF6F0, Dark: #1A251B
    public static let successSubtle = adaptive(
        light: Color(hex: 0xEFF6F0),
        dark: Color(hex: 0x1A251B)
    )

    /// Subtle warning background
    /// Light: #FDF6E7, Dark: #252016
    public static let warningSubtle = adaptive(
        light: Color(hex: 0xFDF6E7),
        dark: Color(hex: 0x252016)
    )

    /// Subtle error background
    /// Light: #FAEFEF, Dark: #251A1A
    public static let errorSubtle = adaptive(
        light: Color(hex: 0xFAEFEF),
        dark: Color(hex: 0x251A1A)
    )

    // MARK: - Border
    
    /// Default border — subtle but visible
    /// Light: #E5E5E5, Dark: #333333
    public static let border = gray200
    
    /// Focused border — uses accent
    public static let borderFocused = accent
    
    // MARK: - Legacy Aliases (For Compatibility)
    
    public static let navy900 = gray900
    public static let navy700 = gray800
    public static let navy500 = gray600
    public static let accentBlue = accent
    public static let accentGold = accent
    
    // MARK: - Adaptive Color Helper
    
    /// Creates an adaptive color that switches between light and dark values
    public static func adaptive(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        return Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #elseif canImport(AppKit)
        return Color(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .vibrantDark]) != nil
                ? NSColor(dark)
                : NSColor(light)
        })
        #else
        return light
        #endif
    }
}

// MARK: - Programmatic Namespace

public extension LubaColors {
    enum Programmatic {
        public static let gray900 = LubaColors.gray900
        public static let gray800 = LubaColors.gray800
        public static let gray600 = LubaColors.gray600
        public static let gray500 = LubaColors.gray500
        public static let gray400 = LubaColors.gray400
        public static let gray200 = LubaColors.gray200
        public static let gray100 = LubaColors.gray100
        public static let gray50 = LubaColors.gray50
        public static let background = LubaColors.background
        public static let surface = LubaColors.surface
        public static let surfaceSecondary = LubaColors.surfaceSecondary
        public static let surfaceTertiary = LubaColors.surfaceTertiary
        public static let accent = LubaColors.accent
        public static let accentHover = LubaColors.accentHover
        public static let accentSubtle = LubaColors.accentSubtle
        public static let textPrimary = LubaColors.textPrimary
        public static let textSecondary = LubaColors.textSecondary
        public static let textTertiary = LubaColors.textTertiary
        public static let textDisabled = LubaColors.textDisabled
        public static let textOnAccent = LubaColors.textOnAccent
        public static let success = LubaColors.success
        public static let warning = LubaColors.warning
        public static let error = LubaColors.error
        public static let successSubtle = LubaColors.successSubtle
        public static let warningSubtle = LubaColors.warningSubtle
        public static let errorSubtle = LubaColors.errorSubtle
        public static let border = LubaColors.border
        
        // Legacy
        public static let navy900 = LubaColors.gray900
        public static let navy700 = LubaColors.gray800
        public static let navy500 = LubaColors.gray600
        public static let accentBlue = LubaColors.accent
        public static let accentGold = LubaColors.accent
    }
}

// MARK: - Color Extension for Hex

public extension Color {
    /// Initialize a Color from a hex value
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
