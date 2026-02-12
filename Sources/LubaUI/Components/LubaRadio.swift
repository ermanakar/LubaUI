//
//  LubaRadio.swift
//  LubaUI
//
//  A refined radio button group with haptic feedback.
//
//  Architecture:
//  - Uses LubaSelectionTokens for sizing
//  - Uses LubaMotion for animations
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - LubaRadio (Convenience Alias)

/// Convenience alias for `LubaRadioButton`.
/// Usage: `LubaRadio(label: "Option A", isSelected: isSelected) { select() }`
public typealias LubaRadio = LubaRadioButton

// MARK: - LubaRadioGroup

/// A group of radio buttons for single selection.
///
/// Usage:
/// ```swift
/// LubaRadioGroup(
///     selection: $shippingMethod,
///     options: [
///         (value: "standard", label: "Standard Shipping"),
///         (value: "express", label: "Express Shipping")
///     ]
/// )
/// ```
public struct LubaRadioGroup<T: Hashable>: View {
    @Binding private var selection: T
    private let options: [(value: T, label: String)]
    private let isDisabled: Bool

    @Environment(\.lubaConfig) private var config

    public init(
        selection: Binding<T>,
        options: [(value: T, label: String)],
        isDisabled: Bool = false
    ) {
        self._selection = selection
        self.options = options
        self.isDisabled = isDisabled
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(options, id: \.value) { option in
                LubaRadioButton(
                    label: option.label,
                    isSelected: selection == option.value,
                    isDisabled: isDisabled
                ) {
                    selection = option.value
                }
            }
        }
    }
}

// MARK: - LubaRadioButton

/// A single radio button (typically used within LubaRadioGroup).
public struct LubaRadioButton: View {
    private let label: String
    private let isSelected: Bool
    private let isDisabled: Bool
    private let action: () -> Void

    @Environment(\.lubaConfig) private var config

    public init(
        label: String,
        isSelected: Bool,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.isSelected = isSelected
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: performAction) {
            HStack(spacing: LubaSelectionTokens.labelSpacing) {
                radioControl
                labelView
                Spacer(minLength: 0)
            }
            .frame(minHeight: LubaSelectionTokens.minTouchTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? LubaMotion.disabledOpacity : 1)
        .animation(LubaMotion.micro, value: isSelected)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Subviews

    private var radioControl: some View {
        ZStack {
            // Outer circle
            Circle()
                .strokeBorder(
                    isSelected ? LubaColors.accent : LubaColors.gray400,
                    lineWidth: LubaSelectionTokens.borderWidth
                )
                .frame(width: LubaSelectionTokens.controlSize, height: LubaSelectionTokens.controlSize)

            // Inner dot
            if isSelected {
                Circle()
                    .fill(LubaColors.accent)
                    .frame(width: LubaSelectionTokens.indicatorSize, height: LubaSelectionTokens.indicatorSize)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private var labelView: some View {
        Text(label)
            .font(.system(size: LubaSelectionTokens.labelFontSize, design: .rounded))
            .foregroundStyle(LubaColors.textPrimary)
    }

    // MARK: - Actions

    private func performAction() {
        guard !isSelected else { return }

        if config.hapticsEnabled {
            LubaHaptics.selection()
        }
        action()
    }
}

// MARK: - Preview

#Preview("Radio Group") {
    struct PreviewWrapper: View {
        @State private var selection = "option1"

        var body: some View {
            LubaRadioGroup(
                selection: $selection,
                options: [
                    (value: "option1", label: "Standard Shipping"),
                    (value: "option2", label: "Express Shipping"),
                    (value: "option3", label: "Overnight Shipping")
                ]
            )
            .padding(20)
            .background(LubaColors.background)
        }
    }

    return PreviewWrapper()
}
