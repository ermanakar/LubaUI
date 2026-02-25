//
//  LubaSheet.swift
//  LubaUI
//
//  A refined bottom sheet / modal component.
//
//  Architecture:
//  - Uses LubaSheetTokens for all dimensions
//  - Reads LubaConfig for haptics
//

import SwiftUI

// MARK: - Sheet Size

/// Presentation height for a bottom sheet.
///
/// Each size maps to a SwiftUI `PresentationDetent`:
/// - ``small``: ~25% of the screen
/// - ``medium``: ~50% of the screen
/// - ``large``: ~75% of the screen
/// - ``full``: Full screen
public enum LubaSheetSize {
    /// Approximately 25% of the screen height.
    case small
    /// Approximately 50% of the screen height.
    case medium
    /// Approximately 75% of the screen height.
    case large
    /// Full screen height.
    case full
    
    var detent: PresentationDetent {
        switch self {
        case .small: return .fraction(0.25)
        case .medium: return .medium
        case .large: return .fraction(0.75)
        case .full: return .large
        }
    }
}

// MARK: - Sheet Modifier

/// A view modifier that presents content in a bottom sheet.
///
/// Use the convenience method `.lubaSheet()` instead of applying this modifier directly:
///
/// ```swift
/// Button("Show Sheet") { showSheet = true }
///     .lubaSheet(isPresented: $showSheet, size: .medium) {
///         SettingsView()
///     }
/// ```
public struct LubaSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let size: LubaSheetSize
    let showDragIndicator: Bool
    let sheetContent: () -> SheetContent
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent()
                    .presentationDetents([size.detent])
                    .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
            }
    }
}

public extension View {
    /// Present a bottom sheet with configurable size and drag indicator.
    ///
    /// - Parameters:
    ///   - isPresented: Binding that controls sheet visibility.
    ///   - size: The sheet's presentation height.
    ///   - showDragIndicator: Whether to show the drag handle at the top.
    ///   - content: The sheet's content.
    func lubaSheet<Content: View>(
        isPresented: Binding<Bool>,
        size: LubaSheetSize = .medium,
        showDragIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(LubaSheetModifier(
            isPresented: isPresented,
            size: size,
            showDragIndicator: showDragIndicator,
            sheetContent: content
        ))
    }
}

// MARK: - Sheet Header

/// A standard header bar for sheets with title, optional subtitle, and close button.
///
/// ```swift
/// LubaSheetHeader("Settings", subtitle: "Customize your experience") {
///     dismiss()
/// }
/// ```
///
/// Set `useGlass: true` for a frosted glass background on the header.
public struct LubaSheetHeader: View {
    private let title: String
    private let subtitle: String?
    private let useGlass: Bool
    private let onClose: () -> Void

    @Environment(\.lubaConfig) private var config

    /// Creates a sheet header.
    ///
    /// - Parameters:
    ///   - title: The header title.
    ///   - subtitle: Optional secondary text below the title.
    ///   - useGlass: Whether to use a glass background instead of a solid surface.
    ///   - onClose: Action invoked when the close button is tapped.
    public init(
        _ title: String,
        subtitle: String? = nil,
        useGlass: Bool = false,
        onClose: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.useGlass = useGlass
        self.onClose = onClose
    }

    public var body: some View {
        let header = HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: LubaSheetTokens.titleSpacing) {
                Text(title)
                    .font(LubaTypography.custom(size: LubaSheetTokens.titleFontSize, weight: .semibold))
                    .foregroundStyle(LubaColors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(LubaTypography.footnote)
                        .foregroundStyle(LubaColors.textSecondary)
                }
            }

            Spacer()

            Button {
                if config.hapticsEnabled {
                    LubaHaptics.light()
                }
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: LubaSheetTokens.closeIconSize, weight: .bold))
                    .foregroundStyle(LubaColors.textSecondary)
                    .frame(width: LubaSheetTokens.closeButtonSize, height: LubaSheetTokens.closeButtonSize)
                    .background(LubaColors.gray100)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close")
            .accessibilityAddTraits(.isButton)
        }
        .padding(LubaSheetTokens.headerPadding)

        if useGlass {
            header.lubaGlass(.subtle)
        } else {
            header.background(LubaColors.surface)
        }
    }
}

// MARK: - Preview

#Preview("Sheet Header") {
    VStack(spacing: 0) {
        LubaSheetHeader("Settings", subtitle: "Customize your experience") {
            print("Close")
        }
        
        LubaDivider()
        
        Spacer()
    }
    .background(LubaColors.surface)
}
