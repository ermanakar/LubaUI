//
//  GlassScreen.swift
//  LubaUIShowcase
//
//  Glass primitive showcase — frosted glass effects for any view.
//

import SwiftUI
import LubaUI

struct GlassScreen: View {
    var body: some View {
        ShowcaseScreen("Glass") {
            ShowcaseHeader(
                title: "Glass",
                description: "Apply frosted glass effects to any view. Uses SwiftUI materials on iOS 16-25 and will use native Liquid Glass on iOS 26+."
            )

            // Glass Styles
            DemoSection(title: "Glass Styles") {
                ZStack {
                    gradientBackground
                        .frame(height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))

                    VStack(spacing: LubaSpacing.md) {
                        glassStyleDemo("Subtle", subtitle: "Toolbar overlays, FABs", style: .subtle)
                        glassStyleDemo("Regular", subtitle: "Cards, tab bars, sheets", style: .regular)
                        glassStyleDemo("Prominent", subtitle: "Panels, modal backgrounds", style: .prominent)
                    }
                    .padding(LubaSpacing.lg)
                }
            }

            // Tinted Glass
            DemoSection(title: "Tinted Glass") {
                ZStack {
                    gradientBackground
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))

                    VStack(spacing: LubaSpacing.md) {
                        tintDemo("Accent", tint: LubaColors.accent)
                        tintDemo("Success", tint: LubaColors.success)
                        tintDemo("Warning", tint: LubaColors.warning)
                    }
                    .padding(LubaSpacing.lg)
                }
            }

            // Glass Card
            DemoSection(title: "Glass Card") {
                ZStack {
                    gradientBackground
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))

                    LubaCard(style: .glass) {
                        HStack {
                            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                Text("Glass Card")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("LubaCard(style: .glass)")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "sparkles")
                                .font(.system(size: 24))
                                .foregroundStyle(LubaColors.accent)
                        }
                    }
                    .padding(LubaSpacing.lg)
                }
            }

            // Glass Button
            DemoSection(title: "Glass Button") {
                ZStack {
                    gradientBackground
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))

                    HStack(spacing: LubaSpacing.md) {
                        LubaButton("Glass", style: .glass) { }
                        LubaButton("Glass + Icon", style: .glass, icon: Image(systemName: "star.fill")) { }
                    }
                    .padding(LubaSpacing.lg)
                }
            }

            // Glass Toast
            DemoSection(title: "Glass Toast") {
                ZStack {
                    gradientBackground
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))

                    VStack(spacing: LubaSpacing.sm) {
                        LubaToast("Saved successfully", style: .success, useGlass: true)
                        LubaToast("Connection lost", style: .error, useGlass: true)
                    }
                    .padding(LubaSpacing.lg)
                }
            }

            // Glass Alert
            DemoSection(title: "Glass Alert") {
                ZStack {
                    gradientBackground
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))

                    VStack(spacing: LubaSpacing.sm) {
                        LubaAlert("Your trial expires in 3 days.", style: .warning, useGlass: true)
                        LubaAlert("Connected to server.", style: .info, useGlass: true)
                    }
                    .padding(LubaSpacing.lg)
                }
            }

            // Accessibility
            DemoSection(title: "Accessibility") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("accessibility", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Solid Fallback")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("When Reduce Transparency or High Contrast Mode is active, glass automatically falls back to a solid opaque surface with a visible border.")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }

            // iOS 26+ Readiness
            DemoSection(title: "iOS 26+ Ready") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("sparkles", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Native Liquid Glass")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("When compiled with Xcode 26 SDK, .lubaGlass() will automatically use Apple's native .glassEffect() API with lensing, highlights, and motion-responsive illumination.")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }

            // Code Example
            DemoSection(title: "Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("// Basic glass")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("Text(\"Hello\").padding()")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaGlass()")
                            .foregroundStyle(LubaColors.accent)

                        LubaDivider()
                            .padding(.vertical, LubaSpacing.sm)

                        Text("// Tinted glass")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("VStack { content }")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaGlass(.subtle, tint: .blue)")
                            .foregroundStyle(LubaColors.accent)

                        LubaDivider()
                            .padding(.vertical, LubaSpacing.sm)

                        Text("// Glass card")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("LubaCard(style: .glass) {")
                            .foregroundStyle(LubaColors.accent)
                        Text("    Text(\"Content\")")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("}")
                            .foregroundStyle(LubaColors.accent)
                    }
                    .font(LubaTypography.code)
                }
            }
        }
    }

    // MARK: - Helpers

    private var gradientBackground: some View {
        LinearGradient(
            colors: [
                Color(hex: 0x6B8068),
                Color(hex: 0x3D5A3E),
                Color(hex: 0x8FB58C)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func glassStyleDemo(_ title: String, subtitle: String, style: LubaGlassStyle) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(LubaTypography.headline)
                    .foregroundStyle(LubaColors.textPrimary)
                Text(subtitle)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }
            Spacer()
        }
        .padding(LubaSpacing.md)
        .lubaGlass(style)
    }

    private func tintDemo(_ title: String, tint: Color) -> some View {
        HStack {
            Text(title)
                .font(LubaTypography.headline)
                .foregroundStyle(LubaColors.textPrimary)
            Spacer()
        }
        .padding(LubaSpacing.md)
        .lubaGlass(.regular, tint: tint)
    }
}

#Preview {
    NavigationStack {
        GlassScreen()
    }
}
