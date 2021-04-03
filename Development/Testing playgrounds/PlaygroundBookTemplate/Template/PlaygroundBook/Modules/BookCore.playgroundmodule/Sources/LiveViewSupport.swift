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
public func instantiateLiveView() -> PlaygroundLiveViewable {
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)


//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "BookCore_LiveViewController") as? LiveViewController {
        
        return viewController
    } else {
        fatalError("LiveView.storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
    }

//    guard let liveViewController = viewController as? LiveViewController else {
//        fatalError("LiveView.storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
//    }

}
