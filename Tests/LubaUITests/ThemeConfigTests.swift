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
        XCTAssertNil(config.accentColorLight)
        XCTAssertNil(config.accentColorDark)
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
        config.setAccentColor(light: .purple, dark: .pink)
        XCTAssertNotNil(config.accentColorLight)
        XCTAssertNotNil(config.accentColorDark)

        config.disableAnimations()
        XCTAssertFalse(config.animationsEnabled)
        XCTAssertFalse(config.hapticsEnabled)

        config.enableHighAccessibility()
        XCTAssertTrue(config.highContrastMode)
        XCTAssertTrue(config.useBoldText)
        XCTAssertEqual(config.minimumTouchTarget, 48)
    }

    // MARK: - Reduced Motion Tests

    func testReducedMotionWithAnimationsEnabled() {
        LubaConfig.shared.animationsEnabled = true
        let animation = LubaReducedMotion.animation(.easeIn(duration: 0.3))
        XCTAssertNotNil(animation)
        XCTAssertNotNil(LubaReducedMotion.safe)
    }

    func testReducedMotionWithAnimationsDisabled() {
        let previousValue = LubaConfig.shared.animationsEnabled
        LubaConfig.shared.animationsEnabled = false
        let animation = LubaReducedMotion.animation(.easeIn(duration: 0.3))
        XCTAssertNil(animation)
        XCTAssertNil(LubaReducedMotion.safe)
        LubaConfig.shared.animationsEnabled = previousValue
    }
}
