//
//  LubaShimmerable.swift
//  LubaUI
//
//  Reusable shimmer loading primitive.
//  Apply a loading shimmer effect to any view — not just skeletons.
//
//  Usage:
//  ```swift
//  // Shimmer any view while loading
//  Image("hero")
//      .lubaShimmerable(isLoading: isLoading)
//
//  // Custom shimmer appearance
//  Text("Loading...")
//      .lubaShimmerable(isLoading: true, intensity: 0.8)
//  ```
//

import SwiftUI

// MARK: - Shimmer Tokens

/// Configuration for shimmer animation.
public enum LubaShimmerTokens {
    /// Duration of one shimmer cycle
    public static let duration: Double = 1.5

    /// Starting position (relative to width)
    public static let startOffset: CGFloat = -1.0

    /// Ending position (relative to width)
    public static let endOffset: CGFloat = 2.0

    /// Default shimmer opacity
    public static let defaultIntensity: CGFloat = 0.6

    /// Width of shimmer gradient (relative to view width)
    public static let gradientWidth: CGFloat = 0.4
}

// MARK: - Shimmerable Modifier

/// Applies a shimmer loading effect over any view.
public struct LubaShimmerableModifier: ViewModifier {
    let isLoading: Bool
    let intensity: CGFloat

    @State private var shimmerOffset: CGFloat = LubaShimmerTokens.startOffset
    @Environment(\.lubaConfig) private var config

    public init(isLoading: Bool, intensity: CGFloat = LubaShimmerTokens.defaultIntensity) {
        self.isLoading = isLoading
        self.intensity = intensity
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isLoading {
                        GeometryReader { geo in
                            shimmerGradient
                                .frame(width: geo.size.width * LubaShimmerTokens.gradientWidth)
                                .offset(x: shimmerOffset * geo.size.width)
                        }
                        .clipped()
                    }
                }
            )
            .onChange(of: isLoading) { newValue in
                if newValue {
                    startShimmer()
                } else {
                    shimmerOffset = LubaShimmerTokens.startOffset
                }
            }
            .onAppear {
                if isLoading {
                    startShimmer()
                }
            }
    }

    private var shimmerGradient: some View {
        LinearGradient(
            colors: [
                Color.clear,
                Color.white.opacity(intensity),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private func startShimmer() {
        guard config.animationsEnabled else { return }
        shimmerOffset = LubaShimmerTokens.startOffset
        withAnimation(.linear(duration: LubaShimmerTokens.duration).repeatForever(autoreverses: false)) {
            shimmerOffset = LubaShimmerTokens.endOffset
        }
    }
}

// MARK: - Redacted Shimmer Modifier

/// Applies shimmer while also redacting the content (like a placeholder).
public struct LubaRedactedShimmerModifier: ViewModifier {
    let isLoading: Bool
    let intensity: CGFloat

    @State private var shimmerOffset: CGFloat = LubaShimmerTokens.startOffset
    @Environment(\.lubaConfig) private var config

    public init(isLoading: Bool, intensity: CGFloat = LubaShimmerTokens.defaultIntensity) {
        self.isLoading = isLoading
        self.intensity = intensity
    }

    public func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .overlay(
                Group {
                    if isLoading {
                        GeometryReader { geo in
                            shimmerGradient
                                .frame(width: geo.size.width * LubaShimmerTokens.gradientWidth)
                                .offset(x: shimmerOffset * geo.size.width)
                        }
                        .clipped()
                    }
                }
            )
            .onChange(of: isLoading) { newValue in
                if newValue {
                    startShimmer()
                } else {
                    shimmerOffset = LubaShimmerTokens.startOffset
                }
            }
            .onAppear {
                if isLoading {
                    startShimmer()
                }
            }
    }

    private var shimmerGradient: some View {
        LinearGradient(
            colors: [
                Color.clear,
                Color.white.opacity(intensity),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private func startShimmer() {
        guard config.animationsEnabled else { return }
        shimmerOffset = LubaShimmerTokens.startOffset
        withAnimation(.linear(duration: LubaShimmerTokens.duration).repeatForever(autoreverses: false)) {
            shimmerOffset = LubaShimmerTokens.endOffset
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Apply a shimmer loading effect over this view.
    ///
    /// The shimmer is a traveling highlight that indicates loading.
    /// Unlike skeleton loaders, this keeps your actual content visible
    /// with the shimmer overlay — great for progressive loading.
    ///
    /// - Parameters:
    ///   - isLoading: Whether to show the shimmer
    ///   - intensity: Opacity of the shimmer highlight (0-1)
    func lubaShimmerable(
        isLoading: Bool,
        intensity: CGFloat = LubaShimmerTokens.defaultIntensity
    ) -> some View {
        modifier(LubaShimmerableModifier(isLoading: isLoading, intensity: intensity))
    }

    /// Apply a shimmer with SwiftUI's redacted placeholder effect.
    ///
    /// This combines the shimmer with content redaction, fully obscuring
    /// the content while loading — perfect for privacy-sensitive data.
    ///
    /// - Parameters:
    ///   - isLoading: Whether to show the shimmer and redaction
    ///   - intensity: Opacity of the shimmer highlight (0-1)
    func lubaRedactedShimmer(
        isLoading: Bool,
        intensity: CGFloat = LubaShimmerTokens.defaultIntensity
    ) -> some View {
        modifier(LubaRedactedShimmerModifier(isLoading: isLoading, intensity: intensity))
    }
}

// MARK: - Preview

#Preview("Shimmerable") {
    struct PreviewWrapper: View {
        @State private var isLoading = true

        var body: some View {
            VStack(spacing: 24) {
                // Toggle
                Toggle("Loading", isOn: $isLoading)
                    .padding(.horizontal)

                // Image with shimmer overlay
                RoundedRectangle(cornerRadius: 12)
                    .fill(LubaColors.gray200)
                    .frame(height: 150)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(LubaColors.gray400)
                    )
                    .lubaShimmerable(isLoading: isLoading)

                // Text with redacted shimmer
                VStack(alignment: .leading, spacing: 8) {
                    Text("Article Title Here")
                        .font(.headline)
                    Text("This is a description that will be redacted while loading.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .lubaRedactedShimmer(isLoading: isLoading)

                // Card with shimmer
                HStack(spacing: 12) {
                    Circle()
                        .fill(LubaColors.gray200)
                        .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("User Name")
                            .font(.headline)
                        Text("Status message")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(LubaColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .lubaShimmerable(isLoading: isLoading, intensity: 0.4)

                Spacer()
            }
            .padding()
            .background(LubaColors.background)
        }
    }

    return PreviewWrapper()
}
