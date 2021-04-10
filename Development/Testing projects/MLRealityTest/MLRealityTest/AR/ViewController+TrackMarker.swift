//
//  ViewController+TrackMarker.swift
//  MLRealityTest
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import RealityKit
import SwiftUI

extension ViewController {
    func trackCurrentMarker() {
        if
            let currentTrackingMarker = vm.selectedCard?.marker
            
        {
            let projectedVector = sceneView.projectPoint(currentTrackingMarker.node.position)
            

//            let projectedPoint = CGPoint(x: projectedVector.x, y: projectedVector.y)
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
            
            /// get distance from camera to cube
            let anchorPosition = currentTrackingMarker.node.position
            let cameraPosition = sceneView.pointOfView?.position
//            let line = cameraPosition - anchorPosition
//            let distance = length(line)
            
            print("anc \(anchorPosition)")
            print("cameraPosition \(cameraPosition)")
            
//            print("dist: \(distance)")
        } else {
            /// remove line
            lineLayer?.removeFromSuperlayer()
            lineLayer = nil
        }
    }
    func updateMarkerColor(marker: Marker?, color: UIColor) {
        print("updating.. \(marker) \(color)")
        
//        let modelEntity = marker?.entity.children[0] as! ModelEntity
//        let material = SimpleMaterial(color: color, isMetallic: false)
//        modelEntity.model?.materials = [material]
    }
}
