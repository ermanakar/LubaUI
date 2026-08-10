//
//  TypographyTests.swift
//  LubaUI
//
//  Tests that the type scale is expressed relative to Apple text styles
//  (so it scales with Dynamic Type) and that theme/config overrides apply.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class TypographyTests: XCTestCase {

    // MARK: - Dynamic Type Mapping

    /// The whole point: every role is anchored to a text style, so none of them
    /// is a frozen point size.
    func testEveryRoleMapsToATextStyle() {
        for role in LubaTextRole.allCases {
            XCTAssertGreaterThan(role.nominalSize, 0, "\(role) has no nominal size")
            _ = role.textStyle
            _ = role.weight
            _ = role.design
        }
        XCTAssertEqual(LubaTextRole.allCases.count, 15)
    }

    func testRoleTextStyleAnchors() {
        XCTAssertEqual(LubaTextRole.largeTitle.textStyle, .largeTitle)
        XCTAssertEqual(LubaTextRole.title.textStyle, .title)
        XCTAssertEqual(LubaTextRole.title2.textStyle, .title3)
        XCTAssertEqual(LubaTextRole.title3.textStyle, .headline)
        XCTAssertEqual(LubaTextRole.body.textStyle, .callout)
        XCTAssertEqual(LubaTextRole.caption.textStyle, .caption)
        XCTAssertEqual(LubaTextRole.caption2.textStyle, .caption2)
        XCTAssertEqual(LubaTextRole.footnote.textStyle, .footnote)
        XCTAssertEqual(LubaTextRole.buttonLarge.textStyle, .body)
    }

    /// Nominal sizes must match the anchor text style's size at the default
    /// content size, or custom-font apps drift away from system-font apps.
    func testNominalSizesMatchTheirTextStyle() {
        let systemSizes: [Font.TextStyle: CGFloat] = [
            .largeTitle: 34, .title: 28, .title2: 22, .title3: 20,
            .headline: 17, .body: 17, .callout: 16, .subheadline: 15,
            .footnote: 13, .caption: 12, .caption2: 11
        ]
        for role in LubaTextRole.allCases {
            guard let expected = systemSizes[role.textStyle] else {
                XCTFail("Unmapped text style for \(role)")
                continue
            }
            XCTAssertEqual(role.nominalSize, expected, "\(role) nominal size drifts from its text style")
        }
    }

    func testDisplayScaleIsMonotonic() {
        let ordered: [LubaTextRole] = [.caption2, .caption, .footnote, .subheadline, .body, .title3, .title2, .title, .largeTitle]
        for i in 0..<(ordered.count - 1) {
            XCTAssertLessThanOrEqual(
                ordered[i].nominalSize,
                ordered[i + 1].nominalSize,
                "\(ordered[i]) should not be larger than \(ordered[i + 1])"
            )
        }
    }

    func testWeightsAndDesigns() {
        XCTAssertEqual(LubaTextRole.largeTitle.weight, .bold)
        XCTAssertEqual(LubaTextRole.body.weight, .regular)
        XCTAssertEqual(LubaTextRole.button.weight, .semibold)
        XCTAssertEqual(LubaTextRole.code.design, .monospaced)
        XCTAssertEqual(LubaTextRole.body.design, .rounded)
    }

    // MARK: - Config Resolution

    func testFontsResolveForEveryConfig() {
        var rounded = LubaConfig()
        rounded.useRoundedFont = true

        var plain = LubaConfig()
        plain.useRoundedFont = false

        var custom = LubaConfig()
        custom.customFontFamily = "Helvetica Neue"

        var bold = LubaConfig()
        bold.useBoldText = true

        for config in [rounded, plain, custom, bold] {
            for role in LubaTextRole.allCases {
                _ = LubaTypography.font(role, config: config)
            }
        }
    }

    /// The rounded/plain switch must actually change the resolved font.
    func testRoundedToggleChangesFont() {
        var rounded = LubaConfig(); rounded.useRoundedFont = true
        var plain = LubaConfig(); plain.useRoundedFont = false
        XCTAssertNotEqual(
            LubaTypography.font(.body, config: rounded),
            LubaTypography.font(.body, config: plain)
        )
    }

    func testBoldTextChangesWeight() {
        var normal = LubaConfig()
        var bold = LubaConfig(); bold.useBoldText = true
        normal.useBoldText = false
        XCTAssertNotEqual(
            LubaTypography.font(.body, config: normal),
            LubaTypography.font(.body, config: bold)
        )
    }

    func testCustomFontFamilyKeepsCodeMonospaced() {
        var custom = LubaConfig()
        custom.customFontFamily = "Helvetica Neue"
        // Monospaced is preserved regardless of family, so code stays code.
        XCTAssertEqual(
            LubaTypography.font(.code, config: custom),
            LubaTypography.font(.code, config: LubaConfig())
        )
        XCTAssertNotEqual(
            LubaTypography.font(.body, config: custom),
            LubaTypography.font(.body, config: LubaConfig())
        )
    }

    // MARK: - Theme Overrides

    func testThemeTypographyOverridesWin() {
        let theme = LubaThemeTypography(body: .system(size: 99))
        XCTAssertTrue(theme.overridesRole(.body))
        XCTAssertFalse(theme.overridesRole(.title))
        XCTAssertEqual(theme.font(.body), .system(size: 99))
        XCTAssertEqual(theme.font(.title), LubaTypography.font(.title))
    }

    func testUnspecifiedThemeTypographyFollowsConfig() {
        var plain = LubaConfig()
        plain.useRoundedFont = false

        let theme = LubaThemeTypography()
        XCTAssertEqual(theme.font(.body, config: plain), LubaTypography.font(.body, config: plain))
        XCTAssertNotEqual(theme.font(.body, config: plain), LubaTypography.font(.body, config: LubaConfig()))
    }

    func testFontSetResolvesThemeAndConfig() {
        var plain = LubaConfig()
        plain.useRoundedFont = false

        let fonts = LubaFontSet(
            typography: LubaThemeTypography(title: .system(size: 42)),
            config: plain
        )
        XCTAssertEqual(fonts.title, .system(size: 42))
        XCTAssertEqual(fonts.body, LubaTypography.font(.body, config: plain))
        XCTAssertEqual(fonts(.caption), fonts.caption)
        _ = fonts.custom(size: 13, weight: .medium, relativeTo: .footnote)
    }

    func testLegacyStaticTokensStillResolve() {
        _ = LubaTypography.largeTitle
        _ = LubaTypography.title
        _ = LubaTypography.body
        _ = LubaTypography.code
        _ = LubaTypography.button
        XCTAssertEqual(LubaTypography.body, LubaTypography.font(.body))
    }

    /// `custom(size:)` is for glyph-locked decoration, so the requested point
    /// size must always survive. Regression test: an earlier implementation
    /// discarded `size` entirely for system fonts and resolved every call to the
    /// same text style, collapsing an 11pt badge and a 32pt avatar initial onto
    /// one size.
    func testCustomAlwaysHonorsRequestedSize() {
        let plain = LubaConfig()
        let small = LubaTypography.custom(size: 11, weight: .semibold, config: plain)
        let large = LubaTypography.custom(size: 32, weight: .semibold, config: plain)

        XCTAssertNotEqual(small, large)
        XCTAssertEqual(small, .system(size: 11, weight: .semibold, design: .rounded))
        XCTAssertEqual(large, .system(size: 32, weight: .semibold, design: .rounded))
    }

    /// The same must hold when a custom font family is configured — otherwise a
    /// branded app and a stock app would render different sizes from one call.
    func testCustomHonorsSizeWithCustomFamily() {
        var branded = LubaConfig()
        branded.customFontFamily = "Georgia"

        let small = LubaTypography.custom(size: 11, weight: .semibold, config: branded)
        let large = LubaTypography.custom(size: 32, weight: .semibold, config: branded)
        XCTAssertNotEqual(small, large)
    }

    /// `relativeTo:` opts a custom-family font into Dynamic Type scaling.
    /// System fonts cannot be both exactly sized and scalable, so it is a no-op
    /// there — running text uses a `LubaTextRole` instead.
    func testRelativeToScalesOnlyCustomFamilies() {
        var branded = LubaConfig()
        branded.customFontFamily = "Georgia"
        XCTAssertNotEqual(
            LubaTypography.custom(size: 11, weight: .medium, relativeTo: nil, config: branded),
            LubaTypography.custom(size: 11, weight: .medium, relativeTo: .caption2, config: branded)
        )

        let plain = LubaConfig()
        XCTAssertEqual(
            LubaTypography.custom(size: 11, weight: .medium, relativeTo: nil, config: plain),
            LubaTypography.custom(size: 11, weight: .medium, relativeTo: .caption2, config: plain)
        )
    }

    /// Every named role resolves through a Dynamic Type-aware text style, so no
    /// role may collapse to a frozen `Font.system(size:)`.
    func testEveryRoleIsDynamicTypeAware() {
        let plain = LubaConfig()
        for role in LubaTextRole.allCases {
            XCTAssertNotEqual(
                LubaTypography.font(role, config: plain),
                .system(size: role.nominalSize, weight: role.weight, design: role.design),
                "\(role) resolved to a fixed-size font and will not scale"
            )
        }
    }
}
