//
//  SliderScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaSlider — continuous and stepped control.
//

import SwiftUI
import LubaUI

struct SliderScreen: View {
    @State private var brightness: Double = 0.7
    @State private var volume: Double = 50
    @State private var fontSize: Double = 16
    @State private var rating: Double = 3

    var body: some View {
        ShowcaseScreen("Slider") {
            ShowcaseHeader(
                title: "Slider",
                description: "A draggable control for selecting values from a continuous or stepped range."
            )

            // Basic
            DemoSection(title: "Basic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaSlider(value: $brightness)
                }
            }

            // With Label & Value
            DemoSection(title: "Label & Value") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaSlider(value: $brightness, label: "Brightness", showValue: true)
                        LubaDivider()
                        LubaSlider(value: $volume, in: 0...100, label: "Volume", showValue: true)
                    }
                }
            }

            // Stepped
            DemoSection(title: "Stepped") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaSlider(value: $fontSize, in: 12...24, step: 2, label: "Font Size", showValue: true)
                        LubaDivider()
                        LubaSlider(value: $rating, in: 1...5, step: 1, label: "Rating", showValue: true)
                    }
                }
            }

            // Disabled
            DemoSection(title: "Disabled") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaSlider(value: .constant(0.5), label: "Locked", showValue: true, isDisabled: true)
                }
            }

            // Live Preview
            DemoSection(title: "Live Preview") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        Text("The quick brown fox")
                            .font(LubaTypography.custom(size: fontSize, weight: .medium))
                            .foregroundStyle(LubaColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, LubaSpacing.md)

                        LubaSlider(value: $fontSize, in: 12...32, step: 1, label: "Size", showValue: true)
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaSlider(value: $val)")
                    CopyableCode(code: "LubaSlider(value: $v, in: 0...100)")
                    CopyableCode(code: "LubaSlider(value: $v, step: 5, label: \"Vol\")")
                    CopyableCode(code: "LubaSlider(value: $v, showValue: true)")
                }
            }

            PhilosophyCard(
                icon: "slider.horizontal.3",
                title: "Tangible Range",
                description: "Sliders make abstract ranges physical. The thumb scales up on drag to confirm engagement, and optional step snapping adds tactile precision to discrete values."
            )
        }
    }
}

#Preview {
    NavigationStack {
        SliderScreen()
    }
}
