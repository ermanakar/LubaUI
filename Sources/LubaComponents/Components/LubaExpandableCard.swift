import SwiftUI
import LubaCore

// MARK: - Expandable Card

/// A card with an expandable section.
public struct LubaExpandableCard<Header: View, Content: View>: View {
    @LubaEnvironment private var luba
    @Binding var isExpanded: Bool
    let elevation: LubaCardElevation
    let header: () -> Header
    let content: () -> Content

    public init(
        isExpanded: Binding<Bool>,
        elevation: LubaCardElevation = .low,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isExpanded = isExpanded
        self.elevation = elevation
        self.header = header
        self.content = content
    }

    public var body: some View {
        LubaCard(elevation: elevation) {
            LubaExpandable(isExpanded: $isExpanded) {
                header()
            } content: {
                VStack(spacing: 0) {
                    LubaDivider()
                        .padding(.vertical, luba.spacing.md)

                    content()
                }
            }
        }
    }
}

// MARK: - Accordion Item

/// Data model for accordion items.
public struct LubaAccordionItem: Identifiable {
    public let id: String
    public let title: String
    public let content: String
    public let icon: String?

    public init(id: String = UUID().uuidString, title: String, content: String, icon: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.icon = icon
    }
}

// MARK: - Accordion

/// A group of expandable items where only one can be open at a time.
public struct LubaAccordion: View {
    @LubaEnvironment private var luba
    let items: [LubaAccordionItem]
    let allowMultiple: Bool

    @State private var expandedIds: Set<String> = []

    public init(items: [LubaAccordionItem], allowMultiple: Bool = false) {
        self.items = items
        self.allowMultiple = allowMultiple
    }

    public var body: some View {
        VStack(spacing: luba.spacing.sm) {
            ForEach(items) { item in
                accordionRow(item: item)
            }
        }
    }

    private func accordionRow(item: LubaAccordionItem) -> some View {
        let isExpanded = expandedIds.contains(item.id)

        return LubaCard(elevation: .flat, style: .outlined) {
            LubaExpandable(isExpanded: Binding(
                get: { isExpanded },
                set: { newValue in
                    if newValue {
                        if !allowMultiple {
                            expandedIds.removeAll()
                        }
                        expandedIds.insert(item.id)
                    } else {
                        expandedIds.remove(item.id)
                    }
                }
            )) {
                HStack(spacing: luba.spacing.md) {
                    if let icon = item.icon {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundStyle(luba.colors.accent)
                            .frame(width: 24)
                    }

                    Text(item.title)
                        .font(luba.fonts.headline)
                        .foregroundStyle(luba.colors.textPrimary)
                }
            } content: {
                VStack(spacing: 0) {
                    LubaDivider()
                        .padding(.vertical, luba.spacing.sm)

                    Text(item.content)
                        .font(luba.fonts.body)
                        .foregroundStyle(luba.colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Expandable") {
    struct PreviewWrapper: View {
        @State private var isExpanded1 = false
        @State private var isExpanded2 = true
        @State private var isExpanded3 = false

        let faqItems: [LubaAccordionItem] = [
            LubaAccordionItem(
                title: "What is LubaUI?",
                content: "LubaUI is a modern SwiftUI design system with design tokens, theming, and reusable components. It's built with radical composability in mind.",
                icon: "questionmark.circle"
            ),
            LubaAccordionItem(
                title: "How do I install it?",
                content: "Add LubaUI as a Swift Package dependency using the repository URL. It supports iOS 16+, macOS 13+, and other Apple platforms.",
                icon: "arrow.down.circle"
            ),
            LubaAccordionItem(
                title: "Is it customizable?",
                content: "Yes! LubaUI uses design tokens for colors, spacing, typography, and motion. You can customize the theme to match your brand.",
                icon: "paintbrush"
            )
        ]

        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: LubaSpacing.xxl) {
                        // Basic Expandable
                        VStack(alignment: .leading, spacing: LubaSpacing.md) {
                            Text("BASIC EXPANDABLE")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)

                            LubaCard(elevation: .flat, style: .outlined) {
                                LubaExpandable(isExpanded: $isExpanded1) {
                                    HStack(spacing: LubaSpacing.md) {
                                        Image(systemName: "info.circle.fill")
                                            .foregroundStyle(LubaColors.accent)
                                        Text("Tap to expand")
                                            .font(LubaTypography.headline)
                                            .foregroundStyle(LubaColors.textPrimary)
                                    }
                                } content: {
                                    VStack(spacing: 0) {
                                        LubaDivider()
                                            .padding(.vertical, LubaSpacing.sm)

                                        Text("This content was hidden and is now revealed. The animation uses a spring for a natural feel.")
                                            .font(LubaTypography.body)
                                            .foregroundStyle(LubaColors.textSecondary)
                                    }
                                }
                            }
                        }

                        // Expandable Card
                        VStack(alignment: .leading, spacing: LubaSpacing.md) {
                            Text("EXPANDABLE CARD")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)

                            LubaExpandableCard(isExpanded: $isExpanded2, elevation: .low) {
                                HStack(spacing: LubaSpacing.md) {
                                    LubaAvatar(name: "Settings", size: .small)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Advanced Settings")
                                            .font(LubaTypography.headline)
                                            .foregroundStyle(LubaColors.textPrimary)
                                        Text("Tap to \(isExpanded2 ? "hide" : "show") options")
                                            .font(LubaTypography.caption)
                                            .foregroundStyle(LubaColors.textSecondary)
                                    }
                                }
                            } content: {
                                VStack(spacing: LubaSpacing.md) {
                                    settingRow(title: "Notifications", isOn: true)
                                    settingRow(title: "Dark Mode", isOn: false)
                                    settingRow(title: "Haptics", isOn: true)
                                }
                            }
                        }

                        // Accordion (FAQ)
                        VStack(alignment: .leading, spacing: LubaSpacing.md) {
                            Text("ACCORDION (FAQ)")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)

                            LubaAccordion(items: faqItems)
                        }

                        // Modifier Usage
                        VStack(alignment: .leading, spacing: LubaSpacing.md) {
                            Text("MODIFIER USAGE")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)

                            LubaCard(elevation: .flat, style: .outlined) {
                                VStack(spacing: 0) {
                                    Button {
                                        withAnimation(LubaExpandTokens.animation) {
                                            isExpanded3.toggle()
                                        }
                                    } label: {
                                        HStack {
                                            Text("Show Details")
                                                .font(LubaTypography.body)
                                                .foregroundStyle(LubaColors.textPrimary)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .rotationEffect(.degrees(isExpanded3 ? 180 : 0))
                                                .foregroundStyle(LubaColors.textTertiary)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .lubaExpandable(isExpanded: $isExpanded3) {
                                        VStack(spacing: 0) {
                                            LubaDivider()
                                                .padding(.vertical, LubaSpacing.sm)

                                            Text("Using .lubaExpandable() modifier")
                                                .font(LubaTypography.caption)
                                                .foregroundStyle(LubaColors.textSecondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(LubaSpacing.lg)
                }
                .background(LubaColors.background)
                .navigationTitle("Expandable")
            }
        }

        private func settingRow(title: String, isOn: Bool) -> some View {
            HStack {
                Text(title)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)
                Spacer()
                LubaToggle(isOn: .constant(isOn))
            }
        }
    }

    return PreviewWrapper()
}
