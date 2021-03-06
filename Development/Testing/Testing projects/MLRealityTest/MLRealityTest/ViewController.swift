//
//  ViewController.swift
//  MLRealityTest
//
//  Created by Zheng on 4/2/21.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    // MARK: ARKit
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var coachingReferenceView: UIView!
    var coachingViewActive = false
    
    // MARK: Vision
    var busyProcessingImage = false
    var currentDetectedObjects = [DetectedObject]()
    
    
    /// converting rects
    var imageFrameSize = CGSize.zero
    var sceneViewSize = CGSize.zero
    
    // MARK: Crosshair
    @IBOutlet weak var crosshairView: UIView!
    @IBOutlet weak var crosshairImageView: UIImageView!
    var crosshairBusyCalculating = false
    var crosshairCenter = CGPoint.zero
    
    var currentTargetedObject: DetectedObject? /// current object underneath crosshair
    
    // MARK: Tracking markers
    var framesSinceLastTrack = 0 /// only track every 5 frames
    var placedMarkers = [Marker]() /// current placed markers
    
    // MARK: Tracking interface
    var lineLayer: CAShapeLayer?
    
    
    
    // MARK: Interface
    var vm: CardsViewModel! /// keep reference to cards
    @IBOutlet weak var drawingView: UIView!
    @IBOutlet weak var cardsReferenceView: UIView!
    @IBOutlet weak var cardsReferenceHeightC: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAR()
        addCoaching()
        setupCardsView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneViewSize = sceneView.bounds.size
        crosshairCenter = crosshairView.center
        
        Positioning.cardContainerHeight = Constants.cardContainerHeight + view.safeAreaInsets.bottom
        cardsReferenceHeightC.constant = Positioning.cardContainerHeight + 40
        
        Positioning.safeAreaWidth = view.safeAreaLayoutGuide.layoutFrame.width
    }
}
