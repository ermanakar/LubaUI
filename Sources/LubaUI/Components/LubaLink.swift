//
//  LubaLink.swift
//  LubaUI
//
//  An inline text link with accent styling and optional icon.
//
//  Design Decisions:
//  - Accent color to distinguish from body text
//  - No underline by default (cleaner), underline on press
//  - Optional trailing icon for external links
//  - 44pt minimum touch target via padding
//

import SwiftUI

// MARK: - Link Style

public enum LubaLinkStyle {
    case `default`
    case subtle
    case external
}

// MARK: - LubaLink

/// An inline text link for navigation and actions.
///
/// ```swift
/// LubaLink("Learn more") { openURL() }
/// LubaLink("Visit site", style: .external) { openURL() }
/// ```
public struct LubaLink: View {
    private let label: String
    private let style: LubaLinkStyle
    private let action: () -> Void

    @Environment(\.lubaConfig) private var config

    public init(
        _ label: String,
        style: LubaLinkStyle = .default,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: performAction) {
            HStack(spacing: 4) {
                Text(label)
                    .font(labelFont)
                    .foregroundStyle(labelColor)

                if style == .external {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(labelColor)
                }
            }
        }
        .buttonStyle(LinkButtonStyle(color: labelColor))
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isLink)
    }

    // MARK: - Styling

    private var labelFont: Font {
        switch style {
        case .default, .external:
            return .system(size: 16, weight: .medium, design: .rounded)
        case .subtle:
            return .system(size: 14, weight: .regular, design: .rounded)
        }
    }

    private var labelColor: Color {
        switch style {
        case .default, .external:
            return LubaColors.accent
        case .subtle:
            return LubaColors.textSecondary
        }
    }

    private func performAction() {
        if config.hapticsEnabled { LubaHaptics.light() }
        action()
    }
}

// MARK: - Button Style

private struct LinkButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .underline(configuration.isPressed, color: color)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// MARK: - Preview

#Preview("Link") {
    VStack(alignment: .leading, spacing: 16) {
        LubaLink("Learn more") { }
        LubaLink("Privacy policy", style: .subtle) { }
        LubaLink("Visit website", style: .external) { }
    }
    .padding(20)
    .background(LubaColors.background)
}
