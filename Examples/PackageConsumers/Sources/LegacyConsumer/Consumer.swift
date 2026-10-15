import SwiftUI
import LubaUI

// External conformances must still resolve Core protocols through the umbrella.
struct BrandButtonStyle: LubaButtonStyling {
    func foregroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color { .white }
    func backgroundColor(isPressed: Bool, colorScheme: ColorScheme) -> Color { .indigo }
    func borderColor(isPressed: Bool, colorScheme: ColorScheme) -> Color? { nil }
}

// An ordinary downstream module: no @testable imports or implementation paths.
@main
struct Consumer {
    @MainActor
    static func main() {
        var config = LubaConfig()
        config.hapticIntensity = 0.25
        let context = LubaContext(config: config)
        precondition(context.haptics.intensity == 0.25)
        precondition(LubaStrings.clearText == "Clear text", "Resource bundle was not packaged")
        let view = LubaCard { LubaTextField("Name", text: .constant("Example")) }.lubaTheme(colors: .accented(.indigo))
        _ = view
        _ = LubaButton("Custom style", styling: BrandButtonStyle()) {}
        _ = LubaAccordion(items: [LubaAccordionItem(title: "Details", content: "Expanded content")])
        let colors = LubaThemeColors(chartPalette: [.indigo], chartGrid: .gray, chartAxisLabel: .secondary)
        precondition(colors.chartColor(at: 0) == .indigo, "Existing theme initializers must remain available")
        precondition(BrandButtonStyle().foregroundColor(in: LubaButtonStyleContext(isPressed: false, colorScheme: .light)) == .white)
        precondition(LubaUI.version == "0.3.0")
        print("LegacyConsumer passed")
    }
}
