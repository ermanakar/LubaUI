//
//  LoadingPatternsScreen.swift
//  LubaUIShowcase
//
//  Composed loading patterns using skeleton, spinner, and progress components.
//

import SwiftUI
import LubaUI

struct LoadingPatternsScreen: View {
    @State private var feedLoading = true
    @State private var uploadProgress = 0.0
    @State private var uploadTimer: Timer?

    var body: some View {
        ShowcaseScreen("Loading Patterns") {
            ShowcaseHeader(
                title: "Loading Patterns",
                description: "Composed patterns for loading states — skeletons, progress, and transitions that keep users informed."
            )

            // Feed Skeleton → Content
            DemoSection(title: "Feed Loading") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        if feedLoading {
                            ForEach(0..<3, id: \.self) { _ in
                                LubaSkeletonCard()
                            }
                        } else {
                            ForEach(0..<3, id: \.self) { index in
                                feedItem(name: ["Sarah Chen", "Alex Morgan", "Jamie Lee"][index],
                                         text: ["Just shipped a new feature!", "Working on the design system today.", "Love the new components!"][index],
                                         time: ["\(index + 1)h ago", "\(index + 2)h ago", "\(index + 3)h ago"][index])
                            }
                        }

                        LubaButton(feedLoading ? "Show Content" : "Show Skeleton", style: .secondary, fullWidth: true) {
                            withAnimation(LubaAnimations.standard) {
                                feedLoading.toggle()
                            }
                        }
                    }
                }
            }

            // Inline Loading
            DemoSection(title: "Inline Loading") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaSpinner(size: 20, style: .arc)
                            Text("Refreshing feed...")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                            Spacer()
                        }

                        LubaDivider()

                        HStack(spacing: LubaSpacing.md) {
                            LubaSpinner(size: 20, style: .dots)
                            Text("Syncing changes...")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                            Spacer()
                        }

                        LubaDivider()

                        HStack(spacing: LubaSpacing.md) {
                            LubaSpinner(size: 20, style: .breathe)
                            Text("Connecting...")
                                .font(LubaTypography.body)
                                .foregroundStyle(LubaColors.textSecondary)
                            Spacer()
                        }
                    }
                }
            }

            // Upload Progress
            DemoSection(title: "File Upload") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaCircledIcon("doc.fill", size: .md, style: .subtle)

                            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                                Text("design-system.zip")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text(uploadProgress >= 1 ? "Upload complete" : "Uploading...")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(uploadProgress >= 1 ? LubaColors.success : LubaColors.textTertiary)
                            }

                            Spacer()

                            if uploadProgress >= 1 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(LubaColors.success)
                            } else {
                                LubaCircularProgress(value: uploadProgress, size: 36, lineWidth: 3, showLabel: false)
                            }
                        }

                        LubaProgressBar(value: uploadProgress, showLabel: true)

                        LubaButton(
                            uploadProgress >= 1 ? "Reset" : (uploadProgress > 0 ? "Uploading..." : "Start Upload"),
                            style: uploadProgress >= 1 ? .secondary : .primary,
                            isLoading: uploadProgress > 0 && uploadProgress < 1,
                            fullWidth: true
                        ) {
                            if uploadProgress >= 1 {
                                uploadProgress = 0
                            } else {
                                simulateUpload()
                            }
                        }
                    }
                }
            }

            // Button Loading States
            DemoSection(title: "Button Loading States") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaButton("Save Changes", style: .primary, isLoading: true, fullWidth: true) { }
                        LubaButton("Sending...", style: .secondary, isLoading: true, fullWidth: true) { }
                        LubaButton("Processing", style: .ghost, isLoading: true, fullWidth: true) { }
                    }
                }
            }

            // Full Page Loading
            DemoSection(title: "Full Page Overlay") {
                LubaCard(elevation: .low) {
                    ZStack {
                        VStack(spacing: LubaSpacing.md) {
                            ForEach(0..<3, id: \.self) { _ in
                                HStack(spacing: LubaSpacing.md) {
                                    RoundedRectangle.luba(LubaRadius.sm)
                                        .fill(LubaColors.gray100)
                                        .frame(width: 40, height: 40)
                                    VStack(alignment: .leading, spacing: 4) {
                                        RoundedRectangle.luba(LubaRadius.xs)
                                            .fill(LubaColors.gray100)
                                            .frame(height: 12)
                                        RoundedRectangle.luba(LubaRadius.xs)
                                            .fill(LubaColors.gray100)
                                            .frame(width: 100, height: 10)
                                    }
                                }
                            }
                        }
                        .opacity(0.5)

                        VStack(spacing: LubaSpacing.md) {
                            LubaSpinner(size: 32, style: .arc)
                            Text("Loading...")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }

            // Philosophy
            PhilosophyCard(
                icon: "hourglass",
                title: "Loading is Communication",
                description: "Skeletons preserve layout and reduce perceived wait time. Progress indicators set expectations. Inline spinners keep context. Choose the right pattern for the right moment."
            )
        }
    }

    // MARK: - Components

    private func feedItem(name: String, text: String, time: String) -> some View {
        HStack(alignment: .top, spacing: LubaSpacing.md) {
            LubaAvatar(name: name, size: .medium)

            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                HStack {
                    Text(name)
                        .font(LubaTypography.headline)
                        .foregroundStyle(LubaColors.textPrimary)
                    Spacer()
                    Text(time)
                        .font(LubaTypography.caption)
                        .foregroundStyle(LubaColors.textTertiary)
                }
                Text(text)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textSecondary)
            }
        }
        .padding(LubaSpacing.md)
        .background(LubaColors.surface)
        .clipShape(RoundedRectangle.luba(LubaRadius.md))
        .overlay(
            RoundedRectangle.luba(LubaRadius.md)
                .strokeBorder(LubaColors.border, lineWidth: 1)
        )
    }

    private func simulateUpload() {
        uploadProgress = 0.01
        uploadTimer?.invalidate()
        uploadTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation(LubaAnimations.smooth) {
                uploadProgress += 0.05
                if uploadProgress >= 1 {
                    uploadProgress = 1
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoadingPatternsScreen()
    }
}
