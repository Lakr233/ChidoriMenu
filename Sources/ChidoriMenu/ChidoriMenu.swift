//
//  ChidoriMenu.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-15.
//

import UIKit

class ChidoriMenu: UIViewController {
    let tableView: UITableView
    var dataSource: DataSource!

    let menu: UIMenu
    let anchorPoint: CGPoint

    let backgroundView = UIView()
    let shadowView = UIView()
    let panGestureRecognizer: UIPanGestureRecognizer = .init()

    var transitionController: ChidoriAnimationController?
    var height: CGFloat {
        tableView.sizeThatFits(
            CGSize(
                width: ChidoriMenu.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        ).height.rounded(.up)
    }

    override var keyCommands: [UIKeyCommand]? {
        [
                UIKeyCommand(
                    title: "Dismiss",
                    action: #selector(escapePressed), // escape
                    input: "\u{1b}",
                    modifierFlags: [],
                    propertyList: nil
                ),
        ]
    }
    
    private var anchorViewToFrame: CGRect? = nil

    var presentingParent: UIViewController? {
        var parent: UIViewController? = presentingViewController
        while let superMenu = parent as? ChidoriMenu {
            parent = superMenu.presentingViewController
        }
        return parent
    }

    var menuStackScaleFactor: CGFloat = 1.0 {
        didSet { UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.8
        ) { [self] in
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
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension

        super.init(nibName: nil, bundle: nil)

        dataSource = DataSource(
            tableView: tableView
        ) { [weak self] _, indexPath, _ -> UITableViewCell? in
            guard let self else { return nil }
            return cell(forRowAtIndex: indexPath, dataSource: dataSource)
        }

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) { fatalError() }

    override public func viewDidLoad() {
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
        shadowView.layer.cornerRadius = ChidoriMenu.cornerRadius
        view.addSubview(shadowView)

        backgroundView.backgroundColor = ChidoriMenuConfiguration.backgroundColor
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = ChidoriMenu.cornerRadius
        backgroundView.layer.cornerCurve = .continuous
        view.addSubview(backgroundView)

        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.selectionFollowsFocus = true
        tableView.allowsSelection = true
        tableView.allowsFocus = false
        tableView.sectionHeaderTopPadding = Self.sectionTopPadding
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(
            top: ChidoriMenu.cornerRadius,
            left: 0.0,
            bottom: ChidoriMenu.cornerRadius,
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

        updateSnapshot()
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
    }

    func anchorView(frame: CGRect) {
        anchorViewToFrame = frame
        view.setNeedsLayout()
    }

    func unlockViewFrame() {
        anchorViewToFrame = nil
    }
    
    @objc func escapePressed() {
        dismiss(animated: true)
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
                width: ChidoriMenu.width,
                height: tableView.frame.height
            ),
            cornerRadius: ChidoriMenu.cornerRadius
        ).cgPath

        let isTableViewNotFullyVisible = tableView.contentSize.height > view.bounds.height
        tableView.isScrollEnabled = isTableViewNotFullyVisible
        panGestureRecognizer.isEnabled = !isTableViewNotFullyVisible
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        var superController: UIViewController? = presentingViewController
        while let menu = superController as? ChidoriMenu {
            menu.menuStackScaleFactor = min(1.0, menu.menuStackScaleFactor + ChidoriMenu.stackScaleFactor)
            superController = menu.presentingViewController
        }
        super.dismiss(animated: flag, completion: completion)
    }

    func dismissIfEmpty() {
        var count = 0
        for idx in 0 ..< dataSource.numberOfSections(in: tableView) {
            count += dataSource.tableView(tableView, numberOfRowsInSection: idx)
        }
        guard count <= 0 else { return }
        dismiss(animated: true)
    }

    func iterateMenusInStack(_ executing: @escaping (ChidoriMenu) -> Void) {
        var parent: ChidoriMenu? = self
        while let currentParent = parent {
            executing(currentParent)
            parent = currentParent.presentingViewController as? ChidoriMenu
        }
    }
}

public extension UIViewController {
    var isChidoriMenu: Bool {
        self is ChidoriMenu
    }
}
