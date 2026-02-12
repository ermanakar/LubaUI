//
//  ThemeScreen.swift
//  LubaUIShowcase
//
//  Theme system showcase with custom theme creation and live preview.
//

import SwiftUI
import LubaUI

struct ThemeScreen: View {
    @State private var selectedTheme = "default"

    private var currentTheme: LubaThemeConfiguration {
        switch selectedTheme {
        case "warm": return warmTheme
        case "ocean": return oceanTheme
        case "mono": return monoTheme
        default: return .default
        }
    }

    var body: some View {
        ShowcaseScreen("Theming") {
            ShowcaseHeader(
                title: "Theming",
                description: "Override colors, typography, spacing, and radius per-subtree via the environment."
            )

            // Theme Picker
            DemoSection(title: "Select Theme") {
                VStack(spacing: LubaSpacing.sm) {
                    themeOption(id: "default", name: "Default", desc: "Greyscale + sage accent", icon: "leaf.fill")
                    themeOption(id: "warm", name: "Warm", desc: "Coral accent, rounded corners", icon: "sun.max.fill")
                    themeOption(id: "ocean", name: "Ocean", desc: "Blue accent, tighter spacing", icon: "drop.fill")
                    themeOption(id: "mono", name: "Mono", desc: "Monochrome, sharp corners", icon: "circle.lefthalf.filled")
                }
            }

            // Live Preview
            DemoSection(title: "Live Preview") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        Text("Components inherit the theme")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        previewArea
                            .lubaTheme(currentTheme)
                    }
                }
            }

            // Structure
            DemoSection(title: "Theme Structure") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        structureRow(token: "colors", desc: "primary, secondary, accent, background, surface, text")
                        LubaDivider()
                        structureRow(token: "typography", desc: "title, headline, body, caption, button")
                        LubaDivider()
                        structureRow(token: "spacing", desc: "xs, sm, md, lg, xl")
                        LubaDivider()
                        structureRow(token: "radius", desc: "sm, md, lg, full")
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Apply to a subtree")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text(".lubaTheme(myTheme)")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Read in any view")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("@Environment(\\.lubaTheme) var theme")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Customize colors only")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("LubaThemeConfiguration(colors: .init(accent: .blue))")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "paintpalette",
                title: "Theme vs. Config",
                description: "LubaTheme overrides visual tokens (colors, fonts, spacing). LubaConfig controls behavior (haptics, animations, accessibility). Both flow through SwiftUI's environment — set once, inherited everywhere."
            )
        }
    }

    // MARK: - Components

    private func themeOption(id: String, name: String, desc: String, icon: String) -> some View {
        let isSelected = selectedTheme == id
        return HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(desc)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(LubaColors.accent)
            }
        }
        .padding(LubaSpacing.md)
        .background(isSelected ? LubaColors.accentSubtle : LubaColors.surface)
        .clipShape(RoundedRectangle.luba(LubaRadius.md))
        .overlay(
            RoundedRectangle.luba(LubaRadius.md)
                .strokeBorder(isSelected ? LubaColors.accent : LubaColors.border, lineWidth: isSelected ? 1.5 : 1)
        )
        .lubaPressable { selectedTheme = id }
    }

    private var previewArea: some View {
        VStack(spacing: LubaSpacing.md) {
            HStack(spacing: LubaSpacing.md) {
                LubaButton("Primary", style: .primary, size: .small) { }
                LubaButton("Secondary", style: .secondary, size: .small) { }
                LubaButton("Ghost", style: .ghost, size: .small) { }
            }

            LubaCard(elevation: .flat, style: .outlined) {
                HStack(spacing: LubaSpacing.md) {
                    LubaAvatar(name: "Theme Demo", size: .medium)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Themed Card")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("Colors adapt to theme")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                    Spacer()
                }
            }

            HStack(spacing: LubaSpacing.sm) {
                LubaBadge("Active", style: .accent)
                LubaBadge("Subtle", style: .subtle)
                LubaBadge("Neutral", style: .neutral)
            }
        }
    }

    private func structureRow(token: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
            Text(token)
                .font(LubaTypography.headline)
                .foregroundStyle(LubaColors.textPrimary)
            Text(desc)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
    }

    // MARK: - Theme Definitions

    private var warmTheme: LubaThemeConfiguration {
        LubaThemeConfiguration(
            colors: LubaThemeColors(accent: Color(red: 0.9, green: 0.4, blue: 0.3)),
            radius: LubaThemeRadius(sm: 12, md: 16, lg: 24)
        )
    }

    private var oceanTheme: LubaThemeConfiguration {
        LubaThemeConfiguration(
            colors: LubaThemeColors(accent: Color(red: 0.2, green: 0.5, blue: 0.85)),
            spacing: LubaThemeSpacing(xs: 2, sm: 6, md: 10, lg: 14, xl: 20)
        )
    }

    private var monoTheme: LubaThemeConfiguration {
        LubaThemeConfiguration(
            colors: LubaThemeColors(accent: LubaColors.gray800),
            radius: LubaThemeRadius(sm: 0, md: 0, lg: 2, full: 4)
        )
    }
}

#Preview {
    NavigationStack {
        ThemeScreen()
    }
}
