//
//  MainVC+SetupViews.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import RealityKit

extension MainViewController {
    
    func setupViews() {
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
        
        
        let coachingReferenceView = UIView()
        coachingReferenceView.backgroundColor = .clear
        coachingReferenceView.isUserInteractionEnabled = false
        view.addSubview(coachingReferenceView)
        
        /// Positioning constraints
        coachingReferenceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingReferenceView.topAnchor.constraint(equalTo: view.topAnchor),
            coachingReferenceView.rightAnchor.constraint(equalTo: view.rightAnchor),
            coachingReferenceView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coachingReferenceView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        self.coachingReferenceView = coachingReferenceView
        
        let crosshairView = UIView()
        crosshairView.backgroundColor = .red
        crosshairView.isUserInteractionEnabled = false
        view.addSubview(crosshairView)
        
        /// Positioning constraints
        crosshairView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crosshairView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            crosshairView.widthAnchor.constraint(equalToConstant: 100),
            crosshairView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        self.crosshairView = crosshairView
        
        let crosshairImageView = UIImageView()
        crosshairImageView.backgroundColor = .clear
        crosshairImageView.isUserInteractionEnabled = false
        
        let plusConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        let plusImage = UIImage(systemName: "plus", withConfiguration: plusConfiguration)
        crosshairImageView.image = plusImage
        crosshairImageView.tintColor = UIColor.white
        crosshairView.addSubview(crosshairImageView)
        
        /// Positioning constraints
        crosshairImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairImageView.centerXAnchor.constraint(equalTo: crosshairView.centerXAnchor),
            crosshairImageView.centerYAnchor.constraint(equalTo: crosshairView.centerYAnchor),
            crosshairImageView.widthAnchor.constraint(equalToConstant: 30),
            crosshairImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        self.crosshairImageView = crosshairImageView
        
    }
    
    
}
