//
//  LubaMenu.swift
//  LubaUI
//
//  A contextual action menu that appears on tap.
//
//  Design Decisions:
//  - 200pt minimum width for comfortable reading
//  - 44pt item height (Apple HIG touch target)
//  - Scale+fade entrance from anchor point
//  - Uses native SwiftUI Menu under the hood for reliability,
//    styled with LubaUI tokens for consistency
//

import SwiftUI

// MARK: - Menu Item

public struct LubaMenuItem {
    public let label: String
    public let icon: Image?
    public let role: LubaMenuItemRole
    public let action: () -> Void

    public init(
        _ label: String,
        icon: Image? = nil,
        role: LubaMenuItemRole = .normal,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.role = role
        self.action = action
    }
}

public enum LubaMenuItemRole {
    case normal
    case destructive
}

// MARK: - LubaMenu

/// A contextual action menu triggered by tapping its label.
///
/// ```swift
/// LubaMenu(items: [
///     LubaMenuItem("Edit", icon: Image(systemName: "pencil")) { },
///     LubaMenuItem("Share", icon: Image(systemName: "square.and.arrow.up")) { },
///     LubaMenuItem("Delete", icon: Image(systemName: "trash"), role: .destructive) { }
/// ]) {
///     Image(systemName: "ellipsis.circle")
/// }
/// ```
public struct LubaMenu<Label: View>: View {
    private let items: [LubaMenuItem]
    private let label: Label

    public init(
        items: [LubaMenuItem],
        @ViewBuilder label: () -> Label
    ) {
        self.items = items
        self.label = label()
    }

    public var body: some View {
        Menu {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                Button(role: item.role == .destructive ? .destructive : nil) {
                    item.action()
                } label: {
                    SwiftUI.Label {
                        Text(item.label)
                    } icon: {
                        if let icon = item.icon {
                            icon
                        }
                    }
                }
            }
        } label: {
            label
        }
        .accessibilityLabel("Menu")
        .accessibilityHint("Shows menu options")
    }
}

// MARK: - Convenience for icon-button trigger

public extension LubaMenu where Label == LubaMenuLabel {
    /// Creates a menu with a standard ellipsis trigger button.
    init(
        items: [LubaMenuItem]
    ) {
        self.items = items
        self.label = LubaMenuLabel()
    }
}

/// Default menu trigger label — ellipsis icon.
public struct LubaMenuLabel: View {
    public var body: some View {
        Image(systemName: "ellipsis")
            .font(LubaTypography.custom(size: 16, weight: .medium))
            .foregroundStyle(LubaColors.textSecondary)
            .frame(width: LubaMenuTokens.itemHeight, height: LubaMenuTokens.itemHeight)
            .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview("Menu") {
    VStack(spacing: 40) {
        LubaMenu(items: [
            LubaMenuItem("Edit", icon: Image(systemName: "pencil")) { },
            LubaMenuItem("Duplicate", icon: Image(systemName: "doc.on.doc")) { },
            LubaMenuItem("Share", icon: Image(systemName: "square.and.arrow.up")) { },
            LubaMenuItem("Delete", icon: Image(systemName: "trash"), role: .destructive) { }
        ]) {
            Text("Tap for menu")
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.accent)
        }

        LubaMenu(items: [
            LubaMenuItem("Copy") { },
            LubaMenuItem("Move") { },
            LubaMenuItem("Delete", role: .destructive) { }
        ])
    }
    .padding(40)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LubaColors.background)
}
