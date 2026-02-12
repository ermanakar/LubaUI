//
//  RatingScreen.swift
//  LubaUIShowcase
//
//  Showcasing LubaRating star controls.
//

import SwiftUI
import LubaUI

struct RatingScreen: View {
    @State private var rating = 3
    @State private var feedback = 0

    var body: some View {
        ShowcaseScreen("Rating") {
            ShowcaseHeader(
                title: "Rating",
                description: "Star-based input for reviews, feedback, and scoring. Tap to set, tap again to clear."
            )

            // Interactive
            DemoSection(title: "Interactive") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaRating(value: $rating, label: "Your rating")

                        LubaDivider()

                        Text(ratingLabel)
                            .font(LubaTypography.bodySmall)
                            .foregroundStyle(LubaColors.textSecondary)
                    }
                }
            }

            // Read Only
            DemoSection(title: "Read Only") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaRating(value: .constant(5), isReadOnly: true, label: "Excellent")
                        LubaRating(value: .constant(3), isReadOnly: true, label: "Average")
                        LubaRating(value: .constant(1), isReadOnly: true, label: "Poor")
                    }
                }
            }

            // Feedback Form
            DemoSection(title: "Feedback Form") {
                LubaCard(elevation: .low) {
                    VStack(alignment: .leading, spacing: LubaSpacing.md) {
                        Text("How was your experience?")
                            .font(LubaTypography.headline)
                            .foregroundStyle(LubaColors.textPrimary)

                        LubaRating(value: $feedback)

                        if feedback > 0 {
                            LubaButton("Submit Feedback", style: .primary, size: .small) { }
                        }
                    }
                }
            }

            // Usage
            DemoSection(title: "Usage") {
                VStack(spacing: LubaSpacing.sm) {
                    CopyableCode(code: "LubaRating(value: $rating)")
                    CopyableCode(code: "LubaRating(value: $rating, label: \"Score\")")
                    CopyableCode(code: "LubaRating(value: .constant(4), isReadOnly: true)")
                }
            }

            PhilosophyCard(
                icon: "star",
                title: "Universal Language",
                description: "Stars are instantly understood. No labels needed, no instructions required. Five stars tell the whole story."
            )
        }
    }

    private var ratingLabel: String {
        switch rating {
        case 0: return "Tap a star to rate"
        case 1: return "Poor"
        case 2: return "Fair"
        case 3: return "Good"
        case 4: return "Great"
        case 5: return "Excellent"
        default: return ""
        }
    }
}

#Preview {
    NavigationStack {
        RatingScreen()
    }
}
