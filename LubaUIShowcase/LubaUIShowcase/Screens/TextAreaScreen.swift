//
//  TextAreaScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaTextArea multi-line inputs.
//

import SwiftUI
import LubaUI

struct TextAreaScreen: View {
    @State private var bio = ""
    @State private var notes = ""
    @State private var tweet = ""

    var body: some View {
        ShowcaseScreen("Text Area") {
            ShowcaseHeader(
                title: "Text Area",
                description: "Multi-line text input for bios, notes, comments, and longer-form content."
            )

            // Basic
            DemoSection(title: "Basic") {
                LubaTextArea("Bio", text: $bio, placeholder: "Tell us about yourself...")
            }

            // Character Limit
            DemoSection(title: "Character Limit") {
                LubaTextArea("Tweet", text: $tweet, placeholder: "What's happening?", characterLimit: 280)
            }

            // Custom Height
            DemoSection(title: "Custom Height") {
                LubaTextArea("Notes", text: $notes, placeholder: "Add your notes here...", minHeight: 160)
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaTextArea(\"Bio\", text: $bio)")
                    CopyableCode(code: "LubaTextArea(\"Notes\", text: $text, characterLimit: 280)")
                    CopyableCode(code: "LubaTextArea(\"Long\", text: $text, minHeight: 200)")
                }
            }

            PhilosophyCard(
                icon: "text.alignleft",
                title: "Room To Breathe",
                description: "Sometimes a single line isn't enough. Text areas give users space to express themselves, with gentle guardrails like character limits."
            )
        }
    }
}

#Preview {
    NavigationStack {
        TextAreaScreen()
    }
}
