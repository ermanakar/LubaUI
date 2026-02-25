# Configuring LubaUI

Control haptics, animations, accessibility, and typography through global configuration and environment-based theming.

## Overview

LubaUI provides two configuration systems that flow through the SwiftUI environment. `LubaConfig` controls runtime behavior (haptics, animation speed, accessibility). `LubaThemeConfiguration` overrides visual tokens (colors, typography, spacing, radii).

### LubaConfig

Apply a configuration to any view subtree:

```swift
ContentView()
    .lubaConfig(.accessible)
```

Or customize individual settings:

```swift
ContentView()
    .lubaConfig { config in
        config.hapticsEnabled = true
        config.animationSpeed = 0.8
        config.highContrastMode = true
    }
```

**Built-in presets:**

| Preset | Description |
|--------|-------------|
| `.minimal` | Haptics off, animations off, reduced motion respected |
| `.accessible` | Bold text, high contrast, larger touch targets |
| `.debug` | Debug borders visible, all features enabled |

### LubaConfig Properties

**Brand:**
- `accentColorLight` / `accentColorDark` — Override the sage green accent

**Haptics:**
- `hapticsEnabled` — Master haptic toggle
- `hapticIntensity` — Scale factor for haptic strength (0.0–1.0)

**Animations:**
- `animationsEnabled` — Master animation toggle
- `respectReducedMotion` — Honor system Reduce Motion setting
- `animationSpeed` — Global speed multiplier

**Accessibility:**
- `highContrastMode` — Stronger borders and elevated contrast
- `useBoldText` — Apply bold weight to body text
- `minimumTouchTarget` — Minimum interactive area (default: 44pt)

**Typography:**
- `useRoundedFont` — Use SF Rounded (default: true)
- `customFontFamily` — Override with a custom font family

### Theme Overrides

`LubaThemeConfiguration` lets you override the visual token system for a view subtree:

```swift
let darkTheme = LubaThemeConfiguration(
    colors: LubaThemeColors(
        accent: .blue,
        background: Color(hex: 0x0A0A0A)
    ),
    spacing: LubaThemeSpacing(
        lg: 20  // Wider spacing
    )
)

SettingsView()
    .lubaTheme(darkTheme)
```

Theme overrides are hierarchical — child views inherit the nearest parent's theme, and you can override specific properties without affecting others.

### Reading Config in Components

Components read configuration from the environment:

```swift
struct MyComponent: View {
    @Environment(\.lubaConfig) private var config
    @Environment(\.lubaTheme) private var theme

    var body: some View {
        Button("Tap") {
            if config.hapticsEnabled {
                LubaHaptics.light()
            }
        }
        .foregroundStyle(theme.colors.accent)
    }
}
```

## Topics

### Reference

- ``LubaConfig``
- ``LubaThemeConfiguration``
- ``LubaThemeColors``
- ``LubaThemeTypography``
- ``LubaThemeSpacing``
- ``LubaThemeRadius``
