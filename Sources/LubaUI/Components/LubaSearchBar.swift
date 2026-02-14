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
    @Binding private var text: String
    private let placeholder: String
    private let showCancelButton: Bool
    private let onSubmit: (() -> Void)?
    private let onCancel: (() -> Void)?

    @FocusState private var isFocused: Bool
    @Environment(\.lubaConfig) private var config

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
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
        HStack(spacing: LubaSpacing.sm) {
            HStack(spacing: LubaSpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textTertiary)

                TextField(placeholder, text: $text)
                    .font(LubaTypography.body)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit { onSubmit?() }

                if !text.isEmpty {
                    Button(action: clearText) {
                        Image(systemName: "xmark.circle.fill")
                            .font(LubaTypography.bodySmall)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, LubaSearchBarTokens.horizontalPadding)
            .frame(height: LubaSearchBarTokens.height)
            .background(LubaColors.surfaceSecondary)
            .clipShape(Capsule())

            if showCancelButton && isFocused {
                Button(action: cancel) {
                    Text("Cancel")
                        .font(LubaTypography.body)
                        .foregroundStyle(LubaColors.accent)
                }
                .buttonStyle(.plain)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .accessibilityLabel("Cancel search")
            }
        }
        .animation(LubaMotion.stateAnimation, value: isFocused)
        .animation(LubaMotion.micro, value: text.isEmpty)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Search")
    }

    // MARK: - Actions

    private func clearText() {
        if config.hapticsEnabled {
            LubaHaptics.light()
        }
        withAnimation(LubaMotion.micro) {
            text = ""
        }
    }

    private func cancel() {
        if config.hapticsEnabled {
            LubaHaptics.light()
        }
        withAnimation(LubaMotion.stateAnimation) {
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
