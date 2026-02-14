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

// MARK: - LubaTabs (Segmented)

public struct LubaTabs<T: Hashable>: View {
    @Binding private var selection: T
    private let tabs: [(value: T, label: String, icon: String?)]
    private let useGlass: Bool

    @Environment(\.lubaConfig) private var config
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
                .lubaGlass(.subtle, cornerRadius: LubaTabsTokens.segmentedContainerRadius)
        } else {
            container
                .background(LubaColors.gray100)
                .clipShape(RoundedRectangle(cornerRadius: LubaTabsTokens.segmentedContainerRadius, style: .continuous))
        }
    }

    private func tabButton(for tab: (value: T, label: String, icon: String?)) -> some View {
        Button {
            guard selection != tab.value else { return }
            if config.hapticsEnabled {
                LubaHaptics.selection()
            }
            withAnimation(config.animationsEnabled ? LubaMotion.stateAnimation : nil) {
                selection = tab.value
            }
        } label: {
            HStack(spacing: LubaTabsTokens.iconLabelSpacing) {
                if let icon = tab.icon {
                    Image(systemName: icon)
                        .font(.system(size: LubaTabsTokens.iconSize, weight: .medium))
                }

                Text(tab.label)
                    .font(LubaTypography.buttonSmall)
            }
            .foregroundStyle(selection == tab.value ? LubaColors.textPrimary : LubaColors.textSecondary)
            .padding(.horizontal, LubaTabsTokens.tabHorizontalPadding)
            .frame(height: LubaTabsTokens.tabHeight)
            .frame(maxWidth: .infinity)
            .background {
                if selection == tab.value {
                    RoundedRectangle(cornerRadius: LubaTabsTokens.segmentedTabRadius, style: .continuous)
                        .fill(LubaColors.surface)
                        .shadow(
                            color: Color.black.opacity(LubaTabsTokens.shadowOpacity),
                            radius: LubaTabsTokens.shadowRadius,
                            y: LubaTabsTokens.shadowY
                        )
                        .matchedGeometryEffect(id: "tab", in: namespace)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(tab.label)
        .accessibilityValue(selection == tab.value ? "Selected" : "")
        .accessibilityAddTraits(selection == tab.value ? [.isButton, .isSelected] : .isButton)
    }
}

// MARK: - LubaUnderlineTabs

public struct LubaUnderlineTabs<T: Hashable>: View {
    @Binding private var selection: T
    private let tabs: [(value: T, label: String)]

    @Environment(\.lubaConfig) private var config
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
            if config.hapticsEnabled {
                LubaHaptics.selection()
            }
            withAnimation(config.animationsEnabled ? LubaMotion.stateAnimation : nil) {
                selection = tab.value
            }
        } label: {
            VStack(spacing: LubaTabsTokens.underlineSpacing) {
                Text(tab.label)
                    .font(LubaTypography.custom(size: LubaTabsTokens.underlineFontSize, weight: selection == tab.value ? .bold : .medium))
                    .foregroundStyle(selection == tab.value ? LubaColors.accent : LubaColors.textTertiary)

                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: LubaTabsTokens.underlineIndicatorHeight)

                    if selection == tab.value {
                        Rectangle()
                            .fill(LubaColors.accent)
                            .frame(height: LubaTabsTokens.underlineIndicatorHeight)
                            .matchedGeometryEffect(id: "underline", in: namespace)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: LubaTabsTokens.underlineHeight)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(tab.label)
        .accessibilityValue(selection == tab.value ? "Selected" : "")
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
