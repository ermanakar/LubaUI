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
    @LubaEnvironment private var luba
    private let value: Double
    private let showLabel: Bool


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
                    .font(luba.fonts.caption)
                    .foregroundStyle(luba.colors.textSecondary)
                    .monospacedDigit()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(luba.colors.fill)

                    // Filled
                    Capsule()
                        .fill(luba.colors.accent)
                        .frame(width: geometry.size.width * CGFloat(value))
                        .animation(luba.motion.animation(LubaMotion.stateAnimation), value: value)
                }
            }
            .frame(height: LubaProgressTokens.barHeight)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(LubaStrings.progress)
        .accessibilityValue(LubaStrings.percent(Int(value * 100)))
    }
}

// MARK: - LubaCircularProgress

/// A refined circular progress indicator.
public struct LubaCircularProgress: View {
    @LubaEnvironment private var luba
    private let value: Double
    private let size: CGFloat
    private let lineWidth: CGFloat
    private let showLabel: Bool


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
                .strokeBorder(luba.colors.fill, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: CGFloat(value))
                .stroke(luba.colors.accent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(luba.motion.animation(LubaMotion.stateAnimation), value: value)

            // Label
            if showLabel {
                Text("\(Int(value * 100))")
                    .font(luba.fonts.custom(size: size * LubaProgressTokens.labelFontRatio, weight: .semibold))
                    .foregroundStyle(luba.colors.textPrimary)
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(LubaStrings.progress)
        .accessibilityValue(LubaStrings.percent(Int(value * 100)))
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
    @LubaEnvironment private var luba
    private let size: CGFloat
    private let style: LubaSpinnerStyle

    @State private var isAnimating = false

    /// Creates a loading spinner.
    ///
    /// - Parameters:
    ///   - size: Diameter of the spinner.
    ///   - style: Animation style (arc, pulse, dots, or breathe).
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
            // The style views own their repeat animations; this just flips the
            // driving flag once, without an implicit animation of its own.
            //
            // Only flip it if something can actually animate. Each style reads
            // the flag to pick its *target* value, so leaving it false when
            // animations are off is what makes them settle on their resting
            // state — a full-opacity arc, a visible pulse ring — rather than
            // freezing mid-cycle at zero opacity.
            isAnimating = luba.motion.allowsAnimation
        }
    }

    // MARK: - Arc Style (Clean rotation)

    private var arcSpinner: some View {
        // Under Reduce Motion the arc stops rotating and breathes in opacity
        // instead — still legibly "busy", with no movement.
        Circle()
            .trim(from: 0, to: LubaSpinnerTokens.arcTrim)
            .stroke(
                luba.colors.accent,
                style: StrokeStyle(lineWidth: size * LubaSpinnerTokens.strokeRatio, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(spins && isAnimating ? 360 : 0))
            .opacity(breathes && isAnimating ? LubaSpinnerTokens.breatheMinOpacity : 1)
            .animation(
                spins
                    ? luba.motion.repeating(.linear(duration: LubaSpinnerTokens.arcDuration).repeatForever(autoreverses: false))
                    : luba.motion.repeatingOpacity(.easeInOut(duration: LubaSpinnerTokens.arcDuration).repeatForever(autoreverses: true)),
                value: isAnimating
            )
    }

    /// Whether this spinner may use rotation/scale, or must fall back to opacity.
    private var spins: Bool { luba.motion.allowsDecorativeMotion }

    /// Whether the opacity fallback should run in place of rotation.
    ///
    /// Only under Reduce Motion. When animations are switched off entirely there
    /// is nothing to fall back *to* — dimming a static arc to its breathe-minimum
    /// would leave it permanently faded rather than simply still.
    private var breathes: Bool {
        luba.motion.allowsAnimation && luba.motion.prefersReducedMotion
    }

    // MARK: - Pulse Style (No spinning)

    private var pulseSpinner: some View {
        ZStack {
            // Outer ring
            Circle()
                .strokeBorder(luba.colors.accent.opacity(0.2), lineWidth: size * 0.08)
                .frame(width: size, height: size)

            // Pulsing ring
            Circle()
                .strokeBorder(luba.colors.accent, lineWidth: size * 0.08)
                .frame(width: size, height: size)
                .scaleEffect(spins ? (isAnimating ? 1.0 : LubaSpinnerTokens.pulseMinScale) : 1.0)
                .opacity(isAnimating ? 0.0 : 1.0)
                .animation(
                    luba.motion.repeatingOpacity(
                        .easeOut(duration: LubaSpinnerTokens.pulseDuration).repeatForever(autoreverses: false)
                    ),
                    value: isAnimating
                )
        }
    }

    // MARK: - Dots Style (Fading sequence)

    private var dotsSpinner: some View {
        HStack(spacing: size * LubaSpinnerTokens.dotsSpacingRatio) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(luba.colors.accent)
                    .frame(width: size * LubaSpinnerTokens.dotSizeRatio, height: size * LubaSpinnerTokens.dotSizeRatio)
                    .opacity(isAnimating ? [0.3, 0.6, 1.0][index] : [1.0, 0.6, 0.3][index])
                    .animation(
                        luba.motion.repeatingOpacity(
                            .easeInOut(duration: LubaSpinnerTokens.dotsDuration)
                                .repeatForever(autoreverses: true)
                                .delay(luba.motion.staggerDelay(index: index, base: LubaSpinnerTokens.dotsStagger))
                        ),
                        value: isAnimating
                    )
            }
        }
        .frame(height: size)
    }

    // MARK: - Breathe Style (Gentle scale)

    private var breatheSpinner: some View {
        Circle()
            .fill(luba.colors.accent)
            .frame(width: size * 0.5, height: size * 0.5)
            .scaleEffect(spins ? (isAnimating ? 1.0 : LubaSpinnerTokens.breatheMinScale) : 1.0)
            // Resting state is full opacity; the cycle autoreverses, so starting
            // from the dim end is visually identical while animating.
            .opacity(isAnimating ? LubaSpinnerTokens.breatheMinOpacity : 1.0)
            .animation(
                luba.motion.repeatingOpacity(
                    .easeInOut(duration: LubaSpinnerTokens.breatheDuration).repeatForever(autoreverses: true)
                ),
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
