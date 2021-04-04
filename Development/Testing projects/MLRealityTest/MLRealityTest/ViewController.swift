//
//  ViewController.swift
//  MLRealityTest
//
//  Created by Zheng on 4/2/21.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    // MARK: ARKit
    @IBOutlet var arView: ARView!
    @IBOutlet weak var coachingReferenceView: UIView!
    var coachingViewActive = false
    
    // MARK: Vision
    var busyProcessingImage = false
    var currentDetectedObjects = [DetectedObject]()
    
    
    /// converting rects
    var pixelBufferSize = CGSize.zero
    var arViewSize = CGSize.zero
    
    // MARK: Crosshair
    @IBOutlet weak var crosshairView: UIView!
    @IBOutlet weak var crosshairImageView: UIImageView!
    var crosshairBusyCalculating = false
    
    var currentTargetedObject: DetectedObject? /// current object underneath crosshair
    
    // MARK: Tracking markers
    var framesSinceLastTrack = 0 /// only track every 5 frames
    var currentTrackingMarker: Marker?
    var placedMarkers = [Marker]() /// current placed markers
    
    
    
    // MARK: Interface
    @IBOutlet weak var drawingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        arView.session.delegate = self
        addCoaching()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        arViewSize = arView.bounds.size
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let object = currentTargetedObject {
            addMarker(at: object.convertedBoundingBox, name: object.name)
        } else {
            let middleOfCrossHair = crosshairView.center
            addMarker(at: middleOfCrossHair)
        }
    }
}

extension ViewController: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .anyPlane
        
        coachingReferenceView.addSubview(coachingOverlay)
        coachingReferenceView.isUserInteractionEnabled = false
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            coachingOverlay.topAnchor.constraint(equalTo: coachingReferenceView.topAnchor),
            coachingOverlay.rightAnchor.constraint(equalTo: coachingReferenceView.rightAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: coachingReferenceView.bottomAnchor),
            coachingOverlay.leftAnchor.constraint(equalTo: coachingReferenceView.leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingViewActive = true
    }
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingViewActive = false
    }
}
