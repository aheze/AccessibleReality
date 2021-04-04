//
//  Utilities.swift
//  MLRealityTest
//
//  Created by Zheng on 4/3/21.
//

import UIKit

class ReceiveTouchView: UIView { }
class PassthroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            ($0 is ReceiveTouchView && $0.point(inside: self.convert(point, to: $0), with: event)) || (
                !$0.isHidden
                && $0.isUserInteractionEnabled
                && $0.point(inside: self.convert(point, to: $0), with: event)
            )
        })
    }
}

extension UIViewController {
    func addChildViewController(_ childViewController: UIViewController, in inView: UIView) {
        /// Add Child View Controller
        addChild(childViewController)
        
        /// Add Child View as Subview
        inView.insertSubview(childViewController.view, at: 0)
        
        /// Configure Child View
        childViewController.view.frame = inView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        /// Notify Child View Controller
        childViewController.didMove(toParent: self)
    }
    func removeChildViewController(_ childViewController: UIViewController) {
        /// Notify Child View Controller
        childViewController.willMove(toParent: nil)

        /// Remove Child View From Superview
        childViewController.view.removeFromSuperview()

        /// Notify Child View Controller
        childViewController.removeFromParent()
    }
}
