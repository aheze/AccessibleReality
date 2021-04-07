//
//  MainVC+ARDelegate.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import ARKit

extension MainViewController: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        print("adding!")
        
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
    
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingViewActive = true
    }
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingViewActive = false
    }
}

extension MainViewController: ARSessionDelegate {
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print("updating. \(busyProcessingImage) \(coachingViewActive)")
        if busyProcessingImage == false && coachingViewActive == false {
            busyProcessingImage = true
            processPixelBuffer(frame.capturedImage)
        }
        
//        if crosshairBusyCalculating == false {
//            let middleOfCrossHair = crosshairView.center
//            checkOverlap(at: middleOfCrossHair) { detectedObject in
//
//
//                self.currentTargetedObject = detectedObject
//
//                self.crosshairView.backgroundColor = (detectedObject == nil) ? UIColor.clear : UIColor.red.withAlphaComponent(0.5)
//
//            }
//        }
        
        framesSinceLastTrack += 1
        if framesSinceLastTrack >= 5 {
            framesSinceLastTrack = 0
            
//            trackCurrentMarker()
        }
    }
}
