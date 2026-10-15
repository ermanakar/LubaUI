import SwiftUI

// MARK: - Card Elevation

/// Elevation levels for LubaCard.
/// Each level defines shadow radius, opacity, and Y offset for realistic depth.
public enum LubaCardElevation {
    case flat       // No shadow — flush with surface
    case low        // Subtle lift — default for content cards
    case medium     // Moderate emphasis — selected states, hover
    case high       // Prominent — modals, popovers, dialogs

    /// Shadow blur radius
    public var shadowRadius: CGFloat {
        switch self {
        case .flat: return 0
        case .low: return 4
        case .medium: return 12
        case .high: return 24
        }
    }

    /// Shadow opacity (before color scheme adjustment)
    public var shadowOpacity: Double {
        switch self {
        case .flat: return 0
        case .low: return 0.06
        case .medium: return 0.10
        case .high: return 0.15
        }
    }

    /// Shadow Y offset (light comes from above)
    public var shadowY: CGFloat {
        switch self {
        case .flat: return 0
        case .low: return 2
        case .medium: return 6
        case .high: return 12
        }
    }

    /// Adjusted shadow opacity for dark mode (shadows need to be stronger)
    public func adjustedOpacity(for colorScheme: ColorScheme) -> Double {
        colorScheme == .dark ? shadowOpacity * 1.5 : shadowOpacity
    }
}
