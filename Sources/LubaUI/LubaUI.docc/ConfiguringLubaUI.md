# Configuring LubaUI

Control colors, typography, motion, haptics, and accessibility through environment-based theming and configuration.

## Overview

LubaUI has two environment systems, and the split is deliberate:

- ``LubaThemeConfiguration`` decides how things **look** — colors, fonts, spacing, radii.
- ``LubaConfig`` decides how things **behave** — haptics, motion, accessibility, font family.

Components resolve colors, fonts, spacing, and radii from the theme. Tier-3
component tokens have resolver forms such as `LubaCardTokens.padding(luba.spacing)`.
Explicit component overrides take precedence over the theme.

Components read both through a single property wrapper, ``LubaEnvironment``, which
hands back a ``LubaContext`` with everything already resolved for the subtree.

### Reading the environment in a component

```swift
struct MyRow: View {
    @LubaEnvironment private var luba

    var body: some View {
        Text("Hello")
            .font(luba.fonts.body)
            .foregroundStyle(luba.colors.textPrimary)
            .padding(luba.spacing.md)
            .background(luba.colors.surface)
            .animation(luba.motion.animation(LubaMotion.stateAnimation), value: isActive)
    }
}
```

`@LubaEnvironment` works in any `DynamicProperty` host: `View`, `ViewModifier`,
and `ButtonStyle`.

> Important: Inside a component body, take colors from `luba.colors` and fonts
> from `luba.fonts` — never from the ``LubaColors`` or ``LubaTypography`` statics.
> The statics are the *authoring* source of truth and supply the theme's defaults;
> reading them directly is what stops `.lubaTheme(…)` from reaching the pixels.

### Theming

``LubaThemeColors`` is a full set of semantic roles. Every role defaults to the
matching ``LubaColors`` token, so the default theme is visually identical to the
unthemed system — including adaptive light/dark behavior, because the defaults
are themselves adaptive colors.

Derive a whole accent ramp from one brand color:

```swift
ContentView()
    .lubaTheme(LubaThemeConfiguration(colors: .accented(Color(hex: 0x2F5FD0))))
```

Or specify roles explicitly:

```swift
let theme = LubaThemeConfiguration(
    colors: LubaThemeColors(
        accent: LubaColors.adaptive(light: Color(hex: 0x2F5FD0), dark: Color(hex: 0x7FA8F5)),
        surface: LubaColors.adaptive(light: .white, dark: Color(hex: 0x15171C)),
        accentSubtle: LubaColors.adaptive(light: Color(hex: 0xEAF0FD), dark: Color(hex: 0x161C2B))
    ),
    radius: LubaThemeRadius(md: 14)
)

SettingsView().lubaTheme(theme)
```

Themes are hierarchical — a subtree inherits the nearest ancestor's theme. To
change only the palette and keep the inherited typography, spacing, and radii:

```swift
PromoBanner().lubaTheme(colors: .accented(.orange))
```

#### Semantic roles

| Group | Roles |
|-------|-------|
| Brand | `accent`, `accentHover`, `accentSubtle`, `textOnAccent` |
| Surfaces | `background`, `surface`, `surfaceSecondary` (`surfaceElevated`), `surfaceTertiary`, `surfaceHover` |
| Text | `textPrimary`, `textSecondary`, `textTertiary`, `textDisabled` |
| Lines | `border`, `borderStrong`, `borderFocused`, `divider`, `fill` |
| Status | `success`, `warning`, `error`, `info` (+ each `…Subtle`) |
| Custom chart colors (compatibility) | `chartPalette`, `chartGrid`, `chartAxisLabel` |
| Glass | `glassBorder`, `glassShadow` |

Every role in that table is read by at least one component, with two deliberate
exceptions — `background` and `surfaceTertiary` are there for **your** views to
use. LubaUI components sit *on* a page; the library never paints a full one.
(`primary` and `secondary` are older aliases, kept so existing themes compile.)
A test enforces the rest, so a role can't quietly go unwired.

Status roles are addressable programmatically via ``LubaStatusRole``:

```swift
luba.colors.status(.error)
luba.colors.statusSubtle(.warning)
luba.colors.chartColor(at: 3)     // wraps around the palette
```

### Configuration

```swift
ContentView().lubaConfig(.accessible)

ContentView()
    .lubaConfig { config in
        config.hapticsEnabled = true
        config.animationSpeed = 0.8
        config.highContrastMode = true
    }
```

The closure receives the configuration inherited from the enclosing subtree, so
nested calls compose rather than resetting to global defaults.

**Precedence:** the nearest `.lubaConfig(…)` ancestor wins. With no ancestor,
components fall back to `LubaConfig.shared`, read live — mutating the singleton
affects views that have not been given their own value.

**Built-in presets:**

| Preset | Description |
|--------|-------------|
| `.minimal` | Haptics off, animations off |
| `.accessible` | Bold text, high contrast, 48pt touch targets |
| `.debug` | Debug outlines and accessibility logging |

#### Properties

**Haptics:**
- `hapticsEnabled` — Master haptic toggle
- `hapticIntensity` — Impact strength (0.0–1.0); subtree-aware through `luba.haptics` in 0.3.0. Selection and notification feedback use system-defined strength.

**Animations:**
- `animationsEnabled` — Master animation toggle
- `respectReducedMotion` — Honor the system Reduce Motion setting
- `animationSpeed` — Global speed multiplier

**Accessibility:**
- `highContrastMode` — Stronger contrast; forces solid glass fallbacks
- `useBoldText` — Bump every font weight one step
- `minimumTouchTarget` — Minimum interactive area (default: 44pt)

**Typography:**
- `useRoundedFont` — Use SF Rounded (default: true)
- `customFontFamily` — Override with a custom font family

> Deprecated: `accentColorLight`, `accentColorDark`, `setAccentColor(light:dark:)`,
> and `defaultCornerRadius` are superseded by the theme and were never read by
> components.

## Topics

### Reference

- ``LubaEnvironment``
- ``LubaContext``
- ``LubaConfig``
- ``LubaThemeConfiguration``
- ``LubaThemeColors``
- ``LubaStatusRole``
- ``LubaThemeTypography``
- ``LubaThemeSpacing``
- ``LubaThemeRadius``

## Release differences

In 0.2.0, `defaultButtonStyle` and `defaultCardElevation` are stored but ignored.
Version 0.3.0 reads the nearest configuration when `style:` or
`elevation:` is omitted. Explicit styles, custom button styling, and explicit
card elevations still win.
