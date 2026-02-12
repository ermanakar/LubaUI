//
//  SearchBarScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaSearchBar with clear and cancel buttons.
//

import SwiftUI
import LubaUI

struct SearchBarScreen: View {
    @State private var basicSearch = ""
    @State private var filterSearch = ""

    private let items = ["LubaButton", "LubaCard", "LubaTextField", "LubaCheckbox", "LubaToggle", "LubaSlider", "LubaAvatar", "LubaBadge", "LubaAlert", "LubaChip"]

    var filteredItems: [String] {
        if filterSearch.isEmpty { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(filterSearch) }
    }

    var body: some View {
        ShowcaseScreen("Search Bar") {
            ShowcaseHeader(
                title: "Search Bar",
                description: "A compact search input with integrated clear and cancel buttons. Pill-shaped, animated, and ready to filter."
            )

            // Basic
            DemoSection(title: "Default") {
                LubaSearchBar(text: $basicSearch)
            }

            // Without Cancel
            DemoSection(title: "Without Cancel Button") {
                LubaSearchBar(text: .constant(""), placeholder: "Find recipes...", showCancelButton: false)
            }

            // Pre-filled
            DemoSection(title: "Pre-filled") {
                LubaSearchBar(text: .constant("Design system"), placeholder: "Search...")
            }

            // Live Filter
            DemoSection(title: "Live Filter") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaSearchBar(text: $filterSearch, placeholder: "Filter components...")

                        VStack(spacing: 0) {
                            ForEach(filteredItems, id: \.self) { item in
                                HStack(spacing: LubaSpacing.md) {
                                    Image(systemName: "cube")
                                        .font(.system(size: 14))
                                        .foregroundStyle(LubaColors.accent)
                                        .frame(width: 20)

                                    Text(item)
                                        .font(LubaTypography.body)
                                        .foregroundStyle(LubaColors.textPrimary)

                                    Spacer()
                                }
                                .padding(.vertical, LubaSpacing.sm)

                                if item != filteredItems.last {
                                    LubaDivider()
                                }
                            }

                            if filteredItems.isEmpty {
                                VStack(spacing: LubaSpacing.sm) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 24))
                                        .foregroundStyle(LubaColors.textTertiary)
                                    Text("No results")
                                        .font(LubaTypography.caption)
                                        .foregroundStyle(LubaColors.textTertiary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, LubaSpacing.xl)
                            }
                        }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaSearchBar(text: $query)")
                    CopyableCode(code: "LubaSearchBar(text: $q, placeholder: \"Find...\")")
                    CopyableCode(code: "LubaSearchBar(text: $q, showCancelButton: false)")
                }
            }

            PhilosophyCard(
                icon: "magnifyingglass",
                title: "Search is Navigation",
                description: "A great search bar disappears — users focus on results, not the input. The pill shape, animated cancel button, and instant clear make searching feel effortless."
            )
        }
    }
}

#Preview {
    NavigationStack {
        SearchBarScreen()
    }
}
