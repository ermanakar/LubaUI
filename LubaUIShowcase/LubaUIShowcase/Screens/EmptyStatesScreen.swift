//
//  EmptyStatesScreen.swift
//  LubaUIShowcase
//
//  Composed empty state patterns using LubaUI components.
//

import SwiftUI
import LubaUI

struct EmptyStatesScreen: View {
    var body: some View {
        ShowcaseScreen("Empty States") {
            ShowcaseHeader(
                title: "Empty States",
                description: "Composed patterns for when there's nothing to show — keep users informed and give them a next step."
            )

            // Simple
            DemoSection(title: "Simple") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundStyle(LubaColors.textTertiary)

                        VStack(spacing: LubaSpacing.xs) {
                            Text("No items yet")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Items you add will appear here.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LubaSpacing.xl)
                }
            }

            // With Action
            DemoSection(title: "With Action") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaCircledIcon("magnifyingglass", size: .xl, style: .subtle)

                        VStack(spacing: LubaSpacing.xs) {
                            Text("No results found")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Try adjusting your search or filters to find what you're looking for.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }

                        LubaButton("Clear Filters", style: .secondary) { }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LubaSpacing.lg)
                }
            }

            // Onboarding
            DemoSection(title: "Onboarding") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        ZStack {
                            Circle()
                                .fill(LubaColors.accentSubtle)
                                .frame(width: 80, height: 80)
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 32))
                                .foregroundStyle(LubaColors.accent)
                        }

                        VStack(spacing: LubaSpacing.xs) {
                            Text("Welcome to Your Workspace")
                                .font(LubaTypography.title3)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Create your first project to get started. We'll guide you through the setup.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaButton("Create Project", style: .primary, icon: Image(systemName: "plus"), fullWidth: true) { }
                            LubaButton("Browse Templates", style: .ghost) { }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LubaSpacing.lg)
                }
            }

            // Error State
            DemoSection(title: "Error State") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaCircledIcon("wifi.slash", size: .xl, style: .subtle)

                        VStack(spacing: LubaSpacing.xs) {
                            Text("Connection Lost")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Check your internet connection and try again.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }

                        LubaButton("Retry", style: .primary, icon: Image(systemName: "arrow.clockwise")) { }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LubaSpacing.lg)
                }
            }

            // Permission
            DemoSection(title: "Permission Request") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaCircledIcon("camera.fill", size: .xl, style: .subtle)

                        VStack(spacing: LubaSpacing.xs) {
                            Text("Camera Access")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Allow camera access to scan QR codes and take photos for your profile.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaButton("Allow Camera", style: .primary, fullWidth: true) { }
                            LubaButton("Not Now", style: .ghost) { }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LubaSpacing.lg)
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "lightbulb",
                title: "Every State Matters",
                description: "Empty states are opportunities — to guide, educate, and delight. A thoughtful empty state turns confusion into confidence. Always provide context and a clear next action."
            )
        }
    }
}

#Preview {
    NavigationStack {
        EmptyStatesScreen()
    }
}
