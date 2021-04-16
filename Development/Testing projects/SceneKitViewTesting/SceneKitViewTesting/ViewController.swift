//
//  ViewController.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/12/21.
//

import UIKit
import SceneKit
import SwiftUI


extension UIViewController {
    func addChildViewController(_ childViewController: UIViewController, in inView: UIView) {
        /// Add Child View Controller
        addChild(childViewController)
        
        /// Add Child View as Subview
        inView.insertSubview(childViewController.view, at: 0)
        
        /// Configure Child View
        childViewController.view.frame = inView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        /// Notify Child View Controller
        childViewController.didMove(toParent: self)
    }
}

class SlidersViewModel: ObservableObject {
    @Published var x = Double(0)
    @Published var y = Double(0)
    @Published var z = Double(0)
    
    static var didChange: (() -> Void)?
}


class ViewController: UIViewController {
    
    var isLive = true
    
    @IBOutlet weak var crosshairView: UIView!
    @IBOutlet weak var crosshairImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var sceneViewWrapper: SceneViewWrapper!
    @IBOutlet var panGestures: UIPanGestureRecognizer!
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if isLive == false {
            if sender.state == .changed {
                let translation = sender.translation(in: containerView)
                crosshairView.frame.origin.x += translation.x
                crosshairView.frame.origin.y += translation.y
                
                
                if crosshairView.center.x > containerView.frame.width {
                    crosshairView.center.x = containerView.frame.width
                } else if crosshairView.center.x < 0 {
                    crosshairView.center.x = 0
                }
                
                if crosshairView.center.y > containerView.frame.height {
                    crosshairView.center.y = containerView.frame.height
                } else if crosshairView.center.y < 0 {
                    crosshairView.center.y = 0
                }
                
                coordinateLabel.text = "Crosshair: \(Int(crosshairView.center.x)) x, \(Int(crosshairView.center.y)) y"
            }
            sender.setTranslation(.zero, in: containerView)
        }
    }
    
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var hitTestButton: UIButton!
    @IBAction func hitTestPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4) {
            self.crosshairImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        } completion: { _ in
            
            let center = CGPoint(
                x: Int(self.crosshairView.center.x),
                y: Int(self.crosshairView.center.y)
            )
            
            let results = self.sceneViewWrapper.sceneView.hitTest(center, options: [SCNHitTestOption.searchMode : 1])
            if let first = results.first(where: {$0.node.name == "PlaneNode"}) {
                
                let coords = first.worldCoordinates
                
                let value = Value(position: coords)

                if let node = self.cubeNode {
                    node.position = value
                } else {
                    let newNode = Node()
                    newNode.color = UIColor.red
                    newNode.position = value
                    self.sceneViewWrapper.sceneView.scene?.rootNode.addNode(newNode)
                    
                    self.cubeNode = newNode
                }
            }
            
            UIView.animate(withDuration: 0.4) {
                self.crosshairImageView.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    var cubeNode: Node?
    var cameraNode: Node?
    var directionNode: Node?
    
    @IBOutlet weak var slidersReferenceView: UIView!
    
//    var svm: SlidersViewModel!
    
    var svm1: SlidersViewModel!
    var svm2: SlidersViewModel!
    var svm3: SlidersViewModel!
    var svm4: SlidersViewModel!
    func setupLiveView() {
//        self.svm = SlidersViewModel()
        
        self.svm1 = SlidersViewModel()
        self.svm2 = SlidersViewModel()
        self.svm3 = SlidersViewModel()
        self.svm4 = SlidersViewModel()
        
        SlidersViewModel.didChange = { [weak self] in
            guard let self = self else { return }
//            self.cubeNode?.position = Value(x: Float(self.svm.x), y: Float(self.svm.y), z:Float(self.svm.z))
            
            self.cubeNode?.position = Value(x: Float(self.svm1.x), y: Float(self.svm1.y), z:Float(self.svm1.z))
            self.cameraNode?.position = Value(x: Float(self.svm2.x), y: Float(self.svm2.y), z:Float(self.svm2.z))
            self.cameraNode?.rotation = Value(x: Float(self.svm3.x), y: Float(self.svm3.y), z:Float(self.svm3.z))
        }
        
        hitTestButton.isHidden = true
        crosshairView.isHidden = true
        coordinateLabel.isHidden = true
        
//        let sliderView = OneSliderView(svm: self.svm)
        let sliderView = FourSliderView(svm1: svm1, svm2: svm2, svm3: svm3, svm4: svm4)
        
        
        let cubeNode = Node()
        cubeNode.color = UIColor.red
        cubeNode.position = Value(x: 0, y: 0, z: 0)
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cubeNode)
        self.cubeNode = cubeNode
        
        let cameraNode = Node()
        cameraNode.shape = .pyramid
        cameraNode.color = UIColor.darkGray
        cameraNode.position = Value(x: 50, y: 25, z: 25)
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cameraNode)
        self.cameraNode = cameraNode
        
        let directionNode = Node()
        directionNode.shape = .sphere
        directionNode.color = UIColor.systemTeal
        directionNode.position = Value(x: 20, y: 25, z: 25)
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(directionNode)
        self.directionNode = directionNode
        
        
        let hostingController = UIHostingController(rootView: sliderView)
        addChildViewController(hostingController, in: slidersReferenceView)
    }
    
    func setupMainView() {
        crosshairImageView.layer.shadowRadius = 3
        crosshairImageView.layer.shadowColor = UIColor.systemBlue.cgColor
        crosshairImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        crosshairImageView.layer.shadowOpacity = 0.9
        
        coordinateLabel.text = "Crosshair: \(Int(crosshairView.center.x)) x, \(Int(crosshairView.center.y)) y"
        
        hitTestButton.layer.cornerRadius = 16
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        isLive ? setupLiveView() : setupMainView()
    }
    
}


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
    
    var cameraNode: SCNNode!
    
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
        self.cameraNode = cameraNode
        
        let cameraOrbitNode = SCNNode()
        cameraOrbitNode.addChildNode(cameraNode)
        cameraOrbitNode.eulerAngles = SCNVector3(-45.degreesToRadians, 45.degreesToRadians, 0)
        
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
        
        let resetButton = UIButton(type: .system)
        contentView.addSubview(resetButton)
        
        resetButton.setTitle("Reset point of view", for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 19, weight: .medium)
        resetButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        resetButton.setTitleColor(.systemBlue, for: .normal)
        resetButton.backgroundColor = UIColor.systemBackground
        resetButton.layer.cornerRadius = 12
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            resetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
        
        resetButton.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)
        
        self.sceneView = sceneView
        
        resetButton.alpha = 0
        resetButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        self.resetButton = resetButton
    }
    
    var resetButton: UIButton!
    @objc func resetPressed() {

        UIView.animate(withDuration: 0.3) {
            self.resetButton.alpha = 0
            self.resetButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        sceneView.pointOfView = cameraNode
        SCNTransaction.commit()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.3) {
            self.resetButton.alpha = 1
            self.resetButton.transform = CGAffineTransform.identity
        }
    }
}


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
