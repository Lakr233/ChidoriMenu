//
//  ChidoriAnimationController.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-15.
//

import UIKit

private typealias ChidoriDelegateProtocol = AnyObject
    & UIViewControllerAnimatedTransitioning
    & UIViewControllerInteractiveTransitioning

class ChidoriAnimationController: NSObject, ChidoriDelegateProtocol {
    enum AnimationControllerType { case presentation, dismissal }

    let type: AnimationControllerType
    var animator: UIViewPropertyAnimator?

    weak var context: UIViewControllerContextTransitioning?

    init(type: AnimationControllerType) {
        self.type = type
    }

    func transitionDuration(
        using _: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        switch type {
        case .presentation:
            0.4
        case .dismissal:
            0.3
        }
    }

    func startInteractiveTransition(
        _ transitionContext: UIViewControllerContextTransitioning
    ) {
        context = transitionContext
        animateTransition(using: transitionContext)
    }

    func cancelTransition() {
        guard let context, let animator else { return }
        context.cancelInteractiveTransition()
        animator.isReversed = true
        animator.startAnimation()

        guard type == .presentation else { return }
        if let presentingController = context.viewController(forKey: .from) {
            presentingController.view.tintAdjustmentMode = .automatic
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let interruptableAnimator = interruptibleAnimator(using: transitionContext)

        switch type {
        case .presentation:
            if let menu = transitionContext.viewController(
                forKey: .to
            ) as? ChidoriMenu { transitionContext.containerView.addSubview(menu.view) }

            if let presentingController = transitionContext.viewController(
                forKey: .from
            ) { presentingController.view.tintAdjustmentMode = .dimmed }
        case .dismissal:
            if let presentingController = transitionContext.viewController(
                forKey: .to
            ) { presentingController.view.tintAdjustmentMode = .automatic }
        }

        interruptableAnimator.startAnimation()
    }

    func interruptibleAnimator(
        using context: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        if let animator { return animator }

        let propertyAnimator = UIViewPropertyAnimator(
            duration: transitionDuration(using: context),
            dampingRatio: 0.75
        )
        propertyAnimator.isInterruptible = true
        propertyAnimator.isUserInteractionEnabled = true

        let isPresenting = type == .presentation

        guard let menu = (
            isPresenting
                ? context.viewController(forKey: .to)
                : context.viewController(forKey: .from)
        ) as? ChidoriMenu else {
            preconditionFailure()
        }

        let finalFrame = context.finalFrame(for: menu)
        menu.view.frame = finalFrame

        // Rather than moving the origin of the view's frame for the animation (which is causing issues with jumpiness), just translate the view temporarily.
        // Accomplish this by finding out how far we have to translate it by creating a reference point from the center of the menu we're moving, and compare that to the center point of where we're moving it to (we're moving it to a specific coordinate, not a frame, so the center point is the same as the coordinate)
        let translationRequired = calculateTranslationRequired(
            forChidoriMenuFrame: finalFrame,
            toDesiredPoint: menu.summonPoint
        )

        let initialAlpha: CGFloat = isPresenting ? 0.0 : 1.0
        let finalAlpha: CGFloat = isPresenting ? 1.0 : 0.0

        let transform = CGAffineTransform(
            translationX: translationRequired.dx,
            y: translationRequired.dy
        ).scaledBy(x: 0.25, y: 0.05)
        let initialTransform = isPresenting ? transform : .identity
        let finalTransform = isPresenting ? .identity : transform

        menu.view.transform = initialTransform
        menu.view.alpha = initialAlpha

        propertyAnimator.addAnimations {
            menu.view.transform = finalTransform
            menu.view.alpha = finalAlpha
        }

        propertyAnimator.addCompletion { _ in
            context.completeTransition(!context.transitionWasCancelled)
            self.animator = nil
        }

        animator = propertyAnimator
        return propertyAnimator
    }

    private func calculateTranslationRequired(
        forChidoriMenuFrame chidoriMenuFrame: CGRect,
        toDesiredPoint desiredPoint: CGPoint
    ) -> CGVector {
        let centerPointOfMenuView = CGPoint(
            x: chidoriMenuFrame.origin.x + (chidoriMenuFrame.width / 2),
            y: chidoriMenuFrame.origin.y + (chidoriMenuFrame.height / 2)
        )
        let translationRequired = CGVector(
            dx: desiredPoint.x - centerPointOfMenuView.x,
            dy: desiredPoint.y - centerPointOfMenuView.y
        )
        return translationRequired
    }
}
