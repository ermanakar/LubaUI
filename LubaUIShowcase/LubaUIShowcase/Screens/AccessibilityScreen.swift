//
//  AccessibilityScreen.swift
//  LubaUIShowcase
//
//  Accessibility utilities showcase with live contrast checking and VoiceOver demos.
//

import SwiftUI
import LubaUI

struct AccessibilityScreen: View {
    @State private var announceText = ""

    var body: some View {
        ShowcaseScreen("Accessibility") {
            ShowcaseHeader(
                title: "Accessibility",
                description: "Built-in utilities for VoiceOver, contrast checking, touch targets, and reduced motion support."
            )

            // Built-in A11y
            DemoSection(title: "Component A11y") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("Every LubaUI component includes accessibility out of the box:")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        a11yFeature(icon: "hand.tap.fill", title: "Buttons", desc: "Label, traits, loading/disabled state")
                        a11yFeature(icon: "checkmark.square", title: "Form Controls", desc: "Value (Checked/On/Selected), adjustable sliders")
                        a11yFeature(icon: "bubble.left.fill", title: "Toast", desc: "Style prefix + message for VoiceOver")
                        a11yFeature(icon: "rectangle.dashed", title: "Skeleton", desc: "Hidden from accessibility tree")
                        a11yFeature(icon: "minus", title: "Divider", desc: "Hidden unless labeled")
                    }
                }
            }

            // Contrast Checker
            DemoSection(title: "Contrast Checker") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        contrastRow(
                            name: "textPrimary / background",
                            fg: LubaColors.textPrimary,
                            bg: LubaColors.background
                        )
                        contrastRow(
                            name: "textSecondary / background",
                            fg: LubaColors.textSecondary,
                            bg: LubaColors.background
                        )
                        contrastRow(
                            name: "textTertiary / background",
                            fg: LubaColors.textTertiary,
                            bg: LubaColors.background
                        )
                        contrastRow(
                            name: "accent / background",
                            fg: LubaColors.accent,
                            bg: LubaColors.background
                        )
                        contrastRow(
                            name: "textOnAccent / accent",
                            fg: LubaColors.textOnAccent,
                            bg: LubaColors.accent
                        )
                    }
                }
            }

            // Touch Targets
            DemoSection(title: "Touch Targets") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.xl) {
                            targetDemo(size: 36, label: "36pt", passing: false)
                            targetDemo(size: 44, label: "44pt", passing: true)
                            targetDemo(size: 48, label: "48pt", passing: true)
                        }
                        .frame(maxWidth: .infinity)

                        Text("Apple HIG recommends 44pt minimum. LubaUI enforces this on all interactive components. The accessible preset increases it to 48pt.")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                }
            }

            // VoiceOver
            DemoSection(title: "VoiceOver Announcements") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        Text("LubaAnnounce sends messages to VoiceOver without visual change.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        VStack(spacing: LubaSpacing.sm) {
                            LubaButton("Announce Message", style: .secondary, fullWidth: true) {
                                LubaAnnounce.message("Item saved successfully")
                                announceText = "Sent: \"Item saved successfully\""
                            }

                            LubaButton("Screen Changed", style: .secondary, fullWidth: true) {
                                LubaAnnounce.screenChanged("Settings screen")
                                announceText = "Sent: screenChanged(\"Settings screen\")"
                            }

                            LubaButton("Layout Changed", style: .secondary, fullWidth: true) {
                                LubaAnnounce.layoutChanged()
                                announceText = "Sent: layoutChanged()"
                            }
                        }

                        if !announceText.isEmpty {
                            Text(announceText)
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }

            // Modifiers
            DemoSection(title: "Accessibility Modifiers") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        modifierRow(name: ".lubaAccessible(label:hint:traits:)", desc: "Standard a11y config")
                        LubaDivider()
                        modifierRow(name: ".lubaAccessibleButton(\"Save\")", desc: "Button trait shorthand")
                        LubaDivider()
                        modifierRow(name: ".lubaAccessibleHeader(\"Section\")", desc: "Header trait shorthand")
                        LubaDivider()
                        modifierRow(name: ".lubaMinTouchTarget()", desc: "Enforce 44pt minimum")
                        LubaDivider()
                        modifierRow(name: "LubaReducedMotion.safe", desc: "Config-aware animation")
                    }
                }
            }

            // Reduced Motion
            DemoSection(title: "Reduced Motion") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("LubaUI respects reduced motion at two levels:")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        HStack(alignment: .top, spacing: LubaSpacing.md) {
                            LubaCircledIcon("gearshape", size: .sm, style: .subtle)
                            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                Text("LubaConfig.animationsEnabled")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("App-level toggle. All components check this before animating.")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }

                        HStack(alignment: .top, spacing: LubaSpacing.md) {
                            LubaCircledIcon("accessibility", size: .sm, style: .subtle)
                            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                Text("System Reduce Motion")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("When respectReducedMotion is true (default), system settings override.")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                        }
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "accessibility",
                title: "No One Left Behind",
                description: "Accessibility isn't an afterthought — it's built into every component. Touch targets, contrast ratios, VoiceOver labels, and reduced motion are all handled automatically. Your app is accessible by default."
            )
        }
    }

    // MARK: - Components

    private func a11yFeature(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(desc)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textTertiary)
            }
            Spacer()
        }
    }

    private func contrastRow(name: String, fg: Color, bg: Color) -> some View {
        let ratio = LubaContrast.contrastRatio(foreground: fg, background: bg)
        let passesAA = LubaContrast.meetsAA(foreground: fg, background: bg)
        let passesAAA = LubaContrast.meetsAAA(foreground: fg, background: bg)

        return HStack(spacing: LubaSpacing.md) {
            ZStack {
                RoundedRectangle.luba(LubaRadius.sm)
                    .fill(bg)
                    .frame(width: 36, height: 36)
                    .overlay(
                        RoundedRectangle.luba(LubaRadius.sm)
                            .strokeBorder(LubaColors.border, lineWidth: 1)
                    )
                Text("Aa")
                    .font(LubaTypography.headline)
                    .foregroundStyle(fg)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(String(format: "%.1f:1", ratio))
                    .font(LubaTypography.code)
                    .foregroundStyle(LubaColors.textTertiary)
            }

            Spacer()

            HStack(spacing: LubaSpacing.xs) {
                resultBadge("AA", passes: passesAA)
                resultBadge("AAA", passes: passesAAA)
            }
        }
    }

    private func resultBadge(_ level: String, passes: Bool) -> some View {
        Text(level)
            .font(LubaTypography.caption)
            .foregroundStyle(passes ? LubaColors.success : LubaColors.error)
            .padding(.horizontal, LubaSpacing.sm)
            .padding(.vertical, 2)
            .background(passes ? LubaColors.success.opacity(0.1) : LubaColors.error.opacity(0.1))
            .clipShape(Capsule())
    }

    private func targetDemo(size: CGFloat, label: String, passing: Bool) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            ZStack {
                RoundedRectangle.luba(LubaRadius.sm)
                    .strokeBorder(
                        passing ? LubaColors.success : LubaColors.error,
                        style: StrokeStyle(lineWidth: 1.5, dash: passing ? [] : [4])
                    )
                    .frame(width: size, height: size)

                Image(systemName: "hand.tap")
                    .font(.system(size: 16))
                    .foregroundStyle(passing ? LubaColors.success : LubaColors.error)
            }

            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(passing ? LubaColors.success : LubaColors.error)
        }
    }

    private func modifierRow(name: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
            Text(name)
                .font(LubaTypography.code)
                .foregroundStyle(LubaColors.accent)
            Text(desc)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
    }
}

#Preview {
    NavigationStack {
        AccessibilityScreen()
    }
}
