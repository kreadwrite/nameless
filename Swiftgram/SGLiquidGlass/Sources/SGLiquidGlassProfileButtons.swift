import Foundation
import UIKit
import SGLiquidGlassCore
import SGSimpleSettings

// MARK: - Round Glass Profile Button

/// Replaces flat square profile action buttons (Call, Video, Mute, Search, More)
/// with the glass-circle style from screenshot 2.
/// Drop this into the same container as the existing profile action buttons
/// and it wraps them in glass circles.
public final class SGGlassCircleButton: UIView, SGLiquidGlassViewContainer {

    // MARK: Public

    public var icon: UIImage? {
        didSet { imageView.image = icon?.withRenderingMode(.alwaysTemplate) }
    }

    public var title: String? {
        didSet { titleLabel.text = title }
    }

    public var tintColorButton: UIColor = .systemBlue {
        didSet {
            imageView.tintColor = tintColorButton
        }
    }

    public var action: (() -> Void)?

    // MARK: Private

    private let glassView: SGLiquidGlassView
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: Init

    public init(icon: UIImage?, title: String?, accentColor: UIColor = .systemBlue) {
        self.glassView = SGLiquidGlassView()
        self.tintColorButton = accentColor
        super.init(frame: .zero)
        self.icon = icon
        self.title = title
        self.setupUI()
        SGLiquidGlassCoordinator.shared.register(node: self, zone: .profile)
    }

    required init?(coder: NSCoder) { fatalError() }

    deinit {
        SGLiquidGlassCoordinator.shared.unregister(node: self)
    }

    // MARK: Setup

    private func setupUI() {
        backgroundColor = .clear

        // Glass background — full circle
        addSubview(glassView)

        // Icon
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = tintColorButton
        imageView.image = icon?.withRenderingMode(.alwaysTemplate)
        addSubview(imageView)

        // Title label below
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)

        // Tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)

        // Long press feedback
        let press = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        press.minimumPressDuration = 0
        addGestureRecognizer(press)

        updateGlassState()
    }

    private func updateGlassState() {
        let enabled = SGSimpleSettings.shared.namelessRoundProfileButtons && SGLiquidGlassZone.profile.isEnabled
        glassView.isHidden = !enabled
        layer.cornerRadius = enabled ? (bounds.width / 2) : 14
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let iconSize: CGFloat = w * 0.44
        let glassSize: CGFloat = w - 0           // full width = circle diameter
        let labelH: CGFloat = 16

        glassView.frame = CGRect(x: 0, y: 0, width: glassSize, height: glassSize)
        glassView.cornerRadii = GlassRadii(radius: glassSize / 2)

        imageView.frame = CGRect(
            x: (glassSize - iconSize) / 2,
            y: (glassSize - iconSize) / 2,
            width: iconSize, height: iconSize
        )
        titleLabel.frame = CGRect(x: 0, y: glassSize + 4, width: w, height: labelH)

        layer.cornerRadius = glassSize / 2
        updateGlassState()
    }

    // MARK: Actions

    @objc private func tapped() {
        action?()
    }

    @objc private func longPressed(_ g: UILongPressGestureRecognizer) {
        UIView.animate(withDuration: 0.12) {
            self.transform = g.state == .began
                ? CGAffineTransform(scaleX: 0.92, y: 0.92)
                : .identity
        }
    }

    // MARK: SGLiquidGlassViewContainer

    public func refreshGlass(zone: SGLiquidGlassZone) {
        UIView.animate(withDuration: zone.fadeAnimationEnabled ? 0.28 : 0) {
            self.glassView.refreshGlass(zone: zone)
            self.updateGlassState()
        }
    }
}

// MARK: - Glass Tab Bar Background

/// Sits behind the native UITabBar icons and makes them float on liquid glass.
/// Add as a subview *below* the tab bar's icon layer.
public final class SGLiquidGlassTabBarBackground: UIView, SGLiquidGlassViewContainer {
    private let glassView: SGLiquidGlassView

    public init(cornerRadius: CGFloat = 22) {
        self.glassView = SGLiquidGlassView()
        self.glassView.cornerRadii = GlassRadii(radius: cornerRadius)
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(glassView)
        SGLiquidGlassCoordinator.shared.register(node: self, zone: .tabBar)
    }

    required init?(coder: NSCoder) { fatalError() }

    deinit { SGLiquidGlassCoordinator.shared.unregister(node: self) }

    public override func layoutSubviews() {
        super.layoutSubviews()
        glassView.frame = bounds
        glassView.cornerRadii = GlassRadii(radius: layer.cornerRadius)
    }

    public func refreshGlass(zone: SGLiquidGlassZone) {
        glassView.refreshGlass(zone: zone)
        isHidden = !zone.isEnabled
    }
}

// MARK: - Glass Navigation Bar Background

/// Blur/glass overlay for navigation bars.
public final class SGLiquidGlassNavBarBackground: UIView, SGLiquidGlassViewContainer {
    private let glassView: SGLiquidGlassView

    public init() {
        self.glassView = SGLiquidGlassView()
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(glassView)
        SGLiquidGlassCoordinator.shared.register(node: self, zone: .navigationBar)
    }

    required init?(coder: NSCoder) { fatalError() }
    deinit { SGLiquidGlassCoordinator.shared.unregister(node: self) }

    public override func layoutSubviews() {
        super.layoutSubviews()
        glassView.frame = bounds
    }

    public func refreshGlass(zone: SGLiquidGlassZone) {
        glassView.refreshGlass(zone: zone)
        isHidden = !zone.isEnabled
    }
}

// MARK: - Glass Reactions Panel Background

/// Transparent glass overlay for the emoji reaction picker.
public final class SGLiquidGlassReactionsPanelBackground: UIView, SGLiquidGlassViewContainer {
    private let glassView: SGLiquidGlassView

    public init(cornerRadius: CGFloat = 20) {
        self.glassView = SGLiquidGlassView()
        self.glassView.cornerRadii = GlassRadii(radius: cornerRadius)
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(glassView)
        SGLiquidGlassCoordinator.shared.register(node: self, zone: .reactions)
    }

    required init?(coder: NSCoder) { fatalError() }
    deinit { SGLiquidGlassCoordinator.shared.unregister(node: self) }

    public override func layoutSubviews() {
        super.layoutSubviews()
        glassView.frame = bounds
    }

    public func refreshGlass(zone: SGLiquidGlassZone) {
        glassView.refreshGlass(zone: zone)
        isHidden = !zone.isEnabled
    }
}

// MARK: - Glass Voice Record Button Background

/// Circle glass background for the voice recording button.
public final class SGLiquidGlassVoiceButtonBackground: UIView, SGLiquidGlassViewContainer {
    private let glassView: SGLiquidGlassView

    public init() {
        self.glassView = SGLiquidGlassView()
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(glassView)
        SGLiquidGlassCoordinator.shared.register(node: self, zone: .inputPanel)
    }

    required init?(coder: NSCoder) { fatalError() }
    deinit { SGLiquidGlassCoordinator.shared.unregister(node: self) }

    public override func layoutSubviews() {
        super.layoutSubviews()
        glassView.frame = bounds
        glassView.cornerRadii = GlassRadii(radius: bounds.width / 2)
    }

    public func refreshGlass(zone: SGLiquidGlassZone) {
        glassView.refreshGlass(zone: zone)
        isHidden = !zone.isEnabled
    }
}

// MARK: - Glass Chat List Search Bar

/// Drop-in glass background for the search bar in the chat list.
public final class SGLiquidGlassChatSearchBackground: UIView, SGLiquidGlassViewContainer {
    private let glassView: SGLiquidGlassView

    public init(cornerRadius: CGFloat = 10) {
        self.glassView = SGLiquidGlassView()
        self.glassView.cornerRadii = GlassRadii(radius: cornerRadius)
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(glassView)
        SGLiquidGlassCoordinator.shared.register(node: self, zone: .search)
    }

    required init?(coder: NSCoder) { fatalError() }
    deinit { SGLiquidGlassCoordinator.shared.unregister(node: self) }

    public override func layoutSubviews() {
        super.layoutSubviews()
        glassView.frame = bounds
    }

    public func refreshGlass(zone: SGLiquidGlassZone) {
        glassView.refreshGlass(zone: zone)
        isHidden = !zone.isEnabled
    }
}
