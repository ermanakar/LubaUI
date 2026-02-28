//
//  LubaTooltip.swift
//  LubaUI
//
//  Contextual help that appears on tap.
//
//  Architecture:
//  - Trigger views emit global anchor rects
//  - A single tooltip host renders in a root overlay layer
//  - Placement is centralized (flip/clamp/edge-safe)
//

import SwiftUI

// MARK: - Tooltip Position

/// Anchor position preference for a ``LubaTooltip``.
public enum LubaTooltipPosition: Sendable {
    case top
    case bottom
}

// MARK: - Controller

final class LubaTooltipController: ObservableObject {
    struct ActiveTooltip: Equatable {
        let id: UUID
        let message: String
        let preferredPosition: LubaTooltipPosition
        var anchor: CGRect
    }

    static let shared = LubaTooltipController()

    @Published var active: ActiveTooltip?
    private var dismissWorkItem: DispatchWorkItem?

    func toggle(
        id: UUID,
        message: String,
        preferredPosition: LubaTooltipPosition,
        anchor: CGRect,
        dismissAfter: Double
    ) {
        if active?.id == id {
            dismiss()
            return
        }

        show(
            id: id,
            message: message,
            preferredPosition: preferredPosition,
            anchor: anchor,
            dismissAfter: dismissAfter
        )
    }

    func dismiss(id: UUID? = nil) {
        if let id, active?.id != id {
            return
        }
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        active = nil
    }

    func updateAnchorIfActive(id: UUID, anchor: CGRect) {
        guard var current = active, current.id == id else { return }
        current.anchor = anchor
        active = current
    }

    private func show(
        id: UUID,
        message: String,
        preferredPosition: LubaTooltipPosition,
        anchor: CGRect,
        dismissAfter: Double
    ) {
        dismissWorkItem?.cancel()
        active = ActiveTooltip(
            id: id,
            message: message,
            preferredPosition: preferredPosition,
            anchor: anchor
        )

        let work = DispatchWorkItem { [weak self] in
            self?.dismiss(id: id)
        }
        dismissWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter, execute: work)
    }
}

// MARK: - LubaTooltip

/// A tooltip trigger that appears on tap to show contextual help.
///
/// To render correctly above complex view hierarchies, apply `.lubaTooltipHost()`
/// at a root container (for example, on your screen-level wrapper).
public struct LubaTooltip<Content: View>: View {
    private let id = UUID()
    private let message: String
    private let position: LubaTooltipPosition
    private let content: Content

    @State private var anchorRect: CGRect = .zero
    @Environment(\.lubaConfig) private var config
    private let tooltipController = LubaTooltipController.shared

    public init(
        _ message: String,
        position: LubaTooltipPosition = .top,
        @ViewBuilder content: () -> Content
    ) {
        self.message = message
        self.position = position
        self.content = content()
    }

    public var body: some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: TooltipAnchorPreferenceKey.self,
                        value: proxy.frame(in: .global)
                    )
                }
            }
            .onPreferenceChange(TooltipAnchorPreferenceKey.self) { rect in
                guard rect.width > 1, rect.height > 1 else { return }
                anchorRect = rect
                tooltipController.updateAnchorIfActive(id: id, anchor: rect)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(TapGesture().onEnded {
                guard anchorRect.width > 1, anchorRect.height > 1 else { return }

                if config.hapticsEnabled {
                    LubaHaptics.light()
                }

                let performToggle = {
                    tooltipController.toggle(
                        id: id,
                        message: message,
                        preferredPosition: position,
                        anchor: anchorRect,
                        dismissAfter: LubaTooltipTokens.dismissDuration
                    )
                }
                if config.animationsEnabled {
                    withAnimation(LubaMotion.micro) { performToggle() }
                } else {
                    performToggle()
                }
            })
            .accessibilityHint("Tap for more information")
            .onDisappear {
                tooltipController.dismiss(id: id)
            }
    }
}

// MARK: - Host Modifier

private struct LubaTooltipHostModifier: ViewModifier {
    @ObservedObject private var tooltipController = LubaTooltipController.shared
    @Environment(\.lubaConfig) private var config
    @State private var bubbleSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                GeometryReader { proxy in
                    if let active = tooltipController.active {
                        let placement = placement(for: active, in: proxy)
                        TooltipBubble(
                            message: active.message,
                            position: placement.position,
                            arrowOffset: placement.arrowOffset
                        )
                        .background {
                            GeometryReader { bubbleProxy in
                                Color.clear.preference(
                                    key: TooltipBubbleSizePreferenceKey.self,
                                    value: bubbleProxy.size
                                )
                            }
                        }
                        .position(x: placement.x, y: placement.y)
                        .transition(
                            .scale(
                                scale: 0.9,
                                anchor: placement.position == .top ? .bottom : .top
                            )
                            .combined(with: .opacity)
                        )
                        .zIndex(10_000)
                    }
                }
                .allowsHitTesting(false)
            }
            .onPreferenceChange(TooltipBubbleSizePreferenceKey.self) { size in
                bubbleSize = size
            }
            .onChange(of: tooltipController.active?.id) { _ in
                bubbleSize = .zero
            }
            .animation(config.animationsEnabled ? LubaMotion.micro : nil, value: tooltipController.active?.id)
    }

    private func placement(
        for active: LubaTooltipController.ActiveTooltip,
        in hostProxy: GeometryProxy
    ) -> (x: CGFloat, y: CGFloat, position: LubaTooltipPosition, arrowOffset: CGFloat) {
        let hostFrame = hostProxy.frame(in: .global)
        let anchorInHost = CGRect(
            x: active.anchor.minX - hostFrame.minX,
            y: active.anchor.minY - hostFrame.minY,
            width: active.anchor.width,
            height: active.anchor.height
        )

        let measuredWidth = bubbleSize.width > 0 ? bubbleSize.width : LubaTooltipTokens.maxWidth
        let measuredHeight = bubbleSize.height > 0 ? bubbleSize.height : 44
        let edgePadding = LubaTooltipTokens.screenEdgePadding
        let gap = LubaTooltipTokens.offsetFromAnchor

        let minCenterX = edgePadding + measuredWidth / 2
        let maxCenterX = hostProxy.size.width - edgePadding - measuredWidth / 2
        let centerX = min(max(anchorInHost.midX, minCenterX), maxCenterX)
        
        // Ensure the arrow doesn't detach from the bubble by clamping it to the rounded corners
        let maxArrowOffset = (measuredWidth / 2) - LubaTooltipTokens.cornerRadius - LubaTooltipTokens.arrowSize
        let arrowOffset = min(max(anchorInHost.midX - centerX, -maxArrowOffset), maxArrowOffset)

        let availableAbove = anchorInHost.minY - edgePadding
        let availableBelow = hostProxy.size.height - anchorInHost.maxY - edgePadding
        let fitsAbove = availableAbove >= measuredHeight + gap
        let fitsBelow = availableBelow >= measuredHeight + gap

        let resolvedPosition: LubaTooltipPosition
        switch active.preferredPosition {
        case .top:
            resolvedPosition = fitsAbove || !fitsBelow ? .top : .bottom
        case .bottom:
            resolvedPosition = fitsBelow || !fitsAbove ? .bottom : .top
        }

        let centerY: CGFloat
        switch resolvedPosition {
        case .top:
            centerY = anchorInHost.minY - gap - measuredHeight / 2
        case .bottom:
            centerY = anchorInHost.maxY + gap + measuredHeight / 2
        }

        return (centerX, centerY, resolvedPosition, arrowOffset)
    }
}

public extension View {
    /// Adds a tooltip trigger that appears when this view is tapped.
    func lubaTooltip(_ message: String, position: LubaTooltipPosition = .top) -> some View {
        LubaTooltip(message, position: position) {
            self
        }
    }

    /// Installs a root tooltip overlay layer for all nested `LubaTooltip` triggers.
    ///
    /// Apply this once near screen/root containers so tooltips render above siblings.
    func lubaTooltipHost() -> some View {
        modifier(LubaTooltipHostModifier())
    }
}

// MARK: - Bubble

private struct TooltipBubble: View {
    let message: String
    let position: LubaTooltipPosition
    let arrowOffset: CGFloat

    var body: some View {
        Text(message)
            .font(LubaTypography.custom(size: LubaTooltipTokens.fontSize, weight: .regular))
            .foregroundStyle(LubaColors.textPrimary)
            .padding(LubaTooltipTokens.padding)
            .frame(maxWidth: LubaTooltipTokens.maxWidth, alignment: .leading)
            .background(LubaColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: LubaTooltipTokens.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: LubaTooltipTokens.cornerRadius, style: .continuous)
                    .strokeBorder(LubaColors.border, lineWidth: 1)
            )
            .overlay(alignment: position == .top ? .bottom : .top) {
                TooltipArrow(position: position)
                    .fill(LubaColors.surface)
                    .frame(width: LubaTooltipTokens.arrowSize * 2, height: LubaTooltipTokens.arrowSize)
                    .overlay(
                        TooltipArrow(position: position)
                            .stroke(LubaColors.border, lineWidth: 1)
                    )
                    .offset(x: arrowOffset, y: position == .top ? LubaTooltipTokens.arrowSize - 1 : -LubaTooltipTokens.arrowSize + 1)
            }
            .shadow(
                color: Color.black.opacity(LubaTooltipTokens.shadowOpacity),
                radius: LubaTooltipTokens.shadowBlur,
                y: LubaTooltipTokens.shadowY
            )
            .accessibilityLabel(message)
            .accessibilityAddTraits(.isStaticText)
    }
}

private struct TooltipArrow: Shape {
    let position: LubaTooltipPosition

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if position == .top {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.closeSubpath()
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.closeSubpath()
        }
        return path
    }
}

private struct TooltipAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

private struct TooltipBubbleSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - Preview

#Preview("Tooltip") {
    VStack(spacing: 60) {
        LubaTooltip("This is a helpful tooltip that explains something.") {
            Image(systemName: "info.circle")
                .font(.system(size: 20))
                .foregroundStyle(LubaColors.accent)
        }

        Text("Tap me for help")
            .font(LubaTypography.body)
            .foregroundStyle(LubaColors.textSecondary)
            .lubaTooltip("Here's some extra context about this feature.", position: .bottom)
    }
    .lubaTooltipHost()
    .padding(40)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LubaColors.background)
}
