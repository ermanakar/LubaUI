//
//  ChipScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaChip dismissible filter tags.
//

import SwiftUI
import LubaUI

struct ChipScreen: View {
    @State private var filters: [String] = ["Swift", "Design", "iOS", "UIKit"]
    @State private var selectedTags: Set<String> = ["Swift"]
    private let allTags = ["Swift", "SwiftUI", "UIKit", "Design", "iOS", "macOS", "Accessibility"]

    var body: some View {
        ShowcaseScreen("Chips") {
            ShowcaseHeader(
                title: "Chip",
                description: "Dismissible tags for filters, categories, and multi-selection. Compact, tactile, and composable."
            )

            // Styles
            DemoSection(title: "Filled") {
                HStack(spacing: LubaSpacing.sm) {
                    LubaChip("Default")
                    LubaChip("Selected", isSelected: true)
                    LubaChip("With Icon", icon: Image(systemName: "star.fill"))
                    LubaChip("Dismiss", isDismissible: true)
                }
            }

            DemoSection(title: "Outlined") {
                HStack(spacing: LubaSpacing.sm) {
                    LubaChip("Default", style: .outlined)
                    LubaChip("Selected", style: .outlined, isSelected: true)
                    LubaChip("Dismiss", style: .outlined, isDismissible: true)
                }
            }

            // Active Filters
            DemoSection(title: "Active Filters") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("Showing results for:")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)

                        FlowLayout(spacing: 8) {
                            ForEach(filters, id: \.self) { filter in
                                LubaChip(filter, isDismissible: true, onDismiss: {
                                    withAnimation(LubaAnimations.standard) {
                                        filters.removeAll { $0 == filter }
                                    }
                                })
                            }
                        }

                        if filters.isEmpty {
                            LubaButton("Reset Filters", style: .secondary) {
                                withAnimation(LubaAnimations.standard) {
                                    filters = ["Swift", "Design", "iOS", "UIKit"]
                                }
                            }
                        }
                    }
                }
            }

            // Multi-Select
            DemoSection(title: "Multi-Select") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("Select topics you're interested in:")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        FlowLayout(spacing: 8) {
                            ForEach(allTags, id: \.self) { tag in
                                LubaChip(
                                    tag,
                                    style: .outlined,
                                    isSelected: selectedTags.contains(tag),
                                    onTap: {
                                        withAnimation(LubaAnimations.quick) {
                                            if selectedTags.contains(tag) {
                                                selectedTags.remove(tag)
                                            } else {
                                                selectedTags.insert(tag)
                                            }
                                        }
                                    }
                                )
                            }
                        }

                        Text("\(selectedTags.count) selected")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaChip(\"Tag\")")
                    CopyableCode(code: "LubaChip(\"Filter\", isDismissible: true) { }")
                    CopyableCode(code: "LubaChip(\"Pick\", style: .outlined, isSelected: true)")
                }
            }

            PhilosophyCard(
                icon: "tag",
                title: "Small But Mighty",
                description: "Chips turn abstract filters into tangible objects. Users can see, touch, and remove their selections — making complex filtering feel intuitive."
            )
        }
    }
}

// MARK: - Flow Layout

/// A simple wrapping layout for chips.
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}

#Preview {
    NavigationStack {
        ChipScreen()
    }
}
