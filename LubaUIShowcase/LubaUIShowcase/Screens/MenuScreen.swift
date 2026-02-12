//
//  MenuScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaMenu contextual action menus.
//

import SwiftUI
import LubaUI

struct MenuScreen: View {
    @State private var lastAction = "None"

    var body: some View {
        ShowcaseScreen("Menu") {
            ShowcaseHeader(
                title: "Menu",
                description: "Contextual action menus that appear on tap. Built on native SwiftUI Menu, styled with LubaUI semantics."
            )

            // Basic
            DemoSection(title: "Basic Menu") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Document.pdf")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("Last action: \(lastAction)")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                        Spacer()
                        LubaMenu(items: [
                            LubaMenuItem("Edit", icon: Image(systemName: "pencil")) { lastAction = "Edit" },
                            LubaMenuItem("Duplicate", icon: Image(systemName: "doc.on.doc")) { lastAction = "Duplicate" },
                            LubaMenuItem("Share", icon: Image(systemName: "square.and.arrow.up")) { lastAction = "Share" }
                        ])
                    }
                }
            }

            // With Destructive
            DemoSection(title: "With Destructive Action") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Jane Doe", size: .medium)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Jane Doe")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("jane@example.com")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }
                        Spacer()
                        LubaMenu(items: [
                            LubaMenuItem("View Profile", icon: Image(systemName: "person")) { },
                            LubaMenuItem("Send Message", icon: Image(systemName: "envelope")) { },
                            LubaMenuItem("Block User", icon: Image(systemName: "slash.circle"), role: .destructive) { }
                        ])
                    }
                }
            }

            // Custom Trigger
            DemoSection(title: "Custom Trigger") {
                HStack(spacing: LubaSpacing.lg) {
                    LubaMenu(items: [
                        LubaMenuItem("Copy") { },
                        LubaMenuItem("Paste") { },
                        LubaMenuItem("Select All") { }
                    ]) {
                        LubaButton("Actions", style: .secondary, icon: Image(systemName: "chevron.down")) { }
                    }

                    LubaMenu(items: [
                        LubaMenuItem("Settings", icon: Image(systemName: "gearshape")) { },
                        LubaMenuItem("Help", icon: Image(systemName: "questionmark.circle")) { },
                        LubaMenuItem("Sign Out", icon: Image(systemName: "arrow.right.square"), role: .destructive) { }
                    ]) {
                        LubaCircledIcon("ellipsis", size: .md, style: .subtle)
                    }
                }
            }

            // Card Actions
            DemoSection(title: "Card With Menu") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        HStack {
                            Text("Project Update")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Spacer()
                            LubaMenu(items: [
                                LubaMenuItem("Edit", icon: Image(systemName: "pencil")) { },
                                LubaMenuItem("Pin", icon: Image(systemName: "pin")) { },
                                LubaMenuItem("Archive", icon: Image(systemName: "archivebox")) { },
                                LubaMenuItem("Delete", icon: Image(systemName: "trash"), role: .destructive) { }
                            ])
                        }

                        Text("The design system is coming together. All components now have accessibility support and the showcase app covers every feature.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        HStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Design", style: .subtle, size: .small)
                            LubaBadge("In Progress", style: .accent, size: .small)
                        }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaMenu(items: [...]) { Label }")
                    CopyableCode(code: "LubaMenu(items: [...])  // ellipsis trigger")
                    CopyableCode(code: "LubaMenuItem(\"Delete\", role: .destructive) { }")
                }
            }

            PhilosophyCard(
                icon: "list.bullet",
                title: "Actions in Context",
                description: "Menus keep interfaces clean by hiding secondary actions until needed. The three-dot pattern is universally understood — no learning curve required."
            )
        }
    }
}

#Preview {
    NavigationStack {
        MenuScreen()
    }
}
