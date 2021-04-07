//
//  MainVC+TrackMarker.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import UIKit
import RealityKit

extension MainViewController {
    func trackCurrentMarker() {
        if
            let currentTrackingMarker = currentTrackingMarker,
            let projectedPoint = arView.project(currentTrackingMarker.entity.position)
        {
            
            let path = UIBezierPath()
            path.move(to: crosshairCenter)
            path.addLine(to: projectedPoint)
            
            /// add lineLayer if nil
            if lineLayer == nil {
                path.lineCapStyle = .round
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.lineWidth = 3
                
                drawingView.layer.addSublayer(lineLayer)
                self.lineLayer = lineLayer
            }
            
            self.lineLayer?.path = path.cgPath
            self.lineLayer?.strokeColor = currentTrackingMarker.color.cgColor
            
            /// get distance from camera to cube
            let anchorPosition = currentTrackingMarker.entity.transform.translation
            let cameraPosition = arView.cameraTransform.translation
            let line = cameraPosition - anchorPosition
            let distance = length(line)
            
            print("dist: \(distance)")
        }
    }
}
