//
//  ProgressScreen.swift
//  LubaUIShowcase
//
//  Progress indicators showcase with bars, circles, spinners, and real-world examples.
//

import SwiftUI
import LubaUI

struct ProgressScreen: View {
    @State private var progress: Double = 0.65
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false

    var body: some View {
        ShowcaseScreen("Progress") {
            ShowcaseHeader(
                title: "Progress",
                description: "Linear bars, circular indicators, and loading spinners with smooth animations."
            )

            // Linear Progress
            DemoSection(title: "Linear Progress") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            LubaProgressBar(value: progress, showLabel: true)
                            Text("With label")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            LubaProgressBar(value: 0.33)
                            Text("Without label")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                            LubaProgressBar(value: 1.0, showLabel: true)
                            Text("Complete")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                }
            }

            // Circular Progress
            DemoSection(title: "Circular Progress") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.xxl) {
                        VStack(spacing: LubaSpacing.sm) {
                            LubaCircularProgress(value: progress)
                            Text("Default")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaCircularProgress(value: 0.33, size: 48, showLabel: false)
                            Text("No label")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }

                        VStack(spacing: LubaSpacing.sm) {
                            LubaCircularProgress(value: 0.85, size: 48)
                            Text("85%")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Spinner Styles
            DemoSection(title: "Spinner Styles") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.xxl) {
                        spinnerDemo(.arc, "Arc")
                        spinnerDemo(.pulse, "Pulse")
                        spinnerDemo(.dots, "Dots")
                        spinnerDemo(.breathe, "Breathe")
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Spinner Sizes
            DemoSection(title: "Spinner Sizes") {
                LubaCard(elevation: .flat, style: .outlined) {
                    HStack(spacing: LubaSpacing.xxl) {
                        VStack(spacing: LubaSpacing.sm) {
                            LubaSpinner(size: 16)
                            Text("16pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                        VStack(spacing: LubaSpacing.sm) {
                            LubaSpinner(size: 24)
                            Text("24pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                        VStack(spacing: LubaSpacing.sm) {
                            LubaSpinner(size: 32)
                            Text("32pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                        VStack(spacing: LubaSpacing.sm) {
                            LubaSpinner(size: 48)
                            Text("48pt")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(LubaColors.textTertiary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Interactive Slider
            DemoSection(title: "Interactive") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaSlider(value: $progress, label: "Adjust Progress", showValue: true)
                }
            }

            // Real-World: File Upload
            DemoSection(title: "File Upload Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaCircledIcon("doc.fill", size: .md, style: .subtle)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("presentation.pdf")
                                    .font(LubaTypography.body)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text(isUploading ? "Uploading..." : "2.4 MB")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()

                            if isUploading {
                                LubaSpinner(size: 20)
                            } else {
                                LubaIconButton("xmark") { }
                            }
                        }

                        if isUploading {
                            LubaProgressBar(value: uploadProgress, showLabel: true)
                        }

                        if !isUploading {
                            LubaButton("Start Upload", style: .primary, fullWidth: true) {
                                startUpload()
                            }
                        }
                    }
                }
            }

            // Real-World: Download List
            DemoSection(title: "Download List Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: 0) {
                        downloadRow(name: "LubaUI.zip", size: "12.5 MB", progress: 1.0, status: .complete)
                        LubaDivider()
                        downloadRow(name: "Assets.zip", size: "8.2 MB", progress: 0.67, status: .downloading)
                        LubaDivider()
                        downloadRow(name: "Fonts.zip", size: "3.1 MB", progress: 0.0, status: .pending)
                    }
                }
            }

            // Real-World: Loading State
            DemoSection(title: "Loading State Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaSpinner(size: 32, style: .arc)

                        Text("Loading your data...")
                            .font(LubaTypography.body)
                            .foregroundStyle(LubaColors.textSecondary)

                        Text("This may take a moment")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LubaSpacing.lg)
                }
            }
        }
    }

    // MARK: - Components

    private func spinnerDemo(_ style: LubaSpinnerStyle, _ name: String) -> some View {
        VStack(spacing: LubaSpacing.sm) {
            LubaSpinner(size: 28, style: style)
                .frame(height: 36)
            Text(name)
                .font(LubaTypography.caption)
                .foregroundStyle(LubaColors.textTertiary)
        }
    }

    enum DownloadStatus {
        case pending, downloading, complete
    }

    private func downloadRow(name: String, size: String, progress: Double, status: DownloadStatus) -> some View {
        HStack(spacing: LubaSpacing.md) {
            LubaCircledIcon(
                status == .complete ? "checkmark" : "doc.fill",
                size: .sm,
                style: status == .complete ? .filled : .subtle
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)

                if status == .downloading {
                    LubaProgressBar(value: progress)
                } else {
                    Text(status == .complete ? "Complete" : size)
                        .font(LubaTypography.caption)
                        .foregroundStyle(status == .complete ? LubaColors.success : LubaColors.textSecondary)
                }
            }

            Spacer()

            if status == .downloading {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(LubaColors.textSecondary)
            }
        }
        .padding(.vertical, LubaSpacing.sm)
    }

    private func startUpload() {
        isUploading = true
        uploadProgress = 0

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            uploadProgress += 0.05
            if uploadProgress >= 1.0 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isUploading = false
                    uploadProgress = 0
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        ProgressScreen()
    }
}
