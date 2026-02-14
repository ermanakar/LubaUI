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

    var color: Color {
        switch self {
        case .info: return LubaColors.accent
        case .success: return LubaColors.success
        case .warning: return LubaColors.warning
        case .error: return LubaColors.error
        }
    }

    var backgroundColor: Color {
        switch self {
        case .info: return LubaColors.accentSubtle
        case .success: return LubaColors.successSubtle
        case .warning: return LubaColors.warningSubtle
        case .error: return LubaColors.errorSubtle
        }
    }
}

// MARK: - LubaAlert

/// An inline alert banner for contextual messages.
///
/// ```swift
/// LubaAlert("Your changes have been saved", style: .success)
/// LubaAlert("Please check your input", style: .error, isDismissible: true)
/// ```
public struct LubaAlert: View {
    private let message: String
    private let style: LubaAlertStyle
    private let title: String?
    private let useGlass: Bool
    private let isDismissible: Bool
    private let onDismiss: (() -> Void)?

    @Environment(\.lubaConfig) private var config

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
        let content = HStack(alignment: .top, spacing: LubaAlertTokens.iconSpacing) {
            Image(systemName: style.icon)
                .font(.system(size: LubaAlertTokens.iconSize, weight: .medium))
                .foregroundStyle(style.color)
                .frame(width: LubaAlertTokens.iconFrameWidth)

            VStack(alignment: .leading, spacing: 2) {
                if let title = title {
                    Text(title)
                        .font(LubaTypography.subheadline)
                        .foregroundStyle(LubaColors.textPrimary)
                }

                Text(message)
                    .font(LubaTypography.bodySmall)
                    .foregroundStyle(LubaColors.textSecondary)
            }

            Spacer(minLength: 0)

            if isDismissible {
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: LubaAlertTokens.dismissIconSize, weight: .semibold))
                        .foregroundStyle(LubaColors.textTertiary)
                        .frame(width: LubaAlertTokens.dismissButtonSize, height: LubaAlertTokens.dismissButtonSize)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss alert")
                .accessibilityAddTraits(.isButton)
            }
        }
        .padding(.horizontal, LubaAlertTokens.horizontalPadding)
        .padding(.vertical, LubaAlertTokens.verticalPadding)

        if useGlass {
            content
                .lubaGlass(.regular, tint: style.color, cornerRadius: LubaRadius.md)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(style.accessibilityPrefix): \(message)")
                .accessibilityAddTraits(isDismissible ? .isButton : .isStaticText)
        } else {
            content
                .background(style.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous)
                        .strokeBorder(style.color.opacity(0.2), lineWidth: 1)
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(style.accessibilityPrefix): \(message)")
                .accessibilityAddTraits(isDismissible ? .isButton : .isStaticText)
        }
    }

    private func dismiss() {
        if config.hapticsEnabled {
            LubaHaptics.light()
        }
        onDismiss?()
    }
}

// MARK: - Accessibility

private extension LubaAlertStyle {
    var accessibilityPrefix: String {
        switch self {
        case .info: return "Information"
        case .success: return "Success"
        case .warning: return "Warning"
        case .error: return "Error"
        }
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
