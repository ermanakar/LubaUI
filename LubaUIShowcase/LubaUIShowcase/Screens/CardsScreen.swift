//
//  CardsScreen.swift
//  LubaUIShowcase
//
//  Refined card showcase — demonstrating composability.
//

import SwiftUI
import LubaUI

struct CardsScreen: View {
    @State private var selectedCard: Int? = nil
    @State private var tapCount = 0

    var body: some View {
        ShowcaseScreen("Cards") {
            // Header
            ShowcaseHeader(
                title: "Cards",
                description: "Elevated containers that become tappable through composition."
            )
                
            // Elevations
            DemoSection(title: "Elevations") {
                VStack(spacing: LubaSpacing.lg) {
                    cardDemo(elevation: .flat, name: "Flat", subtitle: "No shadow")
                    cardDemo(elevation: .low, name: "Low", subtitle: "Subtle depth")
                    cardDemo(elevation: .medium, name: "Medium", subtitle: "Moderate emphasis")
                    cardDemo(elevation: .high, name: "High", subtitle: "Maximum prominence")
                }
            }
                
            // Styles
            DemoSection(title: "Styles") {
                VStack(spacing: LubaSpacing.md) {
                    LubaCard(elevation: .low, style: .filled) {
                        cardContent("Filled", "Default solid background")
                    }

                    LubaCard(elevation: .flat, style: .outlined) {
                        cardContent("Outlined", "Border, no shadow")
                    }

                    LubaCard(elevation: .flat, style: .ghost) {
                        cardContent("Ghost", "Minimal, transparent")
                    }
                }
            }

            // Composability — The Key Feature
            DemoSection(title: "Pressable Cards") {
                VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                    Text("Cards become tappable via composition:")
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)

                    VStack(spacing: LubaSpacing.md) {
                        ForEach(0..<3) { index in
                            LubaCard(
                                elevation: selectedCard == index ? .medium : .low,
                                style: .filled
                            ) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Option \(index + 1)")
                                            .font(LubaTypography.headline)
                                            .foregroundStyle(LubaColors.textPrimary)
                                        Text("Tap to select")
                                            .font(LubaTypography.caption)
                                            .foregroundStyle(LubaColors.textSecondary)
                                    }
                                    Spacer()
                                    if selectedCard == index {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(LubaColors.accent)
                                    }
                                }
                            }
                            .lubaPressable(scale: LubaMotion.pressScaleProminent) {
                                selectedCard = index
                            }
                        }
                    }
                }
            }

            // Code Example
            DemoSection(title: "Composition Pattern") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("// Make any card tappable")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("LubaCard { content }")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaPressable { action() }")
                            .foregroundStyle(LubaColors.accent)
                    }
                    .font(.system(size: 13, design: .monospaced))
                }
            }
                
            // Real-World: User Profile Card
            DemoSection(title: "User Profile Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Sarah Chen", size: .medium)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sarah Chen")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Product Designer")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()
                        }

                        Text("Creating thoughtful digital experiences with a focus on accessibility and delight.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: LubaSpacing.sm) {
                            LubaButton("Follow", style: .primary, size: .small) { }
                            LubaButton("Message", style: .secondary, size: .small) { }
                        }
                    }
                }
            }

            // Real-World: Pricing Card
            DemoSection(title: "Pricing Card Example") {
                LubaCard(elevation: .medium) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(spacing: LubaSpacing.xs) {
                            Text("Pro")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.accent)
                                .textCase(.uppercase)
                                .tracking(1)

                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("$29")
                                    .font(LubaTypography.largeTitle)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("/month")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                            featureCheck("Unlimited projects")
                            featureCheck("Priority support")
                            featureCheck("Advanced analytics")
                            featureCheck("Custom branding")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        LubaButton("Get Started", style: .primary, fullWidth: true) { }
                    }
                }
            }
        }
    }
    
    private func cardDemo(elevation: LubaCardElevation, name: String, subtitle: String) -> some View {
        LubaCard(elevation: elevation) {
            HStack {
                VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                    Text(name)
                        .font(LubaTypography.headline)
                        .foregroundStyle(LubaColors.textPrimary)
                    Text(subtitle)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                }
                Spacer()
            }
        }
    }

    private func cardContent(_ title: String, _ subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                Text(title)
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(subtitle)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }
            Spacer()
        }
    }

    private func featureCheck(_ text: String) -> some View {
        HStack(spacing: LubaSpacing.sm) {
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(LubaColors.accent)
            Text(text)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        CardsScreen()
    }
}
