//
//  LubaChip.swift
//  LubaUI
//
//  A dismissible filter tag for selections and categories.
//
//  Design Decisions:
//  - 32pt height for comfortable touch targets
//  - Full pill shape (capsule) to distinguish from badges
//  - Filled and outlined styles
//  - Optional dismiss button with scale animation
//

import SwiftUI

// MARK: - Chip Style

/// Visual style for a ``LubaChip``.
public enum LubaChipStyle {
    case filled
    case outlined
}

// MARK: - Chip Tokens

/// Design tokens for LubaChip.
public enum LubaChipTokens {
    /// Spacing between icon, label, and dismiss affordance.
    public static let contentSpacing: CGFloat = LubaMotion.iconLabelSpacing

    /// Horizontal content inset.
    public static let horizontalPadding: CGFloat = LubaSpacing.md

    /// Visual chip height.
    public static let height: CGFloat = 32

    /// Leading icon font size.
    public static let iconFontSize: CGFloat = 12

    /// Dismiss glyph font size.
    public static let dismissIconFontSize: CGFloat = 9

    /// Dismiss button hit area inside chip.
    public static let dismissButtonSize: CGFloat = 16

    /// Border width for outlined style.
    public static let borderWidth: CGFloat = 1
}

// MARK: - LubaChip

/// A dismissible chip for filters, tags, and selections.
///
/// ```swift
/// LubaChip("Swift")
/// LubaChip("Design", style: .outlined, isDismissible: true) { print("removed") }
/// ```
public struct LubaChip: View {
    private let label: String
    private let style: LubaChipStyle
    private let icon: Image?
    private let isSelected: Bool
    private let isDismissible: Bool
    private let onDismiss: (() -> Void)?
    private let onTap: (() -> Void)?

    @Environment(\.lubaConfig) private var config

    /// Creates a chip.
    ///
    /// - Parameters:
    ///   - label: The chip label text.
    ///   - style: Visual style (filled or outlined).
    ///   - icon: Optional leading icon.
    ///   - isSelected: Whether the chip is selected.
    ///   - isDismissible: Whether to show a dismiss button.
    ///   - onDismiss: Action called when the dismiss button is tapped.
    ///   - onTap: Action called when the chip itself is tapped.
    public init(
        _ label: String,
        style: LubaChipStyle = .filled,
        icon: Image? = nil,
        isSelected: Bool = false,
        isDismissible: Bool = false,
        onDismiss: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.label = label
        self.style = style
        self.icon = icon
        self.isSelected = isSelected
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: LubaChipTokens.contentSpacing) {
            if let icon = icon {
                icon
                    .font(LubaTypography.custom(size: LubaChipTokens.iconFontSize, weight: .medium))
            }

            Text(label)
                .font(LubaTypography.subheadline)

            if isDismissible {
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(LubaTypography.custom(size: LubaChipTokens.dismissIconFontSize, weight: .bold))
                        .frame(width: LubaChipTokens.dismissButtonSize, height: LubaChipTokens.dismissButtonSize)
                        .background(dismissBackground)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Remove \(label)")
            }
        }
        .padding(.horizontal, LubaChipTokens.horizontalPadding)
        .frame(height: LubaChipTokens.height)
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .clipShape(Capsule())
        .overlay(borderOverlay)
        .if(onTap != nil) { view in
            view.lubaPressable { onTap?() }
        }
        .accessibilityLabel(label)
        .accessibilityAddTraits(onTap != nil ? .isButton : .isStaticText)
        .accessibilityValue(isSelected ? "Selected" : "")
    }

    // MARK: - Styling

    private var foregroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? LubaColors.textOnAccent : LubaColors.accent
        case .outlined:
            return isSelected ? LubaColors.accent : LubaColors.textSecondary
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? LubaColors.accent : LubaColors.accentSubtle
        case .outlined:
            return isSelected ? LubaColors.accentSubtle : Color.clear
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            Capsule()
                .strokeBorder(isSelected ? LubaColors.accent : LubaColors.border, lineWidth: LubaChipTokens.borderWidth)
        }
    }

    private var dismissBackground: Color {
        switch style {
        case .filled:
            return isSelected ? LubaColors.textOnAccent.opacity(0.2) : LubaColors.accent.opacity(0.15)
        case .outlined:
            return LubaColors.textTertiary.opacity(0.15)
        }
    }

    private func dismiss() {
        if config.hapticsEnabled {
            LubaHaptics.soft()
        }
        onDismiss?()
    }
}

// MARK: - Conditional Modifier

private extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview

#Preview("Chip") {
    VStack(spacing: 16) {
        HStack(spacing: 8) {
            LubaChip("Swift", icon: Image(systemName: "swift"))
            LubaChip("Design", isSelected: true)
            LubaChip("Remove me", isDismissible: true)
        }

        HStack(spacing: 8) {
            LubaChip("Outlined", style: .outlined)
            LubaChip("Selected", style: .outlined, isSelected: true)
            LubaChip("Dismiss", style: .outlined, isDismissible: true)
        }
    }
    .padding(20)
    .background(LubaColors.background)
}
