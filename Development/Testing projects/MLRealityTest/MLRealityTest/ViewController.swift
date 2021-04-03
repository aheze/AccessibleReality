//
//  ViewController.swift
//  MLRealityTest
//
//  Created by Zheng on 4/2/21.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    @IBOutlet weak var coachingReferenceView: UIView!
    
    // MARK: Vision
    var busyProcessingImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        arView.session.delegate = self
        addCoaching()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            let location = touch.location(in: arView)
            rayCastingMethod(point: location)
        }
    }
}

extension ViewController: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .anyPlane
        
        coachingReferenceView.addSubview(coachingOverlay)
        coachingReferenceView.isUserInteractionEnabled = false
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            coachingOverlay.topAnchor.constraint(equalTo: coachingReferenceView.topAnchor),
            coachingOverlay.rightAnchor.constraint(equalTo: coachingReferenceView.rightAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: coachingReferenceView.bottomAnchor),
            coachingOverlay.leftAnchor.constraint(equalTo: coachingReferenceView.leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        
        let box = CustomBox(color: .yellow, position: [-0.6, -1, -2])
        arView.installGestures(.all, for: box)
        box.generateCollisionShapes(recursive: true)
        arView.scene.anchors.append(box) //self is arView
        
        let mesh = MeshResource.generateText(
            "RealityKit",
            extrusionDepth: 0.1,
            font: .systemFont(ofSize: 2),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byTruncatingTail)
        
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.scale = SIMD3<Float>(0.03, 0.03, 0.1)
        
        box.addChild(entity)
        
        entity.setPosition(SIMD3<Float>(0, 0.05, 0), relativeTo: box)
    }
    
    func rayCastingMethod(point: CGPoint) {
        
        
        guard let raycastQuery = arView.makeRaycastQuery(from: point,
                                                       allowing: .existingPlaneInfinite,
                                                       alignment: .horizontal) else {
            
            print("failed first")
            return
        }
        
        guard let result = arView.session.raycast(raycastQuery).first else {
            print("failed")
            return
        }
        
        let transformation = Transform(matrix: result.worldTransform)
        let box = CustomBox(color: .yellow)
        arView.installGestures(.all, for: box)
        box.generateCollisionShapes(recursive: true)
        box.transform = transformation
        
        let raycastAnchor = AnchorEntity(raycastResult: result)
        raycastAnchor.addChild(box)
        arView.scene.addAnchor(raycastAnchor)
    }
}
