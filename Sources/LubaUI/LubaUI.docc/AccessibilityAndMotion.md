# Accessibility and Motion

How LubaUI honors Reduce Motion, scales with Dynamic Type, and speaks the user's language.

## Overview

Three accessibility promises are wired all the way through the component set:
Reduce Motion is respected by every animated component, the whole type scale
grows with Dynamic Type, and built-in strings are localized rather than
hard-coded English.

## Reduce Motion

``LubaMotionPolicy`` is the single decision point for whether and how a view
animates. It reads two inputs:

1. ``LubaConfig`` — `animationsEnabled`, `respectReducedMotion`, `animationSpeed`
2. The system `accessibilityReduceMotion` environment value

| Situation | Behavior |
|-----------|----------|
| `animationsEnabled == false` | Nothing animates. State changes still apply, instantly. |
| Reduce Motion on, `respectReducedMotion == true` | Springs, press scale, slide/scale transitions, shimmer, and stagger are removed. Essential state changes become a short cross-fade. |
| Reduce Motion on, `respectReducedMotion == false` | Full motion — the app opted out explicitly. |

### Choosing a policy method

| Method | Use for | Under Reduce Motion |
|--------|---------|---------------------|
| `animation(_:)` | Essential state changes | Short cross-fade |
| `decorative(_:)` | Springs, bounce, press scale | `nil` |
| `interaction(_:)` | Press/hover color shifts | Short cross-fade |
| `repeating(_:)` | Shimmer, rotation | `nil` |
| `repeatingOpacity(_:)` | Opacity-only busy loops | Preserved |
| `continuous(_:)` | Progress that carries information | Preserved |
| `pressScale(_:)`, `motionAmount(_:)` | Transform amounts | Neutralized to 1.0 / 0 |
| `stagger(index:)` | List entrances | Delay collapses to 0 |
| `transition(_:)` | View insertion/removal | Downgraded to `.opacity` |

Two categories deliberately survive Reduce Motion, because suppressing them
would remove *meaning* rather than decoration:

- **Progress that fills over time.** The long-press confirmation ring keeps its
  real duration; a 0.2s cross-fade would make the countdown unreadable.
- **Opacity-only busy indicators.** ``LubaSpinner`` stops rotating and breathes
  in opacity, so "working…" stays legible without movement.

Haptics are configured separately via `hapticsEnabled` — a user who dislikes
animation may still want tactile confirmation, and vice versa.

### Using it in your own components

```swift
struct MyPanel: View {
    @LubaEnvironment private var luba
    @State private var isOpen = false

    var body: some View {
        VStack {
            header
            if isOpen {
                content.transition(luba.motion.transition(.move(edge: .top)))
            }
        }
        .scaleEffect(luba.motion.pressScale(isOpen ? 0.98 : 1))
        .animation(luba.motion.animation(LubaMotion.stateAnimation), value: isOpen)
    }

    private func toggle() {
        luba.motion.run(LubaMotion.stateAnimation) { isOpen.toggle() }
    }
}
```

`run(_:)` always executes its body — the state change happens whether or not it
is animated.

## Dynamic Type

Every entry in the type scale is a ``LubaTextRole`` anchored to an Apple text
style, so the scale participates in Dynamic Type rather than freezing at a point
size:

```swift
LubaTypography.font(.body)          // scales from .callout
luba.fonts.title                    // theme + config aware
luba.fonts(.caption)                // any role, resolved for the subtree
```

For custom font families, LubaUI uses `Font.custom(_:size:relativeTo:)`, which
keeps the authored point size at the default content size and still scales.

``LubaTypography/custom(size:weight:design:relativeTo:config:)`` is the escape
hatch, and it is deliberately **not** Dynamic Type-aware for system fonts: it
always renders at the size you pass, because `Font.system(size:weight:design:)`
is the only system-font API that takes an exact size and it does not scale.
Reserve it for glyph-locked decoration — an SF Symbol inside a fixed frame,
initials sized from an avatar's diameter, the label inside a progress ring —
where a growing size would break the drawing. Everything that reads as text
should use a ``LubaTextRole``.

### Layout consequences

- Controls holding text (``LubaChip``, ``LubaSearchBar``, ``LubaTabs``,
  ``LubaButton``) use `minHeight`, so they grow instead of clipping.
- Multi-word labels — button titles, control labels, helper text — wrap.
- Compact tokens whose silhouette carries meaning — chips, segmented tab labels
  — stay on one line and truncate. Wrapping makes a chip outgrow its capsule;
  the full text remains available to VoiceOver.
- Interactive targets honor `minimumTouchTarget` (44pt by default) even when the
  visible glyph is smaller — ``LubaRating`` stars, the alert dismiss button, and
  the sheet close button all expand their hit area without growing visually.

Test at the `AX3`–`AX5` content sizes before shipping.

## Localized strings

``LubaStrings`` holds every built-in user-facing and accessibility string,
resolved through `Bundle.module`. LubaUI ships English (the development
language) and German; unshipped languages fall back to English.

```swift
LubaButton("Speichern", isLoading: true) { }  // a11y value: "Wird geladen"
LubaSwipeAction.delete { }.label              // "Löschen"
LubaStrings.close                             // "Schließen"
```

Caller-provided labels always win. Nothing built in overrides an explicit
`label:` argument or `.accessibilityLabel(…)` on the call site.

### Adding a language

Add `<lang>.lproj/Localizable.strings` under `Sources/LubaUI/Resources/` using
the same keys as `en.lproj`. Keys are namespaced `luba.<area>.<name>`. A test
enforces key parity between shipped languages.

## Contrast

``LubaContrast`` computes WCAG 2.1 ratios so you can verify a custom theme:

```swift
let ratio = LubaContrast.contrastRatio(
    foreground: theme.colors.textPrimary,
    background: theme.colors.background
)
LubaContrast.meetsAA(foreground: theme.colors.textOnAccent, background: theme.colors.accent)
```

## Topics

### Reference

- ``LubaMotionPolicy``
- ``LubaEnvironment``
- ``LubaContext``
- ``LubaTextRole``
- ``LubaFontSet``
- ``LubaStrings``
- ``LubaContrast``
- ``LubaHaptics``
- ``LubaAnnounce``
