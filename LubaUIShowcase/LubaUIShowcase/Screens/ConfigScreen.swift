//
//  ConfigScreen.swift
//  LubaUIShowcase
//
//  Interactive configuration showcase with live presets and per-setting controls.
//

import SwiftUI
import LubaUI

struct ConfigScreen: View {
    @State private var selectedPreset = "default"
    @State private var config = LubaConfig()

    private let presets: [(id: String, name: String, description: String, icon: String)] = [
        ("default", "Default", "All features enabled", "slider.horizontal.3"),
        ("minimal", "Minimal", "No animations or haptics", "minus.circle"),
        ("accessible", "Accessible", "High contrast, bold, 48pt targets", "accessibility"),
        ("debug", "Debug", "Outlines and a11y warnings", "ladybug")
    ]

    var body: some View {
        ShowcaseScreen("Configuration") {
            ShowcaseHeader(
                title: "Configuration",
                description: "LubaConfig controls the entire system — haptics, animations, accessibility, and more — via environment."
            )

            // Presets
            DemoSection(title: "Presets") {
                VStack(spacing: LubaSpacing.sm) {
                    ForEach(presets, id: \.id) { preset in
                        presetCard(
                            id: preset.id,
                            name: preset.name,
                            description: preset.description,
                            icon: preset.icon
                        )
                    }
                }
            }

            // Live Preview
            DemoSection(title: "Live Preview") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        Text("Components respond to config")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        previewArea
                            .lubaConfig(config)

                        currentSettingsSummary
                    }
                }
            }

            // Individual Settings
            DemoSection(title: "Haptics & Motion") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        settingToggle(
                            icon: "waveform",
                            title: "Haptics Enabled",
                            subtitle: "Tactile feedback on interactions",
                            isOn: $config.hapticsEnabled
                        )
                        LubaDivider()
                        settingToggle(
                            icon: "play.fill",
                            title: "Animations Enabled",
                            subtitle: "Spring and transition animations",
                            isOn: $config.animationsEnabled
                        )
                        LubaDivider()
                        settingToggle(
                            icon: "figure.walk",
                            title: "Respect Reduced Motion",
                            subtitle: "Honor system accessibility setting",
                            isOn: $config.respectReducedMotion
                        )
                    }
                }
            }

            DemoSection(title: "Accessibility") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        settingToggle(
                            icon: "bold",
                            title: "Bold Text",
                            subtitle: "Heavier font weight for readability",
                            isOn: $config.useBoldText
                        )
                        LubaDivider()
                        settingToggle(
                            icon: "circle.lefthalf.filled",
                            title: "High Contrast Mode",
                            subtitle: "Increased color contrast",
                            isOn: $config.highContrastMode
                        )
                    }
                }
            }

            DemoSection(title: "Typography") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        settingToggle(
                            icon: "textformat",
                            title: "SF Rounded",
                            subtitle: "Use rounded variant (vs. SF Pro)",
                            isOn: $config.useRoundedFont
                        )
                    }
                }
            }

            DemoSection(title: "Debug") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        settingToggle(
                            icon: "rectangle.dashed",
                            title: "Debug Outlines",
                            subtitle: "Show component boundaries",
                            isOn: $config.showDebugOutlines
                        )
                        LubaDivider()
                        settingToggle(
                            icon: "exclamationmark.triangle",
                            title: "A11y Warnings",
                            subtitle: "Log accessibility issues",
                            isOn: $config.logA11yWarnings
                        )
                    }
                }
            }

            // Environment Usage
            DemoSection(title: "Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Apply a preset")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text(".lubaConfig(.accessible)")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Customize inline")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text(".lubaConfig { $0.hapticsEnabled = false }")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Read in components")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("@Environment(\\.lubaConfig) var config")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "gearshape.2",
                title: "One Config, Everywhere",
                description: "LubaConfig flows through the environment — set it once at the root and every component inherits it. Override per-subtree for contextual behavior like disabling haptics in a quiet zone."
            )
        }
    }

    // MARK: - Components

    private func presetCard(id: String, name: String, description: String, icon: String) -> some View {
        let isSelected = selectedPreset == id

        return HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(description)
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
        .lubaPressable {
            selectedPreset = id
            switch id {
            case "minimal": config = .minimal
            case "accessible": config = .accessible
            case "debug": config = .debug
            default: config = LubaConfig()
            }
        }
    }

    private var previewArea: some View {
        VStack(spacing: LubaSpacing.md) {
            HStack(spacing: LubaSpacing.md) {
                LubaButton("Tap Me", style: .primary, size: .medium) { }
                LubaButton("Secondary", style: .secondary, size: .medium) { }
            }

            LubaCard(elevation: .flat, style: .outlined) {
                HStack(spacing: LubaSpacing.md) {
                    LubaAvatar(name: "Config Test", size: .medium)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Preview Card")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("Responds to config changes")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                    }

                    Spacer()

                    LubaIconButton("heart") { }
                }
            }

            HStack(spacing: LubaSpacing.sm) {
                LubaCheckbox(isChecked: .constant(true), label: "Checked")
                Spacer()
                LubaToggle(isOn: .constant(true), label: "On")
            }
        }
    }

    private var currentSettingsSummary: some View {
        HStack(spacing: LubaSpacing.sm) {
            configBadge("Haptics", isOn: config.hapticsEnabled)
            configBadge("Anim", isOn: config.animationsEnabled)
            configBadge("Bold", isOn: config.useBoldText)
            configBadge("HiCon", isOn: config.highContrastMode)
        }
    }

    private func configBadge(_ label: String, isOn: Bool) -> some View {
        Text(label)
            .font(LubaTypography.caption)
            .foregroundStyle(isOn ? LubaColors.accent : LubaColors.textTertiary)
            .padding(.horizontal, LubaSpacing.sm)
            .padding(.vertical, LubaSpacing.xs)
            .background(isOn ? LubaColors.accentSubtle : LubaColors.surfaceSecondary)
            .clipShape(Capsule())
    }

    private func settingToggle(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(subtitle)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textTertiary)
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(LubaColors.accent)
        }
        .padding(.horizontal, LubaSpacing.lg)
        .padding(.vertical, LubaSpacing.md)
    }
}

#Preview {
    NavigationStack {
        ConfigScreen()
    }
}
