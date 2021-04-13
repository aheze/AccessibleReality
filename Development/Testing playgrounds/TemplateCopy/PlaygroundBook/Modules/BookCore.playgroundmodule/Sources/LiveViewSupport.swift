//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
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
    
//    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
//
//    guard let viewController = storyboard.instantiateInitialViewController() else {
//        fatalError("LiveView.storyboard does not have an initial scene; please set one or update this function")
//    }
//
//    guard let liveViewController = viewController as? MainViewController else {
//        fatalError("LiveView.storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
//    }
//
//    return liveViewController
}

public func instantiateOneLiveView() -> PlaygroundLiveViewable {
    
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_OneViewController") as? OneViewController {
        return viewController
    }
    
    fatalError("instantiateOneLiveView failed")
}


