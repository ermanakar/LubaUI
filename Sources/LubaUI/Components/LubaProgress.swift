//
//  LubaProgress.swift
//  LubaUI
//
//  A refined progress bar and circular progress indicator.
//
//  Architecture:
//  - Uses LubaProgressTokens for all dimensions
//  - Uses LubaMotion for animations
//  - Respects LubaConfig for reduced motion
//

import SwiftUI

// MARK: - LubaProgressBar

/// A refined linear progress bar.
public struct LubaProgressBar: View {
    private let value: Double
    private let showLabel: Bool

    @Environment(\.lubaConfig) private var config

    /// Create a progress bar.
    /// - Parameters:
    ///   - value: Progress value between 0 and 1
    ///   - showLabel: Whether to show percentage label
    public init(value: Double, showLabel: Bool = false) {
        self.value = max(0, min(1, value))
        self.showLabel = showLabel
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: LubaSpacing.xs) {
            if showLabel {
                Text("\(Int(value * 100))%")
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
                    .monospacedDigit()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(LubaColors.gray200)

                    // Filled
                    Capsule()
                        .fill(LubaColors.accent)
                        .frame(width: geometry.size.width * CGFloat(value))
                        .animation(config.animationsEnabled ? LubaMotion.stateAnimation : nil, value: value)
                }
            }
            .frame(height: LubaProgressTokens.barHeight)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(value * 100)) percent")
    }
}

// MARK: - LubaCircularProgress

/// A refined circular progress indicator.
public struct LubaCircularProgress: View {
    private let value: Double
    private let size: CGFloat
    private let lineWidth: CGFloat
    private let showLabel: Bool

    @Environment(\.lubaConfig) private var config

    /// Create a circular progress indicator.
    /// - Parameters:
    ///   - value: Progress value between 0 and 1
    ///   - size: Diameter of the circle
    ///   - lineWidth: Stroke width
    ///   - showLabel: Whether to show percentage in center
    public init(
        value: Double,
        size: CGFloat = LubaProgressTokens.circularSize,
        lineWidth: CGFloat = LubaProgressTokens.circularStrokeWidth,
        showLabel: Bool = true
    ) {
        self.value = max(0, min(1, value))
        self.size = size
        self.lineWidth = lineWidth
        self.showLabel = showLabel
    }

    public var body: some View {
        ZStack {
            // Background circle
            Circle()
                .strokeBorder(LubaColors.gray200, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: CGFloat(value))
                .stroke(LubaColors.accent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(config.animationsEnabled ? LubaMotion.stateAnimation : nil, value: value)

            // Label
            if showLabel {
                Text("\(Int(value * 100))")
                    .font(LubaTypography.custom(size: size * LubaProgressTokens.labelFontRatio, weight: .semibold))
                    .foregroundStyle(LubaColors.textPrimary)
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(value * 100)) percent")
    }
}

// MARK: - LubaSpinner

/// Spinner style options
public enum LubaSpinnerStyle {
    case arc           // Clean rotating arc
    case pulse         // Pulsing circle (no spinning)
    case dots          // Fading dots (no spinning)
    case breathe       // Breathing circle (no spinning)
}

/// A refined loading indicator.
public struct LubaSpinner: View {
    private let size: CGFloat
    private let style: LubaSpinnerStyle

    @Environment(\.lubaConfig) private var config
    @State private var isAnimating = false

    public init(size: CGFloat = LubaSpinnerTokens.defaultSize, style: LubaSpinnerStyle = .arc) {
        self.size = size
        self.style = style
    }

    public var body: some View {
        Group {
            switch style {
            case .arc:
                arcSpinner
            case .pulse:
                pulseSpinner
            case .dots:
                dotsSpinner
            case .breathe:
                breatheSpinner
            }
        }
        .onAppear {
            guard config.animationsEnabled else {
                isAnimating = true
                return
            }
            withAnimation {
                isAnimating = true
            }
        }
    }

    // MARK: - Arc Style (Clean rotation)

    private var arcSpinner: some View {
        Circle()
            .trim(from: 0, to: LubaSpinnerTokens.arcTrim)
            .stroke(
                LubaColors.accent,
                style: StrokeStyle(lineWidth: size * LubaSpinnerTokens.strokeRatio, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                config.animationsEnabled
                    ? .linear(duration: LubaSpinnerTokens.arcDuration).repeatForever(autoreverses: false)
                    : nil,
                value: isAnimating
            )
    }

    // MARK: - Pulse Style (No spinning)

    private var pulseSpinner: some View {
        ZStack {
            // Outer ring
            Circle()
                .strokeBorder(LubaColors.accent.opacity(0.2), lineWidth: size * 0.08)
                .frame(width: size, height: size)

            // Pulsing ring
            Circle()
                .strokeBorder(LubaColors.accent, lineWidth: size * 0.08)
                .frame(width: size, height: size)
                .scaleEffect(isAnimating ? 1.0 : LubaSpinnerTokens.pulseMinScale)
                .opacity(isAnimating ? 0.0 : 1.0)
                .animation(
                    config.animationsEnabled
                        ? .easeOut(duration: LubaSpinnerTokens.pulseDuration).repeatForever(autoreverses: false)
                        : nil,
                    value: isAnimating
                )
        }
    }

    // MARK: - Dots Style (Fading sequence)

    private var dotsSpinner: some View {
        HStack(spacing: size * LubaSpinnerTokens.dotsSpacingRatio) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(LubaColors.accent)
                    .frame(width: size * LubaSpinnerTokens.dotSizeRatio, height: size * LubaSpinnerTokens.dotSizeRatio)
                    .opacity(isAnimating ? [0.3, 0.6, 1.0][index] : [1.0, 0.6, 0.3][index])
                    .animation(
                        config.animationsEnabled
                            ? .easeInOut(duration: LubaSpinnerTokens.dotsDuration)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * LubaSpinnerTokens.dotsStagger)
                            : nil,
                        value: isAnimating
                    )
            }
        }
        .frame(height: size)
    }

    // MARK: - Breathe Style (Gentle scale)

    private var breatheSpinner: some View {
        Circle()
            .fill(LubaColors.accent)
            .frame(width: size * 0.5, height: size * 0.5)
            .scaleEffect(isAnimating ? 1.0 : LubaSpinnerTokens.breatheMinScale)
            .opacity(isAnimating ? 1.0 : LubaSpinnerTokens.breatheMinOpacity)
            .animation(
                config.animationsEnabled
                    ? .easeInOut(duration: LubaSpinnerTokens.breatheDuration).repeatForever(autoreverses: true)
                    : nil,
                value: isAnimating
            )
            .frame(width: size, height: size)
    }
}

// MARK: - Preview

#Preview("Progress") {
    VStack(spacing: LubaSpacing.xl) {
        LubaProgressBar(value: 0.65, showLabel: true)
        
        HStack(spacing: LubaSpacing.xl) {
            LubaCircularProgress(value: 0.75)
            LubaCircularProgress(value: 0.33, size: 48, showLabel: false)
            LubaSpinner()
        }
    }
    .padding()
    .background(LubaColors.background)
}
