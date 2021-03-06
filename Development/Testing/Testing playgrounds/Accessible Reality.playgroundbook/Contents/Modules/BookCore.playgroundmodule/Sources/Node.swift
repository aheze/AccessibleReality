//
//  Node.swift
//  BookCore
//
//  Created by Zheng on 4/12/21.
//

import UIKit
import SceneKit

/// Make SCNVector3 into Value, and SCNNode into Node (for easier understanding)
/// Also convert from meters into centimeters, rotation in degrees


/**
 Any real number.
 */
public typealias Number = Float


/**
 A value made of X, Y, and Z. The meaning of this depends on where it is used (for example, for Node.position, this is in centimeters).
 */
public struct Value {
    public var x: Number
    public var y: Number
    public var z: Number
    
    /**
     Make a new Value.
     */
    public init(x: Number, y: Number, z: Number) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /**
     Make a new Value with the same number for X, Y, and Z.
     */
    public init(xyz: Number) {
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
public enum NodeShape {
    case cube
    case cylinder
    case sphere
    case cone
    case pyramid
}

/**
 An element inside SceneKit. Determines the position, rotation, scale, and how it looks (color and shape).
 */
public class Node {
    
    /**
     Position of the node, in centimeters
     */
    public var position = Value(x: 0, y: 0, z: 0) { didSet { updateSCNNode() } }
    
    /**
     Rotation of the node, in degrees
     */
    public var rotation = Value(x: 0, y: 0, z: 0) { didSet { updateSCNNode() } }
    
    /**
     Scale of the node, with 1 as the normal scale
     */
    public var scale = Value(x: 1, y: 1, z: 1) { didSet { updateSCNNode() } }
    
    /**
     Color of the node
     */
    public var color = UIColor.green { didSet { updateSCNNode() } }
    
    /**
     Shape of the node
     */
    public var shape = NodeShape.cube { didSet { updateSCNNode() } }
    
    /**
     Position, rotation, and scale combined in 1 matrix
     */
    public var transform: SCNMatrix4 {
        get {
            scnNode?.transform ?? SCNMatrix4Identity
        }
    }
    
    
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
    public init() {
        scnNode = SCNNode()
        updateSCNNode()
    }
}

public extension SCNNode {
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


func combine(_ transform: SCNMatrix4, with position: Value) -> Value {
    var positionForwardsMatrix = matrix_identity_float4x4
    positionForwardsMatrix.columns.3.x = position.x / 100
    positionForwardsMatrix.columns.3.y = position.y / 100
    positionForwardsMatrix.columns.3.z = position.z / 100
    
    let transformMatrix = simd_float4x4(transform)
    let combinedTransform = matrix_multiply(transformMatrix, positionForwardsMatrix)

    let combinedPosition = Value(
        x: combinedTransform.columns.3.x * 100,
        y: combinedTransform.columns.3.y * 100,
        z: combinedTransform.columns.3.z * 100
    )
    
    return combinedPosition
}

/// distance, position, lookPositionB, lookWorldUp
/// make a line between nodes
/// from https://stackoverflow.com/a/57724512/14351818
func lineMidBetweenNodes(positionA: Value, positionB: Value, inScene: SCNScene) -> (Number, SCNVector3, SCNVector3, SCNVector3) {
    let vector = SCNVector3(positionA.x - positionB.x, positionA.y - positionB.y, positionA.z - positionB.z)
    let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
    let midPosition = SCNVector3 (x:(positionA.x + positionB.x) / 2, y:(positionA.y + positionB.y) / 2, z:(positionA.z + positionB.z) / 2)

    let lineNode = SCNNode()
    lineNode.position = midPosition

    let positionBVector = SCNVector3(x: positionB.x, y: positionB.y, z: positionB.z)
    return (distance, midPosition, positionBVector, lineNode.worldUp)
}

func updateLineNode(scene: SCNScene, node: SCNNode, color: UIColor, distance: Number, position: SCNVector3, positionB: SCNVector3, lineWorldUp: SCNVector3) {
    let lineGeometry = SCNCylinder()
    lineGeometry.radius = 0.005
    lineGeometry.height = CGFloat(distance)
    lineGeometry.radialSegmentCount = 5
    lineGeometry.firstMaterial!.diffuse.contents = color
    
    node.geometry = lineGeometry
    node.position = position
    node.look(at: positionB, up: scene.rootNode.worldUp, localFront: lineWorldUp)
}

/// animate node color
/// from https://stackoverflow.com/a/45049489/14351818
func animateColor(from: UIColor, to: UIColor, percentage: CGFloat) -> UIColor {
    let fromComponents = from.cgColor.components!
    let toComponents = to.cgColor.components!

    let color = UIColor(red: fromComponents[0] + (toComponents[0] - fromComponents[0]) * percentage,
        green: fromComponents[1] + (toComponents[1] - fromComponents[1]) * percentage,
        blue: fromComponents[2] + (toComponents[2] - fromComponents[2]) * percentage,
        alpha: fromComponents[3] + (toComponents[3] - fromComponents[3]) * percentage)
    return color
}
