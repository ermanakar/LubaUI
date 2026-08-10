//
//  LubaStrings.swift
//  LubaUI
//
//  Built-in user-facing and accessibility strings, localized by the package.
//
//  A design system that ships accessibility labels also ships a language.
//  These strings resolve through `Bundle.module`, so a German app gets German
//  VoiceOver output from LubaUI's own controls without doing anything.
//
//  Caller-provided labels always win — nothing here overrides an explicit
//  `label:` or `.accessibilityLabel(…)` supplied by the app.
//
//  Adding a language: drop a `<lang>.lproj/Localizable.strings` into
//  `Sources/LubaUI/Resources/` with the same keys.
//

import Foundation

// MARK: - Localized Strings

/// LubaUI's built-in localized strings.
///
/// Shipped languages: English (`en`, the development language) and German (`de`).
/// Unshipped languages fall back to English.
public enum LubaStrings {

    /// Look up a LubaUI string by key.
    ///
    /// - Parameters:
    ///   - key: The `Localizable.strings` key.
    ///   - fallback: The English value, used when no resource bundle is available.
    public static func localized(_ key: String, fallback: String) -> String {
        Bundle.module.localizedString(forKey: key, value: fallback, table: nil)
    }

    /// Look up a format string and substitute its arguments.
    public static func localized(_ key: String, fallback: String, _ arguments: CVarArg...) -> String {
        let format = Bundle.module.localizedString(forKey: key, value: fallback, table: nil)
        return String(format: format, locale: .current, arguments: arguments)
    }

    // MARK: - State

    /// Accessibility value for a control in its loading state.
    public static var loading: String { localized("luba.state.loading", fallback: "Loading") }

    /// Accessibility value for a disabled control.
    public static var disabled: String { localized("luba.state.disabled", fallback: "Disabled") }

    /// Accessibility label for a generic progress indicator.
    public static var progress: String { localized("luba.state.progress", fallback: "Progress") }

    /// Accessibility value for a percentage, e.g. "60 percent".
    public static func percent(_ value: Int) -> String {
        localized("luba.state.percent", fallback: "%d percent", value)
    }

    // MARK: - Actions

    public static var close: String { localized("luba.action.close", fallback: "Close") }
    public static var cancel: String { localized("luba.action.cancel", fallback: "Cancel") }
    public static var dismiss: String { localized("luba.action.dismiss", fallback: "Dismiss") }
    public static var delete: String { localized("luba.action.delete", fallback: "Delete") }
    public static var archive: String { localized("luba.action.archive", fallback: "Archive") }
    public static var pin: String { localized("luba.action.pin", fallback: "Pin") }
    public static var unread: String { localized("luba.action.unread", fallback: "Unread") }
    public static var flag: String { localized("luba.action.flag", fallback: "Flag") }
    public static var share: String { localized("luba.action.share", fallback: "Share") }

    /// Accessibility label for a chip's remove button, e.g. "Remove Design".
    public static func remove(_ label: String) -> String {
        localized("luba.action.remove", fallback: "Remove %@", label)
    }

    /// Accessibility label for dismissing an alert.
    public static var dismissAlert: String {
        localized("luba.alert.dismiss", fallback: "Dismiss alert")
    }

    // MARK: - Search

    public static var search: String { localized("luba.search.placeholder", fallback: "Search") }
    public static var clearSearch: String { localized("luba.search.clear", fallback: "Clear search") }
    public static var cancelSearch: String { localized("luba.search.cancel", fallback: "Cancel search") }

    // MARK: - Menu & Tooltip

    public static var menu: String { localized("luba.menu.label", fallback: "Menu") }
    public static var menuHint: String { localized("luba.menu.hint", fallback: "Shows menu options") }
    public static var tooltipHint: String {
        localized("luba.tooltip.hint", fallback: "Tap for more information")
    }

    // MARK: - Rating

    /// Accessibility value for a star rating, e.g. "3 of 5 stars".
    public static func rating(_ value: Int, of maximum: Int) -> String {
        localized("luba.rating.value", fallback: "%1$d of %2$d stars", value, maximum)
    }

    // MARK: - Expandable

    public static var expand: String { localized("luba.expandable.expand", fallback: "Expand") }
    public static var collapse: String { localized("luba.expandable.collapse", fallback: "Collapse") }
    public static var expanded: String { localized("luba.expandable.expanded", fallback: "Expanded") }
    public static var collapsed: String { localized("luba.expandable.collapsed", fallback: "Collapsed") }

    // MARK: - Charts

    public static var noData: String { localized("luba.chart.empty", fallback: "No data") }

    // MARK: - Status

    /// Spoken prefix for a status message, e.g. "Error: Could not save".
    public static func statusPrefix(_ role: LubaStatusRole) -> String {
        switch role {
        case .info: return localized("luba.status.info", fallback: "Information")
        case .success: return localized("luba.status.success", fallback: "Success")
        case .warning: return localized("luba.status.warning", fallback: "Warning")
        case .error: return localized("luba.status.error", fallback: "Error")
        }
    }

    /// A status message with its spoken prefix, e.g. "Error: Could not save".
    public static func statusMessage(_ role: LubaStatusRole, _ message: String) -> String {
        localized(
            "luba.status.message",
            fallback: "%1$@: %2$@",
            statusPrefix(role),
            message
        )
    }

    // MARK: - Control Names & Values

    public static var checkbox: String { localized("luba.control.checkbox", fallback: "Checkbox") }
    public static var toggle: String { localized("luba.control.toggle", fallback: "Toggle") }
    public static var slider: String { localized("luba.control.slider", fallback: "Slider") }
    public static var stepper: String { localized("luba.control.stepper", fallback: "Stepper") }
    public static var ratingControl: String { localized("luba.control.rating", fallback: "Rating") }
    public static var avatar: String { localized("luba.control.avatar", fallback: "Avatar") }

    public static var checked: String { localized("luba.value.checked", fallback: "Checked") }
    public static var unchecked: String { localized("luba.value.unchecked", fallback: "Unchecked") }
    public static var on: String { localized("luba.value.on", fallback: "On") }
    public static var off: String { localized("luba.value.off", fallback: "Off") }
    public static var selected: String { localized("luba.value.selected", fallback: "Selected") }
    public static var notSelected: String { localized("luba.value.notSelected", fallback: "Not selected") }

    /// Accessibility label for an avatar with initials, e.g. "Avatar, AK".
    public static func avatar(initials: String) -> String {
        localized("luba.control.avatarInitials", fallback: "Avatar, %@", initials)
    }

    /// Accessibility value for a field in an error state, e.g. "Error: Invalid address".
    public static func fieldError(_ message: String) -> String {
        statusMessage(.error, message)
    }

    // MARK: - Fields

    public static var email: String { localized("luba.field.email", fallback: "Email") }
    public static var password: String { localized("luba.field.password", fallback: "Password") }
    public static var required: String { localized("luba.field.required", fallback: "Required") }
}
