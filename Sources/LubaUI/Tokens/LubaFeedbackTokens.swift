//
//  LubaFeedbackTokens.swift
//  LubaUI
//
//  Design tokens for feedback, loading, and notification components.
//  Centralizes magic numbers with documented rationale.
//

import SwiftUI

// MARK: - Toast Tokens

/// Design tokens for LubaToast
public enum LubaToastTokens {
    /// Icon size - 16pt feels balanced with text
    public static let iconSize: CGFloat = 16

    /// Horizontal padding - 14pt provides comfortable breathing room
    public static let horizontalPadding: CGFloat = LubaSpacing.lg

    /// Vertical padding - 12pt (slightly less than horizontal for visual balance)
    public static let verticalPadding: CGFloat = 12

    /// Corner radius - 12pt matches card aesthetic
    public static let cornerRadius: CGFloat = 12

    /// Shadow blur - 8pt for subtle depth
    public static let shadowBlur: CGFloat = 8

    /// Shadow Y offset - 4pt anchors it visually
    public static let shadowY: CGFloat = 4

    /// Shadow opacity
    public static let shadowOpacity: CGFloat = 0.08

    /// Default auto-dismiss duration in seconds
    public static let defaultDuration: Double = 3.0

    /// Spacing between icon and message
    public static let iconSpacing: CGFloat = LubaSpacing.sm

    /// Message font size
    public static let messageFontSize: CGFloat = 14

    /// Action button font size
    public static let actionFontSize: CGFloat = 13

    /// Top padding from screen edge
    public static let topPadding: CGFloat = 16

    /// Horizontal margin from screen edges
    public static let horizontalMargin: CGFloat = 20
}

// MARK: - Progress Tokens

/// Design tokens for LubaProgressBar and LubaCircularProgress
public enum LubaProgressTokens {
    /// Linear progress bar height
    public static let barHeight: CGFloat = 6

    /// Default circular progress size
    public static let circularSize: CGFloat = 64

    /// Default circular progress stroke width
    public static let circularStrokeWidth: CGFloat = 6

    /// Label font size ratio relative to circular size
    public static let labelFontRatio: CGFloat = 0.25
}

// MARK: - Spinner Tokens

/// Design tokens for LubaSpinner
public enum LubaSpinnerTokens {
    /// Default spinner size
    public static let defaultSize: CGFloat = 20

    /// Arc spinner trim amount (how much of circle is visible)
    public static let arcTrim: CGFloat = 0.65

    /// Arc spinner rotation duration
    public static let arcDuration: Double = 0.75

    /// Stroke width ratio relative to size
    public static let strokeRatio: CGFloat = 0.1

    /// Pulse animation duration
    public static let pulseDuration: Double = 1.0

    /// Pulse scale range
    public static let pulseMinScale: CGFloat = 0.6

    /// Dots animation duration
    public static let dotsDuration: Double = 0.4

    /// Dots stagger delay
    public static let dotsStagger: Double = 0.12

    /// Dot size ratio relative to spinner size
    public static let dotSizeRatio: CGFloat = 0.22

    /// Dots spacing ratio
    public static let dotsSpacingRatio: CGFloat = 0.2

    /// Breathe animation duration
    public static let breatheDuration: Double = 0.8

    /// Breathe scale range
    public static let breatheMinScale: CGFloat = 0.7

    /// Breathe min opacity
    public static let breatheMinOpacity: CGFloat = 0.5
}

// MARK: - Skeleton Tokens

/// Design tokens for LubaSkeleton components
public enum LubaSkeletonTokens {
    /// Default corner radius
    public static let cornerRadius: CGFloat = 4

    /// Default line height
    public static let defaultHeight: CGFloat = 14

    /// Shimmer animation duration - 1.5s is smooth without being slow
    public static let shimmerDuration: Double = 1.5

    /// Shimmer gradient width ratio
    public static let shimmerWidthRatio: CGFloat = 0.4

    /// Shimmer start offset
    public static let shimmerStart: CGFloat = -1

    /// Shimmer end offset (rectangle)
    public static let shimmerEndRect: CGFloat = 1.4

    /// Shimmer end offset (circle)
    public static let shimmerEndCircle: CGFloat = 1.5

    /// Shimmer gradient opacity
    public static let shimmerOpacity: CGFloat = 0.6

    /// Default circle skeleton size
    public static let defaultCircleSize: CGFloat = 40

    /// Text skeleton default line count
    public static let defaultLineCount: Int = 3

    /// Text skeleton last line ratio
    public static let lastLineRatio: CGFloat = 0.6

    /// Text skeleton line spacing
    public static let lineSpacing: CGFloat = LubaSpacing.sm

    /// Card skeleton avatar size
    public static let cardAvatarSize: CGFloat = 40

    /// Card skeleton padding
    public static let cardPadding: CGFloat = 16

    /// Card skeleton corner radius
    public static let cardCornerRadius: CGFloat = LubaCardTokens.cornerRadius

    /// Card skeleton header spacing
    public static let headerSpacing: CGFloat = 12

    /// Card skeleton section spacing
    public static let sectionSpacing: CGFloat = LubaSpacing.lg

    /// Row skeleton height
    public static let rowHeight: CGFloat = 60

    /// Row skeleton avatar size
    public static let rowAvatarSize: CGFloat = 44
}

// MARK: - SearchBar Tokens

/// Design tokens for LubaSearchBar
public enum LubaSearchBarTokens {
    /// Search bar height — 40pt is compact, distinct from LubaTextField's 48pt
    public static let height: CGFloat = 40

    /// Horizontal padding inside the bar
    public static let horizontalPadding: CGFloat = LubaSpacing.md

    /// Search icon size
    public static let iconSize: CGFloat = 16

    /// Clear button icon size
    public static let clearIconSize: CGFloat = 14
}

// MARK: - Alert Tokens

/// Design tokens for LubaAlert
public enum LubaAlertTokens {
    /// Corner radius — on the LubaRadius grid
    public static let cornerRadius: CGFloat = LubaRadius.md

    /// Horizontal padding
    public static let horizontalPadding: CGFloat = LubaSpacing.lg

    /// Vertical padding
    public static let verticalPadding: CGFloat = LubaSpacing.md

    /// Status icon size
    public static let iconSize: CGFloat = 18

    /// Icon frame width for alignment
    public static let iconFrameWidth: CGFloat = 20

    /// Spacing between icon and text content
    public static let iconSpacing: CGFloat = LubaSpacing.sm

    /// Dismiss button icon size
    public static let dismissIconSize: CGFloat = 12

    /// Dismiss button tap target
    public static let dismissButtonSize: CGFloat = 24
}

// MARK: - Tabs Tokens

/// Design tokens for LubaTabs
public enum LubaTabsTokens {
    /// Segmented tab internal spacing
    public static let segmentedSpacing: CGFloat = 2

    /// Segmented container padding
    public static let segmentedPadding: CGFloat = 4

    /// Segmented container corner radius
    public static let segmentedContainerRadius: CGFloat = LubaRadius.md

    /// Segmented tab corner radius
    public static let segmentedTabRadius: CGFloat = LubaRadius.sm

    /// Tab height
    public static let tabHeight: CGFloat = 32

    /// Tab horizontal padding
    public static let tabHorizontalPadding: CGFloat = LubaSpacing.lg

    /// Tab icon-label spacing
    public static let iconLabelSpacing: CGFloat = LubaSpacing.xs

    /// Tab font size
    public static let fontSize: CGFloat = 13

    /// Tab icon size
    public static let iconSize: CGFloat = 13

    /// Tab shadow opacity
    public static let shadowOpacity: CGFloat = 0.06

    /// Tab shadow radius
    public static let shadowRadius: CGFloat = 2

    /// Tab shadow Y offset
    public static let shadowY: CGFloat = 1

    /// Underline tab height
    public static let underlineHeight: CGFloat = 44

    /// Underline indicator height
    public static let underlineIndicatorHeight: CGFloat = 2

    /// Underline spacing from text
    public static let underlineSpacing: CGFloat = 8

    /// Underline font size
    public static let underlineFontSize: CGFloat = 14
}

// MARK: - Sheet Tokens

/// Design tokens for LubaSheet
public enum LubaSheetTokens {
    /// Header padding
    public static let headerPadding: CGFloat = 16

    /// Close button size
    public static let closeButtonSize: CGFloat = 28

    /// Close button icon size
    public static let closeIconSize: CGFloat = 12

    /// Title font size
    public static let titleFontSize: CGFloat = 18

    /// Subtitle font size
    public static let subtitleFontSize: CGFloat = 13

    /// Title-subtitle spacing
    public static let titleSpacing: CGFloat = 2
}

// MARK: - Icon Tokens

/// Design tokens for LubaIcon and LubaIconButton
public enum LubaIconTokens {
    /// Touch target size (Apple HIG minimum)
    public static let touchTarget: CGFloat = 44

    /// Circled icon padding multiplier
    public static let circledPaddingMultiplier: CGFloat = 1.8

    /// Icon button press scale — references LubaMotion's compact scale (0.95)
    public static let pressScale: CGFloat = LubaMotion.pressScaleCompact

    /// Icon button press opacity
    public static let pressOpacity: CGFloat = 0.7
}

// MARK: - Menu Tokens

/// Design tokens for LubaMenu
public enum LubaMenuTokens {
    /// Minimum menu width
    public static let minWidth: CGFloat = 200

    /// Menu item height — matches Apple HIG touch target
    public static let itemHeight: CGFloat = 44

    /// Item horizontal padding
    public static let itemPadding: CGFloat = LubaSpacing.lg

    /// Corner radius — matches card aesthetic
    public static let cornerRadius: CGFloat = 12

    /// Shadow blur for elevated menu
    public static let shadowBlur: CGFloat = 16

    /// Shadow Y offset
    public static let shadowY: CGFloat = 6

    /// Shadow opacity
    public static let shadowOpacity: CGFloat = 0.12

    /// Icon size in menu items
    public static let iconSize: CGFloat = 16

    /// Spacing between icon and label
    public static let iconSpacing: CGFloat = LubaSpacing.sm
}

// MARK: - Tooltip Tokens

/// Design tokens for LubaTooltip
public enum LubaTooltipTokens {
    /// Maximum tooltip width before wrapping
    public static let maxWidth: CGFloat = 240

    /// Internal padding
    public static let padding: CGFloat = LubaSpacing.md

    /// Corner radius — smaller than cards for a tight feel
    public static let cornerRadius: CGFloat = 8

    /// Shadow blur
    public static let shadowBlur: CGFloat = 8

    /// Shadow Y offset
    public static let shadowY: CGFloat = 4

    /// Shadow opacity
    public static let shadowOpacity: CGFloat = 0.10

    /// Text font size
    public static let fontSize: CGFloat = 13

    /// Arrow size (triangle pointer)
    public static let arrowSize: CGFloat = 6

    /// Offset from anchor view
    public static let offsetFromAnchor: CGFloat = 8

    /// Auto-dismiss duration in seconds
    public static let dismissDuration: Double = 3.0
}
