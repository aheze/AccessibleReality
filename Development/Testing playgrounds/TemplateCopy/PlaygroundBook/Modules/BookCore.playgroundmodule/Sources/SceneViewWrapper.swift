//
//  SceneViewWrapper.swift
//  BookCore
//
//  Created by Zheng on 4/12/21.
//

import UIKit
import SceneKit

@objc(BookCore_SceneViewWrapper)
class SceneViewWrapper: UIView {
    
    var sceneView: SCNView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let contentView = UIView()
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let scene = SCNScene()
        
        let camera = SCNCamera()
        camera.fieldOfView = 10
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
        cameraNode.camera = camera
        let cameraOrbitNode = SCNNode()
        cameraOrbitNode.addChildNode(cameraNode)
        cameraOrbitNode.eulerAngles = SCNVector3(-35.degreesToRadians, 0, 0)
        scene.rootNode.addChildNode(cameraOrbitNode)
        
        let crosshairCube = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        crosshairCube.firstMaterial?.diffuse.contents = UIColor(red: 0.149, green: 0.604, blue: 0.859, alpha: 0.9)
        
        let crosshairCubeNode = SCNNode(geometry: crosshairCube)
        scene.rootNode.addChildNode(crosshairCubeNode)
        
        
        let action = SCNAction.repeatForever(
            SCNAction.rotate(
                by: .pi,
                around: SCNVector3(0, 0.5, 0),
                duration: 3
            )
        )
        crosshairCubeNode.runAction(action)
        
        let sceneView = SCNView()
        contentView.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sceneView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            sceneView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sceneView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
        
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
        let origin = Origin(length: 1, radiusRatio: 0.006, color: (x: .red, y: .green, z: .blue, origin: .black))
        sceneView.scene?.rootNode.addChildNode(origin)
        
        self.sceneView = sceneView
        
    }
}

/// show the world origin
/// from https://gist.github.com/cenkbilgen/ba5da0b80f10dc69c10ee59d4ccbbda6
class Origin: SCNNode {
    
    /// see: https://developer.apple.com/documentation/arkit/arsessionconfiguration/worldalignment/gravityandheading
    /// if ar session configured with gravity and heading, then +x is east, +y is up, +z is south
    
    private enum Axis {
        case x, y, z
        
        var normal: float3 {
            switch self {
            case .x: return simd_float3(1, 0, 0)
            case .y: return simd_float3(0, 1, 0)
            case .z: return simd_float3(0, 0, 1)
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