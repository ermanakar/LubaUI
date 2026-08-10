# ``LubaUI``

A SwiftUI design system with named tokens, composable primitives, and accessible components.

@Metadata {
    @DisplayName("LubaUI")
}

## Overview

LubaUI provides a complete design system for SwiftUI apps. Every spacing value, color, radius, and animation constant has a name and documented rationale — making the system legible to both humans and AI tools.

The library is built on three core ideas:

- **Named tokens** replace magic numbers. `LubaSpacing.lg` instead of `16`, `LubaRadius.md` instead of `12`.
- **Composable primitives** extract behaviors into modifiers. Any view can become pressable, expandable, or swipeable — no subclassing required.
- **Accessible by default.** Every interactive component meets the 44pt touch target minimum, scales with Dynamic Type, honors Reduce Motion through a single shared policy, and speaks the user's language via package-localized strings.
- **Themeable for real.** Components resolve their colors and fonts from ``LubaThemeConfiguration`` in the environment, so `.lubaTheme(…)` repaints the subtree it is applied to.

LubaUI targets iOS 16+, macOS 13+, watchOS 9+, tvOS 16+, and visionOS 1.0+.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ThreeTierTokenSystem>
- <doc:ComposablePrimitives>
- <doc:ConfiguringLubaUI>
- <doc:AccessibilityAndMotion>

### Design Tokens

- ``LubaColors``
- ``LubaSpacing``
- ``LubaTypography``
- ``LubaRadius``
- ``LubaMotion``
- ``LubaAnimations``
- ``LubaPrimitives``
- <doc:ColorSystem>
- <doc:SpacingAndLayout>
- <doc:MotionAndAnimation>

### Primitives

- ``LubaPressableModifier``
- ``LubaHapticStyle``
- ``LubaExpandable``
- ``LubaSwipeableModifier``
- ``LubaShimmerableModifier``
- ``LubaLongPressableModifier``
- ``LubaGlassModifier``
- ``LubaButtonStyling``
- <doc:CustomizingButtonStyles>
- <doc:GlassEffects>

### Input Components

- ``LubaButton``
- ``LubaTextField``
- ``LubaTextArea``
- ``LubaSearchBar``
- ``LubaCheckbox``
- ``LubaRadioGroup``
- ``LubaToggle``
- ``LubaSlider``
- ``LubaStepper``
- ``LubaRating``
- ``LubaChip``

### Display Components

- ``LubaCard``
- ``LubaAvatar``
- ``LubaBadge``
- ``LubaDivider``
- ``LubaIcon``
- ``LubaLink``

### Feedback Components

- ``LubaToast``
- ``LubaAlert``
- ``LubaProgressBar``
- ``LubaCircularProgress``
- ``LubaSpinner``
- ``LubaSkeleton``

### Data Visualization

- ``LubaBarChart``
- ``LubaGroupedBarChart``
- ``LubaLineChart``
- ``LubaMultiLineChart``
- ``LubaSparkline``
- ``LubaSparklineTrend``
- ``LubaChartSkeleton``
- ``LubaChartEmptyState``
- ``LubaChartLegend``
- ``LubaChartStyleModifier``
- <doc:Charts>

### Navigation

- ``LubaTabs``
- ``LubaMenu``
- ``LubaTooltip``

### Overlays

- ``LubaSheetModifier``
- ``LubaSheetHeader``
- ``LubaSheetSize``

### Configuration & Theming

- ``LubaEnvironment``
- ``LubaContext``
- ``LubaConfig``
- ``LubaThemeConfiguration``
- ``LubaThemeColors``
- ``LubaStatusRole``
- ``LubaThemeTypography``
- ``LubaThemeSpacing``
- ``LubaThemeRadius``
- <doc:ConfiguringLubaUI>

### Component Tokens

- ``LubaFieldTokens``
- ``LubaCardTokens``
- ``LubaSelectionTokens``
- ``LubaToggleTokens``
- ``LubaSliderTokens``
- ``LubaToastTokens``
- ``LubaProgressTokens``
- ``LubaSpinnerTokens``
- ``LubaSkeletonTokens``
- ``LubaTabsTokens``
- ``LubaSheetTokens``
- ``LubaIconTokens``
- ``LubaMenuTokens``
- ``LubaTooltipTokens``
- ``LubaAlertTokens``
- ``LubaSearchBarTokens``
- ``LubaChartTokens``

### Accessibility

- ``LubaMotionPolicy``
- ``LubaTextRole``
- ``LubaFontSet``
- ``LubaStrings``
- ``LubaHaptics``
- ``LubaAccessible``
- ``LubaContrast``
- ``LubaAnnounce``
- <doc:AccessibilityAndMotion>
