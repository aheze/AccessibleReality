//
//  ViewController+AddMarker.swift
//  MLRealityTest
//
//  Created by Zheng on 4/3/21.
//

import UIKit
import RealityKit
import ARKit

extension ViewController {
    func addMarker(at boundingBox: CGRect, name: String) {
        
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
            
            let cubeColor = UIColor.yellow.withAlphaComponent(0.3)
            let transformation = Transform(matrix: centerResult.worldTransform)
            let box = CustomBox(color: cubeColor, width: distance, height: height)
            
            let entity = addEntity(box: box, transform: transformation, raycastResult: centerResult)
            let marker = Marker(name: name, entity: entity)
            placedMarkers.append(marker)
            currentTrackingMarker = marker
        }
        
        
    }
    
    func addMarker(at screenCoordinate: CGPoint) {
        
        if let result = makeRaycastQuery(at: screenCoordinate) {
            let cubeColor = UIColor.green
            
            let transformation = Transform(matrix: result.worldTransform)
            let box = CustomBox(color: cubeColor)
            
            let entity = addEntity(box: box, transform: transformation, raycastResult: result)
            let marker = Marker(name: "Object", entity: entity)
            placedMarkers.append(marker)
            currentTrackingMarker = marker
        }
        
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
            return result
        }
        
        return nil /// nil if no result
        
    }
    
    func addEntity(box: CustomBox, transform: Transform, raycastResult: ARRaycastResult) -> Entity {
        arView.installGestures(.all, for: box)
        box.generateCollisionShapes(recursive: true)
        box.transform = transform
        
        let raycastAnchor = AnchorEntity(raycastResult: raycastResult)
        raycastAnchor.addChild(box)
        arView.scene.addAnchor(raycastAnchor)
        
        return box
    }
}
