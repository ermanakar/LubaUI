//
//  LubaLongPressable.swift
//  LubaUI
//
//  Reusable long press interaction primitive.
//  Long press with visual progress feedback and haptics.
//
//  Usage:
//  ```swift
//  // Basic long press
//  Image(systemName: "trash")
//      .lubaLongPressable { print("Deleted!") }
//
//  // With visual progress ring
//  LubaCard { content }
//      .lubaLongPressable(showProgress: true, duration: 1.0) {
//          confirmDeletion()
//      }
//  ```
//

import SwiftUI

// MARK: - Long Press Tokens

/// Configuration for long press interaction.
public enum LubaLongPressTokens {
    /// Default duration to complete the long press
    public static let defaultDuration: Double = 0.8

    /// Minimum duration (can't be faster than this)
    public static let minimumDuration: Double = 0.3

    /// Scale effect while pressing
    public static let pressScale: CGFloat = 0.95

    /// Progress ring stroke width ratio (relative to size)
    public static let progressStrokeRatio: CGFloat = 0.08

    /// Default progress ring size
    public static let defaultProgressSize: CGFloat = 48

    /// Progress ring color
    public static var progressColor: Color { LubaColors.accent }

    /// Progress ring background color
    public static var progressBackgroundColor: Color { LubaColors.gray200 }
}

// MARK: - Long Pressable Modifier

/// Makes any view respond to long press with optional visual progress.
public struct LubaLongPressableModifier: ViewModifier {
    let duration: Double
    let showProgress: Bool
    let progressSize: CGFloat
    let hapticOnStart: LubaHapticStyle?
    let hapticOnComplete: LubaHapticStyle
    let action: () -> Void

    @State private var isPressed = false
    @State private var progress: CGFloat = 0
    @State private var timer: Timer?
    @Environment(\.lubaConfig) private var config

    public init(
        duration: Double = LubaLongPressTokens.defaultDuration,
        showProgress: Bool = false,
        progressSize: CGFloat = LubaLongPressTokens.defaultProgressSize,
        hapticOnStart: LubaHapticStyle? = .light,
        hapticOnComplete: LubaHapticStyle = .success,
        action: @escaping () -> Void
    ) {
        self.duration = max(LubaLongPressTokens.minimumDuration, duration)
        self.showProgress = showProgress
        self.progressSize = progressSize
        self.hapticOnStart = hapticOnStart
        self.hapticOnComplete = hapticOnComplete
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? LubaLongPressTokens.pressScale : 1.0)
            .animation(LubaMotion.pressAnimation, value: isPressed)
            .overlay(
                Group {
                    if showProgress && isPressed {
                        progressRing
                    }
                }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !isPressed else { return }
                        startPress()
                    }
                    .onEnded { _ in
                        cancelPress()
                    }
            )
            .onDisappear {
                cancelPress()
            }
    }

    private var progressRing: some View {
        ZStack {
            // Background ring
            Circle()
                .strokeBorder(
                    LubaLongPressTokens.progressBackgroundColor,
                    lineWidth: progressSize * LubaLongPressTokens.progressStrokeRatio
                )

            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LubaLongPressTokens.progressColor,
                    style: StrokeStyle(
                        lineWidth: progressSize * LubaLongPressTokens.progressStrokeRatio,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.05), value: progress)
        }
        .frame(width: progressSize, height: progressSize)
    }

    private func startPress() {
        isPressed = true
        progress = 0

        // Start haptic
        if config.hapticsEnabled, let haptic = hapticOnStart {
            haptic.trigger()
        }

        // Start progress timer
        let interval: Double = 0.02
        let increment = CGFloat(interval / duration)

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            progress += increment

            if progress >= 1.0 {
                completePress()
            }
        }
    }

    private func cancelPress() {
        isPressed = false
        progress = 0
        timer?.invalidate()
        timer = nil
    }

    private func completePress() {
        timer?.invalidate()
        timer = nil

        // Completion haptic
        if config.hapticsEnabled {
            hapticOnComplete.trigger()
        }

        // Trigger action
        action()

        // Reset state
        isPressed = false
        progress = 0
    }
}

// MARK: - View Extension

public extension View {
    /// Make any view respond to long press.
    ///
    /// This extracts long press behavior with visual and haptic feedback.
    /// Perfect for dangerous actions that need confirmation, or hidden features.
    ///
    /// - Parameters:
    ///   - duration: How long to hold (default: 0.8s)
    ///   - showProgress: Whether to show a circular progress indicator
    ///   - progressSize: Size of the progress ring
    ///   - hapticOnStart: Haptic when press begins
    ///   - hapticOnComplete: Haptic when action triggers
    ///   - action: The action to perform on completion
    func lubaLongPressable(
        duration: Double = LubaLongPressTokens.defaultDuration,
        showProgress: Bool = false,
        progressSize: CGFloat = LubaLongPressTokens.defaultProgressSize,
        hapticOnStart: LubaHapticStyle? = .light,
        hapticOnComplete: LubaHapticStyle = .success,
        action: @escaping () -> Void
    ) -> some View {
        modifier(LubaLongPressableModifier(
            duration: duration,
            showProgress: showProgress,
            progressSize: progressSize,
            hapticOnStart: hapticOnStart,
            hapticOnComplete: hapticOnComplete,
            action: action
        ))
    }
}

// MARK: - Standalone Progress View

/// A standalone long press button with built-in progress visualization.
public struct LubaLongPressButton: View {
    let icon: String
    let label: String?
    let duration: Double
    let size: CGFloat
    let action: () -> Void

    @State private var isPressed = false
    @State private var progress: CGFloat = 0
    @State private var timer: Timer?
    @Environment(\.lubaConfig) private var config

    public init(
        icon: String,
        label: String? = nil,
        duration: Double = LubaLongPressTokens.defaultDuration,
        size: CGFloat = 56,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.duration = max(LubaLongPressTokens.minimumDuration, duration)
        self.size = size
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background
                Circle()
                    .fill(isPressed ? LubaColors.accentSubtle : LubaColors.gray100)
                    .frame(width: size, height: size)

                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LubaColors.accent,
                        style: StrokeStyle(
                            lineWidth: size * 0.06,
                            lineCap: .round
                        )
                    )
                    .frame(width: size - 8, height: size - 8)
                    .rotationEffect(.degrees(-90))

                // Icon
                Image(systemName: icon)
                    .font(.system(size: size * 0.35))
                    .foregroundStyle(isPressed ? LubaColors.accent : LubaColors.textSecondary)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(LubaMotion.pressAnimation, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !isPressed else { return }
                        startPress()
                    }
                    .onEnded { _ in
                        cancelPress()
                    }
            )
            .onDisappear {
                cancelPress()
            }

            if let label = label {
                Text(label)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }
        }
    }

    private func startPress() {
        isPressed = true
        progress = 0

        if config.hapticsEnabled {
            LubaHaptics.light()
        }

        let interval: Double = 0.02
        let increment = CGFloat(interval / duration)

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            progress += increment
            if progress >= 1.0 {
                completePress()
            }
        }
    }

    private func cancelPress() {
        isPressed = false
        progress = 0
        timer?.invalidate()
        timer = nil
    }

    private func completePress() {
        timer?.invalidate()
        timer = nil

        if config.hapticsEnabled {
            LubaHaptics.success()
        }

        action()
        isPressed = false
        progress = 0
    }
}

// MARK: - Preview

#Preview("Long Pressable") {
    struct PreviewWrapper: View {
        @State private var deleteCount = 0
        @State private var message = "Hold to delete"

        var body: some View {
            VStack(spacing: 32) {
                Text("Long Press Primitive")
                    .font(LubaTypography.title)
                    .foregroundStyle(LubaColors.textPrimary)

                // Basic modifier
                VStack(spacing: 8) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(LubaColors.error)
                        .padding(20)
                        .background(LubaColors.surface)
                        .clipShape(Circle())
                        .lubaLongPressable(duration: 1.0, hapticOnComplete: .warning) {
                            deleteCount += 1
                            message = "Deleted! (\(deleteCount))"
                        }

                    Text(message)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                }

                Divider()

                // With progress ring overlay
                Text("With Progress Ring")
                    .font(LubaTypography.headline)

                RoundedRectangle(cornerRadius: 16)
                    .fill(LubaColors.surface)
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack {
                            Image(systemName: "lock.fill")
                            Text("Hold to unlock")
                                .font(.caption)
                        }
                        .foregroundStyle(LubaColors.textSecondary)
                    )
                    .lubaLongPressable(
                        duration: 1.5,
                        showProgress: true,
                        progressSize: 80,
                        hapticOnComplete: .success
                    ) {
                        message = "Unlocked!"
                    }

                Divider()

                // Standalone button
                Text("Standalone Button")
                    .font(LubaTypography.headline)

                HStack(spacing: 24) {
                    LubaLongPressButton(icon: "heart.fill", label: "Like", duration: 0.5) {
                        message = "Liked!"
                    }

                    LubaLongPressButton(icon: "trash", label: "Delete", duration: 1.0) {
                        message = "Deleted!"
                    }

                    LubaLongPressButton(icon: "checkmark", label: "Confirm", duration: 0.8) {
                        message = "Confirmed!"
                    }
                }

                Spacer()
            }
            .padding()
            .background(LubaColors.background)
        }
    }

    return PreviewWrapper()
}
