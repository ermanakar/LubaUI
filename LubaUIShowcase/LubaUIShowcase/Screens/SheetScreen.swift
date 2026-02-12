//
//  SheetScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaSheet for bottom sheets and modals.
//

import SwiftUI
import LubaUI

struct SheetScreen: View {
    @State private var showSmallSheet = false
    @State private var showMediumSheet = false
    @State private var showLargeSheet = false
    @State private var showFullSheet = false
    @State private var showSettingsSheet = false

    var body: some View {
        ShowcaseScreen("Sheet") {
            ShowcaseHeader(
                title: "Sheet",
                description: "A refined bottom sheet with size presets and header component."
            )

            // Size Variants
            DemoSection(title: "Sizes") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        sheetButton(title: "Small (25%)", subtitle: "Quick actions") {
                            showSmallSheet = true
                        }

                        LubaDivider()

                        sheetButton(title: "Medium (50%)", subtitle: "Forms, selections") {
                            showMediumSheet = true
                        }

                        LubaDivider()

                        sheetButton(title: "Large (75%)", subtitle: "Complex content") {
                            showLargeSheet = true
                        }

                        LubaDivider()

                        sheetButton(title: "Full", subtitle: "Modal screens") {
                            showFullSheet = true
                        }
                    }
                }
            }

            // Real-World Example
            DemoSection(title: "Real-World Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Account Settings")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Manage your preferences")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                            Spacer()
                        }

                        LubaButton("Open Settings", style: .primary) {
                            showSettingsSheet = true
                        }
                    }
                }
            }

            // Header Component
            DemoSection(title: "Sheet Header") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        LubaSheetHeader("Settings", subtitle: "Customize your experience") {
                            // Close action
                        }
                        LubaDivider()

                        Text("Sheet content goes here...")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(LubaSpacing.lg)
                    }
                }
            }

            // API Reference
            DemoSection(title: "Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        codeRow(".lubaSheet(isPresented:size:content:)", "View modifier")
                        codeRow("LubaSheetHeader(_:subtitle:onClose:)", "Header component")
                        codeRow("LubaSheetSize", ".small, .medium, .large, .full")
                    }
                }
            }
        }
        // Sheet Modifiers
        .lubaSheet(isPresented: $showSmallSheet, size: .small) {
            smallSheetContent
        }
        .lubaSheet(isPresented: $showMediumSheet, size: .medium) {
            mediumSheetContent
        }
        .lubaSheet(isPresented: $showLargeSheet, size: .large) {
            largeSheetContent
        }
        .lubaSheet(isPresented: $showFullSheet, size: .full) {
            fullSheetContent
        }
        .lubaSheet(isPresented: $showSettingsSheet, size: .medium) {
            settingsSheetContent
        }
    }

    // MARK: - Sheet Contents

    private var smallSheetContent: some View {
        VStack(spacing: LubaSpacing.lg) {
            LubaSheetHeader("Quick Actions") {
                showSmallSheet = false
            }

            LubaDivider()

            HStack(spacing: LubaSpacing.md) {
                actionButton(icon: "square.and.arrow.up", label: "Share")
                actionButton(icon: "doc.on.doc", label: "Copy")
                actionButton(icon: "trash", label: "Delete")
            }
            .padding(.horizontal, LubaSpacing.lg)
            .padding(.bottom, LubaSpacing.lg)
        }
        .background(LubaColors.surface)
    }

    private var mediumSheetContent: some View {
        VStack(spacing: 0) {
            LubaSheetHeader("Select Option", subtitle: "Choose one to continue") {
                showMediumSheet = false
            }

            LubaDivider()

            ScrollView {
                VStack(spacing: LubaSpacing.sm) {
                    ForEach(1...5, id: \.self) { index in
                        optionRow(title: "Option \(index)", isSelected: index == 1)
                    }
                }
                .padding(LubaSpacing.lg)
            }
        }
        .background(LubaColors.surface)
    }

    private var largeSheetContent: some View {
        VStack(spacing: 0) {
            LubaSheetHeader("Details", subtitle: "Complete information") {
                showLargeSheet = false
            }

            LubaDivider()

            ScrollView {
                VStack(alignment: .leading, spacing: LubaSpacing.lg) {
                    Text("Large sheets are perfect for displaying detailed content that requires more screen real estate.")
                        .font(LubaTypography.body)
                        .foregroundStyle(LubaColors.textSecondary)

                    ForEach(1...6, id: \.self) { _ in
                        LubaCard(elevation: .flat, style: .outlined) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Content Block")
                                        .font(LubaTypography.headline)
                                        .foregroundStyle(LubaColors.textPrimary)
                                    Text("Additional details here")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textSecondary)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .padding(LubaSpacing.lg)
            }
        }
        .background(LubaColors.surface)
    }

    private var fullSheetContent: some View {
        VStack(spacing: 0) {
            LubaSheetHeader("Full Screen") {
                showFullSheet = false
            }

            LubaDivider()

            ScrollView {
                VStack(spacing: LubaSpacing.xl) {
                    Image(systemName: "rectangle.expand.vertical")
                        .font(.system(size: 48))
                        .foregroundStyle(LubaColors.accent)
                        .padding(.top, LubaSpacing.xxl)

                    Text("Full Screen Sheet")
                        .font(LubaTypography.title)
                        .foregroundStyle(LubaColors.textPrimary)

                    Text("Perfect for modal screens that need maximum space, like forms, editors, or detailed views.")
                        .font(LubaTypography.body)
                        .foregroundStyle(LubaColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, LubaSpacing.xl)

                    Spacer()
                }
            }
        }
        .background(LubaColors.surface)
    }

    private var settingsSheetContent: some View {
        VStack(spacing: 0) {
            LubaSheetHeader("Settings", subtitle: "Customize your experience") {
                showSettingsSheet = false
            }

            LubaDivider()

            ScrollView {
                VStack(spacing: 0) {
                    settingToggle(icon: "bell.fill", title: "Notifications", isOn: true)
                    LubaDivider()
                    settingToggle(icon: "moon.fill", title: "Dark Mode", isOn: false)
                    LubaDivider()
                    settingToggle(icon: "hand.raised.fill", title: "Haptics", isOn: true)
                }
                .padding(.horizontal, LubaSpacing.lg)
                .padding(.top, LubaSpacing.md)
            }
        }
        .background(LubaColors.surface)
    }

    // MARK: - Components

    private func sheetButton(title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(LubaTypography.body)
                        .foregroundStyle(LubaColors.textPrimary)
                    Text(subtitle)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(LubaColors.textTertiary)
            }
        }
        .buttonStyle(.plain)
    }

    private func actionButton(icon: String, label: String) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            ZStack {
                Circle()
                    .fill(LubaColors.gray100)
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(LubaColors.textPrimary)
            }

            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func optionRow(title: String, isSelected: Bool) -> some View {
        HStack {
            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(LubaColors.accent)
            }
        }
        .padding(LubaSpacing.md)
        .background(isSelected ? LubaColors.accentSubtle : LubaColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: LubaRadius.md)
                .strokeBorder(isSelected ? LubaColors.accent : LubaColors.border, lineWidth: 1)
        )
    }

    private func settingToggle(icon: String, title: String, isOn: Bool) -> some View {
        HStack {
            LubaCircledIcon(icon, size: .sm, style: .subtle)

            Text(title)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            LubaToggle(isOn: .constant(isOn))
        }
        .padding(.vertical, LubaSpacing.sm)
    }

    private func codeRow(_ code: String, _ description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(code)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(LubaColors.accent)
            Text(description)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)
        }
    }

}

#Preview {
    NavigationStack {
        SheetScreen()
    }
}
