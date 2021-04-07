//
//  ViewController+ARDelegate.swift
//  MLRealityTest
//
//  Created by Zheng on 4/2/21.
//

import UIKit
import ARKit

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if busyProcessingImage == false && coachingViewActive == false {
            busyProcessingImage = true
            processPixelBuffer(frame.capturedImage)
        }
        
        if crosshairBusyCalculating == false {
            checkOverlap(at: crosshairCenter) { detectedObject in
                
                self.currentTargetedObject = detectedObject
                self.crosshairView.backgroundColor = (detectedObject == nil) ? UIColor.clear : UIColor.red.withAlphaComponent(0.5) 
                
            }
        }
        
        framesSinceLastTrack += 1
        if framesSinceLastTrack >= 5 {
            framesSinceLastTrack = 0
            
            trackCurrentMarker()
        }
    }
}
