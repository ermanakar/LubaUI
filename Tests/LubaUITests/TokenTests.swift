//
//  TokenTests.swift
//  LubaUI
//
//  Tests for design tokens: primitives, spacing, radius, colors, typography, motion, animations.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class TokenTests: XCTestCase {

    // MARK: - Version

    func testVersion() {
        XCTAssertEqual(LubaUI.version, "0.1.0")
        XCTAssertEqual(LubaUI.name, "LubaUI")
    }

    // MARK: - Primitives

    func testPrimitiveSpacingValues() {
        XCTAssertEqual(LubaPrimitives.spaceUnit, 4)
        XCTAssertEqual(LubaPrimitives.space4, 4)
        XCTAssertEqual(LubaPrimitives.space8, 8)
        XCTAssertEqual(LubaPrimitives.space12, 12)
        XCTAssertEqual(LubaPrimitives.space16, 16)
        XCTAssertEqual(LubaPrimitives.space24, 24)
        XCTAssertEqual(LubaPrimitives.space32, 32)
        XCTAssertEqual(LubaPrimitives.space48, 48)
        XCTAssertEqual(LubaPrimitives.space64, 64)
    }

    func testPrimitiveRadiusValues() {
        XCTAssertEqual(LubaPrimitives.radius4, 4)
        XCTAssertEqual(LubaPrimitives.radius8, 8)
        XCTAssertEqual(LubaPrimitives.radius12, 12)
        XCTAssertEqual(LubaPrimitives.radius16, 16)
        XCTAssertEqual(LubaPrimitives.radius24, 24)
        XCTAssertEqual(LubaPrimitives.radiusFull, 9999)
    }

    func testPrimitiveFontSizes() {
        XCTAssertEqual(LubaPrimitives.fontSize34, 34)
        XCTAssertEqual(LubaPrimitives.fontSize26, 26)
        XCTAssertEqual(LubaPrimitives.fontSize20, 20)
        XCTAssertEqual(LubaPrimitives.fontSize17, 17)
        XCTAssertEqual(LubaPrimitives.fontSize16, 16)
        XCTAssertEqual(LubaPrimitives.fontSize14, 14)
        XCTAssertEqual(LubaPrimitives.fontSize13, 13)
        XCTAssertEqual(LubaPrimitives.fontSize12, 12)
        XCTAssertEqual(LubaPrimitives.fontSize11, 11)
    }

    func testPrimitiveAnimationValues() {
        XCTAssertEqual(LubaPrimitives.durationQuick, 0.15)
        XCTAssertEqual(LubaPrimitives.durationStandard, 0.25)
        XCTAssertEqual(LubaPrimitives.durationGentle, 0.4)
        XCTAssertEqual(LubaPrimitives.springResponse, 0.35)
        XCTAssertEqual(LubaPrimitives.springDamping, 0.7)
    }

    func testPrimitiveColorPairsExist() {
        XCTAssertNotNil(LubaPrimitives.grey900Light)
        XCTAssertNotNil(LubaPrimitives.grey900Dark)
        XCTAssertNotNil(LubaPrimitives.grey800Light)
        XCTAssertNotNil(LubaPrimitives.grey800Dark)
        XCTAssertNotNil(LubaPrimitives.sageLight)
        XCTAssertNotNil(LubaPrimitives.sageDark)
        XCTAssertNotNil(LubaPrimitives.textOnAccentLight)
        XCTAssertNotNil(LubaPrimitives.textOnAccentDark)
        XCTAssertNotNil(LubaPrimitives.successLight)
        XCTAssertNotNil(LubaPrimitives.successDark)
        XCTAssertNotNil(LubaPrimitives.warningLight)
        XCTAssertNotNil(LubaPrimitives.warningDark)
        XCTAssertNotNil(LubaPrimitives.errorLight)
        XCTAssertNotNil(LubaPrimitives.errorDark)
    }

    // MARK: - Spacing

    func testSpacingScale() {
        XCTAssertEqual(LubaSpacing.xs, 4)
        XCTAssertEqual(LubaSpacing.sm, 8)
        XCTAssertEqual(LubaSpacing.md, 12)
        XCTAssertEqual(LubaSpacing.lg, 16)
        XCTAssertEqual(LubaSpacing.xl, 24)
        XCTAssertEqual(LubaSpacing.xxl, 32)
        XCTAssertEqual(LubaSpacing.xxxl, 48)
        XCTAssertEqual(LubaSpacing.huge, 64)
    }

    func testSpacing4ptGrid() {
        let spacings: [CGFloat] = [
            LubaSpacing.xs, LubaSpacing.sm, LubaSpacing.md,
            LubaSpacing.lg, LubaSpacing.xl, LubaSpacing.xxl,
            LubaSpacing.xxxl, LubaSpacing.huge
        ]
        for spacing in spacings {
            XCTAssertEqual(spacing.truncatingRemainder(dividingBy: 4), 0,
                           "Spacing \(spacing) is not a multiple of 4")
        }
    }

    func testCustomSpacing() {
        XCTAssertEqual(LubaSpacing.custom(1), 4)
        XCTAssertEqual(LubaSpacing.custom(2), 8)
        XCTAssertEqual(LubaSpacing.custom(5), 20)
        XCTAssertEqual(LubaSpacing.custom(10), 40)
    }

    func testSpacingInsets() {
        let uniform = LubaSpacing.insets(LubaSpacing.lg)
        XCTAssertEqual(uniform.top, 16)
        XCTAssertEqual(uniform.leading, 16)
        XCTAssertEqual(uniform.bottom, 16)
        XCTAssertEqual(uniform.trailing, 16)

        let asymmetric = LubaSpacing.insets(horizontal: LubaSpacing.xl, vertical: LubaSpacing.sm)
        XCTAssertEqual(asymmetric.leading, 24)
        XCTAssertEqual(asymmetric.trailing, 24)
        XCTAssertEqual(asymmetric.top, 8)
        XCTAssertEqual(asymmetric.bottom, 8)
    }

    // MARK: - Radius

    func testRadiusScale() {
        XCTAssertEqual(LubaRadius.none, 0)
        XCTAssertEqual(LubaRadius.xs, 4)
        XCTAssertEqual(LubaRadius.sm, 8)
        XCTAssertEqual(LubaRadius.md, 12)
        XCTAssertEqual(LubaRadius.lg, 16)
        XCTAssertEqual(LubaRadius.xl, 24)
        XCTAssertEqual(LubaRadius.full, 9999)
    }

    func testRadiusProgression() {
        let radii = [LubaRadius.none, LubaRadius.xs, LubaRadius.sm,
                     LubaRadius.md, LubaRadius.lg, LubaRadius.xl, LubaRadius.full]
        for i in 0..<(radii.count - 1) {
            XCTAssertLessThan(radii[i], radii[i + 1],
                              "Radius at index \(i) should be less than radius at index \(i + 1)")
        }
    }

    // MARK: - Colors

    func testColorHexInitializer() {
        let red = Color(hex: 0xFF0000)
        let green = Color(hex: 0x00FF00)
        let blue = Color(hex: 0x0000FF)
        let black = Color(hex: 0x000000)
        let white = Color(hex: 0xFFFFFF)

        XCTAssertNotNil(red)
        XCTAssertNotNil(green)
        XCTAssertNotNil(blue)
        XCTAssertNotNil(black)
        XCTAssertNotNil(white)
    }

    func testColorHexWithAlpha() {
        let semiTransparent = Color(hex: 0xFF0000, alpha: 0.5)
        XCTAssertNotNil(semiTransparent)
    }

    func testSemanticColorAliases() {
        XCTAssertNotNil(LubaColors.textPrimary)
        XCTAssertNotNil(LubaColors.textSecondary)
        XCTAssertNotNil(LubaColors.textTertiary)
        XCTAssertNotNil(LubaColors.textDisabled)
        XCTAssertNotNil(LubaColors.textOnAccent)
    }

    func testLegacyColorAliases() {
        XCTAssertNotNil(LubaColors.navy900)
        XCTAssertNotNil(LubaColors.navy700)
        XCTAssertNotNil(LubaColors.navy500)
        XCTAssertNotNil(LubaColors.accentBlue)
        XCTAssertNotNil(LubaColors.accentGold)
    }

    func testProgrammaticNamespace() {
        XCTAssertNotNil(LubaColors.Programmatic.gray900)
        XCTAssertNotNil(LubaColors.Programmatic.accent)
        XCTAssertNotNil(LubaColors.Programmatic.textOnAccent)
        XCTAssertNotNil(LubaColors.Programmatic.background)
        XCTAssertNotNil(LubaColors.Programmatic.surface)
    }

    func testSemanticColorsExist() {
        XCTAssertNotNil(LubaColors.success)
        XCTAssertNotNil(LubaColors.warning)
        XCTAssertNotNil(LubaColors.error)
        XCTAssertNotNil(LubaColors.accent)
        XCTAssertNotNil(LubaColors.accentHover)
        XCTAssertNotNil(LubaColors.accentSubtle)
    }

    func testSurfaceColorHierarchy() {
        XCTAssertNotNil(LubaColors.background)
        XCTAssertNotNil(LubaColors.surface)
        XCTAssertNotNil(LubaColors.surfaceSecondary)
        XCTAssertNotNil(LubaColors.surfaceTertiary)
    }

    func testSubtleSemanticColors() {
        XCTAssertNotNil(LubaColors.successSubtle)
        XCTAssertNotNil(LubaColors.warningSubtle)
        XCTAssertNotNil(LubaColors.errorSubtle)
    }

    func testSubtleColorsProgrammatic() {
        XCTAssertNotNil(LubaColors.Programmatic.successSubtle)
        XCTAssertNotNil(LubaColors.Programmatic.warningSubtle)
        XCTAssertNotNil(LubaColors.Programmatic.errorSubtle)
    }

    // MARK: - Typography

    func testTypographyFontsExist() {
        XCTAssertNotNil(LubaTypography.largeTitle)
        XCTAssertNotNil(LubaTypography.title)
        XCTAssertNotNil(LubaTypography.title2)
        XCTAssertNotNil(LubaTypography.title3)
        XCTAssertNotNil(LubaTypography.headline)
        XCTAssertNotNil(LubaTypography.subheadline)
        XCTAssertNotNil(LubaTypography.body)
        XCTAssertNotNil(LubaTypography.bodySmall)
        XCTAssertNotNil(LubaTypography.caption)
        XCTAssertNotNil(LubaTypography.caption2)
        XCTAssertNotNil(LubaTypography.footnote)
        XCTAssertNotNil(LubaTypography.code)
        XCTAssertNotNil(LubaTypography.button)
        XCTAssertNotNil(LubaTypography.buttonSmall)
        XCTAssertNotNil(LubaTypography.buttonLarge)
    }

    // MARK: - Motion

    func testMotionPressScale() {
        XCTAssertEqual(LubaMotion.pressScale, 0.97)
        XCTAssertEqual(LubaMotion.pressScaleProminent, 0.98)
        XCTAssertEqual(LubaMotion.pressScaleCompact, 0.95)
        XCTAssertGreaterThan(LubaMotion.pressScale, 0.9)
        XCTAssertLessThan(LubaMotion.pressScale, 1.0)
        XCTAssertLessThan(LubaMotion.pressScaleCompact, LubaMotion.pressScale)
        XCTAssertGreaterThan(LubaMotion.pressScaleProminent, LubaMotion.pressScale)
    }

    func testMotionOpacities() {
        XCTAssertEqual(LubaMotion.disabledOpacity, 0.45)
        XCTAssertEqual(LubaMotion.loadingContentOpacity, 0.7)
        XCTAssertLessThan(LubaMotion.disabledOpacity, LubaMotion.loadingContentOpacity)
        XCTAssertGreaterThan(LubaMotion.disabledOpacity, 0)
        XCTAssertLessThan(LubaMotion.loadingContentOpacity, 1)
    }

    func testMotionIconLabelSpacing() {
        XCTAssertEqual(LubaMotion.iconLabelSpacing, 6)
    }

    func testMotionAnimationsExist() {
        XCTAssertNotNil(LubaMotion.pressAnimation)
        XCTAssertNotNil(LubaMotion.colorAnimation)
        XCTAssertNotNil(LubaMotion.stateAnimation)
        XCTAssertNotNil(LubaMotion.micro)
        XCTAssertNotNil(LubaMotion.standard)
        XCTAssertNotNil(LubaMotion.gentle)
        XCTAssertNotNil(LubaMotion.bouncy)
    }

    func testMotionStagger() {
        let stagger0 = LubaMotion.stagger(index: 0)
        let stagger1 = LubaMotion.stagger(index: 1)
        XCTAssertNotNil(stagger0)
        XCTAssertNotNil(stagger1)
    }

    // MARK: - Animation Presets

    func testAnimationPresetsExist() {
        XCTAssertNotNil(LubaAnimations.quick)
        XCTAssertNotNil(LubaAnimations.standard)
        XCTAssertNotNil(LubaAnimations.gentle)
        XCTAssertNotNil(LubaAnimations.bouncy)
        XCTAssertNotNil(LubaAnimations.fadeIn)
        XCTAssertNotNil(LubaAnimations.smooth)
        XCTAssertNotNil(LubaAnimations.subtle)
    }

    func testStaggerDelay() {
        XCTAssertEqual(LubaAnimations.staggerDelay(for: 0), 0)
        XCTAssertEqual(LubaAnimations.staggerDelay(for: 1), 0.05)
        XCTAssertEqual(LubaAnimations.staggerDelay(for: 10), 0.5)
    }

    func testTransitionPresetsExist() {
        XCTAssertNotNil(AnyTransition.lubaSlideUp)
        XCTAssertNotNil(AnyTransition.lubaScale)
        XCTAssertNotNil(AnyTransition.lubaFade)
    }

    // MARK: - Cross-Tier Consistency

    func testSpacingConsistencyWithPrimitives() {
        XCTAssertEqual(LubaSpacing.xs, LubaPrimitives.space4)
        XCTAssertEqual(LubaSpacing.sm, LubaPrimitives.space8)
        XCTAssertEqual(LubaSpacing.md, LubaPrimitives.space12)
        XCTAssertEqual(LubaSpacing.lg, LubaPrimitives.space16)
        XCTAssertEqual(LubaSpacing.xl, LubaPrimitives.space24)
        XCTAssertEqual(LubaSpacing.xxl, LubaPrimitives.space32)
        XCTAssertEqual(LubaSpacing.xxxl, LubaPrimitives.space48)
        XCTAssertEqual(LubaSpacing.huge, LubaPrimitives.space64)
    }

    func testRadiusConsistencyWithPrimitives() {
        XCTAssertEqual(LubaRadius.xs, LubaPrimitives.radius4)
        XCTAssertEqual(LubaRadius.sm, LubaPrimitives.radius8)
        XCTAssertEqual(LubaRadius.md, LubaPrimitives.radius12)
        XCTAssertEqual(LubaRadius.lg, LubaPrimitives.radius16)
        XCTAssertEqual(LubaRadius.xl, LubaPrimitives.radius24)
        XCTAssertEqual(LubaRadius.full, LubaPrimitives.radiusFull)
    }
}
