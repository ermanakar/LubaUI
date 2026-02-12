//
//  DividerScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaDivider for visual separation.
//

import SwiftUI
import LubaUI

struct DividerScreen: View {
    var body: some View {
        ShowcaseScreen("Divider") {
            ShowcaseHeader(
                title: "Divider",
                description: "A refined divider for visual separation with optional labels."
            )

            // Basic Divider
            DemoSection(title: "Basic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        Text("Content above")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        LubaDivider()

                        Text("Content below")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                }
            }

            // Labeled Divider
            DemoSection(title: "With Label") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaDivider(label: "or")

                        LubaDivider(label: "or continue with")

                        LubaDivider(label: "Section")
                    }
                }
            }

            // Vertical Divider
            DemoSection(title: "Vertical") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.lg) {
                        Text("Left")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaDivider(orientation: .vertical)
                            .frame(height: 24)

                        Text("Center")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaDivider(orientation: .vertical)
                            .frame(height: 24)

                        Text("Right")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Real-World Example
            DemoSection(title: "Login Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaButton("Sign in with Email", style: .primary) { }

                        LubaDivider(label: "or continue with")

                        HStack(spacing: LubaSpacing.md) {
                            socialButton(icon: "apple.logo", label: "Apple")
                            socialButton(icon: "g.circle.fill", label: "Google")
                        }
                    }
                }
            }

            // List Example
            DemoSection(title: "List Separation") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: 0) {
                        listRow(icon: "person.fill", title: "Profile")
                        LubaDivider()
                        listRow(icon: "bell.fill", title: "Notifications")
                        LubaDivider()
                        listRow(icon: "gearshape.fill", title: "Settings")
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func socialButton(icon: String, label: String) -> some View {
        LubaButton(label, style: .secondary, icon: Image(systemName: icon)) { }
    }

    private func listRow(icon: String, title: String) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

}

#Preview {
    NavigationStack {
        DividerScreen()
    }
}
