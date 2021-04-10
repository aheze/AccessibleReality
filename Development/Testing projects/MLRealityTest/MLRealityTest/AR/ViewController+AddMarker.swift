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
            let distance = CGFloat(length(line))
            
            let heightOverWidthRatio = boundingBox.height / boundingBox.width
            let height = distance * CGFloat(heightOverWidthRatio)
            
            let cubeColor = color.withAlphaComponent(0.3) /// make partially transparent because it encompasses the detected object
            
            let box = SCNBox(width: distance, height: height, length: height, chamferRadius: 0)
            
            let node = addNode(box: box, raycastResult: centerResult)
            
            let marker = Marker(name: name, color: color, box: box, node: node)
            placedMarkers.append(marker)
            
            return marker
        }
        
        return nil
    }
    
    func addMarker(at screenCoordinate: CGPoint, color: UIColor) -> Marker? {
        print("adding..")
        if let result = makeRaycastQuery(at: screenCoordinate) {
            print("makeRaycastQuery..")
            
//            let transformation = Transform(matrix: result.worldTransform)
//            let box = CustomBox(color: color)
            
            let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
            
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
            print("Making. \(raycastQuery)")
            let results = sceneView.session.raycast(raycastQuery)
            
            print("res. \(results)")
            return results.first
        }
        
        return nil /// nil if no result
        
    }
    
    func addNode(box: SCNBox, raycastResult: ARRaycastResult) -> SCNNode {
        
        print("add node")
//        arView.installGestures(.all, for: box)
//        box.generateCollisionShapes(recursive: true)
//        box.transform = transform
        
//        let raycastAnchor = AnchorEntity(raycastResult: raycastResult)
//        raycastAnchor.addChild(box)
//        arView.scene.addAnchor(raycastAnchor)
        
        let position = SCNVector3(raycastResult.worldTransform.columns.3.x,
                                  raycastResult.worldTransform.columns.3.y,
                                  raycastResult.worldTransform.columns.3.z)
        
        print("position. \(position)")
        let cubeNode = SCNNode(geometry: box)
        
        cubeNode.position = position
        sceneView.scene.rootNode.addChildNode(cubeNode)
        
        return cubeNode
//        return raycastAnchor
    }
}
