//
//  SpacingScreen.swift
//  LubaUIShowcase
//
//  Spacing showcase demonstrating the 4pt base unit system.
//

import SwiftUI
import LubaUI

struct SpacingScreen: View {
    var body: some View {
        ShowcaseScreen("Spacing") {
            ShowcaseHeader(
                title: "Spacing",
                description: "A 4-point base unit creates harmonious, consistent layouts across your entire app."
            )

            // Scale
            DemoSection(title: "Scale") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        spacingRow(name: "xs", value: LubaSpacing.xs)
                        spacingRow(name: "sm", value: LubaSpacing.sm)
                        spacingRow(name: "md", value: LubaSpacing.md)
                        spacingRow(name: "lg", value: LubaSpacing.lg)
                        spacingRow(name: "xl", value: LubaSpacing.xl)
                        spacingRow(name: "xxl", value: LubaSpacing.xxl)
                        spacingRow(name: "xxxl", value: LubaSpacing.xxxl)
                    }
                }
            }

            // Visual Comparison
            DemoSection(title: "Visual Comparison") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.md) {
                        spacingVisual(spacing: LubaSpacing.sm, name: "sm")
                        spacingVisual(spacing: LubaSpacing.md, name: "md")
                        spacingVisual(spacing: LubaSpacing.lg, name: "lg")
                    }
                }
            }

            // Real-World: Card Layout
            DemoSection(title: "Card Layout Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Design System", size: .medium)

                            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                Text("Consistent Spacing")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("lg between sections • md between items")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()
                        }

                        Text("This card uses lg (16pt) for major sections and md (12pt) for related content, creating clear visual hierarchy.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        HStack(spacing: LubaSpacing.sm) {
                            LubaButton("Primary", style: .primary, size: .small) { }
                            LubaButton("Secondary", style: .secondary, size: .small) { }
                        }
                    }
                }
            }

            // Real-World: List Spacing
            DemoSection(title: "List Spacing Example") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        listItem(icon: "house.fill", title: "Dashboard", badge: nil)
                        LubaDivider()
                        listItem(icon: "doc.fill", title: "Documents", badge: "12")
                        LubaDivider()
                        listItem(icon: "gearshape.fill", title: "Settings", badge: nil)
                    }
                }
            }

            // Real-World: Form Spacing
            DemoSection(title: "Form Spacing Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Contact Information")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("Fields use lg spacing, labels use xs")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: LubaSpacing.md) {
                            formField(label: "Name")
                            formField(label: "Email")
                            formField(label: "Phone")
                        }

                        LubaButton("Submit", style: .primary, fullWidth: true) { }
                    }
                }
            }

            // Philosophy
            DemoSection(title: "The 4pt System") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("ruler.fill", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Mathematical Rhythm")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Every spacing value is a multiple of 4pt. This creates visual consistency that users feel even if they can't articulate it.")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func spacingRow(name: String, value: CGFloat) -> some View {
        HStack(spacing: LubaSpacing.lg) {
            Text(name)
                .font(LubaTypography.headline)
                .foregroundStyle(LubaColors.textPrimary)
                .frame(width: 40, alignment: .leading)

            Text("\(Int(value))pt")
                .font(LubaTypography.code)
                .foregroundStyle(LubaColors.textTertiary)
                .frame(width: 40, alignment: .trailing)

            GeometryReader { geo in
                RoundedRectangle(cornerRadius: LubaRadius.xs, style: .continuous)
                    .fill(LubaColors.accent)
                    .frame(width: min(value * 2.5, geo.size.width - 16), height: 20)
            }
            .frame(height: 20)
        }
    }

    private func spacingVisual(spacing: CGFloat, name: String) -> some View {
        VStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: LubaRadius.xs, style: .continuous)
                    .fill(LubaColors.accent.opacity(0.3))
                    .frame(height: 24)
            }
        }
        .padding(LubaSpacing.md)
        .background(LubaColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))
        .overlay(
            Text(name)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
                .padding(LubaSpacing.xs)
                .background(LubaColors.surface)
            , alignment: .bottom
        )
    }

    private func listItem(icon: String, title: String, badge: String?) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            if let badge = badge {
                LubaBadge(badge, style: .subtle, size: .small)
            }

            Image(systemName: "chevron.right")
                .font(LubaTypography.custom(size: 12, weight: .semibold))
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(.horizontal, LubaSpacing.lg)
        .padding(.vertical, LubaSpacing.md)
    }

    private func formField(label: String) -> some View {
        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)

            RoundedRectangle(cornerRadius: LubaRadius.md)
                .fill(LubaColors.surfaceSecondary)
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: LubaRadius.md)
                        .strokeBorder(LubaColors.border, lineWidth: 1)
                )
        }
    }

}

#Preview {
    NavigationStack {
        SpacingScreen()
    }
}
