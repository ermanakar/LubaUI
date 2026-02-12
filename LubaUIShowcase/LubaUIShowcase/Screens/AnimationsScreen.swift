//
//  AnimationsScreen.swift
//  LubaUIShowcase
//
//  Animation presets and transitions showcase with interactive demos.
//

import SwiftUI
import LubaUI

struct AnimationsScreen: View {
    @State private var springDemo = false
    @State private var easedDemo = false
    @State private var staggerDemo = false
    @State private var transitionDemo = false
    @State private var transitionStyle = 0

    var body: some View {
        ShowcaseScreen("Animations") {
            ShowcaseHeader(
                title: "Animations",
                description: "Carefully tuned spring and eased presets for consistent, premium motion across your app."
            )

            // Spring Presets
            DemoSection(title: "Spring Presets") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        springRow(name: "quick", desc: "0.3s / 0.7 damping", animation: LubaAnimations.quick)
                        LubaDivider()
                        springRow(name: "standard", desc: "0.4s / 0.75 damping", animation: LubaAnimations.standard)
                        LubaDivider()
                        springRow(name: "gentle", desc: "0.5s / 0.8 damping", animation: LubaAnimations.gentle)
                        LubaDivider()
                        springRow(name: "bouncy", desc: "0.4s / 0.6 damping", animation: LubaAnimations.bouncy)
                    }
                }
            }

            // Interactive Spring Demo
            DemoSection(title: "Spring Comparison") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            animatedDot(label: "Quick", animation: LubaAnimations.quick, isActive: springDemo)
                            animatedDot(label: "Standard", animation: LubaAnimations.standard, isActive: springDemo)
                            animatedDot(label: "Gentle", animation: LubaAnimations.gentle, isActive: springDemo)
                            animatedDot(label: "Bouncy", animation: LubaAnimations.bouncy, isActive: springDemo)
                        }
                        .frame(maxWidth: .infinity)

                        LubaButton("Animate", style: .primary, fullWidth: true) {
                            springDemo.toggle()
                        }
                    }
                }
            }

            // Eased Presets
            DemoSection(title: "Eased Presets") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        easedRow(name: "fadeIn", desc: "0.2s easeOut — appearing elements", animation: LubaAnimations.fadeIn)
                        LubaDivider()
                        easedRow(name: "smooth", desc: "0.25s easeInOut — color/opacity", animation: LubaAnimations.smooth)
                        LubaDivider()
                        easedRow(name: "subtle", desc: "0.4s easeInOut — background changes", animation: LubaAnimations.subtle)
                    }
                }
            }

            // Stagger Demo
            DemoSection(title: "Stagger Animation") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        ForEach(0..<5, id: \.self) { index in
                            HStack(spacing: LubaSpacing.md) {
                                LubaCircledIcon("star.fill", size: .sm, style: .subtle)

                                Text("List item \(index + 1)")
                                    .font(LubaTypography.body)
                                    .foregroundStyle(LubaColors.textPrimary)

                                Spacer()

                                Text("0.05s \u{00D7} \(index)")
                                    .font(LubaTypography.code)
                                    .foregroundStyle(LubaColors.textTertiary)
                            }
                            .opacity(staggerDemo ? 1 : 0)
                            .offset(y: staggerDemo ? 0 : 20)
                            .animation(
                                LubaAnimations.standard.delay(LubaAnimations.staggerDelay(for: index)),
                                value: staggerDemo
                            )
                        }

                        LubaButton(staggerDemo ? "Reset" : "Stagger In", style: .secondary, fullWidth: true) {
                            staggerDemo.toggle()
                        }
                    }
                }
            }

            // Transitions
            DemoSection(title: "Transition Presets") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaTabs(
                            selection: $transitionStyle,
                            tabs: [
                                (value: 0, label: "Slide Up"),
                                (value: 1, label: "Scale"),
                                (value: 2, label: "Fade")
                            ]
                        )

                        ZStack {
                            if transitionDemo {
                                LubaCard(elevation: .flat, style: .outlined) {
                                    HStack(spacing: LubaSpacing.md) {
                                        LubaCircledIcon("checkmark", size: .md, style: .subtle)
                                        Text("Transitioned content")
                                            .font(LubaTypography.body)
                                            .foregroundStyle(LubaColors.textPrimary)
                                        Spacer()
                                    }
                                }
                                .transition(currentTransition)
                            }
                        }
                        .frame(minHeight: 64)

                        LubaButton(transitionDemo ? "Remove" : "Show", style: .secondary, fullWidth: true) {
                            withAnimation(LubaAnimations.standard) {
                                transitionDemo.toggle()
                            }
                        }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Animation preset")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text("withAnimation(LubaAnimations.quick) { ... }")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("View modifier")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text(".lubaAnimation(.bouncy, value: isActive)")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }

                        LubaDivider()

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            Text("Transition")
                                .font(LubaTypography.headline)
                                .foregroundStyle(LubaColors.textPrimary)
                            Text(".transition(.lubaSlideUp)")
                                .font(LubaTypography.code)
                                .foregroundStyle(LubaColors.accent)
                        }
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "wand.and.stars",
                title: "Motion That Feels Alive",
                description: "Springs over bezier curves. Each preset is tuned for a specific use case — quick for micro-interactions, bouncy for celebrations, gentle for large transitions. Consistent motion creates a cohesive personality."
            )
        }
    }

    // MARK: - Components

    private func springRow(name: String, desc: String, animation: Animation) -> some View {
        HStack(spacing: LubaSpacing.md) {
            Text(name)
                .font(LubaTypography.headline)
                .foregroundStyle(LubaColors.textPrimary)
                .frame(width: 80, alignment: .leading)

            Text(desc)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)

            Spacer()
        }
    }

    private func animatedDot(label: String, animation: Animation, isActive: Bool) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            Circle()
                .fill(LubaColors.accent)
                .frame(width: 24, height: 24)
                .offset(y: isActive ? -40 : 0)
                .animation(animation, value: isActive)

            Text(label)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
    }

    private func easedRow(name: String, desc: String, animation: Animation) -> some View {
        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
            Text(name)
                .font(LubaTypography.headline)
                .foregroundStyle(LubaColors.textPrimary)
            Text(desc)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(LubaSpacing.lg)
    }

    private var currentTransition: AnyTransition {
        switch transitionStyle {
        case 0: return .lubaSlideUp
        case 1: return .lubaScale
        default: return .lubaFade
        }
    }
}

#Preview {
    NavigationStack {
        AnimationsScreen()
    }
}
