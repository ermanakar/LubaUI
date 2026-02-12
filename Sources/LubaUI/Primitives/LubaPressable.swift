//
//  LubaPressable.swift
//  LubaUI
//
//  Reusable press interaction primitive.
//  The DNA of tappable elements — extract once, use everywhere.
//
//  Usage:
//  ```swift
//  // Make any view tappable with the Luba feel
//  Image(systemName: "heart.fill")
//      .lubaPressable { print("Tapped!") }
//
//  // Customize the feel
//  LubaCard { content }
//      .lubaPressable(scale: 0.98, haptic: .medium) { navigate() }
//  ```
//

import SwiftUI

// MARK: - Haptic Style

/// Semantic haptic feedback styles.
/// Maps intent to physical sensation.
public enum LubaHapticStyle {
    /// Subtle tap — buttons, toggles
    case light

    /// Confident tap — primary actions
    case medium

    /// Emphatic tap — destructive or important actions
    case heavy

    /// Gentle tap — passive interactions
    case soft

    /// Tick — selection changes, pickers
    case selection

    /// Celebration — task complete, success
    case success

    /// Caution — validation issues
    case warning

    /// Alert — errors, failures
    case error

    func trigger() {
        switch self {
        case .light: LubaHaptics.light()
        case .medium: LubaHaptics.medium()
        case .heavy: LubaHaptics.heavy()
        case .soft: LubaHaptics.soft()
        case .selection: LubaHaptics.selection()
        case .success: LubaHaptics.success()
        case .warning: LubaHaptics.warning()
        case .error: LubaHaptics.error()
        }
    }
}

// MARK: - Pressable Modifier

/// Makes any view respond to press with scale, animation, and haptics.
public struct LubaPressableModifier: ViewModifier {
    let scale: CGFloat
    let animation: Animation
    let haptic: LubaHapticStyle?
    let action: () -> Void

    @State private var isPressed = false
    @Environment(\.lubaConfig) private var config

    public init(
        scale: CGFloat = LubaMotion.pressScale,
        animation: Animation = LubaMotion.pressAnimation,
        haptic: LubaHapticStyle? = .light,
        action: @escaping () -> Void
    ) {
        self.scale = scale
        self.animation = animation
        self.haptic = haptic
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(animation, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !isPressed else { return }
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                        triggerAction()
                    }
            )
    }

    private func triggerAction() {
        if config.hapticsEnabled, let haptic = haptic {
            haptic.trigger()
        }
        action()
    }
}

// MARK: - View Extension

public extension View {
    /// Make any view pressable with the Luba feel.
    ///
    /// This extracts the core press interaction so it can be applied to any view —
    /// not just buttons. Cards, images, list rows, custom components — anything.
    ///
    /// - Parameters:
    ///   - scale: How much the view shrinks on press (default: 0.97)
    ///   - animation: The press animation (default: quick spring)
    ///   - haptic: Haptic feedback style, or nil for none
    ///   - action: The action to perform on tap
    func lubaPressable(
        scale: CGFloat = LubaMotion.pressScale,
        animation: Animation = LubaMotion.pressAnimation,
        haptic: LubaHapticStyle? = .light,
        action: @escaping () -> Void
    ) -> some View {
        modifier(LubaPressableModifier(
            scale: scale,
            animation: animation,
            haptic: haptic,
            action: action
        ))
    }
}

// MARK: - Button Styles

/// A ButtonStyle that applies Luba's press scale animation.
/// Use when you need SwiftUI Button's accessibility features.
public struct LubaPressableButtonStyle: ButtonStyle {
    let scale: CGFloat
    let animation: Animation

    public init(
        scale: CGFloat = LubaMotion.pressScale,
        animation: Animation = LubaMotion.pressAnimation
    ) {
        self.scale = scale
        self.animation = animation
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(animation, value: configuration.isPressed)
    }
}

/// A ButtonStyle that exposes press state for components that need it.
/// Used by LubaButton to change colors on press.
public struct LubaInteractiveButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    let scale: CGFloat
    let animation: Animation

    public init(
        isPressed: Binding<Bool>,
        scale: CGFloat = LubaMotion.pressScale,
        animation: Animation = LubaMotion.pressAnimation
    ) {
        self._isPressed = isPressed
        self.scale = scale
        self.animation = animation
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(animation, value: configuration.isPressed)
            .preference(key: PressStateKey.self, value: configuration.isPressed)
            .onPreferenceChange(PressStateKey.self) { value in
                isPressed = value
            }
    }
}

// PreferenceKey for propagating press state (iOS 16 compatible)
private struct PressStateKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

// MARK: - Preview

#Preview("Pressable Modifier") {
    VStack(spacing: 24) {
        Text("Tap me!")
            .font(.headline)
            .padding()
            .background(LubaColors.surface)
            .cornerRadius(12)
            .lubaPressable { print("Tapped!") }

        Image(systemName: "heart.fill")
            .font(.system(size: 48))
            .foregroundStyle(LubaColors.accent)
            .lubaPressable(haptic: .medium) { print("Loved!") }

        RoundedRectangle(cornerRadius: 16)
            .fill(LubaColors.accentSubtle)
            .frame(width: 200, height: 100)
            .overlay(Text("Card").foregroundStyle(LubaColors.textPrimary))
            .lubaPressable(scale: 0.98) { print("Card tapped!") }
    }
    .padding()
    .background(LubaColors.background)
}
