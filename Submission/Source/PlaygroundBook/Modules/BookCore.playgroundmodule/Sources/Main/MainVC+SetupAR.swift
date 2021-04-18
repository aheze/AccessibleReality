//
//  MainVC+SetupAR.swift
//  BookCore
//
//  Created by Zheng on 4/7/21.
//

import UIKit
import ARKit

extension MainViewController {
    func setupAR() {
        // MARK: AR View
        let sceneView = ARSCNView(frame: CGRect.zero)
        
        view.addSubview(sceneView)
        
        /// Positioning constraints
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
        sceneView.session.delegate = self /// for processing each frame
        sceneView.delegate = self /// for providing the node
        sceneView.autoenablesDefaultLighting = true
        
        /// Configure positional audio in the AR Scene view
        sceneView.audioEnvironmentNode.distanceAttenuationParameters.maximumDistance = 4 /// how many meters to adjust the sound in fragments
        sceneView.audioEnvironmentNode.distanceAttenuationParameters.referenceDistance = 0.05
        sceneView.audioEnvironmentNode.renderingAlgorithm = .auto
        
        self.sceneView = sceneView
        
    }
    
    
    func getAudioPlayer(filename: String) -> SCNAudioPlayer {
        /// Make the audio source
        let audioSource = SCNAudioSource(fileNamed: filename)!
    
        
        /// As an environmental sound layer, audio should play indefinitely
        audioSource.loops = true
        audioSource.isPositional = true
        
        /// Decode the audio from disk ahead of time to prevent a delay in playback
        audioSource.load()
        
        /// Add the audio player now
        return SCNAudioPlayer(source: audioSource)
    }
}
