import Foundation
import UIKit
import AsyncDisplayKit
import Display
import SGLiquidGlassCore

// MARK: - Per-item glass overlay

/// Lightweight overlay that turns any flat `ASDisplayNode` background into a
/// Liquid Glass surface. Used by `ItemListUI` items to give settings screens
/// the iOS 26 glass look. Bug fixes in v2:
/// - effectView background is always `.clear` (no white stripes)
/// - frame is set AFTER insertion so mask has non-zero bounds
public final class SGLiquidGlassItemBackground {
    private weak var host: ASDisplayNode?
    private let glass: SGLiquidGlassNode
    private var registered: Bool = false
    private var _tint: UIColor = .clear
    private var _cornerRadii: GlassRadii = .init(radius: 0)

    public init() {
        self.glass = SGLiquidGlassNode()
    }

    public func attach(to node: ASDisplayNode) {
        self.host = node
        node.addSubnode(self.glass)
        if !self.registered {
            self.registered = true
            SGLiquidGlassCoordinator.shared.register(node: self.glass, zone: .settings)
        }
        self.refresh()
    }

    public func detach() {
        if self.registered {
            SGLiquidGlassCoordinator.shared.unregister(node: self.glass)
            self.registered = false
        }
        self.glass.removeFromSupernode()
        self.host = nil
    }

    public var tint: UIColor {
        get { self._tint }
        set {
            self._tint = newValue
            self.glass.glassTintColor = SGLiquidGlassZone.settings.isTinted
                ? newValue.withAlphaComponent(0.45)
                : .clear
        }
    }

    public var cornerRadii: GlassRadii {
        get { self._cornerRadii }
        set {
            self._cornerRadii = newValue
            self.glass.glassCornerRadii = newValue
        }
    }

    public func updateLayout(size: CGSize, cornerRadius: CGFloat = 0) {
        // Set frame BEFORE applying mask so mask bounds are non-zero (stripe fix)
        self.glass.frame = CGRect(origin: .zero, size: size)
        if cornerRadius > 0 {
            self.glass.glassCornerRadii = GlassRadii(radius: cornerRadius)
        }
    }

    public func refresh() {
        let enabled = SGLiquidGlassZone.settings.isEnabled
        self.glass.glassVisible = enabled
        self.glass.glassTintColor = SGLiquidGlassZone.settings.isTinted
            ? self._tint.withAlphaComponent(0.45)
            : .clear
        self.glass.refreshGlass(zone: .settings)
    }
}

// MARK: - ASDisplayNode convenience

private var sgGlassOverlayKey: UInt8 = 0

public extension ASDisplayNode {
    var sgGlassOverlay: SGLiquidGlassItemBackground? {
        if SGLiquidGlassZone.settings.isEnabled {
            if let existing = objc_getAssociatedObject(self, &sgGlassOverlayKey) as? SGLiquidGlassItemBackground {
                return existing
            }
            let overlay = SGLiquidGlassItemBackground()
            overlay.attach(to: self)
            objc_setAssociatedObject(self, &sgGlassOverlayKey, overlay, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return overlay
        } else {
            return nil
        }
    }

    func sgRefreshGlass() {
        if let overlay = objc_getAssociatedObject(self, &sgGlassOverlayKey) as? SGLiquidGlassItemBackground {
            overlay.refresh()
        }
    }
}
