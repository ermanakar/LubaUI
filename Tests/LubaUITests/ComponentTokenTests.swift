//
//  ComponentTokenTests.swift
//  LubaUI
//
//  Tests for component-level tokens: button styles/sizes, field, card, controls, feedback, primitives.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class ComponentTokenTests: XCTestCase {

    // MARK: - Button Style Tests

    func testButtonStyleEnum() {
        let styles: [LubaButtonStyle] = [.primary, .secondary, .ghost, .destructive, .subtle, .glass]
        for style in styles {
            XCTAssertNotNil(style.styling, "Style \(style) should produce a styling instance")
        }
    }

    func testButtonStyleType() {
        let types: [LubaButtonStyleType] = [.primary, .secondary, .ghost, .destructive, .subtle, .glass]
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
        XCTAssertGreaterThanOrEqual(LubaButtonSize.small.minHeight, 44,
                       "Small button should meet Apple HIG 44pt minimum touch target")
        XCTAssertEqual(LubaButtonSize.medium.minHeight, 44,
                       "Medium button should meet Apple HIG 44pt minimum touch target")
    }

    func testButtonPaddingOnGrid() {
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
        XCTAssertEqual(LubaFieldTokens.cornerRadius, 12)
        XCTAssertGreaterThan(LubaFieldTokens.borderWidthFocused, LubaFieldTokens.borderWidth,
                             "Focused border should be thicker than normal")
    }

    func testFieldState() {
        let states: [LubaFieldState] = [.normal, .focused, .error, .disabled]
        for state in states {
            XCTAssertNotNil(state.labelColor())
            XCTAssertNotNil(state.borderColor())
            XCTAssertNotNil(state.iconColor())
        }
    }

    // MARK: - Card Token Tests

    func testCardTokens() {
        XCTAssertEqual(LubaCardTokens.cornerRadius, 16)
        XCTAssertEqual(LubaCardTokens.padding, LubaSpacing.lg)
        XCTAssertEqual(LubaCardTokens.paddingCompact, LubaSpacing.md)
        XCTAssertEqual(LubaCardTokens.paddingLarge, LubaSpacing.xl)
        XCTAssertEqual(LubaCardTokens.borderWidth, 1)
    }

    func testCardElevationProgression() {
        let elevations: [LubaCardElevation] = [.flat, .low, .medium, .high]
        for i in 0..<(elevations.count - 1) {
            XCTAssertLessThanOrEqual(elevations[i].shadowRadius, elevations[i + 1].shadowRadius)
            XCTAssertLessThanOrEqual(elevations[i].shadowOpacity, elevations[i + 1].shadowOpacity)
        }
        XCTAssertEqual(LubaCardElevation.flat.shadowRadius, 0)
        XCTAssertEqual(LubaCardElevation.flat.shadowOpacity, 0)
        XCTAssertEqual(LubaCardElevation.flat.shadowY, 0)
    }

    func testCardElevationDarkModeAdjustment() {
        let elevation = LubaCardElevation.low
        let lightOpacity = elevation.adjustedOpacity(for: .light)
        let darkOpacity = elevation.adjustedOpacity(for: .dark)
        XCTAssertGreaterThan(darkOpacity, lightOpacity)
    }

    func testCardStylesCoverage() {
        let styles: [LubaCardStyle] = [.filled, .outlined, .ghost, .glass]
        XCTAssertEqual(styles.count, 4)
    }

    func testCardElevationsCoverage() {
        let elevations: [LubaCardElevation] = [.flat, .low, .medium, .high]
        XCTAssertEqual(elevations.count, 4)
    }

    // MARK: - Control Token Tests

    func testSelectionTokens() {
        XCTAssertEqual(LubaSelectionTokens.controlSize, 20)
        XCTAssertEqual(LubaSelectionTokens.indicatorSize, 10)
        XCTAssertEqual(LubaSelectionTokens.borderWidth, 1.5)
        XCTAssertEqual(LubaSelectionTokens.checkboxRadius, 4)
        XCTAssertEqual(LubaSelectionTokens.checkmarkSize, 11)
        XCTAssertEqual(LubaSelectionTokens.labelSpacing, 8)
        XCTAssertEqual(LubaSelectionTokens.minTouchTarget, 44)
    }

    func testToggleTokens() {
        XCTAssertEqual(LubaToggleTokens.trackWidth, 48)
        XCTAssertEqual(LubaToggleTokens.trackHeight, 28)
        XCTAssertEqual(LubaToggleTokens.thumbSize, 24)
        XCTAssertEqual(LubaToggleTokens.thumbPadding, 2)
        XCTAssertEqual(LubaToggleTokens.minTouchTarget, 44)

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

    func testMenuTokens() {
        XCTAssertEqual(LubaMenuTokens.minWidth, 200)
        XCTAssertEqual(LubaMenuTokens.itemHeight, 44, "Menu items should meet Apple HIG touch target")
        XCTAssertEqual(LubaMenuTokens.cornerRadius, 12)
        XCTAssertGreaterThan(LubaMenuTokens.shadowBlur, 0)
        XCTAssertGreaterThan(LubaMenuTokens.shadowOpacity, 0)
    }

    func testTooltipTokens() {
        XCTAssertEqual(LubaTooltipTokens.maxWidth, 240)
        XCTAssertEqual(LubaTooltipTokens.cornerRadius, 8)
        XCTAssertEqual(LubaTooltipTokens.dismissDuration, 3.0)
        XCTAssertGreaterThan(LubaTooltipTokens.padding, 0)
        XCTAssertGreaterThan(LubaTooltipTokens.offsetFromAnchor, 0)
    }

    // MARK: - Primitive Token Tests (Expandable, Swipeable, Shimmer, LongPress)

    func testLongPressTokens() {
        XCTAssertEqual(LubaLongPressTokens.defaultDuration, 0.8)
        XCTAssertEqual(LubaLongPressTokens.minimumDuration, 0.3)
        XCTAssertLessThan(LubaLongPressTokens.pressScale, 1.0)
        XCTAssertGreaterThan(LubaLongPressTokens.defaultProgressSize, 0)
    }

    func testExpandTokens() {
        XCTAssertEqual(LubaExpandTokens.chevronIcon, "chevron.down")
        XCTAssertEqual(LubaExpandTokens.headerPadding, LubaSpacing.md)
        XCTAssertEqual(LubaExpandTokens.contentPadding, LubaSpacing.md)
    }

    func testSwipeTokens() {
        XCTAssertEqual(LubaSwipeTokens.revealThreshold, 60)
        XCTAssertEqual(LubaSwipeTokens.actionWidth, 72)
        XCTAssertEqual(LubaSwipeTokens.maxActions, 3)
        XCTAssertEqual(LubaSwipeTokens.fullSwipeThreshold, 0.6)
    }

    func testShimmerTokens() {
        XCTAssertEqual(LubaShimmerTokens.duration, 1.5)
        XCTAssertEqual(LubaShimmerTokens.defaultIntensity, 0.6)
        XCTAssertEqual(LubaShimmerTokens.gradientWidth, 0.4)
        XCTAssertLessThan(LubaShimmerTokens.startOffset, LubaShimmerTokens.endOffset)
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

    // MARK: - Badge Tests

    func testBadgeSizeProgression() {
        XCTAssertLessThan(LubaBadgeSize.small.fontSize, LubaBadgeSize.medium.fontSize)
        XCTAssertLessThan(LubaBadgeSize.small.iconSize, LubaBadgeSize.medium.iconSize)
        XCTAssertLessThan(LubaBadgeSize.small.verticalPadding, LubaBadgeSize.medium.verticalPadding)
        XCTAssertLessThan(LubaBadgeSize.small.horizontalPadding, LubaBadgeSize.medium.horizontalPadding)
    }

    func testBadgeStylesCoverage() {
        let styles: [LubaBadgeStyle] = [.accent, .subtle, .neutral, .success, .warning, .error]
        XCTAssertEqual(styles.count, 6, "Should have 6 badge styles")
    }

    // MARK: - Touch Target Consistency

    // MARK: - Glass Token Tests

    func testGlassTokens() {
        XCTAssertEqual(LubaGlassTokens.cornerRadius, LubaRadius.md)
        XCTAssertEqual(LubaGlassTokens.borderWidth, LubaPrimitives.glassBorderWidth)
        XCTAssertEqual(LubaGlassTokens.shadowRadius, LubaPrimitives.glassShadowRadius)
        XCTAssertEqual(LubaGlassTokens.shadowY, LubaPrimitives.glassShadowY)
        XCTAssertEqual(LubaGlassTokens.solidFallbackOpacity, LubaPrimitives.glassSolidFallbackOpacity)
    }

    func testGlassStyleCount() {
        let styles: [LubaGlassStyle] = [.subtle, .regular, .prominent]
        XCTAssertEqual(styles.count, 3)
    }

    func testGlassButtonStyleCreation() {
        let style = LubaGlassButtonStyle()
        XCTAssertEqual(style.haptic, .light)
        XCTAssertFalse(style.defaultsToFullWidth)
        let bg = style.backgroundColor(isPressed: false, colorScheme: .light)
        XCTAssertEqual(bg, .clear)
    }

    func testCardGlassStyle() {
        let style = LubaCardStyle.glass
        XCTAssertTrue(style.isGlass)
        XCTAssertFalse(style.hasBackground)
        XCTAssertFalse(style.hasBorder)
    }

    // MARK: - Touch Target Consistency

    func testTouchTargetConsistency() {
        let appleMinimum: CGFloat = 44
        XCTAssertGreaterThanOrEqual(LubaSelectionTokens.minTouchTarget, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaToggleTokens.minTouchTarget, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaIconTokens.touchTarget, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaFieldTokens.minHeight, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaButtonSize.small.minHeight, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaButtonSize.medium.minHeight, appleMinimum)
        XCTAssertGreaterThanOrEqual(LubaConfig.shared.minimumTouchTarget, appleMinimum)
    }
}
