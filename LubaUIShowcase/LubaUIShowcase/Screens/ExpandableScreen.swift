//
//  ExpandableScreen.swift
//  LubaUIShowcase
//
//  Showcases the LubaExpandable primitive.
//

import SwiftUI
import LubaUI

struct ExpandableScreen: View {
    @State private var isBasicExpanded = false
    @State private var isCardExpanded = true
    @State private var isModifierExpanded = false

    private let faqItems: [LubaAccordionItem] = [
        LubaAccordionItem(
            title: "What is LubaUI?",
            content: "LubaUI is a modern SwiftUI design system with design tokens, theming, and reusable components. It's built with radical composability in mind.",
            icon: "questionmark.circle"
        ),
        LubaAccordionItem(
            title: "How do I install it?",
            content: "Add LubaUI as a Swift Package dependency using the repository URL. It supports iOS 16+, macOS 13+, and other Apple platforms.",
            icon: "arrow.down.circle"
        ),
        LubaAccordionItem(
            title: "Is it customizable?",
            content: "Yes! LubaUI uses design tokens for colors, spacing, typography, and motion. You can customize the theme to match your brand.",
            icon: "paintbrush"
        )
    ]

    var body: some View {
        ShowcaseScreen("Expandable") {
            ShowcaseHeader(
                title: "Expandable",
                description: "Expand and collapse content with smooth spring animations. Compose disclosure behavior onto any view."
            )

            // Basic Expandable
            DemoSection(title: "Basic Expandable") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaExpandable(isExpanded: $isBasicExpanded) {
                        HStack(spacing: LubaSpacing.md) {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(LubaColors.accent)
                            Text("Tap to expand")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                        }
                    } content: {
                        VStack(spacing: 0) {
                            LubaDivider()
                                .padding(.vertical, LubaSpacing.sm)

                            Text("This content was hidden and is now revealed. The animation uses a spring for a natural feel.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }

            // Expandable Card
            DemoSection(title: "Expandable Card") {
                LubaExpandableCard(isExpanded: $isCardExpanded, elevation: .low) {
                    HStack(spacing: LubaSpacing.md) {
                        LubaAvatar(name: "Settings", size: .small)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Advanced Settings")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("Tap to \(isCardExpanded ? "hide" : "show") options")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                } content: {
                    VStack(spacing: LubaSpacing.md) {
                        settingRow(title: "Notifications", isOn: true)
                        settingRow(title: "Dark Mode", isOn: false)
                        settingRow(title: "Haptics", isOn: true)
                    }
                }
            }

            // Accordion
            DemoSection(title: "Accordion (FAQ)") {
                LubaAccordion(items: faqItems)
            }

            // Modifier Usage
            DemoSection(title: "Modifier Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: 0) {
                        Button {
                            withAnimation(LubaExpandTokens.animation) {
                                isModifierExpanded.toggle()
                            }
                        } label: {
                            HStack {
                                Text("Show Details")
                                    .font(LubaTypography.body)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(isModifierExpanded ? 180 : 0))
                                    .foregroundStyle(LubaColors.textTertiary)
                                    .animation(LubaExpandTokens.chevronAnimation, value: isModifierExpanded)
                            }
                        }
                        .buttonStyle(.plain)
                        .lubaExpandable(isExpanded: $isModifierExpanded) {
                            VStack(spacing: 0) {
                                LubaDivider()
                                    .padding(.vertical, LubaSpacing.sm)

                                Text("Using .lubaExpandable() modifier")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                        }
                    }
                }
            }

            // Philosophy
            DemoSection(title: "The Pattern") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            Image(systemName: "rectangle.expand.vertical")
                                .foregroundStyle(LubaColors.accent)
                            Text("Disclosure Composition")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                        }

                        Text("The expandable primitive extracts reveal/hide behavior with smooth spring animations. Use the view for full control, or the modifier for quick additions.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            codeSnippet("// Component approach")
                            codeSnippet("LubaExpandable(isExpanded: $open) {")
                            codeSnippet("    Header()")
                            codeSnippet("} content: { Body() }")

                            Text("")

                            codeSnippet("// Modifier approach")
                            codeSnippet("Header()")
                            codeSnippet("    .lubaExpandable(isExpanded: $open) {")
                            codeSnippet("        Body()")
                            codeSnippet("    }")
                        }
                    }
                }
            }

            // Token Reference
            DemoSection(title: "Expand Tokens") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        tokenRow("Animation", "spring(0.35, 0.8)")
                        LubaDivider()
                        tokenRow("Chevron anim", "spring(0.25, 0.7)")
                        LubaDivider()
                        tokenRow("Default icon", "chevron.down")
                    }
                }
            }
        }
    }

    // MARK: - Setting Row

    private func settingRow(title: String, isOn: Bool) -> some View {
        HStack {
            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)
            Spacer()
            LubaToggle(isOn: .constant(isOn))
        }
    }


    private func tokenRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(LubaColors.accent)
        }
    }

    private func codeSnippet(_ code: String) -> some View {
        Text(code)
            .font(.system(size: 12, weight: .medium, design: .monospaced))
            .foregroundStyle(LubaColors.accent)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ExpandableScreen()
    }
}
