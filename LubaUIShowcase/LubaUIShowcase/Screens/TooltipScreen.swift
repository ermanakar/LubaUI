//
//  TooltipScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaTooltip contextual help.
//

import SwiftUI
import LubaUI

struct TooltipScreen: View {
    var body: some View {
        ShowcaseScreen("Tooltip") {
            ShowcaseHeader(
                title: "Tooltip",
                description: "Contextual help that appears on tap. Perfect for explaining form fields, icons, or unfamiliar concepts."
            )

            // Basic
            DemoSection(title: "Tap to Show") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.xl) {
                        VStack(spacing: LubaSpacing.sm) {
                            LubaTooltip("This tooltip appears above the icon.") {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 24))
                                    .foregroundStyle(LubaColors.accent)
                            }
                            Text("Top")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaTooltip("This tooltip appears below the icon.", position: .bottom) {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 24))
                                    .foregroundStyle(LubaColors.accent)
                            }
                            Text("Bottom")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, LubaSpacing.xl)
                }
            }

            // View Modifier
            DemoSection(title: "View Modifier API") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.sm) {
                            Text("Password Requirements")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundStyle(LubaColors.textTertiary)
                                .lubaTooltip("Must be 8+ characters with at least one number and one special character.")
                        }

                        Text("Use .lubaTooltip() on any view.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                }
            }

            // Form Help
            DemoSection(title: "Form Context") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            HStack(spacing: LubaSpacing.xs) {
                                Text("API Key")
                                    .font(.system(size: LubaFieldTokens.labelFontSize, weight: .medium, design: .rounded))
                                    .foregroundStyle(LubaColors.textSecondary)

                                LubaTooltip("Your API key can be found in Settings > Developer > API Keys. Keep it secret!") {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(LubaColors.textTertiary)
                                }
                            }

                            LubaTextField("", text: .constant(""), placeholder: "sk-...")
                        }

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            HStack(spacing: LubaSpacing.xs) {
                                Text("Webhook URL")
                                    .font(.system(size: LubaFieldTokens.labelFontSize, weight: .medium, design: .rounded))
                                    .foregroundStyle(LubaColors.textSecondary)

                                LubaTooltip("We'll send POST requests to this URL when events occur.", position: .bottom) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.system(size: 12))
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

            PhilosophyCard(
                icon: "lightbulb",
                title: "Help Without Clutter",
                description: "Tooltips reveal information on demand. They keep interfaces clean while ensuring no user is left confused. Tap to learn, tap to dismiss — simple."
            )
        }
    }
}

#Preview {
    NavigationStack {
        TooltipScreen()
    }
}
