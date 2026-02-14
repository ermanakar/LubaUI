//
//  ToggleScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaToggle — the binary choice, made tangible.
//

import SwiftUI
import LubaUI

struct ToggleScreen: View {
    @State private var wifiEnabled = true
    @State private var bluetoothEnabled = false
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false

    var body: some View {
        ShowcaseScreen("Toggle") {
            ShowcaseHeader(
                title: "Toggle",
                description: "A binary on/off switch with smooth spring animation and haptic feedback."
            )

            // Basic
            DemoSection(title: "Basic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: 0) {
                        LubaToggle(isOn: $wifiEnabled, label: "Wi-Fi")
                        LubaDivider()
                        LubaToggle(isOn: $bluetoothEnabled, label: "Bluetooth")
                    }
                }
            }

            // Without Label
            DemoSection(title: "Without Label") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack {
                        Text("Custom label layout")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)
                        Spacer()
                        LubaToggle(isOn: $darkModeEnabled)
                    }
                }
            }

            // Disabled
            DemoSection(title: "Disabled") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: 0) {
                        LubaToggle(isOn: .constant(true), label: "Always on", isDisabled: true)
                        LubaDivider()
                        LubaToggle(isOn: .constant(false), label: "Always off", isDisabled: true)
                    }
                }
            }

            // Settings Panel
            DemoSection(title: "Settings Panel") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        settingsRow(icon: "wifi", title: "Wi-Fi", isOn: $wifiEnabled)
                        LubaDivider()
                        settingsRow(icon: "antenna.radiowaves.left.and.right", title: "Bluetooth", isOn: $bluetoothEnabled)
                        LubaDivider()
                        settingsRow(icon: "bell.fill", title: "Notifications", isOn: $notificationsEnabled)
                        LubaDivider()
                        settingsRow(icon: "moon.fill", title: "Dark Mode", isOn: $darkModeEnabled)
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaToggle(isOn: $isEnabled)")
                    CopyableCode(code: "LubaToggle(isOn: $isOn, label: \"Wi-Fi\")")
                    CopyableCode(code: "LubaToggle(isOn: $isOn, isDisabled: true)")
                }
            }

            PhilosophyCard(
                icon: "power",
                title: "Binary Clarity",
                description: "A toggle represents an immediate, binary choice. On or off — no ambiguity. The spring animation and haptic tap confirm the state change before the UI even updates."
            )
        }
    }

    // MARK: - Components

    private func settingsRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            LubaToggle(isOn: isOn)
        }
        .padding(.vertical, LubaSpacing.xs)
    }
}

#Preview {
    NavigationStack {
        ToggleScreen()
    }
}
