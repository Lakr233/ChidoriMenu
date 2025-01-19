//
//  ChidoriPresentationController.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-15.
//

import UIKit

class ChidoriPresentationController: UIPresentationController {
    let dimmView: UIView = .init()

    protocol Delegate: AnyObject {
        func didTapOverlayView(_ chidoriPresentationController: ChidoriPresentationController)
    }

    weak var transitionDelegate: Delegate?

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView else { return }

        dimmView.translatesAutoresizingMaskIntoConstraints = false
        dimmView.isUserInteractionEnabled = true
        dimmView.isAccessibilityElement = true
        dimmView.accessibilityTraits = .button
        dimmView.accessibilityHint = NSLocalizedString("Close Menu", comment: "")
        dimmView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dimmView.alpha = 0.0

        presentingViewController.view.tintAdjustmentMode = .dimmed
        containerView.addSubview(dimmView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: dimmView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: dimmView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: dimmView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: dimmView.bottomAnchor),
        ])

        let tapGesture = UITapGestureRecognizer(target: nil, action: nil)
        tapGesture.addTarget(self, action: #selector(dimmViewTapped))
        dimmView.addGestureRecognizer(tapGesture)

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

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        if completed { dimmView.removeFromSuperview() }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let menu = presentedViewController as? ChidoriMenu else {
            return .zero
        }
        var height = menu.height
        if let heightLimit = containerView?.bounds.height {
            height = min(height, heightLimit * 0.75)
        }
        let menuSize = CGSize(width: ChidoriMenu.width, height: height)
        let originatingPoint = calculateOriginatingPoint(
            summonPoint: menu.summonPoint,
            menuSize: menuSize
        )
        return CGRect(origin: originatingPoint, size: menuSize)
    }

    private func calculateOriginatingPoint(
        summonPoint: CGPoint,
        menuSize: CGSize
    ) -> CGPoint {
        guard let containerView else { return .zero }

        let requiredSidePadding: CGFloat = 10.0
        let offsetFromFinger: CGFloat = 10.0

        let x: CGFloat = {
            // iOS seems to try to shove it to the left of the touch point (if possible)
            // to prevent your finger obscuring the titles
            let attemptedDistanceFromTouchPoint: CGFloat = 180.0

            let leftShiftedPoint = summonPoint.x
                - attemptedDistanceFromTouchPoint
            let lowestPermissableXPosition = requiredSidePadding
                + containerView.safeAreaInsets.left
            let rightMostPermissableXPosition = containerView.bounds.width
                - requiredSidePadding
                - containerView.safeAreaInsets.right
                - menuSize.width
            return min(
                rightMostPermissableXPosition,
                max(leftShiftedPoint, lowestPermissableXPosition)
            )
        }()

        let y: CGFloat = {
            // check if we have enough room to place it below the touch point
            let maxY = summonPoint.y
                + menuSize.height
                + offsetFromFinger
                + requiredSidePadding
            let allowedY = containerView.bounds.height
                - containerView.safeAreaInsets.bottom
            if maxY < allowedY { return summonPoint.y + offsetFromFinger }
            // if not, iOS tries to keep as much in the bottom half of the screen as possible
            // to be closer to where the thumb normally is, presumably
            return containerView.bounds.height
                - requiredSidePadding
                - containerView.safeAreaInsets.bottom
                - menuSize.height

        }()

        return CGPoint(x: x, y: y)
    }

    @objc func dimmViewTapped() {
        transitionDelegate?.didTapOverlayView(self)
    }
}
