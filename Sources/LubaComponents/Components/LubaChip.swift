//
//  LubaChip.swift
//  LubaUI
//
//  A dismissible filter tag for selections and categories.
//
//  Design Decisions:
//  - 32pt static chips; interactive chips honor the configured touch target
//  - Full pill shape (capsule) to distinguish from badges
//  - Filled and outlined styles
//  - Optional dismiss button with scale animation
//

import SwiftUI
import LubaCore

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
    /// Resolved against a theme's spacing scale.
    public static func horizontalPadding(_ spacing: LubaThemeSpacing) -> CGFloat { spacing.md }

    /// Visual chip height.
    public static let height: CGFloat = 32

    /// Leading icon font size.
    public static let iconFontSize: CGFloat = 12

    /// Dismiss glyph font size.
    public static let dismissIconFontSize: CGFloat = 9

    /// Dismiss glyph background size; the button expands to minimumTouchTarget.
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
    @LubaEnvironment private var luba
    private let label: String
    private let style: LubaChipStyle
    private let icon: Image?
    private let isSelected: Bool
    private let isDismissible: Bool
    private let onDismiss: (() -> Void)?
    private let onTap: (() -> Void)?


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
        HStack(spacing: 0) {
            if let onTap {
                Button {
                    if luba.hapticsEnabled { luba.haptics.trigger(.soft) }
                    onTap()
                } label: {
                    chipLabel
                        .padding(.horizontal, LubaChipTokens.horizontalPadding(luba.spacing))
                        .lubaMinTouchTarget(luba)
                        .contentShape(Rectangle())
                }
                .buttonStyle(LubaPressableButtonStyle())
                .accessibilityLabel(label)
                .accessibilityValue(isSelected ? LubaStrings.selected : "")
            } else {
                chipLabel
                    .padding(.horizontal, LubaChipTokens.horizontalPadding(luba.spacing))
                    .accessibilityLabel(label)
                    .accessibilityValue(isSelected ? LubaStrings.selected : "")
            }

            // Keep dismissal separate from selection: two sibling native buttons
            // give keyboard/VoiceOver users distinct actions and touch targets.
            if isDismissible {
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(luba.fonts.custom(size: LubaChipTokens.dismissIconFontSize, weight: .bold))
                        .frame(width: LubaChipTokens.dismissButtonSize, height: LubaChipTokens.dismissButtonSize)
                        .background(dismissBackground)
                        .clipShape(Circle())
                        .lubaMinTouchTarget(luba)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(LubaStrings.remove(label))
            }
        }
        .frame(minHeight: LubaChipTokens.height)
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .clipShape(chipShape)
        .overlay(borderOverlay)
        .accessibilityElement(children: .contain)
    }

    private var chipLabel: some View {
        HStack(spacing: LubaChipTokens.contentSpacing) {
            if let icon {
                icon.font(luba.fonts.custom(size: LubaChipTokens.iconFontSize, weight: .medium))
                    .accessibilityHidden(true)
            }
            Text(label)
                .font(luba.fonts.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }

    // MARK: - Styling

    private var foregroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? luba.colors.textOnAccent : luba.colors.accent
        case .outlined:
            return isSelected ? luba.colors.accent : luba.colors.textSecondary
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? luba.colors.accent : luba.colors.accentSubtle
        case .outlined:
            return isSelected ? luba.colors.accentSubtle : Color.clear
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            chipShape
                .strokeBorder(isSelected ? luba.colors.accent : luba.colors.border, lineWidth: LubaChipTokens.borderWidth)
        }
    }

    /// A capsule. Kept as one property so the fill and the outlined border
    /// can never drift apart.
    private var chipShape: Capsule { Capsule() }

    private var dismissBackground: Color {
        switch style {
        case .filled:
            return isSelected ? luba.colors.textOnAccent.opacity(0.2) : luba.colors.accent.opacity(0.15)
        case .outlined:
            return luba.colors.textTertiary.opacity(0.15)
        }
    }

    private func dismiss() {
        if luba.hapticsEnabled {
            luba.haptics.trigger(.soft)
        }
        onDismiss?()
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
