//
//  TabsScreen.swift
//  LubaUIShowcase
//
//  Tabs component showcase with segmented controls, underline tabs, and real-world examples.
//

import SwiftUI
import LubaUI

struct TabsScreen: View {
    @State private var segmentedTab = 0
    @State private var underlineTab = "all"
    @State private var iconTab = 0
    @State private var feedFilter = "posts"

    var body: some View {
        ShowcaseScreen("Tabs") {
            ShowcaseHeader(
                title: "Tabs",
                description: "Segmented controls and underline tabs with smooth matched geometry animations."
            )

            // Segmented
            DemoSection(title: "Segmented") {
                VStack(spacing: LubaSpacing.lg) {
                    LubaTabs(
                        selection: $segmentedTab,
                        tabs: [
                            (value: 0, label: "Daily"),
                            (value: 1, label: "Weekly"),
                            (value: 2, label: "Monthly")
                        ]
                    )

                    LubaCard(elevation: .flat, style: .outlined) {
                        VStack(spacing: LubaSpacing.sm) {
                            Text(["Daily View", "Weekly View", "Monthly View"][segmentedTab])
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Content changes based on selection")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LubaSpacing.lg)
                    }
                }
            }

            // With Icons
            DemoSection(title: "With Icons") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaTabs(
                            selection: $iconTab,
                            tabs: [
                                (value: 0, label: "Home", icon: "house"),
                                (value: 1, label: "Search", icon: "magnifyingglass"),
                                (value: 2, label: "Profile", icon: "person")
                            ]
                        )

                        Text("Icons provide visual hierarchy")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Underline Style
            DemoSection(title: "Underline") {
                VStack(spacing: LubaSpacing.lg) {
                    LubaUnderlineTabs(
                        selection: $underlineTab,
                        tabs: [
                            (value: "all", label: "All"),
                            (value: "active", label: "Active"),
                            (value: "completed", label: "Completed")
                        ]
                    )

                    VStack(spacing: LubaSpacing.sm) {
                        ForEach(0..<3) { index in
                            HStack(spacing: LubaSpacing.md) {
                                LubaAvatar(name: "User \(index + 1)", size: .medium)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Task \(index + 1)")
                                        .font(LubaTypography.body)
                                        .foregroundStyle(LubaColors.textPrimary)
                                    Text(underlineTab == "completed" ? "Completed" : "In progress")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(underlineTab == "completed" ? LubaColors.success : LubaColors.textSecondary)
                                }

                                Spacer()

                                if underlineTab == "completed" {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(LubaColors.success)
                                }
                            }
                            .padding(LubaSpacing.md)
                            .background(LubaColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md))
                        }
                    }
                }
            }

            // Real-World: Profile Tabs
            DemoSection(title: "Profile Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        // Profile Header
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Alex Morgan", size: .large)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Alex Morgan")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("@alexmorgan")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()

                            LubaButton("Follow", style: .primary, size: .small) { }
                        }

                        // Stats
                        HStack(spacing: LubaSpacing.xl) {
                            statItem(value: "1.2K", label: "Posts")
                            statItem(value: "48K", label: "Followers")
                            statItem(value: "234", label: "Following")
                        }
                        .frame(maxWidth: .infinity)

                        LubaDivider()

                        // Feed Tabs
                        LubaUnderlineTabs(
                            selection: $feedFilter,
                            tabs: [
                                (value: "posts", label: "Posts"),
                                (value: "replies", label: "Replies"),
                                (value: "likes", label: "Likes")
                            ]
                        )

                        // Content Preview
                        ForEach(0..<2) { _ in
                            HStack(alignment: .top, spacing: LubaSpacing.md) {
                                LubaAvatar(name: "Alex Morgan", size: .small)

                                VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                    Text("Just shipped a new feature!")
                                        .font(LubaTypography.body)
                                        .foregroundStyle(LubaColors.textPrimary)
                                    Text("2h ago")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textTertiary)
                                }

                                Spacer()
                            }
                        }
                    }
                }
            }

            // Real-World: Settings Tabs
            DemoSection(title: "Settings Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaTabs(
                            selection: $segmentedTab,
                            tabs: [
                                (value: 0, label: "Account"),
                                (value: 1, label: "Privacy"),
                                (value: 2, label: "Notifs")
                            ]
                        )

                        // Settings Content
                        VStack(spacing: 0) {
                            settingRow(icon: segmentedTab == 0 ? "person.fill" : segmentedTab == 1 ? "lock.fill" : "bell.fill",
                                       title: segmentedTab == 0 ? "Edit Profile" : segmentedTab == 1 ? "Password" : "Push Notifications")
                            LubaDivider()
                            settingRow(icon: segmentedTab == 0 ? "envelope.fill" : segmentedTab == 1 ? "eye.slash.fill" : "envelope.badge.fill",
                                       title: segmentedTab == 0 ? "Email" : segmentedTab == 1 ? "Hidden Mode" : "Email Alerts")
                            LubaDivider()
                            settingRow(icon: segmentedTab == 0 ? "phone.fill" : segmentedTab == 1 ? "hand.raised.fill" : "speaker.wave.2.fill",
                                       title: segmentedTab == 0 ? "Phone" : segmentedTab == 1 ? "Blocked Users" : "Sounds")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(LubaTypography.headline)
                .foregroundStyle(LubaColors.textPrimary)
            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)
        }
    }

    private func settingRow(icon: String, title: String) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(LubaTypography.custom(size: 12, weight: .semibold))
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

}

#Preview {
    NavigationStack {
        TabsScreen()
    }
}
