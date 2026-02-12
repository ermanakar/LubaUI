//
//  MotionScreen.swift
//  LubaUIShowcase
//
//  Demonstrating the invisible craft — LubaMotion tokens.
//

import SwiftUI
import LubaUI

struct MotionScreen: View {
    @State private var isPressed = false
    @State private var isToggled = false
    @State private var progress: CGFloat = 0.3

    var body: some View {
        ShowcaseScreen("Motion") {
            ShowcaseHeader(
                title: "Motion",
                description: "Every animation in LubaUI is tokenized. No magic numbers — just documented decisions."
            )

            // Philosophy callout
            philosophyCard

            // Press Scale Demo
            DemoSection(title: "Press Scale") {
                HStack(spacing: LubaSpacing.xl) {
                    VStack(spacing: LubaSpacing.sm) {
                        Circle()
                            .fill(LubaColors.accent)
                            .frame(width: 60, height: 60)
                            .scaleEffect(isPressed ? LubaMotion.pressScale : 1.0)
                            .animation(LubaMotion.pressAnimation, value: isPressed)

                        Text("0.97")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundStyle(LubaColors.textSecondary)
                        Text("Standard")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }

                    VStack(spacing: LubaSpacing.sm) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LubaColors.accentSubtle)
                            .frame(width: 80, height: 60)
                            .scaleEffect(isPressed ? LubaMotion.pressScaleProminent : 1.0)
                            .animation(LubaMotion.pressAnimation, value: isPressed)

                        Text("0.98")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundStyle(LubaColors.textSecondary)
                        Text("Prominent")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, LubaSpacing.lg)
                .contentShape(Rectangle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )

                Text("Touch and hold to see the scale")
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textTertiary)
                    .frame(maxWidth: .infinity)
            }

            // Animation Types
            DemoSection(title: "Animation Tokens") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: 0) {
                        animationRow("pressAnimation", "spring(0.25, 0.65)", "Quick bounce")
                        LubaDivider()
                        animationRow("stateAnimation", "spring(0.35, 0.75)", "State changes")
                        LubaDivider()
                        animationRow("colorAnimation", "easeOut(0.12)", "Color transitions")
                        LubaDivider()
                        animationRow("micro", "spring(0.2, 0.7)", "Ultra-quick")
                        LubaDivider()
                        animationRow("gentle", "spring(0.4, 0.8)", "Soft transitions")
                    }
                }
            }

            // Live Demo
            DemoSection(title: "Feel the Difference") {
                VStack(spacing: LubaSpacing.lg) {
                    // Toggle with state animation
                    HStack {
                        Text("State Animation")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)
                        Spacer()
                        LubaToggle(isOn: $isToggled)
                    }
                    .padding()
                    .background(LubaColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Progress with smooth animation
                    VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                        Text("Smooth Progress")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaProgressBar(value: progress, showLabel: true)

                        HStack(spacing: LubaSpacing.sm) {
                            Button("25%") { withAnimation(LubaMotion.stateAnimation) { progress = 0.25 } }
                            Button("50%") { withAnimation(LubaMotion.stateAnimation) { progress = 0.5 } }
                            Button("75%") { withAnimation(LubaMotion.stateAnimation) { progress = 0.75 } }
                            Button("100%") { withAnimation(LubaMotion.stateAnimation) { progress = 1.0 } }
                        }
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.accent)
                    }
                    .padding()
                    .background(LubaColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            // The Invisible Craft
            invisibleCraftCard
        }
    }

    // MARK: - Components

    private var philosophyCard: some View {
        LubaCard(elevation: .flat, style: .outlined) {
            HStack(alignment: .top, spacing: LubaSpacing.md) {
                LubaCircledIcon("wand.and.stars", size: .md, style: .subtle)

                VStack(alignment: .leading, spacing: 4) {
                    Text("The Invisible Craft")
                        .font(LubaTypography.headline)
                        .foregroundStyle(LubaColors.textPrimary)

                    Text("Why 0.97 scale and not 0.95? Because 0.95 feels cartoonish. 0.98 feels too subtle. 0.97 is the sweet spot — you feel it, but it doesn't distract.")
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                }
            }
        }
    }

    private var invisibleCraftCard: some View {
        DemoSection(title: "Documented Rationale") {
            LubaCard(elevation: .low) {
                VStack(alignment: .leading, spacing: LubaSpacing.md) {
                    craftItem("pressScale = 0.97", "Not 0.98 (too subtle), not 0.95 (too cartoonish)")
                    craftItem("response = 0.25s", "Fast enough to feel responsive, slow enough to see")
                    craftItem("dampingFraction = 0.65", "Slight bounce — alive, not mechanical")
                    craftItem("disabledOpacity = 0.45", "Clearly disabled, but not invisible")
                }
            }
        }
    }

    private func animationRow(_ name: String, _ value: String, _ purpose: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(LubaColors.accent)
                Text(purpose)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textTertiary)
            }
            Spacer()
            Text(value)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(LubaColors.textSecondary)
        }
        .padding(.vertical, LubaSpacing.sm)
    }

    private func craftItem(_ token: String, _ rationale: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(token)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(LubaColors.textPrimary)
            Text(rationale)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textSecondary)
        }
    }

}

#Preview {
    NavigationStack {
        MotionScreen()
    }
}
