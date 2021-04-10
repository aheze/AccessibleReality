//
//  MainVC+TrackMarker.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import SwiftUI
import ARKit

extension MainViewController {
    func trackCurrentMarker() {
        if let currentTrackingMarker = vm.selectedCard?.marker {
            let anchorPosition = SCNVector3(
                currentTrackingMarker.anchor.transform.columns.3.x,
                currentTrackingMarker.anchor.transform.columns.3.y,
                currentTrackingMarker.anchor.transform.columns.3.z
            )
            let projectedVector = sceneView.projectPoint(anchorPosition)
            let projectedPoint = CGPoint(x: CGFloat(projectedVector.x), y: CGFloat(projectedVector.y))
            
            
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
            self.lineLayer?.strokeColor = UIColor(vm.selectedCard?.color ?? Color.green).cgColor
            
            
            var cubeColor = UIColor(vm.selectedCard?.color ?? Color.green)
            
            if vm.selectedCard?.marker?.hasDescription ?? false {
                cubeColor = cubeColor.withAlphaComponent(0.8)
            }
            let colorMaterial = SCNMaterial()
            colorMaterial.diffuse.contents = cubeColor
            self.vm.selectedCard?.marker?.box.materials = [colorMaterial]
            
            /// get distance from camera to cube
            if let cameraPosition = sceneView.pointOfView?.position {
                let distance = anchorPosition.distance(to: cameraPosition)
            }
        } else {
            /// remove line
            lineLayer?.removeFromSuperlayer()
            lineLayer = nil
        }
    }
}


extension SCNVector3 {
     func distance(to vector: SCNVector3) -> Float {
         return simd_distance(simd_float3(self), simd_float3(vector))
     }
 }
