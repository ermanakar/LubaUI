//
//  LubaSkeleton.swift
//  LubaUI
//
//  Skeleton loader components with shimmer animation.
//
//  Architecture:
//  - Uses LubaSkeletonTokens for all dimensions
//  - Respects LubaConfig for animations
//

import SwiftUI

// MARK: - LubaSkeleton

/// A skeleton placeholder with shimmer animation.
public struct LubaSkeleton: View {
    private let width: CGFloat?
    private let height: CGFloat
    private let cornerRadius: CGFloat

    @Environment(\.lubaConfig) private var config
    @State private var shimmerOffset: CGFloat = LubaSkeletonTokens.shimmerStart

    public init(
        width: CGFloat? = nil,
        height: CGFloat = LubaSkeletonTokens.defaultHeight,
        cornerRadius: CGFloat = LubaSkeletonTokens.cornerRadius
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(LubaColors.gray200)
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geo in
                    shimmerGradient
                        .frame(width: geo.size.width * LubaSkeletonTokens.shimmerWidthRatio)
                        .offset(x: shimmerOffset * geo.size.width)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .accessibilityHidden(true)
            .onAppear {
                guard config.animationsEnabled else { return }
                withAnimation(.easeInOut(duration: LubaSkeletonTokens.shimmerDuration).repeatForever(autoreverses: false)) {
                    shimmerOffset = LubaSkeletonTokens.shimmerEndRect
                }
            }
    }

    private var shimmerGradient: some View {
        LinearGradient(
            colors: [
                Color.clear,
                LubaColors.surface.opacity(LubaSkeletonTokens.shimmerOpacity),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Circle Skeleton

/// A circular skeleton placeholder.
public struct LubaSkeletonCircle: View {
    private let size: CGFloat

    @Environment(\.lubaConfig) private var config
    @State private var shimmerOffset: CGFloat = LubaSkeletonTokens.shimmerStart

    public init(size: CGFloat = LubaSkeletonTokens.defaultCircleSize) {
        self.size = size
    }

    public var body: some View {
        Circle()
            .fill(LubaColors.gray200)
            .frame(width: size, height: size)
            .overlay(
                LinearGradient(
                    colors: [
                        Color.clear,
                        LubaColors.surface.opacity(LubaSkeletonTokens.shimmerOpacity),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: size * 0.5)
                .offset(x: shimmerOffset * size)
            )
            .clipShape(Circle())
            .accessibilityHidden(true)
            .onAppear {
                guard config.animationsEnabled else { return }
                withAnimation(.easeInOut(duration: LubaSkeletonTokens.shimmerDuration).repeatForever(autoreverses: false)) {
                    shimmerOffset = LubaSkeletonTokens.shimmerEndCircle
                }
            }
    }
}

// MARK: - Text Skeleton

/// Multiple lines of skeleton text.
public struct LubaSkeletonText: View {
    private let lines: Int
    private let lastLineRatio: CGFloat
    private let lineHeight: CGFloat
    private let spacing: CGFloat

    public init(
        lines: Int = LubaSkeletonTokens.defaultLineCount,
        lastLineRatio: CGFloat = LubaSkeletonTokens.lastLineRatio,
        lineHeight: CGFloat = 12,
        spacing: CGFloat = LubaSkeletonTokens.lineSpacing
    ) {
        self.lines = max(1, lines)
        self.lastLineRatio = lastLineRatio
        self.lineHeight = lineHeight
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                let isLast = index == lines - 1

                GeometryReader { geo in
                    LubaSkeleton(
                        width: isLast ? geo.size.width * lastLineRatio : nil,
                        height: lineHeight
                    )
                }
                .frame(height: lineHeight)
            }
        }
    }
}

// MARK: - Card Skeleton

/// A skeleton placeholder for a card with avatar + text pattern.
public struct LubaSkeletonCard: View {
    private let avatarSize: CGFloat
    private let showBody: Bool

    public init(avatarSize: CGFloat = LubaSkeletonTokens.cardAvatarSize, showBody: Bool = true) {
        self.avatarSize = avatarSize
        self.showBody = showBody
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: LubaSkeletonTokens.sectionSpacing) {
            // Header row
            HStack(spacing: LubaSkeletonTokens.headerSpacing) {
                LubaSkeletonCircle(size: avatarSize)

                VStack(alignment: .leading, spacing: 6) {
                    LubaSkeleton(width: 100, height: LubaSkeletonTokens.defaultHeight)
                    LubaSkeleton(width: 60, height: 11)
                }

                Spacer()
            }

            // Body
            if showBody {
                LubaSkeletonText(lines: 2, lineHeight: 12)
            }
        }
        .padding(LubaSkeletonTokens.cardPadding)
        .background(LubaColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: LubaSkeletonTokens.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: LubaSkeletonTokens.cardCornerRadius, style: .continuous)
                .strokeBorder(LubaColors.border, lineWidth: 1)
        )
    }
}

// MARK: - Row Skeleton

/// A skeleton for a list row.
public struct LubaSkeletonRow: View {
    public init() {}

    public var body: some View {
        HStack(spacing: LubaSkeletonTokens.headerSpacing) {
            LubaSkeletonCircle(size: LubaSkeletonTokens.rowAvatarSize)

            VStack(alignment: .leading, spacing: 6) {
                LubaSkeleton(height: LubaSkeletonTokens.defaultHeight)
                LubaSkeleton(width: 80, height: 11)
            }
        }
        .frame(height: LubaSkeletonTokens.rowHeight)
    }
}

// MARK: - Preview

#Preview("Skeleton") {
    ScrollView {
        VStack(spacing: 24) {
            // Basic
            VStack(alignment: .leading, spacing: 8) {
                Text("BASIC").font(.caption).foregroundStyle(.secondary)
                LubaSkeleton(height: 16)
            }
            
            // Avatar + text
            VStack(alignment: .leading, spacing: 8) {
                Text("AVATAR + TEXT").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 12) {
                    LubaSkeletonCircle(size: 44)
                    VStack(alignment: .leading, spacing: 6) {
                        LubaSkeleton(width: 120, height: 14)
                        LubaSkeleton(width: 80, height: 11)
                    }
                }
            }
            
            // Text block
            VStack(alignment: .leading, spacing: 8) {
                Text("TEXT BLOCK").font(.caption).foregroundStyle(.secondary)
                LubaSkeletonText(lines: 3)
            }
            
            // Card
            VStack(alignment: .leading, spacing: 8) {
                Text("CARD").font(.caption).foregroundStyle(.secondary)
                LubaSkeletonCard()
            }
            
            // List rows
            VStack(alignment: .leading, spacing: 8) {
                Text("LIST").font(.caption).foregroundStyle(.secondary)
                LubaSkeletonRow()
                LubaSkeletonRow()
            }
        }
        .padding(20)
    }
    .background(LubaColors.background)
}
