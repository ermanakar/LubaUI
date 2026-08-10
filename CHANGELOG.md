# Changelog

All notable changes to LubaUI are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] — 2026-08-10

The release that makes LubaUI's existing promises real. `.lubaTheme(…)` now
repaints components, Reduce Motion is honored system-wide, the type scale grows
with Dynamic Type, and built-in accessibility strings speak German as well as
English.

### Added

- **Functional theming.** `LubaThemeColors` grew from 7 properties into a full
  semantic role set — accent ramp, surface hierarchy (including an elevated
  surface), four text levels, borders/dividers/fills, four status colors with
  subtle variants, chart palette, and glass roles. Every public component now
  resolves its colors, fonts, **spacing, and radii** from the theme in the
  environment. Tier-3 component tokens keep their defaults and gain a resolver
  form — `LubaCardTokens.padding(luba.spacing)`,
  `LubaFieldTokens.cornerRadius(luba.radius)` — so a component still says
  "card padding" while the value follows the theme.
- **`@LubaEnvironment`** — one property wrapper giving a component the resolved
  `colors`, `fonts`, `spacing`, `radius`, `motion`, and `config` for its subtree.
  Works in `View`, `ViewModifier`, and `ButtonStyle`.
- **`LubaThemeColors.accented(_:)`** — derive a coherent accent ramp, focus
  border, informational color, and lead chart series from one brand color.
- **`LubaStatusRole`** and `colors.status(_:)` / `colors.statusSubtle(_:)` —
  a shared status vocabulary for alerts, toasts, and badges.
- **`.lubaTheme(colors:)`** — override just the palette for a subtree, keeping
  the inherited typography, spacing, and radii.
- **`LubaMotionPolicy`** — the single decision point for whether and how a view
  animates, combining `LubaConfig` with the system `accessibilityReduceMotion`
  value. Distinguishes essential, decorative, interaction, repeating,
  opacity-only, and information-carrying animation.
- **`LubaTextRole`** — 15 semantic type roles, each anchored to an Apple text
  style so the scale participates in Dynamic Type. `LubaFontSet` resolves them
  against the active theme and configuration.
- **`LubaStrings`** — built-in user-facing and accessibility strings, localized
  through `Bundle.module`. Ships English and German.
- **`LubaButtonStyleContext`** and context-based members on `LubaButtonStyling`,
  so custom button styles can follow the active theme.
- **`LubaSwipeActionColor`** — semantic color roles for swipe actions, letting
  the built-in presets follow the theme.
- iOS Simulator library build in CI, using a generic destination and the package
  scheme so it never depends on the showcase app or a named device.
- 57 new tests covering theme resolution, motion policy, typography,
  localization, and environment precedence (104 total). Two are structural
  guards: they fail if a theme color role is declared but never read by a
  component, or if component code reads the Tier-1 dimension scale directly
  instead of resolving through the theme.

### Changed

- **Type scale is now Dynamic Type-aware.** Roles resolve via
  `Font.system(_:design:weight:)` (system fonts) or
  `Font.custom(_:size:relativeTo:)` (custom families) instead of fixed point
  sizes. Three roles shift by 1–2pt at the default content size as a result:
  `title` 26 → 28, `subheadline` 14 → 15, `bodySmall` 14 → 15. Everything else
  keeps its size and now scales.
- **Component labels moved from fixed sizes onto roles**, so they scale too:
  text field labels and helper text, checkbox/radio/toggle/slider labels, slider
  values, badge text, divider labels, menu items, links, tooltips, tab labels,
  and sheet titles. Two shift by 1pt at the default content size: the tab label
  14 → 15, the sheet title 18 → 17.
- **`LubaTypography.custom(size:weight:design:relativeTo:)` is now explicitly the
  glyph-locked escape hatch.** It always honors the size passed to it, and
  `relativeTo:` now defaults to `nil`. It affects custom font families only —
  `Font.system(size:weight:design:)` is the only system-font API that takes an
  exact size, and it does not participate in Dynamic Type. Running text belongs
  on a `LubaTextRole`.
- `LubaThemeColors.divider`, `.glassBorder`, and `.glassShadow` are now read by
  `LubaDivider` and `.lubaGlass()`. They were declared and documented as
  themeable in earlier 0.2.0 development but nothing consumed them.
- **`LubaConfig` environment default is computed**, not stored. Mutating
  `LubaConfig.shared` now affects views that have no `.lubaConfig(…)` ancestor,
  instead of being frozen at first environment access.
- **`.lubaConfig { … }` inherits.** The closure receives the configuration from
  the enclosing subtree rather than a fresh copy of `LubaConfig.shared`, so
  nested calls compose.
- **`LubaSpinner` under Reduce Motion** stops rotating and breathes in opacity.
- **The tab selection indicator no longer slides under Reduce Motion.**
  `matchedGeometryEffect` animates position by construction, so it is skipped
  entirely in that mode and the indicator cross-fades in place instead.
- **Shimmer honors `animationSpeed`**, having previously animated directly
  rather than through the motion policy.
- **A dismissible chip's tap target fills the chip's height** rather than only
  the 16pt glyph circle. A 32pt chip cannot host a 44pt target without changing
  its proportions, so this takes it as far as the geometry allows.
- **Long-press progress rings keep their real duration** under Reduce Motion —
  the fill is the countdown, so shortening it would remove information.
- Controls that hold text use `minHeight` instead of a fixed height, so they
  grow with the type scale. Multi-word labels — button titles, toggle and
  checkbox labels, helper text — wrap. Compact tokens whose shape is the point
  — chips and segmented tab labels — stay on one line and truncate, because
  wrapping makes them outgrow their own silhouette.
- `LubaRating` stars, the `LubaAlert` dismiss button, and the `LubaSheet` close
  button now expand to the configured minimum touch target (44pt by default)
  while keeping their smaller visible glyphs.
- Built-in swipe action labels (`Delete`, `Archive`, `Pin`, `Unread`, `Flag`,
  `Share`) are localized.
- `LubaFieldState`, `LubaAlertStyle`, `LubaToastStyle`, and `LubaSparklineTrend`
  gained `…(_ colors:)` resolvers; their no-argument forms remain and use the
  default palette.
- Chart `color:` parameters became `Color?` (default `nil` → theme accent)
  instead of defaulting to `LubaColors.accent` at the call site.
- `LubaThemeTypography` init parameters became optional, so "not specified"
  is distinguishable from "specified as the default" and can fall through to the
  subtree's configuration. Its properties still read as non-optional `Font`.
- `LubaThemeColors` and `LubaThemeSpacing` inits gained trailing parameters with
  defaults; existing call sites are unaffected.
- CI now runs two jobs: SwiftPM build/test, and an iOS Simulator library build.

### Fixed

- **`LubaTypography.custom(size:)` discarded the requested size for system
  fonts**, resolving every call to the same text style. An 11pt badge and a 32pt
  avatar initial rendered identically, and a 9pt chip glyph overflowed its 16pt
  frame. The size is now always honored, and a regression test pins it.
- **Chips and segmented tabs broke at accessibility text sizes.** Found by
  running the components at AX5 rather than by reading the code: a chip's label
  overflowed its own capsule and the capsule rendered as a circle once the text
  wrapped, and segmented tab labels clipped mid-word. Both are compact tokens,
  so they now stay on one line and truncate, growing in height with the type
  scale. VoiceOver still reads the full label.
- **Spinners froze in a half-finished state when animations were switched off.**
  `LubaSpinner` chose its Reduce Motion fallback whenever motion was disallowed,
  including via `animationsEnabled = false` — where no animation exists to drive
  the fallback. The arc sat permanently at 50% opacity and the pulse ring at
  zero, i.e. invisible. Each style now settles on its resting state.

### Deprecated

- `LubaConfig.accentColorLight`, `LubaConfig.accentColorDark`, and
  `LubaConfig.setAccentColor(light:dark:)` — never read by components. Use
  `.lubaTheme(LubaThemeConfiguration(colors: .accented(color)))`.
- `LubaConfig.defaultCornerRadius` — never read by components. Use
  `LubaThemeRadius`.
- The fixed font-size component tokens superseded by text roles:
  `LubaFieldTokens.labelFontSize` / `.helperFontSize`,
  `LubaSelectionTokens.labelFontSize`, `LubaToggleTokens.labelFontSize`,
  `LubaSliderTokens.labelFontSize` / `.valueFontSize`,
  `LubaTabsTokens.fontSize` / `.underlineFontSize`,
  `LubaSheetTokens.titleFontSize`, and `LubaTooltipTokens.fontSize`. They are no
  longer what the components render, so reading them to match LubaUI's styling
  would now be misleading.
- `LubaReducedMotion.animation(_:)` and `LubaReducedMotion.safe` — they see only
  `LubaConfig.shared.animationsEnabled` and are blind to system Reduce Motion.
  Use `LubaMotionPolicy` via `@LubaEnvironment`.

### Migration

Existing code compiles unchanged; the showcase app builds against 0.2.0 with no
edits. Two things are worth doing deliberately:

1. **Adopt the theme.** Replace app-level accent overrides with
   `.lubaTheme(LubaThemeConfiguration(colors: .accented(brand)))`.
2. **Check text-heavy layouts once.** The three 1–2pt type changes are small, but
   Dynamic Type support means your layouts now genuinely grow. Test at
   `AX3`–`AX5` before shipping.

If you wrote a custom `LubaButtonStyling`, it keeps working — the new
context-based members default to forwarding to the ones you implemented.
Implement `foregroundColor(in:)`, `backgroundColor(in:)`, and `borderColor(in:)`
to make it theme-aware.

### Breaking changes

None intended. The one behavioral change that could surprise: mutating
`LubaConfig.shared` after views exist now takes effect where it previously did
not.

## [0.1.0] — Initial release

- Three-tier token system (primitives → semantic → component).
- 35+ components, 7 composable primitives.
- Environment-based `LubaConfig` and `LubaThemeConfiguration`.
- Glass/frosted primitive with material and solid fallbacks.
- Swift Charts wrappers with token-based styling.
