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
        if busyProcessingImage == false {
            busyProcessingImage = true
            processPixelBuffer(frame.capturedImage)
        }
    }
}
