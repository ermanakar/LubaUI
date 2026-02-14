//
//  LubaStepper.swift
//  LubaUI
//
//  A numeric stepper with increment/decrement controls.
//
//  Design Decisions:
//  - 44pt button touch targets for accessibility
//  - Rounded pill shape with outlined style
//  - Haptic feedback on each step
//  - Configurable range and step size
//

import SwiftUI

// MARK: - LubaStepper

/// A numeric stepper for adjusting values.
///
/// ```swift
/// LubaStepper(value: $quantity, in: 1...10, label: "Quantity")
/// LubaStepper(value: $count, step: 5)
/// ```
public struct LubaStepper: View {
    @Binding private var value: Int
    private let range: ClosedRange<Int>
    private let step: Int
    private let label: String?

    @Environment(\.lubaConfig) private var config

    public init(
        value: Binding<Int>,
        in range: ClosedRange<Int> = 0...99,
        step: Int = 1,
        label: String? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
    }

    public var body: some View {
        HStack(spacing: LubaSpacing.md) {
            if let label = label {
                Text(label)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)

                Spacer()
            }

            HStack(spacing: 0) {
                stepButton(systemName: "minus", action: decrement, isEnabled: canDecrement)

                Text("\(value)")
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                    .frame(minWidth: 40)
                    .monospacedDigit()

                stepButton(systemName: "plus", action: increment, isEnabled: canIncrement)
            }
            .background(LubaColors.surface)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(LubaColors.border, lineWidth: 1)
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Stepper")
        .accessibilityValue("\(value)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: increment()
            case .decrement: decrement()
            @unknown default: break
            }
        }
    }

    // MARK: - Subviews

    private func stepButton(systemName: String, action: @escaping () -> Void, isEnabled: Bool) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(isEnabled ? LubaColors.accent : LubaColors.textDisabled)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    // MARK: - Logic

    private var canIncrement: Bool { value + step <= range.upperBound }
    private var canDecrement: Bool { value - step >= range.lowerBound }

    private func increment() {
        let newValue = min(value + step, range.upperBound)
        guard newValue != value else { return }
        value = newValue
        if config.hapticsEnabled { LubaHaptics.light() }
    }

    private func decrement() {
        let newValue = max(value - step, range.lowerBound)
        guard newValue != value else { return }
        value = newValue
        if config.hapticsEnabled { LubaHaptics.light() }
    }
}

// MARK: - Preview

#Preview("Stepper") {
    VStack(spacing: 24) {
        LubaStepper(value: .constant(3), in: 1...10, label: "Quantity")
        LubaStepper(value: .constant(0), in: 0...100, step: 5, label: "Volume")
        LubaStepper(value: .constant(1))
    }
    .padding(20)
    .background(LubaColors.background)
}
