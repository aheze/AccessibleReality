//
//  MainVC+AddMarker.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import UIKit
import ARKit

extension MainViewController {
    func addMarker(at boundingBox: CGRect, name: String, color: UIColor) -> Marker? {
        
        /// get horizontal distance
        let bottomLeftPoint = CGPoint(x: boundingBox.minX, y: boundingBox.maxY)
        let bottomRightPoint = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)
        let objectCenter = CGPoint(x: boundingBox.midX, y: boundingBox.midY)
        
        if
            let bottomLeftResult = makeRaycastQuery(at: bottomLeftPoint),
            let bottomRightResult = makeRaycastQuery(at: bottomRightPoint),
            let centerResult = makeRaycastQuery(at: objectCenter)
        {
            let bottomLeftRealWorldPosition = bottomLeftResult.worldTransform.columns.3
            let bottomRightRealWorldPosition = bottomRightResult.worldTransform.columns.3
            let line = bottomRightRealWorldPosition - bottomLeftRealWorldPosition
            let distance = CGFloat(length(line))
            
            
            let heightOverWidthRatio = boundingBox.height / boundingBox.width
            let height = distance * CGFloat(heightOverWidthRatio)
    
            let box = SCNBox(width: distance, height: height, length: height, chamferRadius: 0)
            
            let cubeColor = color.withAlphaComponent(0.8) /// make partially transparent because it encompasses the detected object
            let colorMaterial = SCNMaterial()
            colorMaterial.diffuse.contents = cubeColor
            box.materials = [colorMaterial]
            
            let anchor = ARAnchor(name: "Node Anchor", transform: centerResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            
            let maxRadius = max(distance, height) / 2
            let marker = Marker(
                name: name,
                color: color,
                hasDescription: true,
                box: box,
                anchor: anchor,
                radius: Float(maxRadius)
            )
            placedMarkers.append(marker)
            
            return marker
        }
        
        return nil
    }
    
    func addMarker(at screenCoordinate: CGPoint, color: UIColor) -> Marker? {
        if let result = makeRaycastQuery(at: screenCoordinate) {
            
            let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            let colorMaterial = SCNMaterial()
            colorMaterial.diffuse.contents = color
            box.materials = [colorMaterial]
            
            let anchor = ARAnchor(name: "Node Anchor", transform: result.worldTransform)
            sceneView.session.add(anchor: anchor)
            
            let marker = Marker(name: "Node", color: color, hasDescription: false, box: box, anchor: anchor, radius: 0.05)
            placedMarkers.append(marker)
            
            return marker
        }
        
        return nil
        
    }
    
    func makeRaycastQuery(at screenCoordinate: CGPoint) -> ARRaycastResult? {
        if
            let raycastQuery = sceneView.raycastQuery(
                from: screenCoordinate,
                allowing: .existingPlaneInfinite,
                alignment: .any
            )
        {
            let results = sceneView.session.raycast(raycastQuery)
            return results.last
        }
        
        return nil /// nil if no result
        
    }
}
