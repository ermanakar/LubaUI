import SwiftUI
import LubaUI

struct SettingsExample: View {
    @LubaEnvironment private var luba
    @State private var name = ""
    @State private var notifications = true

    var body: some View {
        LubaCard {
            VStack(alignment: .leading, spacing: luba.spacing.lg) {
                Text("Preferences")
                    .font(luba.fonts.title)
                    .foregroundStyle(luba.colors.textPrimary)
                LubaTextField("Name", text: $name)
                LubaToggle(isOn: $notifications, label: "Notifications")
            }
        }
        .padding(luba.spacing.xl)
        .lubaTheme(colors: .accented(.indigo))
    }
}
