import SwiftUI

// MARK: - Button Style Enum (Backwards Compatible)

/// Button visual style presets.
public enum LubaButtonStyle {
    case primary    // Filled accent background
    case secondary  // Bordered, surface background
    case ghost      // Text only, no background
    case destructive // Red, for dangerous actions
    case subtle     // Minimal, for secondary actions
    case glass      // Translucent glass background

    package var styling: any LubaButtonStyling {
        switch self {
        case .primary: return LubaPrimaryStyle()
        case .secondary: return LubaSecondaryStyle()
        case .ghost: return LubaGhostStyle()
        case .destructive: return LubaDestructiveStyle()
        case .subtle: return LubaSubtleStyle()
        case .glass: return LubaGlassButtonStyle()
        }
    }

    var isGlass: Bool { self == .glass }
}
