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
        let utterance = AVSpeechUtterance(string: "asdasd")
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
    var fingerTouchedDownLocation: CGPoint?
    var framesSinceLastFingerCheck = 0
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
    var isDirectlyInFront = false
    var objectDetected = false
    
    // MARK: Interface
    var cvm: CardsViewModel! /// keep reference to cards
    var drawingView: DrawingView!
    var cardsReferenceView: UIView!
    var cardsReferenceHeightC: NSLayoutConstraint!
    
    // MARK: Audio
    var lineSoundPlayer: AVAudioPlayer?
    var arrivedSoundPlayer: AVAudioPlayer?
    
    // MARK: Accessibility
    var currentOrientation = UIInterfaceOrientation.landscapeLeft
    @IBOutlet weak var orientationBlurView: UIVisualEffectView!
    @IBOutlet weak var orientationButton: UIButton!
    @IBAction func orientationButtonPressed(_ sender: Any) {
        let transform: CGAffineTransform
        let newOrientation: UIInterfaceOrientation
        
        let orientationText: String
        
        switch currentOrientation {
        case .portrait:
            newOrientation = .landscapeRight
            transform = CGAffineTransform(rotationAngle: 90.degreesToRadians)
            orientationText = "Home button left"
        case .portraitUpsideDown:
            newOrientation = .landscapeLeft
            transform = CGAffineTransform(rotationAngle: -90.degreesToRadians)
            
            orientationText = "Home button right"
        case .landscapeLeft:
            newOrientation = .portrait
            transform = CGAffineTransform(rotationAngle: 180.degreesToRadians)
            
            orientationText = "Upside down"
        case .landscapeRight:
            newOrientation = .portraitUpsideDown
            transform = CGAffineTransform(rotationAngle: 0.degreesToRadians)
            
            orientationText = "Portrait"
        default:
            newOrientation = .landscapeRight
            transform = CGAffineTransform(rotationAngle: -90.degreesToRadians)
            
            orientationText = "Home button right"
        }
        
        currentOrientation = newOrientation
        
        orientationDescriptionLabel.text = "ML Orientation: \(orientationText)"
        animatingDescriptionCount += 1
        UIView.animate(withDuration: 0.3) {
            self.orientationButton.transform = transform
            self.orientationDescriptionBlurView.transform = CGAffineTransform.identity
            self.orientationDescriptionBlurView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.animatingDescriptionCount -= 1
            
            if self.animatingDescriptionCount == 0 {
                UIView.animate(withDuration: 0.3) {
                    self.orientationDescriptionBlurView.alpha = 0
                    self.orientationDescriptionBlurView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }
            }
        }
    }
    
    var animatingDescriptionCount = 0
    @IBOutlet weak var orientationDescriptionBlurView: UIVisualEffectView!
    @IBOutlet weak var orientationDescriptionLabel: UILabel!
    
    
    var muted = false
    @IBOutlet weak var speakMuteBlurView: UIVisualEffectView!
    @IBOutlet weak var speakMuteButton: UIButton!
    @IBAction func speakMuteButtonPressed(_ sender: Any) {
        muted.toggle()
        updateMuteButton()
    }
    
    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var speakBlurView: UIVisualEffectView!
    @IBOutlet weak var speakButton: UIButton!
    @IBAction func speakButtonPressed(_ sender: Any) {
        speakStatus()
    }
    
    @IBOutlet weak var speakExpandedBlurView: UIVisualEffectView!
    @IBOutlet weak var speakExpandedLabel: UILabel!
    @IBOutlet weak var speakCloseButton: UIButton!
    @IBAction func speakClosePressed(_ sender: Any) {
        stopSpeaking()
    }
    

    let alertSynthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var alertExpandedBlurView: UIVisualEffectView!
    @IBOutlet weak var alertExpandedLabel: UILabel!
    @IBOutlet weak var alertCloseButton: UIButton!
    @IBAction func alertClosePressed(_ sender: Any) {
        stopSpeakingAlert()
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

