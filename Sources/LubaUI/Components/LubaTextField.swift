//
//  LubaTextField.swift
//  LubaUI
//
//  A refined text input — clean, minimal, premium.
//
//  Architecture:
//  - Field tokens define layout constants
//  - Uses LubaMotion for all animations
//  - Uses LubaConfig for haptic feedback
//  - State-driven styling (focused, error, disabled)
//

import SwiftUI

// MARK: - Field Tokens

/// Layout and sizing constants for text fields
public enum LubaFieldTokens {
    /// Minimum touch target height
    public static let minHeight: CGFloat = 48

    /// Corner radius (matches buttons, on the LubaRadius grid)
    public static let cornerRadius: CGFloat = LubaRadius.md

    /// Horizontal padding inside field
    public static let horizontalPadding: CGFloat = LubaSpacing.lg

    /// Spacing between icon and text
    public static let iconSpacing: CGFloat = LubaSpacing.sm

    /// Icon size
    public static let iconSize: CGFloat = 18

    /// Icon frame width (container for leading/trailing icons)
    public static let iconFrameWidth: CGFloat = 20

    /// Label font size
    public static let labelFontSize: CGFloat = 13

    /// Helper/error text font size
    public static let helperFontSize: CGFloat = 12

    /// Spacing between label and field
    public static let labelSpacing: CGFloat = 6

    /// Border width (default)
    public static let borderWidth: CGFloat = 1

    /// Border width (focused)
    public static let borderWidthFocused: CGFloat = 1.5

    /// Clear button size
    public static let clearButtonSize: CGFloat = 16
}

// MARK: - Field State

/// Visual state of a text field
public enum LubaFieldState: Equatable {
    case normal
    case focused
    case error
    case disabled

    func labelColor() -> Color {
        switch self {
        case .normal: return LubaColors.textSecondary
        case .focused: return LubaColors.accent
        case .error: return LubaColors.error
        case .disabled: return LubaColors.textDisabled
        }
    }

    func borderColor() -> Color {
        switch self {
        case .normal: return LubaColors.border
        case .focused: return LubaColors.accent
        case .error: return LubaColors.error
        case .disabled: return LubaColors.border
        }
    }

    func iconColor() -> Color {
        switch self {
        case .normal: return LubaColors.textTertiary
        case .focused: return LubaColors.accent
        case .error: return LubaColors.error
        case .disabled: return LubaColors.textDisabled
        }
    }
}

// MARK: - LubaTextField

/// A refined text field with minimalist styling.
///
/// Basic usage:
/// ```swift
/// LubaTextField("Email", text: $email, placeholder: "you@example.com")
/// ```
///
/// With icons and validation:
/// ```swift
/// LubaTextField(
///     "Password",
///     text: $password,
///     leadingIcon: Image(systemName: "lock"),
///     isSecure: true,
///     error: passwordError
/// )
/// ```
public struct LubaTextField: View {
    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let helperText: String?
    private let error: String?
    private let leadingIcon: Image?
    private let trailingIcon: Image?
    private let isSecure: Bool
    private let isDisabled: Bool
    private let showClearButton: Bool

    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.lubaConfig) private var config

    public init(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        helperText: String? = nil,
        error: String? = nil,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        showClearButton: Bool = true
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.helperText = helperText
        self.error = error
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.isSecure = isSecure
        self.isDisabled = isDisabled
        self.showClearButton = showClearButton
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: LubaFieldTokens.labelSpacing) {
            // Label
            labelView

            // Input field
            fieldView

            // Helper/Error text
            helperView
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? LubaMotion.disabledOpacity : 1)
        .animation(LubaMotion.stateAnimation, value: isDisabled)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label)
        .accessibilityValue(error != nil ? "Error: \(error!)" : helperText ?? "")
    }

    // MARK: - Subviews

    private var labelView: some View {
        Text(label)
            .font(LubaTypography.custom(size: LubaFieldTokens.labelFontSize, weight: .medium))
            .foregroundStyle(currentState.labelColor())
            .animation(LubaMotion.colorAnimation, value: currentState)
    }

    private var fieldView: some View {
        HStack(spacing: LubaFieldTokens.iconSpacing) {
            // Leading icon
            if let icon = leadingIcon {
                icon
                    .font(.system(size: LubaFieldTokens.iconSize, weight: .regular))
                    .foregroundStyle(currentState.iconColor())
                    .frame(width: LubaFieldTokens.iconFrameWidth)
            }

            // Text input
            inputField

            // Clear button
            if showClearButton && !text.isEmpty && isFocused && !isSecure {
                clearButton
            }

            // Trailing icon
            if let icon = trailingIcon {
                icon
                    .font(.system(size: LubaFieldTokens.iconSize, weight: .regular))
                    .foregroundStyle(currentState.iconColor())
                    .frame(width: LubaFieldTokens.iconFrameWidth)
            }
        }
        .padding(.horizontal, LubaFieldTokens.horizontalPadding)
        .frame(minHeight: LubaFieldTokens.minHeight)
        .background(LubaColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: LubaFieldTokens.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
        .animation(LubaMotion.colorAnimation, value: isFocused)
        .animation(LubaMotion.colorAnimation, value: error != nil)
    }

    @ViewBuilder
    private var inputField: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .font(LubaTypography.body)
        .focused($isFocused)
    }

    private var clearButton: some View {
        Button(action: clearText) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: LubaFieldTokens.clearButtonSize))
                .foregroundStyle(LubaColors.textTertiary)
        }
        .buttonStyle(.plain)
        .transition(.scale.combined(with: .opacity))
    }

    @ViewBuilder
    private var helperView: some View {
        if let error = error {
            HStack(spacing: 4) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(LubaTypography.custom(size: LubaFieldTokens.helperFontSize, weight: .regular))
                Text(error)
                    .font(LubaTypography.custom(size: LubaFieldTokens.helperFontSize, weight: .regular))
            }
            .foregroundStyle(LubaColors.error)
            .transition(.opacity.combined(with: .move(edge: .top)))
        } else if let helperText = helperText {
            Text(helperText)
                .font(LubaTypography.custom(size: LubaFieldTokens.helperFontSize, weight: .regular))
                .foregroundStyle(LubaColors.textTertiary)
        }
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: LubaFieldTokens.cornerRadius, style: .continuous)
            .strokeBorder(
                currentState.borderColor(),
                lineWidth: isFocused ? LubaFieldTokens.borderWidthFocused : LubaFieldTokens.borderWidth
            )
    }

    // MARK: - State & Actions

    private var currentState: LubaFieldState {
        if isDisabled { return .disabled }
        if error != nil { return .error }
        if isFocused { return .focused }
        return .normal
    }

    private func clearText() {
        if config.hapticsEnabled {
            LubaHaptics.light()
        }
        withAnimation(LubaMotion.micro) {
            text = ""
        }
    }
}

// MARK: - Convenience Initializers

public extension LubaTextField {
    /// Create a secure text field (password input)
    static func secure(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        error: String? = nil,
        leadingIcon: Image? = Image(systemName: "lock")
    ) -> LubaTextField {
        LubaTextField(
            label,
            text: text,
            placeholder: placeholder,
            error: error,
            leadingIcon: leadingIcon,
            isSecure: true,
            showClearButton: false
        )
    }

    /// Create an email text field
    static func email(
        _ label: String = "Email",
        text: Binding<String>,
        placeholder: String = "you@example.com",
        error: String? = nil
    ) -> LubaTextField {
        LubaTextField(
            label,
            text: text,
            placeholder: placeholder,
            error: error,
            leadingIcon: Image(systemName: "envelope")
        )
    }
}

// MARK: - Preview

#Preview("Text Fields") {
    ScrollView {
        VStack(spacing: LubaSpacing.xl) {
            LubaTextField(
                "Email",
                text: .constant(""),
                placeholder: "you@example.com",
                leadingIcon: Image(systemName: "envelope")
            )

            LubaTextField(
                "Email (Filled)",
                text: .constant("hello@example.com"),
                leadingIcon: Image(systemName: "envelope")
            )

            LubaTextField.secure(
                "Password",
                text: .constant(""),
                placeholder: "Enter password"
            )

            LubaTextField(
                "Username",
                text: .constant("taken_name"),
                error: "This username is already taken",
                leadingIcon: Image(systemName: "person")
            )

            LubaTextField(
                "Bio",
                text: .constant(""),
                placeholder: "Tell us about yourself",
                helperText: "Maximum 200 characters"
            )

            LubaTextField(
                "Disabled",
                text: .constant("Can't edit this"),
                isDisabled: true
            )
        }
        .padding(LubaSpacing.xl)
    }
    .background(LubaColors.background)
}

#Preview("Convenience Initializers") {
    VStack(spacing: LubaSpacing.xl) {
        LubaTextField.email(text: .constant(""))
        LubaTextField.secure("Password", text: .constant(""))
    }
    .padding(LubaSpacing.xl)
    .background(LubaColors.background)
}
