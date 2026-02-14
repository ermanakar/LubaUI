//
//  GettingStartedScreen.swift
//  LubaUIShowcase
//
//  Welcome screen with quick-start guide and philosophy overview.
//

import SwiftUI
import LubaUI

struct GettingStartedScreen: View {
    var body: some View {
        ShowcaseScreen("Getting Started") {
            ShowcaseHeader(
                title: "Getting Started",
                description: "Everything you need to start building with LubaUI in under five minutes."
            )

            // Installation
            DemoSection(title: "Installation") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Label("Swift Package Manager", systemImage: "shippingbox")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)

                        Text("Add LubaUI to your project via Xcode:")
                            .font(LubaTypography.bodySmall)
                            .foregroundStyle(LubaColors.textSecondary)

                        VStack(spacing: LubaSpacing.sm) {
                            stepRow(number: 1, text: "File > Add Package Dependencies")
                            stepRow(number: 2, text: "Enter the repository URL")
                            stepRow(number: 3, text: "Select \"Up to Next Major Version\"")
                        }
                    }
                }
            }

            // Quick Start
            DemoSection(title: "Quick Start") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "import LubaUI")
                    CopyableCode(code: "LubaButton(\"Save\") { }")
                    CopyableCode(code: "LubaCard { Text(\"Hello\") }")
                    CopyableCode(code: "LubaTextField(\"Name\", text: $name)")
                }
            }

            // Primitives
            DemoSection(title: "Composable Primitives") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("Behaviors you can attach to any view:")
                            .font(LubaTypography.bodySmall)
                            .foregroundStyle(LubaColors.textSecondary)

                        VStack(spacing: LubaSpacing.sm) {
                            CopyableCode(code: ".lubaPressable { action() }")
                            CopyableCode(code: ".lubaLongPressable { action() }")
                            CopyableCode(code: ".lubaShimmerable(isLoading: isLoading)")
                            CopyableCode(code: ".lubaSwipeable(actions: [.delete])")
                        }
                    }
                }
            }

            // Token System
            DemoSection(title: "Design Tokens") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("Every value has a token — no magic numbers:")
                            .font(LubaTypography.bodySmall)
                            .foregroundStyle(LubaColors.textSecondary)

                        VStack(spacing: LubaSpacing.sm) {
                            tokenRow(category: "Colors", example: "LubaColors.textPrimary")
                            tokenRow(category: "Spacing", example: "LubaSpacing.md (12pt)")
                            tokenRow(category: "Typography", example: "LubaTypography.body")
                            tokenRow(category: "Radius", example: "LubaRadius.md (12pt)")
                            tokenRow(category: "Motion", example: "LubaMotion.pressScale (0.97)")
                        }
                    }
                }
            }

            // Configuration
            DemoSection(title: "Configuration") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: ".lubaConfig(.minimal)")
                    CopyableCode(code: ".lubaConfig(.accessible)")
                    CopyableCode(code: ".lubaConfig(.debug)")
                }

                Text("Apply a preset or customize haptics, animations, and accessibility at any level of the view hierarchy.")
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textTertiary)
            }

            // Live Demo
            DemoSection(title: "Live Demo") {
                liveDemoCard
            }

            // Philosophy
            PhilosophyCard(
                icon: "leaf",
                title: "The Current, Not The Cage",
                description: "LubaUI is built to liberate, not control. Every component is a primitive designed to be nested, stretched, and combined. The obvious thing is the right thing."
            )
        }
    }

    // MARK: - Subviews

    private func stepRow(number: Int, text: String) -> some View {
        HStack(spacing: LubaSpacing.sm) {
            Text("\(number)")
                .font(LubaTypography.caption2)
                .foregroundStyle(LubaColors.textOnAccent)
                .frame(width: 20, height: 20)
                .background(LubaColors.accent)
                .clipShape(Circle())

            Text(text)
                .font(LubaTypography.bodySmall)
                .foregroundStyle(LubaColors.textPrimary)
        }
    }

    private func tokenRow(category: String, example: String) -> some View {
        HStack {
            Text(category)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)
                .frame(width: 80, alignment: .leading)

            Text(example)
                .font(LubaTypography.code)
                .foregroundStyle(LubaColors.accent)
                .lineLimit(1)
        }
    }

    private var liveDemoCard: some View {
        LubaCard(elevation: .low) {
            VStack(spacing: LubaSpacing.lg) {
                HStack(spacing: LubaSpacing.md) {
                    LubaAvatar(name: "LubaUI", size: .medium)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("LubaUI")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("The design system that feels alive")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                    }

                    Spacer()

                    LubaBadge("v1.0", style: .accent)
                }

                LubaDivider()

                HStack(spacing: LubaSpacing.sm) {
                    LubaButton("Explore", style: .primary, size: .small) { }
                    LubaButton("Docs", style: .secondary, size: .small) { }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GettingStartedScreen()
    }
}
