import SwiftUI
import LubaCore

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
        let view = Text("Core only").font(context.fonts.body).padding(context.spacing.lg).lubaGlass().lubaTheme(colors: .accented(.indigo))
        _ = view

        print("CoreConsumer passed")
    }
}
