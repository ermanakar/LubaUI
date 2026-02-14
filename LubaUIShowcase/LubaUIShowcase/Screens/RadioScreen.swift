//
//  RadioScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaRadioGroup — exclusive selection, clearly expressed.
//

import SwiftUI
import LubaUI

struct RadioScreen: View {
    @State private var selectedPlan = 2
    @State private var selectedSize = "M"
    @State private var selectedShipping = 1

    var body: some View {
        ShowcaseScreen("Radio") {
            ShowcaseHeader(
                title: "Radio",
                description: "Exclusive selection from a group of options. Only one can be active at a time."
            )

            // Basic Group
            DemoSection(title: "Basic Group") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaRadioGroup(
                        selection: $selectedPlan,
                        options: [
                            (value: 1, label: "Free"),
                            (value: 2, label: "Pro"),
                            (value: 3, label: "Enterprise")
                        ]
                    )
                }
            }

            // String Options
            DemoSection(title: "String Values") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaRadioGroup(
                        selection: $selectedSize,
                        options: [
                            (value: "XS", label: "Extra Small"),
                            (value: "S", label: "Small"),
                            (value: "M", label: "Medium"),
                            (value: "L", label: "Large"),
                            (value: "XL", label: "Extra Large")
                        ]
                    )
                }
            }

            // Disabled
            DemoSection(title: "Disabled") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaRadioGroup(
                        selection: .constant(1),
                        options: [
                            (value: 1, label: "Locked option A"),
                            (value: 2, label: "Locked option B")
                        ],
                        isDisabled: true
                    )
                }
            }

            // Individual Buttons
            DemoSection(title: "Individual Buttons") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaRadioButton(label: "Standard Shipping", isSelected: selectedShipping == 1) {
                            selectedShipping = 1
                        }
                        LubaRadioButton(label: "Express Shipping", isSelected: selectedShipping == 2) {
                            selectedShipping = 2
                        }
                        LubaRadioButton(label: "Overnight", isSelected: selectedShipping == 3) {
                            selectedShipping = 3
                        }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaRadioGroup(selection: $plan, options: [...])")
                    CopyableCode(code: "LubaRadioButton(label: \"Opt\", isSelected: true) { }")
                }
            }

            PhilosophyCard(
                icon: "circle.inset.filled",
                title: "One From Many",
                description: "Radio buttons enforce mutual exclusivity — selecting one deselects the rest. Use them when the user must choose exactly one option from a small, visible set."
            )
        }
    }
}

#Preview {
    NavigationStack {
        RadioScreen()
    }
}
