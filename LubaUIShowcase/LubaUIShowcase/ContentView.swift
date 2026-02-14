//
//  ContentView.swift
//  LubaUIShowcase
//
//  The design system that feels alive.
//

import SwiftUI
import LubaUI

// MARK: - Navigation Data

enum ShowcaseSection: String, CaseIterable {
    case primitives = "Primitives"
    case foundation = "Foundation"
    case components = "Components"
    case patterns = "Patterns"

    var icon: String {
        switch self {
        case .primitives: return "atom"
        case .foundation: return "paintpalette"
        case .components: return "square.stack.3d.up"
        case .patterns: return "rectangle.3.group"
        }
    }

    var subtitle: String {
        switch self {
        case .primitives: return "The DNA — composable behaviors"
        case .foundation: return "Design tokens"
        case .components: return "UI building blocks"
        case .patterns: return "Common layouts"
        }
    }

    var items: [ShowcaseItem] {
        switch self {
        case .primitives:
            return [
                ShowcaseItem(icon: "hand.tap.fill", title: "Pressable", description: "Make any view tappable", destination: AnyView(PressableScreen())),
                ShowcaseItem(icon: "hand.tap", title: "Long Pressable", description: "Long press with progress", destination: AnyView(LongPressableScreen())),
                ShowcaseItem(icon: "sparkles", title: "Shimmerable", description: "Loading shimmer on any view", destination: AnyView(ShimmerableScreen())),
                ShowcaseItem(icon: "hand.draw.fill", title: "Swipeable", description: "Swipe actions for any row", destination: AnyView(SwipeableScreen())),
                ShowcaseItem(icon: "rectangle.expand.vertical", title: "Expandable", description: "Expand/collapse any content", destination: AnyView(ExpandableScreen())),
                ShowcaseItem(icon: "paintbrush.pointed.fill", title: "Button Styling", description: "Protocol-based style system", destination: AnyView(ButtonStylingScreen())),
                ShowcaseItem(icon: "cube.transparent", title: "Glass", description: "Frosted glass effects", destination: AnyView(GlassScreen())),
                ShowcaseItem(icon: "wand.and.stars", title: "Motion", description: "Animation tokens & feel", destination: AnyView(MotionScreen())),
                ShowcaseItem(icon: "puzzlepiece.extension", title: "Composability", description: "Modifiers over inheritance", destination: AnyView(ComposabilityScreen()))
            ]
        case .foundation:
            return [
                ShowcaseItem(icon: "book.closed", title: "Getting Started", description: "Quick-start guide & philosophy", destination: AnyView(GettingStartedScreen())),
                ShowcaseItem(icon: "circle.lefthalf.filled", title: "Colors", description: "Greyscale palette with sage accent", destination: AnyView(ColorsScreen())),
                ShowcaseItem(icon: "textformat", title: "Typography", description: "SF Rounded type scale", destination: AnyView(TypographyScreen())),
                ShowcaseItem(icon: "square.split.2x2", title: "Spacing", description: "4pt grid system", destination: AnyView(SpacingScreen())),
                ShowcaseItem(icon: "square.on.circle", title: "Radius", description: "Continuous corner radius tokens", destination: AnyView(RadiusScreen())),
                ShowcaseItem(icon: "paintpalette", title: "Theme", description: "Colors, typography & spacing themes", destination: AnyView(ThemeScreen())),
                ShowcaseItem(icon: "bolt.fill", title: "Animations", description: "Spring & eased motion presets", destination: AnyView(AnimationsScreen())),
                ShowcaseItem(icon: "accessibility", title: "Accessibility", description: "WCAG contrast & VoiceOver", destination: AnyView(AccessibilityScreen())),
                ShowcaseItem(icon: "moon.stars", title: "Dark Mode", description: "Adaptive tokens in action", destination: AnyView(DarkModeScreen())),
                ShowcaseItem(icon: "gearshape", title: "Configuration", description: "Presets, haptics & accessibility", destination: AnyView(ConfigScreen()))
            ]
        case .components:
            return [
                ShowcaseItem(icon: "hand.tap", title: "Buttons", description: "Primary, secondary, ghost, destructive", destination: AnyView(ButtonsScreen())),
                ShowcaseItem(icon: "rectangle.on.rectangle", title: "Cards", description: "Elevated, composable containers", destination: AnyView(CardsScreen())),
                ShowcaseItem(icon: "character.cursor.ibeam", title: "Text Fields", description: "Inputs with validation", destination: AnyView(TextFieldsScreen())),
                ShowcaseItem(icon: "star.circle", title: "Icons", description: "SF Symbols wrapper", destination: AnyView(IconsScreen())),
                ShowcaseItem(icon: "rectangle.dashed", title: "Skeleton", description: "Loading placeholders", destination: AnyView(SkeletonScreen())),
                ShowcaseItem(icon: "chart.bar.fill", title: "Progress", description: "Bars, circles, spinners", destination: AnyView(ProgressScreen())),
                ShowcaseItem(icon: "bubble.left.fill", title: "Toast", description: "Notification messages", destination: AnyView(ToastScreen())),
                ShowcaseItem(icon: "rectangle.split.3x1", title: "Tabs", description: "Segmented & underline", destination: AnyView(TabsScreen())),
                ShowcaseItem(icon: "minus", title: "Divider", description: "Visual separation with labels", destination: AnyView(DividerScreen())),
                ShowcaseItem(icon: "rectangle.bottomhalf.inset.filled", title: "Sheet", description: "Bottom sheets and modals", destination: AnyView(SheetScreen())),
                ShowcaseItem(icon: "exclamationmark.bubble", title: "Alert", description: "Inline notification banners", destination: AnyView(AlertScreen())),
                ShowcaseItem(icon: "magnifyingglass", title: "Search Bar", description: "Search input with clear & cancel", destination: AnyView(SearchBarScreen())),
                ShowcaseItem(icon: "list.bullet", title: "Menu", description: "Contextual action menus", destination: AnyView(MenuScreen())),
                ShowcaseItem(icon: "tag", title: "Chip", description: "Dismissible filter tags", destination: AnyView(ChipScreen())),
                ShowcaseItem(icon: "text.bubble", title: "Tooltip", description: "Contextual help on tap", destination: AnyView(TooltipScreen())),
                ShowcaseItem(icon: "plusminus", title: "Stepper", description: "Numeric increment/decrement", destination: AnyView(StepperScreen())),
                ShowcaseItem(icon: "star", title: "Rating", description: "Star-based input for reviews", destination: AnyView(RatingScreen())),
                ShowcaseItem(icon: "text.alignleft", title: "Text Area", description: "Multi-line text input", destination: AnyView(TextAreaScreen())),
                ShowcaseItem(icon: "link", title: "Link", description: "Inline text links", destination: AnyView(LinkScreen())),
                ShowcaseItem(icon: "switch.2", title: "Toggle", description: "Binary on/off switch", destination: AnyView(ToggleScreen())),
                ShowcaseItem(icon: "checkmark.square", title: "Checkbox", description: "Multi-select controls", destination: AnyView(CheckboxScreen())),
                ShowcaseItem(icon: "circle.inset.filled", title: "Radio", description: "Exclusive selection groups", destination: AnyView(RadioScreen())),
                ShowcaseItem(icon: "slider.horizontal.3", title: "Slider", description: "Continuous & stepped range input", destination: AnyView(SliderScreen()))
            ]
        case .patterns:
            return [
                ShowcaseItem(icon: "person.crop.square", title: "Avatars", description: "User profile images", destination: AnyView(AvatarsScreen())),
                ShowcaseItem(icon: "tag", title: "Badges", description: "Status indicators", destination: AnyView(BadgesScreen())),
                ShowcaseItem(icon: "checklist", title: "Form Controls", description: "Toggle, checkbox, radio, slider", destination: AnyView(FormControlsScreen())),
                ShowcaseItem(icon: "tray", title: "Empty States", description: "Onboarding, errors & permissions", destination: AnyView(EmptyStatesScreen())),
                ShowcaseItem(icon: "hourglass", title: "Loading Patterns", description: "Skeletons, progress & spinners", destination: AnyView(LoadingPatternsScreen())),
                ShowcaseItem(icon: "doc.text", title: "Form Patterns", description: "Signup, settings & payment flows", destination: AnyView(FormPatternsScreen()))
            ]
        }
    }
}

struct ShowcaseItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let destination: AnyView
}

// MARK: - ContentView

struct ContentView: View {
    @State private var searchText = ""
    @State private var isDarkMode = false
    @Environment(\.colorScheme) private var systemColorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    heroSection
                        .padding(.bottom, LubaSpacing.xl)

                    searchBar
                        .padding(.horizontal, LubaSpacing.lg)
                        .padding(.bottom, LubaSpacing.lg)

                    if searchText.isEmpty {
                        sectionsView
                    } else {
                        searchResultsView
                    }
                }
            }
            .background(LubaColors.background)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .onAppear {
            isDarkMode = systemColorScheme == .dark
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: LubaSpacing.lg) {
            ZStack {
                Circle()
                    .fill(LubaColors.accentSubtle)
                    .frame(width: 72, height: 72)

                Image(systemName: isDarkMode ? "moon.fill" : "leaf.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(LubaColors.accent)
            }
            .lubaPressable(scale: LubaMotion.pressScaleCompact, haptic: .medium) {
                withAnimation(LubaMotion.stateAnimation) {
                    isDarkMode.toggle()
                }
            }

            VStack(spacing: LubaSpacing.xs) {
                Text("LubaUI")
                    .font(LubaTypography.title)
                    .foregroundStyle(LubaColors.textPrimary)

                Text("The design system that feels alive")
                    .font(LubaTypography.subheadline)
                    .foregroundStyle(LubaColors.textSecondary)
            }

            HStack(spacing: LubaSpacing.xs) {
                Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                    .font(LubaTypography.caption2)
                Text(isDarkMode ? "Dark Mode" : "Light Mode")
            }
            .font(LubaTypography.caption2)
            .foregroundStyle(LubaColors.textTertiary)
            .padding(.horizontal, LubaSpacing.md)
            .padding(.vertical, LubaSpacing.xs)
            .background(LubaColors.gray100)
            .clipShape(Capsule())

            Text("Radically composable · AI-native · Low-friction")
                .font(LubaTypography.caption2)
                .foregroundStyle(LubaColors.textTertiary)
                .padding(.horizontal, LubaSpacing.md)
                .padding(.vertical, LubaSpacing.xs)
                .background(LubaColors.surfaceSecondary)
                .clipShape(Capsule())
        }
        .padding(.top, LubaSpacing.xxl)
    }

    // MARK: - Search

    private var searchBar: some View {
        LubaSearchBar(
            text: $searchText,
            placeholder: "Search components...",
            showCancelButton: false
        )
    }

    // MARK: - Sections

    private var sectionsView: some View {
        VStack(spacing: LubaSpacing.xl) {
            ForEach(ShowcaseSection.allCases, id: \.rawValue) { section in
                sectionBlock(for: section)
            }
        }
        .padding(.horizontal, LubaSpacing.lg)
        .padding(.bottom, LubaSpacing.xxxl)
    }

    private func sectionBlock(for section: ShowcaseSection) -> some View {
        NavigationLink(destination: SectionListView(section: section)) {
            HStack(spacing: LubaSpacing.md) {
                ZStack {
                    RoundedRectangle.luba(LubaRadius.sm)
                        .fill(LubaColors.accentSubtle)
                        .frame(width: 48, height: 48)

                    Image(systemName: section.icon)
                        .font(LubaTypography.title2)
                        .foregroundStyle(LubaColors.accent)
                }

                VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                    Text(section.rawValue)
                        .font(LubaTypography.title3)
                        .foregroundStyle(LubaColors.textPrimary)

                    Text(section.subtitle)
                        .font(LubaTypography.footnote)
                        .foregroundStyle(LubaColors.textSecondary)
                }

                Spacer()

                Text("\(section.items.count)")
                    .font(LubaTypography.buttonSmall)
                    .foregroundStyle(LubaColors.textTertiary)
                    .padding(.horizontal, LubaSpacing.sm)
                    .padding(.vertical, LubaSpacing.xs)
                    .background(LubaColors.gray100)
                    .clipShape(Capsule())

                Image(systemName: "chevron.right")
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textTertiary)
            }
            .padding(LubaSpacing.lg)
            .background(LubaColors.surface)
            .lubaCornerRadius(LubaRadius.md)
            .overlay(
                RoundedRectangle.luba(LubaRadius.md)
                    .strokeBorder(LubaColors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Search Results

    private var searchResultsView: some View {
        let filtered = allItems.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }

        return VStack(spacing: LubaSpacing.sm) {
            if filtered.isEmpty {
                VStack(spacing: LubaSpacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundStyle(LubaColors.textTertiary)

                    Text("No results found")
                        .font(LubaTypography.bodySmall)
                        .foregroundStyle(LubaColors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, LubaSpacing.huge)
            } else {
                ForEach(filtered) { item in
                    NavigationLink(destination: item.destination) {
                        ComponentRow(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, LubaSpacing.lg)
    }

    // MARK: - Data

    private var allItems: [ShowcaseItem] {
        ShowcaseSection.allCases.flatMap(\.items)
    }
}

// MARK: - Section List View

struct SectionListView: View {
    let section: ShowcaseSection

    var body: some View {
        ScrollView {
            VStack(spacing: LubaSpacing.sm) {
                ForEach(section.items) { item in
                    NavigationLink(destination: item.destination) {
                        ComponentRow(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(LubaSpacing.lg)
        }
        .background(LubaColors.background)
        .navigationTitle(section.rawValue)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Component Row

struct ComponentRow: View {
    let item: ShowcaseItem

    var body: some View {
        HStack(spacing: LubaSpacing.md) {
            ZStack {
                RoundedRectangle.luba(LubaRadius.sm)
                    .fill(LubaColors.gray100)
                    .frame(width: 40, height: 40)

                Image(systemName: item.icon)
                    .font(LubaTypography.body)
                    .foregroundStyle(LubaColors.accent)
            }

            VStack(alignment: .leading, spacing: LubaSpacing.xs) {
                Text(item.title)
                    .font(LubaTypography.button)
                    .foregroundStyle(LubaColors.textPrimary)

                Text(item.description)
                    .font(LubaTypography.caption)
                    .foregroundStyle(LubaColors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(LubaTypography.caption2)
                .foregroundStyle(LubaColors.textTertiary)
        }
        .padding(LubaSpacing.md)
        .background(LubaColors.surface)
        .lubaCornerRadius(LubaRadius.md)
        .overlay(
            RoundedRectangle.luba(LubaRadius.md)
                .strokeBorder(LubaColors.border, lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
