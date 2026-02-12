//
//  RadiusScreen.swift
//  LubaUIShowcase
//
//  Radius token showcase with visual comparisons and real-world examples.
//

import SwiftUI
import LubaUI

struct RadiusScreen: View {
    var body: some View {
        ShowcaseScreen("Radius") {
            ShowcaseHeader(
                title: "Radius",
                description: "Continuous corner radius tokens — from sharp edges to full pills — for consistent roundness everywhere."
            )

            // Token Scale
            DemoSection(title: "Scale") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        radiusRow(name: "none", value: LubaRadius.none, usage: "Sharp corners")
                        LubaDivider()
                        radiusRow(name: "xs", value: LubaRadius.xs, usage: "Inputs, small elements")
                        LubaDivider()
                        radiusRow(name: "sm", value: LubaRadius.sm, usage: "Buttons, tags")
                        LubaDivider()
                        radiusRow(name: "md", value: LubaRadius.md, usage: "Cards, modals")
                        LubaDivider()
                        radiusRow(name: "lg", value: LubaRadius.lg, usage: "Prominent cards")
                        LubaDivider()
                        radiusRow(name: "xl", value: LubaRadius.xl, usage: "Modal sheets")
                        LubaDivider()
                        radiusRow(name: "full", value: LubaRadius.full, usage: "Pill shapes")
                    }
                }
            }

            // Visual Comparison
            DemoSection(title: "Visual Comparison") {
                LubaCard(elevation: .flat, style: .outlined) {
                    let tokens: [(String, CGFloat)] = [
                        ("none", LubaRadius.none),
                        ("xs", LubaRadius.xs),
                        ("sm", LubaRadius.sm),
                        ("md", LubaRadius.md),
                        ("lg", LubaRadius.lg),
                        ("xl", LubaRadius.xl),
                        ("full", LubaRadius.full)
                    ]

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: LubaSpacing.md) {
                        ForEach(tokens, id: \.0) { name, radius in
                            VStack(spacing: LubaSpacing.sm) {
                                RoundedRectangle(cornerRadius: radius, style: .continuous)
                                    .fill(LubaColors.accent.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                                            .strokeBorder(LubaColors.accent, lineWidth: 1.5)
                                    )
                                    .frame(height: 56)

                                Text(name)
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }
                    }
                }
            }

            // Continuous vs. Circular
            DemoSection(title: "Continuous Corners") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.xl) {
                            VStack(spacing: LubaSpacing.sm) {
                                RoundedRectangle(cornerRadius: LubaRadius.lg, style: .continuous)
                                    .fill(LubaColors.accent)
                                    .frame(width: 80, height: 80)

                                Text("Continuous")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textPrimary)

                                Text("LubaUI default")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }

                            VStack(spacing: LubaSpacing.sm) {
                                RoundedRectangle(cornerRadius: LubaRadius.lg, style: .circular)
                                    .fill(LubaColors.gray400)
                                    .frame(width: 80, height: 80)

                                Text("Circular")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textPrimary)

                                Text("Standard CSS")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Text("Continuous (superellipse) corners create smoother, more natural curves — the same approach Apple uses for app icons.")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }

            // Real-World: Button Radii
            DemoSection(title: "Button Styles Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        buttonExample(label: "Sharp (none)", radius: LubaRadius.none)
                        buttonExample(label: "Subtle (xs)", radius: LubaRadius.xs)
                        buttonExample(label: "Standard (sm)", radius: LubaRadius.sm)
                        buttonExample(label: "Rounded (md)", radius: LubaRadius.md)
                        buttonExample(label: "Pill (full)", radius: LubaRadius.full)
                    }
                }
            }

            // Real-World: Card Radii
            DemoSection(title: "Card Variants Example") {
                VStack(spacing: LubaSpacing.md) {
                    cardExample(title: "Compact Card", subtitle: "Uses sm radius for tight layouts", radius: LubaRadius.sm)
                    cardExample(title: "Standard Card", subtitle: "Uses md radius — the default", radius: LubaRadius.md)
                    cardExample(title: "Hero Card", subtitle: "Uses xl radius for maximum presence", radius: LubaRadius.xl)
                }
            }

            // Real-World: Nested Radii
            DemoSection(title: "Nested Radii Example") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("Outer: xl · Inner: md · Badge: full")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)

                        VStack(spacing: LubaSpacing.md) {
                            RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous)
                                .fill(LubaColors.surfaceSecondary)
                                .frame(height: 120)
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 28))
                                        .foregroundStyle(LubaColors.gray400)
                                )

                            HStack {
                                VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                    Text("Featured Item")
                                        .font(LubaTypography.headline)
                                        .foregroundStyle(LubaColors.textPrimary)
                                    Text("Radius tokens nest naturally")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textSecondary)
                                }

                                Spacer()

                                Text("New")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, LubaSpacing.sm)
                                    .padding(.vertical, LubaSpacing.xs)
                                    .background(LubaColors.accent)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }

            // Helpers
            DemoSection(title: "Convenience Helpers") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Shape Helper")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("RoundedRectangle.luba(.md)")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("View Modifier")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text(".lubaCornerRadius(.lg)")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "circle.square",
                title: "Why Continuous Corners?",
                description: "Continuous (superellipse) corners feel more organic and premium than circular arcs. They're the same curves Apple uses for app icons and hardware — and they make your UI feel native."
            )
        }
    }

    // MARK: - Components

    private func radiusRow(name: String, value: CGFloat, usage: String) -> some View {
        HStack(spacing: LubaSpacing.md) {
            RoundedRectangle(cornerRadius: value, style: .continuous)
                .fill(LubaColors.accent)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(usage)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textTertiary)
            }

            Spacer()

            Text("\(Int(value))pt")
                .font(LubaTypography.code)
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(LubaSpacing.lg)
        .background(LubaColors.surface)
    }

    private func buttonExample(label: String, radius: CGFloat) -> some View {
        HStack {
            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)

            Spacer()

            Text("Button")
                .font(LubaTypography.button)
                .foregroundStyle(.white)
                .padding(.horizontal, LubaSpacing.lg)
                .padding(.vertical, LubaSpacing.sm)
                .background(LubaColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
    }

    private func cardExample(title: String, subtitle: String, radius: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
            Text(title)
                .font(LubaTypography.headline)
                .foregroundStyle(LubaColors.textPrimary)
            Text(subtitle)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(LubaSpacing.lg)
        .background(LubaColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(LubaColors.border, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        RadiusScreen()
    }
}
