//
//  MainVC+AddMarker.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import UIKit
import RealityKit
import ARKit

extension MainViewController {
    func addMarker(at boundingBox: CGRect, name: String, color: UIColor) -> Marker? {
        
        /// get horizontal distance
        let topLeftPoint = CGPoint(x: boundingBox.minX, y: boundingBox.minY)
        let topRightPoint = CGPoint(x: boundingBox.maxX, y: boundingBox.minY)
        let objectCenter = CGPoint(x: boundingBox.midX, y: boundingBox.midY)
        
        if
            let topLeftResult = makeRaycastQuery(at: topLeftPoint),
            let topRightResult = makeRaycastQuery(at: topRightPoint),
            let centerResult = makeRaycastQuery(at: objectCenter)
        {
            let topLeftRealWorldPosition = topLeftResult.worldTransform.columns.3
            let topRightRealWorldPosition = topRightResult.worldTransform.columns.3
            let line = topRightRealWorldPosition - topLeftRealWorldPosition
            let distance = length(line)
            
            let heightOverWidthRatio = boundingBox.height / boundingBox.width
            let height = distance * Float(heightOverWidthRatio)
            
            let cubeColor = color.withAlphaComponent(0.3) /// make partially transparent because it encompasses the detected object
            let transformation = Transform(matrix: centerResult.worldTransform)
            let box = CustomBox(color: cubeColor, width: distance, height: height)
            
            let anchorEntity = addEntity(box: box, transform: transformation, raycastResult: centerResult)
            
            let marker = Marker(name: name, color: color, entity: box, anchorEntity: anchorEntity)
            placedMarkers.append(marker)
            currentTrackingMarker = marker
            
            return marker
        }
        
        print("nil...")
        
        return nil
    }
    
    func addMarker(at screenCoordinate: CGPoint, color: UIColor) -> Marker? {
        
        if let result = makeRaycastQuery(at: screenCoordinate) {
            
            let transformation = Transform(matrix: result.worldTransform)
            let box = CustomBox(color: color)
            
            let anchorEntity = addEntity(box: box, transform: transformation, raycastResult: result)
            let marker = Marker(name: "Object", color: color, entity: box, anchorEntity: anchorEntity)
            placedMarkers.append(marker)
            currentTrackingMarker = marker
            
            return marker
        }
        
        print("nil")
        return nil
        
    }
    
    func makeRaycastQuery(at screenCoordinate: CGPoint) -> ARRaycastResult? {
        if
            let raycastQuery = arView.makeRaycastQuery(
                from: screenCoordinate,
                allowing: .existingPlaneInfinite,
                alignment: .horizontal
            ),
            let result = arView.session.raycast(raycastQuery).first
        {
            print("yes ray")
            return result
        }
        
        return nil /// nil if no result
        
    }
    
    func addEntity(box: CustomBox, transform: Transform, raycastResult: ARRaycastResult) -> AnchorEntity {
        arView.installGestures(.all, for: box)
        box.generateCollisionShapes(recursive: true)
        box.transform = transform
        
        let raycastAnchor = AnchorEntity(raycastResult: raycastResult)
        raycastAnchor.addChild(box)
        arView.scene.addAnchor(raycastAnchor)
        
        return raycastAnchor
    }
}
