# LubaUI showcase

An interactive catalog and set of compositions for LubaUI 0.3.0. The Xcode
project references the package in the repository root and deliberately keeps
`import LubaUI`, exercising the convenience umbrella after the module split.

Open `LubaUIShowcase.xcodeproj`, select the LubaUIShowcase scheme, and run on an
iOS simulator. The updated demos require the current main branch; they were
added after the immutable 0.3.0 library release.

- **Foundation → Package Products** explains Core, Components, and the umbrella.
- **Foundation → Theme** applies a full theme above a child that reads
  `@LubaEnvironment`. Change the palette to see controls and custom content agree.
- **Patterns → Form Patterns** contains an in-memory form. Save, clear its name,
  and inspect the inline error. No account or network connection is involved.
- **Primitives → Composability** starts with a native button using
  `LubaPressableButtonStyle`, then adds expandable detail. Lower-level gesture
  examples still require app-specific keyboard and VoiceOver consideration.
- The home-screen leaf/moon button changes the appearance.

## Repeatable captures

Debug builds accept these launch arguments in the Xcode scheme:

```text
-showcase-screen Theme -showcase-light
-showcase-screen Theme -showcase-dark
-showcase-screen "Form Patterns" -showcase-light
-showcase-screen Buttons -showcase-light
-showcase-screen Composability -showcase-light
```

The screen value must match a catalog title. In Theme, select Ocean for the
custom-palette capture. In Composability, activate the first card to expand it.
Back returns to the catalog; launch arguments are applied only once per launch.
Release builds ignore these arguments.

Use the simulator's screenshot export at native resolution. Remove embedded
metadata without altering pixels, review every image for private content, and
keep [capture notes](../assets/showcase/README.md) alongside published images.
