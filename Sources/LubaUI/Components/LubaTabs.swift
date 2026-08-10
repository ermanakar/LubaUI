//
//  LubaTabs.swift
//  LubaUI
//
//  A refined tab bar component.
//
//  Architecture:
//  - Uses LubaTabsTokens for all dimensions
//  - Uses LubaMotion for animations
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - Selection Indicator

/// Applies the sliding-indicator geometry only when decorative motion is allowed.
///
/// `matchedGeometryEffect` animates position by construction, so a Reduce Motion
/// user still sees the indicator travel no matter how gentle the animation is.
/// The only way to hold it still is not to use it — under Reduce Motion the
/// indicator cross-fades in place instead, which reads as the same state change
/// without the movement.
private struct LubaTabIndicator: ViewModifier {
    let namespace: Namespace.ID
    let id: String
    let slides: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if slides {
            content.matchedGeometryEffect(id: id, in: namespace)
        } else {
            content.transition(.opacity)
        }
    }
}

// MARK: - LubaTabs (Segmented)

/// A segmented tab bar with animated selection indicator.
///
/// Use `LubaTabs` for pill-style segmented controls. For underline-style tabs,
/// see ``LubaUnderlineTabs``.
///
/// ```swift
/// LubaTabs(selection: $tab, tabs: [
///     (value: Tab.home, label: "Home", icon: "house"),
///     (value: Tab.search, label: "Search", icon: "magnifyingglass"),
/// ])
/// ```
///
/// Pass `useGlass: true` for a frosted glass background.
public struct LubaTabs<T: Hashable>: View {
    @LubaEnvironment private var luba
    @Binding private var selection: T
    private let tabs: [(value: T, label: String, icon: String?)]
    private let useGlass: Bool

    @Namespace private var namespace

    public init(
        selection: Binding<T>,
        tabs: [(value: T, label: String, icon: String?)],
        useGlass: Bool = false
    ) {
        self._selection = selection
        self.tabs = tabs
        self.useGlass = useGlass
    }

    /// Convenience init without icons
    public init(
        selection: Binding<T>,
        tabs: [(value: T, label: String)],
        useGlass: Bool = false
    ) {
        self._selection = selection
        self.tabs = tabs.map { ($0.value, $0.label, nil) }
        self.useGlass = useGlass
    }

    /// Backwards-compatible init with haptic parameter (now reads from config)
    public init(
        selection: Binding<T>,
        tabs: [(value: T, label: String, icon: String?)],
        haptic: Bool
    ) {
        self._selection = selection
        self.tabs = tabs
        self.useGlass = false
    }

    /// Backwards-compatible convenience init
    public init(
        selection: Binding<T>,
        tabs: [(value: T, label: String)],
        haptic: Bool
    ) {
        self._selection = selection
        self.tabs = tabs.map { ($0.value, $0.label, nil) }
        self.useGlass = false
    }

    public var body: some View {
        let container = HStack(spacing: LubaTabsTokens.segmentedSpacing) {
            ForEach(tabs, id: \.value) { tab in
                tabButton(for: tab)
            }
        }
        .padding(LubaTabsTokens.segmentedPadding)

        if useGlass {
            container
                .lubaGlass(.subtle, cornerRadius: LubaTabsTokens.segmentedContainerRadius(luba.radius))
        } else {
            container
                .background(luba.colors.surfaceHover)
                .clipShape(RoundedRectangle(cornerRadius: LubaTabsTokens.segmentedContainerRadius(luba.radius), style: .continuous))
        }
    }

    private func tabButton(for tab: (value: T, label: String, icon: String?)) -> some View {
        Button {
            guard selection != tab.value else { return }
            if luba.hapticsEnabled {
                LubaHaptics.selection()
            }
            luba.motion.run(LubaMotion.stateAnimation) {
                selection = tab.value
            }
        } label: {
            HStack(spacing: LubaTabsTokens.iconLabelSpacing(luba.spacing)) {
                if let icon = tab.icon {
                    Image(systemName: icon)
                        .font(.system(size: LubaTabsTokens.iconSize, weight: .medium))
                }

                Text(tab.label)
                    .font(luba.fonts.buttonSmall)
                    .lineLimit(1)
                    .minimumScaleFactor(LubaTabsTokens.minimumScaleFactor)
                    .truncationMode(.tail)
            }
            .foregroundStyle(selection == tab.value ? luba.colors.textPrimary : luba.colors.textSecondary)
            .padding(.horizontal, LubaTabsTokens.tabHorizontalPadding(luba.spacing))
            .frame(minHeight: LubaTabsTokens.tabHeight)
            .frame(maxWidth: .infinity)
            .background {
                if selection == tab.value {
                    RoundedRectangle(cornerRadius: LubaTabsTokens.segmentedTabRadius(luba.radius), style: .continuous)
                        .fill(luba.colors.surface)
                        .shadow(
                            color: Color.black.opacity(LubaTabsTokens.shadowOpacity),
                            radius: LubaTabsTokens.shadowRadius,
                            y: LubaTabsTokens.shadowY
                        )
                        .modifier(LubaTabIndicator(
                                namespace: namespace,
                                id: "tab",
                                slides: luba.motion.allowsDecorativeMotion
                            ))
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(tab.label)
        .accessibilityValue(selection == tab.value ? LubaStrings.selected : "")
        .accessibilityAddTraits(selection == tab.value ? [.isButton, .isSelected] : .isButton)
    }
}

// MARK: - LubaUnderlineTabs

/// An underline-style tab bar with animated selection indicator.
///
/// ```swift
/// LubaUnderlineTabs(selection: $section, tabs: [
///     (value: Section.overview, label: "Overview"),
///     (value: Section.details, label: "Details"),
/// ])
/// ```
public struct LubaUnderlineTabs<T: Hashable>: View {
    @LubaEnvironment private var luba
    @Binding private var selection: T
    private let tabs: [(value: T, label: String)]

    @Namespace private var namespace

    public init(
        selection: Binding<T>,
        tabs: [(value: T, label: String)]
    ) {
        self._selection = selection
        self.tabs = tabs
    }

    /// Backwards-compatible init with haptic parameter
    public init(
        selection: Binding<T>,
        tabs: [(value: T, label: String)],
        haptic: Bool
    ) {
        self._selection = selection
        self.tabs = tabs
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.value) { tab in
                underlineTabButton(for: tab)
            }
        }
    }

    private func underlineTabButton(for tab: (value: T, label: String)) -> some View {
        Button {
            guard selection != tab.value else { return }
            if luba.hapticsEnabled {
                LubaHaptics.selection()
            }
            luba.motion.run(LubaMotion.stateAnimation) {
                selection = tab.value
            }
        } label: {
            VStack(spacing: LubaTabsTokens.underlineSpacing) {
                Text(tab.label)
                    .font(luba.fonts.subheadline.weight(selection == tab.value ? .bold : .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(LubaTabsTokens.minimumScaleFactor)
                    .truncationMode(.tail)
                    .foregroundStyle(selection == tab.value ? luba.colors.accent : luba.colors.textTertiary)

                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: LubaTabsTokens.underlineIndicatorHeight)

                    if selection == tab.value {
                        Rectangle()
                            .fill(luba.colors.accent)
                            .frame(height: LubaTabsTokens.underlineIndicatorHeight)
                            .modifier(LubaTabIndicator(
                                namespace: namespace,
                                id: "underline",
                                slides: luba.motion.allowsDecorativeMotion
                            ))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: LubaTabsTokens.underlineHeight)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(tab.label)
        .accessibilityValue(selection == tab.value ? LubaStrings.selected : "")
        .accessibilityAddTraits(selection == tab.value ? [.isButton, .isSelected] : .isButton)
    }
}

// MARK: - Preview

#Preview("Tabs") {
    struct PreviewWrapper: View {
        @State private var tab1 = 0
        @State private var tab2 = "all"
        
        var body: some View {
            VStack(spacing: 24) {
                LubaTabs(
                    selection: $tab1,
                    tabs: [
                        (value: 0, label: "Daily"),
                        (value: 1, label: "Weekly"),
                        (value: 2, label: "Monthly")
                    ]
                )
                
                LubaUnderlineTabs(
                    selection: $tab2,
                    tabs: [
                        (value: "all", label: "All"),
                        (value: "active", label: "Active"),
                        (value: "done", label: "Completed")
                    ]
                )
            }
            .padding(20)
            .background(LubaColors.background)
        }
    }
    
    return PreviewWrapper()
}
