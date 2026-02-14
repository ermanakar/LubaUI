//
//  LubaTypography.swift
//  LubaUI
//
//  Typography system using SF Rounded — friendly, premium, highly legible.
//

import SwiftUI

// MARK: - Typography Tokens

/// LubaUI's typography system.
/// Uses SF Rounded for a friendly, approachable, premium feel.
///
/// The scale follows Apple's Dynamic Type sizes where practical:
///   34, 26, 20, 17, 16, 15, 14, 13, 12, 11
///
/// **Hierarchy guide — choosing the right size:**
///
/// Display tier (large, bold — structural headings):
///   largeTitle (34) → title (26) → title2 (20) → title3 (17)
///
/// Content tier (regular weight — running text):
///   body (16) → bodySmall (14) → caption (12) → caption2 (11)
///
/// Supporting tier (specialized roles):
///   headline (16, semibold) — inline emphasis, same size as body
///   subheadline (14, medium) — supporting labels, same size as bodySmall
///   footnote (13) — attributions, helper text
///   code (13, monospaced) — code snippets
///
/// The bottom four sizes (11–14) are intentionally close. They are
/// differentiated by weight and context, not just size:
///   11pt = fine print you rarely read (caption2)
///   12pt = timestamps, metadata (caption)
///   13pt = footnotes, code (footnote, code)
///   14pt = secondary body text (bodySmall, subheadline)
public enum LubaTypography {

    // MARK: - Font Resolution

    /// Resolves a font based on global config (useRoundedFont, customFontFamily).
    /// Custom fonts override the system font entirely. Monospaced is always preserved.
    private static func font(size: CGFloat, weight: Font.Weight, design: Font.Design = .rounded) -> Font {
        let config = LubaConfig.shared
        if let family = config.customFontFamily {
            // Custom font family — preserve monospaced for code, use custom for everything else
            if design == .monospaced {
                return .system(size: size, weight: weight, design: .monospaced)
            }
            return .custom(family, size: size).weight(weight)
        }
        // System font — respect useRoundedFont toggle
        let resolvedDesign: Font.Design
        if design == .monospaced {
            resolvedDesign = .monospaced
        } else {
            resolvedDesign = config.useRoundedFont ? .rounded : .default
        }
        return .system(size: size, weight: weight, design: resolvedDesign)
    }

    // MARK: - Custom

    /// Config-aware font for component-specific sizes not covered by named tokens.
    /// Respects `useRoundedFont` and `customFontFamily` from `LubaConfig.shared`.
    public static func custom(size: CGFloat, weight: Font.Weight, design: Font.Design = .rounded) -> Font {
        font(size: size, weight: weight, design: design)
    }

    // MARK: - Display

    /// Large display text for hero sections
    /// Size: 34pt, Weight: Bold
    public static var largeTitle: Font { font(size: 34, weight: .bold) }

    /// Primary title for screens and sections
    /// Size: 26pt, Weight: Bold
    public static var title: Font { font(size: 26, weight: .bold) }

    /// Secondary title for subsections
    /// Size: 20pt, Weight: Semibold
    public static var title2: Font { font(size: 20, weight: .semibold) }

    /// Tertiary title for cards and groups
    /// Size: 17pt, Weight: Semibold
    public static var title3: Font { font(size: 17, weight: .semibold) }

    // MARK: - Headings

    /// Headline for emphasized inline content
    /// Size: 16pt, Weight: Semibold
    public static var headline: Font { font(size: 16, weight: .semibold) }

    /// Subheadline for supporting content
    /// Size: 14pt, Weight: Medium
    public static var subheadline: Font { font(size: 14, weight: .medium) }

    // MARK: - Body

    /// Primary body text
    /// Size: 16pt, Weight: Regular
    public static var body: Font { font(size: 16, weight: .regular) }

    /// Secondary body text (slightly smaller)
    /// Size: 14pt, Weight: Regular
    public static var bodySmall: Font { font(size: 14, weight: .regular) }

    // MARK: - Supporting

    /// Caption text for labels and metadata
    /// Size: 12pt, Weight: Regular
    public static var caption: Font { font(size: 12, weight: .regular) }

    /// Small caption for fine print
    /// Size: 11pt, Weight: Regular
    public static var caption2: Font { font(size: 11, weight: .regular) }

    /// Footnote for attributions
    /// Size: 13pt, Weight: Regular
    public static var footnote: Font { font(size: 13, weight: .regular) }

    // MARK: - Special

    /// Monospaced font for code (always monospaced, ignores useRoundedFont)
    /// Size: 13pt, Weight: Regular, Design: Monospaced
    public static var code: Font { font(size: 13, weight: .regular, design: .monospaced) }

    /// Button text
    /// Size: 15pt, Weight: Semibold
    public static var button: Font { font(size: 15, weight: .semibold) }

    /// Small button text
    /// Size: 13pt, Weight: Semibold
    public static var buttonSmall: Font { font(size: 13, weight: .semibold) }

    /// Large button text
    /// Size: 17pt, Weight: Semibold
    public static var buttonLarge: Font { font(size: 17, weight: .semibold) }
}
