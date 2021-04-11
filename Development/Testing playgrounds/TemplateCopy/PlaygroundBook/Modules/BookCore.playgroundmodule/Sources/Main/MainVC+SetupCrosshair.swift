//
//  MainVC+SetupCrosshair.swift
//  BookCore
//
//  Created by Zheng on 4/10/21.
//

import UIKit
import SceneKit
import SpriteKit

extension MainViewController {
    func setupCrosshair() {
        // MARK: Crosshair View
        let crosshairView = UIView()
        crosshairView.backgroundColor = .clear
        crosshairView.isUserInteractionEnabled = false
        view.addSubview(crosshairView)
        
        /// Positioning constraints
        crosshairView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crosshairView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            crosshairView.widthAnchor.constraint(equalToConstant: 100),
            crosshairView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        self.crosshairView = crosshairView
        
        // MARK: Crosshair content view (contains cube and particles)
        let crosshairContentView = UIView()
        crosshairContentView.backgroundColor = .clear
        crosshairContentView.isUserInteractionEnabled = false
        view.addSubview(crosshairContentView)
        
        /// Positioning constraints
        crosshairContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crosshairContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            crosshairContentView.widthAnchor.constraint(equalToConstant: 100),
            crosshairContentView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        self.crosshairContentView = crosshairContentView
        
        // MARK: Crosshair cube view
        let crosshairCubeSceneView = SCNView()
        crosshairCubeSceneView.backgroundColor = .clear
        crosshairContentView.addSubview(crosshairCubeSceneView)
        
        /// Positioning constraints
        crosshairCubeSceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairCubeSceneView.centerXAnchor.constraint(equalTo: crosshairView.centerXAnchor),
            crosshairCubeSceneView.centerYAnchor.constraint(equalTo: crosshairView.centerYAnchor),
            crosshairCubeSceneView.widthAnchor.constraint(equalToConstant: 300),
            crosshairCubeSceneView.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        let cubeScene = SCNScene()
        
        let camera = SCNCamera()
        camera.fieldOfView = 10
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        cameraNode.camera = camera
        let cameraOrbitNode = SCNNode()
        cameraOrbitNode.addChildNode(cameraNode)
        cameraOrbitNode.eulerAngles = SCNVector3(-35.degreesToRadians, 0, 0)
        cubeScene.rootNode.addChildNode(cameraOrbitNode)
        
        let cube = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        cube.firstMaterial?.diffuse.contents = UIColor(red: 0.149, green: 0.604, blue: 0.859, alpha: 0.9)
        
        let crosshairCubeNode = SCNNode(geometry: cube)
        cubeScene.rootNode.addChildNode(crosshairCubeNode)
        
        self.crosshairCubeNode = crosshairCubeNode
        
        let action = SCNAction.repeatForever(
            SCNAction.rotate(
                by: .pi,
                around: SCNVector3(0, 0.5, 0),
                duration: 3
            )
        )
        crosshairCubeNode.runAction(action)
        crosshairCubeSceneView.scene = cubeScene
        crosshairCubeSceneView.autoenablesDefaultLighting = true
        
        // MARK: Crosshair particle effect view
        let crosshairCubeParticleView = SKView()
        crosshairCubeParticleView.backgroundColor = .clear
        crosshairContentView.addSubview(crosshairCubeParticleView)
        
        /// Positioning constraints
        crosshairCubeParticleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairCubeParticleView.centerXAnchor.constraint(equalTo: crosshairView.centerXAnchor),
            crosshairCubeParticleView.centerYAnchor.constraint(equalTo: crosshairView.centerYAnchor),
            crosshairCubeParticleView.widthAnchor.constraint(equalToConstant: 300),
            crosshairCubeParticleView.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        let sprikeScene: SKScene = SKScene(size: CGSize(width: 300, height: 300))
        sprikeScene.scaleMode = .aspectFit
        sprikeScene.backgroundColor = .clear
        
        if let emitter = SKEmitterNode(fileNamed: "Particles.sks") {
            emitter.position = CGPoint(x: 150, y: 150)
            
            sprikeScene.addChild(emitter)
            crosshairCubeParticleView.presentScene(sprikeScene)
        }
        
        self.crosshairCubeParticleView = crosshairCubeParticleView
        
        // MARK: Crosshair Image View
        let crosshairImageView = UIImageView()
        crosshairImageView.backgroundColor = .clear
        crosshairImageView.isUserInteractionEnabled = false
        
        let plusConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        let plusImage = UIImage(systemName: "plus", withConfiguration: plusConfiguration)
        crosshairImageView.image = plusImage
        crosshairImageView.tintColor = UIColor.white
        crosshairView.addSubview(crosshairImageView)
        
        /// Positioning constraints
        crosshairImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairImageView.centerXAnchor.constraint(equalTo: crosshairView.centerXAnchor),
            crosshairImageView.centerYAnchor.constraint(equalTo: crosshairView.centerYAnchor),
            crosshairImageView.widthAnchor.constraint(equalToConstant: 30),
            crosshairImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        self.crosshairImageView = crosshairImageView
        
        scaleCubeOverlay(up: false)
    }
}

