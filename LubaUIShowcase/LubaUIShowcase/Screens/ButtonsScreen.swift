//
//  ButtonsScreen.swift
//  LubaUIShowcase
//
//  Buttons showcase with all styles, sizes, states, and real-world examples.
//

import SwiftUI
import LubaUI

struct ButtonsScreen: View {
    @State private var isLoading = false
    @State private var isSaving = false

    var body: some View {
        ShowcaseScreen("Buttons") {
            ShowcaseHeader(
                title: "Buttons",
                description: "Refined buttons with subtle press animations (0.97 scale), haptic feedback, and multiple variants."
            )

            // Styles
            DemoSection(title: "Styles") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaButton("Primary", style: .primary) { }

                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Secondary", style: .secondary) { }
                            LubaButton("Ghost", style: .ghost) { }
                        }

                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Subtle", style: .subtle) { }
                            LubaButton("Destructive", style: .destructive) { }
                        }
                    }
                }
            }

            // Sizes
            DemoSection(title: "Sizes") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.md) {
                            VStack(spacing: LubaSpacing.xs) {
                                LubaButton("Small", size: .small) { }
                                Text("32pt")
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundStyle(LubaColors.textTertiary)
                            }

                            VStack(spacing: LubaSpacing.xs) {
                                LubaButton("Medium", size: .medium) { }
                                Text("44pt")
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }

                        VStack(spacing: LubaSpacing.xs) {
                            LubaButton("Large", size: .large) { }
                            Text("52pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                }
            }

            // With Icons
            DemoSection(title: "With Icons") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Continue", icon: Image(systemName: "arrow.right"), iconPosition: .trailing) { }
                            LubaButton("Add", style: .secondary, icon: Image(systemName: "plus")) { }
                        }

                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Download", style: .ghost, icon: Image(systemName: "arrow.down.circle")) { }
                            LubaButton("Delete", style: .destructive, size: .small, icon: Image(systemName: "trash")) { }
                        }
                    }
                }
            }

            // States
            DemoSection(title: "States") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Disabled", isDisabled: true) { }

                            LubaButton(
                                isLoading ? "Loading..." : "Tap to Load",
                                isLoading: isLoading
                            ) {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isLoading = false
                                }
                            }
                        }

                        Text("Tap the button to see loading state")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Full Width
            DemoSection(title: "Full Width") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaButton("Full Width Primary", style: .primary, fullWidth: true) { }
                        LubaButton("Full Width Secondary", style: .secondary, fullWidth: true) { }
                    }
                }
            }

            // Real-World: Login Form
            DemoSection(title: "Login Form Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaButton("Sign in with Apple", style: .primary, icon: Image(systemName: "apple.logo"), fullWidth: true) { }

                        LubaButton("Continue with Google", style: .secondary, icon: Image(systemName: "g.circle.fill"), fullWidth: true) { }

                        LubaDivider(label: "or")

                        LubaButton("Sign in with Email", style: .ghost, fullWidth: true) { }
                    }
                }
            }

            // Real-World: Action Bar
            DemoSection(title: "Action Bar Example") {
                LubaCard(elevation: .low) {
                    HStack(spacing: LubaSpacing.md) {
                        LubaButton("Cancel", style: .ghost) { }
                        Spacer()
                        LubaButton("Save Draft", style: .secondary) { }
                        LubaButton(
                            isSaving ? "Saving..." : "Publish",
                            style: .primary,
                            isLoading: isSaving
                        ) {
                            isSaving = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isSaving = false
                            }
                        }
                    }
                }
            }

            // Real-World: Destructive Action
            DemoSection(title: "Destructive Action Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaCircledIcon("exclamationmark.triangle.fill", size: .md, style: .subtle)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Delete Account")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("This action cannot be undone.")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()
                        }

                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Cancel", style: .secondary) { }
                            LubaButton("Delete", style: .destructive, icon: Image(systemName: "trash")) { }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        ButtonsScreen()
    }
}
