# Composable Primitives

Extract interactive behaviors into reusable modifiers instead of subclassing.

## Overview

LubaUI's core design philosophy is **composability over inheritance**. Rather than building a `TappableCard` subclass or a `SwipeableRow` wrapper, behaviors are extracted into *primitives* — SwiftUI view modifiers that can be applied to any view.

### The Seven Primitives

| Primitive | Modifier | Purpose |
|-----------|----------|---------|
| Pressable | `.lubaPressable()` | Scale animation, haptics, and tap handling |
| Expandable | `.lubaExpandable()` | Expand/collapse with smooth animation |
| Swipeable | `.lubaSwipeable()` | Swipe-to-reveal actions |
| Shimmerable | `.lubaShimmerable()` | Loading shimmer overlay |
| Long Pressable | `.lubaLongPressable()` | Long press with progress feedback |
| Glass | `.lubaGlass()` | Frosted glass/blur effect |
| Button Styling | `LubaButtonStyling` | Protocol for custom button appearances |

### Making Any View Pressable

The pressable primitive gives any view the same tap interaction as a button — scale feedback, haptics, and action handling:

```swift
Image(systemName: "heart.fill")
    .font(.largeTitle)
    .foregroundStyle(LubaColors.accent)
    .lubaPressable { print("Liked!") }
```

Customize the feel per context:

```swift
LubaCard {
    Text("Tap to open")
}
.lubaPressable(scale: 0.98, haptic: .medium) {
    navigate()
}
```

### Adding Swipe Actions

Apply swipe actions to any view using built-in presets or custom actions:

```swift
MessageRow(message: message)
    .lubaSwipeable(
        leading: [.pin { togglePin() }],
        trailing: [.delete { remove() }, .archive { archive() }]
    )
```

### Shimmer Loading

Show a loading state over real content, or combine with redaction for full placeholder loading:

```swift
// Shimmer over visible content
ProfileCard(user: user)
    .lubaShimmerable(isLoading: isLoading)

// Shimmer with content redaction
ProfileCard(user: user)
    .lubaRedactedShimmer(isLoading: isLoading)
```

### Composing Primitives

Primitives compose naturally because they're just modifiers:

```swift
LubaCard {
    ItemContent(item: item)
}
.lubaExpandable(isExpanded: $showDetails) {
    DetailContent(item: item)
}
.lubaSwipeable(trailing: [.delete { remove(item) }])
.lubaPressable { select(item) }
```

## Topics

### Primitive Reference

- ``LubaPressableModifier``
- ``LubaExpandable``
- ``LubaSwipeableModifier``
- ``LubaShimmerableModifier``
- ``LubaLongPressableModifier``
- ``LubaGlassModifier``
- ``LubaButtonStyling``
- ``LubaHapticStyle``
