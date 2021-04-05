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
    
//    @IBOutlet weak var sceneView: ARSCNView!
    
    var arView: ARView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
//        sceneView.delegate = self
//        sceneView.session.delegate = self
//        sceneView.scene = scene

//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = .vertical
//        sceneView.session.run(config)
//        let arKitSceneView = ARSCNView()
//
//        /// Make voiceover allow directly tapping the scene view.
//        arKitSceneView.isAccessibilityElement = true
//        arKitSceneView.accessibilityTraits = .allowsDirectInteraction
//        arKitSceneView.accessibilityLabel = "Use the rotor to enable Direct Touch"
//
//        /// Add the ARKIT scene view as a subview
//        view.addSubview(arKitSceneView)
//
//        /// Positioning constraints
//        arKitSceneView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            arKitSceneView.topAnchor.constraint(equalTo: view.topAnchor),
//            arKitSceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            arKitSceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            arKitSceneView.leftAnchor.constraint(equalTo: view.leftAnchor)
//        ])
//
//
//
//        /// Configure the AR Session
//        /// This will make ARKit track the device's position and orientation
//        let worldTrackingConfiguration = ARWorldTrackingConfiguration()
//
//        /// Run the configuration
//        arKitSceneView.session.run(worldTrackingConfiguration)
        
        let arView = ARView(frame: CGRect.zero, cameraMode: .ar, automaticallyConfigureSession: true)
        view.addSubview(arView)
        
        /// Positioning constraints
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.rightAnchor.constraint(equalTo: view.rightAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        self.arView = arView
        
        
//        PlaygroundPage.current.liveView = instantiateLiveView()
        PlaygroundPage.current.needsIndefiniteExecution = true
//        let worldTrackingConfiguration = ARWorldTrackingConfiguration()
//        arView.session.run(worldTrackingConfiguration)
    }
    
    
}

