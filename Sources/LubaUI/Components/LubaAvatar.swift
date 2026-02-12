//
//  LubaAvatar.swift
//  LubaUI
//
//  A refined avatar component for user profile images.
//
//  Design Decisions:
//  - Sizes: 32/40/56/80pt (refined scale)
//  - Border: 1.5pt when shown
//  - Initials font: 40% of avatar size
//  - AvatarGroup overlap: 25% of size
//

import SwiftUI

// MARK: - Avatar Size

public enum LubaAvatarSize {
    case small   // 32pt
    case medium  // 40pt
    case large   // 56pt
    case xlarge  // 80pt
    
    var dimension: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 40
        case .large: return 56
        case .xlarge: return 80
        }
    }
    
    var fontSize: CGFloat {
        return dimension * 0.4
    }
    
    var iconSize: CGFloat {
        return dimension * 0.45
    }
}

// MARK: - LubaAvatar

public struct LubaAvatar: View {
    private let image: Image?
    private let initials: String?
    private let size: LubaAvatarSize
    private let showBorder: Bool
    
    /// Create an avatar with an image
    public init(
        image: Image,
        size: LubaAvatarSize = .medium,
        showBorder: Bool = false
    ) {
        self.image = image
        self.initials = nil
        self.size = size
        self.showBorder = showBorder
    }
    
    /// Create an avatar with initials
    public init(
        initials: String,
        size: LubaAvatarSize = .medium,
        showBorder: Bool = false
    ) {
        self.image = nil
        self.initials = String(initials.prefix(2)).uppercased()
        self.size = size
        self.showBorder = showBorder
    }
    
    /// Create an avatar from a name (auto-generates initials)
    public init(
        name: String,
        size: LubaAvatarSize = .medium,
        showBorder: Bool = false
    ) {
        self.image = nil
        let components = name.components(separatedBy: " ")
        let firstInitial = components.first?.first.map(String.init) ?? ""
        let lastInitial = components.count > 1 ? components.last?.first.map(String.init) ?? "" : ""
        self.initials = (firstInitial + lastInitial).uppercased()
        self.size = size
        self.showBorder = showBorder
    }
    
    public var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let initials = initials {
                LubaColors.accentSubtle
                
                Text(initials)
                    .font(.system(size: size.fontSize, weight: .semibold, design: .rounded))
                    .foregroundStyle(LubaColors.accent)
            } else {
                LubaColors.gray100
                
                Image(systemName: "person.fill")
                    .font(.system(size: size.iconSize))
                    .foregroundStyle(LubaColors.textTertiary)
            }
        }
        .frame(width: size.dimension, height: size.dimension)
        .clipShape(Circle())
        .accessibilityLabel(initials.map { "Avatar, \($0)" } ?? "Avatar")
        .accessibilityAddTraits(.isImage)
        .overlay {
            if showBorder {
                Circle()
                    .strokeBorder(LubaColors.border, lineWidth: 1.5)
            }
        }
    }
}

// MARK: - Avatar Group

public struct LubaAvatarGroup: View {
    private let avatars: [LubaAvatar]
    private let maxVisible: Int
    private let size: LubaAvatarSize
    
    public init(
        avatars: [LubaAvatar],
        maxVisible: Int = 4,
        size: LubaAvatarSize = .small
    ) {
        self.avatars = avatars
        self.maxVisible = maxVisible
        self.size = size
    }
    
    public var body: some View {
        HStack(spacing: -size.dimension * 0.25) {
            ForEach(0..<min(avatars.count, maxVisible), id: \.self) { index in
                avatars[index]
                    .overlay(
                        Circle()
                            .strokeBorder(LubaColors.surface, lineWidth: 2)
                    )
            }
            
            if avatars.count > maxVisible {
                ZStack {
                    Circle()
                        .fill(LubaColors.gray200)
                    
                    Text("+\(avatars.count - maxVisible)")
                        .font(.system(size: size.fontSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(LubaColors.textSecondary)
                }
                .frame(width: size.dimension, height: size.dimension)
                .overlay(
                    Circle()
                        .strokeBorder(LubaColors.surface, lineWidth: 2)
                )
            }
        }
    }
}

// MARK: - Preview

#Preview("Avatar") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            LubaAvatar(initials: "S", size: .small)
            LubaAvatar(initials: "M", size: .medium)
            LubaAvatar(initials: "L", size: .large)
            LubaAvatar(initials: "XL", size: .xlarge)
        }
        
        HStack(spacing: 16) {
            LubaAvatar(name: "Erman Akar", size: .large)
            LubaAvatar(name: "Jane Doe", size: .large)
            LubaAvatar(initials: "LU", size: .large, showBorder: true)
        }
    }
    .padding(20)
    .background(LubaColors.background)
}
