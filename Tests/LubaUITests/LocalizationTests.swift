//
//  LocalizationTests.swift
//  LubaUI
//
//  Tests that LubaUI's built-in strings are actually localized — that a
//  German app does not get English VoiceOver output from a LubaUI control.
//

import XCTest
import SwiftUI
@testable import LubaUI

final class LocalizationTests: XCTestCase {

    private func bundle(for language: String) throws -> Bundle {
        let path = try XCTUnwrap(
            Bundle.module.path(forResource: language, ofType: "lproj"),
            "Missing \(language).lproj in the package resource bundle"
        )
        return try XCTUnwrap(Bundle(path: path))
    }

    private func string(_ key: String, in language: String) throws -> String {
        let value = try bundle(for: language).localizedString(forKey: key, value: "@@MISSING@@", table: nil)
        XCTAssertNotEqual(value, "@@MISSING@@", "Key \(key) missing from \(language).lproj")
        return value
    }

    // MARK: - Resource Bundle

    func testResourceBundleShipsBothLanguages() throws {
        XCTAssertNotNil(Bundle.module.path(forResource: "en", ofType: "lproj"))
        XCTAssertNotNil(Bundle.module.path(forResource: "de", ofType: "lproj"))
    }

    // MARK: - English

    func testEnglishStrings() throws {
        XCTAssertEqual(try string("luba.state.loading", in: "en"), "Loading")
        XCTAssertEqual(try string("luba.state.disabled", in: "en"), "Disabled")
        XCTAssertEqual(try string("luba.action.close", in: "en"), "Close")
        XCTAssertEqual(try string("luba.status.error", in: "en"), "Error")
        XCTAssertEqual(try string("luba.search.placeholder", in: "en"), "Search")
    }

    // MARK: - German

    func testGermanStrings() throws {
        XCTAssertEqual(try string("luba.state.loading", in: "de"), "Wird geladen")
        XCTAssertEqual(try string("luba.state.disabled", in: "de"), "Deaktiviert")
        XCTAssertEqual(try string("luba.action.close", in: "de"), "Schließen")
        XCTAssertEqual(try string("luba.status.error", in: "de"), "Fehler")
        XCTAssertEqual(try string("luba.search.placeholder", in: "de"), "Suchen")
        XCTAssertEqual(try string("luba.value.on", in: "de"), "Ein")
    }

    /// Every key present in English must exist in German, or German users get
    /// a silent English fallback in the middle of a German screen.
    func testGermanCoversEveryEnglishKey() throws {
        let en = try keys(in: "en")
        let de = try keys(in: "de")
        XCTAssertFalse(en.isEmpty)
        XCTAssertEqual(en.subtracting(de), [], "Keys missing from de.lproj")
        XCTAssertEqual(de.subtracting(en), [], "Extra keys in de.lproj")
    }

    private func keys(in language: String) throws -> Set<String> {
        let path = try XCTUnwrap(bundle(for: language).path(forResource: "Localizable", ofType: "strings"))
        let dict = try XCTUnwrap(NSDictionary(contentsOfFile: path) as? [String: String])
        return Set(dict.keys)
    }

    // MARK: - Public API

    /// Tests run under the `en` development language, so the API surface should
    /// return English here; the point is that it routes through the bundle.
    func testStringsAPIResolvesThroughBundle() {
        XCTAssertEqual(LubaStrings.loading, "Loading")
        XCTAssertEqual(LubaStrings.disabled, "Disabled")
        XCTAssertEqual(LubaStrings.close, "Close")
        XCTAssertEqual(LubaStrings.search, "Search")
        XCTAssertEqual(LubaStrings.checked, "Checked")
        XCTAssertEqual(LubaStrings.notSelected, "Not selected")
    }

    func testFormattedStrings() {
        XCTAssertEqual(LubaStrings.percent(60), "60 percent")
        XCTAssertEqual(LubaStrings.rating(3, of: 5), "3 of 5 stars")
        XCTAssertEqual(LubaStrings.remove("Design"), "Remove Design")
        XCTAssertEqual(LubaStrings.avatar(initials: "AK"), "Avatar, AK")
        XCTAssertEqual(LubaStrings.statusMessage(.error, "Could not save"), "Error: Could not save")
        XCTAssertEqual(LubaStrings.fieldError("Invalid address"), "Error: Invalid address")
    }

    func testStatusPrefixesCoverEveryRole() {
        for role in LubaStatusRole.allCases {
            XCTAssertFalse(LubaStrings.statusPrefix(role).isEmpty)
        }
    }

    // MARK: - Components Use Localized Strings

    func testSwipePresetLabelsAreLocalized() {
        XCTAssertEqual(LubaSwipeAction.delete {}.label, LubaStrings.delete)
        XCTAssertEqual(LubaSwipeAction.archive {}.label, LubaStrings.archive)
        XCTAssertEqual(LubaSwipeAction.pin {}.label, LubaStrings.pin)
        XCTAssertEqual(LubaSwipeAction.unread {}.label, LubaStrings.unread)
        XCTAssertEqual(LubaSwipeAction.flag {}.label, LubaStrings.flag)
        XCTAssertEqual(LubaSwipeAction.share {}.label, LubaStrings.share)
    }

    /// A caller-supplied label must never be replaced by a built-in string.
    func testCallerProvidedLabelsWin() {
        let action = LubaSwipeAction(icon: "trash", label: "Papierkorb", color: .red) {}
        XCTAssertEqual(action.label, "Papierkorb")
    }
}
