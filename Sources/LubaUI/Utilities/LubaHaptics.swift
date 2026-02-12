//
//  LubaHaptics.swift
//  LubaUI
//
//  Haptic feedback utilities for a premium tactile experience.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Haptic Feedback

/// LubaUI's haptic feedback system for tactile responses.
public enum LubaHaptics {
    
    /// Light impact — for subtle interactions
    public static func light() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
    
    /// Medium impact — for button presses
    public static func medium() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
    
    /// Heavy impact — for significant actions
    public static func heavy() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        #endif
    }
    
    /// Soft impact — for gentle feedback
    public static func soft() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        #endif
    }
    
    /// Success notification
    public static func success() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }
    
    /// Warning notification
    public static func warning() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        #endif
    }
    
    /// Error notification
    public static func error() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #endif
    }
    
    /// Selection changed
    public static func selection() {
        #if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}
