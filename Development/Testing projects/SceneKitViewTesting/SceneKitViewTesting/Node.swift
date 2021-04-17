//
//  Node.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/16/21.
//

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
enum Shape {
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
    var shape = Shape.cube { didSet { updateSCNNode() } }
    
    /**
     Position, rotation, and scale combined in 1 matrix
     */
    public var transform: SCNMatrix4 {
        get {
            scnNode.transform
        }
    }
    
    
    internal var scnNode: SCNNode!
    
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


/// degrees to radians helper function
/// from https://stackoverflow.com/a/29179878/14351818
extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}


/// show the world origin
/// from https://gist.github.com/cenkbilgen/ba5da0b80f10dc69c10ee59d4ccbbda6
class Origin: SCNNode {

    /// see: https://developer.apple.com/documentation/arkit/arsessionconfiguration/worldalignment/gravityandheading
    /// if ar session configured with gravity and heading, then +x is east, +y is up, +z is south

    private enum Axis {
        case x, y, z

        var normal: SIMD3<Float> {
            switch self {
            case .x: return SIMD3(1, 0, 0)
            case .y: return SIMD3(0, 1, 0)
            case .z: return SIMD3(0, 0, 1)
            }
        }
    }


    init(length: CGFloat = 0.1, radiusRatio ratio: CGFloat = 0.04, color: (x: UIColor, y: UIColor, z: UIColor, origin: UIColor) = (.blue, .green, .red, .cyan)) {

        /// x-axis
        let xAxis = SCNCylinder(radius: length*ratio, height: length)
        xAxis.firstMaterial?.diffuse.contents = color.x
        let xAxisNode = SCNNode(geometry: xAxis)
        /// by default the middle of the cylinder will be at the origin aligned to the y-axis
        /// need to spin around to align with respective axes and shift position so they start at the origin
        xAxisNode.simdWorldOrientation = simd_quatf.init(angle: .pi/2, axis: Axis.z.normal)
        xAxisNode.simdWorldPosition = simd_float1(length)/2 * Axis.x.normal

        /// x-axis mirror
        let xAxisMirror = SCNCylinder(radius: length*ratio, height: length)
        xAxisMirror.firstMaterial?.diffuse.contents = color.x.withAlphaComponent(0.4)
        let xAxisMirrorNode = SCNNode(geometry: xAxisMirror)
        xAxisMirrorNode.simdWorldOrientation = simd_quatf.init(angle: .pi/2, axis: Axis.z.normal)
        xAxisMirrorNode.simdWorldPosition = -simd_float1(length)/2 * Axis.x.normal

        /// y-axis
        let yAxis = SCNCylinder(radius: length*ratio, height: length)
        yAxis.firstMaterial?.diffuse.contents = color.y
        let yAxisNode = SCNNode(geometry: yAxis)
        yAxisNode.simdWorldPosition = simd_float1(length)/2 * Axis.y.normal /// just shift

        let yAxisMirror = SCNCylinder(radius: length*ratio, height: length)
        yAxisMirror.firstMaterial?.diffuse.contents = color.y.withAlphaComponent(0.4)
        let yAxisMirrorNode = SCNNode(geometry: yAxisMirror)
        yAxisMirrorNode.simdWorldPosition = -simd_float1(length)/2 * Axis.y.normal


        /// z-axis
        let zAxis = SCNCylinder(radius: length*ratio, height: length)
        zAxis.firstMaterial?.diffuse.contents = color.z
        let zAxisNode = SCNNode(geometry: zAxis)
        zAxisNode.simdWorldOrientation = simd_quatf(angle: -.pi/2, axis: Axis.x.normal)
        zAxisNode.simdWorldPosition = simd_float1(length)/2 * Axis.z.normal

        let zAxisMirror = SCNCylinder(radius: length*ratio, height: length)
        zAxisMirror.firstMaterial?.diffuse.contents = color.z.withAlphaComponent(0.4)
        let zAxisMirrorNode = SCNNode(geometry: zAxisMirror)
        zAxisMirrorNode.simdWorldOrientation = simd_quatf(angle: -.pi/2, axis: Axis.x.normal)
        zAxisMirrorNode.simdWorldPosition = -simd_float1(length)/2 * Axis.z.normal

        /// dot at origin
        let origin = SCNSphere(radius: length*ratio*2)
        origin.firstMaterial?.diffuse.contents = color.origin
        origin.firstMaterial?.transparency = 0.5
        let originNode = SCNNode(geometry: origin)

        super.init()

        self.addChildNode(originNode)
        self.addChildNode(xAxisNode)
        self.addChildNode(yAxisNode)
        self.addChildNode(zAxisNode)

        self.addChildNode(xAxisMirrorNode)
        self.addChildNode(yAxisMirrorNode)
        self.addChildNode(zAxisMirrorNode)

        let planeGeo = SCNPlane(width: length * 2, height: length * 2)

        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = UIImage(named: "Grid")
        imageMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(32, 32, 0)
        imageMaterial.isDoubleSided = true

        planeGeo.firstMaterial = imageMaterial

        let plane = SCNNode(geometry: planeGeo)
        plane.name = "PlaneNode"

        plane.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
        plane.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
        plane.simdWorldOrientation = simd_quatf.init(angle: -.pi/2, axis: Axis.x.normal)
        self.addChildNode(plane)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
//}
//class Origin: SCNNode {
//
//    /// see: https://developer.apple.com/documentation/arkit/arsessionconfiguration/worldalignment/gravityandheading
//    /// if ar session configured with gravity and heading, then +x is east, +y is up, +z is south
//
//    init(length: CGFloat = 0.1, radiusRatio ratio: CGFloat = 0.04, color: (x: UIColor, y: UIColor, z: UIColor, origin: UIColor) = (.blue, .green, .red, .cyan)) {
//
//        /// x-axis
//        let xAxis = SCNCylinder(radius: length*ratio, height: length)
//        xAxis.firstMaterial?.diffuse.contents = color.x
//        let xAxisNode = SCNNode(geometry: xAxis)
//        /// by default the middle of the cylinder will be at the origin aligned to the y-axis
//        /// need to spin around to align with respective axes and shift position so they start at the origin
////        xAxisNode.simdWorldOrientation = simd_quatf.init(angle: .pi/2, axis: Axis.z.normal)
//        xAxisNode.eulerAngles = SCNVector3(0, 0, 90.degreesToRadians)
//        xAxisNode.simdWorldPosition = simd_float1(length)/2 * Axis.x.normal
//
//        /// x-axis mirror
//        let xAxisMirror = SCNCylinder(radius: length*ratio, height: length)
//        xAxisMirror.firstMaterial?.diffuse.contents = color.x.withAlphaComponent(0.4)
//        let xAxisMirrorNode = SCNNode(geometry: xAxisMirror)
//        xAxisMirrorNode.simdWorldOrientation = simd_quatf.init(angle: .pi/2, axis: Axis.z.normal)
//        xAxisMirrorNode.simdWorldPosition = -simd_float1(length)/2 * Axis.x.normal
//
//        /// y-axis
//        let yAxis = SCNCylinder(radius: length*ratio, height: length)
//        yAxis.firstMaterial?.diffuse.contents = color.y
//        let yAxisNode = SCNNode(geometry: yAxis)
//        yAxisNode.simdWorldPosition = simd_float1(length)/2 * Axis.y.normal /// just shift
//
//        let yAxisMirror = SCNCylinder(radius: length*ratio, height: length)
//        yAxisMirror.firstMaterial?.diffuse.contents = color.y.withAlphaComponent(0.4)
//        let yAxisMirrorNode = SCNNode(geometry: yAxisMirror)
//        yAxisMirrorNode.simdWorldPosition = -simd_float1(length)/2 * Axis.y.normal
//
//
//        /// z-axis
//        let zAxis = SCNCylinder(radius: length*ratio, height: length)
//        zAxis.firstMaterial?.diffuse.contents = color.z
//        let zAxisNode = SCNNode(geometry: zAxis)
//        zAxisNode.simdWorldOrientation = simd_quatf(angle: -.pi/2, axis: Axis.x.normal)
//        zAxisNode.simdWorldPosition = simd_float1(length)/2 * Axis.z.normal
//
//        let zAxisMirror = SCNCylinder(radius: length*ratio, height: length)
//        zAxisMirror.firstMaterial?.diffuse.contents = color.z.withAlphaComponent(0.4)
//        let zAxisMirrorNode = SCNNode(geometry: zAxisMirror)
//        zAxisMirrorNode.simdWorldOrientation = simd_quatf(angle: -.pi/2, axis: Axis.x.normal)
//        zAxisMirrorNode.simdWorldPosition = -simd_float1(length)/2 * Axis.z.normal
//
//        /// dot at origin
//        let origin = SCNSphere(radius: length*ratio*2)
//        origin.firstMaterial?.diffuse.contents = color.origin
//        origin.firstMaterial?.transparency = 0.5
//        let originNode = SCNNode(geometry: origin)
//
//        super.init()
//
//        self.addChildNode(originNode)
//        self.addChildNode(xAxisNode)
//        self.addChildNode(yAxisNode)
//        self.addChildNode(zAxisNode)
//
//        self.addChildNode(xAxisMirrorNode)
//        self.addChildNode(yAxisMirrorNode)
//        self.addChildNode(zAxisMirrorNode)
//
//        let planeGeo = SCNPlane(width: length * 2, height: length * 2)
//
//        let imageMaterial = SCNMaterial()
//        imageMaterial.diffuse.contents = UIImage(named: "Grid")
//        imageMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(32, 32, 0)
//        imageMaterial.isDoubleSided = true
//
//        planeGeo.firstMaterial = imageMaterial
//
//        let plane = SCNNode(geometry: planeGeo)
//        plane.name = "PlaneNode"
//
//        plane.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
//        plane.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
//        plane.simdWorldOrientation = simd_quatf.init(angle: -.pi/2, axis: Axis.x.normal)
//        self.addChildNode(plane)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
