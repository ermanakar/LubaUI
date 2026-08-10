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
    @LubaEnvironment private var luba
    @Binding private var isChecked: Bool
    private let label: String?
    private let isDisabled: Bool


    /// Creates a checkbox.
    ///
    /// - Parameters:
    ///   - isChecked: Binding to the checked state.
    ///   - label: Optional text displayed next to the checkbox.
    ///   - isDisabled: When `true`, the checkbox is non-interactive.
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
        .animation(luba.motion.animation(LubaMotion.micro), value: isChecked)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? LubaStrings.checkbox)
        .accessibilityValue(isChecked ? LubaStrings.checked : LubaStrings.unchecked)
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Subviews

    private var checkboxControl: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: LubaSelectionTokens.checkboxRadius, style: .continuous)
                .fill(isChecked ? luba.colors.accent : luba.colors.surface)
                .frame(width: LubaSelectionTokens.controlSize, height: LubaSelectionTokens.controlSize)

            // Border
            RoundedRectangle(cornerRadius: LubaSelectionTokens.checkboxRadius, style: .continuous)
                .strokeBorder(
                    isChecked ? luba.colors.accent : luba.colors.borderStrong,
                    lineWidth: LubaSelectionTokens.borderWidth
                )
                .frame(width: LubaSelectionTokens.controlSize, height: LubaSelectionTokens.controlSize)

            // Checkmark
            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: LubaSelectionTokens.checkmarkSize, weight: .bold))
                    .foregroundStyle(checkmarkColor)
                    .transition(luba.motion.transition(.scale.combined(with: .opacity)))
            }
        }
    }

    @ViewBuilder
    private var labelView: some View {
        if let label = label {
            Text(label)
                .font(luba.fonts.bodySmall)
                .foregroundStyle(luba.colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Computed

    private var checkmarkColor: Color {
        luba.colors.textOnAccent
    }

    // MARK: - Actions

    private func toggle() {
        if luba.hapticsEnabled {
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
