//
//  LubaCheckbox.swift
//  LubaUI
//
//  A refined checkbox with haptic feedback.
//
//  Architecture:
//  - Uses LubaSelectionTokens for sizing
//  - Uses LubaMotion for animations
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - LubaCheckbox

/// A refined checkbox with optional label.
///
/// Usage:
/// ```swift
/// LubaCheckbox(isChecked: $agreedToTerms, label: "I agree to the terms")
/// ```
public struct LubaCheckbox: View {
    @Binding private var isChecked: Bool
    private let label: String?
    private let isDisabled: Bool

    @Environment(\.lubaConfig) private var config

    public init(
        isChecked: Binding<Bool>,
        label: String? = nil,
        isDisabled: Bool = false
    ) {
        self._isChecked = isChecked
        self.label = label
        self.isDisabled = isDisabled
    }

    public var body: some View {
        Button(action: toggle) {
            HStack(spacing: LubaSelectionTokens.labelSpacing) {
                checkboxControl
                labelView
                Spacer(minLength: 0)
            }
            .frame(minHeight: LubaSelectionTokens.minTouchTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? LubaMotion.disabledOpacity : 1)
        .animation(LubaMotion.micro, value: isChecked)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Checkbox")
        .accessibilityValue(isChecked ? "Checked" : "Unchecked")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Subviews

    private var checkboxControl: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: LubaSelectionTokens.checkboxRadius, style: .continuous)
                .fill(isChecked ? LubaColors.accent : LubaColors.surface)
                .frame(width: LubaSelectionTokens.controlSize, height: LubaSelectionTokens.controlSize)

            // Border
            RoundedRectangle(cornerRadius: LubaSelectionTokens.checkboxRadius, style: .continuous)
                .strokeBorder(
                    isChecked ? LubaColors.accent : LubaColors.gray400,
                    lineWidth: LubaSelectionTokens.borderWidth
                )
                .frame(width: LubaSelectionTokens.controlSize, height: LubaSelectionTokens.controlSize)

            // Checkmark
            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: LubaSelectionTokens.checkmarkSize, weight: .bold))
                    .foregroundStyle(checkmarkColor)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    @ViewBuilder
    private var labelView: some View {
        if let label = label {
            Text(label)
                .font(LubaTypography.custom(size: LubaSelectionTokens.labelFontSize, weight: .regular))
                .foregroundStyle(LubaColors.textPrimary)
        }
    }

    // MARK: - Computed

    private var checkmarkColor: Color {
        LubaColors.textOnAccent
    }

    // MARK: - Actions

    private func toggle() {
        if config.hapticsEnabled {
            LubaHaptics.light()
        }
        isChecked.toggle()
    }
}

// MARK: - Preview

#Preview("Checkbox") {
    VStack(alignment: .leading, spacing: 0) {
        LubaCheckbox(isChecked: .constant(false), label: "Unchecked option")
        LubaCheckbox(isChecked: .constant(true), label: "Checked option")
        LubaCheckbox(isChecked: .constant(false), label: "Another option here")
        LubaCheckbox(isChecked: .constant(true), label: "Disabled checked", isDisabled: true)
    }
    .padding(20)
    .background(LubaColors.background)
}
