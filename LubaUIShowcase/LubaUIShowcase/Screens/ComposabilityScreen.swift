//
//  ComposabilityScreen.swift
//  LubaUIShowcase
//
//  The crown jewel — demonstrating composable modifiers over inheritance.
//

import SwiftUI
import LubaUI

struct ComposabilityScreen: View {
    @State private var isExpanded = false
    @State private var isLoading = false
    @State private var usePressable = true
    @State private var useShimmer = false
    @State private var useGlass = false
    @State private var useExpandable = false
    @State private var mixExpanded = false
    @State private var tapCount = 0

    var body: some View {
        ShowcaseScreen("Composability") {
            ShowcaseHeader(
                title: "Composability",
                description: "LubaUI's core innovation — behaviors as modifiers, not subclasses. Any view gains interactive powers through composition."
            )

            // The Big Idea
            PhilosophyCard(
                icon: "puzzlepiece.extension",
                title: "Modifiers Over Inheritance",
                description: "Traditional design systems lock behaviors into component subclasses. LubaUI extracts them into primitives — small, composable modifiers that work on any view."
            )

            // Stacking Primitives
            DemoSection(title: "Stacking Primitives") {
                VStack(spacing: LubaSpacing.md) {
                    LubaCard(elevation: .low) {
                        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                            HStack {
                                LubaCircledIcon("hand.tap.fill", size: .sm, style: .subtle)
                                Text("Pressable + Expandable")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                            }

                            Text("This card is both tappable and expandable — two primitives composed together.")
                                .font(LubaTypography.bodySmall)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                    }
                    .lubaPressable { isExpanded.toggle() }
                    .lubaExpandable(isExpanded: $isExpanded) {
                        LubaCard(elevation: .flat, style: .outlined) {
                            VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                                Text("Expanded content")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("This section appeared because the card above uses .lubaExpandable(). The press came from .lubaPressable(). Neither knows about the other — they just compose.")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                        }
                    }

                    Text("Tap the card above")
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Mix & Match
            DemoSection(title: "Mix & Match") {
                VStack(spacing: LubaSpacing.md) {
                    // Toggle controls
                    LubaCard(elevation: .flat, style: .outlined) {
                        VStack(spacing: 0) {
                            LubaToggle(isOn: $usePressable, label: "Pressable")
                            LubaDivider()
                            LubaToggle(isOn: $useShimmer, label: "Shimmerable")
                            LubaDivider()
                            LubaToggle(isOn: $useGlass, label: "Glass")
                            LubaDivider()
                            LubaToggle(isOn: $useExpandable, label: "Expandable")
                        }
                    }

                    // Demo card with toggled primitives
                    demoCard
                }
            }

            // Glass + Press
            DemoSection(title: "Glass + Pressable") {
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(hex: 0x6B8068),
                            Color(hex: 0x3D5A3E),
                            Color(hex: 0x8FB58C)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: LubaRadius.md, style: .continuous))

                    HStack {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Glass Card")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("Tap count: \(tapCount)")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(LubaColors.accent)
                    }
                    .padding(LubaSpacing.lg)
                    .lubaGlass()
                    .lubaPressable { tapCount += 1 }
                    .padding(LubaSpacing.lg)
                }
            }

            // Code Examples
            DemoSection(title: "How It Works") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "view.lubaPressable { action() }")
                    CopyableCode(code: "view.lubaShimmerable(isLoading: true)")
                    CopyableCode(code: "view.lubaGlass(.subtle, tint: .blue)")
                    CopyableCode(code: "view.lubaExpandable(isExpanded: $exp) { }")
                }
            }

            // Before/After
            DemoSection(title: "Composition Pattern") {
                CodeBlock {
                    VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                        Text("// Stack any combination of primitives")
                            .foregroundStyle(LubaColors.textTertiary)
                        Text("LubaCard { content }")
                            .foregroundStyle(LubaColors.textPrimary)
                        Text("    .lubaGlass(.subtle)")
                            .foregroundStyle(LubaColors.accent)
                        Text("    .lubaPressable { doSomething() }")
                            .foregroundStyle(LubaColors.accent)
                        Text("    .lubaShimmerable(isLoading: loading)")
                            .foregroundStyle(LubaColors.accent)
                    }
                }
            }

            PhilosophyCard(
                icon: "arrow.triangle.branch",
                title: "Infinite Combinations",
                description: "6 primitives don't give you 6 features — they give you 2^6 = 64 combinations. Every primitive works with every other, and with every component. That's radical composability."
            )
        }
    }

    // MARK: - Components

    @ViewBuilder
    private var demoCard: some View {
        let card = LubaCard(elevation: .low) {
            VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                HStack {
                    Text("Demo Card")
                        .font(LubaTypography.headline)
                        .foregroundStyle(LubaColors.textPrimary)
                    Spacer()
                    activeModifierBadges
                }

                Text("Toggle the switches above to add or remove primitives from this card in real time.")
                    .font(LubaTypography.bodySmall)
                    .foregroundStyle(LubaColors.textSecondary)
            }
        }

        let shimmerableCard = card
            .lubaShimmerable(isLoading: useShimmer)

        let glassOrPlain = useGlass
            ? AnyView(shimmerableCard.lubaGlass(.subtle))
            : AnyView(shimmerableCard)

        let pressableOrNot = usePressable
            ? AnyView(glassOrPlain.lubaPressable { mixExpanded.toggle() })
            : AnyView(glassOrPlain)

        if useExpandable {
            pressableOrNot
                .lubaExpandable(isExpanded: $mixExpanded) {
                    LubaCard(elevation: .flat, style: .outlined) {
                        Text("Expanded via .lubaExpandable()")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
        } else {
            pressableOrNot
        }
    }

    private var activeModifierBadges: some View {
        HStack(spacing: LubaSpacing.xs) {
            if usePressable { modifierBadge("P") }
            if useShimmer { modifierBadge("S") }
            if useGlass { modifierBadge("G") }
            if useExpandable { modifierBadge("E") }
        }
    }

    private func modifierBadge(_ letter: String) -> some View {
        Text(letter)
            .font(LubaTypography.custom(size: 10, weight: .bold))
            .foregroundStyle(LubaColors.accent)
            .frame(width: 20, height: 20)
            .background(LubaColors.accentSubtle)
            .clipShape(Circle())
    }
}

#Preview {
    NavigationStack {
        ComposabilityScreen()
    }
}
