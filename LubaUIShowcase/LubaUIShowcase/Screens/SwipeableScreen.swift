//
//  SwipeableScreen.swift
//  LubaUIShowcase
//
//  Showcases the LubaSwipeable primitive.
//

import SwiftUI
import LubaUI

struct SwipeableScreen: View {
    @State private var messages: [DemoMessage] = DemoMessage.samples
    @State private var lastAction = "Swipe an item to see actions"

    var body: some View {
        ShowcaseScreen("Swipeable") {
            ShowcaseHeader(
                title: "Swipeable",
                description: "Swipe gestures reveal actions. Full swipe triggers the first action instantly."
            )

            // Interactive Demo
            DemoSection(title: "Swipe Actions") {
                VStack(spacing: 0) {
                    // Status bar
                    Text(lastAction)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(LubaSpacing.md)
                        .background(LubaColors.surfaceSecondary)

                    // Message list
                    VStack(spacing: 1) {
                        ForEach(messages) { message in
                            messageRow(message)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: LubaRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: LubaRadius.lg)
                        .strokeBorder(LubaColors.border, lineWidth: 1)
                )
            }

            // Preset Actions
            DemoSection(title: "Preset Actions") {
                VStack(spacing: LubaSpacing.md) {
                    presetActionRow(
                        icon: "trash.fill",
                        label: "Delete",
                        color: LubaColors.error,
                        code: ".delete { }"
                    )
                    presetActionRow(
                        icon: "archivebox.fill",
                        label: "Archive",
                        color: LubaColors.accent,
                        code: ".archive { }"
                    )
                    presetActionRow(
                        icon: "pin.fill",
                        label: "Pin",
                        color: LubaColors.warning,
                        code: ".pin { }"
                    )
                    presetActionRow(
                        icon: "envelope.badge.fill",
                        label: "Unread",
                        color: LubaColors.accent,
                        code: ".unread { }"
                    )
                    presetActionRow(
                        icon: "flag.fill",
                        label: "Flag",
                        color: LubaColors.warning,
                        code: ".flag { }"
                    )
                    presetActionRow(
                        icon: "square.and.arrow.up",
                        label: "Share",
                        color: LubaColors.accent,
                        code: ".share { }"
                    )
                }
            }

            // Philosophy
            DemoSection(title: "The Pattern") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.sm) {
                            Image(systemName: "hand.draw")
                                .foregroundStyle(LubaColors.accent)
                            Text("Gesture Composition")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                        }

                        Text("The swipe primitive extracts the complex gesture handling, action revelation, and full-swipe behavior. Apply it to any row — messages, emails, tasks, or custom content.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            codeSnippet(".lubaSwipeable(")
                            codeSnippet("    leading: [.pin { }, .unread { }],")
                            codeSnippet("    trailing: [.archive { }, .delete { }]")
                            codeSnippet(")")
                        }
                    }
                }
            }

            // Token Reference
            DemoSection(title: "Swipe Tokens") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        tokenRow("Reveal threshold", "60pt")
                        LubaDivider()
                        tokenRow("Full swipe", "60% of width")
                        LubaDivider()
                        tokenRow("Action width", "72pt")
                        LubaDivider()
                        tokenRow("Max actions", "3 per side")
                    }
                }
            }

            // Reset Button
            if messages.count < DemoMessage.samples.count {
                LubaButton("Reset Messages", style: .secondary) {
                    withAnimation(LubaMotion.stateAnimation) {
                        messages = DemoMessage.samples
                        lastAction = "Messages restored"
                    }
                }
            }
        }
    }

    // MARK: - Message Row

    private func messageRow(_ message: DemoMessage) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaAvatar(name: message.sender, size: .medium)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(message.sender)
                        .font(LubaTypography.headline)
                        .foregroundStyle(LubaColors.textPrimary)

                    Spacer()

                    Text(message.time)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textTertiary)
                }

                Text(message.preview)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(LubaSpacing.md)
        .frame(height: 72)
        .background(LubaColors.surface)
        .lubaSwipeable(
            leading: [
                .pin { lastAction = "Pinned \(message.sender)" },
                .unread { lastAction = "Marked \(message.sender) unread" }
            ],
            trailing: [
                .archive { lastAction = "Archived \(message.sender)" },
                .delete {
                    lastAction = "Deleted \(message.sender)"
                    withAnimation(LubaMotion.stateAnimation) {
                        messages.removeAll { $0.id == message.id }
                    }
                }
            ]
        )
    }

    // MARK: - Preset Action Row

    private func presetActionRow(icon: String, label: String, color: Color, code: String) -> some View {
        HStack(spacing: LubaSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: LubaRadius.sm)
                    .fill(color)
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(LubaTypography.custom(size: 16, weight: .medium))
                    .foregroundStyle(.white)
            }

            Text(label)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer()

            Text(code)
                .font(LubaTypography.custom(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(LubaColors.accent)
        }
        .padding(LubaSpacing.md)
        .background(LubaColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: LubaRadius.md)
                .strokeBorder(LubaColors.border, lineWidth: 1)
        )
    }


    private func tokenRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textSecondary)
            Spacer()
            Text(value)
                .font(LubaTypography.custom(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(LubaColors.accent)
        }
    }

    private func codeSnippet(_ code: String) -> some View {
        Text(code)
            .font(LubaTypography.custom(size: 12, weight: .medium, design: .monospaced))
            .foregroundStyle(LubaColors.accent)
    }
}

// MARK: - Demo Data

private struct DemoMessage: Identifiable {
    let id = UUID()
    let sender: String
    let preview: String
    let time: String

    static let samples: [DemoMessage] = [
        DemoMessage(sender: "Alex", preview: "Hey! Are we still on for lunch?", time: "2m"),
        DemoMessage(sender: "Design Team", preview: "New mockups are ready for review", time: "15m"),
        DemoMessage(sender: "Jordan", preview: "Thanks for the help yesterday!", time: "1h"),
        DemoMessage(sender: "Calendar", preview: "Reminder: Team sync in 30 minutes", time: "2h")
    ]
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SwipeableScreen()
    }
}
