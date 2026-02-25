# Customizing Button Styles

Create custom button appearances using the LubaButtonStyling protocol.

## Overview

LubaUI buttons support both built-in style presets and fully custom styles through the `LubaButtonStyling` protocol. Use the enum for convenience, or implement the protocol for complete control.

### Built-in Styles

Six styles are included out of the box:

```swift
LubaButton("Save", style: .primary) { }      // Filled accent
LubaButton("Cancel", style: .secondary) { }   // Bordered
LubaButton("More", style: .ghost) { }         // Text only
LubaButton("Delete", style: .destructive) { } // Red, danger
LubaButton("Skip", style: .subtle) { }        // Minimal
LubaButton("Overlay", style: .glass) { }      // Frosted glass
```

### Creating a Custom Style

Implement `LubaButtonStyling` to define colors for normal and pressed states in both color schemes:

```swift
struct BrandStyle: LubaButtonStyling {
    func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        .white
    }

    func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? Color.blue.opacity(0.8) : Color.blue
    }

    func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        .clear
    }

    var borderWidth: CGFloat { 0 }
    var defaultsToFullWidth: Bool { true }
    var haptic: LubaHapticStyle { .medium }
}
```

Use the `styling:` parameter (not `style:`) when passing a custom style:

```swift
LubaButton("Continue", styling: BrandStyle()) { }
```

### Protocol Requirements

| Property/Method | Purpose |
|-----------------|---------|
| `foregroundColor(isPressed:colorScheme:)` | Text and icon color |
| `backgroundColor(isPressed:colorScheme:)` | Fill color |
| `borderColor(isPressed:colorScheme:)` | Border stroke color |
| `borderWidth` | Border stroke width (0 for none) |
| `defaultsToFullWidth` | Whether the button expands to fill available width |
| `haptic` | Haptic feedback style on tap |

### Press State

LubaButton uses `LubaInteractiveButtonStyle` internally, which propagates press state via a `PreferenceKey`. Your custom style receives `isPressed: true` during the press gesture, letting you animate color changes.

## Topics

### Reference

- ``LubaButtonStyling``
- ``LubaButton``
- ``LubaButtonStyleType``
- ``LubaPressableButtonStyle``
- ``LubaInteractiveButtonStyle``
