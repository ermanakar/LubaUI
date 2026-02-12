//
//  LubaUITests.swift
//  LubaUI
//
//  Comprehensive unit tests for LubaUI design system.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class LubaUITests: XCTestCase {
    
    // MARK: - Version Tests
    
    func testVersion() {
        XCTAssertEqual(LubaUI.version, "0.1.0")
        XCTAssertEqual(LubaUI.name, "LubaUI")
    }
    
    // MARK: - Spacing Tests
    
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
        // All spacing values should be multiples of 4
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
    
    // MARK: - Radius Tests
    
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
        // Radii should monotonically increase
        let radii = [LubaRadius.none, LubaRadius.xs, LubaRadius.sm,
                     LubaRadius.md, LubaRadius.lg, LubaRadius.xl, LubaRadius.full]
        for i in 0..<(radii.count - 1) {
            XCTAssertLessThan(radii[i], radii[i + 1],
                              "Radius at index \(i) should be less than radius at index \(i + 1)")
        }
    }
    
    // MARK: - Color Tests
    
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
        // textPrimary should be the same reference as gray900
        // (Both are computed from the same adaptive call, so we test they exist)
        XCTAssertNotNil(LubaColors.textPrimary)
        XCTAssertNotNil(LubaColors.textSecondary)
        XCTAssertNotNil(LubaColors.textTertiary)
        XCTAssertNotNil(LubaColors.textDisabled)
        XCTAssertNotNil(LubaColors.textOnAccent)
    }
    
    func testLegacyColorAliases() {
        // Legacy aliases should exist for backwards compatibility
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
        // Surface colors should exist as a hierarchy
        XCTAssertNotNil(LubaColors.background)
        XCTAssertNotNil(LubaColors.surface)
        XCTAssertNotNil(LubaColors.surfaceSecondary)
        XCTAssertNotNil(LubaColors.surfaceTertiary)
    }
    
    // MARK: - Motion Tests
    
    func testMotionPressScale() {
        XCTAssertEqual(LubaMotion.pressScale, 0.97)
        XCTAssertEqual(LubaMotion.pressScaleProminent, 0.98)
        XCTAssertEqual(LubaMotion.pressScaleCompact, 0.95)

        // Press scale should be close to 1.0 but visibly different
        XCTAssertGreaterThan(LubaMotion.pressScale, 0.9)
        XCTAssertLessThan(LubaMotion.pressScale, 1.0)

        // Scale hierarchy: compact < standard < prominent (closer to 1.0 = subtler)
        XCTAssertLessThan(LubaMotion.pressScaleCompact, LubaMotion.pressScale)
        XCTAssertGreaterThan(LubaMotion.pressScaleProminent, LubaMotion.pressScale)
    }
    
    func testMotionOpacities() {
        XCTAssertEqual(LubaMotion.disabledOpacity, 0.45)
        XCTAssertEqual(LubaMotion.loadingContentOpacity, 0.7)
        
        // Disabled should be more dimmed than loading
        XCTAssertLessThan(LubaMotion.disabledOpacity, LubaMotion.loadingContentOpacity)
        
        // Both should be between 0 and 1
        XCTAssertGreaterThan(LubaMotion.disabledOpacity, 0)
        XCTAssertLessThan(LubaMotion.loadingContentOpacity, 1)
    }
    
    func testMotionIconLabelSpacing() {
        XCTAssertEqual(LubaMotion.iconLabelSpacing, 6)
    }
    
    func testMotionAnimationsExist() {
        // Verify all animation presets can be created
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
    
    // MARK: - Typography Tests
    
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
    
    // MARK: - Primitives Tests
    
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
        // Light/dark pairs for greyscale
        XCTAssertNotNil(LubaPrimitives.grey900Light)
        XCTAssertNotNil(LubaPrimitives.grey900Dark)
        XCTAssertNotNil(LubaPrimitives.grey800Light)
        XCTAssertNotNil(LubaPrimitives.grey800Dark)
        
        // Accent pairs
        XCTAssertNotNil(LubaPrimitives.sageLight)
        XCTAssertNotNil(LubaPrimitives.sageDark)
        
        // Text on accent pairs
        XCTAssertNotNil(LubaPrimitives.textOnAccentLight)
        XCTAssertNotNil(LubaPrimitives.textOnAccentDark)
        
        // Semantic pairs
        XCTAssertNotNil(LubaPrimitives.successLight)
        XCTAssertNotNil(LubaPrimitives.successDark)
        XCTAssertNotNil(LubaPrimitives.warningLight)
        XCTAssertNotNil(LubaPrimitives.warningDark)
        XCTAssertNotNil(LubaPrimitives.errorLight)
        XCTAssertNotNil(LubaPrimitives.errorDark)
    }
    
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
    
    // MARK: - Control Token Tests
    
    func testSelectionTokens() {
        XCTAssertEqual(LubaSelectionTokens.controlSize, 20)
        XCTAssertEqual(LubaSelectionTokens.indicatorSize, 10)
        XCTAssertEqual(LubaSelectionTokens.borderWidth, 1.5)
        XCTAssertEqual(LubaSelectionTokens.checkboxRadius, 5)
        XCTAssertEqual(LubaSelectionTokens.checkmarkSize, 11)
        XCTAssertEqual(LubaSelectionTokens.labelSpacing, 10)
        XCTAssertEqual(LubaSelectionTokens.minTouchTarget, 44)
    }
    
    func testToggleTokens() {
        XCTAssertEqual(LubaToggleTokens.trackWidth, 48)
        XCTAssertEqual(LubaToggleTokens.trackHeight, 28)
        XCTAssertEqual(LubaToggleTokens.thumbSize, 24)
        XCTAssertEqual(LubaToggleTokens.thumbPadding, 2)
        XCTAssertEqual(LubaToggleTokens.minTouchTarget, 44)
        
        // Thumb must fit inside track with padding
        let availableSpace = LubaToggleTokens.trackWidth - (LubaToggleTokens.thumbPadding * 2)
        XCTAssertGreaterThanOrEqual(availableSpace, LubaToggleTokens.thumbSize,
                                     "Thumb must fit inside track")
    }
    
    func testSliderTokens() {
        XCTAssertEqual(LubaSliderTokens.trackHeight, 4)
        XCTAssertEqual(LubaSliderTokens.thumbSize, 22)
        XCTAssertGreaterThan(LubaSliderTokens.thumbDragScale, 1.0,
                             "Drag scale should enlarge thumb")
    }
    
    // MARK: - Feedback Token Tests
    
    func testToastTokens() {
        XCTAssertEqual(LubaToastTokens.cornerRadius, 12)
        XCTAssertEqual(LubaToastTokens.defaultDuration, 3.0)
        XCTAssertGreaterThan(LubaToastTokens.defaultDuration, 0)
    }
    
    func testProgressTokens() {
        XCTAssertEqual(LubaProgressTokens.barHeight, 6)
        XCTAssertEqual(LubaProgressTokens.circularSize, 64)
        XCTAssertEqual(LubaProgressTokens.circularStrokeWidth, 6)
        XCTAssertGreaterThan(LubaProgressTokens.labelFontRatio, 0)
        XCTAssertLessThan(LubaProgressTokens.labelFontRatio, 1)
    }
    
    func testSpinnerTokens() {
        XCTAssertEqual(LubaSpinnerTokens.defaultSize, 20)
        XCTAssertGreaterThan(LubaSpinnerTokens.arcTrim, 0)
        XCTAssertLessThan(LubaSpinnerTokens.arcTrim, 1)
        XCTAssertGreaterThan(LubaSpinnerTokens.arcDuration, 0)
    }
    
    func testSkeletonTokens() {
        XCTAssertEqual(LubaSkeletonTokens.shimmerDuration, 1.5)
        XCTAssertEqual(LubaSkeletonTokens.defaultLineCount, 3)
        XCTAssertGreaterThan(LubaSkeletonTokens.lastLineRatio, 0)
        XCTAssertLessThan(LubaSkeletonTokens.lastLineRatio, 1)
    }
    
    func testTabsTokens() {
        XCTAssertEqual(LubaTabsTokens.tabHeight, 32)
        XCTAssertEqual(LubaTabsTokens.underlineHeight, 44)
    }
    
    func testSheetTokens() {
        XCTAssertEqual(LubaSheetTokens.closeButtonSize, 28)
        XCTAssertEqual(LubaSheetTokens.headerPadding, 16)
    }
    
    func testIconTokens() {
        XCTAssertEqual(LubaIconTokens.touchTarget, 44, "Touch target should be Apple HIG minimum")
        XCTAssertEqual(LubaIconTokens.pressScale, LubaMotion.pressScaleCompact,
                       "Icon press scale should reference LubaMotion.pressScaleCompact")
        XCTAssertEqual(LubaIconTokens.pressScale, 0.95)
        XCTAssertLessThan(LubaIconTokens.pressScale, 1.0)
        XCTAssertGreaterThan(LubaIconTokens.pressScale, 0.5)
    }
    
    // MARK: - Card Token Tests
    
    func testCardTokens() {
        XCTAssertEqual(LubaCardTokens.cornerRadius, 14)
        XCTAssertEqual(LubaCardTokens.padding, LubaSpacing.lg)
        XCTAssertEqual(LubaCardTokens.paddingCompact, LubaSpacing.md)
        XCTAssertEqual(LubaCardTokens.paddingLarge, LubaSpacing.xl)
        XCTAssertEqual(LubaCardTokens.borderWidth, 1)
    }
    
    // MARK: - Card Elevation Tests
    
    func testCardElevationProgression() {
        let elevations: [LubaCardElevation] = [.flat, .low, .medium, .high]
        
        // Shadow radius should increase with elevation
        for i in 0..<(elevations.count - 1) {
            XCTAssertLessThanOrEqual(elevations[i].shadowRadius, elevations[i + 1].shadowRadius)
            XCTAssertLessThanOrEqual(elevations[i].shadowOpacity, elevations[i + 1].shadowOpacity)
        }
        
        // Flat should have zero shadow
        XCTAssertEqual(LubaCardElevation.flat.shadowRadius, 0)
        XCTAssertEqual(LubaCardElevation.flat.shadowOpacity, 0)
        XCTAssertEqual(LubaCardElevation.flat.shadowY, 0)
    }
    
    func testCardElevationDarkModeAdjustment() {
        // Dark mode shadows should be stronger
        let elevation = LubaCardElevation.low
        let lightOpacity = elevation.adjustedOpacity(for: .light)
        let darkOpacity = elevation.adjustedOpacity(for: .dark)
        XCTAssertGreaterThan(darkOpacity, lightOpacity)
    }
    
    // MARK: - Button Style Tests
    
    func testButtonStyleEnum() {
        let styles: [LubaButtonStyle] = [.primary, .secondary, .ghost, .destructive, .subtle]
        for style in styles {
            XCTAssertNotNil(style.styling, "Style \(style) should produce a styling instance")
        }
    }
    
    func testButtonStyleType() {
        let types: [LubaButtonStyleType] = [.primary, .secondary, .ghost, .destructive, .subtle]
        for type in types {
            XCTAssertNotNil(type.styling, "Type \(type) should produce a styling instance")
        }
    }
    
    func testPrimaryStyleFullWidth() {
        let style = LubaPrimaryStyle()
        XCTAssertTrue(style.defaultsToFullWidth)
        XCTAssertEqual(style.haptic, .medium)
    }
    
    func testSecondaryStyleNotFullWidth() {
        let style = LubaSecondaryStyle()
        XCTAssertFalse(style.defaultsToFullWidth)
        XCTAssertEqual(style.haptic, .light)
    }
    
    func testGhostStyleTransparent() {
        let style = LubaGhostStyle()
        let bg = style.backgroundColor(isPressed: false, colorScheme: .light)
        XCTAssertEqual(bg, .clear)
        XCTAssertEqual(style.haptic, .soft)
    }
    
    func testDestructiveStyleFullWidth() {
        let style = LubaDestructiveStyle()
        XCTAssertTrue(style.defaultsToFullWidth)
        XCTAssertEqual(style.haptic, .warning)
    }
    
    func testSubtleStyleMinimal() {
        let style = LubaSubtleStyle()
        let bg = style.backgroundColor(isPressed: false, colorScheme: .light)
        XCTAssertEqual(bg, .clear)
        XCTAssertEqual(style.haptic, .soft)
    }
    
    func testButtonStylingDefaults() {
        // Test that protocol default implementations work
        let style = LubaGhostStyle()
        XCTAssertEqual(style.borderWidth, 1)
    }
    
    // MARK: - Button Size Tests
    
    func testButtonSizeProgression() {
        let sizes: [LubaButtonSize] = [.small, .medium, .large]

        for i in 0..<(sizes.count - 1) {
            XCTAssertLessThanOrEqual(sizes[i].verticalPadding, sizes[i + 1].verticalPadding)
            XCTAssertLessThanOrEqual(sizes[i].horizontalPadding, sizes[i + 1].horizontalPadding)
            XCTAssertLessThanOrEqual(sizes[i].minHeight, sizes[i + 1].minHeight)
            XCTAssertLessThanOrEqual(sizes[i].iconSize, sizes[i + 1].iconSize)
            XCTAssertLessThanOrEqual(sizes[i].cornerRadius, sizes[i + 1].cornerRadius)
        }
    }

    func testMediumButtonMinHeight() {
        // All button sizes meet Apple HIG 44pt minimum touch target
        XCTAssertGreaterThanOrEqual(LubaButtonSize.small.minHeight, 44,
                       "Small button should meet Apple HIG 44pt minimum touch target")
        XCTAssertEqual(LubaButtonSize.medium.minHeight, 44,
                       "Medium button should meet Apple HIG 44pt minimum touch target")
    }

    func testButtonPaddingOnGrid() {
        // All button padding values should be multiples of 4 (on the 4pt grid)
        let sizes: [LubaButtonSize] = [.small, .medium, .large]
        for size in sizes {
            XCTAssertEqual(size.verticalPadding.truncatingRemainder(dividingBy: 4), 0,
                           "\(size) vertical padding should be on the 4pt grid")
            XCTAssertEqual(size.horizontalPadding.truncatingRemainder(dividingBy: 4), 0,
                           "\(size) horizontal padding should be on the 4pt grid")
        }
    }
    
    // MARK: - Field Token Tests
    
    func testFieldTokens() {
        XCTAssertEqual(LubaFieldTokens.minHeight, 48)
        XCTAssertEqual(LubaFieldTokens.cornerRadius, 10)
        XCTAssertGreaterThan(LubaFieldTokens.borderWidthFocused, LubaFieldTokens.borderWidth,
                             "Focused border should be thicker than normal")
    }
    
    func testFieldState() {
        // Verify LubaFieldState produces different colors per state
        let states: [LubaFieldState] = [.normal, .focused, .error, .disabled]
        for state in states {
            XCTAssertNotNil(state.labelColor())
            XCTAssertNotNil(state.borderColor())
            XCTAssertNotNil(state.iconColor())
        }
    }
    
    // MARK: - Avatar Size Tests
    
    func testAvatarSizeProgression() {
        let sizes: [LubaAvatarSize] = [.small, .medium, .large, .xlarge]
        for i in 0..<(sizes.count - 1) {
            XCTAssertLessThan(sizes[i].dimension, sizes[i + 1].dimension)
        }
        
        XCTAssertEqual(LubaAvatarSize.small.dimension, 32)
        XCTAssertEqual(LubaAvatarSize.medium.dimension, 40)
        XCTAssertEqual(LubaAvatarSize.large.dimension, 56)
        XCTAssertEqual(LubaAvatarSize.xlarge.dimension, 80)
    }
    
    func testAvatarFontSizeRelative() {
        // Font size should be 40% of dimension
        for size in [LubaAvatarSize.small, .medium, .large, .xlarge] {
            XCTAssertEqual(size.fontSize, size.dimension * 0.4, accuracy: 0.01)
        }
    }
    
    // MARK: - Icon Size Tests
    
    func testIconSizeProgression() {
        let sizes = LubaIconSize.allCases
        for i in 0..<(sizes.count - 1) {
            XCTAssertLessThan(sizes[i].dimension, sizes[i + 1].dimension)
        }
    }
    
    // MARK: - Toast Style Tests
    
    func testToastStyleIcons() {
        let styles: [LubaToastStyle] = [.info, .success, .warning, .error]
        for style in styles {
            XCTAssertFalse(style.icon.isEmpty, "\(style) should have an icon")
            XCTAssertNotNil(style.color, "\(style) should have a color")
        }
    }
    
    // MARK: - Sheet Size Tests
    
    func testSheetSizeDetents() {
        // Each sheet size should produce a valid detent
        let sizes: [LubaSheetSize] = [.small, .medium, .large, .full]
        for size in sizes {
            XCTAssertNotNil(size.detent)
        }
    }
    
    // MARK: - Long Press Token Tests
    
    func testLongPressTokens() {
        XCTAssertEqual(LubaLongPressTokens.defaultDuration, 0.8)
        XCTAssertEqual(LubaLongPressTokens.minimumDuration, 0.3)
        XCTAssertLessThan(LubaLongPressTokens.pressScale, 1.0)
        XCTAssertGreaterThan(LubaLongPressTokens.defaultProgressSize, 0)
    }
    
    // MARK: - Expand Token Tests
    
    func testExpandTokens() {
        XCTAssertEqual(LubaExpandTokens.chevronIcon, "chevron.down")
        XCTAssertEqual(LubaExpandTokens.headerPadding, LubaSpacing.md)
        XCTAssertEqual(LubaExpandTokens.contentPadding, LubaSpacing.md)
    }
    
    // MARK: - Swipe Token Tests
    
    func testSwipeTokens() {
        XCTAssertEqual(LubaSwipeTokens.revealThreshold, 60)
        XCTAssertEqual(LubaSwipeTokens.actionWidth, 72)
        XCTAssertEqual(LubaSwipeTokens.maxActions, 3)
        XCTAssertEqual(LubaSwipeTokens.fullSwipeThreshold, 0.6)
    }
    
    // MARK: - Shimmer Token Tests
    
    func testShimmerTokens() {
        XCTAssertEqual(LubaShimmerTokens.duration, 1.5)
        XCTAssertEqual(LubaShimmerTokens.defaultIntensity, 0.6)
        XCTAssertEqual(LubaShimmerTokens.gradientWidth, 0.4)
        XCTAssertLessThan(LubaShimmerTokens.startOffset, LubaShimmerTokens.endOffset)
    }
    
    // MARK: - Swipe Action Presets Tests
    
    func testSwipeActionPresets() {
        let deleteAction = LubaSwipeAction.delete { }
        XCTAssertEqual(deleteAction.icon, "trash.fill")
        XCTAssertEqual(deleteAction.label, "Delete")
        
        let archiveAction = LubaSwipeAction.archive { }
        XCTAssertEqual(archiveAction.icon, "archivebox.fill")
        XCTAssertEqual(archiveAction.label, "Archive")
        
        let pinAction = LubaSwipeAction.pin { }
        XCTAssertEqual(pinAction.icon, "pin.fill")
        XCTAssertEqual(pinAction.label, "Pin")
        
        let unreadAction = LubaSwipeAction.unread { }
        XCTAssertEqual(unreadAction.label, "Unread")
        
        let flagAction = LubaSwipeAction.flag { }
        XCTAssertEqual(flagAction.label, "Flag")
        
        let shareAction = LubaSwipeAction.share { }
        XCTAssertEqual(shareAction.label, "Share")
    }
    
    // MARK: - Accordion Item Tests
    
    func testAccordionItem() {
        let item = LubaAccordionItem(title: "FAQ", content: "Answer", icon: "star")
        XCTAssertFalse(item.id.isEmpty)
        XCTAssertEqual(item.title, "FAQ")
        XCTAssertEqual(item.content, "Answer")
        XCTAssertEqual(item.icon, "star")
    }
    
    func testAccordionItemDefaultIcon() {
        let item = LubaAccordionItem(title: "Q", content: "A")
        XCTAssertNil(item.icon)
        XCTAssertFalse(item.id.isEmpty)
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
    
    // MARK: - Animation Preset Tests
    
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
    
    // MARK: - Transition Preset Tests
    
    func testTransitionPresetsExist() {
        XCTAssertNotNil(AnyTransition.lubaSlideUp)
        XCTAssertNotNil(AnyTransition.lubaScale)
        XCTAssertNotNil(AnyTransition.lubaFade)
    }
    
    // MARK: - Cross-Consistency Tests
    
    func testSpacingConsistencyWithPrimitives() {
        // Tier 2 spacing should match Tier 1 primitives
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
        // Tier 2 radius should match Tier 1 primitives
        XCTAssertEqual(LubaRadius.xs, LubaPrimitives.radius4)
        XCTAssertEqual(LubaRadius.sm, LubaPrimitives.radius8)
        XCTAssertEqual(LubaRadius.md, LubaPrimitives.radius12)
        XCTAssertEqual(LubaRadius.lg, LubaPrimitives.radius16)
        XCTAssertEqual(LubaRadius.xl, LubaPrimitives.radius24)
        XCTAssertEqual(LubaRadius.full, LubaPrimitives.radiusFull)
    }
    
    func testTouchTargetConsistency() {
        // All touch targets should meet Apple HIG minimum
        let appleMinimum: CGFloat = 44
        XCTAssertGreaterThanOrEqual(LubaSelectionTokens.minTouchTarget, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaToggleTokens.minTouchTarget, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaIconTokens.touchTarget, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaFieldTokens.minHeight, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaButtonSize.small.minHeight, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaButtonSize.medium.minHeight, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaConfig.shared.minimumTouchTarget, appleMinimum)
    }

    // MARK: - Alert Style Tests

    func testAlertStylesCoverage() {
        let styles: [LubaAlertStyle] = [.info, .success, .warning, .error]
        XCTAssertEqual(styles.count, 4, "Should have 4 alert styles")
    }

    func testAlertCreationAllStyles() {
        let styles: [LubaAlertStyle] = [.info, .success, .warning, .error]
        for style in styles {
            let alert = LubaAlert("Test", style: style)
            XCTAssertNotNil(alert)
        }
    }

    // MARK: - Chip Style Tests

    func testChipStyles() {
        let styles: [LubaChipStyle] = [.filled, .outlined]
        XCTAssertEqual(styles.count, 2)
    }

    // MARK: - Menu Item Tests

    func testMenuItemCreation() {
        var actionCalled = false
        let item = LubaMenuItem("Edit", icon: Image(systemName: "pencil"), role: .normal) {
            actionCalled = true
        }
        XCTAssertEqual(item.label, "Edit")
        XCTAssertNotNil(item.icon)
        XCTAssertEqual(item.role, .normal)
        item.action()
        XCTAssertTrue(actionCalled)
    }

    func testMenuItemDestructiveRole() {
        let item = LubaMenuItem("Delete", role: .destructive) { }
        XCTAssertEqual(item.role, .destructive)
        XCTAssertEqual(item.label, "Delete")
    }

    func testMenuItemDefaultRole() {
        let item = LubaMenuItem("Copy") { }
        XCTAssertEqual(item.role, .normal)
        XCTAssertNil(item.icon)
    }

    // MARK: - Menu Tokens Tests

    func testMenuTokens() {
        XCTAssertEqual(LubaMenuTokens.minWidth, 200)
        XCTAssertEqual(LubaMenuTokens.itemHeight, 44, "Menu items should meet Apple HIG touch target")
        XCTAssertEqual(LubaMenuTokens.cornerRadius, 12)
        XCTAssertGreaterThan(LubaMenuTokens.shadowBlur, 0)
        XCTAssertGreaterThan(LubaMenuTokens.shadowOpacity, 0)
    }

    // MARK: - Tooltip Tokens Tests

    func testTooltipTokens() {
        XCTAssertEqual(LubaTooltipTokens.maxWidth, 240)
        XCTAssertEqual(LubaTooltipTokens.cornerRadius, 8)
        XCTAssertEqual(LubaTooltipTokens.dismissDuration, 3.0)
        XCTAssertGreaterThan(LubaTooltipTokens.padding, 0)
        XCTAssertGreaterThan(LubaTooltipTokens.offsetFromAnchor, 0)
    }

    // MARK: - Tooltip Position Tests

    func testTooltipPositions() {
        let positions: [LubaTooltipPosition] = [.top, .bottom]
        XCTAssertEqual(positions.count, 2)
    }

    // MARK: - Subtle Color Tests

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

    // MARK: - Badge Size Tests

    func testBadgeSizeProgression() {
        XCTAssertLessThan(LubaBadgeSize.small.fontSize, LubaBadgeSize.medium.fontSize)
        XCTAssertLessThan(LubaBadgeSize.small.iconSize, LubaBadgeSize.medium.iconSize)
        XCTAssertLessThan(LubaBadgeSize.small.verticalPadding, LubaBadgeSize.medium.verticalPadding)
        XCTAssertLessThan(LubaBadgeSize.small.horizontalPadding, LubaBadgeSize.medium.horizontalPadding)
    }

    // MARK: - Badge Style Tests

    func testBadgeStylesCoverage() {
        let styles: [LubaBadgeStyle] = [.accent, .subtle, .neutral, .success, .warning, .error]
        XCTAssertEqual(styles.count, 6, "Should have 6 badge styles")
    }

    // MARK: - Card Style Tests

    func testCardStylesCoverage() {
        let styles: [LubaCardStyle] = [.filled, .outlined]
        XCTAssertEqual(styles.count, 2)
    }

    func testCardElevationsCoverage() {
        let elevations: [LubaCardElevation] = [.flat, .low, .medium, .high]
        XCTAssertEqual(elevations.count, 4)
    }

    // MARK: - Divider Orientation Tests

    func testDividerOrientationsCoverage() {
        let orientations: [LubaDivider.Orientation] = [.horizontal, .vertical]
        XCTAssertEqual(orientations.count, 2)
    }

    // MARK: - Component Instantiation Tests

    func testButtonCreation() {
        let button = LubaButton("Test", style: .primary) { }
        XCTAssertNotNil(button)
    }

    func testButtonWithAllStyles() {
        let styles: [LubaButtonStyle] = [.primary, .secondary, .ghost, .destructive, .subtle]
        for style in styles {
            let button = LubaButton("Test", style: style) { }
            XCTAssertNotNil(button)
        }
    }

    func testButtonWithAllSizes() {
        let sizes: [LubaButtonSize] = [.small, .medium, .large]
        for size in sizes {
            let button = LubaButton("Test", style: .primary, size: size) { }
            XCTAssertNotNil(button)
        }
    }

    func testButtonWithOptions() {
        let button = LubaButton(
            "Submit",
            style: .primary,
            size: .large,
            isLoading: false,
            isDisabled: false,
            icon: Image(systemName: "checkmark"),
            fullWidth: true
        ) { }
        XCTAssertNotNil(button)
    }

    func testCardCreation() {
        let card = LubaCard(elevation: .low, style: .filled) {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    func testTextFieldCreation() {
        let field = LubaTextField("Email", text: .constant(""), placeholder: "test@example.com")
        XCTAssertNotNil(field)
    }

    func testTextFieldConvenience() {
        let email = LubaTextField.email(text: .constant(""))
        XCTAssertNotNil(email)

        let secure = LubaTextField.secure("Password", text: .constant(""))
        XCTAssertNotNil(secure)
    }

    func testCheckboxCreation() {
        let checkbox = LubaCheckbox(isChecked: .constant(true), label: "Accept")
        XCTAssertNotNil(checkbox)
    }

    func testToggleCreation() {
        let toggle = LubaToggle(isOn: .constant(true), label: "Dark Mode")
        XCTAssertNotNil(toggle)
    }

    func testSliderCreation() {
        let slider = LubaSlider(value: .constant(0.5), in: 0...1, label: "Volume")
        XCTAssertNotNil(slider)
    }

    func testAvatarCreation() {
        let avatar = LubaAvatar(name: "Jane Doe", size: .medium)
        XCTAssertNotNil(avatar)
    }

    func testBadgeCreation() {
        let badge = LubaBadge("New", style: .accent, size: .medium)
        XCTAssertNotNil(badge)

        let badgeWithIcon = LubaBadge("Pro", style: .subtle, icon: Image(systemName: "crown"))
        XCTAssertNotNil(badgeWithIcon)
    }

    func testDividerCreation() {
        let divider = LubaDivider()
        XCTAssertNotNil(divider)

        let labeledDivider = LubaDivider(label: "OR")
        XCTAssertNotNil(labeledDivider)
    }

    func testProgressBarCreation() {
        let bar = LubaProgressBar(value: 0.5)
        XCTAssertNotNil(bar)
    }

    func testCircularProgressCreation() {
        let circular = LubaCircularProgress(value: 0.75)
        XCTAssertNotNil(circular)
    }

    func testSpinnerCreation() {
        let spinner = LubaSpinner(size: 20, style: .arc)
        XCTAssertNotNil(spinner)
    }

    func testSkeletonCreation() {
        let skeleton = LubaSkeleton()
        XCTAssertNotNil(skeleton)

        let circle = LubaSkeletonCircle()
        XCTAssertNotNil(circle)
    }

    func testAlertCreation() {
        let alert = LubaAlert("Test message", style: .info)
        XCTAssertNotNil(alert)

        let alertWithTitle = LubaAlert("Message", style: .error, title: "Error", isDismissible: true)
        XCTAssertNotNil(alertWithTitle)
    }

    func testChipCreation() {
        let chip = LubaChip("Swift")
        XCTAssertNotNil(chip)

        let chipFull = LubaChip(
            "Design",
            style: .outlined,
            icon: Image(systemName: "star"),
            isSelected: true,
            isDismissible: true,
            onDismiss: { },
            onTap: { }
        )
        XCTAssertNotNil(chipFull)
    }

    func testSearchBarCreation() {
        let bar = LubaSearchBar(text: .constant(""))
        XCTAssertNotNil(bar)

        let barCustom = LubaSearchBar(text: .constant("query"), placeholder: "Find...", showCancelButton: false)
        XCTAssertNotNil(barCustom)
    }

    func testMenuCreation() {
        let menu = LubaMenu(items: [
            LubaMenuItem("Edit") { },
            LubaMenuItem("Delete", role: .destructive) { }
        ]) {
            Text("Trigger")
        }
        XCTAssertNotNil(menu)
    }

    func testMenuDefaultLabel() {
        let menu = LubaMenu(items: [LubaMenuItem("Test") { }])
        XCTAssertNotNil(menu)
    }

    func testTooltipCreation() {
        let tooltip = LubaTooltip("Help text") {
            Text("Anchor")
        }
        XCTAssertNotNil(tooltip)
    }

    func testToastCreation() {
        let toast = LubaToast("Hello", style: .info)
        XCTAssertNotNil(toast)
    }

    // MARK: - WCAG Contrast Tests

    func testContrastRatioWhiteOnBlack() {
        let ratio = LubaContrast.contrastRatio(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000)
        )
        // White on black should be ~21:1
        XCTAssertGreaterThan(ratio, 20.0)
        XCTAssertLessThanOrEqual(ratio, 21.1)
    }

    func testContrastRatioSameColor() {
        let ratio = LubaContrast.contrastRatio(
            foreground: Color(hex: 0xFF0000),
            background: Color(hex: 0xFF0000)
        )
        // Same color should be 1:1
        XCTAssertEqual(ratio, 1.0, accuracy: 0.01)
    }

    func testMeetsAANormalText() {
        // White on black should pass AA (needs 4.5:1)
        XCTAssertTrue(LubaContrast.meetsAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000)
        ))
    }

    func testMeetsAALargeText() {
        // Large text only needs 3:1 ratio
        XCTAssertTrue(LubaContrast.meetsAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000),
            largeText: true
        ))
    }

    func testMeetsAAANormalText() {
        // White on black should pass AAA (needs 7:1)
        XCTAssertTrue(LubaContrast.meetsAAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000)
        ))
    }

    func testMeetsAAALargeText() {
        // Large text AAA needs 4.5:1
        XCTAssertTrue(LubaContrast.meetsAAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000),
            largeText: true
        ))
    }

    func testLowContrastFailsAA() {
        // Light gray on white should fail AA
        XCTAssertFalse(LubaContrast.meetsAA(
            foreground: Color(hex: 0xCCCCCC),
            background: Color(hex: 0xFFFFFF)
        ))
    }

    // MARK: - Stepper Tests

    func testStepperCreation() {
        let stepper = LubaStepper(value: .constant(5), in: 1...10, label: "Quantity")
        XCTAssertNotNil(stepper)
    }

    func testStepperCustomStep() {
        let stepper = LubaStepper(value: .constant(0), in: 0...100, step: 5)
        XCTAssertNotNil(stepper)
    }

    // MARK: - Rating Tests

    func testRatingCreation() {
        let rating = LubaRating(value: .constant(3))
        XCTAssertNotNil(rating)
    }

    func testRatingWithLabel() {
        let rating = LubaRating(value: .constant(4), maxStars: 5, isReadOnly: true, label: "Score")
        XCTAssertNotNil(rating)
    }

    // MARK: - TextArea Tests

    func testTextAreaCreation() {
        let area = LubaTextArea("Bio", text: .constant(""), placeholder: "Tell us...")
        XCTAssertNotNil(area)
    }

    func testTextAreaWithLimit() {
        let area = LubaTextArea("Tweet", text: .constant("Hello"), characterLimit: 280)
        XCTAssertNotNil(area)
    }

    // MARK: - Link Tests

    func testLinkCreation() {
        let link = LubaLink("Learn more") { }
        XCTAssertNotNil(link)
    }

    func testLinkStyles() {
        let styles: [LubaLinkStyle] = [.default, .subtle, .external]
        XCTAssertEqual(styles.count, 3)
        for style in styles {
            let link = LubaLink("Test", style: style) { }
            XCTAssertNotNil(link)
        }
    }
}
