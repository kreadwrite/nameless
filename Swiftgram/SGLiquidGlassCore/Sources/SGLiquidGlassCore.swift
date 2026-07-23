import Foundation
import UIKit
import SGSimpleSettings

// MARK: - Zones

/// All distinct Liquid Glass surfaces in nameless.
public enum SGLiquidGlassZone: Int, CaseIterable {
    case messages           // входящие пузыри
    case outgoingMessages   // исходящие пузыри
    case settings           // экраны настроек
    case profile            // профиль
    case profileGifts       // подарки в профиле
    case inlineButtons      // инлайн-кнопки ботов
    case tabBar             // нижний таббар
    case navigationBar      // верхний навбар
    case inputPanel         // поле ввода текста
    case search             // поиск
    case buttons            // обычные кнопки
    case popup              // попапы / листы
    case contextMenu        // контекстное меню
    case reactions          // реакции на сообщения
    case stickers           // панель стикеров / эмодзи
    case calls              // экран звонков
    case media              // медиа-просмотрщик
    case chatList           // список чатов

    public var isEnabled: Bool {
        let s = SGSimpleSettings.shared
        guard s.liquidGlassEnabled else { return false }
        switch self {
        case .messages:          return s.namelessLiquidGlassMessages
        case .outgoingMessages:  return s.namelessLiquidGlassOutgoingMessages
        case .settings:          return s.namelessLiquidGlassSettings
        case .profile:           return s.namelessLiquidGlassProfile
        case .profileGifts:      return s.namelessLiquidGlassProfileGifts
        case .inlineButtons:     return s.namelessLiquidGlassInlineButtons
        case .popup:             return s.namelessLiquidGlassPopup
        case .contextMenu:       return s.namelessLiquidGlassContextMenu
        case .search:            return s.namelessLiquidGlassSearch
        case .reactions:         return s.namelessLiquidGlassReactions
        case .stickers:          return s.namelessLiquidGlassStickers
        case .calls:             return s.namelessLiquidGlassCalls
        case .media:             return s.namelessLiquidGlassMedia
        case .chatList:          return s.namelessLiquidGlassChatList
        case .tabBar,
             .navigationBar,
             .inputPanel,
             .buttons:           return true
        }
    }

    public var isTinted: Bool {
        SGSimpleSettings.shared.namelessLiquidGlassTinting
    }

    public var intensity: CGFloat {
        CGFloat(SGSimpleSettings.shared.namelessLiquidGlassIntensity)
    }

    public var fadeAnimationEnabled: Bool {
        SGSimpleSettings.shared.namelessLiquidGlassFadeAnimation
    }
}

// MARK: - Glass Radii

public struct GlassRadii: Equatable {
    public let topLeft: CGFloat
    public let topRight: CGFloat
    public let bottomLeft: CGFloat
    public let bottomRight: CGFloat

    public init(radius: CGFloat) {
        self.topLeft = radius; self.topRight = radius
        self.bottomLeft = radius; self.bottomRight = radius
    }

    public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft; self.topRight = topRight
        self.bottomLeft = bottomLeft; self.bottomRight = bottomRight
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

public protocol SGLiquidGlassContainer: AnyObject {
    func refreshGlass(zone: SGLiquidGlassZone)
}

public protocol SGLiquidGlassViewContainer: AnyObject {
    func refreshGlass(zone: SGLiquidGlassZone)
}

public protocol SGLiquidGlassViewProtocol: AnyObject {
    var tintColorGlass: UIColor { get set }
    var cornerRadii: GlassRadii { get set }
    var isVisible: Bool { get set }
    func refreshGlass(zone: SGLiquidGlassZone)
}

public extension SGLiquidGlassViewProtocol where Self: UIView {
    func setFrame(_ frame: CGRect) { self.frame = frame }
}

public final class SGLiquidGlassFactory {
    public static let shared = SGLiquidGlassFactory()
    private init() {}
    public var create: (() -> SGLiquidGlassViewProtocol?)?
}

// MARK: - Coordinator

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
        self.notificationObserver = NotificationCenter.default.addObserver(
            forName: .luxgramLiquidGlassDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in self?.refreshAll() }
    }

    deinit {
        if let o = notificationObserver { NotificationCenter.default.removeObserver(o) }
    }

    public func register(node: AnyObject, zone: SGLiquidGlassZone) {
        let id = ObjectIdentifier(node)
        queue.sync { self.observers[id] = Observer(node: node, zone: zone) }
    }

    public func unregister(node: AnyObject) {
        let id = ObjectIdentifier(node)
        queue.sync { _ = self.observers.removeValue(forKey: id) }
    }

    public func refreshAll() {
        var snapshot: [Observer] = []
        queue.sync { snapshot = Array(self.observers.values) }
        for obs in snapshot {
            if let n = obs.node as? SGLiquidGlassContainer {
                n.refreshGlass(zone: obs.zone)
            } else if let v = obs.node as? SGLiquidGlassViewContainer {
                v.refreshGlass(zone: obs.zone)
            }
        }
    }
}
