//
//  ChidoriMenu+Transition.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        transitionController = ChidoriAnimationController(type: .presentation)
        return transitionController
    }

    func interactionControllerForPresentation(
        using _: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        transitionController
    }

    func animationController(
        forDismissed _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        ChidoriAnimationController(type: .dismissal)
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source _: UIViewController
    ) -> UIPresentationController? {
        let controller = ChidoriPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        controller.transitionDelegate = self
        return controller
    }
}

extension ChidoriMenu: ChidoriPresentationController.Delegate {
    func didTapOverlayView(_: ChidoriPresentationController) {
        transitionController?.cancelTransition()
        dismiss(animated: true)
    }
}
