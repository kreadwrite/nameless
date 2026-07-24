import Foundation
import UIKit
import AsyncDisplayKit
import Display
import SGLiquidGlassCore
import SGSimpleSettings
import GlassBackgroundComponent
import ComponentFlow

// MARK: - Per-item Liquid Glass (real UIGlassEffect via GlassBackgroundView)

/// Turns ItemList block backgrounds into real iOS 26 Liquid Glass.
/// Critical rules:
/// 1. Host solid `backgroundColor` MUST be `.clear` while glass is on — otherwise glass is invisible.
/// 2. Separators must be softened / hidden — thick gray stripes kill the glass look.
/// 3. Corner radii only on section top/bottom items (radius 26 like Telegram glass style).
public final class SGLiquidGlassItemBackground {
    private weak var host: ASDisplayNode?
    private let glassView: GlassBackgroundView
    private var registered: Bool = false
    private var _tint: UIColor = .clear
    private var currentSize: CGSize = .zero
    private var currentRadii: GlassBackgroundView.CornerRadii = .init(radius: 0)
    private var currentIsDark: Bool = true

    public init() {
        self.glassView = GlassBackgroundView()
        self.glassView.isUserInteractionEnabled = false
        self.glassView.isHidden = true
    }

    public func attach(to node: ASDisplayNode) {
        self.host = node
        if self.glassView.superview !== node.view {
            node.view.insertSubview(self.glassView, at: 0)
        }
        if !self.registered {
            self.registered = true
            SGLiquidGlassCoordinator.shared.register(node: self, zone: .settings)
        }
        self.refresh()
    }

    public func detach() {
        if self.registered {
            SGLiquidGlassCoordinator.shared.unregister(node: self)
            self.registered = false
        }
        self.glassView.removeFromSuperview()
        self.host = nil
    }

    public var tint: UIColor {
        get { self._tint }
        set { self._tint = newValue; self.pushGlass() }
    }

    /// Legacy API kept for call-sites that pass a single radius.
    public func updateLayout(size: CGSize, cornerRadius: CGFloat = 0) {
        self.updateLayout(
            size: size,
            topLeft: cornerRadius, topRight: cornerRadius,
            bottomLeft: cornerRadius, bottomRight: cornerRadius,
            isDark: true
        )
    }

    public func updateLayout(
        size: CGSize,
        topLeft: CGFloat, topRight: CGFloat,
        bottomLeft: CGFloat, bottomRight: CGFloat,
        isDark: Bool
    ) {
        self.currentSize = size
        self.currentRadii = .init(
            topLeft: topLeft, topRight: topRight,
            bottomLeft: bottomLeft, bottomRight: bottomRight
        )
        self.currentIsDark = isDark
        self.glassView.frame = CGRect(origin: .zero, size: size)
        self.pushGlass()
    }

    public func refresh() {
        self.pushGlass()
    }

    private func pushGlass() {
        let enabled = SGLiquidGlassZone.settings.isEnabled
        // CRITICAL: clear solid host so glass can show through
        if let host = self.host {
            if enabled {
                host.backgroundColor = .clear
            }
        }
        self.glassView.isHidden = !enabled
        guard enabled, self.currentSize.width > 0.5, self.currentSize.height > 0.5 else { return }

        let tint: GlassBackgroundView.TintColor
        if SGLiquidGlassZone.settings.isTinted, self._tint != .clear {
            tint = .init(kind: .custom(style: .clear, color: self._tint.withAlphaComponent(0.12)))
        } else {
            // Real clear glass — content behind must bleed through (like reference screenshots)
            tint = .init(kind: .clear)
        }

        self.glassView.update(
            size: self.currentSize,
            cornerRadii: self.currentRadii,
            isDark: self.currentIsDark,
            tintColor: tint,
            isInteractive: false,
            isVisible: true,
            transition: .immediate
        )
        // Intensity
        let intensity = CGFloat(SGSimpleSettings.shared.namelessLiquidGlassIntensity)
        self.glassView.alpha = max(0.55, min(1.0, intensity))
    }
}

extension SGLiquidGlassItemBackground: SGLiquidGlassContainer {
    public func refreshGlass(zone: SGLiquidGlassZone) {
        self.refresh()
    }
}

// MARK: - ASDisplayNode convenience

private var sgGlassOverlayKey: UInt8 = 0

public extension ASDisplayNode {
    /// Lazily attaches a real Liquid Glass surface when settings-zone is enabled.
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
            if let existing = objc_getAssociatedObject(self, &sgGlassOverlayKey) as? SGLiquidGlassItemBackground {
                existing.detach()
                objc_setAssociatedObject(self, &sgGlassOverlayKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return nil
        }
    }

    func sgRefreshGlass() {
        if let overlay = objc_getAssociatedObject(self, &sgGlassOverlayKey) as? SGLiquidGlassItemBackground {
            overlay.refresh()
        }
    }
}

// MARK: - Shared ItemList glass applicator

public enum NamelessItemListGlass {
    /// Glass corner radius matching Telegram iOS 26 glass section style.
    public static let sectionCornerRadius: CGFloat = 26.0

    /// Soft separator used inside glass sections (not the thick gray stripe).
    public static func softSeparatorColor(isDark: Bool) -> UIColor {
        if isDark {
            return UIColor(white: 1.0, alpha: 0.08)
        } else {
            return UIColor(white: 0.0, alpha: 0.08)
        }
    }

    /// Apply real Liquid Glass to a settings block item.
    /// - Clears solid fill
    /// - Places UIGlassEffect with correct per-corner radii
    /// - Softens separators so gray bars disappear
    public static func apply(
        backgroundNode: ASDisplayNode,
        topStripeNode: ASDisplayNode,
        bottomStripeNode: ASDisplayNode,
        size: CGSize,
        hasTopCorners: Bool,
        hasBottomCorners: Bool,
        isMiddleOfSection: Bool,
        isDark: Bool,
        accentTint: UIColor
    ) {
        guard SGLiquidGlassZone.settings.isEnabled else {
            // restore default solid look is caller's job (they set itemBackgroundColor)
            return
        }

        backgroundNode.backgroundColor = .clear

        let r = sectionCornerRadius
        let top: CGFloat = hasTopCorners ? r : 0
        let bottom: CGFloat = hasBottomCorners ? r : 0

        if let glass = backgroundNode.sgGlassOverlay {
            glass.tint = accentTint
            glass.updateLayout(
                size: size,
                topLeft: top, topRight: top,
                bottomLeft: bottom, bottomRight: bottom,
                isDark: isDark
            )
        }

        // Soft / hidden separators — kills the "gray bars" bug
        topStripeNode.isHidden = true
        if isMiddleOfSection || (!hasBottomCorners && !hasTopCorners) {
            bottomStripeNode.backgroundColor = softSeparatorColor(isDark: isDark)
            bottomStripeNode.isHidden = false
            bottomStripeNode.alpha = 1.0
        } else if hasBottomCorners {
            bottomStripeNode.isHidden = true
        } else {
            bottomStripeNode.backgroundColor = softSeparatorColor(isDark: isDark)
        }
    }
}
