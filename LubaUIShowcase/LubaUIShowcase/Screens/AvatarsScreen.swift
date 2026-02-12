//
//  AvatarsScreen.swift
//  LubaUIShowcase
//
//  Avatars showcase with sizes, groups, and real-world examples.
//

import SwiftUI
import LubaUI

struct AvatarsScreen: View {
    var body: some View {
        ShowcaseScreen("Avatars") {
            ShowcaseHeader(
                title: "Avatars",
                description: "User profile images with automatic initials generation and grouping support."
            )

            // Sizes
            DemoSection(title: "Sizes") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.lg) {
                        VStack(spacing: LubaSpacing.sm) {
                            LubaAvatar(name: "Small", size: .small)
                            Text("32pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaAvatar(name: "Medium", size: .medium)
                            Text("40pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaAvatar(name: "Large", size: .large)
                            Text("56pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaAvatar(name: "XL", size: .xlarge)
                            Text("80pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Initials Generation
            DemoSection(title: "Auto Initials") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.lg) {
                            VStack(spacing: LubaSpacing.xs) {
                                LubaAvatar(name: "Erman Akar", size: .large)
                                Text("EA")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            VStack(spacing: LubaSpacing.xs) {
                                LubaAvatar(name: "Jane Doe", size: .large)
                                Text("JD")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            VStack(spacing: LubaSpacing.xs) {
                                LubaAvatar(name: "Alex", size: .large)
                                Text("A")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            VStack(spacing: LubaSpacing.xs) {
                                LubaAvatar(initials: "UI", size: .large)
                                Text("Custom")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Text("Pass a full name to auto-generate initials, or provide custom initials directly.")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Border Option
            DemoSection(title: "With Border") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.lg) {
                        LubaAvatar(name: "No Border", size: .large)
                        LubaAvatar(name: "With Border", size: .large, showBorder: true)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Avatar Group
            DemoSection(title: "Avatar Group") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack {
                            Text("Team Members")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textPrimary)
                            Spacer()
                            LubaAvatarGroup(
                                avatars: [
                                    LubaAvatar(name: "Alice Brown", size: .small),
                                    LubaAvatar(name: "Bob Smith", size: .small),
                                    LubaAvatar(name: "Carol White", size: .small),
                                    LubaAvatar(name: "David Lee", size: .small),
                                    LubaAvatar(name: "Emma Wilson", size: .small),
                                    LubaAvatar(name: "Frank Miller", size: .small)
                                ],
                                maxVisible: 4,
                                size: .small
                            )
                        }

                        Text("Overlapping avatars with overflow count. Great for showing team members or participants.")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Real-World: User List
            DemoSection(title: "User List Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        userRow(name: "Sarah Johnson", role: "Product Designer", isOnline: true)
                        LubaDivider()
                        userRow(name: "Michael Chen", role: "iOS Developer", isOnline: true)
                        LubaDivider()
                        userRow(name: "Emily Davis", role: "Project Manager", isOnline: false)
                    }
                }
            }

            // Real-World: Comment
            DemoSection(title: "Comment Example") {
                LubaCard(elevation: .low) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaAvatar(name: "Alex Rivera", size: .medium)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            HStack(spacing: LubaSpacing.sm) {
                                Text("Alex Rivera")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)

                                Text("2h ago")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }

                            Text("This design system is looking great! The attention to detail in the motion tokens really shows.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }

            // Real-World: Profile Header
            DemoSection(title: "Profile Header Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaAvatar(name: "Erman Akar", size: .xlarge, showBorder: true)

                        VStack(spacing: LubaSpacing.xs) {
                            Text("Erman Akar")
                                .font(LubaTypography.title)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Creator of LubaUI")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                        }

                        HStack(spacing: LubaSpacing.md) {
                            LubaButton("Follow", style: .primary, size: .small) { }
                            LubaButton("Message", style: .secondary, size: .small) { }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: - Components

    private func userRow(name: String, role: String, isOnline: Bool) -> some View {
        HStack(spacing: LubaSpacing.md) {
            ZStack(alignment: .bottomTrailing) {
                LubaAvatar(name: name, size: .medium)

                Circle()
                    .fill(isOnline ? LubaColors.success : LubaColors.gray400)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .strokeBorder(LubaColors.surface, lineWidth: 2)
                    )
                    .offset(x: 2, y: 2)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)

                Text(role)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }

            Spacer()

            Text(isOnline ? "Online" : "Offline")
                .font(LubaTypography.caption)
                .foregroundStyle(isOnline ? LubaColors.success : LubaColors.textTertiary)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

}

#Preview {
    NavigationStack {
        AvatarsScreen()
    }
}
