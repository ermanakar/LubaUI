# Motion and Animation

Two complementary systems for animation constants and applied animations.

## Overview

LubaUI splits motion into two enums that serve different purposes. Understanding when to use each one prevents confusion and keeps animation code clean.

### LubaMotion — Raw Constants

`LubaMotion` provides raw animation **values** — scale factors, durations, opacities, and spring configurations. Use these when you need values for `scaleEffect()`, `opacity()`, or custom animation logic.

```swift
// Scale feedback on press
.scaleEffect(isPressed ? LubaMotion.pressScale : 1.0)

// Opacity for loading states
.opacity(isLoading ? LubaMotion.loadingContentOpacity : 1.0)

// Staggered animation delays
.animation(.default.delay(LubaMotion.stagger(index: index)))
```

**Press scale hierarchy:** Smaller elements need more exaggerated scale change to feel responsive, while larger elements need less to avoid looking jarring:

| Constant | Value | Use Case |
|----------|-------|----------|
| `pressScaleCompact` | 0.95 | Small icons, badges |
| `pressScale` | 0.97 | Standard buttons, cards |
| `pressScaleProminent` | 0.98 | Large surfaces, hero cards |

### LubaAnimations — Applied Animations

`LubaAnimations` provides `Animation` objects and `AnyTransition` values. Use these for `withAnimation()` blocks, `.animation()` modifiers, and `.transition()` calls.

**Spring presets:**

```swift
withAnimation(LubaAnimations.quick) { isExpanded.toggle() }
withAnimation(LubaAnimations.bouncy) { showConfetti = true }
```

| Preset | Feel |
|--------|------|
| `.quick` | Snappy, responsive |
| `.standard` | Balanced, natural |
| `.gentle` | Soft, relaxed |
| `.bouncy` | Playful, springy |

**Eased presets:**

| Preset | Feel |
|--------|------|
| `.fadeIn` | Smooth opacity entrance |
| `.smooth` | General-purpose ease |
| `.subtle` | Barely perceptible |

**Transitions:**

```swift
content
    .transition(.lubaSlideUp)  // Slide up + fade
    .transition(.lubaScale)    // Scale from center
    .transition(.lubaFade)     // Opacity only
```

**View modifier:**

```swift
view.lubaAnimation(.bouncy, value: isActive)
```

### When to Use Which

| Need | Use |
|------|-----|
| A value for `.scaleEffect()` | `LubaMotion.pressScale` |
| A value for `.opacity()` | `LubaMotion.loadingContentOpacity` |
| An `Animation` for `withAnimation()` | `LubaAnimations.quick` |
| A `.transition()` | `.lubaSlideUp` |
| A stagger delay | `LubaMotion.stagger(index:)` |

### Respecting Reduced Motion

Both systems integrate with `LubaConfig`. When `animationsEnabled` is `false` or the system's Reduce Motion setting is active, animations degrade gracefully:

```swift
@Environment(\.lubaConfig) private var config

withAnimation(config.animationsEnabled ? LubaAnimations.standard : nil) {
    isVisible.toggle()
}
```

## Topics

### Reference

- ``LubaMotion``
- ``LubaAnimations``
- ``LubaReducedMotion``
