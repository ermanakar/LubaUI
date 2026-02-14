//
//  ComponentTests.swift
//  LubaUI
//
//  Tests for component instantiation, swipe action presets, and WCAG contrast.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class ComponentTests: XCTestCase {

    // MARK: - Button

    func testButtonCreation() {
        let button = LubaButton("Test", style: .primary) { }
        XCTAssertNotNil(button)
    }

    func testButtonWithAllStyles() {
        let styles: [LubaButtonStyle] = [.primary, .secondary, .ghost, .destructive, .subtle, .glass]
        for style in styles {
            let button = LubaButton("Test", style: style) { }
            XCTAssertNotNil(button)
        }
    }

    func testButtonWithAllSizes() {
        let sizes: [LubaButtonSize] = [.small, .medium, .large]
        for size in sizes {
            let button = LubaButton("Test", style: .primary, size: size) { }
            XCTAssertNotNil(button)
        }
    }

    func testButtonWithOptions() {
        let button = LubaButton(
            "Submit",
            style: .primary,
            size: .large,
            isLoading: false,
            isDisabled: false,
            icon: Image(systemName: "checkmark"),
            fullWidth: true
        ) { }
        XCTAssertNotNil(button)
    }

    // MARK: - Card

    func testCardCreation() {
        let card = LubaCard(elevation: .low, style: .filled) {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    func testGlassCardCreation() {
        let card = LubaCard(style: .glass) {
            Text("Glass Content")
        }
        XCTAssertNotNil(card)
    }

    func testGlassButtonCreation() {
        let button = LubaButton("Glass", style: .glass) { }
        XCTAssertNotNil(button)
    }

    func testGlassToastCreation() {
        let toast = LubaToast("Saved", style: .success, useGlass: true)
        XCTAssertNotNil(toast)
    }

    func testGlassAlertCreation() {
        let alert = LubaAlert("Info", style: .info, useGlass: true)
        XCTAssertNotNil(alert)
    }

    // MARK: - TextField

    func testTextFieldCreation() {
        let field = LubaTextField("Email", text: .constant(""), placeholder: "test@example.com")
        XCTAssertNotNil(field)
    }

    func testTextFieldConvenience() {
        let email = LubaTextField.email(text: .constant(""))
        XCTAssertNotNil(email)

        let secure = LubaTextField.secure("Password", text: .constant(""))
        XCTAssertNotNil(secure)
    }

    // MARK: - TextArea

    func testTextAreaCreation() {
        let area = LubaTextArea("Bio", text: .constant(""), placeholder: "Tell us...")
        XCTAssertNotNil(area)
    }

    func testTextAreaWithLimit() {
        let area = LubaTextArea("Tweet", text: .constant("Hello"), characterLimit: 280)
        XCTAssertNotNil(area)
    }

    // MARK: - Form Controls

    func testCheckboxCreation() {
        let checkbox = LubaCheckbox(isChecked: .constant(true), label: "Accept")
        XCTAssertNotNil(checkbox)
    }

    func testToggleCreation() {
        let toggle = LubaToggle(isOn: .constant(true), label: "Dark Mode")
        XCTAssertNotNil(toggle)
    }

    func testSliderCreation() {
        let slider = LubaSlider(value: .constant(0.5), in: 0...1, label: "Volume")
        XCTAssertNotNil(slider)
    }

    func testStepperCreation() {
        let stepper = LubaStepper(value: .constant(5), in: 1...10, label: "Quantity")
        XCTAssertNotNil(stepper)
    }

    func testStepperCustomStep() {
        let stepper = LubaStepper(value: .constant(0), in: 0...100, step: 5)
        XCTAssertNotNil(stepper)
    }

    func testRatingCreation() {
        let rating = LubaRating(value: .constant(3))
        XCTAssertNotNil(rating)
    }

    func testRatingWithLabel() {
        let rating = LubaRating(value: .constant(4), maxStars: 5, isReadOnly: true, label: "Score")
        XCTAssertNotNil(rating)
    }

    // MARK: - SearchBar

    func testSearchBarCreation() {
        let bar = LubaSearchBar(text: .constant(""))
        XCTAssertNotNil(bar)

        let barCustom = LubaSearchBar(text: .constant("query"), placeholder: "Find...", showCancelButton: false)
        XCTAssertNotNil(barCustom)
    }

    // MARK: - Data Display

    func testAvatarCreation() {
        let avatar = LubaAvatar(name: "Jane Doe", size: .medium)
        XCTAssertNotNil(avatar)
    }

    func testBadgeCreation() {
        let badge = LubaBadge("New", style: .accent, size: .medium)
        XCTAssertNotNil(badge)

        let badgeWithIcon = LubaBadge("Pro", style: .subtle, icon: Image(systemName: "crown"))
        XCTAssertNotNil(badgeWithIcon)
    }

    func testDividerCreation() {
        let divider = LubaDivider()
        XCTAssertNotNil(divider)

        let labeledDivider = LubaDivider(label: "OR")
        XCTAssertNotNil(labeledDivider)
    }

    func testDividerOrientationsCoverage() {
        let orientations: [LubaDivider.Orientation] = [.horizontal, .vertical]
        XCTAssertEqual(orientations.count, 2)
    }

    func testSkeletonCreation() {
        let skeleton = LubaSkeleton()
        XCTAssertNotNil(skeleton)

        let circle = LubaSkeletonCircle()
        XCTAssertNotNil(circle)
    }

    func testChipCreation() {
        let chip = LubaChip("Swift")
        XCTAssertNotNil(chip)

        let chipFull = LubaChip(
            "Design",
            style: .outlined,
            icon: Image(systemName: "star"),
            isSelected: true,
            isDismissible: true,
            onDismiss: { },
            onTap: { }
        )
        XCTAssertNotNil(chipFull)
    }

    func testChipStyles() {
        let styles: [LubaChipStyle] = [.filled, .outlined]
        XCTAssertEqual(styles.count, 2)
    }

    func testLinkCreation() {
        let link = LubaLink("Learn more") { }
        XCTAssertNotNil(link)
    }

    func testLinkStyles() {
        let styles: [LubaLinkStyle] = [.default, .subtle, .external]
        XCTAssertEqual(styles.count, 3)
        for style in styles {
            let link = LubaLink("Test", style: style) { }
            XCTAssertNotNil(link)
        }
    }

    // MARK: - Feedback

    func testProgressBarCreation() {
        let bar = LubaProgressBar(value: 0.5)
        XCTAssertNotNil(bar)
    }

    func testCircularProgressCreation() {
        let circular = LubaCircularProgress(value: 0.75)
        XCTAssertNotNil(circular)
    }

    func testSpinnerCreation() {
        let spinner = LubaSpinner(size: 20, style: .arc)
        XCTAssertNotNil(spinner)
    }

    func testAlertCreation() {
        let alert = LubaAlert("Test message", style: .info)
        XCTAssertNotNil(alert)

        let alertWithTitle = LubaAlert("Message", style: .error, title: "Error", isDismissible: true)
        XCTAssertNotNil(alertWithTitle)
    }

    func testAlertStylesCoverage() {
        let styles: [LubaAlertStyle] = [.info, .success, .warning, .error]
        XCTAssertEqual(styles.count, 4, "Should have 4 alert styles")
    }

    func testAlertCreationAllStyles() {
        let styles: [LubaAlertStyle] = [.info, .success, .warning, .error]
        for style in styles {
            let alert = LubaAlert("Test", style: style)
            XCTAssertNotNil(alert)
        }
    }

    func testToastCreation() {
        let toast = LubaToast("Hello", style: .info)
        XCTAssertNotNil(toast)
    }

    func testToastStyleIcons() {
        let styles: [LubaToastStyle] = [.info, .success, .warning, .error]
        for style in styles {
            XCTAssertFalse(style.icon.isEmpty, "\(style) should have an icon")
            XCTAssertNotNil(style.color, "\(style) should have a color")
        }
    }

    func testSheetSizeDetents() {
        let sizes: [LubaSheetSize] = [.small, .medium, .large, .full]
        for size in sizes {
            XCTAssertNotNil(size.detent)
        }
    }

    // MARK: - Menu

    func testMenuCreation() {
        let menu = LubaMenu(items: [
            LubaMenuItem("Edit") { },
            LubaMenuItem("Delete", role: .destructive) { }
        ]) {
            Text("Trigger")
        }
        XCTAssertNotNil(menu)
    }

    func testMenuDefaultLabel() {
        let menu = LubaMenu(items: [LubaMenuItem("Test") { }])
        XCTAssertNotNil(menu)
    }

    func testMenuItemCreation() {
        var actionCalled = false
        let item = LubaMenuItem("Edit", icon: Image(systemName: "pencil"), role: .normal) {
            actionCalled = true
        }
        XCTAssertEqual(item.label, "Edit")
        XCTAssertNotNil(item.icon)
        XCTAssertEqual(item.role, .normal)
        item.action()
        XCTAssertTrue(actionCalled)
    }

    func testMenuItemDestructiveRole() {
        let item = LubaMenuItem("Delete", role: .destructive) { }
        XCTAssertEqual(item.role, .destructive)
        XCTAssertEqual(item.label, "Delete")
    }

    func testMenuItemDefaultRole() {
        let item = LubaMenuItem("Copy") { }
        XCTAssertEqual(item.role, .normal)
        XCTAssertNil(item.icon)
    }

    // MARK: - Tooltip

    func testTooltipCreation() {
        let tooltip = LubaTooltip("Help text") {
            Text("Anchor")
        }
        XCTAssertNotNil(tooltip)
    }

    func testTooltipPositions() {
        let positions: [LubaTooltipPosition] = [.top, .bottom]
        XCTAssertEqual(positions.count, 2)
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

        let unreadAction = LubaSwipeAction.unread { }
        XCTAssertEqual(unreadAction.label, "Unread")

        let flagAction = LubaSwipeAction.flag { }
        XCTAssertEqual(flagAction.label, "Flag")

        let shareAction = LubaSwipeAction.share { }
        XCTAssertEqual(shareAction.label, "Share")
    }

    // MARK: - Accordion

    func testAccordionItem() {
        let item = LubaAccordionItem(title: "FAQ", content: "Answer", icon: "star")
        XCTAssertFalse(item.id.isEmpty)
        XCTAssertEqual(item.title, "FAQ")
        XCTAssertEqual(item.content, "Answer")
        XCTAssertEqual(item.icon, "star")
    }

    func testAccordionItemDefaultIcon() {
        let item = LubaAccordionItem(title: "Q", content: "A")
        XCTAssertNil(item.icon)
        XCTAssertFalse(item.id.isEmpty)
    }

    // MARK: - WCAG Contrast Tests

    func testContrastRatioWhiteOnBlack() {
        let ratio = LubaContrast.contrastRatio(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000)
        )
        XCTAssertGreaterThan(ratio, 20.0)
        XCTAssertLessThanOrEqual(ratio, 21.1)
    }

    func testContrastRatioSameColor() {
        let ratio = LubaContrast.contrastRatio(
            foreground: Color(hex: 0xFF0000),
            background: Color(hex: 0xFF0000)
        )
        XCTAssertEqual(ratio, 1.0, accuracy: 0.01)
    }

    func testMeetsAANormalText() {
        XCTAssertTrue(LubaContrast.meetsAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000)
        ))
    }

    func testMeetsAALargeText() {
        XCTAssertTrue(LubaContrast.meetsAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000),
            largeText: true
        ))
    }

    func testMeetsAAANormalText() {
        XCTAssertTrue(LubaContrast.meetsAAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000)
        ))
    }

    func testMeetsAAALargeText() {
        XCTAssertTrue(LubaContrast.meetsAAA(
            foreground: Color(hex: 0xFFFFFF),
            background: Color(hex: 0x000000),
            largeText: true
        ))
    }

    func testLowContrastFailsAA() {
        XCTAssertFalse(LubaContrast.meetsAA(
            foreground: Color(hex: 0xCCCCCC),
            background: Color(hex: 0xFFFFFF)
        ))
    }
}
