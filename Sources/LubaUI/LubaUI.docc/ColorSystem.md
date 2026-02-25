# Color System

Adaptive colors that work across light mode, dark mode, and accessibility settings.

## Overview

LubaUI's color system provides semantic color tokens that automatically adapt between light and dark appearances. Every color is defined once with both light and dark variants, and the system resolves the correct value at runtime.

### Adaptive Colors

All semantic colors use `LubaColors.adaptive(light:dark:)` under the hood, which maps to platform-specific trait resolution (`UIColor` on iOS, `NSColor` on macOS):

```swift
// Use semantic names — they adapt automatically
Text("Hello")
    .foregroundStyle(LubaColors.textPrimary)
    .background(LubaColors.surface)
```

### Surface Hierarchy

Surfaces layer from background to foreground:

| Token | Purpose |
|-------|---------|
| `LubaColors.background` | App-level background |
| `LubaColors.surface` | Cards, sheets, elevated content |
| `LubaColors.surfaceSecondary` | Nested surfaces, input fields |
| `LubaColors.surfaceTertiary` | Deeply nested or hover states |

### Greyscale

A 10-step greyscale from `gray900` (near-black) to `gray50` (near-white), with `black` and `white` at the extremes. Each step is adaptive:

```swift
LubaColors.gray900  // 0x1A1A1A (light) / 0xF5F5F5 (dark)
LubaColors.gray600  // 0x6B6B6B (light) / 0xA3A3A3 (dark)
LubaColors.gray100  // 0xF0F0F0 (light) / 0x2A2A2A (dark)
```

### Accent Color

The accent color is sage green, chosen for WCAG AA compliance (4.5:1 contrast ratio):

```swift
LubaColors.accent       // 0x6B8068 (light) / 0x9AB897 (dark)
LubaColors.accentHover  // Slightly shifted for hover states
LubaColors.accentSubtle // Low-opacity tint for backgrounds
```

### Semantic Colors

Status colors for feedback components:

```swift
LubaColors.success  // Green — positive outcomes
LubaColors.warning  // Amber — caution states
LubaColors.error    // Red — errors and destructive actions
```

### Text Colors

A three-level text hierarchy:

```swift
LubaColors.textPrimary    // Body text, headings
LubaColors.textSecondary  // Supporting text, labels
LubaColors.textTertiary   // Placeholder text, disabled state
LubaColors.textOnAccent   // Text placed on accent backgrounds
```

### Custom Colors

Create your own adaptive colors:

```swift
let brandBlue = LubaColors.adaptive(
    light: Color(hex: 0x2563EB),
    dark: Color(hex: 0x60A5FA)
)
```

## Topics

### Reference

- ``LubaColors``
- ``LubaPrimitives``
