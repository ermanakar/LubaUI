//
//  MotionPolicyTests.swift
//  LubaUI
//
//  Tests for the central motion policy and the environment context that
//  feeds it — the two inputs being LubaConfig and system Reduce Motion.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class MotionPolicyTests: XCTestCase {

    // MARK: - Resolution From Config + System Setting

    func testPolicyCombinesConfigAndSystemSetting() {
        var config = LubaConfig()
        config.respectReducedMotion = true

        XCTAssertFalse(LubaMotionPolicy(config: config, systemReduceMotion: false).prefersReducedMotion)
        XCTAssertTrue(LubaMotionPolicy(config: config, systemReduceMotion: true).prefersReducedMotion)
    }

    /// Opting out of Reduce Motion is the app's call, and it must be honored.
    func testConfigCanOptOutOfSystemReduceMotion() {
        var config = LubaConfig()
        config.respectReducedMotion = false

        let policy = LubaMotionPolicy(config: config, systemReduceMotion: true)
        XCTAssertFalse(policy.prefersReducedMotion)
        XCTAssertTrue(policy.allowsDecorativeMotion)
    }

    // MARK: - Animations Disabled

    func testDisabledPolicySuppressesEverything() {
        let policy = LubaMotionPolicy.disabled

        XCTAssertNil(policy.animation(.easeIn(duration: 0.3)))
        XCTAssertNil(policy.decorative(.easeIn(duration: 0.3)))
        XCTAssertNil(policy.interaction(.easeIn(duration: 0.3)))
        XCTAssertNil(policy.repeating(.linear(duration: 1)))
        XCTAssertNil(policy.repeatingOpacity(.linear(duration: 1)))
        XCTAssertNil(policy.continuous(.linear(duration: 1)))
        XCTAssertNil(policy.stagger(index: 3))
        XCTAssertFalse(policy.allowsAnimation)
        XCTAssertFalse(policy.allowsDecorativeMotion)
        XCTAssertEqual(policy.pressScale(0.95), 1.0)
        XCTAssertEqual(policy.motionAmount(20), 0)
        XCTAssertEqual(policy.staggerDelay(index: 5), 0)
    }

    func testMinimalConfigProducesDisabledPolicy() {
        let policy = LubaConfig.minimal.motionPolicy(systemReduceMotion: false)
        XCTAssertFalse(policy.allowsAnimation)
        XCTAssertNil(policy.animation(LubaMotion.pressAnimation))
    }

    // MARK: - Reduce Motion

    func testReducedPolicyKeepsEssentialChangesButRemovesMovement() {
        let policy = LubaMotionPolicy.reduced

        // Essential state changes stay perceivable — as a cross-fade.
        XCTAssertNotNil(policy.animation(LubaMotion.pressAnimation))
        XCTAssertEqual(policy.animation(LubaMotion.pressAnimation), LubaMotionPolicy.reducedMotionFallback)

        // Decorative motion is gone.
        XCTAssertNil(policy.decorative(LubaMotion.pressAnimation))
        XCTAssertNil(policy.repeating(.linear(duration: 1)))

        // Staggering collapses: items still cross-fade in, but simultaneously.
        XCTAssertEqual(policy.staggerDelay(index: 3), 0)
        XCTAssertEqual(policy.stagger(index: 0), policy.stagger(index: 7))

        // Transforms are neutralized.
        XCTAssertEqual(policy.pressScale(0.95), 1.0)
        XCTAssertEqual(policy.motionAmount(40), 0)
        XCTAssertEqual(policy.staggerDelay(index: 5), 0)

        XCTAssertTrue(policy.allowsAnimation)
        XCTAssertFalse(policy.allowsDecorativeMotion)
        XCTAssertFalse(policy.allowsRepeatingMotion)
    }

    /// Progress rings and opacity-only busy indicators must survive Reduce
    /// Motion — replacing them with a 0.2s cross-fade would destroy meaning.
    func testInformationCarryingAnimationsSurviveReduceMotion() {
        let policy = LubaMotionPolicy.reduced
        XCTAssertNotNil(policy.continuous(.linear(duration: 2)))
        XCTAssertEqual(policy.continuous(.linear(duration: 2)), .linear(duration: 2))
        XCTAssertNotNil(policy.repeatingOpacity(.easeInOut(duration: 1)))
    }

    func testFullPolicyPassesAnimationsThrough() {
        let policy = LubaMotionPolicy.full
        XCTAssertEqual(policy.animation(LubaMotion.pressAnimation), LubaMotion.pressAnimation)
        XCTAssertEqual(policy.decorative(LubaMotion.pressAnimation), LubaMotion.pressAnimation)
        XCTAssertEqual(policy.pressScale(0.95), 0.95)
        XCTAssertEqual(policy.staggerDelay(index: 4, base: 0.05), 0.2, accuracy: 0.0001)
    }

    // MARK: - Speed

    func testSpeedMultiplierAppliesAndIdentityIsUntouched() {
        let normal = LubaMotionPolicy(speed: 1.0)
        XCTAssertEqual(normal.animation(LubaMotion.pressAnimation), LubaMotion.pressAnimation)

        let slow = LubaMotionPolicy(speed: 2.0)
        XCTAssertNotEqual(slow.animation(LubaMotion.pressAnimation), LubaMotion.pressAnimation)
        XCTAssertNotNil(slow.animation(LubaMotion.pressAnimation))
    }

    // MARK: - Transitions

    func testTransitionDowngrades() {
        // No crash + a value is produced for each policy; AnyTransition is opaque,
        // so behavior is asserted through the policy flags it branches on.
        XCTAssertTrue(LubaMotionPolicy.full.allowsDecorativeMotion)
        XCTAssertFalse(LubaMotionPolicy.reduced.allowsDecorativeMotion)
        XCTAssertFalse(LubaMotionPolicy.disabled.allowsAnimation)

        _ = LubaMotionPolicy.full.transition(.slide)
        _ = LubaMotionPolicy.reduced.transition(.slide)
        _ = LubaMotionPolicy.disabled.transition(.slide)
    }

    // MARK: - run(_:)

    func testRunExecutesBodyRegardlessOfPolicy() {
        for policy in [LubaMotionPolicy.full, .reduced, .disabled] {
            var ran = false
            policy.run { ran = true }
            XCTAssertTrue(ran, "State updates must happen even when animation is suppressed")

            var decorativeRan = false
            policy.runDecorative { decorativeRan = true }
            XCTAssertTrue(decorativeRan)
        }
    }

    // MARK: - Context

    func testContextExposesResolvedSubsystems() {
        var config = LubaConfig()
        config.animationsEnabled = false
        config.minimumTouchTarget = 50
        config.hapticsEnabled = false

        let context = LubaContext(
            theme: LubaThemeConfiguration(colors: .accented(.blue)),
            config: config,
            systemReduceMotion: true
        )

        XCTAssertEqual(context.colors.accent, .blue)
        XCTAssertEqual(context.spacing.lg, LubaSpacing.lg)
        XCTAssertEqual(context.radius.md, LubaRadius.md)
        XCTAssertEqual(context.minimumTouchTarget, 50)
        XCTAssertFalse(context.hapticsEnabled)
        XCTAssertFalse(context.motion.allowsAnimation)
        XCTAssertTrue(context.motion.prefersReducedMotion)
    }

    /// Haptics stay configurable independently of motion — a user who dislikes
    /// animation may still want tactile confirmation, and vice versa.
    func testHapticsAreIndependentOfMotion() {
        var config = LubaConfig()
        config.animationsEnabled = false
        config.hapticsEnabled = true

        let context = LubaContext(config: config, systemReduceMotion: true)
        XCTAssertTrue(context.hapticsEnabled)
        XCTAssertFalse(context.motion.allowsAnimation)
    }

    /// "Reduce Motion" and "animations off" are different states, and a view
    /// that only distinguishes *motion allowed* from *motion not allowed* will
    /// apply its Reduce Motion fallback in both.
    ///
    /// Regression test: `LubaSpinner` picked its opacity fallback whenever
    /// decorative motion was disallowed, so with `animationsEnabled == false`
    /// there was no animation to carry the opacity and the arc sat permanently
    /// dimmed. Anything choosing a fallback must gate on `prefersReducedMotion`.
    func testAnimationsOffIsDistinctFromReducedMotion() {
        var off = LubaConfig()
        off.animationsEnabled = false
        let animationsOff = LubaMotionPolicy(config: off, systemReduceMotion: false)

        XCTAssertFalse(animationsOff.allowsDecorativeMotion)
        XCTAssertFalse(animationsOff.prefersReducedMotion)
        XCTAssertFalse(animationsOff.allowsAnimation)
        // No animation of any kind is available to drive a fallback.
        XCTAssertNil(animationsOff.repeatingOpacity(.linear(duration: 1)))
        XCTAssertNil(animationsOff.continuous(.linear(duration: 1)))

        let reduced = LubaMotionPolicy(config: LubaConfig(), systemReduceMotion: true)
        XCTAssertFalse(reduced.allowsDecorativeMotion)
        XCTAssertTrue(reduced.prefersReducedMotion)
        XCTAssertTrue(reduced.allowsAnimation)
        // Under Reduce Motion the opacity fallback is genuinely available.
        XCTAssertNotNil(reduced.repeatingOpacity(.linear(duration: 1)))
    }
}
