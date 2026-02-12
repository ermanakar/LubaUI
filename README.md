# LubaUI

**Ship beautiful SwiftUI apps without thinking about design.**

You're building fast. You're vibing with your AI. You don't want to stop and think about what shade of gray a subtitle should be, whether your button animation is too bouncy, or if your touch targets meet accessibility standards. You want to write `LubaButton("Save") { save() }` and have it just *feel right*.

That's LubaUI.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%2B%20%7C%20macOS%2013%2B%20%7C%20watchOS%209%2B%20%7C%20visionOS%201%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## 30-Second Demo

```swift
import SwiftUI
import LubaUI

struct ContentView: View {
    @State private var email = ""
    @State private var agreed = false

    var body: some View {
        VStack(spacing: LubaSpacing.lg) {
            Text("Create Account")
                .font(LubaTypography.title)
                .foregroundStyle(LubaColors.textPrimary)

            LubaTextField.email(text: $email)

            LubaCheckbox(isChecked: $agreed, label: "I agree to the terms")

            LubaButton("Get Started", style: .primary, isDisabled: !agreed) {
                createAccount()
            }
        }
        .padding(LubaSpacing.xl)
    }
}
```

No color codes. No animation curves. No magic numbers. It just looks and feels like a real app.

---

## Installation

### Swift Package Manager

**Xcode:** File → Add Package Dependencies → Enter:
```
https://github.com/ermanakar/LubaUI
```

**Package.swift:**
```swift
dependencies: [
    .package(url: "https://github.com/ermanakar/LubaUI", from: "0.1.0")
]
```

---

## Why LubaUI

### Built for AI-Assisted Development

Every token, every constant, every API in LubaUI is designed to be understood by your AI coding assistant. Semantic naming (`LubaColors.textPrimary`, not `gray900`), strict tokenization (no magic numbers), and documented rationale for every design decision. When you pair with an AI, it doesn't guess — it *knows* this system.

### One Import, Whole Design Language

You get colors, typography, spacing, motion, haptics, accessibility, and 25+ components that all share the same DNA. Your settings screen looks like it belongs with your onboarding flow because they're built from the same tokens.

### The Details Are Done

The hard stuff is already decided:
- **0.97 press scale** — not 0.98 (too subtle), not 0.95 (too cartoonish)
- **Spring animations** tuned to feel alive, not mechanical
- **4pt spacing grid** for mathematical rhythm
- **44pt touch targets** for accessibility compliance
- **Adaptive colors** that look right in light and dark mode

You don't have to make these decisions. They're already made, and they're good.

---

## Primitives — Make Anything Interactive

This is the core idea. Behaviors aren't locked inside components — they're modifiers you can attach to *any* view.

### `.lubaPressable()` — Tap anything

```swift
// A card that feels like a button
LubaCard {
    Text("Tap me")
}
.lubaPressable { print("Tapped!") }

// An image that responds to touch
Image("hero")
    .lubaPressable(scale: 0.98) { showDetail = true }
```

### `.lubaSwipeable()` — Swipe actions on any row

```swift
// Swipe to delete
MessageRow()
    .lubaSwipeable(trailing: [.delete { removeItem() }])

// Multiple actions
MessageRow()
    .lubaSwipeable(
        leading: [.pin { pinMessage() }],
        trailing: [.archive { archive() }, .delete { delete() }]
    )
```

### `.lubaLongPressable()` — Long press with progress

```swift
// Destructive action with visual confirmation
Image(systemName: "trash")
    .lubaLongPressable { confirmDeletion() }

// With progress ring
LubaCard { content }
    .lubaLongPressable(showProgress: true, duration: 1.0) {
        confirmDeletion()
    }
```

### `.lubaShimmerable()` — Loading state for any view

```swift
// Shimmer anything while loading
Image("hero")
    .lubaShimmerable(isLoading: isLoading)
```

### `LubaExpandable` — Accordion behavior

```swift
LubaExpandable(isExpanded: $isOpen) {
    Text("FAQ Question")
} content: {
    Text("The answer goes here")
}
```

---

## Components

### Interactive Controls

| Component | What It Does |
|-----------|-------------|
| `LubaButton` | Primary, secondary, ghost, destructive, subtle. Loading states. Icons. |
| `LubaTextField` | Labels, icons, error states. Convenience: `.email()`, `.secure()` |
| `LubaTextArea` | Multi-line text editor with character counter and limits |
| `LubaSearchBar` | Search input with cancel button and submit handler |
| `LubaCheckbox` | Animated checkmark with label |
| `LubaRadio` | Radio button groups |
| `LubaToggle` | iOS-style toggle switch |
| `LubaSlider` | Value slider with optional labels |
| `LubaStepper` | Numeric +/- adjuster with configurable range and step |
| `LubaRating` | Star rating control with read-only display mode |
| `LubaTabs` | Segmented control with matched geometry animation |
| `LubaIconButton` | Icon buttons with 44pt touch targets |

### Layout & Containers

| Component | What It Does |
|-----------|-------------|
| `LubaCard` | Container with elevation levels. Compose with `.lubaPressable()` |
| `LubaSheet` | Bottom sheets with size presets and drag indicator |
| `LubaDivider` | Horizontal/vertical dividers with optional labels |

### Feedback & Status

| Component | What It Does |
|-----------|-------------|
| `LubaToast` | Info, success, warning, error notifications with auto-dismiss |
| `LubaAlert` | Inline notification banner with semantic styles |
| `LubaProgressBar` | Linear progress indicator |
| `LubaCircularProgress` | Circular progress indicator |
| `LubaSpinner` | Arc, pulse, dots, and breathe loading styles |
| `LubaBadge` | Status badges with semantic colors |
| `LubaTooltip` | Contextual help popup with auto-dismiss |

### Data Display

| Component | What It Does |
|-----------|-------------|
| `LubaAvatar` | Image or initials with size variants |
| `LubaIcon` | Standardized icon sizing with semantic colors |
| `LubaCircledIcon` | Icons with circular backgrounds |
| `LubaSkeleton` | Shimmer loading placeholders (text, circle, card, row) |
| `LubaChip` | Dismissible filter/tag pill with selection state |
| `LubaLink` | Inline text link with default, subtle, and external styles |
| `LubaMenu` | Context menu with icons and destructive item support |

---

## Design Tokens

Every value has a name. No magic numbers.

### Colors
```swift
LubaColors.textPrimary       // Main text
LubaColors.textSecondary     // Supporting text
LubaColors.accent            // Brand color (sage green)
LubaColors.success           // Positive states
LubaColors.warning           // Caution states
LubaColors.error             // Error states
LubaColors.surface           // Card backgrounds
LubaColors.background        // Page backgrounds
```

All colors are adaptive — they switch automatically between light and dark mode.

### Spacing (4pt base grid)
```swift
LubaSpacing.xs    // 4pt
LubaSpacing.sm    // 8pt
LubaSpacing.md    // 12pt
LubaSpacing.lg    // 16pt
LubaSpacing.xl    // 24pt
LubaSpacing.xxl   // 32pt
LubaSpacing.xxxl  // 48pt
LubaSpacing.huge  // 64pt
```

### Motion
```swift
LubaMotion.pressScale        // 0.97 — the sweet spot
LubaMotion.pressAnimation    // Quick spring with bounce
LubaMotion.stateAnimation    // Smooth state transitions
LubaMotion.micro             // Ultra-quick feedback
LubaMotion.gentle            // Soft transitions
LubaMotion.disabledOpacity   // 0.45
```

### Typography
```swift
LubaTypography.largeTitle    // SF Rounded by default
LubaTypography.title
LubaTypography.headline
LubaTypography.body
LubaTypography.caption
// ... 13 presets total
```

---

## Button Styles

```swift
LubaButton("Save", style: .primary) { }
LubaButton("Cancel", style: .secondary) { }
LubaButton("Delete", style: .destructive) { }
LubaButton("Learn More", style: .ghost) { }
LubaButton("Subtle", style: .subtle) { }

// With icon and loading state
LubaButton("Upload", style: .primary, isLoading: isUploading, icon: Image(systemName: "arrow.up")) {
    startUpload()
}

// Create your own style
struct BrandStyle: LubaButtonStyling {
    func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? .purple.opacity(0.8) : .purple
    }
    func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color { .white }
    func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? { nil }
    var borderWidth: CGFloat { 0 }
    var defaultsToFullWidth: Bool { true }
    var haptic: LubaHapticStyle { .medium }
}

LubaButton("Custom", styling: BrandStyle()) { }
```

---

## Configuration

Control the system globally via SwiftUI's environment:

```swift
// Use a preset
ContentView()
    .lubaConfig(.accessible)    // High contrast, bold text, larger touch targets

ContentView()
    .lubaConfig(.minimal)       // No animations, no haptics

ContentView()
    .lubaConfig(.debug)         // Debug outlines and a11y logging

// Customize inline
ContentView()
    .lubaConfig { config in
        config.hapticsEnabled = false
        config.highContrastMode = true
        config.useRoundedFont = false
    }
```

Components automatically respect these settings via `@Environment(\.lubaConfig)`.

### Available Settings

| Property | Default | Description |
|----------|---------|-------------|
| `hapticsEnabled` | `true` | Enable haptic feedback globally |
| `hapticIntensity` | `1.0` | Haptic feedback intensity (0.0 - 1.0) |
| `animationsEnabled` | `true` | Enable animations globally |
| `respectReducedMotion` | `true` | Respect system reduced motion setting |
| `animationSpeed` | `1.0` | Animation duration multiplier |
| `minimumTouchTarget` | `44` | Minimum touch target size in points |
| `useBoldText` | `false` | Bold text for readability |
| `highContrastMode` | `false` | Increased contrast for semantic colors |
| `useRoundedFont` | `true` | SF Rounded (true) or SF Pro (false) |
| `customFontFamily` | `nil` | Custom font family override |
| `defaultButtonStyle` | `.primary` | Default button style |
| `defaultCardElevation` | `.low` | Default card elevation |
| `defaultCornerRadius` | `12` | Default corner radius |
| `showDebugOutlines` | `false` | Show component outlines for debugging |
| `logA11yWarnings` | `false` | Log accessibility warnings |

---

## Requirements

- iOS 16.0+ / macOS 13.0+ / watchOS 9.0+ / tvOS 16.0+ / visionOS 1.0+
- Swift 5.9+
- Xcode 15.0+

---

## Contributing

LubaUI welcomes contributions. When adding new components:

1. Create component-specific tokens (e.g., `LubaFooTokens`)
2. Use `LubaMotion` for all animations — never hardcode values
3. Read `@Environment(\.lubaConfig)` for haptics and animations
4. Use `LubaColors` semantic colors (never raw hex values)
5. Extract reusable behavior to primitives
6. Maintain backwards compatibility

See [llms.txt](llms.txt) for detailed architecture documentation.

---

## License

LubaUI is available under the MIT License. See [LICENSE](LICENSE) for details.

---

<p align="center">
Made with intention by <a href="https://github.com/ermanakar">Erman Akar</a>
</p>
