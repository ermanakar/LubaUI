//
//  LubaUI.swift
//  LubaUI
//
//  A modern SwiftUI design system with design tokens, theming, and reusable components.
//

import SwiftUI

// MARK: - Public Exports

// Re-export all public APIs for convenient access
@_exported import struct SwiftUI.Color
@_exported import struct SwiftUI.Font

/// The LubaUI design system namespace.
///
/// LubaUI provides design tokens, composable primitives, and accessible components
/// for SwiftUI. Use ``LubaUI/version`` to check the current library version.
///
/// ```swift
/// import LubaUI
///
/// Text(LubaUI.name)       // "LubaUI"
/// Text(LubaUI.version)    // "0.1.0"
/// ```
public enum LubaUI {
    /// The current library version.
    public static let version = "0.1.0"

    /// The library name.
    public static let name = "LubaUI"
}
