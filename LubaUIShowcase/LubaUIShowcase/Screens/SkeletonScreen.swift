//
//  SkeletonScreen.swift
//  LubaUIShowcase
//
//  Skeleton loading showcase with shimmer animations and real-world examples.
//

import SwiftUI
import LubaUI

struct SkeletonScreen: View {
    @State private var isLoading = true

    var body: some View {
        ShowcaseScreen("Skeleton") {
            ShowcaseHeader(
                title: "Skeleton",
                description: "Loading placeholders with subtle shimmer animations. Toggle to see the magic."
            )

            // Toggle
            DemoSection(title: "Toggle Loading") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaToggle(isOn: $isLoading, label: "Show skeletons")
                }
            }

            // Basic Line
            DemoSection(title: "Basic Line") {
                LubaCard(elevation: .flat, style: .outlined) {
                    if isLoading {
                        LubaSkeleton(height: 16)
                    } else {
                        Text("This is loaded content that replaces the skeleton.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textPrimary)
                    }
                }
            }

            // Avatar + Text
            DemoSection(title: "Avatar + Text") {
                LubaCard(elevation: .flat, style: .outlined) {
                    if isLoading {
                        HStack(spacing: LubaSpacing.md) {
                            LubaSkeletonCircle(size: 44)
                            VStack(alignment: .leading, spacing: LubaSpacing.sm) {
                                LubaSkeleton(width: 120, height: 14)
                                LubaSkeleton(width: 80, height: 11)
                            }
                        }
                    } else {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Jane Doe", size: .medium)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Jane Doe")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Product Designer")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                        }
                    }
                }
            }

            // Text Block
            DemoSection(title: "Text Block") {
                LubaCard(elevation: .flat, style: .outlined) {
                    if isLoading {
                        LubaSkeletonText(lines: 3)
                    } else {
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                }
            }

            // Card
            DemoSection(title: "Card") {
                if isLoading {
                    LubaSkeletonCard()
                } else {
                    LubaCard(elevation: .low) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "Alex Smith", size: .medium)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Alex Smith")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Just posted an update")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                            Spacer()
                        }
                    }
                }
            }

            // List Rows
            DemoSection(title: "List Rows") {
                LubaCard(elevation: .flat, style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        if isLoading {
                            ForEach(0..<3, id: \.self) { _ in
                                LubaSkeletonRow()
                                    .padding(.horizontal, LubaSpacing.lg)
                                LubaDivider()
                            }
                        } else {
                            ForEach(["Alice Johnson", "Bob Chen", "Carol White"], id: \.self) { name in
                                HStack(spacing: LubaSpacing.md) {
                                    LubaAvatar(name: name, size: .medium)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(name)
                                            .font(LubaTypography.body)
                                            .foregroundStyle(LubaColors.textPrimary)
                                        Text("Online")
                                            .font(LubaTypography.caption)
                                            .foregroundStyle(LubaColors.success)
                                    }
                                    Spacer()
                                }
                                .padding(LubaSpacing.lg)

                                if name != "Carol White" {
                                    LubaDivider()
                                }
                            }
                        }
                    }
                }
            }

            // Real-World: Feed
            DemoSection(title: "Feed Example") {
                VStack(spacing: LubaSpacing.md) {
                    ForEach(0..<2, id: \.self) { index in
                        LubaCard(elevation: .low) {
                            VStack(alignment: .leading, spacing: LubaSpacing.md) {
                                if isLoading {
                                    HStack(spacing: LubaSpacing.md) {
                                        LubaSkeletonCircle(size: 40)
                                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                            LubaSkeleton(width: 100, height: 14)
                                            LubaSkeleton(width: 60, height: 10)
                                        }
                                    }

                                    LubaSkeletonText(lines: 2)

                                    LubaSkeleton(height: 180)
                                } else {
                                    HStack(spacing: LubaSpacing.md) {
                                        LubaAvatar(name: index == 0 ? "Sarah Kim" : "Mike Davis", size: .medium)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(index == 0 ? "Sarah Kim" : "Mike Davis")
                                                .font(LubaTypography.headline)
                                                .foregroundStyle(LubaColors.textPrimary)
                                            Text(index == 0 ? "2h ago" : "5h ago")
                                                .font(LubaTypography.caption)
                                                .foregroundStyle(LubaColors.textTertiary)
                                        }
                                        Spacer()
                                    }

                                    Text(index == 0 ? "Just shipped a new feature! Really proud of what the team accomplished." : "Beautiful day for a hike in the mountains.")
                                        .font(LubaTypography.body)
                                        .foregroundStyle(LubaColors.textSecondary)

                                    RoundedRectangle(cornerRadius: LubaRadius.md)
                                        .fill(LubaColors.gray200)
                                        .frame(height: 180)
                                }
                            }
                        }
                    }
                }
            }

            // Real-World: Profile
            DemoSection(title: "Profile Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        if isLoading {
                            LubaSkeletonCircle(size: 80)
                            VStack(spacing: LubaSpacing.sm) {
                                LubaSkeleton(width: 120, height: 20)
                                LubaSkeleton(width: 80, height: 14)
                            }
                            HStack(spacing: LubaSpacing.md) {
                                LubaSkeleton(width: 80, height: 36)
                                LubaSkeleton(width: 80, height: 36)
                            }
                        } else {
                            LubaAvatar(name: "Erman Akar", size: .xlarge)
                            VStack(spacing: LubaSpacing.xs) {
                                Text("Erman Akar")
                                    .font(LubaTypography.title)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("Creator of LubaUI")
                                    .font(LubaTypography.body)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }
                            HStack(spacing: LubaSpacing.md) {
                                LubaButton("Follow", style: .primary, size: .small) { }
                                LubaButton("Message", style: .secondary, size: .small) { }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isLoading)
    }

}

#Preview {
    NavigationStack {
        SkeletonScreen()
    }
}
