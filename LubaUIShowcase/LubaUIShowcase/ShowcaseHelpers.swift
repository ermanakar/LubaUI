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
    @LubaEnvironment private var luba
    let title: String // Retained for compatibility with existing screens
    let description: String

    var body: some View {
        Text(description)
            .font(luba.fonts.body)
            .foregroundStyle(luba.colors.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Demo Section

/// Section wrapper with uppercase label — used in every showcase screen.
struct DemoSection<Content: View>: View {
    @LubaEnvironment private var luba
    let title: String
    @ViewBuilder let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: luba.spacing.md) {
            Text(title)
                .font(luba.fonts.caption)
                .foregroundStyle(luba.colors.textTertiary)
                .textCase(.uppercase)
                .tracking(0.5)

            content
        }
    }
}

// MARK: - Philosophy Card

/// Callout card for explaining design rationale.
struct PhilosophyCard: View {
    @LubaEnvironment private var luba
    let icon: String
    let title: String
    let description: String

    var body: some View {
        LubaCard(elevation: .flat, style: .outlined) {
            HStack(alignment: .top, spacing: luba.spacing.md) {
                LubaCircledIcon(icon, size: .md, style: .subtle)

                VStack(alignment: .leading, spacing: luba.spacing.xs) {
                    Text(title)
                        .font(luba.fonts.headline)
                        .foregroundStyle(luba.colors.textPrimary)

                    Text(description)
                        .font(luba.fonts.caption)
                        .foregroundStyle(luba.colors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Code Block

/// Monospaced code display inside a card.
struct CodeBlock<Content: View>: View {
    @LubaEnvironment private var luba
    @ViewBuilder let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        LubaCard(elevation: .flat, style: .outlined) {
            VStack(alignment: .leading, spacing: luba.spacing.sm) {
                content
            }
            .font(luba.fonts.code)
        }
    }
}

// MARK: - Copyable Code

/// A single-line code snippet with tap-to-copy.
struct CopyableCode: View {
    @LubaEnvironment private var luba
    let code: String
    @State private var copied = false

    var body: some View {
        Button {
            #if os(iOS)
            UIPasteboard.general.string = code
            #endif
            copied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
        } label: {
            HStack {
                Text(code)
                    .font(luba.fonts.code)
                    .foregroundStyle(luba.colors.accent)
                    .lineLimit(1)

                Spacer()

                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                    .font(luba.fonts.caption)
                    .foregroundStyle(copied ? luba.colors.success : luba.colors.textTertiary)
            }
            .padding(luba.spacing.md)
            .background(luba.colors.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: luba.radius.sm, style: .continuous))
        }
        .buttonStyle(LubaPressableButtonStyle())
        .lubaMinTouchTarget(luba)
        .accessibilityLabel("Copy code: \(code)")
        .accessibilityValue(copied ? "Copied" : "")
    }
}

// MARK: - Showcase Screen Layout

/// Standard scroll layout used by every showcase screen.
struct ShowcaseScreen<Content: View>: View {
    @LubaEnvironment private var luba
    let navigationTitle: String
    @ViewBuilder let content: Content

    init(_ navigationTitle: String, @ViewBuilder content: () -> Content) {
        self.navigationTitle = navigationTitle
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: luba.spacing.xxl) {
                content
            }
            .padding(luba.spacing.lg)
        }
        .background(luba.colors.background)
        .lubaTooltipHost()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
    }
}
