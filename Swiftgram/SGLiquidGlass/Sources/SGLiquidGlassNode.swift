import Foundation
import UIKit
import AsyncDisplayKit
import Display
import SGLiquidGlassCore
import SGSimpleSettings

// MARK: - Rounded path helper (fixes stripe artefacts)

private func makeRoundedPath(rect: CGRect, radii: GlassRadii) -> UIBezierPath {
    let tl = max(radii.topLeft, 0), tr = max(radii.topRight, 0)
    let bl = max(radii.bottomLeft, 0), br = max(radii.bottomRight, 0)
    let p = UIBezierPath()
    p.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))
    p.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
    p.addArc(withCenter: CGPoint(x: rect.maxX - tr, y: rect.minY + tr),   radius: tr, startAngle: -.pi/2, endAngle: 0,      clockwise: true)
    p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
    p.addArc(withCenter: CGPoint(x: rect.maxX - br, y: rect.maxY - br),   radius: br, startAngle: 0,       endAngle: .pi/2,  clockwise: true)
    p.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
    p.addArc(withCenter: CGPoint(x: rect.minX + bl, y: rect.maxY - bl),   radius: bl, startAngle: .pi/2,  endAngle: .pi,    clockwise: true)
    p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
    p.addArc(withCenter: CGPoint(x: rect.minX + tl, y: rect.minY + tl),   radius: tl, startAngle: .pi,    endAngle: -.pi/2, clockwise: true)
    p.close()
    return p
}

// MARK: - Specular highlight layer (iOS 26 glass edge shine)

private func makeSpecularLayer(rect: CGRect, radii: GlassRadii) -> CAGradientLayer {
    let g = CAGradientLayer()
    g.type = .radial
    g.colors = [
        UIColor.white.withAlphaComponent(0.22).cgColor,
        UIColor.white.withAlphaComponent(0.0).cgColor
    ]
    g.locations = [0, 1]
    // Shine originates from top-left corner
    g.startPoint = CGPoint(x: 0, y: 0)
    g.endPoint   = CGPoint(x: 1.2, y: 1.2)
    g.frame = rect
    // Clip to same shape
    let mask = CAShapeLayer()
    mask.path = makeRoundedPath(rect: CGRect(origin: .zero, size: rect.size), radii: radii).cgPath
    g.mask = mask
    return g
}

// MARK: - Glass Node (ASDisplayKit)

public final class SGLiquidGlassNode: ASDisplayNode, SGLiquidGlassContainer {

    private var effectView: UIVisualEffectView?
    private var specularLayer: CAGradientLayer?
    private var _tintColor: UIColor = .clear
    private var _cornerRadii: GlassRadii = .init(radius: 0)
    private var _glassVisible: Bool = true
    private var _interactive: Bool = false
    private var _specularEnabled: Bool = true

    public var glassTintColor: UIColor {
        get { _tintColor }
        set { if _tintColor != newValue { _tintColor = newValue; applyTint() } }
    }

    public var glassCornerRadii: GlassRadii {
        get { _cornerRadii }
        set { _cornerRadii = newValue; applyMask(); updateSpecular() }
    }

    public var glassVisible: Bool {
        get { _glassVisible }
        set { _glassVisible = newValue; effectView?.isHidden = !newValue; specularLayer?.isHidden = !newValue }
    }

    public var interactive: Bool {
        get { _interactive }
        set { _interactive = newValue; rebuildEffect() }
    }

    /// Show top-left specular shine (iOS 26 style). Default true.
    public var specularEnabled: Bool {
        get { _specularEnabled }
        set { _specularEnabled = newValue; specularLayer?.isHidden = !newValue }
    }

    public override init() {
        super.init()
        isLayerBacked = false
        backgroundColor = .clear
        clipsToBounds = true
    }

    public override func didLoad() {
        super.didLoad()
        rebuildEffect()
    }

    // MARK: - Build

    private func rebuildEffect() {
        guard isNodeLoaded else { return }
        effectView?.removeFromSuperview()
        effectView = nil
        specularLayer?.removeFromSuperlayer()
        specularLayer = nil

        let ev: UIVisualEffectView
        if #available(iOS 26.0, *) {
            let g = UIGlassEffect()
            g.isInteractive = _interactive
            // Pure clear glass — maximum blur, zero tint base
            ev = UIVisualEffectView(effect: g)
        } else {
            ev = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        }
        ev.backgroundColor = .clear
        ev.frame = bounds
        ev.isUserInteractionEnabled = false
        // CRITICAL: do NOT use autoresizingMask — we set frame manually
        view.insertSubview(ev, at: 0)
        effectView = ev

        // Specular highlight on top
        if _specularEnabled {
            let sl = makeSpecularLayer(rect: bounds, radii: _cornerRadii)
            view.layer.addSublayer(sl)
            specularLayer = sl
        }

        applyTint()
        applyMask()
        applyIntensity(zone: nil)
    }

    // MARK: - Tint

    private func applyTint() {
        guard isNodeLoaded, let ev = effectView else { return }
        if #available(iOS 26.0, *), let g = ev.effect as? UIGlassEffect {
            g.tintColor = _tintColor == .clear ? nil : _tintColor.withAlphaComponent(0.35)
        } else {
            ev.backgroundColor = _tintColor == .clear ? .clear : _tintColor.withAlphaComponent(0.15)
        }
    }

    // MARK: - Mask (fixes stripe bug: manual per-corner path)

    private func applyMask() {
        guard isNodeLoaded, let ev = effectView else { return }
        let r = _cornerRadii
        let allZero = r.topLeft <= 0 && r.topRight <= 0 && r.bottomLeft <= 0 && r.bottomRight <= 0
        if allZero {
            ev.layer.mask = nil
            ev.clipsToBounds = false
            return
        }
        let path = makeRoundedPath(rect: ev.bounds, radii: r)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillColor = UIColor.black.cgColor
        mask.strokeColor = nil
        ev.layer.mask = mask
        ev.clipsToBounds = true
    }

    // MARK: - Intensity

    private func applyIntensity(zone: SGLiquidGlassZone?) {
        guard isNodeLoaded, let ev = effectView else { return }
        let alpha: CGFloat
        if let zone = zone {
            alpha = zone.intensity
        } else {
            alpha = CGFloat(SGSimpleSettings.shared.namelessLiquidGlassIntensity)
        }
        // IMPROVEMENT: if blurInsteadGlass is ON, use a stronger alpha fallback
        if SGSimpleSettings.shared.blurInsteadGlass {
            ev.alpha = max(alpha, 0.85)
        } else {
            ev.alpha = alpha
        }
        specularLayer?.opacity = Float(alpha * 0.8)
    }

    // MARK: - Layout

    public override func layout() {
        super.layout()
        guard let ev = effectView else { return }
        ev.frame = bounds
        applyMask()
        updateSpecular()
    }

    private func updateSpecular() {
        guard isNodeLoaded else { return }
        specularLayer?.frame = bounds
        // Update specular clip mask shape
        if let sl = specularLayer, let mask = sl.mask as? CAShapeLayer {
            mask.path = makeRoundedPath(rect: CGRect(origin: .zero, size: bounds.size), radii: _cornerRadii).cgPath
        }
    }

    public func updateGlassFrame(_ frame: CGRect, transition: ContainedViewLayoutTransition) {
        transition.updateFrame(node: self, frame: frame)
        if let ev = effectView {
            transition.updateFrame(view: ev, frame: bounds)
            applyMask()
        }
    }

    // MARK: - SGLiquidGlassContainer

    public func refreshGlass(zone: SGLiquidGlassZone) {
        guard isNodeLoaded else { return }
        let enabled = zone.isEnabled
        let animate = zone.fadeAnimationEnabled

        if animate {
            UIView.animate(withDuration: 0.32, delay: 0,
                           usingSpringWithDamping: 0.85, initialSpringVelocity: 0,
                           options: [.curveEaseInOut, .allowUserInteraction]) {
                self.effectView?.isHidden = !enabled
                self.specularLayer?.isHidden = !enabled
                self.applyIntensity(zone: zone)
            }
        } else {
            effectView?.isHidden = !enabled
            specularLayer?.isHidden = !enabled
            applyIntensity(zone: zone)
        }

        if zone.isTinted {
            applyTint()
        } else {
            if #available(iOS 26.0, *), let ev = effectView, let g = ev.effect as? UIGlassEffect {
                g.tintColor = nil
            } else if let ev = effectView {
                ev.backgroundColor = .clear
            }
        }

        if enabled && effectView == nil { rebuildEffect() }
    }
}

// MARK: - Glass View (UIView)

public final class SGLiquidGlassView: UIView, SGLiquidGlassViewProtocol, SGLiquidGlassViewContainer {
    private var effectView: UIVisualEffectView?
    private var specularLayer: CAGradientLayer?
    private var _tintColor: UIColor = .clear
    private var _cornerRadii: GlassRadii = .init(radius: 0)
    private var _interactive: Bool = false
    private var _visible: Bool = true

    public var tintColorGlass: UIColor {
        get { _tintColor }
        set { _tintColor = newValue; applyTint() }
    }

    public var cornerRadii: GlassRadii {
        get { _cornerRadii }
        set { _cornerRadii = newValue; applyMask(); updateSpecular() }
    }

    public var isInteractive: Bool {
        get { _interactive }
        set { _interactive = newValue; rebuildEffect() }
    }

    public var isVisible: Bool {
        get { _visible }
        set { _visible = newValue; effectView?.isHidden = !newValue; specularLayer?.isHidden = !newValue }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil && effectView == nil { rebuildEffect() }
    }

    private func rebuildEffect() {
        effectView?.removeFromSuperview(); effectView = nil
        specularLayer?.removeFromSuperlayer(); specularLayer = nil

        let ev: UIVisualEffectView
        if #available(iOS 26.0, *) {
            let g = UIGlassEffect(); g.isInteractive = _interactive
            ev = UIVisualEffectView(effect: g)
        } else {
            ev = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        }
        ev.backgroundColor = .clear
        ev.frame = bounds
        ev.isUserInteractionEnabled = false
        insertSubview(ev, at: 0)
        effectView = ev

        // Specular
        let sl = makeSpecularLayer(rect: bounds, radii: _cornerRadii)
        layer.addSublayer(sl)
        specularLayer = sl

        applyTint(); applyMask(); applyIntensity(zone: nil)
    }

    private func applyTint() {
        guard let ev = effectView else { return }
        if #available(iOS 26.0, *), let g = ev.effect as? UIGlassEffect {
            g.tintColor = _tintColor == .clear ? nil : _tintColor.withAlphaComponent(0.35)
        } else {
            ev.backgroundColor = _tintColor == .clear ? .clear : _tintColor.withAlphaComponent(0.15)
        }
    }

    private func applyMask() {
        guard let ev = effectView else { return }
        let r = _cornerRadii
        let allZero = r.topLeft <= 0 && r.topRight <= 0 && r.bottomLeft <= 0 && r.bottomRight <= 0
        if allZero { ev.layer.mask = nil; ev.clipsToBounds = false; return }
        let path = makeRoundedPath(rect: ev.bounds, radii: r)
        let mask = CAShapeLayer()
        mask.path = path.cgPath; mask.fillColor = UIColor.black.cgColor; mask.strokeColor = nil
        ev.layer.mask = mask; ev.clipsToBounds = true
    }

    private func applyIntensity(zone: SGLiquidGlassZone?) {
        guard let ev = effectView else { return }
        let alpha = zone?.intensity ?? CGFloat(SGSimpleSettings.shared.namelessLiquidGlassIntensity)
        let finalAlpha = SGSimpleSettings.shared.blurInsteadGlass ? max(alpha, 0.85) : alpha
        ev.alpha = finalAlpha
        specularLayer?.opacity = Float(finalAlpha * 0.8)
    }

    private func updateSpecular() {
        specularLayer?.frame = bounds
        if let sl = specularLayer, let mask = sl.mask as? CAShapeLayer {
            mask.path = makeRoundedPath(rect: CGRect(origin: .zero, size: bounds.size), radii: _cornerRadii).cgPath
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let ev = effectView else { return }
        ev.frame = bounds; applyMask(); updateSpecular()
    }

    public func refreshGlass(zone: SGLiquidGlassZone) {
        let enabled = zone.isEnabled
        if zone.fadeAnimationEnabled {
            UIView.animate(withDuration: 0.32, delay: 0, usingSpringWithDamping: 0.85,
                           initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                self.effectView?.isHidden = !enabled
                self.specularLayer?.isHidden = !enabled
                self.applyIntensity(zone: zone)
            }
        } else {
            effectView?.isHidden = !enabled; specularLayer?.isHidden = !enabled
            applyIntensity(zone: zone)
        }
        zone.isTinted ? applyTint() : ({ [weak self] in
            if #available(iOS 26.0, *), let ev = self?.effectView, let g = ev.effect as? UIGlassEffect { g.tintColor = nil }
            else { self?.effectView?.backgroundColor = .clear }
        }())
        if enabled && effectView == nil { rebuildEffect() }
    }
}

// MARK: - Factory

public extension SGLiquidGlassFactory {
    @discardableResult
    func registerConcreteGlassView() -> Bool {
        if create == nil { create = { SGLiquidGlassView() } }
        return true
    }
}

public enum SGLiquidGlass {
    @discardableResult
    public static func registerFactory() -> Bool { SGLiquidGlassFactory.shared.registerConcreteGlassView() }
}
