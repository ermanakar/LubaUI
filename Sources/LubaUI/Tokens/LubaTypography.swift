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
    
    // MARK: - Display
    
    /// Large display text for hero sections
    /// Size: 34pt, Weight: Bold, Design: Rounded
    public static let largeTitle: Font = .system(size: 34, weight: .bold, design: .rounded)
    
    /// Primary title for screens and sections
    /// Size: 26pt, Weight: Bold, Design: Rounded
    public static let title: Font = .system(size: 26, weight: .bold, design: .rounded)
    
    /// Secondary title for subsections
    /// Size: 20pt, Weight: Semibold, Design: Rounded
    public static let title2: Font = .system(size: 20, weight: .semibold, design: .rounded)
    
    /// Tertiary title for cards and groups
    /// Size: 17pt, Weight: Semibold, Design: Rounded
    public static let title3: Font = .system(size: 17, weight: .semibold, design: .rounded)
    
    // MARK: - Headings
    
    /// Headline for emphasized inline content
    /// Size: 16pt, Weight: Semibold, Design: Rounded
    public static let headline: Font = .system(size: 16, weight: .semibold, design: .rounded)
    
    /// Subheadline for supporting content
    /// Size: 14pt, Weight: Medium, Design: Rounded
    public static let subheadline: Font = .system(size: 14, weight: .medium, design: .rounded)
    
    // MARK: - Body
    
    /// Primary body text
    /// Size: 16pt, Weight: Regular, Design: Rounded
    public static let body: Font = .system(size: 16, weight: .regular, design: .rounded)
    
    /// Secondary body text (slightly smaller)
    /// Size: 14pt, Weight: Regular, Design: Rounded
    public static let bodySmall: Font = .system(size: 14, weight: .regular, design: .rounded)
    
    // MARK: - Supporting
    
    /// Caption text for labels and metadata
    /// Size: 12pt, Weight: Regular, Design: Rounded
    public static let caption: Font = .system(size: 12, weight: .regular, design: .rounded)
    
    /// Small caption for fine print
    /// Size: 11pt, Weight: Regular, Design: Rounded
    public static let caption2: Font = .system(size: 11, weight: .regular, design: .rounded)
    
    /// Footnote for attributions
    /// Size: 13pt, Weight: Regular, Design: Rounded
    public static let footnote: Font = .system(size: 13, weight: .regular, design: .rounded)
    
    // MARK: - Special
    
    /// Monospaced font for code
    /// Size: 13pt, Weight: Regular, Design: Monospaced
    public static let code: Font = .system(size: 13, weight: .regular, design: .monospaced)
    
    /// Button text
    /// Size: 15pt, Weight: Semibold, Design: Rounded
    public static let button: Font = .system(size: 15, weight: .semibold, design: .rounded)
    
    /// Small button text
    /// Size: 13pt, Weight: Semibold, Design: Rounded
    public static let buttonSmall: Font = .system(size: 13, weight: .semibold, design: .rounded)
    
    /// Large button text
    /// Size: 17pt, Weight: Semibold, Design: Rounded
    public static let buttonLarge: Font = .system(size: 17, weight: .semibold, design: .rounded)
}
