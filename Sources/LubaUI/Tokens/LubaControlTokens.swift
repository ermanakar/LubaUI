//
//  LubaControlTokens.swift
//  LubaUI
//
//  Tokens for interactive controls: Checkbox, Radio, Toggle, Slider.
//  Centralizes sizing and spacing for consistency across selection controls.
//

import SwiftUI

// MARK: - Selection Control Tokens

/// Shared tokens for Checkbox and Radio controls
public enum LubaSelectionTokens {
    /// Control box/circle size
    public static let controlSize: CGFloat = 20

    /// Inner indicator size (radio dot, checkbox uses icon)
    public static let indicatorSize: CGFloat = 10

    /// Border width
    public static let borderWidth: CGFloat = 1.5

    /// Corner radius for checkbox
    public static let checkboxRadius: CGFloat = 5

    /// Checkmark icon size
    public static let checkmarkSize: CGFloat = 11

    /// Spacing between control and label
    public static let labelSpacing: CGFloat = 10

    /// Label font size
    public static let labelFontSize: CGFloat = 15

    /// Minimum touch target height
    public static let minTouchTarget: CGFloat = 44
}

// MARK: - Toggle Tokens

/// Tokens for Toggle switch
public enum LubaToggleTokens {
    /// Track width
    public static let trackWidth: CGFloat = 48

    /// Track height
    public static let trackHeight: CGFloat = 28

    /// Thumb diameter
    public static let thumbSize: CGFloat = 24

    /// Thumb horizontal padding from track edge
    public static let thumbPadding: CGFloat = 2

    /// Thumb shadow opacity
    public static let thumbShadowOpacity: Double = 0.1

    /// Thumb shadow radius
    public static let thumbShadowRadius: CGFloat = 2

    /// Spacing between label and toggle
    public static let labelSpacing: CGFloat = 12

    /// Label font size
    public static let labelFontSize: CGFloat = 15

    /// Minimum touch target height
    public static let minTouchTarget: CGFloat = 44
}

// MARK: - Slider Tokens

/// Tokens for Slider control
public enum LubaSliderTokens {
    /// Track height
    public static let trackHeight: CGFloat = 4

    /// Thumb diameter
    public static let thumbSize: CGFloat = 22

    /// Thumb border width
    public static let thumbBorderWidth: CGFloat = 2

    /// Thumb shadow opacity
    public static let thumbShadowOpacity: Double = 0.08

    /// Thumb shadow radius
    public static let thumbShadowRadius: CGFloat = 2

    /// Scale factor when dragging
    public static let thumbDragScale: CGFloat = 1.1

    /// Spacing between label row and track
    public static let labelSpacing: CGFloat = 8

    /// Label font size
    public static let labelFontSize: CGFloat = 15

    /// Value label font size
    public static let valueFontSize: CGFloat = 13
}
