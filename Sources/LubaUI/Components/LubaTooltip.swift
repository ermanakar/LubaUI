//
//  LubaTooltip.swift
//  LubaUI
//
//  Contextual help that appears on tap.
//
//  Design Decisions:
//  - 240pt max width for comfortable reading
//  - 8pt corner radius (tight, informational feel)
//  - Auto-dismiss after 3s
//  - Scale+fade entrance from anchor point
//  - Available as both component and view modifier
//

import SwiftUI

// MARK: - Tooltip Position

public enum LubaTooltipPosition {
    case top
    case bottom
}

// MARK: - LubaTooltip

/// A tooltip that appears on tap to show contextual help.
///
/// As a wrapper:
/// ```swift
/// LubaTooltip("This field is required") {
///     Image(systemName: "info.circle")
/// }
/// ```
///
/// As a modifier:
/// ```swift
/// Text("Label")
///     .lubaTooltip("Helpful explanation")
/// ```
public struct LubaTooltip<Content: View>: View {
    private let message: String
    private let position: LubaTooltipPosition
    private let content: Content

    @State private var isPresented = false
    @Environment(\.lubaConfig) private var config

    public init(
        _ message: String,
        position: LubaTooltipPosition = .top,
        @ViewBuilder content: () -> Content
    ) {
        self.message = message
        self.position = position
        self.content = content()
    }

    public var body: some View {
        content
            .lubaPressable {
                if config.hapticsEnabled {
                    LubaHaptics.light()
                }
                withAnimation(LubaMotion.micro) {
                    isPresented.toggle()
                }
                if isPresented {
                    scheduleDismiss()
                }
            }
            .overlay(alignment: position == .top ? .top : .bottom) {
                if isPresented {
                    tooltipView
                        .offset(y: position == .top ? -(LubaTooltipTokens.offsetFromAnchor + 30) : LubaTooltipTokens.offsetFromAnchor + 30)
                        .transition(.scale(scale: 0.9, anchor: position == .top ? .bottom : .top).combined(with: .opacity))
                }
            }
            .accessibilityHint("Tap for more information")
    }

    private var tooltipView: some View {
        Text(message)
            .font(LubaTypography.footnote)
            .foregroundStyle(LubaColors.textPrimary)
            .padding(LubaTooltipTokens.padding)
            .frame(maxWidth: LubaTooltipTokens.maxWidth)
            .background(LubaColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: LubaTooltipTokens.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: LubaTooltipTokens.cornerRadius, style: .continuous)
                    .strokeBorder(LubaColors.border, lineWidth: 1)
            )
            .shadow(
                color: Color.black.opacity(LubaTooltipTokens.shadowOpacity),
                radius: LubaTooltipTokens.shadowBlur,
                y: LubaTooltipTokens.shadowY
            )
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityLabel(message)
            .accessibilityAddTraits(.isStaticText)
    }

    private func scheduleDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + LubaTooltipTokens.dismissDuration) {
            withAnimation(LubaMotion.micro) {
                isPresented = false
            }
        }
    }
}

// MARK: - View Modifier

public extension View {
    /// Adds a tooltip that appears when this view is tapped.
    func lubaTooltip(_ message: String, position: LubaTooltipPosition = .top) -> some View {
        LubaTooltip(message, position: position) {
            self
        }
    }
}

// MARK: - Preview

#Preview("Tooltip") {
    VStack(spacing: 60) {
        LubaTooltip("This is a helpful tooltip that explains something.") {
            Image(systemName: "info.circle")
                .font(.system(size: 20))
                .foregroundStyle(LubaColors.accent)
        }

        Text("Tap me for help")
            .font(LubaTypography.body)
            .foregroundStyle(LubaColors.textSecondary)
            .lubaTooltip("Here's some extra context about this feature.", position: .bottom)
    }
    .padding(40)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LubaColors.background)
}
