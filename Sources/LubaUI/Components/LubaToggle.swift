//
//  LubaToggle.swift
//  LubaUI
//
//  A refined toggle switch with haptic feedback.
//
//  Architecture:
//  - Uses LubaToggleTokens for sizing
//  - Uses LubaMotion for animations
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - LubaToggle

/// A refined toggle switch with optional label.
///
/// Usage:
/// ```swift
/// LubaToggle(isOn: $darkMode, label: "Dark Mode")
/// ```
public struct LubaToggle: View {
    @Binding private var isOn: Bool
    private let label: String?
    private let isDisabled: Bool

    @Environment(\.lubaConfig) private var config

    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        isDisabled: Bool = false
    ) {
        self._isOn = isOn
        self.label = label
        self.isDisabled = isDisabled
    }

    public var body: some View {
        Button(action: toggle) {
            HStack(spacing: LubaToggleTokens.labelSpacing) {
                labelView
                toggleTrack
            }
            .frame(minHeight: LubaToggleTokens.minTouchTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? LubaMotion.disabledOpacity : 1)
        .animation(LubaMotion.micro, value: isOn)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Toggle")
        .accessibilityValue(isOn ? "On" : "Off")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var labelView: some View {
        if let label = label {
            Text(label)
                .font(.system(size: LubaToggleTokens.labelFontSize, design: .rounded))
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()
        }
    }

    private var toggleTrack: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            // Track
            Capsule()
                .fill(isOn ? LubaColors.accent : LubaColors.gray200)
                .frame(width: LubaToggleTokens.trackWidth, height: LubaToggleTokens.trackHeight)

            // Thumb
            Circle()
                .fill(Color.white)
                .frame(width: LubaToggleTokens.thumbSize, height: LubaToggleTokens.thumbSize)
                .shadow(
                    color: Color.black.opacity(LubaToggleTokens.thumbShadowOpacity),
                    radius: LubaToggleTokens.thumbShadowRadius,
                    y: 1
                )
                .padding(.horizontal, LubaToggleTokens.thumbPadding)
        }
    }

    // MARK: - Actions

    private func toggle() {
        if config.hapticsEnabled {
            LubaHaptics.light()
        }
        isOn.toggle()
    }
}

// MARK: - Preview

#Preview("Toggle") {
    VStack(spacing: 0) {
        LubaToggle(isOn: .constant(false), label: "Dark Mode")
        LubaToggle(isOn: .constant(true), label: "Notifications")
        LubaToggle(isOn: .constant(false), label: "Auto-save")
        LubaToggle(isOn: .constant(true), label: "Disabled", isDisabled: true)
    }
    .padding(20)
    .background(LubaColors.background)
}
