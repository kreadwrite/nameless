import Foundation
import UIKit
import SGSimpleSettings

// MARK: - Zones

/// All distinct Liquid Glass surfaces in nameless.
/// Each one is gated by a corresponding toggle in SGSimpleSettings.
public enum SGLiquidGlassZone: Int, CaseIterable {
    case messages
    case settings
    case profile
    case profileGifts
    case inlineButtons
    case tabBar
    case navigationBar
    case inputPanel
    case search
    case buttons

    /// Master switch (`nameless.liquidGlassEnabled`) gates every zone.
    /// Per-zone toggles only apply if the master is on.
    public var isEnabled: Bool {
        let s = SGSimpleSettings.shared
        guard s.liquidGlassEnabled else { return false }
        switch self {
        case .messages:        return s.namelessLiquidGlassMessages
        case .settings:        return s.namelessLiquidGlassSettings
        case .profile:         return s.namelessLiquidGlassProfile
        case .profileGifts:    return s.namelessLiquidGlassProfileGifts
        case .inlineButtons:   return s.namelessLiquidGlassInlineButtons
        case .tabBar,
             .navigationBar,
             .inputPanel,
             .search,
             .buttons:         return true // gated only by master
        }
    }

    /// Whether the tint color of the glass should be applied.
    /// When `false`, the glass is purely a blur (no tint).
    public var isTinted: Bool {
        SGSimpleSettings.shared.namelessLiquidGlassTinting
    }
}

// MARK: - Glass Radii

public struct GlassRadii: Equatable {
    public let topLeft: CGFloat
    public let topRight: CGFloat
    public let bottomLeft: CGFloat
    public let bottomRight: CGFloat

    public init(radius: CGFloat) {
        self.topLeft = radius
        self.topRight = radius
        self.bottomLeft = radius
        self.bottomRight = radius
    }

    public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    public var roundedCorners: UIRectCorner {
        var c: UIRectCorner = []
        if topLeft > 0 { c.insert(.topLeft) }
        if topRight > 0 { c.insert(.topRight) }
        if bottomLeft > 0 { c.insert(.bottomLeft) }
        if bottomRight > 0 { c.insert(.bottomRight) }
        return c
    }
}

// MARK: - Container protocols

/// Adopted by ASDisplayNode subclasses that own a glass surface.
/// (Kept here so low-level Display module can adopt it without pulling in
/// the heavy glass implementation module.)
public protocol SGLiquidGlassContainer: AnyObject {
    func refreshGlass(zone: SGLiquidGlassZone)
}

/// Adopted by UIView subclasses that own a glass surface.
public protocol SGLiquidGlassViewContainer: AnyObject {
    func refreshGlass(zone: SGLiquidGlassZone)
}

// MARK: - Glass view protocol (factory-registered)

/// Protocol that concrete glass views conform to. Lives in Core so low-level
/// modules (Display) can hold one without depending on the heavy
/// implementation module.
public protocol SGLiquidGlassViewProtocol: AnyObject {
    var tintColorGlass: UIColor { get set }
    var cornerRadii: GlassRadii { get set }
    var isVisible: Bool { get set }
    func refreshGlass(zone: SGLiquidGlassZone)
}

public extension SGLiquidGlassViewProtocol where Self: UIView {
    /// Helper to set the frame from outside.
    func setFrame(_ frame: CGRect) { self.frame = frame }
}

/// Factory hook so high-level code can register the concrete glass view class
/// while low-level code (Display) can instantiate one without a hard dep.
public final class SGLiquidGlassFactory {
    public static let shared = SGLiquidGlassFactory()
    private init() {}

    public var create: (() -> SGLiquidGlassViewProtocol?)?
}

// MARK: - Coordinator

/// Singleton that:
/// 1) Listens for `.luxgramLiquidGlassDidChange` notifications.
/// 2) Holds weak references to all live glass-bearing nodes/views.
/// 3) Forces every glass surface to refresh whenever a toggle changes.
public final class SGLiquidGlassCoordinator {
    public static let shared = SGLiquidGlassCoordinator()

    private struct Observer {
        weak var node: AnyObject?
        let zone: SGLiquidGlassZone
    }

    private var observers: [ObjectIdentifier: Observer] = [:]
    private var notificationObserver: NSObjectProtocol?
    private let queue = DispatchQueue(label: "nameless.liquidglass.coordinator")

    private init() {
        let center = NotificationCenter.default
        self.notificationObserver = center.addObserver(
            forName: .luxgramLiquidGlassDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshAll()
        }
    }

    deinit {
        if let o = self.notificationObserver {
            NotificationCenter.default.removeObserver(o)
        }
    }

    // MARK: Registration

    public func register(node: AnyObject, zone: SGLiquidGlassZone) {
        let id = ObjectIdentifier(node)
        queue.sync {
            self.observers[id] = Observer(node: node, zone: zone)
        }
    }

    public func unregister(node: AnyObject) {
        let id = ObjectIdentifier(node)
        queue.sync {
            self.observers.removeValue(forKey: id)
        }
    }

    // MARK: Refresh

    /// Re-evaluate every registered glass surface. Called on the main thread
    /// whenever any Liquid Glass toggle changes.
    public func refreshAll() {
        var snapshot: [Observer] = []
        queue.sync {
            snapshot = Array(self.observers.values)
        }
        for obs in snapshot {
            if let n = obs.node as? SGLiquidGlassContainer {
                n.refreshGlass(zone: obs.zone)
            } else if let v = obs.node as? SGLiquidGlassViewContainer {
                v.refreshGlass(zone: obs.zone)
            }
        }
    }
}

