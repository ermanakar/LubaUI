//
//  LubaMotion.swift
//  LubaUI
//
//  Motion constants for consistent, soulful interactions.
//  The tactile "soul" of LubaUI lives here.
//
//  Philosophy:
//  - Springs over easing (organic, not mechanical)
//  - Subtle but perceptible (0.97 scale, not 0.98)
//  - Every number has a reason
//

import SwiftUI

// MARK: - Motion Tokens

/// LubaUI's motion constants.
/// These define the tactile feel of every interaction.
public enum LubaMotion {

    // MARK: - Press Interaction

    /// Press scale hierarchy — smaller elements need more exaggerated motion
    /// to be perceptible, larger elements less:
    ///   compact (0.95) → standard (0.97) → prominent (0.98)
    ///
    /// These are perceptual thresholds, not arbitrary picks:
    ///   0.95 = clearly pressed (icon buttons, small targets)
    ///   0.97 = intentional but not exaggerated (standard buttons)
    ///   0.98 = subtle nod (cards, large surfaces)

    /// Scale when pressed: 0.97 (3% shrink)
    /// Why 0.97? It's the threshold where press feels intentional but not exaggerated.
    /// 0.98 feels too subtle, 0.95 feels cartoonish.
    public static let pressScale: CGFloat = 0.97

    /// Prominent press scale for larger elements (cards, tiles)
    public static let pressScaleProminent: CGFloat = 0.98

    /// Compact press scale for smaller elements (icon buttons, chips)
    /// 5% shrink is needed because small targets have less visual area
    /// to convey the change.
    public static let pressScaleCompact: CGFloat = 0.95

    /// The press animation: a quick, slightly underdamped spring
    /// Response 0.25s = snappy, Damping 0.65 = tiny bounce at the end
    public static let pressAnimation: Animation = .spring(
        response: 0.25,
        dampingFraction: 0.65
    )

    // MARK: - Color Transitions

    /// How colors shift on press/hover
    /// Slightly slower than the scale to create a layered feel
    public static let colorAnimation: Animation = .easeOut(duration: 0.12)

    // MARK: - State Transitions

    /// Loading state entrance/exit
    public static let stateAnimation: Animation = .spring(
        response: 0.35,
        dampingFraction: 0.75
    )

    /// Content opacity when loading spinner is visible
    /// Text remains visible but recedes behind the spinner
    public static let loadingContentOpacity: CGFloat = 0.7

    // MARK: - Disabled State

    /// Opacity for disabled elements
    /// 0.45 reads as "unavailable" without disappearing
    public static let disabledOpacity: CGFloat = 0.45

    // MARK: - Layout Constants

    /// Space between icon and label
    public static let iconLabelSpacing: CGFloat = 6

    // MARK: - Semantic Presets

    /// Quick micro-interaction (toggles, checkboxes)
    public static let micro: Animation = .spring(response: 0.2, dampingFraction: 0.7)

    /// Standard interaction (buttons, cards)
    public static let standard: Animation = pressAnimation

    /// Gentle movement (modals, sheets)
    public static let gentle: Animation = .spring(response: 0.4, dampingFraction: 0.8)

    /// Celebratory bounce (success states)
    public static let bouncy: Animation = .spring(response: 0.35, dampingFraction: 0.5)
}

// MARK: - Animation Helpers

public extension LubaMotion {
    /// Creates a staggered delay for list animations
    static func stagger(index: Int, base: Double = 0.04) -> Animation {
        standard.delay(Double(index) * base)
    }
}
