//
//  LubaSwipeable.swift
//  LubaUI
//
//  Reusable swipe actions primitive.
//  Add leading/trailing swipe actions to any view.
//
//  Usage:
//  ```swift
//  // Basic swipe to delete
//  ListRow()
//      .lubaSwipeable(
//          trailing: [.delete { removeItem() }]
//      )
//
//  // Multiple actions
//  MessageRow()
//      .lubaSwipeable(
//          leading: [.pin { pinMessage() }],
//          trailing: [.archive { archive() }, .delete { delete() }]
//      )
//  ```
//

import SwiftUI

// MARK: - Swipe Tokens

/// Configuration for swipe interactions.
public enum LubaSwipeTokens {
    /// Minimum swipe distance to reveal actions
    public static let revealThreshold: CGFloat = 60

    /// Distance to trigger full swipe action
    public static let fullSwipeThreshold: CGFloat = 0.6

    /// Action button width
    public static let actionWidth: CGFloat = 72

    /// Maximum actions on each side
    public static let maxActions: Int = 3

    /// Swipe animation
    public static var animation: Animation { LubaMotion.stateAnimation }

    /// Reset animation
    public static var resetAnimation: Animation {
        .spring(response: 0.3, dampingFraction: 0.8)
    }
}

// MARK: - Swipe Action

/// A swipe action with icon, color, and callback.
public struct LubaSwipeAction: Identifiable {
    public let id = UUID()
    public let icon: String
    public let label: String?
    public let color: Color
    public let haptic: LubaHapticStyle
    public let action: () -> Void

    public init(
        icon: String,
        label: String? = nil,
        color: Color,
        haptic: LubaHapticStyle = .medium,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.color = color
        self.haptic = haptic
        self.action = action
    }

    // MARK: - Preset Actions

    /// Delete action (red, trash icon)
    public static func delete(action: @escaping () -> Void) -> LubaSwipeAction {
        LubaSwipeAction(
            icon: "trash.fill",
            label: "Delete",
            color: LubaColors.error,
            haptic: .warning,
            action: action
        )
    }

    /// Archive action (accent, archive icon)
    public static func archive(action: @escaping () -> Void) -> LubaSwipeAction {
        LubaSwipeAction(
            icon: "archivebox.fill",
            label: "Archive",
            color: LubaColors.accent,
            haptic: .medium,
            action: action
        )
    }

    /// Pin action (warning/yellow, pin icon)
    public static func pin(action: @escaping () -> Void) -> LubaSwipeAction {
        LubaSwipeAction(
            icon: "pin.fill",
            label: "Pin",
            color: LubaColors.warning,
            haptic: .light,
            action: action
        )
    }

    /// Unread action (accent, envelope icon)
    public static func unread(action: @escaping () -> Void) -> LubaSwipeAction {
        LubaSwipeAction(
            icon: "envelope.badge.fill",
            label: "Unread",
            color: LubaColors.accent,
            haptic: .light,
            action: action
        )
    }

    /// Flag action (warning, flag icon)
    public static func flag(action: @escaping () -> Void) -> LubaSwipeAction {
        LubaSwipeAction(
            icon: "flag.fill",
            label: "Flag",
            color: LubaColors.warning,
            haptic: .light,
            action: action
        )
    }

    /// Share action (accent, share icon)
    public static func share(action: @escaping () -> Void) -> LubaSwipeAction {
        LubaSwipeAction(
            icon: "square.and.arrow.up",
            label: "Share",
            color: LubaColors.accent,
            haptic: .light,
            action: action
        )
    }
}

// MARK: - Swipeable Modifier

/// Makes any view swipeable with leading and/or trailing actions.
public struct LubaSwipeableModifier: ViewModifier {
    let leading: [LubaSwipeAction]
    let trailing: [LubaSwipeAction]
    let allowsFullSwipe: Bool

    @State private var offset: CGFloat = 0
    @State private var isRevealed: Bool = false
    @Environment(\.lubaConfig) private var config

    public init(
        leading: [LubaSwipeAction] = [],
        trailing: [LubaSwipeAction] = [],
        allowsFullSwipe: Bool = true
    ) {
        self.leading = Array(leading.prefix(LubaSwipeTokens.maxActions))
        self.trailing = Array(trailing.prefix(LubaSwipeTokens.maxActions))
        self.allowsFullSwipe = allowsFullSwipe
    }

    private var leadingWidth: CGFloat {
        CGFloat(leading.count) * LubaSwipeTokens.actionWidth
    }

    private var trailingWidth: CGFloat {
        CGFloat(trailing.count) * LubaSwipeTokens.actionWidth
    }

    public func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                // Leading actions (revealed when swiping right)
                if !leading.isEmpty {
                    HStack(spacing: 0) {
                        ForEach(leading) { action in
                            actionButton(action: action, width: LubaSwipeTokens.actionWidth)
                        }
                        Spacer()
                    }
                }

                // Trailing actions (revealed when swiping left)
                if !trailing.isEmpty {
                    HStack(spacing: 0) {
                        Spacer()
                        ForEach(trailing) { action in
                            actionButton(action: action, width: LubaSwipeTokens.actionWidth)
                        }
                    }
                }

                // Main content
                content
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                handleDrag(value: value, width: geo.size.width)
                            }
                            .onEnded { value in
                                handleDragEnd(value: value, width: geo.size.width)
                            }
                    )
            }
        }
    }

    private func actionButton(action: LubaSwipeAction, width: CGFloat) -> some View {
        Button {
            triggerAction(action)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: action.icon)
                    .font(.system(size: 20, weight: .medium))

                if let label = action.label {
                    Text(label)
                        .font(LubaTypography.custom(size: 11, weight: .medium))
                }
            }
            .foregroundStyle(.white)
            .frame(width: width)
            .frame(maxHeight: .infinity)
            .background(action.color)
        }
        .buttonStyle(.plain)
    }

    private func handleDrag(value: DragGesture.Value, width: CGFloat) {
        let translation = value.translation.width

        // Limit swipe range
        if translation > 0 && !leading.isEmpty {
            // Swiping right (reveal leading)
            let maxOffset = allowsFullSwipe ? width * LubaSwipeTokens.fullSwipeThreshold : leadingWidth
            offset = min(translation, maxOffset)
        } else if translation < 0 && !trailing.isEmpty {
            // Swiping left (reveal trailing)
            let maxOffset = allowsFullSwipe ? width * LubaSwipeTokens.fullSwipeThreshold : trailingWidth
            offset = max(translation, -maxOffset)
        }
    }

    private func handleDragEnd(value: DragGesture.Value, width: CGFloat) {
        let translation = value.translation.width
        let velocity = value.predictedEndTranslation.width - translation

        // Check for full swipe
        if allowsFullSwipe {
            let fullSwipeDistance = width * LubaSwipeTokens.fullSwipeThreshold

            if translation > fullSwipeDistance || velocity > 500 {
                // Full swipe right - trigger first leading action
                if let firstAction = leading.first {
                    performFullSwipe(action: firstAction, direction: 1, width: width)
                    return
                }
            } else if translation < -fullSwipeDistance || velocity < -500 {
                // Full swipe left - trigger first trailing action
                if let firstAction = trailing.first {
                    performFullSwipe(action: firstAction, direction: -1, width: width)
                    return
                }
            }
        }

        // Snap to revealed or reset
        withAnimation(LubaSwipeTokens.resetAnimation) {
            if translation > LubaSwipeTokens.revealThreshold && !leading.isEmpty {
                offset = leadingWidth
                isRevealed = true
            } else if translation < -LubaSwipeTokens.revealThreshold && !trailing.isEmpty {
                offset = -trailingWidth
                isRevealed = true
            } else {
                offset = 0
                isRevealed = false
            }
        }
    }

    private func performFullSwipe(action: LubaSwipeAction, direction: CGFloat, width: CGFloat) {
        withAnimation(LubaSwipeTokens.animation) {
            offset = direction * width
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            triggerAction(action)
            withAnimation(LubaSwipeTokens.resetAnimation) {
                offset = 0
            }
        }
    }

    private func triggerAction(_ action: LubaSwipeAction) {
        if config.hapticsEnabled {
            action.haptic.trigger()
        }
        action.action()

        withAnimation(LubaSwipeTokens.resetAnimation) {
            offset = 0
            isRevealed = false
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Make any view swipeable with leading and/or trailing actions.
    ///
    /// Swipe gestures reveal action buttons. Full swipe triggers the first action.
    ///
    /// - Parameters:
    ///   - leading: Actions revealed when swiping right
    ///   - trailing: Actions revealed when swiping left
    ///   - allowsFullSwipe: Whether full swipe triggers first action
    func lubaSwipeable(
        leading: [LubaSwipeAction] = [],
        trailing: [LubaSwipeAction] = [],
        allowsFullSwipe: Bool = true
    ) -> some View {
        modifier(LubaSwipeableModifier(
            leading: leading,
            trailing: trailing,
            allowsFullSwipe: allowsFullSwipe
        ))
    }
}

// MARK: - Preview

#Preview("Swipeable") {
    struct PreviewWrapper: View {
        @State private var items = ["Message 1", "Message 2", "Message 3", "Message 4"]
        @State private var lastAction = "Swipe an item"

        var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    Text(lastAction)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LubaColors.surfaceSecondary)

                    ScrollView {
                        VStack(spacing: 1) {
                            ForEach(items, id: \.self) { item in
                                HStack {
                                    Circle()
                                        .fill(LubaColors.gray200)
                                        .frame(width: 44, height: 44)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item)
                                            .font(LubaTypography.headline)
                                            .foregroundStyle(LubaColors.textPrimary)
                                        Text("Swipe me left or right")
                                            .font(LubaTypography.caption)
                                            .foregroundStyle(LubaColors.textSecondary)
                                    }

                                    Spacer()

                                    Text("2m")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textTertiary)
                                }
                                .padding()
                                .frame(height: 72)
                                .background(LubaColors.surface)
                                .lubaSwipeable(
                                    leading: [
                                        .pin { lastAction = "Pinned \(item)" },
                                        .unread { lastAction = "Marked \(item) unread" }
                                    ],
                                    trailing: [
                                        .archive { lastAction = "Archived \(item)" },
                                        .delete {
                                            lastAction = "Deleted \(item)"
                                            items.removeAll { $0 == item }
                                        }
                                    ]
                                )
                            }
                        }
                    }
                }
                .background(LubaColors.background)
                .navigationTitle("Swipeable")
            }
        }
    }

    return PreviewWrapper()
}
