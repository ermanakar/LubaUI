//
//  ToastScreen.swift
//  LubaUIShowcase
//
//  Toast notifications showcase with styles, actions, and real-world examples.
//

import SwiftUI
import LubaUI

struct ToastScreen: View {
    @State private var showInfoToast = false
    @State private var showSuccessToast = false
    @State private var showWarningToast = false
    @State private var showErrorToast = false
    @State private var formSubmitted = false
    @State private var isSubmitting = false

    var body: some View {
        ShowcaseScreen("Toast") {
            // Header
            ShowcaseHeader(
                title: "Toast",
                description: "Temporary notification messages with semantic styles, actions, and auto-dismiss."
            )

            // Static Styles
            DemoSection(title: "Styles") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        LubaToast("This is an informational message", style: .info)
                            .padding(LubaSpacing.md)
                        LubaDivider()
                        LubaToast("Operation completed successfully!", style: .success)
                            .padding(LubaSpacing.md)
                        LubaDivider()
                        LubaToast("Please check your input", style: .warning)
                            .padding(LubaSpacing.md)
                        LubaDivider()
                        LubaToast("Something went wrong", style: .error)
                            .padding(LubaSpacing.md)
                    }
                }
            }

            // With Action
            DemoSection(title: "With Action") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaToast(
                            "Failed to save changes",
                            style: .error,
                            action: { },
                            actionLabel: "Retry"
                        )

                        LubaToast(
                            "New version available",
                            style: .info,
                            action: { },
                            actionLabel: "Update"
                        )
                    }
                }
            }

            // Interactive
            DemoSection(title: "Try It") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            LubaButton("Info", style: .secondary, size: .small) {
                                showInfoToast = true
                            }
                            LubaButton("Success", style: .secondary, size: .small) {
                                showSuccessToast = true
                            }
                        }
                        HStack(spacing: LubaSpacing.sm) {
                            LubaButton("Warning", style: .secondary, size: .small) {
                                showWarningToast = true
                            }
                            LubaButton("Error", style: .secondary, size: .small) {
                                showErrorToast = true
                            }
                        }

                        Text("Tap a button to trigger a toast notification")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Real-World: Form Submission
            DemoSection(title: "Form Submission Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaCircledIcon("envelope.fill", size: .md, style: .subtle)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Newsletter Signup")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Get weekly updates")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()
                        }

                        LubaButton(
                            isSubmitting ? "Subscribing..." : "Subscribe",
                            style: .primary,
                            isLoading: isSubmitting,
                            fullWidth: true
                        ) {
                            submitForm()
                        }
                    }
                }
            }

            // Real-World: Action Feedback
            DemoSection(title: "Action Feedback Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Draft Post", size: .medium)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("My Draft Post")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Last edited 2 hours ago")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()
                        }

                        HStack(spacing: LubaSpacing.sm) {
                            LubaButton("Delete", style: .destructive, size: .small) {
                                showErrorToast = true
                            }

                            Spacer()

                            LubaButton("Save Draft", style: .secondary, size: .small) {
                                showInfoToast = true
                            }

                            LubaButton("Publish", style: .primary, size: .small) {
                                showSuccessToast = true
                            }
                        }
                    }
                }
            }

            // Usage Code
            DemoSection(title: "Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("// View modifier")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text(".lubaToast(")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    isPresented: $show,")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    message: \"Saved!\",")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    style: .success")
                            .foregroundStyle(LubaColors.accent)
                        Text(")")
                            .foregroundStyle(LubaColors.textPrimary)
                    }
                    .font(.system(size: 13, design: .monospaced))
                }
            }
        }
        .lubaToast(isPresented: $showInfoToast, message: "Here's some information", style: .info)
        .lubaToast(isPresented: $showSuccessToast, message: "Saved successfully!", style: .success)
        .lubaToast(isPresented: $showWarningToast, message: "Check your connection", style: .warning)
        .lubaToast(isPresented: $showErrorToast, message: "Something went wrong", style: .error)
        .lubaToast(isPresented: $formSubmitted, message: "You're subscribed!", style: .success)
    }

    // MARK: - Actions

    private func submitForm() {
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            formSubmitted = true
        }
    }

}

#Preview {
    NavigationStack {
        ToastScreen()
    }
}
