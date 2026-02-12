//
//  LongPressableScreen.swift
//  LubaUIShowcase
//
//  LongPressable primitive showcase — long press with visual progress and haptics.
//

import SwiftUI
import LubaUI

struct LongPressableScreen: View {
    @State private var deleteCount = 0
    @State private var unlockCount = 0
    @State private var lastAction = "Hold any element to trigger"

    var body: some View {
        ShowcaseScreen("Long Pressable") {
            ShowcaseHeader(
                title: "Long Pressable",
                description: "Long press with visual progress feedback and haptics. Perfect for dangerous actions or hidden features."
            )

            // Status
            DemoSection(title: "Last Action") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack {
                        Image(systemName: "hand.tap.fill")
                            .foregroundStyle(LubaColors.accent)

                        Text(lastAction)
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)

                        Spacer()
                    }
                }
            }

            // Basic Long Press
            DemoSection(title: "Basic Long Press") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.xl) {
                            VStack(spacing: LubaSpacing.sm) {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(LubaColors.error)
                                    .frame(width: 56, height: 56)
                                    .background(LubaColors.surface)
                                    .clipShape(Circle())
                                    .overlay(Circle().strokeBorder(LubaColors.border, lineWidth: 1))
                                    .lubaLongPressable(duration: 0.8, hapticOnComplete: .warning) {
                                        deleteCount += 1
                                        lastAction = "Deleted! (\(deleteCount) times)"
                                    }

                                Text("Delete")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            VStack(spacing: LubaSpacing.sm) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(LubaColors.accent)
                                    .frame(width: 56, height: 56)
                                    .background(LubaColors.accentSubtle)
                                    .clipShape(Circle())
                                    .lubaLongPressable(duration: 0.5, hapticOnComplete: .success) {
                                        lastAction = "Super liked!"
                                    }

                                Text("Super Like")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Text("Hold for 0.5-0.8 seconds to trigger")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // With Progress Ring
            DemoSection(title: "With Progress Ring") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        RoundedRectangle(cornerRadius: LubaRadius.lg)
                            .fill(LubaColors.surface)
                            .frame(height: 100)
                            .overlay(
                                VStack(spacing: LubaSpacing.sm) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 24))
                                    Text("Hold to unlock")
                                        .font(LubaTypography.caption)
                                }
                                .foregroundStyle(LubaColors.textSecondary)
                            )
                            .lubaLongPressable(
                                duration: 1.5,
                                showProgress: true,
                                progressSize: 64,
                                hapticOnComplete: .success
                            ) {
                                unlockCount += 1
                                lastAction = "Unlocked! (\(unlockCount) times)"
                            }

                        Text("Visual progress ring shows completion")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Standalone Button
            DemoSection(title: "Standalone Button") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.xl) {
                            LubaLongPressButton(icon: "heart.fill", label: "Like", duration: 0.5) {
                                lastAction = "Super liked!"
                            }

                            LubaLongPressButton(icon: "trash", label: "Delete", duration: 1.0) {
                                deleteCount += 1
                                lastAction = "Deleted! (\(deleteCount) times)"
                            }

                            LubaLongPressButton(icon: "checkmark", label: "Confirm", duration: 0.8) {
                                lastAction = "Confirmed!"
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Text("Built-in component with progress ring")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Real-World: Dangerous Action
            DemoSection(title: "Dangerous Action Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaCircledIcon("exclamationmark.triangle.fill", size: .md, style: .subtle)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Delete Account")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("This action cannot be undone")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()
                        }

                        LubaDivider()

                        HStack {
                            Text("Hold to confirm deletion")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)

                            Spacer()

                            Text("Delete")
                                .font(LubaTypography.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, LubaSpacing.lg)
                                .padding(.vertical, LubaSpacing.sm)
                                .background(LubaColors.error)
                                .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md))
                                .lubaLongPressable(
                                    duration: 2.0,
                                    showProgress: true,
                                    progressSize: 44,
                                    hapticOnComplete: .error
                                ) {
                                    lastAction = "Account deleted!"
                                }
                        }
                    }
                }
            }

            // Real-World: Hidden Feature
            DemoSection(title: "Hidden Feature Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "LubaUI", size: .medium)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("LubaUI")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Version 0.1.0")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()
                        }
                        .lubaLongPressable(duration: 3.0, hapticOnComplete: .success) {
                            lastAction = "Developer mode activated!"
                        }

                        Text("Long press the header for 3 seconds to unlock developer mode")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Philosophy
            DemoSection(title: "Intentional Friction") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(alignment: .top, spacing: LubaSpacing.md) {
                        LubaCircledIcon("timer", size: .md, style: .subtle)

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Deliberate Delay")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)

                            Text("Long press adds intentional friction for dangerous or irreversible actions. The progress feedback gives users time to reconsider and the haptic confirms completion.")
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
                        Text("// Basic long press")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("Button { }")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaLongPressable { delete() }")
                            .foregroundStyle(LubaColors.accent)

                        LubaDivider()
                            .padding(.vertical, LubaSpacing.sm)

                        Text("// With progress ring")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("View { }")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaLongPressable(")
                            .foregroundStyle(LubaColors.accent)
                        Text("        duration: 2.0,")
                            .foregroundStyle(LubaColors.textSecondary)
                        Text("        showProgress: true")
                            .foregroundStyle(LubaColors.textSecondary)
                        Text("    ) { action() }")
                            .foregroundStyle(LubaColors.accent)
                    }
                    .font(.system(size: 13, design: .monospaced))
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        LongPressableScreen()
    }
}
