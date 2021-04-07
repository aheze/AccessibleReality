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
            
        }
    }
}
