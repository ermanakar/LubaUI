//
//  LubaSearchBar.swift
//  LubaUI
//
//  A search input with clear and cancel buttons.
//
//  Design Decisions:
//  - 40pt height (compact, distinct from LubaTextField's 48pt)
//  - Pill shape for search-specific aesthetic
//  - surfaceSecondary background (no border by default)
//  - Cancel button slides in on focus
//

import SwiftUI

// MARK: - LubaSearchBar

/// A search bar with integrated clear and cancel buttons.
///
/// ```swift
/// LubaSearchBar(text: $searchText)
/// LubaSearchBar(text: $query, placeholder: "Find recipes...")
/// ```
public struct LubaSearchBar: View {
    @LubaEnvironment private var luba
    @Binding private var text: String
    private let placeholder: String
    private let showCancelButton: Bool
    private let onSubmit: (() -> Void)?
    private let onCancel: (() -> Void)?

    @FocusState private var isFocused: Bool

    /// Creates a search bar.
    ///
    /// - Parameters:
    ///   - text: Binding to the search text.
    ///   - placeholder: Placeholder shown when the field is empty.
    ///   - showCancelButton: When `true`, a cancel button appears on focus.
    ///   - onSubmit: Optional closure invoked when the user submits.
    ///   - onCancel: Optional closure invoked when the user cancels.
    public init(
        text: Binding<String>,
        placeholder: String = LubaStrings.search,
        showCancelButton: Bool = true,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showCancelButton = showCancelButton
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }

    public var body: some View {
        HStack(spacing: luba.spacing.sm) {
            HStack(spacing: luba.spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(luba.fonts.body)
                    .foregroundStyle(luba.colors.textTertiary)

                TextField(placeholder, text: $text)
                    .font(luba.fonts.body)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit { onSubmit?() }

                if !text.isEmpty {
                    Button(action: clearText) {
                        Image(systemName: "xmark.circle.fill")
                            .font(luba.fonts.bodySmall)
                            .foregroundStyle(luba.colors.textTertiary)
                    }
                    .buttonStyle(.plain)
                    .transition(luba.motion.transition(.scale.combined(with: .opacity)))
                    .accessibilityLabel(LubaStrings.clearSearch)
                }
            }
            .padding(.horizontal, LubaSearchBarTokens.horizontalPadding(luba.spacing))
            .frame(minHeight: LubaSearchBarTokens.height)
            .background(luba.colors.surfaceSecondary)
            .clipShape(Capsule())

            if showCancelButton && isFocused {
                Button(action: cancel) {
                    Text(LubaStrings.cancel)
                        .font(luba.fonts.body)
                        .foregroundStyle(luba.colors.accent)
                }
                .buttonStyle(.plain)
                .transition(luba.motion.transition(.move(edge: .trailing).combined(with: .opacity)))
                .accessibilityLabel(LubaStrings.cancelSearch)
            }
        }
        .animation(luba.motion.animation(LubaMotion.stateAnimation), value: isFocused)
        .animation(luba.motion.animation(LubaMotion.micro), value: text.isEmpty)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(LubaStrings.search)
    }

    // MARK: - Actions

    private func clearText() {
        if luba.hapticsEnabled {
            LubaHaptics.light()
        }
        luba.motion.run(LubaMotion.micro) {
            text = ""
        }
    }

    private func cancel() {
        if luba.hapticsEnabled {
            LubaHaptics.light()
        }
        luba.motion.run(LubaMotion.stateAnimation) {
            text = ""
            isFocused = false
        }
        onCancel?()
    }
}

// MARK: - Preview

#Preview("SearchBar") {
    VStack(spacing: 20) {
        LubaSearchBar(text: .constant(""))
        LubaSearchBar(text: .constant("Design system"), placeholder: "Find components...")
        LubaSearchBar(text: .constant(""), showCancelButton: false)
    }
    .padding(20)
    .background(LubaColors.background)
}
