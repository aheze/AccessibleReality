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
    var sceneView: ARSCNView!
    
    var coachingReferenceView: UIView!
    var coachingViewActive = false
    
    // MARK: Vision
    var busyProcessingImage = false
    var currentDetectedObjects = [DetectedObject]()
    
    /// converting rects
    var imageFrameSize = CGSize.zero
    var sceneViewSize = CGSize.zero
    
    // MARK: Crosshair
    var crosshairView: UIView!
    var crosshairImageView: UIImageView!

    var crosshairBusyCalculating = false
    var crosshairCenter = CGPoint.zero
    var currentTargetedObject: DetectedObject? /// current object underneath crosshair
    
    var crosshairContentView: UIView!
    var crosshairCubeSceneView: SCNView!
    var crosshairCubeParticleView: SKView!
    var crosshairCubeNode: SCNNode!
    var crosshairCube: SCNBox!
    
    // MARK: Tracking interface
    var lineLayer: CAShapeLayer?
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var infoBorderView: UIView!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: Tracking markers
    var framesSinceLastTrack = 0 /// only track every 5 frames
    var placedMarkers = [Marker]() /// current placed markers
    var edgePointView: UIView?
    var degreesAway = ""
    var cmAway = ""
    
    
    // MARK: Interface
    var cvm: CardsViewModel! /// keep reference to cards
    var drawingView: DrawingView!
    var cardsReferenceView: UIView!
    var cardsReferenceHeightC: NSLayoutConstraint!
    
    // MARK: Audio
    
    
    // MARK: Accessibility
    var currentOrientation = UIInterfaceOrientation.landscapeLeft
    @IBOutlet weak var orientationBlurView: UIVisualEffectView!
    @IBOutlet weak var orientationButton: UIButton!
    @IBAction func orientationButtonPressed(_ sender: Any) {
        let transform: CGAffineTransform
        switch currentOrientation {
        case .portrait:
            currentOrientation = .landscapeRight
            transform = CGAffineTransform(rotationAngle: 90.degreesToRadians)
        case .portraitUpsideDown:
            currentOrientation = .landscapeLeft
            transform = CGAffineTransform(rotationAngle: -90.degreesToRadians)
        case .landscapeLeft:
            currentOrientation = .portrait
            transform = CGAffineTransform(rotationAngle: 180.degreesToRadians)
        case .landscapeRight:
            currentOrientation = .portraitUpsideDown
            transform = CGAffineTransform(rotationAngle: 0.degreesToRadians)
        default:
            currentOrientation = .landscapeRight
            transform = CGAffineTransform(rotationAngle: -90.degreesToRadians)
        }
        UIView.animate(withDuration: 0.3) {
            self.orientationButton.transform = transform
        }
    }
    
    @IBOutlet weak var speakBlurView: UIVisualEffectView!
    @IBOutlet weak var speakButton: UIButton!
    @IBAction func speakButtonPressed(_ sender: Any) {
        print("speak pressed")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupAR()
        setupViews()
        setupInfoView()
        setupCrosshair()
        
        addCoaching()
        setupCardsView()
        
        setupAccessibility()
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneViewSize = sceneView.bounds.size
        crosshairCenter = crosshairView.center
        
        Positioning.cardContainerHeight = Constants.cardContainerHeight + view.safeAreaInsets.bottom
        cardsReferenceHeightC.constant = Positioning.cardContainerHeight + 40
        
        cvm.safeAreaWidth = view.safeAreaLayoutGuide.layoutFrame.width
    }
    
    
}

