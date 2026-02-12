//
//  ColorsScreen.swift
//  LubaUIShowcase
//
//  Color palette showcase with greyscale, accent, semantic colors, and real-world examples.
//

import SwiftUI
import LubaUI

struct ColorsScreen: View {
    var body: some View {
        ShowcaseScreen("Colors") {
            // Header
            ShowcaseHeader(
                title: "Colors",
                description: "A greyscale-first palette with organic sage accent. Refined for light and dark modes."
            )

            // Greyscale
            DemoSection(title: "Greyscale") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        greyscaleRow(name: "900", color: LubaColors.gray900)
                        greyscaleRow(name: "800", color: LubaColors.gray800)
                        greyscaleRow(name: "600", color: LubaColors.gray600)
                        greyscaleRow(name: "500", color: LubaColors.gray500)
                        greyscaleRow(name: "400", color: LubaColors.gray400)
                        greyscaleRow(name: "200", color: LubaColors.gray200)
                        greyscaleRow(name: "100", color: LubaColors.gray100)
                        greyscaleRow(name: "50", color: LubaColors.gray50)
                    }
                }
            }

            // Accent
            DemoSection(title: "Accent — Sage Green") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.md) {
                        colorChip(color: LubaColors.accent, name: "Accent")
                        colorChip(color: LubaColors.accentHover, name: "Hover")
                        colorChip(color: LubaColors.accentSubtle, name: "Subtle")
                    }
                }
            }

            // Semantic
            DemoSection(title: "Semantic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.md) {
                        colorChip(color: LubaColors.success, name: "Success")
                        colorChip(color: LubaColors.warning, name: "Warning")
                        colorChip(color: LubaColors.error, name: "Error")
                    }
                }
            }

            // Surfaces
            DemoSection(title: "Surfaces") {
                VStack(spacing: LubaSpacing.sm) {
                    surfaceRow(name: "Background", color: LubaColors.background)
                    surfaceRow(name: "Surface", color: LubaColors.surface)
                    surfaceRow(name: "Surface Secondary", color: LubaColors.surfaceSecondary)
                }
            }

            // Real-World: Notification List
            DemoSection(title: "Notification List Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        notificationRow(
                            icon: "checkmark.circle.fill",
                            iconColor: LubaColors.success,
                            title: "Payment received",
                            subtitle: "$250.00 from John Doe"
                        )
                        LubaDivider()
                        notificationRow(
                            icon: "exclamationmark.triangle.fill",
                            iconColor: LubaColors.warning,
                            title: "Subscription expiring",
                            subtitle: "Renew before Mar 30"
                        )
                        LubaDivider()
                        notificationRow(
                            icon: "xmark.circle.fill",
                            iconColor: LubaColors.error,
                            title: "Card declined",
                            subtitle: "Please update payment method"
                        )
                        LubaDivider()
                        notificationRow(
                            icon: "info.circle.fill",
                            iconColor: LubaColors.accent,
                            title: "New feature available",
                            subtitle: "Check out dark mode support"
                        )
                    }
                }
            }

            // Real-World: Status Indicators
            DemoSection(title: "Status Indicators Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        statusRow(name: "API Server", status: .success, statusText: "Operational")
                        statusRow(name: "Database", status: .success, statusText: "Operational")
                        statusRow(name: "CDN", status: .warning, statusText: "Degraded")
                        statusRow(name: "Auth Service", status: .error, statusText: "Outage")
                    }
                }
            }

            // Real-World: Text Colors
            DemoSection(title: "Text Hierarchy Example") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("Primary text for main content")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)

                        Text("Secondary text provides supporting information that complements the primary content.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        Text("Tertiary text for timestamps, captions, and less important details")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)

                        LubaDivider()

                        HStack(spacing: LubaSpacing.lg) {
                            VStack(spacing: LubaSpacing.xs) {
                                Circle().fill(LubaColors.textPrimary).frame(width: 24, height: 24)
                                Text("Primary").font(LubaTypography.caption).foregroundStyle(LubaColors.textTertiary)
                            }
                            VStack(spacing: LubaSpacing.xs) {
                                Circle().fill(LubaColors.textSecondary).frame(width: 24, height: 24)
                                Text("Secondary").font(LubaTypography.caption).foregroundStyle(LubaColors.textTertiary)
                            }
                            VStack(spacing: LubaSpacing.xs) {
                                Circle().fill(LubaColors.textTertiary).frame(width: 24, height: 24)
                                Text("Tertiary").font(LubaTypography.caption).foregroundStyle(LubaColors.textTertiary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }

            // Philosophy
            DemoSection(title: "Why Sage Green?") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("leaf.fill", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Organic & Calming")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Sage green feels natural and approachable. It's distinctive without being aggressive — standing out in a sea of blue apps while remaining professional.")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func greyscaleRow(name: String, color: Color) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(color)
                .frame(width: 60)

            HStack {
                Text("Gray \(name)")
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)
                Spacer()
                Text("gray\(name)")
                    .font(LubaTypography.code)
                    .foregroundStyle(LubaColors.textTertiary)
            }
            .padding(.horizontal, LubaSpacing.lg)
            .padding(.vertical, LubaSpacing.md)
        }
        .frame(height: 52)
        .background(LubaColors.surface)
    }

    private func colorChip(color: Color, name: String) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous)
                .fill(color)
                .frame(height: 80)

            Text(name)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func surfaceRow(name: String, color: Color) -> some View {
        HStack {
            Text(name)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)
            Spacer()
        }
        .padding(LubaSpacing.lg)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous)
                .strokeBorder(LubaColors.border, lineWidth: 1)
        )
    }

    private func notificationRow(icon: String, iconColor: Color, title: String, subtitle: String) -> some View {
        HStack(spacing: LubaSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(subtitle)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }

            Spacer()

            Text("2m")
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

    enum StatusType {
        case success, warning, error
    }

    private func statusRow(name: String, status: StatusType, statusText: String) -> some View {
        HStack(spacing: LubaSpacing.md) {
            Circle()
                .fill(status == .success ? LubaColors.success : status == .warning ? LubaColors.warning : LubaColors.error)
                .frame(width: 8, height: 8)

            Text(name)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            Text(statusText)
                .font(LubaTypography.caption)
                .foregroundStyle(status == .success ? LubaColors.success : status == .warning ? LubaColors.warning : LubaColors.error)
        }
    }

}

#Preview {
    NavigationStack {
        ColorsScreen()
    }
}
