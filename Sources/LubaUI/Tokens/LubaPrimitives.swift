//
//  LubaPrimitives.swift
//  LubaUI
//
//  Tier 1: Raw primitive values.
//  These are the DNA — never use directly in components.
//  Always reference via semantic tokens (Tier 2).
//

import SwiftUI

// MARK: - Color Primitives (Tier 1)

/// Raw color values. Use LubaColors (Tier 2) in your code instead.
public enum LubaPrimitives {
    
    // MARK: - Greyscale
    
    public static let black = Color(hex: 0x000000)
    public static let white = Color.white
    
    // Light mode greys
    public static let grey900Light = Color(hex: 0x1A1A1A)
    public static let grey800Light = Color(hex: 0x2E2E2E)
    public static let grey600Light = Color(hex: 0x525252)
    public static let grey500Light = Color(hex: 0x737373)
    public static let grey400Light = Color(hex: 0xA3A3A3)
    public static let grey200Light = Color(hex: 0xE5E5E5)
    public static let grey100Light = Color(hex: 0xF5F5F5)
    public static let grey50Light = Color(hex: 0xFAFAFA)
    
    // Dark mode greys
    public static let grey900Dark = Color(hex: 0xF5F5F5)
    public static let grey800Dark = Color(hex: 0xE5E5E5)
    public static let grey600Dark = Color(hex: 0xB3B3B3)
    public static let grey500Dark = Color(hex: 0x8A8A8A)
    public static let grey400Dark = Color(hex: 0x5C5C5C)
    public static let grey200Dark = Color(hex: 0x333333)
    public static let grey100Dark = Color(hex: 0x1C1C1C)
    public static let grey50Dark = Color(hex: 0x161616)
    
    // MARK: - Accent (Sage Green)
    
    public static let sageLight = Color(hex: 0x5F7360)
    public static let sageDark = Color(hex: 0x9AB897)
    public static let sageHoverLight = Color(hex: 0x506350)
    public static let sageHoverDark = Color(hex: 0xAAC8A7)
    public static let sageSubtleLight = Color(hex: 0xEDF2EC)
    public static let sageSubtleDark = Color(hex: 0x1D261D)
    
    // MARK: - Text on Accent
    
    public static let textOnAccentLight = Color.white
    public static let textOnAccentDark = Color(hex: 0x1A1A1A)
    
    // MARK: - Semantic Primitives
    
    public static let successLight = Color(hex: 0x4A7C59)
    public static let successDark = Color(hex: 0x7CB88D)
    public static let warningLight = Color(hex: 0xB8860B)
    public static let warningDark = Color(hex: 0xE0A832)
    public static let errorLight = Color(hex: 0xB54A4A)
    public static let errorDark = Color(hex: 0xE07A7A)
    
    // MARK: - Surface Primitives
    
    public static let backgroundLight = Color(hex: 0xFAFAFA)
    public static let backgroundDark = Color(hex: 0x0D0D0D)
    public static let surfaceLight = Color.white
    public static let surfaceDark = Color(hex: 0x171717)
    public static let surfaceSecondaryLight = Color(hex: 0xF5F5F5)
    public static let surfaceSecondaryDark = Color(hex: 0x212121)
}

// MARK: - Spacing Primitives (Tier 1)

public extension LubaPrimitives {
    /// Base unit for spacing (4pt grid)
    static let spaceUnit: CGFloat = 4
    
    static let space4: CGFloat = 4
    static let space8: CGFloat = 8
    static let space12: CGFloat = 12
    static let space16: CGFloat = 16
    static let space24: CGFloat = 24
    static let space32: CGFloat = 32
    static let space48: CGFloat = 48
    static let space64: CGFloat = 64
}

// MARK: - Radius Primitives (Tier 1)

public extension LubaPrimitives {
    static let radius4: CGFloat = 4
    static let radius8: CGFloat = 8
    static let radius12: CGFloat = 12
    static let radius16: CGFloat = 16
    static let radius24: CGFloat = 24
    static let radiusFull: CGFloat = 9999
}

// MARK: - Typography Primitives (Tier 1)

public extension LubaPrimitives {
    static let fontSize34: CGFloat = 34
    static let fontSize26: CGFloat = 26
    static let fontSize20: CGFloat = 20
    static let fontSize17: CGFloat = 17
    static let fontSize16: CGFloat = 16
    static let fontSize14: CGFloat = 14
    static let fontSize13: CGFloat = 13
    static let fontSize12: CGFloat = 12
    static let fontSize11: CGFloat = 11
}

// MARK: - Animation Primitives (Tier 1)

public extension LubaPrimitives {
    static let durationQuick: Double = 0.15
    static let durationStandard: Double = 0.25
    static let durationGentle: Double = 0.4
    
    static let springResponse: Double = 0.35
    static let springDamping: Double = 0.7
}
