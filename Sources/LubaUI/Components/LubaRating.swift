//
//  LubaRating.swift
//  LubaUI
//
//  A star rating component for reviews and feedback.
//
//  Design Decisions:
//  - 5-star system (industry standard)
//  - 28pt star size for comfortable tapping
//  - Accent fill color for selected stars
//  - Haptic on each star tap
//  - Read-only mode for display
//

import SwiftUI

// MARK: - LubaRating

/// A star-based rating control.
///
/// ```swift
/// LubaRating(value: $rating)
/// LubaRating(value: .constant(4), maxStars: 5, isReadOnly: true)
/// ```
public struct LubaRating: View {
    @Binding private var value: Int
    private let maxStars: Int
    private let isReadOnly: Bool
    private let label: String?

    @Environment(\.lubaConfig) private var config

    public init(
        value: Binding<Int>,
        maxStars: Int = 5,
        isReadOnly: Bool = false,
        label: String? = nil
    ) {
        self._value = value
        self.maxStars = maxStars
        self.isReadOnly = isReadOnly
        self.label = label
    }

    public var body: some View {
        HStack(spacing: LubaSpacing.md) {
            if let label = label {
                Text(label)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.textPrimary)

                Spacer()
            }

            HStack(spacing: 4) {
                ForEach(1...maxStars, id: \.self) { star in
                    starView(for: star)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Rating")
        .accessibilityValue("\(value) of \(maxStars) stars")
        .accessibilityAdjustableAction { direction in
            guard !isReadOnly else { return }
            switch direction {
            case .increment:
                if value < maxStars { setRating(value + 1) }
            case .decrement:
                if value > 0 { setRating(value - 1) }
            @unknown default: break
            }
        }
    }

    // MARK: - Subviews

    private func starView(for star: Int) -> some View {
        Image(systemName: star <= value ? "star.fill" : "star")
            .font(.system(size: 28))
            .foregroundStyle(star <= value ? LubaColors.accent : LubaColors.gray200)
            .frame(width: 36, height: 36)
            .contentShape(Rectangle())
            .onTapGesture {
                guard !isReadOnly else { return }
                setRating(star == value ? 0 : star)
            }
    }

    // MARK: - Logic

    private func setRating(_ newValue: Int) {
        let clamped = max(0, min(newValue, maxStars))
        guard clamped != value else { return }
        withAnimation(LubaMotion.micro) {
            value = clamped
        }
        if config.hapticsEnabled { LubaHaptics.light() }
    }
}

// MARK: - Preview

#Preview("Rating") {
    VStack(spacing: 24) {
        LubaRating(value: .constant(3), label: "Your rating")
        LubaRating(value: .constant(4), isReadOnly: true, label: "Average")
        LubaRating(value: .constant(0))
    }
    .padding(20)
    .background(LubaColors.background)
}
