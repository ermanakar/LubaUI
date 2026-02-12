//
//  BadgesScreen.swift
//  LubaUIShowcase
//
//  Badges showcase with styles, sizes, and real-world examples.
//

import SwiftUI
import LubaUI

struct BadgesScreen: View {
    var body: some View {
        ShowcaseScreen("Badges") {
            ShowcaseHeader(
                title: "Badges",
                description: "Status indicators and labels with semantic colors and icon support."
            )

            // Styles
            DemoSection(title: "Styles") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Accent", style: .accent)
                            LubaBadge("Subtle", style: .subtle)
                            LubaBadge("Neutral", style: .neutral)
                        }

                        Text("Accent for primary actions, Subtle for softer emphasis, Neutral for informational.")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Semantic
            DemoSection(title: "Semantic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Success", style: .success)
                            LubaBadge("Warning", style: .warning)
                            LubaBadge("Error", style: .error)
                        }

                        Text("Use semantic colors to convey meaning: success, warning, or error states.")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Sizes
            DemoSection(title: "Sizes") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.lg) {
                        VStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Small", style: .accent, size: .small)
                            Text("11pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Medium", style: .accent, size: .medium)
                            Text("12pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // With Icons
            DemoSection(title: "With Icons") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            LubaBadge("New", style: .accent, icon: Image(systemName: "sparkles"))
                            LubaBadge("Pro", style: .subtle, icon: Image(systemName: "crown"))
                            LubaBadge("Verified", style: .success, icon: Image(systemName: "checkmark.seal"))
                        }

                        HStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Live", style: .error, icon: Image(systemName: "dot.radiowaves.left.and.right"))
                            LubaBadge("Beta", style: .warning, icon: Image(systemName: "hammer"))
                        }
                    }
                }
            }

            // Notification Counts
            DemoSection(title: "Notification Counts") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.xl) {
                        notificationIcon(icon: "bell.fill", count: 3)
                        notificationIcon(icon: "envelope.fill", count: 12)
                        notificationIcon(icon: "cart.fill", count: 99)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Real-World: Feature List
            DemoSection(title: "Feature List Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        featureRow(title: "Dark Mode", badge: LubaBadge("New", style: .accent, size: .small, icon: Image(systemName: "sparkles")))
                        LubaDivider()
                        featureRow(title: "Cloud Sync", badge: LubaBadge("Pro", style: .subtle, size: .small, icon: Image(systemName: "crown")))
                        LubaDivider()
                        featureRow(title: "AI Assistant", badge: LubaBadge("Beta", style: .warning, size: .small))
                        LubaDivider()
                        featureRow(title: "Analytics", badge: nil)
                    }
                }
            }

            // Real-World: Status List
            DemoSection(title: "Status List Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        statusRow(title: "Payment", status: "Completed", style: .success)
                        LubaDivider()
                        statusRow(title: "Shipping", status: "In Transit", style: .warning)
                        LubaDivider()
                        statusRow(title: "Delivery", status: "Pending", style: .neutral)
                    }
                }
            }

            // Real-World: User Profile
            DemoSection(title: "User Profile Example") {
                LubaCard(elevation: .low) {
                    HStack(spacing: LubaSpacing.md) {
                        LubaAvatar(name: "Erman Akar", size: .large)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            HStack(spacing: LubaSpacing.sm) {
                                Text("Erman Akar")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)

                                LubaBadge("Pro", style: .subtle, size: .small, icon: Image(systemName: "crown"))
                            }

                            HStack(spacing: LubaSpacing.sm) {
                                LubaBadge("iOS", style: .neutral, size: .small)
                                LubaBadge("SwiftUI", style: .neutral, size: .small)
                                LubaBadge("Design Systems", style: .neutral, size: .small)
                            }
                        }

                        Spacer()
                    }
                }
            }

            // Real-World: Article Card
            DemoSection(title: "Article Card Example") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Design", style: .subtle, size: .small)
                            LubaBadge("5 min read", style: .neutral, size: .small)
                        }

                        Text("Building a Vibe-First Design System")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)

                        Text("How we created LubaUI with radical composability, AI-native architecture, and low-friction adoption.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        HStack {
                            LubaAvatar(name: "Erman Akar", size: .small)
                            Text("Erman Akar")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                            Spacer()
                            Text("Dec 15, 2024")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func notificationIcon(icon: String, count: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Circle()
                    .fill(LubaColors.gray100)
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(LubaColors.textPrimary)
            }

            LubaBadge(count > 99 ? "99+" : "\(count)", style: .error, size: .small)
                .offset(x: 8, y: -4)
        }
    }

    private func featureRow(title: String, badge: LubaBadge?) -> some View {
        HStack {
            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            if let badge = badge {
                badge
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

    private func statusRow(title: String, status: String, style: LubaBadgeStyle) -> some View {
        HStack {
            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            LubaBadge(status, style: style, size: .small)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

}

#Preview {
    NavigationStack {
        BadgesScreen()
    }
}
