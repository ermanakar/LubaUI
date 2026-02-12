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
    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let characterLimit: Int?
    private let minHeight: CGFloat

    @FocusState private var isFocused: Bool
    @Environment(\.lubaConfig) private var config

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
        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.system(size: 16, design: .rounded))
                    .focused($isFocused)
                    .frame(minHeight: minHeight)
                    .scrollContentBackground(.hidden)
                    .padding(LubaSpacing.sm)

                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundStyle(LubaColors.textTertiary)
                        .padding(LubaSpacing.sm)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                        .allowsHitTesting(false)
                }
            }
            .background(LubaColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: isFocused ? 2 : 1)
            )

            if let limit = characterLimit {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(limit)")
                        .font(LubaTypography.caption2)
                        .foregroundStyle(isOverLimit ? LubaColors.error : LubaColors.textTertiary)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label)
    }

    // MARK: - Styling

    private var borderColor: Color {
        if isOverLimit { return LubaColors.error }
        return isFocused ? LubaColors.accent : LubaColors.border
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
