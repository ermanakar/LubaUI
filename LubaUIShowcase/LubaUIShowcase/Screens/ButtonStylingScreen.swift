//
//  ButtonStylingScreen.swift
//  LubaUIShowcase
//
//  ButtonStyling primitive showcase — protocol-based button styling system.
//

import SwiftUI
import LubaUI

// MARK: - Custom Style Example

/// A custom brand style demonstrating the protocol.
struct BrandPurpleStyle: LubaButtonStyling {
    func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        .white
    }

    func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? Color.purple.opacity(0.8) : Color.purple
    }

    func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        nil
    }

    var defaultsToFullWidth: Bool { true }
    var haptic: LubaHapticStyle { .medium }
}

/// Outlined accent style.
struct AccentOutlinedStyle: LubaButtonStyling {
    func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.accentHover : LubaColors.accent
    }

    func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color {
        isPressed ? LubaColors.accentSubtle : .clear
    }

    func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? {
        LubaColors.accent
    }

    var haptic: LubaHapticStyle { .light }
}

// MARK: - Screen

struct ButtonStylingScreen: View {
    var body: some View {
        ShowcaseScreen("Button Styling") {
            // Header
            ShowcaseHeader(
                title: "Button Styling",
                description: "Protocol-based styling extracts appearance into reusable, type-safe definitions."
            )

            // Philosophy
            DemoSection(title: "Radical Composability") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("lightbulb.fill", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Styles as Values")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Instead of switch statements scattered across components, each style is a self-contained struct. Create new styles by implementing one protocol — no touching button internals.")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }

            // Built-in Styles
            DemoSection(title: "Built-in Styles") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        styleRow("Primary", "LubaPrimaryStyle()", .primary)
                        LubaDivider()
                        styleRow("Secondary", "LubaSecondaryStyle()", .secondary)
                        LubaDivider()
                        styleRow("Ghost", "LubaGhostStyle()", .ghost)
                        LubaDivider()
                        styleRow("Destructive", "LubaDestructiveStyle()", .destructive)
                        LubaDivider()
                        styleRow("Subtle", "LubaSubtleStyle()", .subtle)
                    }
                }
            }

            // Custom Styles
            DemoSection(title: "Custom Styles") {
                VStack(spacing: LubaSpacing.md) {
                    LubaButton("Brand Purple", styling: BrandPurpleStyle()) { }

                    LubaButton("Accent Outlined", styling: AccentOutlinedStyle()) { }

                    Text("Custom styles implement LubaButtonStyling protocol")
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // Protocol Definition
            DemoSection(title: "The Protocol") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        codeSnippet("protocol LubaButtonStyling {")
                        codeSnippet("    func foregroundColor(...) -> Color")
                        codeSnippet("    func backgroundColor(...) -> Color")
                        codeSnippet("    func borderColor(...) -> Color?")
                        codeSnippet("    var borderWidth: CGFloat { get }")
                        codeSnippet("    var defaultsToFullWidth: Bool { get }")
                        codeSnippet("    var haptic: LubaHapticStyle { get }")
                        codeSnippet("}")
                    }
                }
            }

            // Usage Example
            DemoSection(title: "Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("// Using enum (quick access)")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("LubaButton(\"Save\", style: .primary) { }")
                            .foregroundStyle(LubaColors.accent)

                        LubaDivider()
                            .padding(.vertical, LubaSpacing.sm)

                        Text("// Using struct (type-safe)")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("LubaButton(\"Save\", styling: LubaPrimaryStyle()) { }")
                            .foregroundStyle(LubaColors.accent)

                        LubaDivider()
                            .padding(.vertical, LubaSpacing.sm)

                        Text("// Custom style")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("LubaButton(\"Save\", styling: MyBrandStyle()) { }")
                            .foregroundStyle(LubaColors.accent)
                    }
                    .font(.system(size: 13, design: .monospaced))
                }
            }

            // Creating Custom Style
            DemoSection(title: "Creating a Custom Style") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        codeSnippet("struct MyBrandStyle: LubaButtonStyling {")
                        codeSnippet("    func foregroundColor(...) -> Color {")
                        codeSnippet("        .white")
                        codeSnippet("    }")
                        codeSnippet("")
                        codeSnippet("    func backgroundColor(...) -> Color {")
                        codeSnippet("        isPressed ? brandColor.opacity(0.8)")
                        codeSnippet("                  : brandColor")
                        codeSnippet("    }")
                        codeSnippet("")
                        codeSnippet("    func borderColor(...) -> Color? { nil }")
                        codeSnippet("}")
                    }
                }
            }
        }
    }

    // MARK: - Components

    private func styleRow(_ name: String, _ code: String, _ style: LubaButtonStyle) -> some View {
        HStack(spacing: LubaSpacing.md) {
            Text(name)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)
                .frame(width: 90, alignment: .leading)

            LubaButton("Tap", style: style, size: .small) { }

            Spacer()

            Text(code)
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(LubaColors.textTertiary)
                .lineLimit(1)
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
        ButtonStylingScreen()
    }
}
