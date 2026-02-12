//
//  LubaSlider.swift
//  LubaUI
//
//  A refined slider with haptic feedback at bounds.
//
//  Architecture:
//  - Uses LubaSliderTokens for sizing
//  - Uses LubaMotion for animations
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - LubaSlider

/// A refined slider with optional label and value display.
///
/// Usage:
/// ```swift
/// LubaSlider(value: $volume, in: 0...100, label: "Volume", showValue: true)
/// ```
public struct LubaSlider: View {
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double?
    private let label: String?
    private let showValue: Bool
    private let isDisabled: Bool

    @State private var lastHapticValue: Double = 0
    @State private var isDragging = false

    @Environment(\.lubaConfig) private var config

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double? = nil,
        label: String? = nil,
        showValue: Bool = false,
        isDisabled: Bool = false
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        self.showValue = showValue
        self.isDisabled = isDisabled
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: LubaSliderTokens.labelSpacing) {
            labelRow
            sliderTrack
        }
        .opacity(isDisabled ? LubaMotion.disabledOpacity : 1)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Slider")
        .accessibilityValue(formattedValue)
        .accessibilityAdjustableAction { direction in
            let stepSize = step ?? (range.upperBound - range.lowerBound) / 10
            switch direction {
            case .increment: value = min(range.upperBound, value + stepSize)
            case .decrement: value = max(range.lowerBound, value - stepSize)
            @unknown default: break
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var labelRow: some View {
        if label != nil || showValue {
            HStack {
                if let label = label {
                    Text(label)
                        .font(.system(size: LubaSliderTokens.labelFontSize, design: .rounded))
                        .foregroundStyle(LubaColors.textPrimary)
                }

                Spacer()

                if showValue {
                    Text(formattedValue)
                        .font(.system(size: LubaSliderTokens.valueFontSize, weight: .medium, design: .monospaced))
                        .foregroundStyle(LubaColors.textSecondary)
                }
            }
        }
    }

    private var sliderTrack: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(LubaColors.gray200)
                    .frame(height: LubaSliderTokens.trackHeight)

                // Filled track
                Capsule()
                    .fill(LubaColors.accent)
                    .frame(width: filledWidth(for: geometry.size.width), height: LubaSliderTokens.trackHeight)

                // Thumb
                Circle()
                    .fill(LubaColors.surface)
                    .frame(width: LubaSliderTokens.thumbSize, height: LubaSliderTokens.thumbSize)
                    .overlay(
                        Circle()
                            .strokeBorder(LubaColors.accent, lineWidth: LubaSliderTokens.thumbBorderWidth)
                    )
                    .shadow(
                        color: Color.black.opacity(LubaSliderTokens.thumbShadowOpacity),
                        radius: LubaSliderTokens.thumbShadowRadius,
                        y: 1
                    )
                    .scaleEffect(isDragging ? LubaSliderTokens.thumbDragScale : 1.0)
                    .offset(x: thumbOffset(for: geometry.size.width))
                    .animation(LubaMotion.micro, value: isDragging)
            }
            // Full-width touch target for better interaction
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        guard !isDisabled else { return }
                        isDragging = true
                        updateValue(for: gesture.location.x, in: geometry.size.width)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
        .frame(height: LubaSliderTokens.thumbSize)
    }

    // MARK: - Calculations

    private var formattedValue: String {
        if let step = step, step >= 1 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }

    private func filledWidth(for totalWidth: CGFloat) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return totalWidth * CGFloat(percentage)
    }

    private func thumbOffset(for totalWidth: CGFloat) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (totalWidth - LubaSliderTokens.thumbSize) * CGFloat(percentage)
    }

    private func updateValue(for position: CGFloat, in totalWidth: CGFloat) {
        let percentage = max(0, min(1, position / totalWidth))
        var newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)

        // Apply step if specified
        if let step = step {
            newValue = (newValue / step).rounded() * step
        }

        // Clamp to range
        newValue = max(range.lowerBound, min(range.upperBound, newValue))

        // Haptic at bounds
        if config.hapticsEnabled {
            if (newValue == range.lowerBound || newValue == range.upperBound) && lastHapticValue != newValue {
                LubaHaptics.light()
            }
        }

        lastHapticValue = newValue
        value = newValue
    }
}

// MARK: - Preview

#Preview("Slider") {
    struct PreviewWrapper: View {
        @State private var value1: Double = 0.5
        @State private var value2: Double = 50

        var body: some View {
            VStack(spacing: 24) {
                LubaSlider(value: $value1, showValue: true)
                LubaSlider(value: $value2, in: 0...100, step: 1, label: "Volume", showValue: true)
                LubaSlider(value: .constant(30), in: 0...100, label: "Disabled", showValue: true, isDisabled: true)
            }
            .padding(20)
            .background(LubaColors.background)
        }
    }

    return PreviewWrapper()
}
