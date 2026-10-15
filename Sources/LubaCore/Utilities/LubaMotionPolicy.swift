//
//  LubaMotionPolicy.swift
//  LubaUI
//
//  The single decision point for "should this move, and how?".
//
//  Two inputs, one answer:
//    1. LubaConfig — `animationsEnabled`, `respectReducedMotion`, `animationSpeed`
//    2. The system `accessibilityReduceMotion` environment value
//
//  Every animated component routes through this policy so behavior is uniform:
//  turn animations off and nothing animates; turn Reduce Motion on and
//  decorative movement (springs, scale, shimmer, stagger, slide) is replaced
//  by a restrained cross-fade or removed entirely — while the *state change
//  itself* stays visible and understandable.
//

import SwiftUI

// MARK: - Motion Policy

/// Resolves whether and how a view should animate.
///
/// Read it from the environment inside a view:
///
/// ```swift
/// @LubaEnvironment private var luba
///
/// var body: some View {
///     shape
///         .scaleEffect(luba.motion.pressScale(isPressed ? 0.97 : 1))
///         .animation(luba.motion.interaction(LubaMotion.pressAnimation), value: isPressed)
/// }
/// ```
public struct LubaMotionPolicy: Equatable {

    /// Whether animations are enabled at all (`LubaConfig.animationsEnabled`).
    public let animationsEnabled: Bool

    /// Whether decorative motion must be suppressed.
    ///
    /// True when the system Reduce Motion setting is on *and* the active
    /// configuration respects it.
    public let prefersReducedMotion: Bool

    /// Duration multiplier — values above 1 slow animations down.
    public let speed: Double

    // MARK: - Init

    public init(
        animationsEnabled: Bool = true,
        prefersReducedMotion: Bool = false,
        speed: Double = 1.0
    ) {
        self.animationsEnabled = animationsEnabled
        self.prefersReducedMotion = prefersReducedMotion
        self.speed = speed
    }

    /// Resolve the policy from a configuration and the system Reduce Motion value.
    public init(config: LubaConfig, systemReduceMotion: Bool) {
        self.animationsEnabled = config.animationsEnabled
        self.prefersReducedMotion = config.respectReducedMotion && systemReduceMotion
        self.speed = config.animationSpeed
    }

    // MARK: - Presets

    /// Everything animates.
    public static let full = LubaMotionPolicy()

    /// Nothing animates.
    public static let disabled = LubaMotionPolicy(animationsEnabled: false)

    /// Essential transitions cross-fade; decorative motion is removed.
    public static let reduced = LubaMotionPolicy(prefersReducedMotion: true)

    // MARK: - Queries

    /// Whether any animation may run.
    public var allowsAnimation: Bool { animationsEnabled }

    /// Whether decorative movement (springs, scale, slide, shimmer) may run.
    public var allowsDecorativeMotion: Bool { animationsEnabled && !prefersReducedMotion }

    /// Whether an indefinitely repeating animation (spinner, shimmer) may run.
    public var allowsRepeatingMotion: Bool { allowsDecorativeMotion }

    // MARK: - Animation Resolution

    /// The animation used in place of movement under Reduce Motion.
    /// A short symmetric ease so an essential state change is still perceivable.
    public static let reducedMotionFallback: Animation = .easeInOut(duration: 0.2)

    /// Resolve an animation for an **essential** state change — one the user
    /// must notice (expand/collapse, error appearing, value updating).
    ///
    /// - Animations off → `nil`
    /// - Reduce Motion → a plain cross-fade curve
    /// - Otherwise → the requested animation, speed-adjusted
    public func animation(_ base: Animation) -> Animation? {
        guard animationsEnabled else { return nil }
        return adjust(prefersReducedMotion ? Self.reducedMotionFallback : base)
    }

    /// Resolve an animation for **decorative** motion — press scale, bounce,
    /// parallax, stagger. Removed entirely under Reduce Motion.
    public func decorative(_ base: Animation) -> Animation? {
        guard allowsDecorativeMotion else { return nil }
        return adjust(base)
    }

    /// Resolve an interaction animation (press, hover). Under Reduce Motion the
    /// scale itself is neutralized by ``pressScale(_:)``, so this returns the
    /// cross-fade curve to keep color changes smooth.
    public func interaction(_ base: Animation) -> Animation? {
        animation(base)
    }

    /// Resolve a continuously repeating animation. `nil` under Reduce Motion,
    /// so callers can render a static placeholder instead.
    public func repeating(_ base: Animation) -> Animation? {
        guard allowsRepeatingMotion else { return nil }
        return adjust(base)
    }

    /// Resolve a repeating animation that drives **opacity only**.
    ///
    /// Survives Reduce Motion: a busy indicator still has to say "busy", and a
    /// cross-fade carries no movement. Callers must ensure nothing else is
    /// animated by it — use ``pressScale(_:)`` / ``motionAmount(_:)`` to
    /// neutralize accompanying transforms.
    public func repeatingOpacity(_ base: Animation) -> Animation? {
        guard animationsEnabled else { return nil }
        return adjust(base)
    }

    /// Resolve an animation that **carries information over time** — a progress
    /// ring filling, a hold-to-confirm countdown.
    ///
    /// Preserved under Reduce Motion: shortening it to a cross-fade would
    /// destroy the meaning. Only `animationsEnabled` switches it off.
    public func continuous(_ base: Animation) -> Animation? {
        guard animationsEnabled else { return nil }
        return adjust(base)
    }

    /// Neutralize a press/hover scale under Reduce Motion or when animations are off.
    public func pressScale(_ scale: CGFloat) -> CGFloat {
        allowsDecorativeMotion ? scale : 1.0
    }

    /// Neutralize an arbitrary transform amount (offset, rotation) under Reduce Motion.
    public func motionAmount(_ amount: CGFloat) -> CGFloat {
        allowsDecorativeMotion ? amount : 0
    }

    /// A staggered delay for list animations — collapses to 0 under Reduce Motion.
    public func staggerDelay(index: Int, base: Double = 0.04) -> Double {
        allowsDecorativeMotion ? Double(index) * base : 0
    }

    /// A staggered animation for list entrances.
    public func stagger(index: Int, base: Animation = LubaMotion.pressAnimation, step: Double = 0.04) -> Animation? {
        guard let resolved = animation(base) else { return nil }
        return resolved.delay(staggerDelay(index: index, base: step))
    }

    /// Downgrade a moving transition to a cross-fade under Reduce Motion,
    /// and to no transition at all when animations are disabled.
    public func transition(_ base: AnyTransition) -> AnyTransition {
        guard animationsEnabled else { return .identity }
        return prefersReducedMotion ? .opacity : base
    }

    /// Run `body` inside `withAnimation`, honoring the policy.
    public func run(_ base: Animation = LubaAnimations.standard, _ body: () -> Void) {
        if let resolved = animation(base) {
            withAnimation(resolved) { body() }
        } else {
            body()
        }
    }

    /// Run `body` inside `withAnimation` using a decorative animation.
    public func runDecorative(_ base: Animation = LubaAnimations.standard, _ body: () -> Void) {
        if let resolved = decorative(base) {
            withAnimation(resolved) { body() }
        } else {
            body()
        }
    }

    // MARK: - Private

    private func adjust(_ animation: Animation) -> Animation {
        speed == 1.0 ? animation : animation.speed(1.0 / max(speed, 0.0001))
    }
}

// MARK: - View Helpers

public extension View {
    /// Apply an animation through a motion policy.
    func lubaAnimation<V: Equatable>(
        _ base: Animation = LubaAnimations.standard,
        value: V,
        policy: LubaMotionPolicy
    ) -> some View {
        animation(policy.animation(base), value: value)
    }

    /// Apply a decorative animation through a motion policy.
    func lubaDecorativeAnimation<V: Equatable>(
        _ base: Animation = LubaAnimations.standard,
        value: V,
        policy: LubaMotionPolicy
    ) -> some View {
        animation(policy.decorative(base), value: value)
    }
}
