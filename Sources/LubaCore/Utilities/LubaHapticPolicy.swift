import SwiftUI

/// Haptic settings resolved from the current view subtree.
/// Impact styles use `intensity`; notification and selection styles use the
/// system's fixed feedback and only honor `isEnabled`.
public struct LubaHapticPolicy {
    public let isEnabled: Bool
    public let intensity: CGFloat

    public init(config: LubaConfig) {
        isEnabled = config.hapticsEnabled
        intensity = config.hapticIntensity.isFinite ? min(1, max(0, config.hapticIntensity)) : 1
    }

    public func trigger(_ style: LubaHapticStyle) {
        guard isEnabled else { return }
        style.trigger(intensity: intensity)
    }
}
