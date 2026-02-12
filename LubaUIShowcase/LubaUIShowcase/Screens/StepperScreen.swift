//
//  StepperScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaStepper numeric controls.
//

import SwiftUI
import LubaUI

struct StepperScreen: View {
    @State private var quantity = 1
    @State private var volume = 50
    @State private var guests = 2

    var body: some View {
        ShowcaseScreen("Stepper") {
            ShowcaseHeader(
                title: "Stepper",
                description: "Numeric controls for precise value adjustments. Compact, accessible, and haptic."
            )

            // Basic
            DemoSection(title: "Basic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaStepper(value: $quantity, in: 1...10, label: "Quantity")
                        LubaDivider()
                        LubaStepper(value: $guests, in: 1...20, label: "Guests")
                    }
                }
            }

            // Custom Step
            DemoSection(title: "Custom Step") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaStepper(value: $volume, in: 0...100, step: 10, label: "Volume")
                }
            }

            // No Label
            DemoSection(title: "Standalone") {
                HStack {
                    Text("Items in cart")
                        .font(LubaTypography.bodySmall)
                        .foregroundStyle(LubaColors.textSecondary)
                    Spacer()
                    LubaStepper(value: $quantity, in: 0...99)
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaStepper(value: $count, in: 1...10)")
                    CopyableCode(code: "LubaStepper(value: $vol, step: 5, label: \"Volume\")")
                }
            }

            PhilosophyCard(
                icon: "plusminus",
                title: "Precise Control",
                description: "Steppers give users exact control over numeric values. Each tap provides haptic feedback, making counting feel tangible."
            )
        }
    }
}

#Preview {
    NavigationStack {
        StepperScreen()
    }
}
