//
//  ViewController.swift
//  RotatingScene
//
//  Created by Zheng on 4/10/21.
//

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneReferenceView: UIView!
    @IBOutlet weak var particleReferenceView: UIView!
    
    var cubeNode: SCNNode!
    var cameraOrbitNode: SCNNode!
    
    var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = SCNView()
        sceneView.frame = sceneReferenceView.bounds
        sceneReferenceView.addSubview(sceneView)
        
        let scene = SCNScene()
        
        let camera = SCNCamera()
        camera.fieldOfView = 10
        
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        cameraNode.camera = camera
        
        let cameraOrbitNode = SCNNode()
        cameraOrbitNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraOrbitNode)
        
        self.cameraOrbitNode = cameraOrbitNode
        
        
        let cube = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        cube.firstMaterial?.diffuse.contents = UIColor(red: 0.149, green: 0.604, blue: 0.859, alpha: 0.9)
        
        let cubeNode = SCNNode(geometry: cube)
        scene.rootNode.addChildNode(cubeNode)
        
        self.cubeNode = cubeNode
        
        let action = SCNAction.repeatForever(
            SCNAction.rotate(
                by: .pi,
                around: SCNVector3(0, 0.5, 0),
                duration: 3
            )
        )
        cubeNode.runAction(action)
        
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        
        let spriteKitView: SKView = SKView()
        spriteKitView.frame = particleReferenceView.bounds
        spriteKitView.backgroundColor = .clear
        particleReferenceView.addSubview(spriteKitView)
        
        let sprikeScene: SKScene = SKScene(size: particleReferenceView.bounds.size)
        sprikeScene.scaleMode = .aspectFit
        sprikeScene.backgroundColor = .clear
        
        if let emitter = SKEmitterNode(fileNamed: "Particles.sks") {
            emitter.position = spriteKitView.center
            
            sprikeScene.addChild(emitter)
            spriteKitView.presentScene(sprikeScene)
        }
        particleReferenceView.alpha = 0
        
    }
    
    func scale(up: Bool) {
        if up {
            let scaleAction = SCNAction.scale(to: 1.5, duration: 0.1)
            let fadeAction = SCNAction.fadeOpacity(to: 0.6, duration: 0.1)
            let group = SCNAction.group([
                scaleAction,
                fadeAction
            ])
            cubeNode.runAction(group)
            
            UIView.animate(withDuration: 0.1) {
                self.particleReferenceView.alpha = 1
            }
        } else {
            let scaleAction = SCNAction.scale(to: 1, duration: 0.1)
            let fadeAction = SCNAction.fadeOpacity(to: 1, duration: 0.1)
            let group = SCNAction.group([
                scaleAction,
                fadeAction
            ])
            cubeNode.runAction(group)
            
            UIView.animate(withDuration: 0.1) {
                self.particleReferenceView.alpha = 0
            }
        }
        
    }
    
    var firstValue: Double = -0.35
    @IBAction func slider1Changed(_ sender: UISlider) {
        let value = (sender.value - 0.5) * 100
        firstValue = Double(value)
        
        print("1: \(value)")
        cameraOrbitNode.eulerAngles = SCNVector3(
            value.degreesToRadians, Float(secondValue.degreesToRadians), Float(thirdValue.degreesToRadians)
        )
    }
    
    var secondValue: Double = 0
    @IBAction func slider2Changed(_ sender: UISlider) {
        //        let value = (sender.value - 0.5) * 100
        //        secondValue = Double(value)
        //
        //        print("2: \(value)")
        //        cameraOrbit.eulerAngles = SCNVector3(
        //            Float(firstValue.degreesToRadians), value.degreesToRadians, Float(thirdValue.degreesToRadians)
        //        )
        scale(up: false)
    }
    
    var thirdValue: Double = 0
    @IBAction func slider3Changed(_ sender: UISlider) {
        //        let value = (sender.value - 0.5) * 100
        //        thirdValue = Double(value)
        //
        //        print("3: \(value)")
        //        cameraOrbit.eulerAngles = SCNVector3(
        //            Float(firstValue.degreesToRadians), Float(secondValue.degreesToRadians), value.degreesToRadians
        //        )
        //
        scale(up: true)
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
