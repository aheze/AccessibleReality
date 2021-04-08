//
//  MainViewController.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import PlaygroundSupport
import ARKit

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
//    var arView: ARView!
    var sceneView: ARSCNView!
    
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

    var crosshairBusyCalculating = false
    var crosshairCenter = CGPoint.zero
    
    var currentTargetedObject: DetectedObject? /// current object underneath crosshair
    
    // MARK: Tracking markers
    var framesSinceLastTrack = 0 /// only track every 5 frames
    var currentTrackingMarker: Marker?
    var placedMarkers = [Marker]() /// current placed markers
    
    // MARK: Tracking interface
    var lineLayer: CAShapeLayer?
    
    // MARK: Interface
    var cardsView: CardsView?
    var drawingView: UIView!
    var cardsReferenceView: UIView!
    var cardsReferenceHeightC: NSLayoutConstraint!
 
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupAR()
        setupViews()
        
//        arView.session.delegate = self
        addCoaching()
        setupCardsView()
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        arViewSize = sceneView.bounds.size
        crosshairCenter = crosshairView.center
        
        Positioning.cardContainerHeight = Constants.cardContainerHeight + view.safeAreaInsets.bottom
        cardsReferenceHeightC.constant = Positioning.cardContainerHeight + 40
        
    }
    
    
}

