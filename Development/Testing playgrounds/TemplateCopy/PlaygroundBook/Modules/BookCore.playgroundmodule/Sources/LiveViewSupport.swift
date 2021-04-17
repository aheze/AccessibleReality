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
public func instantiateTwoMainView(block: @escaping ((SCNView, Value, Value) -> (Node, Node))) -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_TwoViewController") as? TwoViewController {
        viewController.isLive = false
        viewController.mainCode = { (sceneView, slider1Value, slider2Value) in
            return block(sceneView, slider1Value, slider2Value)
        }
        return viewController
    }
    
    fatalError("instantiateOneLiveView failed")
}

public func instantiateThreeLiveView() -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_ThreeViewController") as? ThreeViewController {
        return viewController
    }
    
    fatalError("instantiateOneLiveView failed")
}

public func instantiateThreeMainView(block: @escaping ((Node, Node, Node) -> Void)) -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_ThreeViewController") as? ThreeViewController {
        viewController.isLive = false
        viewController.mainCode = { (cameraNode, cubeNode, directionNode) in
            block(cameraNode, cubeNode, directionNode)
        }
        return viewController
    }
    
    fatalError("instantiateOneLiveView failed")
}





