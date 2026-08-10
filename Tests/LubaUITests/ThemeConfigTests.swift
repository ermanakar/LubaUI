//
//  ThemeConfigTests.swift
//  LubaUI
//
//  Tests for theme configuration, config presets, and reduced motion.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class ThemeConfigTests: XCTestCase {

    // MARK: - Theme Tests

    func testDefaultTheme() {
        let theme = LubaThemeConfiguration.default
        XCTAssertNotNil(theme.colors)
        XCTAssertNotNil(theme.typography)
        XCTAssertNotNil(theme.spacing)
        XCTAssertNotNil(theme.radius)
    }

    func testCustomTheme() {
        let customColors = LubaThemeColors(
            primary: .red,
            accent: .purple
        )
        let theme = LubaThemeConfiguration(colors: customColors)

        XCTAssertNotNil(theme.colors.primary)
        XCTAssertNotNil(theme.colors.accent)
    }

    func testThemeSpacingDefaults() {
        let spacing = LubaThemeSpacing.default
        XCTAssertEqual(spacing.xs, LubaSpacing.xs)
        XCTAssertEqual(spacing.sm, LubaSpacing.sm)
        XCTAssertEqual(spacing.md, LubaSpacing.md)
        XCTAssertEqual(spacing.lg, LubaSpacing.lg)
        XCTAssertEqual(spacing.xl, LubaSpacing.xl)
    }

    func testThemeRadiusDefaults() {
        let radius = LubaThemeRadius.default
        XCTAssertEqual(radius.sm, LubaRadius.sm)
        XCTAssertEqual(radius.md, LubaRadius.md)
        XCTAssertEqual(radius.lg, LubaRadius.lg)
        XCTAssertEqual(radius.full, LubaRadius.full)
    }

    // MARK: - Config Tests

    func testDefaultConfig() {
        let config = LubaConfig()
        XCTAssertTrue(config.hapticsEnabled)
        XCTAssertTrue(config.animationsEnabled)
        XCTAssertTrue(config.respectReducedMotion)
        XCTAssertEqual(config.minimumTouchTarget, 44)
        XCTAssertFalse(config.useBoldText)
        XCTAssertFalse(config.highContrastMode)
        XCTAssertTrue(config.useRoundedFont)
        XCTAssertNil(config.customFontFamily)
        XCTAssertFalse(config.showDebugOutlines)
        XCTAssertFalse(config.logA11yWarnings)
        XCTAssertEqual(config.animationSpeed, 1.0)
        XCTAssertEqual(config.hapticIntensity, 1.0)
    }

    func testMinimalConfig() {
        let config = LubaConfig.minimal
        XCTAssertFalse(config.animationsEnabled)
        XCTAssertFalse(config.hapticsEnabled)
    }

    func testAccessibleConfig() {
        let config = LubaConfig.accessible
        XCTAssertTrue(config.highContrastMode)
        XCTAssertTrue(config.useBoldText)
        XCTAssertEqual(config.minimumTouchTarget, 48)
    }

    func testDebugConfig() {
        let config = LubaConfig.debug
        XCTAssertTrue(config.showDebugOutlines)
        XCTAssertTrue(config.logA11yWarnings)
    }

    func testConfigMutation() {
        var config = LubaConfig()

        config.disableAnimations()
        XCTAssertFalse(config.animationsEnabled)
        XCTAssertFalse(config.hapticsEnabled)

        config.enableHighAccessibility()
        XCTAssertTrue(config.highContrastMode)
        XCTAssertTrue(config.useBoldText)
        XCTAssertEqual(config.minimumTouchTarget, 48)
    }

    // MARK: - Reduced Motion Tests

    func testMotionPolicyWithAnimationsEnabled() {
        var config = LubaConfig()
        config.animationsEnabled = true

        let policy = config.motionPolicy(systemReduceMotion: false)
        XCTAssertNotNil(policy.animation(.easeIn(duration: 0.3)))
        XCTAssertNotNil(policy.decorative(.easeIn(duration: 0.3)))
    }

    func testMotionPolicyWithAnimationsDisabled() {
        var config = LubaConfig()
        config.animationsEnabled = false

        let policy = config.motionPolicy(systemReduceMotion: false)
        XCTAssertNil(policy.animation(.easeIn(duration: 0.3)))
        XCTAssertNil(policy.decorative(.easeIn(duration: 0.3)))
    }

    // MARK: - Environment Precedence

    /// `LubaConfig.shared` is a *live* fallback, not a value frozen at first
    /// environment access. Mutating it must still affect views with no
    /// `.lubaConfig(…)` ancestor.
    func testSharedConfigActsAsLiveFallback() {
        let previous = LubaConfig.shared
        defer { LubaConfig.shared = previous }

        LubaConfig.shared.minimumTouchTarget = 60
        XCTAssertEqual(EnvironmentValues().lubaConfig.minimumTouchTarget, 60)

        LubaConfig.shared.minimumTouchTarget = 44
        XCTAssertEqual(EnvironmentValues().lubaConfig.minimumTouchTarget, 44)
    }

    /// An explicit environment value must win over the singleton.
    func testEnvironmentConfigOverridesShared() {
        let previous = LubaConfig.shared
        defer { LubaConfig.shared = previous }

        LubaConfig.shared.minimumTouchTarget = 44

        var values = EnvironmentValues()
        var subtree = LubaConfig()
        subtree.minimumTouchTarget = 52
        values.lubaConfig = subtree

        XCTAssertEqual(values.lubaConfig.minimumTouchTarget, 52)
        XCTAssertEqual(LubaConfig.shared.minimumTouchTarget, 44)
    }

    /// The theme environment defaults to the stock theme and accepts overrides.
    func testEnvironmentThemeOverride() {
        var values = EnvironmentValues()
        XCTAssertEqual(values.lubaTheme.colors.accent, LubaColors.accent)

        values.lubaTheme = LubaThemeConfiguration(colors: .accented(.blue))
        XCTAssertEqual(values.lubaTheme.colors.accent, .blue)
    }
}
