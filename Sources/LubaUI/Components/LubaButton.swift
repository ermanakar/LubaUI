//
//  LubaButton.swift
//  LubaUI
//
//  A refined button built on composable primitives.
//
//  Architecture:
//  - Visual styling via LubaButtonStyling protocol (composable, extensible)
//  - Press interaction via LubaInteractiveButtonStyle (reusable)
//  - Motion constants via LubaMotion (consistent)
//  - Haptics via LubaConfig environment (configurable)
//
//  Usage:
//  ```swift
//  // Classic API (backwards compatible)
//  LubaButton("Save", style: .primary) { }
//
//  // New API with custom styling
//  LubaButton("Save", styling: MyBrandStyle()) { }
//  ```
//

import SwiftUI

// MARK: - Button Style Enum (Backwards Compatible)

/// Button visual style presets.
public enum LubaButtonStyle {
    case primary    // Filled accent background
    case secondary  // Bordered, surface background
    case ghost      // Text only, no background
    case destructive // Red, for dangerous actions
    case subtle     // Minimal, for secondary actions
    case glass      // Translucent glass background

    var styling: any LubaButtonStyling {
        switch self {
        case .primary: return LubaPrimaryStyle()
        case .secondary: return LubaSecondaryStyle()
        case .ghost: return LubaGhostStyle()
        case .destructive: return LubaDestructiveStyle()
        case .subtle: return LubaSubtleStyle()
        case .glass: return LubaGlassButtonStyle()
        }
    }

    var isGlass: Bool { self == .glass }
}

// MARK: - Icon Position

/// Position of icon relative to button label
public enum LubaIconPosition {
    case leading
    case trailing
}

// MARK: - Button Size

public enum LubaButtonSize {
    case small
    case medium
    case large

    /// Vertical padding, resolved against a theme's spacing scale.
    /// All defaults land on the 4pt grid.
    func verticalPadding(_ spacing: LubaThemeSpacing) -> CGFloat {
        switch self {
        case .small: return spacing.sm   // 8
        case .medium: return spacing.md  // 12
        case .large: return spacing.lg   // 16
        }
    }

    /// Horizontal padding, resolved against a theme's spacing scale.
    /// All defaults land on the 4pt grid.
    func horizontalPadding(_ spacing: LubaThemeSpacing) -> CGFloat {
        switch self {
        case .small: return spacing.md            // 12
        case .medium: return spacing.custom(5)    // 20
        case .large: return spacing.custom(7)     // 28
        }
    }

    /// The semantic text role for this size — resolved through the theme so
    /// custom typography and Dynamic Type both apply.
    var role: LubaTextRole {
        switch self {
        case .small: return .buttonSmall
        case .medium: return .button
        case .large: return .buttonLarge
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 16
        case .large: return 18
        }
    }

    var cornerRadius: CGFloat {
        cornerRadius(.default)
    }

    /// Corner radius resolved against a theme's radius scale.
    func cornerRadius(_ radius: LubaThemeRadius) -> CGFloat {
        switch self {
        case .small: return radius.sm    // 8
        case .medium: return radius.md   // 12
        case .large: return radius.md    // 12
        }
    }

    /// Visual minimum height. 
    /// Keep all button sizes at or above Apple HIG 44pt touch target.
    var minHeight: CGFloat {
        switch self {
        case .small: return 44
        case .medium: return 44  // Apple HIG minimum
        case .large: return 52
        }
    }

    var spinnerSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 16
        case .large: return 18
        }
    }
}

// MARK: - LubaButton

/// A refined button with multiple styles and sizes.
///
/// Classic API:
/// ```swift
/// LubaButton("Save", style: .primary) { save() }
/// LubaButton("Cancel", style: .ghost) { cancel() }
/// ```
///
/// Custom styling API:
/// ```swift
/// LubaButton("Brand Action", styling: MyBrandStyle()) { action() }
/// ```
public struct LubaButton: View {
    private let title: String
    private let styling: any LubaButtonStyling
    private let size: LubaButtonSize
    private let isLoading: Bool
    private let isDisabled: Bool
    private let icon: Image?
    private let iconPosition: LubaIconPosition
    private let fullWidth: Bool?
    private let useGlass: Bool
    private let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @LubaEnvironment private var luba

    // MARK: - Classic Initializer (Backwards Compatible)

    /// Create a button with a preset style.
    public init(
        _ title: String,
        style: LubaButtonStyle = .primary,
        size: LubaButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        icon: Image? = nil,
        iconPosition: LubaIconPosition = .leading,
        fullWidth: Bool? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.styling = style.styling
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.icon = icon
        self.iconPosition = iconPosition
        self.fullWidth = fullWidth
        self.useGlass = style.isGlass
        self.action = action
    }

    // MARK: - Custom Styling Initializer

    /// Create a button with a custom styling.
    public init(
        _ title: String,
        styling: some LubaButtonStyling,
        size: LubaButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        icon: Image? = nil,
        iconPosition: LubaIconPosition = .leading,
        fullWidth: Bool? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.styling = styling
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.icon = icon
        self.iconPosition = iconPosition
        self.fullWidth = fullWidth
        self.useGlass = styling is LubaGlassButtonStyle
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: performAction) {
            buttonContent
        }
        .buttonStyle(LubaCoreButtonStyle(
            styling: styling,
            size: size,
            useGlass: useGlass,
            fullWidth: resolvedFullWidth,
            colorScheme: colorScheme,
            colors: luba.colors,
            font: luba.fonts.font(size.role),
            radius: size.cornerRadius(luba.radius),
            horizontalPadding: size.horizontalPadding(luba.spacing),
            verticalPadding: size.verticalPadding(luba.spacing),
            minHeight: max(size.minHeight, luba.minimumTouchTarget),
            motion: luba.motion
        ))
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? LubaMotion.disabledOpacity : 1)
        .animation(luba.motion.animation(LubaMotion.stateAnimation), value: isDisabled)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
        .accessibilityRemoveTraits(isDisabled ? .isButton : [])
        .accessibilityValue(accessibilityValue)
    }

    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: LubaMotion.iconLabelSpacing) {
            // Leading icon
            if !isLoading, let icon = icon, iconPosition == .leading {
                iconView(icon)
                    .transition(luba.motion.transition(.scale.combined(with: .opacity)))
            }

            // Loading state
            if isLoading {
                LubaSpinner(size: size.spinnerSize, style: .arc)
                    .transition(luba.motion.transition(.scale.combined(with: .opacity)))
            }

            // Title — wraps rather than truncating at large Dynamic Type sizes.
            Text(title)
                .font(luba.fonts.font(size.role))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(isLoading ? LubaMotion.loadingContentOpacity : 1)
                .animation(luba.motion.animation(LubaMotion.stateAnimation), value: isLoading)

            // Trailing icon
            if !isLoading, let icon = icon, iconPosition == .trailing {
                iconView(icon)
                    .transition(luba.motion.transition(.scale.combined(with: .opacity)))
            }
        }
    }

    private var accessibilityValue: String {
        if isLoading { return LubaStrings.loading }
        if isDisabled { return LubaStrings.disabled }
        return ""
    }

    @ViewBuilder
    private func iconView(_ image: Image) -> some View {
        image
            .font(.system(size: size.iconSize, weight: .semibold))
    }

    private func performAction() {
        guard !isLoading && !isDisabled else { return }

        if luba.hapticsEnabled {
            styling.haptic.trigger()
        }

        action()
    }

    // MARK: - Resolved Properties

    private var resolvedFullWidth: Bool {
        fullWidth ?? styling.defaultsToFullWidth
    }
}

// MARK: - Core Button Style

/// Internal style that applies the LubaButtonStyling protocol logic directly within `makeBody`.
/// This eliminates the need for PreferenceKey propagation and improves performance.
private struct LubaCoreButtonStyle: ButtonStyle {
    let styling: any LubaButtonStyling
    let size: LubaButtonSize
    let useGlass: Bool
    let fullWidth: Bool
    let colorScheme: ColorScheme
    let colors: LubaThemeColors
    let font: Font
    let radius: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let minHeight: CGFloat
    let motion: LubaMotionPolicy

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        let context = LubaButtonStyleContext(
            isPressed: isPressed,
            colorScheme: colorScheme,
            colors: colors
        )
        let fgColor = styling.foregroundColor(in: context)
        let bgColor = styling.backgroundColor(in: context)

        let label = configuration.label
            .font(font)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(minHeight: minHeight)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .foregroundStyle(fgColor)

        Group {
            if useGlass {
                label
                    .lubaGlass(.regular, cornerRadius: radius)
            } else {
                label
                    .background(bgColor)
                    .overlay(
                        Group {
                            if let borderColor = styling.borderColor(in: context) {
                                RoundedRectangle(cornerRadius: radius, style: .continuous)
                                    .strokeBorder(borderColor, lineWidth: styling.borderWidth)
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            }
        }
        // Expand touch target invisibly to meet accessibility guidelines
        .background(
            Color.clear
                .frame(minWidth: minHeight, minHeight: minHeight)
                .contentShape(Rectangle())
        )
        .scaleEffect(motion.pressScale(isPressed ? LubaMotion.pressScale : 1.0))
        .animation(motion.interaction(LubaMotion.colorAnimation), value: isPressed)
        .animation(motion.decorative(LubaMotion.pressAnimation), value: isPressed)
    }
}

// MARK: - Preview

#Preview("Button Styles") {
    VStack(spacing: 16) {
        LubaButton("Primary Button", style: .primary) { }
        LubaButton("Secondary Button", style: .secondary) { }
        LubaButton("Ghost Button", style: .ghost) { }
        LubaButton("Destructive", style: .destructive) { }
        LubaButton("Subtle", style: .subtle) { }
    }
    .padding(20)
    .background(LubaColors.background)
}

#Preview("Custom Styling") {
    VStack(spacing: 16) {
        LubaButton("Primary", styling: LubaPrimaryStyle()) { }
        LubaButton("Secondary", styling: LubaSecondaryStyle()) { }
        LubaButton("Ghost", styling: LubaGhostStyle()) { }
    }
    .padding(20)
    .background(LubaColors.background)
}

#Preview("Button Sizes") {
    VStack(spacing: 16) {
        LubaButton("Small", style: .secondary, size: .small) { }
        LubaButton("Medium", style: .secondary, size: .medium) { }
        LubaButton("Large", style: .secondary, size: .large) { }
    }
    .padding(20)
    .background(LubaColors.background)
}

#Preview("Glass Button") {
    ZStack {
        LinearGradient(
            colors: [Color(hex: 0x6B8068), Color(hex: 0x3D5A3E)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: LubaSpacing.lg) {
            LubaButton("Glass Button", style: .glass) { }
            LubaButton("Glass + Icon", style: .glass, icon: Image(systemName: "sparkles")) { }
        }
        .padding(LubaSpacing.xl)
    }
}

#Preview("Button Features") {
    VStack(spacing: 16) {
        LubaButton("Loading...", style: .primary, isLoading: true) { }
        LubaButton("Disabled", style: .primary, isDisabled: true) { }
        LubaButton("With Icon", style: .primary, icon: Image(systemName: "arrow.right"), iconPosition: .trailing) { }
        LubaButton("Leading Icon", style: .primary, icon: Image(systemName: "plus")) { }
    }
    .padding(20)
    .background(LubaColors.background)
}
