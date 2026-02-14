//
//  ShimmerableScreen.swift
//  LubaUIShowcase
//
//  Shimmerable primitive showcase — apply loading shimmer to any view.
//

import SwiftUI
import LubaUI

struct ShimmerableScreen: View {
    @State private var isLoading = true

    var body: some View {
        ShowcaseScreen("Shimmerable") {
            ShowcaseHeader(
                title: "Shimmerable",
                description: "Apply a loading shimmer effect to any view — not just skeletons. The shimmer travels across your content."
            )

            // Toggle
            DemoSection(title: "Toggle Loading") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaToggle(isOn: $isLoading, label: "Show shimmer")
                }
            }

            // Basic Shimmer Overlay
            DemoSection(title: "Shimmer Overlay") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        RoundedRectangle(cornerRadius: LubaRadius.md)
                            .fill(LubaColors.gray200)
                            .frame(height: 120)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 32))
                                    .foregroundStyle(LubaColors.gray400)
                            )
                            .lubaShimmerable(isLoading: isLoading)

                        Text("Shimmer overlays your content while loading")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Redacted Shimmer
            DemoSection(title: "Redacted Shimmer") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                            Text("Sensitive Data")
                                .font(LubaTypography.headline)
                            Text("This content is hidden while loading using SwiftUI's redaction combined with shimmer.")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                        .lubaRedactedShimmer(isLoading: isLoading)

                        Text("Combines redaction with shimmer for privacy")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Intensity Comparison
            DemoSection(title: "Shimmer Intensity") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.md) {
                            intensityDemo(intensity: 0.3, label: "Subtle")
                            intensityDemo(intensity: 0.6, label: "Default")
                            intensityDemo(intensity: 0.9, label: "Strong")
                        }

                        Text("Adjust intensity based on background")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Real-World: Image Gallery
            DemoSection(title: "Image Gallery Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: LubaSpacing.sm) {
                            ForEach(0..<6, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: LubaRadius.sm)
                                    .fill(LubaColors.gray200)
                                    .aspectRatio(1, contentMode: .fit)
                                    .lubaShimmerable(isLoading: isLoading, intensity: 0.5)
                            }
                        }

                        if !isLoading {
                            Text("6 photos loaded")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                }
            }

            // Real-World: User Profile
            DemoSection(title: "User Profile Example") {
                LubaCard(elevation: .low) {
                    HStack(spacing: LubaSpacing.md) {
                        Circle()
                            .fill(LubaColors.gray200)
                            .frame(width: 56, height: 56)
                            .lubaShimmerable(isLoading: isLoading)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Alexandra Chen")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Product Designer at Luba")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                        .lubaRedactedShimmer(isLoading: isLoading)

                        Spacer()

                        if !isLoading {
                            LubaButton("Follow", style: .primary, size: .small) { }
                        }
                    }
                }
            }

            // Philosophy
            DemoSection(title: "Radical Composability") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("sparkles", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Beyond Skeletons")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Traditional skeletons replace your content. .lubaShimmerable() overlays shimmer on your actual views — keeping layout stable during progressive loading.")
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
                        Text("// Shimmer overlay")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("Image(\"hero\")")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaShimmerable(isLoading: isLoading)")
                            .foregroundStyle(LubaColors.accent)

                        LubaDivider()
                            .padding(.vertical, LubaSpacing.sm)

                        Text("// Redacted + shimmer")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("Text(\"Sensitive\")")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaRedactedShimmer(isLoading: true)")
                            .foregroundStyle(LubaColors.accent)
                    }
                    .font(LubaTypography.code)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isLoading)
    }

    // MARK: - Components

    private func intensityDemo(intensity: CGFloat, label: String) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            RoundedRectangle(cornerRadius: LubaRadius.sm)
                .fill(LubaColors.gray200)
                .frame(height: 60)
                .lubaShimmerable(isLoading: isLoading, intensity: intensity)

            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
    }

}

#Preview {
    NavigationStack {
        ShimmerableScreen()
    }
}
