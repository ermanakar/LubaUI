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
- **Accessible by default.** Every interactive component meets the 44pt touch target minimum, supports Dynamic Type, and integrates with VoiceOver.

LubaUI targets iOS 16+, macOS 13+, watchOS 9+, tvOS 16+, and visionOS 1.0+.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ThreeTierTokenSystem>
- <doc:ComposablePrimitives>

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

### Configuration

- ``LubaConfig``
- ``LubaThemeConfiguration``
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

- ``LubaHaptics``
- ``LubaAccessible``
- ``LubaReducedMotion``
- ``LubaContrast``
- ``LubaAnnounce``
