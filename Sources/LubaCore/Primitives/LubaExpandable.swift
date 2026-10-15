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
///
/// ```swift
/// LubaExpandable(isExpanded: $isOpen) {
///     Text("Header")
/// } content: {
///     Text("Expandable content here")
/// }
/// ```
public struct LubaExpandable<Header: View, Content: View>: View {
    @LubaEnvironment private var luba
    @Binding var isExpanded: Bool
    let showChevron: Bool
    let haptic: LubaHapticStyle?
    let header: () -> Header
    let content: () -> Content


    /// Creates an expandable view.
    ///
    /// - Parameters:
    ///   - isExpanded: Binding controlling the expanded state.
    ///   - showChevron: Whether to display a rotation chevron indicator.
    ///   - haptic: Haptic feedback on toggle, or `nil` for none.
    ///   - header: The always-visible header content.
    ///   - content: The content revealed when expanded.
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
                            .font(luba.fonts.custom(size: 14, weight: .semibold))
                            .foregroundStyle(luba.colors.textTertiary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(luba.motion.decorative(LubaExpandTokens.chevronAnimation), value: isExpanded)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Content (expandable)
            if isExpanded {
                content()
                    .transition(luba.motion.transition(.opacity))
            }
        }
        .clipped()
        .animation(luba.motion.animation(LubaExpandTokens.animation), value: isExpanded)
    }

    private func toggle() {
        if luba.hapticsEnabled, let haptic = haptic {
            luba.haptics.trigger(haptic)
        }
        isExpanded.toggle()
    }
}

// MARK: - Expandable Modifier

/// Makes any view expandable with a toggle binding.
public struct LubaExpandableModifier<ExpandedContent: View>: ViewModifier {
    @LubaEnvironment private var luba
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
                    .transition(luba.motion.transition(.opacity))
            }
        }
        .clipped()
        .animation(luba.motion.animation(LubaExpandTokens.animation), value: isExpanded)
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
