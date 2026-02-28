//
//  TooltipScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaTooltip contextual help.
//

import SwiftUI
import LubaUI

struct TooltipScreen: View {
    private enum DemoPosition {
        case top
        case bottom

        var title: String {
            switch self {
            case .top: return "Top"
            case .bottom: return "Bottom"
            }
        }

        var tooltipPosition: LubaTooltipPosition {
            switch self {
            case .top: return .top
            case .bottom: return .bottom
            }
        }
    }

    private enum DemoMessageLength {
        case short
        case long

        var title: String {
            switch self {
            case .short: return "Short"
            case .long: return "Long"
            }
        }

        var message: String {
            switch self {
            case .short:
                return "Tooltips explain things quickly."
            case .long:
                return "Use tooltips for low-frequency guidance. Keep text concise and actionable."
            }
        }
    }

    private enum DemoTrigger {
        case icon
        case label

        var title: String {
            switch self {
            case .icon: return "Icon"
            case .label: return "Label"
            }
        }
    }

    @State private var demoPosition: DemoPosition = .top
    @State private var demoMessageLength: DemoMessageLength = .long
    @State private var demoTrigger: DemoTrigger = .icon

    var body: some View {
        ShowcaseScreen("Tooltip") {
            ShowcaseHeader(
                title: "Tooltip",
                description: "Contextual help that appears on tap. Perfect for explaining form fields, icons, or unfamiliar concepts."
            )

            DemoSection(title: "Interactive Playground") {
                LubaCard(elevation: .flat, style: .outlined, clipsContent: false) {
                    VStack(alignment: .leading, spacing: LubaSpacing.lg) {
                        Text("Tap the trigger to preview tooltip behavior.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        controlsRow(
                            title: "Placement",
                            items: [DemoPosition.top, .bottom].map(\.title),
                            selected: demoPosition.title
                        ) { selected in
                            demoPosition = selected == DemoPosition.top.title ? .top : .bottom
                        }

                        controlsRow(
                            title: "Message",
                            items: [DemoMessageLength.short, .long].map(\.title),
                            selected: demoMessageLength.title
                        ) { selected in
                            demoMessageLength = selected == DemoMessageLength.short.title ? .short : .long
                        }

                        controlsRow(
                            title: "Trigger",
                            items: [DemoTrigger.icon, .label].map(\.title),
                            selected: demoTrigger.title
                        ) { selected in
                            switch selected {
                            case DemoTrigger.icon.title: demoTrigger = .icon
                            default: demoTrigger = .label
                            }
                        }

                        LubaDivider()

                        HStack {
                            Spacer()
                            triggerPreview
                            Spacer()
                        }
                        .padding(.vertical, LubaSpacing.sm)
                    }
                }
            }

            DemoSection(title: "View Modifier API") {
                LubaCard(elevation: .flat, style: .outlined, clipsContent: false) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            Text("Password Requirements")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Image(systemName: "info.circle")
                                .font(LubaTypography.bodySmall)
                                .foregroundStyle(LubaColors.textTertiary)
                                .lubaTooltip("Must be 8+ characters, with one number and one special character.")
                        }

                        Text("Attach `.lubaTooltip()` to any view for lightweight, on-demand help.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                }
            }

            DemoSection(title: "Form Context") {
                LubaCard(elevation: .low, clipsContent: false) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            HStack(spacing: LubaSpacing.xs) {
                                Text("API Key")
                                    .font(LubaTypography.custom(size: LubaFieldTokens.labelFontSize, weight: .medium))
                                    .foregroundStyle(LubaColors.textSecondary)

                                LubaTooltip("Your API key can be found in Settings > Developer > API Keys. Keep it secret!") {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textTertiary)
                                }
                            }

                            LubaTextField("", text: .constant(""), placeholder: "sk-...")
                        }

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            HStack(spacing: LubaSpacing.xs) {
                                Text("Webhook URL")
                                    .font(LubaTypography.custom(size: LubaFieldTokens.labelFontSize, weight: .medium))
                                    .foregroundStyle(LubaColors.textSecondary)

                                LubaTooltip("We'll send POST requests to this URL when events occur.", position: .top) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textTertiary)
                                }
                            }

                            LubaTextField("", text: .constant(""), placeholder: "https://...")
                        }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaTooltip(\"Help text\") { Icon }")
                    CopyableCode(code: "view.lubaTooltip(\"Explanation\")")
                    CopyableCode(code: "view.lubaTooltip(\"...\", position: .bottom)")
                }
            }

            // Philosophy
            DemoSection(title: "Help Without Clutter") {
                PhilosophyCard(
                    icon: "lightbulb",
                    title: "Help Without Clutter",
                    description: "Tooltips reveal information on demand. They keep interfaces clean while ensuring no user is left confused. Tap to learn, tap to dismiss — simple."
                )
            }
        }
    }

    @ViewBuilder
    private var triggerPreview: some View {
        switch demoTrigger {
        case .icon:
            LubaTooltip(demoMessageLength.message, position: demoPosition.tooltipPosition) {
                LubaIcon("info.circle", size: .xl, color: LubaColors.accent)
            }
        case .label:
            Text("Tap for help")
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)
                .lubaTooltip(demoMessageLength.message, position: demoPosition.tooltipPosition)
        }
    }

    @ViewBuilder
    private func controlsRow(
        title: String,
        items: [String],
        selected: String,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
            Text(title)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            HStack(spacing: LubaSpacing.sm) {
                ForEach(items, id: \.self) { item in
                    LubaButton(
                        item,
                        style: selected == item ? .primary : .secondary,
                        size: .small
                    ) {
                        onSelect(item)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        TooltipScreen()
    }
}
