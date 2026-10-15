import SwiftUI
import LubaUI

/// The preview is a child view so its environment reads resolve *below* `.lubaTheme`.
struct ThemeScreen: View {
    @State private var selectedTheme = "Sage"
    private let themes = ["Sage", "Ocean", "Warm", "Mono"]

    private var currentTheme: LubaThemeConfiguration {
        switch selectedTheme {
        case "Ocean":
            return LubaThemeConfiguration(
                colors: .accented(Color(hex: 0x2F5FD0)),
                spacing: LubaThemeSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 20)
            )
        case "Warm":
            return LubaThemeConfiguration(
                colors: .accented(Color(hex: 0xA84832)),
                radius: LubaThemeRadius(sm: 12, md: 16, lg: 24)
            )
        case "Mono":
            return LubaThemeConfiguration(
                colors: .accented(LubaColors.textPrimary, onAccent: LubaColors.background),
                radius: LubaThemeRadius(sm: 0, md: 0, lg: 2, full: 4)
            )
        default: return .default
        }
    }

    var body: some View {
        ShowcaseScreen("Theming") {
            ShowcaseHeader(title: "Theming", description: "One composition. Four visual identities. Change the theme and every child inherits it.")

            Picker("Theme", selection: $selectedTheme) {
                ForEach(themes, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.segmented)

            ThemePreview()
                .lubaTheme(currentTheme)

            DemoSection(title: "Inside the subtree") {
                CodeBlock {
                    Text("@LubaEnvironment private var luba")
                    Text(".foregroundStyle(luba.colors.accent)")
                    Text(".padding(luba.spacing.lg)")
                }
            }

            PhilosophyCard(
                icon: "paintpalette",
                title: "A palette is more than one color",
                description: "Use .accented(...) to derive the accent ramp, subtle surfaces, focus borders, and info color together. A palette-only override preserves the surrounding type, spacing, and radii."
            )
            CopyableCode(code: ".lubaTheme(colors: .accented(.indigo))")
        }
    }
}

private struct ThemePreview: View {
    @LubaEnvironment private var luba
    @State private var notifications = true
    @State private var saved = false
    @State private var selected = "Design"

    var body: some View {
        VStack(alignment: .leading, spacing: luba.spacing.lg) {
            LubaCard {
                VStack(alignment: .leading, spacing: luba.spacing.lg) {
                    HStack(spacing: luba.spacing.md) {
                        LubaCircledIcon("leaf", size: .md, style: .subtle)
                        VStack(alignment: .leading, spacing: luba.spacing.xs) {
                            Text("Studio workspace")
                                .font(luba.fonts.title3)
                                .foregroundStyle(luba.colors.textPrimary)
                            Text("A little room to make things.")
                                .font(luba.fonts.caption)
                                .foregroundStyle(luba.colors.textSecondary)
                        }
                        Spacer(minLength: 0)
                    }

                    LubaDivider()
                    HStack {
                        Text("Spring collection")
                            .font(luba.fonts.headline)
                            .foregroundStyle(luba.colors.textPrimary)
                        Spacer()
                        LubaBadge("In progress", style: .accent)
                    }
                    Text("Six of eight details, ready to go.")
                        .font(luba.fonts.body)
                        .foregroundStyle(luba.colors.textSecondary)
                    LubaProgressBar(value: 0.75, showLabel: true)
                    HStack(spacing: luba.spacing.sm) {
                        ForEach(["Design", "Build", "Review"], id: \.self) { label in
                            LubaChip(label, isSelected: selected == label, onTap: { selected = label })
                        }
                    }
                    LubaDivider()
                    LubaToggle(isOn: $notifications, label: "Project updates")
                    LubaButton(saved ? "Changes saved" : "Save changes", icon: Image(systemName: saved ? "checkmark" : "arrow.right"), fullWidth: true) {
                        saved.toggle()
                    }
                }
            }
            HStack(spacing: luba.spacing.sm) {
                ForEach(["Accent", "Surface", "Text"], id: \.self) { role in
                    HStack(spacing: luba.spacing.xs) {
                        Circle()
                            .fill(role == "Accent" ? luba.colors.accent : role == "Surface" ? luba.colors.accentSubtle : luba.colors.textPrimary)
                            .frame(width: 10, height: 10)
                        Text(role).font(luba.fonts.caption)
                    }
                }
            }
            .foregroundStyle(luba.colors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack { ThemeScreen() }
}
