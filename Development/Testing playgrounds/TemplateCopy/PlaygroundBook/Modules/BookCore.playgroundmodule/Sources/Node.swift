//
//  Node.swift
//  BookCore
//
//  Created by Zheng on 4/12/21.
//

import UIKit
import SceneKit

/**
 A value made of X, Y, and Z. The meaning of this depends on where it is used (for example, for Node.position, this is in centimeters).
 */
struct Value {
    var x: Float
    var y: Float
    var z: Float
    
    /**
     Make a new Value
     */
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /**
     Make a new Value with the same number for X, Y, and Z
     */
    init(xyz: Float) {
        self.x = xyz
        self.y = xyz
        self.z = xyz
    }
    
    internal init(position: SCNVector3) {
        self.x = position.x * 100
        self.y = position.y * 100
        self.z = position.z * 100
    }
    
    internal init(rotation: SCNVector3) {
        self.x = rotation.x.radiansToDegrees
        self.y = rotation.y.radiansToDegrees
        self.z = rotation.z.radiansToDegrees
    }
    
    internal init(scale: SCNVector3) {
        self.x = scale.x
        self.y = scale.y
        self.z = scale.z
    }
    
}

/**
 The shape of a node.
 */
enum NodeShape {
    case cube
    case cylinder
    case sphere
    case cone
    case pyramid
}

/**
 An element inside SceneKit. Determines the position, rotation, scale, and how it looks (color and shape).
 */
class Node {
    
    /**
     Position of the node, in centimeters
     */
    var position = Value(x: 0, y: 0, z: 0) { didSet { updateSCNNode() } }
    
    /**
     Rotation of the node, in degrees
     */
    var rotation = Value(x: 0, y: 0, z: 0) { didSet { updateSCNNode() } }
    
    /**
     Scale of the node, with 1 as the normal scale
     */
    var scale = Value(x: 1, y: 1, z: 1) { didSet { updateSCNNode() } }
    
    /**
     Color of the node
     */
    var color = UIColor.green { didSet { updateSCNNode() } }
    
    /**
     Shape of the node
     */
    var shape = NodeShape.cube { didSet { updateSCNNode() } }
    
    
    internal var scnNode: SCNNode?
    
    private func makeSCNNode() -> (SCNGeometry, SCNVector3, SCNVector3, SCNVector3) {
        let geometry: SCNGeometry
        
        switch self.shape {
        case .cube:
            let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            geometry = box
        case .cylinder:
            let cylinder = SCNCylinder(radius: 0.05, height: 0.1)
            geometry = cylinder
        case .sphere:
            let sphere = SCNSphere(radius: 0.05)
            geometry = sphere
        case .cone:
            let cone = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.1)
            geometry = cone
        case .pyramid:
            let pyramid = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
            geometry = pyramid
        }
        
        geometry.firstMaterial?.diffuse.contents = self.color
        
        let scnPosition = SCNVector3(position: position)
        let scnRotation = SCNVector3(rotation: rotation)
        let scnScale = SCNVector3(scale: scale)
        
        return (geometry, scnPosition, scnRotation, scnScale)
    }
    
    private func updateSCNNode() {
        let (geometry, position, rotation, scale) = makeSCNNode()
        
        scnNode?.geometry = geometry
        scnNode?.position = position
        scnNode?.eulerAngles = rotation
        scnNode?.scale = scale
    }
    
    /**
     Make a node.
     */
    init() {
        scnNode = SCNNode()
        updateSCNNode()
    }
}

extension SCNNode {
    func addNode(_ node: Node) {
        if let scnNode = node.scnNode {
            addChildNode(scnNode)
        }
    }
}

extension SCNVector3 {
    internal init(position: Value) {
        self.init(
            position.x / 100,
            position.y / 100,
            position.z / 100
        )
    }
    
    internal init(rotation: Value) {
        self.init(
            rotation.x.degreesToRadians,
            rotation.y.degreesToRadians,
            rotation.z.degreesToRadians
        )
    }
    
    internal init(scale: Value) {
        self.init(
            scale.x,
            scale.y,
            scale.z
        )
    }
}
