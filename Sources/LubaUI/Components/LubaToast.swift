//
//  LubaToast.swift
//  LubaUI
//
//  A refined toast notification system.
//
//  Architecture:
//  - Uses LubaToastTokens for all dimensions
//  - Uses LubaMotion for animations
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - Toast Style

public enum LubaToastStyle {
    case info
    case success
    case warning
    case error

    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
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
}

// MARK: - Toast View

public struct LubaToast: View {
    private let message: String
    private let style: LubaToastStyle
    private let useGlass: Bool
    private let action: (() -> Void)?
    private let actionLabel: String?

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.lubaConfig) private var config

    public init(
        _ message: String,
        style: LubaToastStyle = .info,
        useGlass: Bool = false,
        action: (() -> Void)? = nil,
        actionLabel: String? = nil
    ) {
        self.message = message
        self.style = style
        self.useGlass = useGlass
        self.action = action
        self.actionLabel = actionLabel
    }

    public var body: some View {
        let content = HStack(spacing: LubaToastTokens.iconSpacing) {
            // Icon
            Image(systemName: style.icon)
                .font(.system(size: LubaToastTokens.iconSize, weight: .medium))
                .foregroundStyle(style.color)

            // Message
            Text(message)
                .font(LubaTypography.subheadline)
                .foregroundStyle(LubaColors.textPrimary)

            Spacer(minLength: 4)

            // Action button
            if let action = action, let label = actionLabel {
                Button {
                    if config.hapticsEnabled {
                        LubaHaptics.light()
                    }
                    action()
                } label: {
                    Text(label)
                        .font(LubaTypography.buttonSmall)
                        .foregroundStyle(style.color)
                }
            }
        }
        .padding(.horizontal, LubaToastTokens.horizontalPadding)
        .padding(.vertical, LubaToastTokens.verticalPadding)

        if useGlass {
            content
                .lubaGlass(.regular, tint: style.color, cornerRadius: LubaToastTokens.cornerRadius)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(style.accessibilityPrefix): \(message)")
                .accessibilityAddTraits(.isStaticText)
        } else {
            content
                .background(LubaColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: LubaToastTokens.cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: LubaToastTokens.cornerRadius, style: .continuous)
                        .strokeBorder(LubaColors.border.opacity(colorScheme == .dark ? 0.5 : 1), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(LubaToastTokens.shadowOpacity),
                    radius: LubaToastTokens.shadowBlur,
                    y: LubaToastTokens.shadowY
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(style.accessibilityPrefix): \(message)")
                .accessibilityAddTraits(.isStaticText)
        }
    }
}

private extension LubaToastStyle {
    var accessibilityPrefix: String {
        switch self {
        case .info: return "Information"
        case .success: return "Success"
        case .warning: return "Warning"
        case .error: return "Error"
        }
    }
}

// MARK: - Toast Modifier

public struct LubaToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let style: LubaToastStyle
    let duration: Double

    @Environment(\.lubaConfig) private var config

    public func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                if isPresented {
                    LubaToast(message, style: style)
                        .padding(.horizontal, LubaToastTokens.horizontalMargin)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation(config.animationsEnabled ? LubaMotion.stateAnimation : nil) {
                                    isPresented = false
                                }
                            }
                        }
                }

                Spacer()
            }
            .padding(.top, LubaToastTokens.topPadding)
            .animation(config.animationsEnabled ? LubaMotion.stateAnimation : nil, value: isPresented)
        }
    }
}

public extension View {
    func lubaToast(
        isPresented: Binding<Bool>,
        message: String,
        style: LubaToastStyle = .info,
        duration: Double = LubaToastTokens.defaultDuration
    ) -> some View {
        modifier(LubaToastModifier(
            isPresented: isPresented,
            message: message,
            style: style,
            duration: duration
        ))
    }
}

// MARK: - Preview

#Preview("Toast") {
    VStack(spacing: 12) {
        LubaToast("This is an info message", style: .info)
        LubaToast("Operation completed!", style: .success)
        LubaToast("Please check your input", style: .warning)
        LubaToast("Something went wrong", style: .error, action: {}, actionLabel: "Retry")
    }
    .padding(20)
    .background(LubaColors.background)
}
