//
//  AlertScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaAlert inline notification banners.
//

import SwiftUI
import LubaUI

struct AlertScreen: View {
    @State private var showDismissible = true
    @State private var showFormError = false
    @State private var email = ""

    var body: some View {
        ShowcaseScreen("Alert") {
            ShowcaseHeader(
                title: "Alert",
                description: "Inline notification banners that live in the layout flow — for validation, warnings, and contextual messages."
            )

            // Styles
            DemoSection(title: "Styles") {
                VStack(spacing: LubaSpacing.sm) {
                    LubaAlert("This is an informational message.", style: .info)
                    LubaAlert("Your changes have been saved.", style: .success)
                    LubaAlert("Your trial expires in 3 days.", style: .warning)
                    LubaAlert("Unable to connect to server.", style: .error)
                }
            }

            // With Title
            DemoSection(title: "With Title") {
                VStack(spacing: LubaSpacing.sm) {
                    LubaAlert("Please verify your email address to continue.", style: .info, title: "Action Required")
                    LubaAlert("All systems are operational.", style: .success, title: "System Status")
                }
            }

            // Dismissible
            DemoSection(title: "Dismissible") {
                VStack(spacing: LubaSpacing.sm) {
                    if showDismissible {
                        LubaAlert(
                            "This alert can be dismissed.",
                            style: .warning,
                            title: "Heads Up",
                            isDismissible: true
                        ) {
                            withAnimation(LubaAnimations.standard) {
                                showDismissible = false
                            }
                        }
                    }

                    if !showDismissible {
                        LubaButton("Show Again", style: .secondary) {
                            withAnimation(LubaAnimations.standard) {
                                showDismissible = true
                            }
                        }
                    }
                }
            }

            // Form Validation
            DemoSection(title: "Form Validation") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaTextField(
                            "Email",
                            text: $email,
                            placeholder: "you@example.com",
                            leadingIcon: Image(systemName: "envelope")
                        )

                        if showFormError {
                            LubaAlert("Please enter a valid email address.", style: .error)
                        }

                        LubaButton("Submit", style: .primary, fullWidth: true) {
                            withAnimation(LubaAnimations.standard) {
                                showFormError = !email.contains("@")
                            }
                        }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaAlert(\"Message\", style: .info)")
                    CopyableCode(code: "LubaAlert(\"Error\", style: .error, title: \"Oops\")")
                    CopyableCode(code: "LubaAlert(\"...\", isDismissible: true) { }")
                }
            }

            PhilosophyCard(
                icon: "bell",
                title: "Inline, Not Intrusive",
                description: "Alerts live in the flow of content — they inform without interrupting. Use Toast for transient notifications, Alert for persistent contextual messages."
            )
        }
    }
}

#Preview {
    NavigationStack {
        AlertScreen()
    }
}
