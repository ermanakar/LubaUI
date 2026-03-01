//
//  TokenTests.swift
//  LubaUI
//
//  Tests for design tokens: primitives, spacing, radius, motion, glass.
//  Validates value snapshots, cross-tier consistency, monotonic progressions.
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

    // MARK: - Primitive Snapshots

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

    // MARK: - Spacing (scale, grid, custom, insets, cross-tier)

    func testSpacingScaleGridAndCrossTier() {
        // Value snapshot
        XCTAssertEqual(LubaSpacing.xs, 4)
        XCTAssertEqual(LubaSpacing.sm, 8)
        XCTAssertEqual(LubaSpacing.md, 12)
        XCTAssertEqual(LubaSpacing.lg, 16)
        XCTAssertEqual(LubaSpacing.xl, 24)
        XCTAssertEqual(LubaSpacing.xxl, 32)
        XCTAssertEqual(LubaSpacing.xxxl, 48)
        XCTAssertEqual(LubaSpacing.huge, 64)

        // 4pt grid alignment
        let spacings: [CGFloat] = [
            LubaSpacing.xs, LubaSpacing.sm, LubaSpacing.md,
            LubaSpacing.lg, LubaSpacing.xl, LubaSpacing.xxl,
            LubaSpacing.xxxl, LubaSpacing.huge
        ]
        for spacing in spacings {
            XCTAssertEqual(spacing.truncatingRemainder(dividingBy: 4), 0,
                           "Spacing \(spacing) is not a multiple of 4")
        }

        // Custom multiplier
        XCTAssertEqual(LubaSpacing.custom(1), 4)
        XCTAssertEqual(LubaSpacing.custom(2), 8)
        XCTAssertEqual(LubaSpacing.custom(5), 20)

        // Insets
        let uniform = LubaSpacing.insets(LubaSpacing.lg)
        XCTAssertEqual(uniform.top, 16)
        XCTAssertEqual(uniform.leading, 16)
        let asymmetric = LubaSpacing.insets(horizontal: LubaSpacing.xl, vertical: LubaSpacing.sm)
        XCTAssertEqual(asymmetric.leading, 24)
        XCTAssertEqual(asymmetric.top, 8)

        // Cross-tier: Tier 2 references Tier 1
        XCTAssertEqual(LubaSpacing.xs, LubaPrimitives.space4)
        XCTAssertEqual(LubaSpacing.sm, LubaPrimitives.space8)
        XCTAssertEqual(LubaSpacing.lg, LubaPrimitives.space16)
        XCTAssertEqual(LubaSpacing.xl, LubaPrimitives.space24)
        XCTAssertEqual(LubaSpacing.huge, LubaPrimitives.space64)
    }

    // MARK: - Radius (scale, progression, cross-tier)

    func testRadiusScaleProgressionAndCrossTier() {
        // Value snapshot
        XCTAssertEqual(LubaRadius.none, 0)
        XCTAssertEqual(LubaRadius.xs, 4)
        XCTAssertEqual(LubaRadius.sm, 8)
        XCTAssertEqual(LubaRadius.md, 12)
        XCTAssertEqual(LubaRadius.lg, 16)
        XCTAssertEqual(LubaRadius.xl, 24)
        XCTAssertEqual(LubaRadius.full, 9999)

        // Monotonic progression
        let radii = [LubaRadius.none, LubaRadius.xs, LubaRadius.sm,
                     LubaRadius.md, LubaRadius.lg, LubaRadius.xl, LubaRadius.full]
        for i in 0..<(radii.count - 1) {
            XCTAssertLessThan(radii[i], radii[i + 1])
        }

        // Cross-tier
        XCTAssertEqual(LubaRadius.xs, LubaPrimitives.radius4)
        XCTAssertEqual(LubaRadius.sm, LubaPrimitives.radius8)
        XCTAssertEqual(LubaRadius.lg, LubaPrimitives.radius16)
        XCTAssertEqual(LubaRadius.full, LubaPrimitives.radiusFull)
    }

    // MARK: - Motion (values, scales, opacities)

    func testMotionValues() {
        // Press scale hierarchy: compact < default < prominent
        XCTAssertEqual(LubaMotion.pressScaleCompact, 0.95)
        XCTAssertEqual(LubaMotion.pressScale, 0.97)
        XCTAssertEqual(LubaMotion.pressScaleProminent, 0.98)
        XCTAssertLessThan(LubaMotion.pressScaleCompact, LubaMotion.pressScale)
        XCTAssertLessThan(LubaMotion.pressScale, LubaMotion.pressScaleProminent)

        // Opacities
        XCTAssertEqual(LubaMotion.disabledOpacity, 0.45)
        XCTAssertEqual(LubaMotion.loadingContentOpacity, 0.7)
        XCTAssertLessThan(LubaMotion.disabledOpacity, LubaMotion.loadingContentOpacity)

        // Misc constants
        XCTAssertEqual(LubaMotion.iconLabelSpacing, 6)
        XCTAssertEqual(LubaMotion.tapMovementTolerance, 10)
    }

    func testStaggerDelay() {
        XCTAssertEqual(LubaAnimations.staggerDelay(for: 0), 0)
        XCTAssertEqual(LubaAnimations.staggerDelay(for: 1), 0.05)
        XCTAssertEqual(LubaAnimations.staggerDelay(for: 10), 0.5)
    }

    // MARK: - Glass Primitives (values, progressions, dark mode)

    func testGlassPrimitives() {
        // Value snapshot
        XCTAssertEqual(LubaPrimitives.glassBlurSubtle, 8)
        XCTAssertEqual(LubaPrimitives.glassBlurRegular, 16)
        XCTAssertEqual(LubaPrimitives.glassBlurProminent, 24)
        XCTAssertEqual(LubaPrimitives.glassBorderWidth, 0.5)
        XCTAssertEqual(LubaPrimitives.glassSolidFallbackOpacity, 0.95)
        XCTAssertEqual(LubaPrimitives.glassShadowRadius, 8)
        XCTAssertEqual(LubaPrimitives.glassShadowY, 2)

        // Blur monotonic progression
        XCTAssertLessThan(LubaPrimitives.glassBlurSubtle, LubaPrimitives.glassBlurRegular)
        XCTAssertLessThan(LubaPrimitives.glassBlurRegular, LubaPrimitives.glassBlurProminent)

        // Dark mode opacities are stronger
        XCTAssertGreaterThan(LubaPrimitives.glassTintOpacityDark, LubaPrimitives.glassTintOpacityLight)
        XCTAssertGreaterThan(LubaPrimitives.glassShadowOpacityDark, LubaPrimitives.glassShadowOpacityLight)

        // Light border brighter than dark
        XCTAssertGreaterThan(LubaPrimitives.glassBorderLuminanceLight, LubaPrimitives.glassBorderLuminanceDark)
    }
}
