//
//  ViewController+AddMarker.swift
//  MLRealityTest
//
//  Created by Zheng on 4/3/21.
//

import UIKit
import ARKit

extension ViewController {
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
            
            let node = addNode(box: box, raycastResult: centerResult)
            
            let marker = Marker(name: name, color: color, box: box, node: node)
            placedMarkers.append(marker)
            
            return marker
        }
        
        return nil
    }
    
    func addMarker(at screenCoordinate: CGPoint, color: UIColor) -> Marker? {
        if let result = makeRaycastQuery(at: screenCoordinate) {
            
            let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
            let colorMaterial = SCNMaterial()
            colorMaterial.diffuse.contents = color
            box.materials = [colorMaterial]
            
            let node = addNode(box: box, raycastResult: result)
            let marker = Marker(name: "Object", color: color, box: box, node: node)
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
                alignment: .horizontal
            )
        {
            let results = sceneView.session.raycast(raycastQuery)
            return results.last
        }
        
        return nil /// nil if no result
        
    }
    
    func addNode(box: SCNBox, raycastResult: ARRaycastResult) -> SCNNode {
        
        let position = SCNVector3(
            raycastResult.worldTransform.columns.3.x,
            raycastResult.worldTransform.columns.3.y,
            raycastResult.worldTransform.columns.3.z
        )
        
        let cubeNode = SCNNode(geometry: box)
        
        cubeNode.transform = SCNMatrix4(raycastResult.worldTransform)
        sceneView.scene.rootNode.addChildNode(cubeNode)
        
        return cubeNode
    }
}
