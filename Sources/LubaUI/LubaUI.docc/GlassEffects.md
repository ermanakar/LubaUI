# Glass Effects

Apply frosted glass surfaces using SwiftUI materials, with an opaque accessibility fallback.

## Overview

The glass primitive provides translucent blur effects that adapt to the platform and user's accessibility settings. It uses SwiftUI materials on every supported OS version. Native Liquid Glass is not implemented; the `isInteractive` parameter currently has no effect.

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

When the user enables **Reduce Transparency** or when `LubaConfig.highContrastMode` is active, glass effects automatically fall back to a solid opaque surface. Check contrast with your actual foreground colors and content.

### Glass Containers

`.lubaGlassContainer()` is a compatibility placeholder. It currently returns its content unchanged on every OS version and does not merge overlapping glass surfaces.

## Topics

### Reference

- ``LubaGlassModifier``
- ``LubaGlassStyle``
- ``LubaGlassTokens``
