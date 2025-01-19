//
//  ChidoriMenu.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-15.
//

import UIKit

class ChidoriMenu: UIViewController {
    let tableView: UITableView
    let dataSource: DataSource

    let menu: UIMenu
    let summonPoint: CGPoint
    let useDimmingView: Bool

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    let shadowLayer = CALayer()

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

    init(menu: UIMenu, summonPoint: CGPoint, useDimmingView: Bool = true) {
        self.menu = menu
        self.summonPoint = summonPoint
        self.useDimmingView = useDimmingView

        tableView = .init(frame: .zero, style: .plain)
        dataSource = Self.createDataSource(tableView: tableView)

        tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        tableView.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.layer.masksToBounds = false

        shadowLayer.masksToBounds = false
        shadowLayer.cornerRadius = ChidoriMenu.cornerRadius
        shadowLayer.cornerCurve = .continuous
        shadowLayer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 24
        shadowLayer.shouldRasterize = true
        shadowLayer.rasterizationScale = view.window?.screen.scale ?? UIScreen.main.scale
        view.layer.addSublayer(shadowLayer)

        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = ChidoriMenu.cornerRadius
        blurView.layer.cornerCurve = .continuous
        view.addSubview(blurView)

        tableView.separatorInset = .zero
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
        blurView.contentView.addSubview(tableView)

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionController = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        blurView.frame = view.bounds
        let contentFrame = blurView.contentView.bounds
        tableView.frame = .init(
            x: contentFrame.minX,
            y: contentFrame.minY + 1,
            width: contentFrame.width,
            height: contentFrame.height
        )

        shadowLayer.frame = view.bounds
        shadowLayer.shadowPath = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: ChidoriMenu.cornerRadius
        ).cgPath

        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds

        maskLayer.fillRule = .evenOdd

        // We want this mask to be larger than the shadow layer
        // because the shadow layer draws outside its bounds.
        // Make it suitably large enough to cover the shadow radius,
        // which anecdotally seems approximately double the radius.
        let mainPath = UIBezierPath(
            roundedRect: CGRect(
                x: -ChidoriMenu.shadowRadius * 2.0,
                y: -ChidoriMenu.shadowRadius * 2.0,
                width: view.bounds.width + ChidoriMenu.shadowRadius * 4.0,
                height: view.bounds.height + ChidoriMenu.shadowRadius * 4.0
            ),
            cornerRadius: ChidoriMenu.cornerRadius
        )

        let maskOutPath = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: ChidoriMenu.cornerRadius
        )
        mainPath.append(maskOutPath)
        maskLayer.path = mainPath.cgPath
        shadowLayer.mask = maskLayer

        let isTableViewNotFullyVisible = tableView.contentSize.height > view.bounds.height
        tableView.isScrollEnabled = isTableViewNotFullyVisible
        panGestureRecognizer.isEnabled = !isTableViewNotFullyVisible
    }

    func dismissIfEmpty() {
        var count = 0
        for idx in 0 ..< dataSource.numberOfSections(in: tableView) {
            count += dataSource.tableView(tableView, numberOfRowsInSection: idx)
        }
        guard count <= 0 else { return }
        dismiss(animated: true)
    }

    func dismissToRoot() {
        var popper: UIViewController? = self
        while let controller = popper as? ChidoriMenu {
            popper = controller.presentingViewController
            controller.dismiss(animated: true)
        }
    }
}
