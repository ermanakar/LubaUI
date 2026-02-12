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

public enum LubaSheetSize {
    case small      // ~25% of screen
    case medium     // ~50% of screen
    case large      // ~75% of screen
    case full       // Full screen
    
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

public struct LubaSheetHeader: View {
    private let title: String
    private let subtitle: String?
    private let onClose: () -> Void

    @Environment(\.lubaConfig) private var config

    public init(
        _ title: String,
        subtitle: String? = nil,
        onClose: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onClose = onClose
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: LubaSheetTokens.titleSpacing) {
                Text(title)
                    .font(.system(size: LubaSheetTokens.titleFontSize, weight: .semibold, design: .rounded))
                    .foregroundStyle(LubaColors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: LubaSheetTokens.subtitleFontSize, design: .rounded))
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
        .background(LubaColors.surface)
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
