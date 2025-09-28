//
//  ChidoriMenu.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-15.
//

import UIKit

class ChidoriMenu: UIViewController {
    let tableView: UITableView
    var dataSource: DataSourceContents = []

    let menu: UIMenu
    let anchorPoint: CGPoint

    let backgroundView = UIView()
    let shadowView = UIView()
    let panGestureRecognizer: UIPanGestureRecognizer = .init()

    var transitionController: ChidoriAnimationController?
    private var resolvedWidth: CGFloat?

    var width: CGFloat {
        if let resolvedWidth { return resolvedWidth }
        let computedWidth = calculateMenuWidth()
        resolvedWidth = computedWidth
        return computedWidth
    }

    var height: CGFloat {
        let measuredHeight = tableView.sizeThatFits(
            CGSize(
                width: width,
                height: CGFloat.greatestFiniteMagnitude
            )
        ).height.rounded(.up)

        guard
            let controller = presentationController as? ChidoriPresentationController,
            let containerView = controller.containerView
        else {
            return measuredHeight
        }

        let safeArea = containerView.safeAreaInsets
        let maximumHeight = max(
            MenuLayout.minRowHeight,
            containerView.bounds.height
                - controller.minimalEdgeInset * 2
                - safeArea.top
                - safeArea.bottom
        )

        return min(measuredHeight, maximumHeight)
    }

    private var anchorViewToFrame: CGRect?

    var presentingParent: UIViewController? {
        var parent: UIViewController? = presentingViewController
        while let superMenu = parent as? ChidoriMenu {
            parent = superMenu.presentingViewController
        }
        return parent
    }

    var menuStackScaleFactor: CGFloat = 1.0 {
        didSet { Spring.animate { [self] in
            let factor = menuStackScaleFactor
            view.transform = CGAffineTransform(scaleX: factor, y: factor)
            view.layoutIfNeeded()
        } }
    }

    required init(menu: UIMenu, anchorPoint: CGPoint) {
        self.menu = menu
        self.anchorPoint = anchorPoint

        tableView = TableView(frame: .zero, style: .plain)

        tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        super.init(nibName: nil, bundle: nil)

        tableView.dataSource = self

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false

        shadowView.backgroundColor = ChidoriMenuConfiguration.backgroundColor
        shadowView.layer.shadowColor = UIColor { provider in
            switch provider.userInterfaceStyle {
            case .dark: UIColor.black.withAlphaComponent(0.25)
            default: UIColor.black.withAlphaComponent(0.1)
            }
        }.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 8
        shadowView.layer.cornerRadius = MenuLayout.cornerRadius
        view.addSubview(shadowView)

        backgroundView.backgroundColor = ChidoriMenuConfiguration.backgroundColor
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = MenuLayout.cornerRadius
        backgroundView.layer.cornerCurve = .continuous
        view.addSubview(backgroundView)

        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = true
        if #available(iOS 14.0, macCatalyst 14.0, *) {
            tableView.selectionFollowsFocus = true
        }
        if #available(iOS 15.0, macCatalyst 15.0, *) {
            tableView.allowsFocus = false
            tableView.sectionHeaderTopPadding = Self.sectionTopPadding
        }
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(
            top: MenuLayout.cornerRadius,
            left: 0.0,
            bottom: MenuLayout.cornerRadius,
            right: 0.0
        )
        backgroundView.addSubview(tableView)

        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0

        panGestureRecognizer.addTarget(
            self,
            action: #selector(panned(panGestureRecognizer:))
        )
        panGestureRecognizer.cancelsTouchesInView = true
        tableView.addGestureRecognizer(panGestureRecognizer)

        updateDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let haptic = ChidoriMenuConfiguration.hapticFeedback {
            UIImpactFeedbackGenerator(style: haptic).impactOccurred()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionController = nil
        tableView.becomeFirstResponder()
    }

    func anchor(to frame: CGRect) {
        anchorViewToFrame = frame
        view.setNeedsLayout()
    }

    func removeAnchor() {
        anchorViewToFrame = nil
    }

    @objc func escapePressed() {
        dismiss(animated: true)
    }

    override open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            guard let key = press.key else { continue }
            if key.keyCode == .keyboardEscape {
                escapePressed()
                return
            }
        }
        super.pressesBegan(presses, with: event)
    }

    override var preferredContentSize: CGSize {
        get {
            CGSize(width: width, height: height)
        }
        set { assertionFailure() }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let anchorViewToFrame { view.frame = anchorViewToFrame }

        backgroundView.frame = view.bounds
        let contentFrame = backgroundView.bounds
        tableView.separatorStyle = .none
        tableView.frame = .init(
            x: contentFrame.minX,
            y: contentFrame.minY,
            width: contentFrame.width,
            height: contentFrame.height
        )

        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: .init(
                x: 0,
                y: 0,
                width: width,
                height: tableView.frame.height
            ),
            cornerRadius: MenuLayout.cornerRadius
        ).cgPath

        let isTableViewNotFullyVisible = tableView.contentSize.height > view.bounds.height
        tableView.isScrollEnabled = isTableViewNotFullyVisible
        panGestureRecognizer.isEnabled = !isTableViewNotFullyVisible
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        var superController: UIViewController? = presentingViewController
        while let menu = superController as? ChidoriMenu {
            menu.menuStackScaleFactor = min(1.0, menu.menuStackScaleFactor + MenuLayout.stackScaleFactor)
            superController = menu.presentingViewController
        }
        super.dismiss(animated: flag, completion: completion)
    }

    func dismissIfEmpty() {
        let count = dataSource.reduce(0) { $0 + $1.contents.count }
        guard count <= 0 else { return }
        dismiss(animated: true)
    }

    func forEachMenuInStack(_ execute: @escaping (ChidoriMenu) -> Void) {
        var parent: ChidoriMenu? = self
        while let currentParent = parent {
            execute(currentParent)
            parent = currentParent.presentingViewController as? ChidoriMenu
        }
    }

    private func calculateMenuWidth() -> CGFloat {
        if let suggestedWidth = ChidoriMenuConfiguration.suggestedWidth {
            return suggestedWidth
        }

        let minWidth: CGFloat = 200
        let maxWidth: CGFloat = 320

        var maxContentWidth: CGFloat = minWidth

        for section in dataSource {
            for content in section.contents {
                switch content.content {
                case let .action(action):
                    let textWidth = calculateTextWidth(for: action.title)
                    var itemWidth = MenuLayout.horizontalPadding * 2 + textWidth

                    // Add icon space if present
                    if action.image != nil {
                        itemWidth += MenuLayout.iconSize + MenuLayout.spacing
                    }

                    // Add trailing icon space if present
                    if action.chidoriKeepsMenuPresented || action.state != .off {
                        itemWidth += MenuLayout.iconSize + MenuLayout.spacing
                    }

                    maxContentWidth = max(maxContentWidth, itemWidth)

                case let .submenu(menu):
                    let textWidth = calculateTextWidth(for: menu.title)
                    var itemWidth = MenuLayout.horizontalPadding * 2 + textWidth

                    // Add icon space if present
                    if menu.image != nil {
                        itemWidth += MenuLayout.iconSize + MenuLayout.spacing
                    }

                    // Always add trailing icon for submenus
                    itemWidth += MenuLayout.iconSize + MenuLayout.spacing

                    maxContentWidth = max(maxContentWidth, itemWidth)
                }
            }
        }

        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - 64 // 32 padding on each side

        let calculatedWidth = maxContentWidth + 32
        let finalWidth = min(calculatedWidth, availableWidth)

        return min(max(finalWidth, minWidth), maxWidth)
    }

    private func calculateTextWidth(for text: String) -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
}

public extension UIViewController {
    var isChidoriMenu: Bool {
        self is ChidoriMenu
    }
}
