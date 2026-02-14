//
//  IconsScreen.swift
//  LubaUIShowcase
//
//  Icons showcase with sizes, colors, buttons, and real-world examples.
//

import SwiftUI
import LubaUI

struct IconsScreen: View {
    var body: some View {
        ShowcaseScreen("Icons") {
            ShowcaseHeader(
                title: "Icons",
                description: "SF Symbols with consistent sizing, semantic colors, and 44pt touch targets."
            )

            // Size Scale
            DemoSection(title: "Size Scale") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.xl) {
                        ForEach(LubaIconSize.allCases, id: \.dimension) { iconSize in
                            VStack(spacing: LubaSpacing.sm) {
                                LubaIcon("heart.fill", size: iconSize, color: LubaColors.accent)
                                Text("\(Int(iconSize.dimension))pt")
                                    .font(LubaTypography.custom(size: 11, weight: .regular, design: .monospaced))
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Semantic Colors
            DemoSection(title: "Semantic Colors") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.xxl) {
                        VStack(spacing: LubaSpacing.sm) {
                            LubaIcon("checkmark.circle.fill", size: .lg, color: LubaColors.success)
                            Text("Success")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaIcon("exclamationmark.triangle.fill", size: .lg, color: LubaColors.warning)
                            Text("Warning")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaIcon("xmark.circle.fill", size: .lg, color: LubaColors.error)
                            Text("Error")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaIcon("info.circle.fill", size: .lg, color: LubaColors.accent)
                            Text("Info")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Icon Buttons
            DemoSection(title: "Icon Buttons") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            LubaIconButton("bell") { }
                            LubaIconButton("gear") { }
                            LubaIconButton("magnifyingglass") { }
                            LubaIconButton("plus") { }
                            LubaIconButton("ellipsis") { }
                        }

                        Text("44pt touch target with haptic feedback")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Circled Icons
            DemoSection(title: "Circled Icons") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.xl) {
                            VStack(spacing: LubaSpacing.sm) {
                                LubaCircledIcon("envelope", size: .lg, style: .filled)
                                Text("Filled")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }

                            VStack(spacing: LubaSpacing.sm) {
                                LubaCircledIcon("heart", size: .lg, style: .subtle)
                                Text("Subtle")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }

                            VStack(spacing: LubaSpacing.sm) {
                                LubaCircledIcon("star", size: .lg, style: .neutral)
                                Text("Neutral")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        HStack(spacing: LubaSpacing.lg) {
                            LubaCircledIcon("person", size: .sm, style: .subtle)
                            LubaCircledIcon("person", size: .md, style: .subtle)
                            LubaCircledIcon("person", size: .lg, style: .subtle)
                        }
                    }
                }
            }

            // Real-World: Navigation Bar
            DemoSection(title: "Navigation Bar Example") {
                LubaCard(elevation: .low) {
                    HStack {
                        LubaIconButton("chevron.left") { }

                        Spacer()

                        Text("Settings")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)

                        Spacer()

                        LubaIconButton("ellipsis") { }
                    }
                }
            }

            // Real-World: Toolbar
            DemoSection(title: "Toolbar Example") {
                LubaCard(elevation: .low) {
                    HStack(spacing: LubaSpacing.sm) {
                        LubaIconButton("bold") { }
                        LubaIconButton("italic") { }
                        LubaIconButton("underline") { }

                        LubaDivider(orientation: .vertical)
                            .frame(height: 24)

                        LubaIconButton("list.bullet") { }
                        LubaIconButton("list.number") { }

                        Spacer()

                        LubaIconButton("photo") { }
                        LubaIconButton("link") { }
                    }
                }
            }

            // Real-World: Feature List
            DemoSection(title: "Feature List Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        featureRow(icon: "bell.fill", title: "Notifications", subtitle: "Get notified about updates")
                        LubaDivider()
                        featureRow(icon: "lock.fill", title: "Privacy", subtitle: "Control your data")
                        LubaDivider()
                        featureRow(icon: "paintbrush.fill", title: "Appearance", subtitle: "Customize the look")
                    }
                }
            }

            // SF Symbols Note
            DemoSection(title: "About SF Symbols") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("info.circle.fill", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("SF Symbols")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Icons are from Apple's SF Symbols library. Browse 5,000+ icons at developer.apple.com/sf-symbols")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .md, style: .subtle)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(subtitle)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(LubaTypography.custom(size: 12, weight: .semibold))
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

}

#Preview {
    NavigationStack {
        IconsScreen()
    }
}
