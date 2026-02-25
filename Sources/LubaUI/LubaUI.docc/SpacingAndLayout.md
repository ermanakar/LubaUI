# Spacing and Layout

A 4pt grid system and radius scale that keep layouts consistent.

## Overview

LubaUI's spacing and radius tokens replace hardcoded values with named constants that sit on a predictable grid. This makes layouts consistent across components and easy to adjust globally.

### The 4pt Grid

All spacing values are multiples of 4pt. The scale starts with a 2x jump, then alternates between 1.5x and 1.33x multipliers — landing on clean grid values with perceptible gaps between each step.

| Token | Value | Multiplier | Use Case |
|-------|-------|------------|----------|
| `LubaSpacing.xs` | 4pt | — | Tight internal spacing |
| `LubaSpacing.sm` | 8pt | 2x | Icon-to-label gaps |
| `LubaSpacing.md` | 12pt | 1.5x | Form field spacing |
| `LubaSpacing.lg` | 16pt | 1.33x | Standard element spacing |
| `LubaSpacing.xl` | 24pt | 1.5x | Section padding |
| `LubaSpacing.xxl` | 32pt | 1.33x | Major section gaps |
| `LubaSpacing.xxxl` | 48pt | 1.5x | Page-level margins |
| `LubaSpacing.huge` | 64pt | 1.33x | Hero spacing |

```swift
VStack(spacing: LubaSpacing.lg) {
    Text("Title")
    Text("Subtitle")
}
.padding(LubaSpacing.xl)
```

### Convenience Modifiers

LubaUI provides padding modifiers that accept tokens directly:

```swift
// Uniform padding
view.lubaPadding(.lg)

// Asymmetric padding
view.lubaPadding(horizontal: .xl, vertical: .md)

// EdgeInsets from tokens
let insets = LubaSpacing.insets(horizontal: .lg, vertical: .sm)
```

### Radius Scale

Corner radii follow a fixed scale designed for consistent visual rhythm:

| Token | Value | Use Case |
|-------|-------|----------|
| `LubaRadius.none` | 0pt | Sharp corners |
| `LubaRadius.xs` | 4pt | Small elements, badges |
| `LubaRadius.sm` | 8pt | Buttons, chips |
| `LubaRadius.md` | 12pt | Cards, text fields |
| `LubaRadius.lg` | 16pt | Sheets, large cards |
| `LubaRadius.xl` | 24pt | Prominent surfaces |
| `LubaRadius.full` | 9999pt | Circles, pills |

```swift
RoundedRectangle.luba(.md)  // 12pt radius

view.lubaCornerRadius(.lg)  // 16pt clip
```

## Topics

### Reference

- ``LubaSpacing``
- ``LubaRadius``
