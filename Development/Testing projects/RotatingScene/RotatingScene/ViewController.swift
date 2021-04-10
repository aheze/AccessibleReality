//
//  ViewController.swift
//  RotatingScene
//
//  Created by Zheng on 4/10/21.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneReferenceView: UIView!
    var cubeNode: SCNNode!
    var cameraOrbit: SCNNode!
    
    var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let sceneView = SCNView()
        sceneView.frame = sceneReferenceView.bounds
        sceneReferenceView.addSubview(sceneView)
        
        // Create the scene
        let scene = SCNScene()



        let camera = SCNCamera()
        camera.fieldOfView = 10

//        let cameraNode = SCNNode()
//        cameraNode.camera = camera
//        cameraNode.position = SCNVector3(0, 0, 50)
//        self.cameraNode = cameraNode
//
//
//
//
//        scene.rootNode.addChildNode(cameraNode)
        
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        cameraNode.camera = camera
        let cameraOrbit = SCNNode()
        cameraOrbit.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraOrbit)
        
        self.cameraOrbit = cameraOrbit


        let cube = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        cube.firstMaterial?.diffuse.contents = UIColor(red: 0.149, green: 0.604, blue: 0.859, alpha: 0.9)
        let cubeNode = SCNNode(geometry: cube)
        scene.rootNode.addChildNode(cubeNode)
        
//        cubeNode.eulerAngles = SCNVector3(45.degreesToRadians, -45.degreesToRadians, -30.degreesToRadians)

        self.cubeNode = cubeNode

//        // Add an animation to the cube.
//        let animation = CAKeyframeAnimation(keyPath: "rotation")
//
////
//        animation.values = [
//            NSValue(scnVector4: SCNVector4(1, 1, 1, 2.0 * .pi))
//        ]
//        animation.duration = 1
        //        animation.repeatCount = .infinity
        //        cubeNode.addAnimation(animation, forKey: "rotation")
        
        let action = SCNAction.repeatForever(
            SCNAction.rotate(by: .pi,
                             around: SCNVector3(0, 0.5, 0),
                             duration: 3))
        cubeNode.runAction(action)
        
        
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true

    }
    
    var firstValue: Double = 0
    @IBAction func slider1Changed(_ sender: UISlider) {
        let value = (sender.value - 0.5) * 100
        firstValue = Double(value)
        
        print("1: \(value)")
        cameraOrbit.eulerAngles = SCNVector3(
            value.degreesToRadians, Float(secondValue.degreesToRadians), Float(thirdValue.degreesToRadians)
        )
    }
    
    var secondValue: Double = 0
    @IBAction func slider2Changed(_ sender: UISlider) {
        let value = (sender.value - 0.5) * 100
        secondValue = Double(value)
        
        print("2: \(value)")
        cameraOrbit.eulerAngles = SCNVector3(
            Float(firstValue.degreesToRadians), value.degreesToRadians, Float(thirdValue.degreesToRadians)
        )
    }
    
    var thirdValue: Double = 0
    @IBAction func slider3Changed(_ sender: UISlider) {
        let value = (sender.value - 0.5) * 100
        thirdValue = Double(value)
        
        print("3: \(value)")
        cameraOrbit.eulerAngles = SCNVector3(
            Float(firstValue.degreesToRadians), Float(secondValue.degreesToRadians), value.degreesToRadians
        )
    }
    
//    @objc func textFieldChanged() {
//        cubeNode.eulerAngles = SCNVector3(45.degreesToRadians, -45.degreesToRadians, -Int(textField.text!)!.degreesToRadians)
//    }


}

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
