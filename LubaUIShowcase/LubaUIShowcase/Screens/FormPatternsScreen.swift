import SwiftUI
import LubaUI

struct FormPatternsScreen: View {
    var body: some View {
        ShowcaseScreen("Form Patterns") {
            ShowcaseHeader(title: "Form Patterns", description: "Clear labels, inline validation, and grouped preferences. Built from the same small set of controls.")
            ProjectFormDemo()
            PhilosophyCard(icon: "checklist", title: "Validate where it matters", description: "Try clearing the project name and saving. The field keeps its label and shows the error next to the input. This demo stores nothing outside this screen.")
            CodeBlock {
                Text("LubaTextField(\"Project name\", text: $name)")
                Text("LubaToggle(isOn: $updates, label: \"Updates\")")
                Text("LubaButton(\"Save project\") { validate() }")
            }
        }
    }
}

private struct ProjectFormDemo: View {
    @LubaEnvironment private var luba
    @State private var name = "Spring collection"
    @State private var notes = "A quieter palette. A little more space."
    @State private var updates = true
    @State private var shared = false
    @State private var submitted = false
    @State private var saved = false

    var body: some View {
        LubaCard {
            VStack(alignment: .leading, spacing: luba.spacing.lg) {
                HStack(spacing: luba.spacing.md) {
                    LubaCircledIcon("folder", size: .md, style: .subtle)
                    VStack(alignment: .leading, spacing: luba.spacing.xs) {
                        Text("A new project").font(luba.fonts.title3)
                        Text("Make room for your next idea.")
                            .font(luba.fonts.caption)
                            .foregroundStyle(luba.colors.textSecondary)
                    }
                }
                LubaDivider()
                LubaTextField("Project name", text: $name, placeholder: "Give it a name", error: submitted && name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Add a project name to continue." : nil, leadingIcon: Image(systemName: "pencil"))
                LubaTextField("Notes", text: $notes, placeholder: "A few words about the idea")
                LubaDivider()
                LubaToggle(isOn: $updates, label: "Project updates")
                LubaCheckbox(isChecked: $shared, label: "Share with the workspace")
                LubaButton(saved ? "Project saved" : "Save project", icon: Image(systemName: saved ? "checkmark" : "plus"), fullWidth: true) {
                    submitted = true
                    saved = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                Text("Example content · changes stay in this demo")
                    .font(luba.fonts.caption)
                    .foregroundStyle(luba.colors.textSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .onChange(of: name) { _ in saved = false }
        .onChange(of: notes) { _ in saved = false }
        .onChange(of: updates) { _ in saved = false }
        .onChange(of: shared) { _ in saved = false }
    }
}

#Preview {
    NavigationStack { FormPatternsScreen() }
}
