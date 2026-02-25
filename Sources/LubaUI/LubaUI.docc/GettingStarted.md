# Getting Started with LubaUI

Install LubaUI and build your first screen with design tokens and components.

## Overview

LubaUI is distributed as a Swift Package. Once added to your project, you get immediate access to the full token system, all 25 components, and the composable primitives.

### Add the Package

In Xcode, go to **File > Add Package Dependencies** and enter the repository URL. Then add `LubaUI` to your target's dependencies.

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/AkademiaUI/LubaUI.git", from: "0.1.0"),
],
targets: [
    .target(name: "YourApp", dependencies: ["LubaUI"]),
]
```

### Import and Use

Import the module and start using tokens and components:

```swift
import SwiftUI
import LubaUI

struct ContentView: View {
    @State private var name = ""

    var body: some View {
        VStack(spacing: LubaSpacing.lg) {
            Text("Welcome")
                .font(LubaTypography.title)
                .foregroundStyle(LubaColors.textPrimary)

            LubaTextField("Name", text: $name, placeholder: "Enter your name")

            LubaButton("Continue", style: .primary) {
                // handle tap
            }
        }
        .padding(LubaSpacing.xl)
        .background(LubaColors.background)
    }
}
```

### Key Concepts

**Use tokens, not magic numbers.** Instead of `.padding(16)`, write `.padding(LubaSpacing.lg)`. Tokens give every value a name and make refactoring trivial.

**Compose behaviors with primitives.** Instead of wrapping views in custom gesture handlers, apply modifiers like `.lubaPressable()` or `.lubaExpandable()`.

**Configure globally with LubaConfig.** Disable haptics, adjust animation speed, or enable high-contrast mode for an entire view hierarchy:

```swift
ContentView()
    .lubaConfig(.accessible)
```

## Topics

### Next Steps

- <doc:ThreeTierTokenSystem>
- <doc:ComposablePrimitives>
- <doc:ConfiguringLubaUI>
