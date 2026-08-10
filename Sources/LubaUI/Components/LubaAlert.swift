//
//  LubaAlert.swift
//  LubaUI
//
//  An inline notification banner for contextual messages.
//  Unlike LubaToast (overlay), LubaAlert lives in the layout flow.
//
//  Design Decisions:
//  - 16×12pt padding (on the spacing grid)
//  - 12pt corner radius (LubaRadius.md, on-grid)
//  - Color-tinted subtle background with accent border
//  - Optional dismiss button with haptic feedback
//

import SwiftUI

// MARK: - Alert Style

/// Semantic style for a ``LubaAlert``.
///
/// - ``info``: Neutral informational message.
/// - ``success``: Positive confirmation.
/// - ``warning``: Caution or upcoming expiration.
/// - ``error``: Failure or validation error.
public enum LubaAlertStyle {
    case info
    case success
    case warning
    case error

    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        }
    }

    /// The semantic status role this style maps to.
    public var role: LubaStatusRole {
        switch self {
        case .info: return .info
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        }
    }

    /// Icon/accent color, resolved against a theme palette.
    func color(_ colors: LubaThemeColors) -> Color { colors.status(role) }

    /// Banner background, resolved against a theme palette.
    func backgroundColor(_ colors: LubaThemeColors) -> Color { colors.statusSubtle(role) }

    var color: Color { color(.default) }
    var backgroundColor: Color { backgroundColor(.default) }
}

// MARK: - LubaAlert

/// An inline alert banner for contextual messages.
///
/// ```swift
/// LubaAlert("Your changes have been saved", style: .success)
/// LubaAlert("Please check your input", style: .error, isDismissible: true)
/// ```
public struct LubaAlert: View {
    @LubaEnvironment private var luba
    private let message: String
    private let style: LubaAlertStyle
    private let title: String?
    private let useGlass: Bool
    private let isDismissible: Bool
    private let onDismiss: (() -> Void)?


    /// Creates an inline alert banner.
    ///
    /// - Parameters:
    ///   - message: The alert body text.
    ///   - style: Semantic style controlling color and icon.
    ///   - title: Optional bold title above the message.
    ///   - useGlass: Whether to use a glass material background.
    ///   - isDismissible: Whether to show a dismiss button.
    ///   - onDismiss: Action called when dismissed.
    public init(
        _ message: String,
        style: LubaAlertStyle = .info,
        title: String? = nil,
        useGlass: Bool = false,
        isDismissible: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.style = style
        self.title = title
        self.useGlass = useGlass
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
    }

    public var body: some View {
        let content = HStack(alignment: .top, spacing: LubaAlertTokens.iconSpacing(luba.spacing)) {
            Image(systemName: style.icon)
                .font(.system(size: LubaAlertTokens.iconSize, weight: .medium))
                .foregroundStyle(style.color(luba.colors))
                .frame(width: LubaAlertTokens.iconFrameWidth)

            VStack(alignment: .leading, spacing: 2) {
                if let title = title {
                    Text(title)
                        .font(luba.fonts.subheadline)
                        .foregroundStyle(luba.colors.textPrimary)
                }

                Text(message)
                    .font(luba.fonts.bodySmall)
                    .foregroundStyle(luba.colors.textSecondary)
            }

            Spacer(minLength: 0)

            if isDismissible {
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: LubaAlertTokens.dismissIconSize, weight: .semibold))
                        .foregroundStyle(luba.colors.textTertiary)
                        .frame(width: LubaAlertTokens.dismissButtonSize, height: LubaAlertTokens.dismissButtonSize)
                        .frame(minWidth: luba.minimumTouchTarget, minHeight: luba.minimumTouchTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(LubaStrings.dismissAlert)
                .accessibilityAddTraits(.isButton)
            }
        }
        .padding(.horizontal, LubaAlertTokens.horizontalPadding(luba.spacing))
        .padding(.vertical, LubaAlertTokens.verticalPadding(luba.spacing))

        if useGlass {
            content
                .lubaGlass(.regular, tint: style.color(luba.colors), cornerRadius: luba.radius.md)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(LubaStrings.statusMessage(style.role, message))
                .accessibilityAddTraits(isDismissible ? .isButton : .isStaticText)
        } else {
            content
                .background(style.backgroundColor(luba.colors))
                .clipShape(RoundedRectangle(cornerRadius: luba.radius.md, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: luba.radius.md, style: .continuous)
                        .strokeBorder(style.color(luba.colors).opacity(0.2), lineWidth: 1)
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(LubaStrings.statusMessage(style.role, message))
                .accessibilityAddTraits(isDismissible ? .isButton : .isStaticText)
        }
    }

    private func dismiss() {
        if luba.hapticsEnabled {
            LubaHaptics.light()
        }
        onDismiss?()
    }
}

// MARK: - Accessibility

private extension LubaAlertStyle {
    var accessibilityPrefix: String {
        LubaStrings.statusPrefix(role)
    }
}

// MARK: - Preview

#Preview("Alert") {
    VStack(spacing: 12) {
        LubaAlert("This is an informational message.", style: .info)
        LubaAlert("Your changes have been saved.", style: .success)
        LubaAlert("Your trial expires in 3 days.", style: .warning, isDismissible: true)
        LubaAlert("Failed to save changes.", style: .error, title: "Error", isDismissible: true)
    }
    .padding(20)
    .background(LubaColors.background)
}
