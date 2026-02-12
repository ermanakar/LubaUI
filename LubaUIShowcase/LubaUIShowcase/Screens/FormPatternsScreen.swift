//
//  FormPatternsScreen.swift
//  LubaUIShowcase
//
//  Composed form patterns with validation, progressive disclosure, and multi-step flows.
//

import SwiftUI
import LubaUI

struct FormPatternsScreen: View {
    // Signup form
    @State private var signupName = ""
    @State private var signupEmail = ""
    @State private var signupPassword = ""
    @State private var agreedToTerms = false
    @State private var signupSubmitted = false

    // Settings form
    @State private var notificationsOn = true
    @State private var darkMode = false
    @State private var fontSize: Double = 16
    @State private var language = "en"

    // Payment form
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvc = ""
    @State private var saveCard = true

    var body: some View {
        ShowcaseScreen("Form Patterns") {
            ShowcaseHeader(
                title: "Form Patterns",
                description: "Composed form layouts with real-time validation, grouped settings, and payment flows."
            )

            // Signup
            DemoSection(title: "Signup Form") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(spacing: LubaSpacing.xs) {
                            Text("Create Account")
                                .font(LubaTypography.title3)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("Start your free trial today")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)

                        LubaTextField(
                            "Full Name",
                            text: $signupName,
                            placeholder: "Jane Doe",
                            leadingIcon: Image(systemName: "person")
                        )

                        LubaTextField(
                            "Email",
                            text: $signupEmail,
                            placeholder: "you@example.com",
                            error: signupSubmitted && !signupEmail.contains("@") ? "Enter a valid email" : nil,
                            leadingIcon: Image(systemName: "envelope")
                        )

                        LubaTextField(
                            "Password",
                            text: $signupPassword,
                            placeholder: "8+ characters",
                            error: signupSubmitted && signupPassword.count < 8 ? "Password must be 8+ characters" : nil,
                            leadingIcon: Image(systemName: "lock"),
                            isSecure: true
                        )

                        if !signupPassword.isEmpty {
                            passwordStrength
                        }

                        LubaCheckbox(isChecked: $agreedToTerms, label: "I agree to the Terms of Service")

                        LubaButton("Create Account", style: .primary, isDisabled: !agreedToTerms, fullWidth: true) {
                            signupSubmitted = true
                        }

                        LubaDivider(label: "or continue with")

                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Google", style: .secondary, icon: Image(systemName: "globe"), fullWidth: true) { }
                            LubaButton("Apple", style: .secondary, icon: Image(systemName: "apple.logo"), fullWidth: true) { }
                        }
                    }
                }
            }

            // Settings
            DemoSection(title: "Settings Form") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        settingGroup(title: "Preferences") {
                            LubaToggle(isOn: $notificationsOn, label: "Push Notifications")
                            LubaDivider()
                            LubaToggle(isOn: $darkMode, label: "Dark Mode")
                        }

                        Spacer().frame(height: LubaSpacing.lg)

                        settingGroup(title: "Display") {
                            LubaSlider(value: $fontSize, in: 12...24, step: 1, label: "Font Size", showValue: true)
                        }

                        Spacer().frame(height: LubaSpacing.lg)

                        settingGroup(title: "Language") {
                            LubaRadioGroup(
                                selection: $language,
                                options: [
                                    (value: "en", label: "English"),
                                    (value: "de", label: "Deutsch"),
                                    (value: "es", label: "Espanol")
                                ]
                            )
                        }
                    }
                }
            }

            // Payment
            DemoSection(title: "Payment Form") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack {
                            Text("Payment Details")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Spacer()
                            HStack(spacing: LubaSpacing.xs) {
                                Image(systemName: "creditcard.fill")
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }

                        LubaTextField(
                            "Card Number",
                            text: $cardNumber,
                            placeholder: "4242 4242 4242 4242",
                            leadingIcon: Image(systemName: "creditcard")
                        )

                        HStack(spacing: LubaSpacing.md) {
                            LubaTextField(
                                "Expiry",
                                text: $expiry,
                                placeholder: "MM/YY"
                            )

                            LubaTextField(
                                "CVC",
                                text: $cvc,
                                placeholder: "123",
                                leadingIcon: Image(systemName: "lock.fill")
                            )
                        }

                        LubaCheckbox(isChecked: $saveCard, label: "Save card for future purchases")

                        LubaDivider()

                        HStack {
                            Text("Total")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                            Spacer()
                            Text("$29.00")
                                .font(LubaTypography.title3)
                                .foregroundStyle(LubaColors.textPrimary)
                        }

                        LubaButton("Pay $29.00", style: .primary, icon: Image(systemName: "lock.fill"), fullWidth: true) { }
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "checklist",
                title: "Forms That Guide",
                description: "Good forms validate inline, group related fields, and use progressive disclosure. Every interaction should feel effortless — from the first tap to the final submit."
            )
        }
    }

    // MARK: - Components

    private var passwordStrength: some View {
        let strength: (text: String, color: Color, value: Double) = {
            let len = signupPassword.count
            if len < 6 { return ("Weak", LubaColors.error, 0.25) }
            if len < 10 { return ("Fair", LubaColors.warning, 0.5) }
            if len < 14 { return ("Good", LubaColors.accent, 0.75) }
            return ("Strong", LubaColors.success, 1.0)
        }()

        return VStack(alignment: .leading, spacing: LubaSpacing.xs) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(LubaColors.gray200)
                    Capsule()
                        .fill(strength.color)
                        .frame(width: geo.size.width * strength.value)
                        .animation(LubaAnimations.smooth, value: signupPassword.count)
                }
            }
            .frame(height: 4)

            Text(strength.text)
                .font(LubaTypography.caption)
                .foregroundStyle(strength.color)
        }
    }

    private func settingGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
            Text(title)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            VStack(spacing: 0) {
                content()
            }
            .padding(LubaSpacing.md)
            .background(LubaColors.surface)
            .clipShape(RoundedRectangle.luba(LubaRadius.md))
            .overlay(
                RoundedRectangle.luba(LubaRadius.md)
                    .strokeBorder(LubaColors.border, lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        FormPatternsScreen()
    }
}
