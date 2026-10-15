import SwiftUI
import LubaComponents

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
        let view = LubaCard { LubaButton("Continue") {} }.lubaConfig(config)
        _ = view
        _ = LubaAccordion(items: [LubaAccordionItem(title: "Details", content: "Expanded content")])

        print("ComponentsConsumer passed")
    }
}
