//
//  ComponentTests.swift
//  LubaUI
//
//  Tests for component behavior: swipe presets, menu items, toast styles,
//  sheet detents, accordion items, and WCAG contrast compliance.
//  Creation-only tests (XCTAssertNotNil on non-optional view structs) are
//  intentionally omitted — the compiler enforces construction.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class ComponentTests: XCTestCase {

    // MARK: - Toast Style Behavior

    func testToastStyleIcons() {
        let styles: [LubaToastStyle] = [.info, .success, .warning, .error]
        for style in styles {
            XCTAssertFalse(style.icon.isEmpty, "\(style) should have an icon")
            XCTAssertNotNil(style.color, "\(style) should have a color")
        }
    }

    // MARK: - Sheet Size Detents

    func testSheetSizeDetents() {
        let sizes: [LubaSheetSize] = [.small, .medium, .large, .full]
        for size in sizes {
            XCTAssertNotNil(size.detent)
        }
    }

    // MARK: - Menu Item Behavior

    func testMenuItemBehavior() {
        // Action callback fires
        var actionCalled = false
        let item = LubaMenuItem("Edit", icon: Image(systemName: "pencil"), role: .normal) {
            actionCalled = true
        }
        XCTAssertEqual(item.label, "Edit")
        XCTAssertNotNil(item.icon)
        XCTAssertEqual(item.role, .normal)
        item.action()
        XCTAssertTrue(actionCalled)

        // Destructive role
        let destructive = LubaMenuItem("Delete", role: .destructive) { }
        XCTAssertEqual(destructive.role, .destructive)

        // Default role
        let copy = LubaMenuItem("Copy") { }
        XCTAssertEqual(copy.role, .normal)
        XCTAssertNil(copy.icon)
    }

    // MARK: - Swipe Action Presets

    func testSwipeActionPresets() {
        let deleteAction = LubaSwipeAction.delete { }
        XCTAssertEqual(deleteAction.icon, "trash.fill")
        XCTAssertEqual(deleteAction.label, "Delete")

        let archiveAction = LubaSwipeAction.archive { }
        XCTAssertEqual(archiveAction.icon, "archivebox.fill")
        XCTAssertEqual(archiveAction.label, "Archive")

        let pinAction = LubaSwipeAction.pin { }
        XCTAssertEqual(pinAction.icon, "pin.fill")
        XCTAssertEqual(pinAction.label, "Pin")

        XCTAssertEqual(LubaSwipeAction.unread { }.label, "Unread")
        XCTAssertEqual(LubaSwipeAction.flag { }.label, "Flag")
        XCTAssertEqual(LubaSwipeAction.share { }.label, "Share")
    }

    // MARK: - Accordion

    func testAccordionItem() {
        let item = LubaAccordionItem(title: "FAQ", content: "Answer", icon: "star")
        XCTAssertFalse(item.id.isEmpty)
        XCTAssertEqual(item.title, "FAQ")
        XCTAssertEqual(item.content, "Answer")
        XCTAssertEqual(item.icon, "star")

        // Default icon is nil
        let plain = LubaAccordionItem(title: "Q", content: "A")
        XCTAssertNil(plain.icon)
        XCTAssertFalse(plain.id.isEmpty)
    }

    // MARK: - WCAG Contrast

    func testContrastRatioCalculation() {
        // White on black: maximum contrast
        let maxRatio = LubaContrast.contrastRatio(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000)
        )
        XCTAssertGreaterThan(maxRatio, 20.0)
        XCTAssertLessThanOrEqual(maxRatio, 21.1)

        // Same color: ratio = 1
        let sameRatio = LubaContrast.contrastRatio(
            foreground: Color(hex: 0xFF0000),
            background: Color(hex: 0xFF0000)
        )
        XCTAssertEqual(sameRatio, 1.0, accuracy: 0.01)
    }

    func testWCAGCompliance() {
        // High contrast passes all levels
        let white = Color(hex: 0xFFFFFF)
        let black = Color(hex: 0x000000)
        XCTAssertTrue(LubaContrast.meetsAA(foreground: white, background: black))
        XCTAssertTrue(LubaContrast.meetsAA(foreground: white, background: black, largeText: true))
        XCTAssertTrue(LubaContrast.meetsAAA(foreground: white, background: black))
        XCTAssertTrue(LubaContrast.meetsAAA(foreground: white, background: black, largeText: true))

        // Low contrast fails AA
        XCTAssertFalse(LubaContrast.meetsAA(
            foreground: Color(hex: 0xCCCCCC),
            background: Color(hex: 0xFFFFFF)
        ))
    }
}
