# The Three-Tier Token System

Understand how LubaUI organizes design values into primitives, semantic tokens, and component tokens.

## Overview

Every value in LubaUI — colors, spacing, radii, animation constants — lives in a three-tier hierarchy. This architecture prevents magic numbers, makes theming possible, and keeps component code readable.

### Tier 1: Primitives

Raw values with no semantic meaning. These are the DNA of the system.

```swift
LubaPrimitives.grey900Light   // Color(hex: 0x1A1A1A)
LubaPrimitives.space4         // 4.0
LubaPrimitives.radius12       // 12.0
```

**Never reference Tier 1 directly in component code.** Primitives exist so that Tier 2 tokens can map to them, giving you a single source of truth for every raw value.

### Tier 2: Semantic Tokens

Human-readable names that describe *purpose*, not *value*. These are what you use day-to-day.

```swift
LubaColors.textPrimary    // Maps to grey900 (light) / grey50 (dark)
LubaSpacing.lg            // 16pt — comfortable element spacing
LubaRadius.md             // 12pt — standard card radius
LubaMotion.pressScale     // 0.97 — default press feedback
```

Semantic tokens adapt automatically. `LubaColors.textPrimary` resolves to dark text in light mode and light text in dark mode — your component code doesn't change.

### Tier 3: Component Tokens

Per-component constants that fine-tune dimensions, spacing, and behavior for a specific component.

```swift
LubaFieldTokens.minHeight        // 48pt
LubaFieldTokens.cornerRadius     // 12pt (matches LubaRadius.md)
LubaCardTokens.defaultPadding    // 16pt (matches LubaSpacing.lg)
LubaToastTokens.shadowBlur       // 16pt
```

Component tokens reference Tier 2 values where possible, but may define component-specific values (like shadow blur) that don't belong in the general token scale.

### Why Three Tiers?

The tiers serve different audiences:

| Tier | Audience | Example |
|------|----------|---------|
| 1 — Primitives | System maintainers | Changing `grey900Light` updates every downstream reference |
| 2 — Semantic | App developers | Use `LubaSpacing.lg` without knowing it's `16pt` |
| 3 — Component | Component authors | Fine-tune `LubaToastTokens.shadowBlur` independently |

This separation means you can rebrand the entire color palette by editing Tier 1, adjust spacing proportions by editing Tier 2, or tweak one component's radius by editing Tier 3 — without side effects.

## Topics

### Token References

- ``LubaPrimitives``
- ``LubaColors``
- ``LubaSpacing``
- ``LubaTypography``
- ``LubaRadius``
- ``LubaMotion``
