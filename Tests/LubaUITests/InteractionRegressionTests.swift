import XCTest
import SwiftUI
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
@testable import LubaUI
@testable import LubaCore
@testable import LubaComponents

final class InteractionRegressionTests: XCTestCase {
    func testOmittedButtonStyleFollowsConfigAndExplicitChoicesWin() {
        var config = LubaConfig()
        config.defaultButtonStyle = .destructive
        let inherited = LubaButton("Save") { }
        XCTAssertTrue(inherited.resolvedStyling(in: config) is LubaDestructiveStyle)
        config.defaultButtonStyle = .glass
        XCTAssertTrue(inherited.resolvedStyling(in: config) is LubaGlassButtonStyle)
        XCTAssertTrue(LubaButton("Save", style: .primary) { }
            .resolvedStyling(in: config) is LubaPrimaryStyle)
        XCTAssertTrue(LubaButton("Save", styling: LubaGhostStyle()) { }
            .resolvedStyling(in: config) is LubaGhostStyle)
    }

    func testOmittedCardElevationFollowsConfigAndExplicitChoiceWins() {
        var config = LubaConfig()
        config.defaultCardElevation = .high
        let inherited = LubaCard { Text("Content") }
        XCTAssertEqual(inherited.resolvedElevation(in: config), .high)
        config.defaultCardElevation = .flat
        XCTAssertEqual(inherited.resolvedElevation(in: config), .flat)
        XCTAssertEqual(LubaCard(elevation: .low) { Text("Content") }
            .resolvedElevation(in: config), .low)
    }

    func testHapticsResolveSubtreeConfiguration() {
        var config = LubaConfig()
        config.hapticIntensity = 0.25
        config.hapticsEnabled = false
        let context = LubaContext(config: config)
        XCTAssertEqual(context.haptics.intensity, 0.25)
        XCTAssertFalse(context.haptics.isEnabled)
        config.hapticIntensity = 2
        XCTAssertEqual(LubaHapticPolicy(config: config).intensity, 1)
        config.hapticIntensity = -1
        XCTAssertEqual(LubaHapticPolicy(config: config).intensity, 0)
    }

    #if os(macOS) || os(iOS)
    @MainActor
    private func renderedSize<V: View>(_ view: V) throws -> CGSize {
        #if os(macOS)
        let host = NSHostingView(rootView: view.frame(width: 280))
        return host.fittingSize
        #else
        let host = UIHostingController(rootView: view)
        return host.sizeThatFits(in: CGSize(width: 280, height: CGFloat.greatestFiniteMagnitude))
        #endif
    }

    @MainActor
    func testInteractiveChipsGrowToConfiguredTarget() throws {
        var config = LubaConfig()
        config.minimumTouchTarget = 60
        let dismissible = try renderedSize(LubaChip("Filter", isDismissible: true).lubaConfig(config))
        let selectable = try renderedSize(LubaChip("Filter", onTap: {}).lubaConfig(config))
        let plain = try renderedSize(LubaChip("Filter").lubaConfig(config))
        XCTAssertGreaterThanOrEqual(dismissible.height, 60)
        XCTAssertGreaterThanOrEqual(selectable.height, 60)
        XCTAssertLessThan(plain.height, 60, "Static chips should retain their compact layout")
    }

    @MainActor
    func testTextFieldGrowsWithLargeTypeAndConfiguredTarget() throws {
        let field = LubaTextField("Address", text: .constant("Example"))
        let normal = try renderedSize(field)
        let themed = try renderedSize(field.lubaTheme(LubaThemeConfiguration(
            typography: LubaThemeTypography(body: .system(size: 64))
        )))
        XCTAssertGreaterThan(themed.height, normal.height)
        #if os(iOS)
        // macOS text controls do not implement iOS content-size categories.
        let large = try renderedSize(field.dynamicTypeSize(.accessibility5))
        XCTAssertGreaterThan(large.height, normal.height)
        #endif
        var config = LubaConfig()
        config.minimumTouchTarget = 80
        XCTAssertGreaterThanOrEqual(try renderedSize(field.lubaConfig(config)).height, 80)
    }
    #endif
}
