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
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.session.delegate = self /// for processing each frame
        sceneView.delegate = self /// for providing the node
        sceneView.autoenablesDefaultLighting = true
        self.sceneView = sceneView
    }
    
}
