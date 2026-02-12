//
//  LubaDivider.swift
//  LubaUI
//
//  A refined divider for visual separation.
//
//  Design Decisions:
//  - Horizontal line: 1px height
//  - Vertical line: 1px width
//  - Label spacing: 12pt
//  - Label font: 12pt, secondary color
//

import SwiftUI

// MARK: - LubaDivider

public struct LubaDivider: View {
    private let label: String?
    private let orientation: Orientation
    
    public enum Orientation {
        case horizontal
        case vertical
    }
    
    public init(
        label: String? = nil,
        orientation: Orientation = .horizontal
    ) {
        self.label = label
        self.orientation = orientation
    }
    
    public var body: some View {
        Group {
            switch orientation {
            case .horizontal:
                horizontalDivider
            case .vertical:
                verticalDivider
            }
        }
        .accessibilityHidden(label == nil)
        .accessibilityLabel(label ?? "")
    }
    
    private var horizontalDivider: some View {
        HStack(spacing: 12) {
            if let label = label {
                line
                
                Text(label)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(LubaColors.textTertiary)
                
                line
            } else {
                line
            }
        }
    }
    
    private var verticalDivider: some View {
        Rectangle()
            .fill(LubaColors.border)
            .frame(width: 1)
    }
    
    private var line: some View {
        Rectangle()
            .fill(LubaColors.border)
            .frame(height: 1)
    }
}

// MARK: - Preview

#Preview("Divider") {
    VStack(spacing: 24) {
        LubaDivider()
        
        LubaDivider(label: "or continue with")
        
        HStack(spacing: 16) {
            Text("Left")
                .foregroundStyle(LubaColors.textSecondary)
            LubaDivider(orientation: .vertical)
                .frame(height: 24)
            Text("Right")
                .foregroundStyle(LubaColors.textSecondary)
        }
    }
    .padding(20)
    .background(LubaColors.background)
}
