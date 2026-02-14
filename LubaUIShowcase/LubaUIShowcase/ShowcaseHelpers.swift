//
//  ShowcaseHelpers.swift
//  LubaUIShowcase
//
//  Shared views for showcase screens — extracted to eliminate duplication.
//

import SwiftUI
import LubaUI

// MARK: - Screen Header

/// Standard header for all showcase screens.
struct ShowcaseHeader: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: LubaSpacing.sm) {
            Text(title)
                .font(LubaTypography.title)
                .foregroundStyle(LubaColors.textPrimary)

            Text(description)
                .font(LubaTypography.body)
                .foregroundStyle(LubaColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Demo Section

/// Section wrapper with uppercase label — used in every showcase screen.
struct DemoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: LubaSpacing.md) {
            Text(title)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            content
        }
    }
}

// MARK: - Philosophy Card

/// Callout card for explaining design rationale.
struct PhilosophyCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        LubaCard(elevation: .flat, style: .outlined) {
            HStack(alignment: .top, spacing: LubaSpacing.md) {
                LubaCircledIcon(icon, size: .md, style: .subtle)

                VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                    Text(title)
                        .font(LubaTypography.headline)
                        .foregroundStyle(LubaColors.textPrimary)

                    Text(description)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Code Block

/// Monospaced code display inside a card.
struct CodeBlock<Content: View>: View {
    @ViewBuilder let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        LubaCard(elevation: .flat, style: .outlined) {
            VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                content
            }
            .font(LubaTypography.code)
        }
    }
}

// MARK: - Copyable Code

/// A single-line code snippet with tap-to-copy.
struct CopyableCode: View {
    let code: String
    @State private var copied = false

    var body: some View {
        HStack {
            Text(code)
                .font(LubaTypography.code)
                .foregroundStyle(LubaColors.accent)
                .lineLimit(1)

            Spacer()

            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                .font(LubaTypography.custom(size: 12, weight: .medium))
                .foregroundStyle(copied ? LubaColors.success : LubaColors.textTertiary)
        }
        .padding(LubaSpacing.md)
        .background(LubaColors.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: LubaRadius.sm, style: .continuous))
        .lubaPressable {
            #if os(iOS)
            UIPasteboard.general.string = code
            #endif
            withAnimation(LubaAnimations.quick) { copied = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(LubaAnimations.quick) { copied = false }
            }
        }
    }
}

// MARK: - Showcase Screen Layout

/// Standard scroll layout used by every showcase screen.
struct ShowcaseScreen<Content: View>: View {
    let navigationTitle: String
    @ViewBuilder let content: Content

    init(_ navigationTitle: String, @ViewBuilder content: () -> Content) {
        self.navigationTitle = navigationTitle
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: LubaSpacing.xxl) {
                content
            }
            .padding(LubaSpacing.lg)
        }
        .background(LubaColors.background)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
