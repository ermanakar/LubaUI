//
//  LinkScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaLink inline text links.
//

import SwiftUI
import LubaUI

struct LinkScreen: View {
    var body: some View {
        ShowcaseScreen("Link") {
            ShowcaseHeader(
                title: "Link",
                description: "Inline text links for navigation, actions, and references. Understated until pressed."
            )

            // Styles
            DemoSection(title: "Default") {
                LubaLink("Learn more about LubaUI") { }
            }

            DemoSection(title: "Subtle") {
                LubaLink("Privacy policy", style: .subtle) { }
            }

            DemoSection(title: "External") {
                LubaLink("Visit documentation", style: .external) { }
            }

            // In Context
            DemoSection(title: "In Context") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("By creating an account, you agree to our **Terms of Service** and **Privacy Policy**.")
                            .font(LubaTypography.bodySmall)
                            .foregroundStyle(LubaColors.textSecondary)
                            .tint(LubaColors.accent)
                    }
                }

                LubaCard(elevation: .flat, style: .outlined) {
                    HStack {
                        Text("Need help?")
                            .font(LubaTypography.bodySmall)
                            .foregroundStyle(LubaColors.textSecondary)
                        LubaLink("Contact support") { }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaLink(\"Learn more\") { }")
                    CopyableCode(code: "LubaLink(\"Policy\", style: .subtle) { }")
                    CopyableCode(code: "LubaLink(\"Docs\", style: .external) { }")
                }
            }

            PhilosophyCard(
                icon: "link",
                title: "The Gentle Invitation",
                description: "Links don't demand attention — they offer it. A subtle accent color says 'you can go here' without screaming. Underline on press confirms the interaction."
            )
        }
    }
}

#Preview {
    NavigationStack {
        LinkScreen()
    }
}
