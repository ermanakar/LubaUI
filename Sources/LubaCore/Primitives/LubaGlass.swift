//
//  LubaGlass.swift
//  LubaUI
//
//  Composable glass/frosted effect primitive.
//  Uses SwiftUI materials on all supported OS versions; native Liquid Glass is not implemented.
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

    /// The SwiftUI Material used on every supported OS version
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
/// Uses SwiftUI materials on all supported OS versions; native Liquid Glass is not implemented.
/// Provides a solid opaque fallback when Reduce Transparency or
/// High Contrast Mode is active.
public struct LubaGlassModifier: ViewModifier {
    @LubaEnvironment private var luba
    let style: LubaGlassStyle
    let tint: Color?
    let cornerRadius: CGFloat
    let isInteractive: Bool

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
        reduceTransparency || luba.config.highContrastMode
    }

    /// Solid opaque background for accessibility
    @ViewBuilder
    private var solidFallbackBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(luba.colors.surface.opacity(LubaGlassTokens.solidFallbackOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(luba.colors.border, lineWidth: 1)
            )
    }

    // MARK: - Material Rendering

    /// Material-based glass rendering for all supported versions
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
                    // The glass roles already carry their own light/dark
                    // luminance and opacity — applying the token ratios again
                    // here would double-attenuate them.
                    .strokeBorder(
                        luba.colors.glassBorder,
                        lineWidth: LubaGlassTokens.borderWidth
                    )
            )
            .shadow(
                color: luba.colors.glassShadow,
                radius: LubaGlassTokens.shadowRadius,
                x: 0,
                y: LubaGlassTokens.shadowY
            )
    }

    // MARK: - Adaptive Computed Properties

    private var tintOpacity: CGFloat {
        colorScheme == .dark
            ? LubaGlassTokens.tintOpacityDark
            : LubaGlassTokens.tintOpacityLight
    }

}

// MARK: - View Extension

public extension View {
    /// Apply a glass/frosted effect to this view.
    ///
    /// Uses SwiftUI materials on all supported OS versions; native Liquid Glass is not implemented.
    /// Provides a solid opaque fallback when Reduce Transparency or
    /// High Contrast Mode is active.
    ///
    /// - Parameters:
    ///   - style: Glass intensity (.subtle, .regular, .prominent)
    ///   - tint: Optional color tint applied over the glass
    ///   - cornerRadius: Corner radius for the glass surface
    ///   - isInteractive: Reserved for future native glass support; currently has no effect
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

/// Compatibility placeholder for future shared glass compositing.
/// Currently returns its content unchanged on every OS version.
public struct LubaGlassContainerModifier: ViewModifier {
    public func body(content: Content) -> some View { content }
}

public extension View {
    /// Compatibility placeholder; currently a no-op on every OS version.
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
