//
//  LubaAnimations.swift
//  LubaUI
//
//  Animation presets for consistent, premium motion.
//

import SwiftUI

// MARK: - Animation Presets

/// LubaUI's animation system with carefully tuned curves.
public enum LubaAnimations {
    
    // MARK: - Spring Animations
    
    /// Quick, snappy spring for micro-interactions
    /// Use for: button presses, toggles, small state changes
    public static let quick = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    /// Standard spring for most animations
    /// Use for: cards, panels, navigation
    public static let standard = Animation.spring(response: 0.4, dampingFraction: 0.75)
    
    /// Gentle spring for larger movements
    /// Use for: page transitions, large cards
    public static let gentle = Animation.spring(response: 0.5, dampingFraction: 0.8)
    
    /// Bouncy spring for playful feedback
    /// Use for: success states, celebrations
    public static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    
    // MARK: - Eased Animations
    
    /// Fast ease-out for appearing elements
    public static let fadeIn = Animation.easeOut(duration: 0.2)
    
    /// Smooth ease for color/opacity changes
    public static let smooth = Animation.easeInOut(duration: 0.25)
    
    /// Slow ease for subtle background changes
    public static let subtle = Animation.easeInOut(duration: 0.4)
    
    // MARK: - Staggered Animations
    
    /// Creates a delay for staggered list animations
    /// - Parameter index: Item index in the list
    /// - Returns: Delay duration
    public static func staggerDelay(for index: Int) -> Double {
        Double(index) * 0.05
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply a LubaUI animation to a specific value change.
    ///
    /// - Parameters:
    ///   - animation: The animation preset to use (default: standard spring)
    ///   - value: The value to observe for triggering the animation
    func lubaAnimation<V: Equatable>(_ animation: Animation = LubaAnimations.standard, value: V) -> some View {
        self.animation(animation, value: value)
    }
}

// MARK: - Transition Presets

public extension AnyTransition {
    /// Slide up with fade
    static var lubaSlideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
    
    /// Scale with fade
    static var lubaScale: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .scale(scale: 1.05).combined(with: .opacity)
        )
    }
    
    /// Gentle fade
    static var lubaFade: AnyTransition {
        .opacity
    }
}
