//
//  TextFieldsScreen.swift
//  LubaUIShowcase
//
//  Text fields showcase with all states, icons, and real-world examples.
//

import SwiftUI
import LubaUI

struct TextFieldsScreen: View {
    @State private var basicText = ""
    @State private var email = ""
    @State private var password = ""
    @State private var username = "taken_user"
    @State private var bio = ""
    @State private var searchQuery = ""
    @State private var amount = ""

    var body: some View {
        ShowcaseScreen("Text Fields") {
            ShowcaseHeader(
                title: "Text Fields",
                description: "Clean, minimal inputs with validation states, icons, and helper text support."
            )

            // Basic
            DemoSection(title: "Basic") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaTextField(
                            "Label",
                            text: $basicText,
                            placeholder: "Enter text..."
                        )

                        Text("Simple text field with label and placeholder")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // With Icons
            DemoSection(title: "With Icons") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaTextField(
                            "Email",
                            text: $email,
                            placeholder: "you@example.com",
                            leadingIcon: Image(systemName: "envelope")
                        )

                        LubaTextField(
                            "Password",
                            text: $password,
                            placeholder: "Enter password",
                            leadingIcon: Image(systemName: "lock"),
                            trailingIcon: Image(systemName: "eye.slash"),
                            isSecure: true
                        )

                        LubaTextField(
                            "Search",
                            text: $searchQuery,
                            placeholder: "Search...",
                            leadingIcon: Image(systemName: "magnifyingglass")
                        )
                    }
                }
            }

            // Validation States
            DemoSection(title: "Validation States") {
                LubaCard(elevation: .flat, style: .outlined) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaTextField(
                            "Username",
                            text: $username,
                            error: "This username is already taken",
                            leadingIcon: Image(systemName: "person")
                        )

                        LubaTextField(
                            "Bio",
                            text: $bio,
                            placeholder: "Tell us about yourself...",
                            helperText: "Max 200 characters"
                        )

                        LubaTextField(
                            "Amount",
                            text: $amount,
                            placeholder: "0.00",
                            helperText: "Enter amount in USD",
                            leadingIcon: Image(systemName: "dollarsign.circle")
                        )
                    }
                }
            }

            // Disabled State
            DemoSection(title: "Disabled") {
                LubaCard(elevation: .flat, style: .outlined) {
                    LubaTextField(
                        "Disabled Field",
                        text: .constant("Cannot edit this"),
                        isDisabled: true
                    )
                }
            }

            // Real-World: Login Form
            DemoSection(title: "Login Form Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        LubaTextField(
                            "Email",
                            text: $email,
                            placeholder: "you@example.com",
                            leadingIcon: Image(systemName: "envelope")
                        )

                        LubaTextField(
                            "Password",
                            text: $password,
                            placeholder: "••••••••",
                            leadingIcon: Image(systemName: "lock"),
                            isSecure: true
                        )

                        LubaButton("Sign In", style: .primary, fullWidth: true) { }

                        HStack {
                            Text("Forgot password?")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.accent)

                            Spacer()

                            Text("Create account")
                                .font(LubaTypography.caption)
                                .foregroundStyle(LubaColors.accent)
                        }
                    }
                }
            }

            // Real-World: Search Bar
            DemoSection(title: "Search Bar Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.md) {
                        LubaTextField(
                            "Search",
                            text: $searchQuery,
                            placeholder: "Search products...",
                            leadingIcon: Image(systemName: "magnifyingglass")
                        )

                        HStack(spacing: LubaSpacing.sm) {
                            LubaBadge("Electronics", style: .subtle, size: .small)
                            LubaBadge("Clothing", style: .subtle, size: .small)
                            LubaBadge("Books", style: .subtle, size: .small)
                        }

                        Text("Recent searches")
                            .font(LubaTypography.caption)
                            .foregroundStyle(LubaColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // Real-World: Profile Edit
            DemoSection(title: "Profile Edit Example") {
                LubaCard(elevation: .low) {
                    VStack(spacing: LubaSpacing.lg) {
                        HStack(spacing: LubaSpacing.md) {
                            LubaAvatar(name: "User Name", size: .large)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Profile Photo")
                                    .font(LubaTypography.headline)
                                    .foregroundStyle(LubaColors.textPrimary)
                                Text("JPG, PNG up to 5MB")
                                    .font(LubaTypography.caption)
                                    .foregroundStyle(LubaColors.textSecondary)
                            }

                            Spacer()

                            LubaButton("Change", style: .secondary, size: .small) { }
                        }

                        LubaDivider()

                        LubaTextField(
                            "Display Name",
                            text: $basicText,
                            placeholder: "Your name",
                            leadingIcon: Image(systemName: "person")
                        )

                        LubaTextField(
                            "Email",
                            text: $email,
                            placeholder: "you@example.com",
                            leadingIcon: Image(systemName: "envelope")
                        )

                        LubaTextField(
                            "Bio",
                            text: $bio,
                            placeholder: "A short bio...",
                            helperText: "Displayed on your public profile"
                        )

                        LubaButton("Save Changes", style: .primary, fullWidth: true) { }
                    }
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        TextFieldsScreen()
    }
}
