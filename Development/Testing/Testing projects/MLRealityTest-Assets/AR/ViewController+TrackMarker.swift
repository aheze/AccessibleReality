//
//  ViewController+TrackMarker.swift
//  MLRealityTest
//
//  Created by Zheng on 4/4/21.
//

import UIKit

extension ViewController {
    func trackCurrentMarker() {
        if let currentTrackingMarker = currentTrackingMarker {
            
            
            let projectedPoint = arView.project(currentTrackingMarker.entity.position)
            print("point: \(projectedPoint)")
            
            //                DispatchQueue.main.async {
            //
            //                }
            
            
        }
    }
}
