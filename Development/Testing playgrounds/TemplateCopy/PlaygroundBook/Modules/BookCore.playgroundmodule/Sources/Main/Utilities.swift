//
//  Utilities.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import UIKit

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
}


/// degrees to radians helper function
/// from https://stackoverflow.com/a/29179878/14351818
extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

