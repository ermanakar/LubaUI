//
//  CheckboxScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaCheckbox — multi-select made simple.
//

import SwiftUI
import LubaUI

struct CheckboxScreen: View {
    @State private var agreeToTerms = false
    @State private var receiveEmails = true
    @State private var shareData = false

    @State private var selectAll = false
    @State private var option1 = true
    @State private var option2 = false
    @State private var option3 = true

    var body: some View {
        ShowcaseScreen("Checkbox") {
            ShowcaseHeader(
                title: "Checkbox",
                description: "Multi-select controls for forms, filters, and preference lists."
            )

            // Basic
            DemoSection(title: "Basic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaCheckbox(isChecked: $agreeToTerms, label: "I agree to the terms")
                        LubaCheckbox(isChecked: $receiveEmails, label: "Send me email updates")
                        LubaCheckbox(isChecked: $shareData, label: "Share usage data")
                    }
                }
            }

            // Without Label
            DemoSection(title: "Without Label") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack {
                        LubaCheckbox(isChecked: $agreeToTerms)
                        Text("Custom label with **bold** formatting")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)
                    }
                }
            }

            // Disabled
            DemoSection(title: "Disabled") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaCheckbox(isChecked: .constant(true), label: "Checked (disabled)", isDisabled: true)
                        LubaCheckbox(isChecked: .constant(false), label: "Unchecked (disabled)", isDisabled: true)
                    }
                }
            }

            // Select All Pattern
            DemoSection(title: "Select All Pattern") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        LubaCheckbox(isChecked: $selectAll, label: "Select all")
                            .onChange(of: selectAll) { newValue in
                                option1 = newValue
                                option2 = newValue
                                option3 = newValue
                            }

                        LubaDivider()

                        VStack(spacing: LubaSpacing.sm) {
                            LubaCheckbox(isChecked: $option1, label: "Design tokens")
                            LubaCheckbox(isChecked: $option2, label: "Components")
                            LubaCheckbox(isChecked: $option3, label: "Primitives")
                        }
                        .padding(.leading, LubaSpacing.xl)
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaCheckbox(isChecked: $agreed)")
                    CopyableCode(code: "LubaCheckbox(isChecked: $ok, label: \"Accept\")")
                    CopyableCode(code: "LubaCheckbox(isChecked: $v, isDisabled: true)")
                }
            }

            PhilosophyCard(
                icon: "checklist",
                title: "Many From Many",
                description: "Checkboxes let users select multiple options independently. Unlike radio buttons (one from many), checkboxes represent non-exclusive choices — each stands on its own."
            )
        }
    }
}

#Preview {
    NavigationStack {
        CheckboxScreen()
    }
}
