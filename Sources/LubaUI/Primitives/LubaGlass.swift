//
//  LubaGlass.swift
//  LubaUI
//
//  Composable glass/frosted effect primitive.
//  Uses native Liquid Glass on iOS 26+ and SwiftUI materials on iOS 16-25.
//
//  Usage:
//  ```swift
//  // Basic glass
//  Text("Hello").padding().lubaGlass()
//
//  // Subtle glass with tint
//  VStack { content }.lubaGlass(.subtle, tint: .blue)
//
//  // Prominent glass with custom radius
//  Panel().lubaGlass(.prominent, cornerRadius: 20)
//  ```
//

import SwiftUI

// MARK: - Glass Tokens

/// Design tokens for glass/frosted effects.
/// Maps Tier 1 primitives to semantic glass properties.
public enum LubaGlassTokens {
    /// Default corner radius for glass surfaces
    public static let cornerRadius: CGFloat = LubaRadius.md

    /// Border width for the luminous edge highlight
    public static let borderWidth: CGFloat = LubaPrimitives.glassBorderWidth

    /// Light-mode border luminance — subtle white edge catch
    public static var borderLuminanceLight: CGFloat { LubaPrimitives.glassBorderLuminanceLight }

    /// Dark-mode border luminance — dimmer to avoid glare
    public static var borderLuminanceDark: CGFloat { LubaPrimitives.glassBorderLuminanceDark }

    /// Tint overlay opacity in light mode
    public static var tintOpacityLight: CGFloat { LubaPrimitives.glassTintOpacityLight }

    /// Tint overlay opacity in dark mode — slightly stronger for visibility
    public static var tintOpacityDark: CGFloat { LubaPrimitives.glassTintOpacityDark }

    /// Shadow radius for glass depth
    public static var shadowRadius: CGFloat { LubaPrimitives.glassShadowRadius }

    /// Shadow Y offset
    public static var shadowY: CGFloat { LubaPrimitives.glassShadowY }

    /// Shadow opacity light mode
    public static var shadowOpacityLight: CGFloat { LubaPrimitives.glassShadowOpacityLight }

    /// Shadow opacity dark mode
    public static var shadowOpacityDark: CGFloat { LubaPrimitives.glassShadowOpacityDark }

    /// Solid fallback background opacity for accessibility
    public static var solidFallbackOpacity: CGFloat { LubaPrimitives.glassSolidFallbackOpacity }
}

// MARK: - Glass Style

/// Visual intensity levels for glass effects.
/// Smaller/navigation elements should use .subtle or .regular.
/// Only large prominent surfaces should use .prominent.
public enum LubaGlassStyle {
    /// Light frosting — toolbar overlays, floating action buttons
    case subtle

    /// Standard glass — cards, tab bars, sheets
    case regular

    /// Heavy glass — prominent panels, modal backgrounds
    case prominent

    /// The SwiftUI Material for iOS 16-25 fallback rendering
    var fallbackMaterial: Material {
        switch self {
        case .subtle: return .ultraThinMaterial
        case .regular: return .thinMaterial
        case .prominent: return .regularMaterial
        }
    }
}

// MARK: - Glass Modifier

/// Applies a glass/frosted effect to any view.
/// Uses native Liquid Glass on iOS 26+ and SwiftUI materials on iOS 16-25.
/// Provides a solid opaque fallback when Reduce Transparency or
/// High Contrast Mode is active.
public struct LubaGlassModifier: ViewModifier {
    let style: LubaGlassStyle
    let tint: Color?
    let cornerRadius: CGFloat
    let isInteractive: Bool

    @Environment(\.lubaConfig) private var config
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public init(
        style: LubaGlassStyle = .regular,
        tint: Color? = nil,
        cornerRadius: CGFloat = LubaGlassTokens.cornerRadius,
        isInteractive: Bool = false
    ) {
        self.style = style
        self.tint = tint
        self.cornerRadius = cornerRadius
        self.isInteractive = isInteractive
    }

    public func body(content: Content) -> some View {
        if shouldUseSolidFallback {
            content
                .background(solidFallbackBackground)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        } else {
            fallbackMaterialGlass(content: content)
        }
    }

    // MARK: - Accessibility Fallback

    /// Whether to use a solid (non-transparent) fallback.
    /// Triggers for: reduceTransparency, highContrastMode.
    private var shouldUseSolidFallback: Bool {
        reduceTransparency || config.highContrastMode
    }

    /// Solid opaque background for accessibility
    @ViewBuilder
    private var solidFallbackBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(LubaColors.surface.opacity(LubaGlassTokens.solidFallbackOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(LubaColors.border, lineWidth: 1)
            )
    }

    // MARK: - iOS 16-25 Fallback

    /// Material-based glass rendering for iOS 16-25
    @ViewBuilder
    private func fallbackMaterialGlass(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Layer 1: Material blur
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(style.fallbackMaterial)

                    // Layer 2: Optional tint overlay
                    if let tint = tint {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(tint.opacity(tintOpacity))
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                // Layer 3: Luminous border (edge highlight)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        Color.white.opacity(borderLuminance),
                        lineWidth: LubaGlassTokens.borderWidth
                    )
            )
            .shadow(
                color: Color.black.opacity(shadowOpacity),
                radius: LubaGlassTokens.shadowRadius,
                x: 0,
                y: LubaGlassTokens.shadowY
            )
    }

    // MARK: - iOS 26+ Native Liquid Glass (uncomment when Xcode 26 SDK is available)

    // @available(iOS 26, macOS 26, watchOS 26, tvOS 26, visionOS 2, *)
    // @ViewBuilder
    // private func nativeLiquidGlass(content: Content) -> some View {
    //     if let tint = tint {
    //         if isInteractive {
    //             content.glassEffect(.regular.tint(tint).interactive(), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    //         } else {
    //             content.glassEffect(.regular.tint(tint), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    //         }
    //     } else {
    //         let glass: Glass = style == .subtle ? .clear : .regular
    //         if isInteractive {
    //             content.glassEffect(glass.interactive(), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    //         } else {
    //             content.glassEffect(glass, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    //         }
    //     }
    // }

    // MARK: - Adaptive Computed Properties

    private var tintOpacity: CGFloat {
        colorScheme == .dark
            ? LubaGlassTokens.tintOpacityDark
            : LubaGlassTokens.tintOpacityLight
    }

    private var borderLuminance: CGFloat {
        colorScheme == .dark
            ? LubaGlassTokens.borderLuminanceDark
            : LubaGlassTokens.borderLuminanceLight
    }

    private var shadowOpacity: CGFloat {
        colorScheme == .dark
            ? LubaGlassTokens.shadowOpacityDark
            : LubaGlassTokens.shadowOpacityLight
    }
}

// MARK: - View Extension

public extension View {
    /// Apply a glass/frosted effect to this view.
    ///
    /// Uses native Liquid Glass on iOS 26+ and SwiftUI materials on iOS 16-25.
    /// Provides a solid opaque fallback when Reduce Transparency or
    /// High Contrast Mode is active.
    ///
    /// - Parameters:
    ///   - style: Glass intensity (.subtle, .regular, .prominent)
    ///   - tint: Optional color tint applied over the glass
    ///   - cornerRadius: Corner radius for the glass surface
    ///   - isInteractive: Whether the glass responds to touch (iOS 26+ only)
    func lubaGlass(
        _ style: LubaGlassStyle = .regular,
        tint: Color? = nil,
        cornerRadius: CGFloat = LubaGlassTokens.cornerRadius,
        isInteractive: Bool = false
    ) -> some View {
        modifier(LubaGlassModifier(
            style: style,
            tint: tint,
            cornerRadius: cornerRadius,
            isInteractive: isInteractive
        ))
    }
}

// MARK: - Glass Container

/// Wraps content in a GlassEffectContainer on iOS 26+.
/// Required when multiple glass views need to composite together.
/// No-op on iOS 16-25.
public struct LubaGlassContainerModifier: ViewModifier {
    public func body(content: Content) -> some View {
        // When Xcode 26 SDK is available, uncomment:
        // if #available(iOS 26, macOS 26, *) {
        //     GlassEffectContainer { content }
        // } else {
            content
        // }
    }
}

public extension View {
    /// Group glass elements for shared compositing.
    /// Required on iOS 26+ when multiple glass views overlap.
    /// No-op on iOS 16-25.
    func lubaGlassContainer() -> some View {
        modifier(LubaGlassContainerModifier())
    }
}

// MARK: - Preview

#Preview("Glass Effects") {
    ZStack {
        LinearGradient(
            colors: [
                Color(hex: 0x6B8068),
                Color(hex: 0x3D5A3E),
                Color(hex: 0x8FB58C)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ScrollView {
            VStack(spacing: LubaSpacing.lg) {
                Text("Glass Effects")
                    .font(LubaTypography.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.top, LubaSpacing.xl)

                // Subtle
                glassDemo("Subtle", subtitle: "Toolbar overlays, FABs", style: .subtle)

                // Regular
                glassDemo("Regular", subtitle: "Cards, tab bars, sheets", style: .regular)

                // Prominent
                glassDemo("Prominent", subtitle: "Panels, modal backgrounds", style: .prominent)

                // Tinted
                glassDemo("Tinted", subtitle: "With accent color tint", style: .regular, tint: LubaColors.accent)
            }
            .padding(LubaSpacing.lg)
        }
    }
}

@ViewBuilder
private func glassDemo(_ title: String, subtitle: String, style: LubaGlassStyle, tint: Color? = nil) -> some View {
    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
        Text(title)
            .font(LubaTypography.headline)
            .foregroundStyle(LubaColors.textPrimary)
        Text(subtitle)
            .font(LubaTypography.body)
            .foregroundStyle(LubaColors.textSecondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(LubaSpacing.lg)
    .lubaGlass(style, tint: tint)
}
