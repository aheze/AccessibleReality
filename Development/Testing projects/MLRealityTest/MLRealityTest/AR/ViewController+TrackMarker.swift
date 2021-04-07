//
//  ViewController+TrackMarker.swift
//  MLRealityTest
//
//  Created by Zheng on 4/4/21.
//

import UIKit

extension ViewController {
    func trackCurrentMarker() {
        if
            let currentTrackingMarker = currentTrackingMarker,
            let projectedPoint = arView.project(currentTrackingMarker.entity.position)
        {
            
            let path = UIBezierPath()
            path.move(to: crosshairCenter)
            path.addLine(to: projectedPoint)
            
            if let lineLayer = lineLayer {
                lineLayer.path = path.cgPath
            } else {
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.strokeColor = currentTrackingMarker.color.cgColor
                lineLayer.lineWidth = 3
                
                drawingView.layer.addSublayer(lineLayer)
                
                self.lineLayer = lineLayer
            }
            
        }
    }
}
