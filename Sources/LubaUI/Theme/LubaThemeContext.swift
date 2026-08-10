//
//  LubaThemeContext.swift
//  LubaUI
//
//  One property, everything a component needs.
//
//  A LubaUI component reads exactly one thing from the environment:
//
//  ```swift
//  @LubaEnvironment private var luba
//  ```
//
//  and from it gets semantic colors, fonts, spacing, radii, the motion
//  policy, and the raw configuration — all already resolved for the current
//  view subtree. This is what makes `.lubaTheme(…)` and `.lubaConfig(…)`
//  actually reach the pixels.
//

import SwiftUI

// MARK: - Resolved Context

/// The theme, configuration, and accessibility state resolved for a view subtree.
public struct LubaContext {

    /// The active theme.
    public let theme: LubaThemeConfiguration

    /// The active configuration. Environment value first, `LubaConfig.shared` as fallback.
    public let config: LubaConfig

    /// The system Reduce Motion setting, before the configuration's policy is applied.
    public let systemReduceMotion: Bool

    public init(
        theme: LubaThemeConfiguration = .default,
        config: LubaConfig = .shared,
        systemReduceMotion: Bool = false
    ) {
        self.theme = theme
        self.config = config
        self.systemReduceMotion = systemReduceMotion
    }

    /// Semantic colors for this subtree.
    public var colors: LubaThemeColors { theme.colors }

    /// Spacing scale for this subtree.
    public var spacing: LubaThemeSpacing { theme.spacing }

    /// Corner radius scale for this subtree.
    public var radius: LubaThemeRadius { theme.radius }

    /// Dynamic Type-aware fonts for this subtree.
    public var fonts: LubaFontSet {
        LubaFontSet(typography: theme.typography, config: config)
    }

    /// The resolved motion policy for this subtree.
    public var motion: LubaMotionPolicy {
        LubaMotionPolicy(config: config, systemReduceMotion: systemReduceMotion)
    }

    /// Whether haptics may fire. Independent of the motion policy by design —
    /// a user who turns off animation may still want tactile confirmation.
    public var hapticsEnabled: Bool { config.hapticsEnabled }

    /// The minimum interactive target size for this subtree.
    public var minimumTouchTarget: CGFloat { config.minimumTouchTarget }
}

// MARK: - Property Wrapper

/// Reads the resolved LubaUI context (theme + configuration + Reduce Motion)
/// for the current view subtree.
///
/// ```swift
/// struct MyRow: View {
///     @LubaEnvironment private var luba
///
///     var body: some View {
///         Text("Hello")
///             .font(luba.fonts.body)
///             .foregroundStyle(luba.colors.textPrimary)
///             .padding(luba.spacing.md)
///             .background(luba.colors.surface)
///     }
/// }
/// ```
///
/// Works in any `DynamicProperty` host: `View`, `ViewModifier`, `ButtonStyle`.
@propertyWrapper
public struct LubaEnvironment: DynamicProperty {

    @SwiftUI.Environment(\.lubaTheme) private var theme
    @SwiftUI.Environment(\.lubaConfig) private var config
    @SwiftUI.Environment(\.accessibilityReduceMotion) private var systemReduceMotion

    public init() {}

    public var wrappedValue: LubaContext {
        LubaContext(theme: theme, config: config, systemReduceMotion: systemReduceMotion)
    }
}

// MARK: - Minimum Touch Target

public extension View {
    /// Ensure the view meets the configured minimum interactive target size.
    ///
    /// Unlike the older `lubaMinTouchTarget()`, this reads the *effective*
    /// configuration for the subtree rather than the global singleton.
    func lubaMinTouchTarget(_ context: LubaContext) -> some View {
        frame(
            minWidth: context.minimumTouchTarget,
            minHeight: context.minimumTouchTarget
        )
    }
}
