//
//  PressableScreen.swift
//  LubaUIShowcase
//
//  Demonstrating Radical Composability — the .lubaPressable() primitive.
//

import SwiftUI
import LubaUI

struct PressableScreen: View {
    @State private var tapCount = 0
    @State private var heartFilled = false
    @State private var selectedCard: Int? = nil

    var body: some View {
        ShowcaseScreen("Pressable") {
            ShowcaseHeader(
                title: "Pressable",
                description: "The .lubaPressable() modifier extracts press behavior into a reusable primitive. Any view can have that tactile feel."
            )

            PhilosophyCard(
                icon: "lightbulb.fill",
                title: "Radical Composability",
                description: "We don't build buttons; we build behaviors. The press interaction isn't locked in LubaButton — it's extracted so any view can use it."
            )

            DemoSection(title: "Any View Can Be Tappable") {
                VStack(spacing: LubaSpacing.lg) {
                    // Image
                    Image(systemName: heartFilled ? "heart.fill" : "heart")
                        .font(.system(size: 48))
                        .foregroundStyle(heartFilled ? LubaColors.error : LubaColors.textSecondary)
                        .frame(width: 80, height: 80)
                        .lubaPressable {
                            heartFilled.toggle()
                        }

                    Text("Tap the heart")
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, LubaSpacing.lg)
            }

            DemoSection(title: "Pressable Cards") {
                VStack(spacing: LubaSpacing.md) {
                    ForEach(0..<3) { index in
                        LubaCard(
                            elevation: selectedCard == index ? .medium : .flat,
                            style: selectedCard == index ? .filled : .outlined
                        ) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Option \(index + 1)")
                                        .font(LubaTypography.headline)
                                        .foregroundStyle(LubaColors.textPrimary)
                                    Text("Tap to select")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textSecondary)
                                }
                                Spacer()
                                if selectedCard == index {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(LubaColors.accent)
                                }
                            }
                        }
                        .lubaPressable(scale: LubaMotion.pressScaleProminent) {
                            selectedCard = index
                        }
                    }
                }
            }

            DemoSection(title: "Custom Scale & Haptics") {
                VStack(spacing: LubaSpacing.lg) {
                    Text("\(tapCount)")
                        .font(LubaTypography.custom(size: 64, weight: .bold))
                        .foregroundStyle(LubaColors.accent)
                        .frame(width: 120, height: 120)
                        .background(LubaColors.accentSubtle)
                        .clipShape(Circle())
                        .lubaPressable(scale: 0.9, haptic: .medium) {
                            tapCount += 1
                        }

                    Text("Stronger scale (0.9) + medium haptic")
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, LubaSpacing.lg)
            }

            // Code Example
            codeExample
        }
    }

    private var codeExample: some View {
        DemoSection(title: "Usage") {
            LubaCard(elevation: .flat, style: .outlined) {
                VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                    Text("// Make any view tappable")
                        .foregroundStyle(LubaColors.textTertiary)
                    Text("Image(\"hero\")")
                        .foregroundStyle(LubaColors.textPrimary)
                    Text("    .lubaPressable { action() }")
                        .foregroundStyle(LubaColors.accent)

                    LubaDivider()
                        .padding(.vertical, LubaSpacing.sm)

                    Text("// Custom scale for larger elements")
                        .foregroundStyle(LubaColors.textTertiary)
                    Text("LubaCard { content }")
                        .foregroundStyle(LubaColors.textPrimary)
                    Text("    .lubaPressable(scale: 0.98) { }")
                        .foregroundStyle(LubaColors.accent)
                }
                .font(LubaTypography.code)
            }
        }
    }

}

#Preview {
    NavigationStack {
        PressableScreen()
    }
}
