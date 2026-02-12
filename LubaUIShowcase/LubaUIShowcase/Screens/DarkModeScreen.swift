//
//  DarkModeScreen.swift
//  LubaUIShowcase
//
//  Side-by-side dark mode comparison of all design tokens and components.
//

import SwiftUI
import LubaUI

struct DarkModeScreen: View {
    var body: some View {
        ShowcaseScreen("Dark Mode") {
            ShowcaseHeader(
                title: "Dark Mode",
                description: "Every LubaUI color is adaptive — see how tokens transform between light and dark."
            )

            // Side-by-Side Colors
            DemoSection(title: "Color Tokens") {
                HStack(spacing: LubaSpacing.sm) {
                    colorColumn(scheme: .light)
                    colorColumn(scheme: .dark)
                }
            }

            // Side-by-Side Components
            DemoSection(title: "Components") {
                HStack(alignment: .top, spacing: LubaSpacing.sm) {
                    componentColumn(scheme: .light)
                    componentColumn(scheme: .dark)
                }
            }

            // Card Elevations
            DemoSection(title: "Card Shadows") {
                HStack(spacing: LubaSpacing.sm) {
                    elevationColumn(scheme: .light)
                    elevationColumn(scheme: .dark)
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "moon.stars",
                title: "Automatic Adaptation",
                description: "LubaColors.adaptive(light:dark:) handles everything. Shadows get 50% stronger in dark mode. Borders become visible on filled cards. No manual overrides needed — it just works."
            )
        }
    }

    // MARK: - Components

    private func colorColumn(scheme: ColorScheme) -> some View {
        VStack(spacing: LubaSpacing.xs) {
            Text(scheme == .light ? "Light" : "Dark")
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)

            VStack(spacing: 2) {
                colorSwatch("background", LubaColors.background, scheme: scheme)
                colorSwatch("surface", LubaColors.surface, scheme: scheme)
                colorSwatch("accent", LubaColors.accent, scheme: scheme)
                colorSwatch("accentSubtle", LubaColors.accentSubtle, scheme: scheme)
                colorSwatch("border", LubaColors.border, scheme: scheme)
                colorSwatch("gray100", LubaColors.gray100, scheme: scheme)
                colorSwatch("gray400", LubaColors.gray400, scheme: scheme)
                colorSwatch("gray900", LubaColors.gray900, scheme: scheme)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func colorSwatch(_ name: String, _ color: Color, scheme: ColorScheme) -> some View {
        HStack(spacing: LubaSpacing.xs) {
            RoundedRectangle.luba(LubaRadius.xs)
                .fill(color)
                .frame(width: 20, height: 20)
                .overlay(
                    RoundedRectangle.luba(LubaRadius.xs)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 0.5)
                )

            Text(name)
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(LubaColors.textTertiary)
                .lineLimit(1)

            Spacer()
        }
        .padding(.vertical, 2)
        .environment(\.colorScheme, scheme)
    }

    private func componentColumn(scheme: ColorScheme) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            Text(scheme == .light ? "Light" : "Dark")
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)

            VStack(spacing: LubaSpacing.sm) {
                LubaButton("Button", style: .primary, size: .small) { }

                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Card")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("With content")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                }

                HStack(spacing: LubaSpacing.xs) {
                    LubaBadge("Tag", style: .accent, size: .small)
                    LubaBadge("Info", style: .subtle, size: .small)
                }

                LubaCheckbox(isChecked: .constant(true), label: "Checked")
            }
            .padding(LubaSpacing.md)
            .background(LubaColors.background)
            .clipShape(RoundedRectangle.luba(LubaRadius.md))
            .overlay(
                RoundedRectangle.luba(LubaRadius.md)
                    .strokeBorder(LubaColors.border, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity)
        .environment(\.colorScheme, scheme)
    }

    private func elevationColumn(scheme: ColorScheme) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            Text(scheme == .light ? "Light" : "Dark")
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)

            VStack(spacing: LubaSpacing.md) {
                ForEach(["Flat", "Low", "Medium", "High"], id: \.self) { name in
                    let elevation: LubaCardElevation = {
                        switch name {
                        case "Flat": return .flat
                        case "Low": return .low
                        case "Medium": return .medium
                        default: return .high
                        }
                    }()

                    LubaCard(elevation: elevation) {
                        Text(name)
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(LubaSpacing.md)
            .background(LubaColors.background)
            .clipShape(RoundedRectangle.luba(LubaRadius.md))
        }
        .frame(maxWidth: .infinity)
        .environment(\.colorScheme, scheme)
    }
}

#Preview {
    NavigationStack {
        DarkModeScreen()
    }
}
