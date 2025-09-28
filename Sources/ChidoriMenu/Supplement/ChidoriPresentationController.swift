//
//  ChidoriPresentationController.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-15.
//

import UIKit

class ChidoriPresentationController: UIPresentationController {
    let dimmView: UIButton = .init()
    var minimalEdgeInset: CGFloat = 10

    protocol Delegate: AnyObject {
        func didTapOverlayView(_ chidoriPresentationController: ChidoriPresentationController)
    }

    weak var transitionDelegate: Delegate?

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentingViewController.view.tintAdjustmentMode = .dimmed

        guard let containerView else { return }
        containerView.addSubview(dimmView)
        dimmView.addTarget(self, action: #selector(dimmViewTapped), for: .touchUpInside)
        dimmView.backgroundColor = MenuLayout.dimmingBackgroundColor

        dimmView.alpha = 0.0
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate { _ in self.dimmView.alpha = 1.0 }
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentingViewController.view.tintAdjustmentMode = .automatic

        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate { _ in self.dimmView.alpha = 0.0 }
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmView.frame = containerView?.bounds ?? .zero
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let menu = presentedViewController as? ChidoriMenu else {
            return .zero
        }
        var height = menu.height
        if let heightLimit = containerView?.bounds.height {
            height = min(height, heightLimit * 0.75)
        }
        let menuSize = CGSize(width: menu.width, height: height)
        let originatingPoint = calculateOriginatingPoint(
            anchorPoint: menu.anchorPoint,
            menuSize: menuSize
        )
        return CGRect(origin: originatingPoint, size: menuSize)
    }

    private func calculateOriginatingPoint(
        anchorPoint: CGPoint,
        menuSize: CGSize
    ) -> CGPoint {
        guard let containerView else { return .zero }

        let x: CGFloat = {
            let requiredMinX = anchorPoint.x - menuSize.width / 2
            let maxPossibleX = minimalEdgeInset
                + containerView.safeAreaInsets.left
            let rightMostPermissableXPosition = containerView.bounds.width
                - minimalEdgeInset
                - containerView.safeAreaInsets.right
                - menuSize.width
            return min(
                rightMostPermissableXPosition,
                max(requiredMinX, maxPossibleX)
            )
        }()

        let y: CGFloat = {
            let maxY = anchorPoint.y + menuSize.height + minimalEdgeInset + MenuLayout.offsetY
            let allowedY = containerView.bounds.height - containerView.safeAreaInsets.bottom
            if maxY < allowedY { return anchorPoint.y + MenuLayout.offsetY /* move below a little bit */ }
            // if not, iOS tries to keep as much in the bottom half of the screen as possible
            // to be closer to where the thumb normally is, presumably
            return containerView.bounds.height
                - minimalEdgeInset
                - containerView.safeAreaInsets.bottom
                - menuSize.height
        }()

        return CGPoint(x: x, y: y)
    }

    @objc func dimmViewTapped() {
        transitionDelegate?.didTapOverlayView(self)
    }
}
