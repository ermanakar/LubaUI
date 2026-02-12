//
//  LubaIcon.swift
//  LubaUI
//
//  A standardized icon wrapper with consistent sizing.
//
//  Architecture:
//  - Uses LubaIconTokens for press behavior
//  - Uses LubaMotion for animations
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - Icon Size

public enum LubaIconSize: CaseIterable {
    case xs     // 14pt
    case sm     // 18pt
    case md     // 22pt
    case lg     // 26pt
    case xl     // 32pt
    
    public var dimension: CGFloat {
        switch self {
        case .xs: return 14
        case .sm: return 18
        case .md: return 22
        case .lg: return 26
        case .xl: return 32
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .xs, .sm: return .regular
        case .md, .lg: return .medium
        case .xl: return .semibold
        }
    }
}

// MARK: - LubaIcon

/// A standardized icon with consistent sizing.
public struct LubaIcon: View {
    private let name: String
    private let size: LubaIconSize
    private let color: Color?
    
    public init(
        _ name: String,
        size: LubaIconSize = .md,
        color: Color? = nil
    ) {
        self.name = name
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        Image(systemName: name)
            .font(.system(size: size.dimension, weight: size.weight))
            .foregroundStyle(color ?? LubaColors.textSecondary)
    }
}

// MARK: - Icon Button

/// An icon wrapped in a tappable button with 44pt touch target.
public struct LubaIconButton: View {
    private let icon: String
    private let size: LubaIconSize
    private let color: Color?
    private let action: () -> Void

    @Environment(\.lubaConfig) private var config
    @State private var isPressed = false

    public init(
        _ icon: String,
        size: LubaIconSize = .md,
        color: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.action = action
    }

    /// Backwards-compatible init with haptic parameter (now reads from config)
    public init(
        _ icon: String,
        size: LubaIconSize = .md,
        color: Color? = nil,
        haptic: Bool,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button {
            if config.hapticsEnabled {
                LubaHaptics.light()
            }
            action()
        } label: {
            LubaIcon(icon, size: size, color: color)
                .frame(width: LubaIconTokens.touchTarget, height: LubaIconTokens.touchTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(IconPressStyle(isPressed: $isPressed))
        .scaleEffect(isPressed ? LubaIconTokens.pressScale : 1.0)
        .opacity(isPressed ? LubaIconTokens.pressOpacity : 1.0)
        .animation(config.animationsEnabled ? LubaMotion.micro : nil, value: isPressed)
        .accessibilityLabel(icon.replacingOccurrences(of: ".", with: " "))
        .accessibilityAddTraits(.isButton)
    }
}

private struct IconPressStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .preference(key: IconPressKey.self, value: configuration.isPressed)
            .onPreferenceChange(IconPressKey.self) { isPressed = $0 }
    }
}

private struct IconPressKey: PreferenceKey {
    static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) { value = nextValue() }
}

// MARK: - Circled Icon

/// An icon with a circular background.
public struct LubaCircledIcon: View {
    private let icon: String
    private let size: LubaIconSize
    private let style: Style

    public enum Style {
        case filled     // Accent bg, contrasting icon
        case subtle     // Accent subtle bg, accent icon
        case neutral    // Gray bg, gray icon
    }

    public init(
        _ icon: String,
        size: LubaIconSize = .md,
        style: Style = .subtle
    ) {
        self.icon = icon
        self.size = size
        self.style = style
    }

    private var backgroundColor: Color {
        switch style {
        case .filled: return LubaColors.accent
        case .subtle: return LubaColors.accentSubtle
        case .neutral: return LubaColors.gray100
        }
    }

    private var iconColor: Color {
        switch style {
        case .filled:
            return LubaColors.textOnAccent
        case .subtle:
            return LubaColors.accent
        case .neutral:
            return LubaColors.textSecondary
        }
    }

    private var circleSize: CGFloat {
        size.dimension * LubaIconTokens.circledPaddingMultiplier
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: circleSize, height: circleSize)

            LubaIcon(icon, size: size, color: iconColor)
        }
    }
}

// MARK: - Preview

#Preview("Icon") {
    VStack(spacing: 24) {
        // Sizes
        VStack(spacing: 8) {
            Text("SIZES").font(.caption).foregroundStyle(.secondary)
            HStack(spacing: 20) {
                ForEach(LubaIconSize.allCases, id: \.dimension) { iconSize in
                    VStack(spacing: 4) {
                        LubaIcon("heart.fill", size: iconSize, color: LubaColors.accent)
                        Text("\(Int(iconSize.dimension))")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        
        // Colors
        VStack(spacing: 8) {
            Text("SEMANTIC COLORS").font(.caption).foregroundStyle(.secondary)
            HStack(spacing: 16) {
                LubaIcon("checkmark.circle.fill", size: .lg, color: LubaColors.success)
                LubaIcon("exclamationmark.triangle.fill", size: .lg, color: LubaColors.warning)
                LubaIcon("xmark.circle.fill", size: .lg, color: LubaColors.error)
            }
        }
        
        // Buttons
        VStack(spacing: 8) {
            Text("ICON BUTTONS").font(.caption).foregroundStyle(.secondary)
            HStack(spacing: 8) {
                LubaIconButton("bell") { }
                LubaIconButton("gear") { }
                LubaIconButton("magnifyingglass") { }
                LubaIconButton("plus") { }
            }
        }
        
        // Circled
        VStack(spacing: 8) {
            Text("CIRCLED ICONS").font(.caption).foregroundStyle(.secondary)
            HStack(spacing: 16) {
                LubaCircledIcon("envelope", size: .md, style: .filled)
                LubaCircledIcon("heart", size: .md, style: .subtle)
                LubaCircledIcon("star", size: .md, style: .neutral)
            }
        }
    }
    .padding(24)
    .background(LubaColors.background)
}
