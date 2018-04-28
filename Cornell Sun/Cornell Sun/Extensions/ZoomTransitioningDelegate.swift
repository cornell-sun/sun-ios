//
//  ZoomTransitioningDelegate.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/28/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ZoomingViewController {
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView?
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView?
}

enum TransitionState {
    case initial
    case final
}

class ZoomTransitioningDelegate: NSObject {
    var transitionDuration = 0.8
    var operation: UINavigationControllerOperation = .none

    private let zoomScale: CGFloat = 15.0
    private let backgroundScale: CGFloat = 0.8

    typealias ZoomingViews = (otherView: UIView, imageView: UIView)

    func configureViews(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews) {
        switch state {
        case .initial:

            // set the initial state of the background view and its image view
            backgroundViewController.view.transform = CGAffineTransform.identity
            backgroundViewController.view.alpha = 1

            snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)

        case .final:
            // make the background view shrink down to backgroundScale
            backgroundViewController.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale)
            backgroundViewController.view.alpha = 0

            snapshotViews.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, from: viewsInForeground.imageView.superview)
        }
    }
}

extension ZoomTransitioningDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        }
        return nil
    }
}

extension ZoomTransitioningDelegate: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView

        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController

        if operation == .pop {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }

        let maybeBackgroundImageView = (backgroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)
        let maybeForegroundImageView = (foregroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)

        assert(maybeBackgroundImageView != nil, "Cannot find image view in backgroundVC")
        assert(maybeForegroundImageView != nil, "Cannot find imageView in foregroundVC")

        let backgroundImageView = maybeForegroundImageView!
        let foregroundImageView = maybeForegroundImageView!

        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        imageViewSnapshot.contentMode = .scaleAspectFill
        imageViewSnapshot.layer.masksToBounds = true

        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        let foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor
        foregroundViewController.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(backgroundViewController.view)
        containerView.addSubview(foregroundViewController.view)
        containerView.addSubview(imageViewSnapshot)

        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final

        if operation == .pop {
            preTransitionState = .final
            postTransitionState = .initial
        }

        configureViews(for: preTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))

        foregroundViewController.view.layoutIfNeeded()

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {

            self.configureViews(for: postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))

        }) { (finished) in
            backgroundViewController.view.transform = CGAffineTransform.identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
