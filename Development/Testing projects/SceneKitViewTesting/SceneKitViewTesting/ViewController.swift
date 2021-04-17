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

class ReadOnlySlidersViewModel: ObservableObject {
    @Published var x = Double(0)
    @Published var y = Double(0)
    @Published var z = Double(0)
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
    
    var svmV: SlidersViewModel!
    var svm1: SlidersViewModel!
    var svm2R: SlidersViewModel!
    var svm2: ReadOnlySlidersViewModel!
    
    func setupLiveView() {
//        self.svm = SlidersViewModel()
        
        self.svmV = SlidersViewModel()
        self.svm1 = SlidersViewModel()
        self.svm2R = SlidersViewModel()
        self.svm2 = ReadOnlySlidersViewModel()
        
        
        SlidersViewModel.didChange = { [weak self] in
            guard let self = self else { return }
//            self.cubeNode?.position = Value(x: Float(self.svm.x), y: Float(self.svm.y), z:Float(self.svm.z))
            
            self.cubeNode?.position = Value(x: Float(self.svm1.x), y: Float(self.svm1.y), z:Float(self.svm1.z))
            self.cameraNode?.position = Value(x: Float(self.svmV.x), y: Float(self.svmV.y), z:Float(self.svmV.z))
            self.cameraNode?.rotation = Value(x: Float(self.svm2R.x), y: Float(self.svm2R.y), z:Float(self.svm2R.z))
            
            let position = combine(self.cameraNode!.transform, with: Value(x: 0, y: -50, z: 0))
            self.directionNode?.position = position
            self.svm2.x = Double(position.x)
            self.svm2.y = Double(position.y)
            self.svm2.z = Double(position.z)
        }
        
        hitTestButton.isHidden = true
        crosshairView.isHidden = true
        coordinateLabel.isHidden = true
        
//        let sliderView = OneSliderView(svm: self.svm)
        let sliderView = FourSliderView(svm1: svm1, svmV: svmV, svm2R: svm2R, svm2: svm2)
        
        
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
