//
//  LubaExpandable.swift
//  LubaUI
//
//  Reusable expand/collapse primitive.
//  Add expand/collapse behavior to any view with smooth animations.
//
//  Usage:
//  ```swift
//  // Basic expandable
//  LubaExpandable(isExpanded: $isOpen) {
//      Text("Header")
//  } content: {
//      Text("Expandable content here")
//  }
//
//  // Accordion group
//  LubaAccordion(items: faqItems)
//  ```
//

import SwiftUI

// MARK: - Expand Tokens

/// Configuration for expand/collapse animations.
public enum LubaExpandTokens {
    /// Expand/collapse animation
    public static var animation: Animation {
        .spring(response: 0.35, dampingFraction: 0.8)
    }

    /// Chevron rotation animation
    public static var chevronAnimation: Animation {
        .spring(response: 0.25, dampingFraction: 0.7)
    }

    /// Default chevron icon
    public static let chevronIcon = "chevron.down"

    /// Header padding
    public static let headerPadding: CGFloat = LubaSpacing.md

    /// Content padding
    public static let contentPadding: CGFloat = LubaSpacing.md
}

// MARK: - Expandable View

/// A view that can expand and collapse to reveal content.
public struct LubaExpandable<Header: View, Content: View>: View {
    @Binding var isExpanded: Bool
    let showChevron: Bool
    let haptic: LubaHapticStyle?
    let header: () -> Header
    let content: () -> Content

    @Environment(\.lubaConfig) private var config

    public init(
        isExpanded: Binding<Bool>,
        showChevron: Bool = true,
        haptic: LubaHapticStyle? = .light,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isExpanded = isExpanded
        self.showChevron = showChevron
        self.haptic = haptic
        self.header = header
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header (always visible)
            Button {
                toggle()
            } label: {
                HStack {
                    header()

                    Spacer()

                    if showChevron {
                        Image(systemName: LubaExpandTokens.chevronIcon)
                            .font(LubaTypography.custom(size: 14, weight: .semibold))
                            .foregroundStyle(LubaColors.textTertiary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(LubaExpandTokens.chevronAnimation, value: isExpanded)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Content (expandable)
            if isExpanded {
                content()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipped()
        .animation(LubaExpandTokens.animation, value: isExpanded)
    }

    private func toggle() {
        if config.hapticsEnabled, let haptic = haptic {
            haptic.trigger()
        }
        isExpanded.toggle()
    }
}

// MARK: - Expandable Card

/// A card with an expandable section.
public struct LubaExpandableCard<Header: View, Content: View>: View {
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
                        .padding(.vertical, LubaSpacing.md)

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
    let items: [LubaAccordionItem]
    let allowMultiple: Bool

    @State private var expandedIds: Set<String> = []

    public init(items: [LubaAccordionItem], allowMultiple: Bool = false) {
        self.items = items
        self.allowMultiple = allowMultiple
    }

    public var body: some View {
        VStack(spacing: LubaSpacing.sm) {
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
                HStack(spacing: LubaSpacing.md) {
                    if let icon = item.icon {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundStyle(LubaColors.accent)
                            .frame(width: 24)
                    }

                    Text(item.title)
                        .font(LubaTypography.headline)
                        .foregroundStyle(LubaColors.textPrimary)
                }
            } content: {
                VStack(spacing: 0) {
                    LubaDivider()
                        .padding(.vertical, LubaSpacing.sm)

                    Text(item.content)
                        .font(LubaTypography.body)
                        .foregroundStyle(LubaColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

// MARK: - Expandable Modifier

/// Makes any view expandable with a toggle binding.
public struct LubaExpandableModifier<ExpandedContent: View>: ViewModifier {
    @Binding var isExpanded: Bool
    let expandedContent: () -> ExpandedContent

    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder expandedContent: @escaping () -> ExpandedContent
    ) {
        self._isExpanded = isExpanded
        self.expandedContent = expandedContent
    }

    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content

            if isExpanded {
                expandedContent()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipped()
        .animation(LubaExpandTokens.animation, value: isExpanded)
    }
}

// MARK: - View Extension

public extension View {
    /// Add expandable content below this view.
    ///
    /// The content appears/disappears with animation based on the binding.
    ///
    /// - Parameters:
    ///   - isExpanded: Binding controlling visibility
    ///   - content: The expandable content
    func lubaExpandable<Content: View>(
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(LubaExpandableModifier(isExpanded: isExpanded, expandedContent: content))
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
