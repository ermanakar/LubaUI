# Getting Started with LubaUI

Install LubaUI and build your first screen with design tokens and components.

## Overview

LubaUI is distributed as a Swift Package. Once added to your project, you get immediate access to the full token system, the component catalog, and the composable primitives.

### Add the Package

In Xcode, go to **File > Add Package Dependencies** and enter the repository URL. Then add `LubaUI` to your target's dependencies.

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ermanakar/LubaUI", from: "0.3.0"),
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

struct SettingsExample: View {
    @LubaEnvironment private var luba
    @State private var name = ""
    @State private var notifications = true

    var body: some View {
        LubaCard {
            VStack(alignment: .leading, spacing: luba.spacing.lg) {
                Text("Preferences")
                    .font(luba.fonts.title)
                    .foregroundStyle(luba.colors.textPrimary)
                LubaTextField("Name", text: $name)
                LubaToggle(isOn: $notifications, label: "Notifications")
            }
        }
        .padding(luba.spacing.xl)
        .lubaTheme(colors: .accented(.indigo))
    }
}
```

### Key Concepts

**Use tokens, not magic numbers.** Instead of `.padding(16)`, write `.padding(LubaSpacing.lg)`. Tokens give every value a name and make refactoring trivial.

**Compose behaviors with primitives.** Instead of wrapping views in custom gesture handlers, apply modifiers like `.lubaPressable()` or the `LubaExpandable` container.

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
