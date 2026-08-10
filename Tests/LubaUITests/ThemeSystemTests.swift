//
//  ThemeSystemTests.swift
//  LubaUI
//
//  Tests that the theme is a real source of truth, not a stored-and-ignored
//  environment value.
//
//  SwiftUI view rendering is not directly inspectable, so these tests target
//  the layer components actually resolve through: `LubaThemeColors` roles and
//  the `…(_ colors:)` / `…(in context:)` resolvers that every component calls.
//  If a component compiles against these resolvers, a custom theme reaches it.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class ThemeSystemTests: XCTestCase {

    // MARK: - Default Theme Preserves Appearance

    /// The default theme must be indistinguishable from the static tokens,
    /// otherwise 0.2.0 silently restyles every existing app.
    func testDefaultThemeMatchesStaticTokens() {
        let colors = LubaThemeColors.default

        XCTAssertEqual(colors.accent, LubaColors.accent)
        XCTAssertEqual(colors.accentHover, LubaColors.accentHover)
        XCTAssertEqual(colors.accentSubtle, LubaColors.accentSubtle)
        XCTAssertEqual(colors.background, LubaColors.background)
        XCTAssertEqual(colors.surface, LubaColors.surface)
        XCTAssertEqual(colors.surfaceSecondary, LubaColors.surfaceSecondary)
        XCTAssertEqual(colors.surfaceTertiary, LubaColors.surfaceTertiary)
        XCTAssertEqual(colors.surfaceHover, LubaColors.gray100)
        XCTAssertEqual(colors.textPrimary, LubaColors.textPrimary)
        XCTAssertEqual(colors.textSecondary, LubaColors.textSecondary)
        XCTAssertEqual(colors.textTertiary, LubaColors.textTertiary)
        XCTAssertEqual(colors.textDisabled, LubaColors.textDisabled)
        XCTAssertEqual(colors.textOnAccent, LubaColors.textOnAccent)
        XCTAssertEqual(colors.border, LubaColors.border)
        XCTAssertEqual(colors.borderStrong, LubaColors.gray400)
        XCTAssertEqual(colors.fill, LubaColors.gray200)
        XCTAssertEqual(colors.success, LubaColors.success)
        XCTAssertEqual(colors.warning, LubaColors.warning)
        XCTAssertEqual(colors.error, LubaColors.error)
        XCTAssertEqual(colors.chartGrid, LubaColors.Chart.grid)
        XCTAssertEqual(colors.chartAxisLabel, LubaColors.Chart.axisLabel)
        XCTAssertEqual(colors.chartPalette.count, LubaColors.Chart.palette.count)
    }

    func testDefaultThemeDerivedRoles() {
        let colors = LubaThemeColors.default
        XCTAssertEqual(colors.borderFocused, LubaColors.accent)
        XCTAssertEqual(colors.info, LubaColors.accent)
        XCTAssertEqual(colors.infoSubtle, LubaColors.accentSubtle)
        XCTAssertEqual(colors.divider, LubaColors.border)
        XCTAssertEqual(colors.surfaceElevated, colors.surfaceSecondary)
    }

    // MARK: - Custom Semantic Colors

    func testAccentedDerivesCoherentRamp() {
        let brand = Color(hex: 0x2F5FD0)
        let colors = LubaThemeColors.accented(brand)

        XCTAssertEqual(colors.accent, brand)
        XCTAssertEqual(colors.borderFocused, brand)
        XCTAssertEqual(colors.info, brand)
        XCTAssertEqual(colors.chartPalette.first, brand, "Charts should lead with the brand accent")
        XCTAssertNotEqual(colors.accentHover, LubaColors.accentHover)
        XCTAssertNotEqual(colors.accentSubtle, LubaColors.accentSubtle)
    }

    func testExplicitOverridesWinOverDerivation() {
        let colors = LubaThemeColors(
            accent: .blue,
            accentHover: .purple,
            accentSubtle: .mint,
            borderFocused: .pink
        )
        XCTAssertEqual(colors.accentHover, .purple)
        XCTAssertEqual(colors.accentSubtle, .mint)
        XCTAssertEqual(colors.borderFocused, .pink)
    }

    func testUnspecifiedRolesKeepDefaults() {
        // Rebranding the accent must not silently repaint surfaces or text.
        let colors = LubaThemeColors.accented(.blue)
        XCTAssertEqual(colors.background, LubaColors.background)
        XCTAssertEqual(colors.surface, LubaColors.surface)
        XCTAssertEqual(colors.textPrimary, LubaColors.textPrimary)
        XCTAssertEqual(colors.error, LubaColors.error)
    }

    func testStatusRoleResolution() {
        let colors = LubaThemeColors(success: .green, warning: .yellow, error: .red)
        XCTAssertEqual(colors.status(.success), .green)
        XCTAssertEqual(colors.status(.warning), .yellow)
        XCTAssertEqual(colors.status(.error), .red)
        XCTAssertEqual(colors.status(.info), colors.info)

        XCTAssertEqual(colors.statusSubtle(.success), colors.successSubtle)
        XCTAssertEqual(colors.statusSubtle(.error), colors.errorSubtle)
    }

    func testChartPaletteWrapsAround() {
        let colors = LubaThemeColors.default
        let count = colors.chartPalette.count
        XCTAssertEqual(colors.chartColor(at: 0), colors.chartPalette[0])
        XCTAssertEqual(colors.chartColor(at: count), colors.chartPalette[0])
        XCTAssertEqual(colors.chartColors(count: count + 2).count, count + 2)
        XCTAssertEqual(colors.chartColors(count: 0), [])
    }

    // MARK: - Components Resolve Through the Theme

    func testButtonStylesFollowTheme() {
        let brand = Color(hex: 0x2F5FD0)
        let colors = LubaThemeColors.accented(brand)
        let context = LubaButtonStyleContext(isPressed: false, colorScheme: .light, colors: colors)

        XCTAssertEqual(LubaPrimaryStyle().backgroundColor(in: context), brand)
        XCTAssertEqual(LubaGhostStyle().foregroundColor(in: context), brand)
        XCTAssertEqual(LubaSecondaryStyle().backgroundColor(in: context), colors.surface)
        XCTAssertEqual(LubaSecondaryStyle().borderColor(in: context), colors.border)
        XCTAssertEqual(LubaSubtleStyle().foregroundColor(in: context), colors.textSecondary)
    }

    func testButtonStylesRespondToPressState() {
        let colors = LubaThemeColors.default
        let idle = LubaButtonStyleContext(isPressed: false, colorScheme: .light, colors: colors)
        let pressed = LubaButtonStyleContext(isPressed: true, colorScheme: .light, colors: colors)

        XCTAssertEqual(LubaPrimaryStyle().backgroundColor(in: pressed), colors.accentHover)
        XCTAssertNotEqual(
            LubaPrimaryStyle().backgroundColor(in: idle),
            LubaPrimaryStyle().backgroundColor(in: pressed)
        )
        XCTAssertEqual(LubaSecondaryStyle().backgroundColor(in: pressed), colors.surfaceHover)
    }

    /// A style implementing only the legacy members must keep working, and must
    /// keep its own colors even when a theme is present.
    func testLegacyButtonStylingStillWorks() {
        struct LegacyStyle: LubaButtonStyling {
            func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color { .white }
            func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color { .orange }
            func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? { .brown }
        }

        let context = LubaButtonStyleContext(
            isPressed: false,
            colorScheme: .light,
            colors: .accented(.blue)
        )
        XCTAssertEqual(LegacyStyle().foregroundColor(in: context), .white)
        XCTAssertEqual(LegacyStyle().backgroundColor(in: context), .orange)
        XCTAssertEqual(LegacyStyle().borderColor(in: context), .brown)
    }

    func testFieldStateFollowsTheme() {
        let colors = LubaThemeColors(accent: .blue, border: .gray, error: .red)

        XCTAssertEqual(LubaFieldState.focused.labelColor(colors), .blue)
        XCTAssertEqual(LubaFieldState.focused.borderColor(colors), colors.borderFocused)
        XCTAssertEqual(LubaFieldState.error.borderColor(colors), .red)
        XCTAssertEqual(LubaFieldState.normal.borderColor(colors), .gray)
        XCTAssertEqual(LubaFieldState.disabled.labelColor(colors), colors.textDisabled)

        // Every state still resolves under the default palette.
        for state in [LubaFieldState.normal, .focused, .error, .disabled] {
            XCTAssertNotNil(state.labelColor(.default))
            XCTAssertNotNil(state.borderColor(.default))
            XCTAssertNotNil(state.iconColor(.default))
        }
    }

    func testAlertAndToastStylesFollowTheme() {
        let colors = LubaThemeColors(accent: .blue, success: .green, warning: .yellow, error: .red)

        XCTAssertEqual(LubaAlertStyle.success.color(colors), .green)
        XCTAssertEqual(LubaAlertStyle.error.color(colors), .red)
        XCTAssertEqual(LubaAlertStyle.info.color(colors), colors.info)
        XCTAssertEqual(LubaAlertStyle.warning.backgroundColor(colors), colors.warningSubtle)

        XCTAssertEqual(LubaToastStyle.success.color(colors), .green)
        XCTAssertEqual(LubaToastStyle.error.color(colors), .red)

        XCTAssertEqual(LubaAlertStyle.warning.role, .warning)
        XCTAssertEqual(LubaToastStyle.info.role, .info)
    }

    func testSwipeActionPresetsFollowTheme() {
        let colors = LubaThemeColors(accent: .blue, warning: .yellow, error: .red)

        XCTAssertEqual(LubaSwipeAction.delete {}.color(colors), .red)
        XCTAssertEqual(LubaSwipeAction.archive {}.color(colors), .blue)
        XCTAssertEqual(LubaSwipeAction.pin {}.color(colors), .yellow)
        XCTAssertEqual(LubaSwipeAction.share {}.color(colors), .blue)
    }

    /// An explicitly colored swipe action must ignore the theme.
    func testCustomSwipeActionKeepsItsColor() {
        let action = LubaSwipeAction(icon: "star", label: "Star", color: .purple) {}
        XCTAssertEqual(action.color(.accented(.blue)), .purple)
        XCTAssertEqual(action.color, .purple)
    }

    func testSparklineTrendFollowsTheme() {
        let colors = LubaThemeColors(success: .green, error: .red)
        XCTAssertEqual(LubaSparklineTrend.up.color(colors), .green)
        XCTAssertEqual(LubaSparklineTrend.down.color(colors), .red)
        XCTAssertEqual(LubaSparklineTrend.flat.color(colors), colors.textTertiary)
    }

    // MARK: - Theme Composition

    func testThemeConfigurationComposesParts() {
        let theme = LubaThemeConfiguration(
            colors: .accented(.blue),
            radius: LubaThemeRadius(md: 20)
        )
        XCTAssertEqual(theme.colors.accent, .blue)
        XCTAssertEqual(theme.radius.md, 20)
        // Untouched parts stay at the defaults.
        XCTAssertEqual(theme.spacing.lg, LubaSpacing.lg)
        XCTAssertEqual(theme.radius.sm, LubaRadius.sm)
    }

    func testThemeSpacingIncludesFullScale() {
        let spacing = LubaThemeSpacing.default
        XCTAssertEqual(spacing.xxs, LubaSpacing.xxs)
        XCTAssertEqual(spacing.huge, LubaSpacing.huge)
    }

    // MARK: - Roles Are Actually Wired

    /// A theme role that no component reads is a promise the library does not
    /// keep: `.lubaTheme(colors: LubaThemeColors(divider: .red))` compiles,
    /// documents itself as themeable, and changes nothing on screen.
    ///
    /// This scans the shipped component and primitive sources for a read of
    /// every declared role. Roles that are deliberately not consumed are listed
    /// below with the reason, so the exemption is a decision rather than an
    /// oversight.
    func testEveryThemeColorRoleIsReadBySomeComponent() throws {
        /// Roles resolved indirectly through `status(_:)` / `statusSubtle(_:)`,
        /// which components call instead of naming the role.
        let viaStatusResolver: Set<String> = [
            "success", "successSubtle", "warning", "warningSubtle",
            "error", "errorSubtle", "info", "infoSubtle"
        ]
        /// Roles for **app** surfaces. LubaUI components are placed onto these
        /// by the host app; the library never paints a full page itself.
        let appFacing: Set<String> = ["background", "surfaceTertiary"]
        /// Superseded by the semantic roles, kept so existing themes compile.
        let legacy: Set<String> = ["primary", "secondary"]

        let exempt = viaStatusResolver.union(appFacing).union(legacy)

        let sources = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()   // LubaUITests
            .deletingLastPathComponent()   // Tests
            .deletingLastPathComponent()   // package root
            .appendingPathComponent("Sources/LubaUI")

        let themeFile = sources.appendingPathComponent("Theme/LubaTheme.swift")
        let declarations = try String(contentsOf: themeFile, encoding: .utf8)
            .split(separator: "\n")
            .compactMap { line -> String? in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                guard trimmed.hasPrefix("public let "), trimmed.hasSuffix(": Color") else { return nil }
                return String(trimmed.dropFirst("public let ".count).dropLast(": Color".count))
            }
        XCTAssertFalse(declarations.isEmpty, "Could not parse any roles from \(themeFile.path)")

        var componentSource = ""
        for directory in ["Components", "Primitives"] {
            let root = sources.appendingPathComponent(directory)
            let files = try FileManager.default
                .contentsOfDirectory(at: root, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "swift" }
            for file in files {
                componentSource += try String(contentsOf: file, encoding: .utf8)
            }
        }

        let unread = declarations
            .filter { !exempt.contains($0) }
            .filter { !componentSource.contains("colors.\($0)") }

        XCTAssertTrue(
            unread.isEmpty,
            """
            Theme role(s) declared and documented as themeable but never read by \
            any component: \(unread.sorted().joined(separator: ", ")). Either read \
            the role from `luba.colors`, or add it to an exemption set above with \
            the reason.
            """
        )
    }

    /// A theme that rescales dimensions must actually move them, and the
    /// default scale must reproduce the Tier-1 values exactly so an unthemed
    /// app looks identical.
    func testDimensionResolversFollowTheThemeScale() {
        XCTAssertEqual(LubaCardTokens.cornerRadius(.default), LubaRadius.lg)
        XCTAssertEqual(LubaCardTokens.padding(.default), LubaSpacing.lg)
        XCTAssertEqual(LubaFieldTokens.cornerRadius(.default), LubaRadius.md)
        XCTAssertEqual(LubaButtonSize.medium.horizontalPadding(.default), LubaSpacing.custom(5))

        let squared = LubaThemeRadius(sm: 0, md: 0, lg: 0)
        XCTAssertEqual(LubaCardTokens.cornerRadius(squared), 0)
        XCTAssertEqual(LubaFieldTokens.cornerRadius(squared), 0)

        // Custom steps derive from `xs`, so a rescaled theme carries them too.
        let roomy = LubaThemeSpacing(xs: 8, md: 24, lg: 32)
        XCTAssertEqual(LubaCardTokens.padding(roomy), 32)
        XCTAssertEqual(LubaButtonSize.medium.horizontalPadding(roomy), 40)
    }

    /// The same promise applies to dimensions: `.lubaTheme(spacing:)` and
    /// `(radius:)` only mean something if components resolve through
    /// `luba.spacing` / `luba.radius` rather than reading the Tier-1 scales.
    ///
    /// A component may still *declare* a Tier-3 default as `= LubaSpacing.md`;
    /// what it must not do is read that scale while drawing.
    func testComponentsResolveDimensionsThroughTheTheme() throws {
        let sources = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Sources/LubaUI")

        var offenders: [String] = []

        for directory in ["Components", "Primitives"] {
            let root = sources.appendingPathComponent(directory)
            let files = try FileManager.default
                .contentsOfDirectory(at: root, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "swift" }

            for file in files {
                let lines = try String(contentsOf: file, encoding: .utf8).split(
                    separator: "\n", omittingEmptySubsequences: false
                )
                for (offset, raw) in lines.enumerated() {
                    let line = String(raw)
                    // Previews may use the authoring tier directly.
                    if line.hasPrefix("#Preview") || line.contains("MARK: - Preview") { break }
                    guard line.contains("LubaSpacing.") || line.contains("LubaRadius.") else { continue }
                    let trimmed = line.trimmingCharacters(in: .whitespaces)
                    // Prose may name the scale it documents.
                    if trimmed.hasPrefix("//") { continue }
                    // A Tier-3 token declaring its default is the one legitimate use.
                    if trimmed.hasPrefix("public static let") || trimmed.hasPrefix("static let") { continue }
                    offenders.append(
                        "\(file.lastPathComponent):\(offset + 1): \(trimmed)"
                    )
                }
            }
        }

        XCTAssertTrue(
            offenders.isEmpty,
            """
            Component code reads the Tier-1 dimension scale directly, so \
            `.lubaTheme(spacing:)` / `(radius:)` cannot reach it. Use \
            `luba.spacing` / `luba.radius`, or a Tier-3 resolver such as \
            `LubaCardTokens.padding(luba.spacing)`:
            \(offenders.joined(separator: "\n"))
            """
        )
    }
}
