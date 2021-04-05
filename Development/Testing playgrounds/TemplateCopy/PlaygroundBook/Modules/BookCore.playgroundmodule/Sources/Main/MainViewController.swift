//
//  MainViewController.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import PlaygroundSupport
import ARKit
import RealityKit

@objc(BookCore_MainViewController)
public class MainViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    /*
    public func liveViewMessageConnectionOpened() {
        // Implement this method to be notified when the live view message connection is opened.
        // The connection will be opened when the process running Contents.swift starts running and listening for messages.
    }
    */

    /*
    public func liveViewMessageConnectionClosed() {
        // Implement this method to be notified when the live view message connection is closed.
        // The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
        // This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
    }
    */

    public func receive(_ message: PlaygroundValue) {
        // Implement this method to receive messages sent from the process running Contents.swift.
        // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
        // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
    }
    

    // MARK: AR views
    var arView: ARView!
    var coachingReferenceView: UIView!
    var coachingViewActive = false
    
    // MARK: Vision
    var busyProcessingImage = false
    var currentDetectedObjects = [DetectedObject]()
    
    /// converting rects
    var pixelBufferSize = CGSize.zero
    var arViewSize = CGSize.zero
    
    // MARK: Crosshair
    var crosshairView: UIView!
    var crosshairImageView: UIImageView!
    var currentTargetedObject: DetectedObject? /// current object underneath crosshair
    
    // MARK: Tracking markers
    var framesSinceLastTrack = 0 /// only track every 5 frames
    var currentTrackingMarker: Marker?
    var placedMarkers = [Marker]() /// current placed markers
    
    var cardsReferenceView: UIView!
    var cardsReferenceHeightC: NSLayoutConstraint!
 
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    
}

