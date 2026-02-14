//
//  FormControlsScreen.swift
//  LubaUIShowcase
//
//  Form controls showcase with real-world examples.
//

import SwiftUI
import LubaUI

struct FormControlsScreen: View {
    // Component demos
    @State private var notificationsOn = true
    @State private var agreeToTerms = false
    @State private var selectedPlan = 2
    @State private var volumeLevel: Double = 0.7

    // Signup form state
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var acceptTerms = false
    @State private var receiveUpdates = true
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var hasAttemptedSubmit = false

    var body: some View {
        ShowcaseScreen("Form Controls") {
            ShowcaseHeader(
                title: "Form Controls",
                description: "Interactive controls with validation, haptic feedback, and smooth animations."
            )

            // Toggle
            DemoSection(title: "Toggle") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: 0) {
                        LubaToggle(isOn: $notificationsOn, label: "Enable notifications")
                        LubaDivider()
                        LubaToggle(isOn: .constant(true), label: "Always on (disabled)")
                    }
                }
            }

            // Checkbox
            DemoSection(title: "Checkbox") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaCheckbox(isChecked: $agreeToTerms, label: "I agree to the terms and conditions")
                        LubaCheckbox(isChecked: .constant(true), label: "Selected state")
                    }
                }
            }

            // Radio
            DemoSection(title: "Radio") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaRadioGroup(
                        selection: $selectedPlan,
                        options: [
                            (value: 1, label: "Free Plan"),
                            (value: 2, label: "Pro Plan"),
                            (value: 3, label: "Enterprise")
                        ]
                    )
                }
            }

            // Slider
            DemoSection(title: "Slider") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaSlider(
                        value: $volumeLevel,
                        label: "Volume",
                        showValue: true
                    )
                }
            }

            // Real-World: Signup Form
            DemoSection(title: "Signup Form Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        // Email
                        LubaTextField(
                            "Email",
                            text: $email,
                            placeholder: "you@example.com",
                            error: emailError,
                            leadingIcon: Image(systemName: "envelope")
                        )

                        // Password
                        LubaTextField(
                            "Password",
                            text: $password,
                            placeholder: "At least 8 characters",
                            helperText: passwordHelperText,
                            error: passwordError,
                            leadingIcon: Image(systemName: "lock"),
                            isSecure: true
                        )

                        // Confirm Password
                        LubaTextField(
                            "Confirm Password",
                            text: $confirmPassword,
                            placeholder: "Re-enter password",
                            error: confirmPasswordError,
                            leadingIcon: Image(systemName: "lock"),
                            isSecure: true
                        )

                        LubaDivider()

                        // Checkboxes
                        VStack(alignment: .leading, spacing: LubaSpacing.md) {
                            LubaCheckbox(
                                isChecked: $acceptTerms,
                                label: "I accept the terms and conditions"
                            )
                            LubaCheckbox(
                                isChecked: $receiveUpdates,
                                label: "Send me product updates"
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // Submit Button
                        LubaButton(
                            isLoading ? "Creating Account..." : "Create Account",
                            isLoading: isLoading,
                            isDisabled: !isFormValid
                        ) {
                            submitForm()
                        }

                        // Validation summary
                        if hasAttemptedSubmit && !isFormValid {
                            HStack(spacing: LubaSpacing.sm) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(LubaColors.error)

                                Text("Please fix the errors above")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.error)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }

            // Real-World: Settings Panel
            DemoSection(title: "Settings Panel Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        settingsRow(icon: "bell.fill", title: "Push Notifications") {
                            LubaToggle(isOn: $notificationsOn)
                        }

                        LubaDivider()

                        settingsRow(icon: "speaker.wave.2.fill", title: "Volume") {
                            Text("\(Int(volumeLevel * 100))%")
                                .font(LubaTypography.custom(size: 13, weight: .medium, design: .monospaced))
                                .foregroundStyle(LubaColors.textSecondary)
                        }

                        LubaSlider(value: $volumeLevel)
                            .padding(.top, LubaSpacing.sm)
                            .padding(.bottom, LubaSpacing.xs)

                        LubaDivider()

                        settingsRow(icon: "checkmark.circle.fill", title: "Terms Accepted") {
                            LubaCheckbox(isChecked: $agreeToTerms)
                        }
                    }
                }
            }
        }
        .lubaToast(isPresented: $showSuccess, message: "Account created successfully!", style: .success)
    }

    // MARK: - Validation

    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }

    private var isValidPassword: Bool {
        password.count >= 8
    }

    private var passwordsMatch: Bool {
        password == confirmPassword && !password.isEmpty
    }

    private var isFormValid: Bool {
        isValidEmail && isValidPassword && passwordsMatch && acceptTerms
    }

    private var emailError: String? {
        guard !email.isEmpty else { return nil }
        return isValidEmail ? nil : "Please enter a valid email"
    }

    private var passwordError: String? {
        guard !password.isEmpty else { return nil }
        return isValidPassword ? nil : "Password must be at least 8 characters"
    }

    private var passwordHelperText: String? {
        password.isEmpty ? "Must contain at least 8 characters" : nil
    }

    private var confirmPasswordError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        return passwordsMatch ? nil : "Passwords do not match"
    }

    private func submitForm() {
        hasAttemptedSubmit = true

        guard isFormValid else { return }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            showSuccess = true

            // Reset form
            email = ""
            password = ""
            confirmPassword = ""
            acceptTerms = false
            hasAttemptedSubmit = false
        }
    }

    // MARK: - Components

    private func settingsRow<Content: View>(
        icon: String,
        title: String,
        @ViewBuilder trailing: () -> Content
    ) -> some View {
        HStack {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            trailing()
        }
        .padding(.vertical, LubaSpacing.xs)
    }

}

#Preview {
    NavigationStack {
        FormControlsScreen()
    }
}
