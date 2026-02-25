# Glass Effects

Apply frosted glass surfaces with automatic fallbacks for accessibility and older OS versions.

## Overview

The glass primitive provides translucent blur effects that adapt to the platform and user's accessibility settings. On iOS 16–25 it uses SwiftUI materials; on iOS 26+ it's ready for native Liquid Glass.

### Basic Usage

Apply glass to any view:

```swift
Text("Floating label")
    .padding(LubaSpacing.md)
    .lubaGlass(.subtle)
```

### Intensity Levels

Three intensity levels control the blur strength and opacity:

| Style | Use Case |
|-------|----------|
| `.subtle` | Toolbars, floating action buttons |
| `.regular` | Cards, tab bars, sheet headers |
| `.prominent` | Modal backgrounds, large panels |

```swift
// Navigation overlay
toolbar.lubaGlass(.subtle)

// Floating card
card.lubaGlass(.regular, cornerRadius: LubaRadius.lg)

// Full-screen overlay
panel.lubaGlass(.prominent)
```

### Color Tinting

Add a color tint over the glass surface:

```swift
LubaToast("Saved", style: .success, useGlass: true)
// Internally applies: .lubaGlass(.regular, tint: successColor)
```

### Components with Glass

Several components have built-in glass support:

```swift
// Glass button
LubaButton("Action", style: .glass) { }

// Glass card
LubaCard(style: .glass) { content }

// Glass tab bar
LubaTabs(selection: $tab, tabs: items, useGlass: true)

// Glass sheet header
LubaSheetHeader("Title", useGlass: true) { dismiss() }

// Glass toast
LubaToast("Message", useGlass: true)
```

### Accessibility Fallbacks

When the user enables **Reduce Transparency** or when `LubaConfig.highContrastMode` is active, glass effects automatically fall back to a solid opaque surface. This ensures readability is never compromised.

### Glass Containers

On iOS 26+, overlapping glass views need a shared compositing container. Use `.lubaGlassContainer()` on the parent:

```swift
ZStack {
    GlassCard()
    GlassOverlay()
}
.lubaGlassContainer()
```

This is a no-op on iOS 16–25.

## Topics

### Reference

- ``LubaGlassModifier``
- ``LubaGlassStyle``
- ``LubaGlassTokens``
