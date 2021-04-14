//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import SceneKit
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
public func instantiateMainLiveView() -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_MainViewController") as? MainViewController {
        return viewController
    }
    
    fatalError("instantiateMainLiveView failed")
    
}

public func instantiateOneLiveView() -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_OneViewController") as? OneViewController {
        return viewController
    }
    
    fatalError("instantiateOneLiveView failed")
}

public func instantiateTwoLiveView() -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_TwoViewController") as? TwoViewController {
        return viewController
    }
    
    fatalError("instantiateOneLiveView failed")
}

public func instantiateOneMainView(block: @escaping ((SCNView, CGPoint) -> Value?)) -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_OneViewController") as? OneViewController {
        viewController.isLive = false
        viewController.hitTest = { (sceneView, point) in
            return block(sceneView, point)
        }
        return viewController
    }
    
    fatalError("instantiateOneLiveView failed")
}



