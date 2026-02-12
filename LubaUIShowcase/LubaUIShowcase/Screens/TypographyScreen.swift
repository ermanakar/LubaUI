//
//  TypographyScreen.swift
//  LubaUIShowcase
//
//  Typography showcase with the full type scale and real-world examples.
//

import SwiftUI
import LubaUI

struct TypographyScreen: View {
    var body: some View {
        ShowcaseScreen("Typography") {
            ShowcaseHeader(
                title: "Typography",
                description: "SF Rounded for a friendly, approachable, premium feel across your entire interface."
            )

            // Display
            DemoSection(title: "Display") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        typeSample(name: "Large Title", font: LubaTypography.largeTitle, size: "34pt Bold")
                        LubaDivider()
                        typeSample(name: "Title", font: LubaTypography.title, size: "26pt Bold")
                        LubaDivider()
                        typeSample(name: "Title 2", font: LubaTypography.title2, size: "20pt Semibold")
                        LubaDivider()
                        typeSample(name: "Title 3", font: LubaTypography.title3, size: "17pt Semibold")
                    }
                }
            }

            // Body & Headings
            DemoSection(title: "Body & Headings") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        typeSample(name: "Headline", font: LubaTypography.headline, size: "16pt Semibold")
                        LubaDivider()
                        typeSample(name: "Subheadline", font: LubaTypography.subheadline, size: "14pt Medium")
                        LubaDivider()
                        typeSample(name: "Body", font: LubaTypography.body, size: "16pt Regular")
                        LubaDivider()
                        typeSample(name: "Body Small", font: LubaTypography.bodySmall, size: "14pt Regular")
                    }
                }
            }

            // Supporting
            DemoSection(title: "Supporting") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        typeSample(name: "Caption", font: LubaTypography.caption, size: "12pt Regular")
                        LubaDivider()
                        typeSample(name: "Footnote", font: LubaTypography.footnote, size: "13pt Regular")
                        LubaDivider()
                        typeSample(name: "Code", font: LubaTypography.code, size: "13pt Mono")
                    }
                }
            }

            // Real-World: Article Card
            DemoSection(title: "Article Card Example") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        // Image placeholder
                        RoundedRectangle(cornerRadius: LubaRadius.md)
                            .fill(LubaColors.gray200)
                            .frame(height: 160)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 32))
                                    .foregroundStyle(LubaColors.gray400)
                            )

                        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                            HStack(spacing: LubaSpacing.sm) {
                                LubaBadge("Design", style: .subtle, size: .small)
                                Text("5 min read")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }

                            Text("The Art of Typography")
                                .font(LubaTypography.title2)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Typography is the art and technique of arranging type to make written language legible, readable and appealing.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                                .lineSpacing(4)

                            HStack(spacing: LubaSpacing.md) {
                                LubaAvatar(name: "Jane Doe", size: .small)

                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Jane Doe")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textPrimary)
                                    Text("Mar 15, 2024")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textTertiary)
                                }
                            }
                        }
                    }
                }
            }

            // Real-World: Message Thread
            DemoSection(title: "Message Thread Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        // Header
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Sarah Chen", size: .medium)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sarah Chen")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Online")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.success)
                            }

                            Spacer()

                            LubaIconButton("ellipsis") { }
                        }

                        LubaDivider()

                        // Messages
                        VStack(alignment: .leading, spacing: LubaSpacing.md) {
                            messageBubble(text: "Hey! How's the design system coming along?", isOutgoing: false)
                            messageBubble(text: "Really well! Just finished the typography scale.", isOutgoing: true)
                            messageBubble(text: "SF Rounded looks so good", isOutgoing: false)
                        }
                    }
                }
            }

            // Real-World: Pricing
            DemoSection(title: "Pricing Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(spacing: LubaSpacing.xs) {
                            Text("PRO")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.accent)
                                .tracking(2)

                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("$29")
                                    .font(LubaTypography.largeTitle)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("/month")
                                    .font(LubaTypography.body)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Text("Everything you need to ship faster")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                        }

                        LubaButton("Get Started", style: .primary, fullWidth: true) { }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Philosophy
            DemoSection(title: "Why SF Rounded?") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("textformat", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Friendly & Approachable")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("SF Rounded softens the edges while maintaining excellent legibility. It feels modern and welcoming — perfect for apps that prioritize user experience.")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func typeSample(name: String, font: Font, size: String) -> some View {
        HStack {
            Text(name)
                .font(font)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            Text(size)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(LubaSpacing.lg)
        .background(LubaColors.surface)
    }

    private func messageBubble(text: String, isOutgoing: Bool) -> some View {
        HStack {
            if isOutgoing { Spacer() }

            Text(text)
                .font(LubaTypography.body)
                .foregroundStyle(isOutgoing ? .white : LubaColors.textPrimary)
                .padding(.horizontal, LubaSpacing.md)
                .padding(.vertical, LubaSpacing.sm)
                .background(isOutgoing ? LubaColors.accent : LubaColors.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md))

            if !isOutgoing { Spacer() }
        }
    }

}

#Preview {
    NavigationStack {
        TypographyScreen()
    }
}
