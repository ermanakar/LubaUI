//
//  LubaTextArea.swift
//  LubaUI
//
//  A multi-line text input for longer form content.
//
//  Design Decisions:
//  - Minimum height of 100pt for comfortable editing
//  - 12pt corner radius matching text field
//  - Character counter for constrained inputs
//  - Focus-ring accent border
//

import SwiftUI

// MARK: - LubaTextArea

/// A multi-line text editor with character count and validation.
///
/// ```swift
/// LubaTextArea("Bio", text: $bio, placeholder: "Tell us about yourself")
/// LubaTextArea("Notes", text: $notes, characterLimit: 280)
/// ```
public struct LubaTextArea: View {
    @LubaEnvironment private var luba
    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let characterLimit: Int?
    private let minHeight: CGFloat

    @FocusState private var isFocused: Bool

    /// Creates a multi-line text area.
    ///
    /// - Parameters:
    ///   - label: The field label displayed above the editor.
    ///   - text: A binding to the edited text.
    ///   - placeholder: Placeholder text shown when empty.
    ///   - characterLimit: Optional maximum character count.
    ///   - minHeight: Minimum editor height in points.
    public init(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        characterLimit: Int? = nil,
        minHeight: CGFloat = 100
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
        self.minHeight = minHeight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: luba.spacing.xs) {
            Text(label)
                .font(luba.fonts.caption)
                .foregroundStyle(luba.colors.textSecondary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(luba.fonts.body)
                    .focused($isFocused)
                    .frame(minHeight: minHeight)
                    .scrollContentBackground(.hidden)
                    .padding(luba.spacing.sm)

                if text.isEmpty {
                    Text(placeholder)
                        .font(luba.fonts.body)
                        .foregroundStyle(luba.colors.textTertiary)
                        .padding(luba.spacing.sm)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                        .allowsHitTesting(false)
                }
            }
            .background(luba.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: luba.radius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: luba.radius.md, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: isFocused ? 2 : 1)
            )

            if let limit = characterLimit {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(limit)")
                        .font(luba.fonts.caption2)
                        .foregroundStyle(isOverLimit ? luba.colors.error : luba.colors.textTertiary)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label)
    }

    // MARK: - Styling

    private var borderColor: Color {
        if isOverLimit { return luba.colors.error }
        return isFocused ? luba.colors.accent : luba.colors.border
    }

    private var isOverLimit: Bool {
        guard let limit = characterLimit else { return false }
        return text.count > limit
    }
}

// MARK: - Preview

#Preview("TextArea") {
    VStack(spacing: 24) {
        LubaTextArea("Bio", text: .constant(""), placeholder: "Tell us about yourself...")
        LubaTextArea("Notes", text: .constant("Some text here"), characterLimit: 100)
    }
    .padding(20)
    .background(LubaColors.background)
}
