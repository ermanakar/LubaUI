//
//  ComponentTokenTests.swift
//  LubaUI
//
//  Tests for component-level tokens: button styles/sizes, field, card, controls,
//  feedback, primitives, sizes, glass, charts. Each test consolidates related
//  assertions to eliminate one-liner tests while preserving full value coverage.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class ComponentTokenTests: XCTestCase {

    // MARK: - Button Styles

    func testButtonStyleProperties() {
        // All enum cases produce a styling instance
        let styles: [LubaButtonStyle] = [.primary, .secondary, .ghost, .destructive, .subtle, .glass]
        for style in styles {
            XCTAssertNotNil(style.styling, "Style \(style) should produce a styling instance")
        }

        // Primary: full-width, medium haptic
        let primary = LubaPrimaryStyle()
        XCTAssertTrue(primary.defaultsToFullWidth)
        XCTAssertEqual(primary.haptic, .medium)

        // Secondary: not full-width, light haptic
        let secondary = LubaSecondaryStyle()
        XCTAssertFalse(secondary.defaultsToFullWidth)
        XCTAssertEqual(secondary.haptic, .light)

        // Ghost: clear background, soft haptic, 1pt border
        let ghost = LubaGhostStyle()
        XCTAssertEqual(ghost.backgroundColor(isPressed: false, colorScheme: .light), .clear)
        XCTAssertEqual(ghost.haptic, .soft)
        XCTAssertEqual(ghost.borderWidth, 1)

        // Destructive: full-width, warning haptic
        let destructive = LubaDestructiveStyle()
        XCTAssertTrue(destructive.defaultsToFullWidth)
        XCTAssertEqual(destructive.haptic, .warning)

        // Subtle: clear background, soft haptic
        let subtle = LubaSubtleStyle()
        XCTAssertEqual(subtle.backgroundColor(isPressed: false, colorScheme: .light), .clear)
        XCTAssertEqual(subtle.haptic, .soft)
    }

    // MARK: - Button Sizes

    func testButtonSizes() {
        let sizes: [LubaButtonSize] = [.small, .medium, .large]

        // Monotonic progression
        for i in 0..<(sizes.count - 1) {
            XCTAssertLessThanOrEqual(sizes[i].verticalPadding, sizes[i + 1].verticalPadding)
            XCTAssertLessThanOrEqual(sizes[i].horizontalPadding, sizes[i + 1].horizontalPadding)
            XCTAssertLessThanOrEqual(sizes[i].minHeight, sizes[i + 1].minHeight)
            XCTAssertLessThanOrEqual(sizes[i].iconSize, sizes[i + 1].iconSize)
            XCTAssertLessThanOrEqual(sizes[i].cornerRadius, sizes[i + 1].cornerRadius)
        }

        // All sizes meet Apple HIG 44pt minimum
        XCTAssertGreaterThanOrEqual(LubaButtonSize.small.minHeight, 44)
        XCTAssertEqual(LubaButtonSize.medium.minHeight, 44)

        // Padding on 4pt grid
        for size in sizes {
            XCTAssertEqual(size.verticalPadding.truncatingRemainder(dividingBy: 4), 0,
                           "\(size) vertical padding should be on the 4pt grid")
            XCTAssertEqual(size.horizontalPadding.truncatingRemainder(dividingBy: 4), 0,
                           "\(size) horizontal padding should be on the 4pt grid")
        }
    }

    // MARK: - Field Tokens

    func testFieldTokensAndState() {
        XCTAssertEqual(LubaFieldTokens.minHeight, 48)
        XCTAssertEqual(LubaFieldTokens.cornerRadius, 12)
        XCTAssertGreaterThan(LubaFieldTokens.borderWidthFocused, LubaFieldTokens.borderWidth)

        // All states produce colors
        for state in [LubaFieldState.normal, .focused, .error, .disabled] {
            XCTAssertNotNil(state.labelColor())
            XCTAssertNotNil(state.borderColor())
            XCTAssertNotNil(state.iconColor())
        }
    }

    // MARK: - Card Tokens

    func testCardTokensAndElevation() {
        // Static token values
        XCTAssertEqual(LubaCardTokens.cornerRadius, 16)
        XCTAssertEqual(LubaCardTokens.padding, LubaSpacing.lg)
        XCTAssertEqual(LubaCardTokens.paddingCompact, LubaSpacing.md)
        XCTAssertEqual(LubaCardTokens.paddingLarge, LubaSpacing.xl)
        XCTAssertEqual(LubaCardTokens.borderWidth, 1)

        // Elevation progression
        let elevations: [LubaCardElevation] = [.flat, .low, .medium, .high]
        for i in 0..<(elevations.count - 1) {
            XCTAssertLessThanOrEqual(elevations[i].shadowRadius, elevations[i + 1].shadowRadius)
            XCTAssertLessThanOrEqual(elevations[i].shadowOpacity, elevations[i + 1].shadowOpacity)
        }
        XCTAssertEqual(LubaCardElevation.flat.shadowRadius, 0)
        XCTAssertEqual(LubaCardElevation.flat.shadowOpacity, 0)

        // Dark mode shadow adjustment
        let low = LubaCardElevation.low
        XCTAssertGreaterThan(low.adjustedOpacity(for: .dark), low.adjustedOpacity(for: .light))
    }

    // MARK: - Control Tokens

    func testControlTokens() {
        // Selection
        XCTAssertEqual(LubaSelectionTokens.controlSize, 20)
        XCTAssertEqual(LubaSelectionTokens.indicatorSize, 10)
        XCTAssertEqual(LubaSelectionTokens.borderWidth, 1.5)
        XCTAssertEqual(LubaSelectionTokens.checkboxRadius, 4)
        XCTAssertEqual(LubaSelectionTokens.checkmarkSize, 11)
        XCTAssertEqual(LubaSelectionTokens.labelSpacing, 8)
        XCTAssertEqual(LubaSelectionTokens.minTouchTarget, 44)

        // Toggle: thumb fits inside track
        XCTAssertEqual(LubaToggleTokens.trackWidth, 48)
        XCTAssertEqual(LubaToggleTokens.trackHeight, 28)
        XCTAssertEqual(LubaToggleTokens.thumbSize, 24)
        XCTAssertEqual(LubaToggleTokens.thumbPadding, 2)
        XCTAssertEqual(LubaToggleTokens.minTouchTarget, 44)
        let availableSpace = LubaToggleTokens.trackWidth - (LubaToggleTokens.thumbPadding * 2)
        XCTAssertGreaterThanOrEqual(availableSpace, LubaToggleTokens.thumbSize)

        // Slider
        XCTAssertEqual(LubaSliderTokens.trackHeight, 4)
        XCTAssertEqual(LubaSliderTokens.thumbSize, 22)
        XCTAssertGreaterThan(LubaSliderTokens.thumbDragScale, 1.0)
    }

    // MARK: - Feedback Tokens

    func testFeedbackTokens() {
        // Toast
        XCTAssertEqual(LubaToastTokens.cornerRadius, 12)
        XCTAssertEqual(LubaToastTokens.defaultDuration, 3.0)

        // Progress
        XCTAssertEqual(LubaProgressTokens.barHeight, 6)
        XCTAssertEqual(LubaProgressTokens.circularSize, 64)
        XCTAssertEqual(LubaProgressTokens.circularStrokeWidth, 6)
        XCTAssertGreaterThan(LubaProgressTokens.labelFontRatio, 0)
        XCTAssertLessThan(LubaProgressTokens.labelFontRatio, 1)

        // Spinner
        XCTAssertEqual(LubaSpinnerTokens.defaultSize, 20)
        XCTAssertGreaterThan(LubaSpinnerTokens.arcTrim, 0)
        XCTAssertLessThan(LubaSpinnerTokens.arcTrim, 1)

        // Skeleton
        XCTAssertEqual(LubaSkeletonTokens.shimmerDuration, 1.5)
        XCTAssertEqual(LubaSkeletonTokens.defaultLineCount, 3)
        XCTAssertGreaterThan(LubaSkeletonTokens.lastLineRatio, 0)
        XCTAssertLessThan(LubaSkeletonTokens.lastLineRatio, 1)
    }

    // MARK: - UI Component Tokens

    func testUIComponentTokens() {
        // Tabs
        XCTAssertEqual(LubaTabsTokens.tabHeight, 32)
        XCTAssertEqual(LubaTabsTokens.underlineHeight, 44)

        // Sheet
        XCTAssertEqual(LubaSheetTokens.closeButtonSize, 28)
        XCTAssertEqual(LubaSheetTokens.headerPadding, 16)

        // Icon
        XCTAssertEqual(LubaIconTokens.touchTarget, 44)
        XCTAssertEqual(LubaIconTokens.pressScale, LubaMotion.pressScaleCompact)
        XCTAssertEqual(LubaIconTokens.pressScale, 0.95)

        // Menu
        XCTAssertEqual(LubaMenuTokens.minWidth, 200)
        XCTAssertEqual(LubaMenuTokens.itemHeight, 44)
        XCTAssertEqual(LubaMenuTokens.cornerRadius, 12)

        // Tooltip
        XCTAssertEqual(LubaTooltipTokens.maxWidth, 240)
        XCTAssertEqual(LubaTooltipTokens.cornerRadius, 8)
        XCTAssertEqual(LubaTooltipTokens.dismissDuration, 3.0)
        XCTAssertEqual(LubaTooltipTokens.screenEdgePadding, LubaSpacing.lg)

        // Chip
        XCTAssertEqual(LubaChipTokens.contentSpacing, LubaMotion.iconLabelSpacing)
        XCTAssertEqual(LubaChipTokens.horizontalPadding, LubaSpacing.md)
        XCTAssertEqual(LubaChipTokens.height, 32)
        XCTAssertEqual(LubaChipTokens.borderWidth, 1)
    }

    // MARK: - Primitive Tokens (Expandable, Swipeable, Shimmer, LongPress)

    func testPrimitiveTokens() {
        // Long press
        XCTAssertEqual(LubaLongPressTokens.defaultDuration, 0.8)
        XCTAssertEqual(LubaLongPressTokens.minimumDuration, 0.3)
        XCTAssertLessThan(LubaLongPressTokens.pressScale, 1.0)

        // Expand
        XCTAssertEqual(LubaExpandTokens.chevronIcon, "chevron.down")
        XCTAssertEqual(LubaExpandTokens.headerPadding, LubaSpacing.md)
        XCTAssertEqual(LubaExpandTokens.contentPadding, LubaSpacing.md)

        // Swipe
        XCTAssertEqual(LubaSwipeTokens.revealThreshold, 60)
        XCTAssertEqual(LubaSwipeTokens.actionWidth, 72)
        XCTAssertEqual(LubaSwipeTokens.maxActions, 3)
        XCTAssertEqual(LubaSwipeTokens.fullSwipeThreshold, 0.6)

        // Shimmer
        XCTAssertEqual(LubaShimmerTokens.duration, 1.5)
        XCTAssertEqual(LubaShimmerTokens.defaultIntensity, 0.6)
        XCTAssertEqual(LubaShimmerTokens.gradientWidth, 0.4)
        XCTAssertLessThan(LubaShimmerTokens.startOffset, LubaShimmerTokens.endOffset)
    }

    // MARK: - Size Progressions

    func testAvatarSizes() {
        let sizes: [LubaAvatarSize] = [.small, .medium, .large, .xlarge]
        for i in 0..<(sizes.count - 1) {
            XCTAssertLessThan(sizes[i].dimension, sizes[i + 1].dimension)
        }
        XCTAssertEqual(LubaAvatarSize.small.dimension, 32)
        XCTAssertEqual(LubaAvatarSize.medium.dimension, 40)
        XCTAssertEqual(LubaAvatarSize.large.dimension, 56)
        XCTAssertEqual(LubaAvatarSize.xlarge.dimension, 80)

        // Font size is 40% of dimension
        for size in sizes {
            XCTAssertEqual(size.fontSize, size.dimension * 0.4, accuracy: 0.01)
        }
    }

    func testIconSizeProgression() {
        let sizes = LubaIconSize.allCases
        for i in 0..<(sizes.count - 1) {
            XCTAssertLessThan(sizes[i].dimension, sizes[i + 1].dimension)
        }
    }

    func testBadgeSizes() {
        XCTAssertLessThan(LubaBadgeSize.small.fontSize, LubaBadgeSize.medium.fontSize)
        XCTAssertLessThan(LubaBadgeSize.small.iconSize, LubaBadgeSize.medium.iconSize)
        XCTAssertLessThan(LubaBadgeSize.small.verticalPadding, LubaBadgeSize.medium.verticalPadding)
        XCTAssertLessThan(LubaBadgeSize.small.horizontalPadding, LubaBadgeSize.medium.horizontalPadding)
    }

    // MARK: - Glass Tokens

    func testGlassTokensAndStyles() {
        // Token cross-references
        XCTAssertEqual(LubaGlassTokens.cornerRadius, LubaRadius.md)
        XCTAssertEqual(LubaGlassTokens.borderWidth, LubaPrimitives.glassBorderWidth)
        XCTAssertEqual(LubaGlassTokens.shadowRadius, LubaPrimitives.glassShadowRadius)
        XCTAssertEqual(LubaGlassTokens.shadowY, LubaPrimitives.glassShadowY)
        XCTAssertEqual(LubaGlassTokens.solidFallbackOpacity, LubaPrimitives.glassSolidFallbackOpacity)

        // Glass button style
        let glassButton = LubaGlassButtonStyle()
        XCTAssertEqual(glassButton.haptic, .light)
        XCTAssertFalse(glassButton.defaultsToFullWidth)
        XCTAssertEqual(glassButton.backgroundColor(isPressed: false, colorScheme: .light), .clear)

        // Card glass style
        let glass = LubaCardStyle.glass
        XCTAssertTrue(glass.isGlass)
        XCTAssertFalse(glass.hasBackground)
        XCTAssertFalse(glass.hasBorder)
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

    // MARK: - Chart Tokens

    func testChartTokens() {
        // Height progression
        XCTAssertLessThan(LubaChartTokens.sparklineHeight, LubaChartTokens.compactHeight)
        XCTAssertLessThan(LubaChartTokens.compactHeight, LubaChartTokens.defaultHeight)
        XCTAssertLessThan(LubaChartTokens.defaultHeight, LubaChartTokens.expandedHeight)

        // Height values
        XCTAssertEqual(LubaChartTokens.sparklineHeight, 40)
        XCTAssertEqual(LubaChartTokens.compactHeight, 140)
        XCTAssertEqual(LubaChartTokens.defaultHeight, 200)
        XCTAssertEqual(LubaChartTokens.expandedHeight, 300)

        // Mark dimensions
        XCTAssertEqual(LubaChartTokens.barCornerRadius, LubaRadius.xs)
        XCTAssertEqual(LubaChartTokens.lineWidth, 2.5)
        XCTAssertEqual(LubaChartTokens.pointSize, 6)
        XCTAssertEqual(LubaChartTokens.areaOpacity, 0.15)

        // Grid
        XCTAssertEqual(LubaChartTokens.gridOpacity, 0.12)
        XCTAssertEqual(LubaChartTokens.gridLineWidth, 0.5)

        // Legend
        XCTAssertEqual(LubaChartTokens.legendSpacing, LubaSpacing.md)
        XCTAssertEqual(LubaChartTokens.legendDotSize, 8)

        // Skeleton
        XCTAssertEqual(LubaChartTokens.skeletonBarCount, 5)
        XCTAssertEqual(LubaChartTokens.skeletonLinePointCount, 8)
        XCTAssertGreaterThan(LubaChartTokens.skeletonBarMaxRatio, LubaChartTokens.skeletonBarMinRatio)

        // Palette
        XCTAssertEqual(LubaColors.Chart.palette.count, 6)
    }
}
