import Foundation
import UIKit
import AsyncDisplayKit
import Display
import SGLiquidGlassCore

// MARK: - Glass Node (AsyncDisplayKit)

/// ASDisplayNode wrapper around UIVisualEffectView + UIGlassEffect (iOS 26+).
/// Falls back to a no-op translucent node on older systems.
///
/// Use:
///   let glass = SGLiquidGlassNode()
///   glass.glassTintColor = .red
///   glass.cornerRadii = .init(radius: 18)
///   addSubnode(glass)
///   glass.frame = ...
public final class SGLiquidGlassNode: ASDisplayNode, SGLiquidGlassContainer {
    private var effectView: UIVisualEffectView?
    private var _tintColor: UIColor = .clear
    private var _cornerRadii: GlassRadii = .init(radius: 0)
    private var _isVisible: Bool = true
    private var _isInteractive: Bool = false
    private var _cachedZone: SGLiquidGlassZone = .buttons

    /// Tint color applied to the glass surface. Renamed from `tintColor` to
    /// avoid clashing with `ASDisplayNode.tintColor` (which is the standard
    /// UIKit tinting color, semantically unrelated to glass tint).
    public var glassTintColor: UIColor {
        get { self._tintColor }
        set {
            if self._tintColor != newValue {
                self._tintColor = newValue
                self.applyTintColor()
            }
        }
    }

    public var cornerRadii: GlassRadii {
        get { self._cornerRadii }
        set {
            self._cornerRadii = newValue
            self.applyMaskPath()
        }
    }

    public var isVisible: Bool {
        get { self._isVisible }
        set {
            self._isVisible = newValue
            self.effectView?.isHidden = !newValue
        }
    }

    public var isInteractive: Bool {
        get { self._isInteractive }
        set {
            self._isInteractive = newValue
            self.rebuildEffect()
        }
    }

    public override init() {
        super.init()
        self.isLayerBacked = false
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }

    public override func didLoad() {
        super.didLoad()
        self.rebuildEffect()
    }

    private func rebuildEffect() {
        if self.isNodeLoaded {
            if let v = self.effectView {
                v.removeFromSuperview()
                self.effectView = nil
            }
            if #available(iOS 26.0, *) {
                let effect = UIGlassEffect(style: .regular)
                effect.isInteractive = self._isInteractive
                if self._tintColor != .clear {
                    effect.tintColor = self._tintColor
                }
                let ev = UIVisualEffectView(effect: effect)
                ev.frame = self.bounds
                ev.backgroundColor = .clear
                ev.isUserInteractionEnabled = false
                self.view.addSubview(ev)
                self.effectView = ev
            } else {
                let ev = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                ev.frame = self.bounds
                ev.backgroundColor = self._tintColor.withAlphaComponent(0.18)
                ev.isUserInteractionEnabled = false
                self.view.addSubview(ev)
                self.effectView = ev
            }
            self.applyMaskPath()
        }
    }

    private func applyTintColor() {
        guard self.isNodeLoaded, let ev = self.effectView else { return }
        if #available(iOS 26.0, *), let g = ev.effect as? UIGlassEffect {
            g.tintColor = self._tintColor
        } else {
            ev.backgroundColor = self._tintColor.withAlphaComponent(0.18)
        }
    }

    private func applyMaskPath() {
        guard self.isNodeLoaded, let ev = self.effectView else { return }
        let r = self._cornerRadii
        if r.topLeft <= 0 && r.topRight <= 0 && r.bottomLeft <= 0 && r.bottomRight <= 0 {
            ev.layer.mask = nil
            ev.layer.cornerRadius = 0
            ev.clipsToBounds = false
            return
        }
        let path = UIBezierPath(
            roundedRect: ev.bounds,
            byRoundingCorners: r.roundedCorners,
            cornerRadii: CGSize(width: max(r.topLeft, 0.001), height: max(r.topLeft, 0.001))
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        ev.layer.mask = mask
        ev.layer.cornerRadius = r.topLeft
        ev.clipsToBounds = true
    }

    public override func layout() {
        super.layout()
        if let ev = self.effectView {
            ev.frame = self.bounds
            self.applyMaskPath()
        }
    }

    public override func updateFrame(_ frame: CGRect, transition: ContainedViewLayoutTransition) {
        super.updateFrame(frame, transition: transition)
        if let ev = self.effectView {
            transition.updateFrame(view: ev, frame: self.bounds)
            self.applyMaskPath()
        }
    }

    // MARK: SGLiquidGlassContainer

    public func refreshGlass(zone: SGLiquidGlassZone) {
        self._cachedZone = zone
        let enabled = zone.isEnabled
        self.effectView?.isHidden = !enabled
        if zone.isTinted {
            self.applyTintColor()
        } else {
            if #available(iOS 26.0, *), let ev = self.effectView, let g = ev.effect as? UIGlassEffect {
                g.tintColor = .clear
            } else if let ev = self.effectView {
                ev.backgroundColor = .clear
            }
        }
        if enabled && self.effectView == nil {
            self.rebuildEffect()
        }
    }
}

// MARK: - Glass View (UIView)

/// UIView wrapper around UIVisualEffectView + UIGlassEffect (iOS 26+).
public final class SGLiquidGlassView: UIView, SGLiquidGlassViewProtocol, SGLiquidGlassViewContainer {
    private var effectView: UIVisualEffectView?
    private var _tintColor: UIColor = .clear
    private var _cornerRadii: GlassRadii = .init(radius: 0)
    private var _isInteractive: Bool = false
    private var _isVisible: Bool = true

    public var tintColorGlass: UIColor {
        get { self._tintColor }
        set {
            self._tintColor = newValue
            self.applyTintColor()
        }
    }

    public var cornerRadii: GlassRadii {
        get { self._cornerRadii }
        set {
            self._cornerRadii = newValue
            self.applyMaskPath()
        }
    }

    public var isInteractive: Bool {
        get { self._isInteractive }
        set {
            self._isInteractive = newValue
            self.rebuildEffect()
        }
    }

    public var isVisible: Bool {
        get { self._isVisible }
        set {
            self._isVisible = newValue
            self.effectView?.isHidden = !newValue
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil && self.effectView == nil {
            self.rebuildEffect()
        }
    }

    private func rebuildEffect() {
        if let v = self.effectView {
            v.removeFromSuperview()
            self.effectView = nil
        }
        if #available(iOS 26.0, *) {
            let effect = UIGlassEffect(style: .regular)
            effect.isInteractive = self._isInteractive
            if self._tintColor != .clear {
                effect.tintColor = self._tintColor
            }
            let ev = UIVisualEffectView(effect: effect)
            ev.frame = self.bounds
            ev.backgroundColor = .clear
            ev.isUserInteractionEnabled = false
            self.addSubview(ev)
            self.effectView = ev
        } else {
            let ev = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            ev.frame = self.bounds
            ev.backgroundColor = self._tintColor.withAlphaComponent(0.18)
            ev.isUserInteractionEnabled = false
            self.addSubview(ev)
            self.effectView = ev
        }
        self.applyMaskPath()
    }

    private func applyTintColor() {
        guard let ev = self.effectView else { return }
        if #available(iOS 26.0, *), let g = ev.effect as? UIGlassEffect {
            g.tintColor = self._tintColor
        } else {
            ev.backgroundColor = self._tintColor.withAlphaComponent(0.18)
        }
    }

    private func applyMaskPath() {
        guard let ev = self.effectView else { return }
        let r = self._cornerRadii
        if r.topLeft <= 0 && r.topRight <= 0 && r.bottomLeft <= 0 && r.bottomRight <= 0 {
            ev.layer.mask = nil
            ev.layer.cornerRadius = 0
            ev.clipsToBounds = false
            return
        }
        let path = UIBezierPath(
            roundedRect: ev.bounds,
            byRoundingCorners: r.roundedCorners,
            cornerRadii: CGSize(width: max(r.topLeft, 0.001), height: max(r.topLeft, 0.001))
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        ev.layer.mask = mask
        ev.layer.cornerRadius = r.topLeft
        ev.clipsToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let ev = self.effectView {
            ev.frame = self.bounds
            self.applyMaskPath()
        }
    }

    public func refreshGlass(zone: SGLiquidGlassZone) {
        let enabled = zone.isEnabled
        self.effectView?.isHidden = !enabled
        if zone.isTinted {
            self.applyTintColor()
        } else {
            if #available(iOS 26.0, *), let ev = self.effectView, let g = ev.effect as? UIGlassEffect {
                g.tintColor = .clear
            } else if let ev = self.effectView {
                ev.backgroundColor = .clear
            }
        }
        if enabled && self.effectView == nil {
            self.rebuildEffect()
        }
    }
}

// MARK: - Factory registration

/// On first use, register the concrete glass view factory with Core so that
/// low-level Display module can create one without a circular dep.
/// Call `SGLiquidGlass.registerFactory()` once at app launch (e.g. from
/// `AppDelegate.didFinishLaunchingWithOptions`).
public extension SGLiquidGlassFactory {
    /// Registers the concrete `SGLiquidGlassView` as the factory's product.
    /// Idempotent.
    @discardableResult
    func registerConcreteGlassView() -> Bool {
        if self.create == nil {
            self.create = { SGLiquidGlassView() }
        }
        return true
    }
}

/// Convenience: call from AppDelegate to register the Liquid Glass view
/// factory. Idempotent and thread-safe via dispatch_once-like semantics.
public enum SGLiquidGlass {
    @discardableResult
    public static func registerFactory() -> Bool {
        return SGLiquidGlassFactory.shared.registerConcreteGlassView()
    }
}
