//
//  TwoViewController.swift
//  BookCore
//
//  Created by Zheng on 4/13/21.
//

import UIKit
import SwiftUI
import SceneKit
import PlaygroundSupport


@objc(BookCore_TwoViewController)
public class TwoViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    /*
     public func liveViewMessageConnectionOpened() {
     // Implement this method to be notified when the live view message connection is opened.
     // The connection will be opened when the process running Contents.swift starts running and listening for messages.
     }
     */
    
    /*
     public func liveViewMessageConnectionClosed() {
     // Implement this method to be notified when the live view message connection is closed.
     // The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
     // This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
     }
     */
    
    public func receive(_ message: PlaygroundValue) {
        // Implement this method to receive messages sent from the process running Contents.swift.
        // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
        // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
    }
    
    @IBOutlet weak var sceneViewWrapper: SceneViewWrapper!
    var cubeNode: Node?
    var cameraNode: Node?
    var lineNode: SCNNode?
    var textNode: SCNNode?
    
    var svm1: SlidersViewModel! /// keep reference to cards
    var svm2: SlidersViewModel! /// keep reference to cards
    @IBOutlet weak var slidersReferenceView: UIView!
    
    var isLive = true
    override public func viewDidLoad() {
        super.viewDidLoad()
        isLive ? setupLiveView() : setupMainView()
        sceneViewWrapper.positionZ = 5        
    }
    
    func setupLiveView() {
        self.svm1 = SlidersViewModel()
        self.svm2 = SlidersViewModel()
        
        svm2.x = 50
        svm2.y = 25
        svm2.z = 25
        
        PlaygroundKeyValueStore.current["Two_svm1x"] = .floatingPoint(self.svm1.x)
        PlaygroundKeyValueStore.current["Two_svm1y"] = .floatingPoint(self.svm1.y)
        PlaygroundKeyValueStore.current["Two_svm1z"] = .floatingPoint(self.svm1.z)
        PlaygroundKeyValueStore.current["Two_svm2x"] = .floatingPoint(self.svm2.x)
        PlaygroundKeyValueStore.current["Two_svm2y"] = .floatingPoint(self.svm2.y)
        PlaygroundKeyValueStore.current["Two_svm2z"] = .floatingPoint(self.svm2.z)
        
        SlidersViewModel.didChange = { [weak self] in
            guard let self = self else { return }
            self.cubeNode?.position = Value(x: Float(self.svm1.x), y: Float(self.svm1.y), z:Float(self.svm1.z))
            self.cameraNode?.position = Value(x: Float(self.svm2.x), y: Float(self.svm2.y), z:Float(self.svm2.z))
            
            PlaygroundKeyValueStore.current["Two_svm1x"] = .floatingPoint(self.svm1.x)
            PlaygroundKeyValueStore.current["Two_svm1y"] = .floatingPoint(self.svm1.y)
            PlaygroundKeyValueStore.current["Two_svm1z"] = .floatingPoint(self.svm1.z)
            PlaygroundKeyValueStore.current["Two_svm2x"] = .floatingPoint(self.svm2.x)
            PlaygroundKeyValueStore.current["Two_svm2y"] = .floatingPoint(self.svm2.y)
            PlaygroundKeyValueStore.current["Two_svm2z"] = .floatingPoint(self.svm2.z)

            
            if
                let lineNode = self.lineNode,
                let textNode = self.textNode,
                let scene = self.sceneViewWrapper.sceneView.scene {
                let value1 = Value(
                    x: Float(self.svm1.x) / 100,
                    y: Float(self.svm1.y) / 100,
                    z: Float(self.svm1.z) / 100
                )
                let value2 = Value(
                    x: Float(self.svm2.x) / 100,
                    y: Float(self.svm2.y) / 100,
                    z: Float(self.svm2.z) / 100
                )
                let line = lineMidBetweenNodes(positionA: value1, positionB: value2, inScene: scene)
                updateLineNode(scene: scene, node: lineNode, color: .yellow, distance: line.0, position: line.1, positionB: line.2, lineWorldUp: line.3)
                textNode.position = line.1.offsetZ(by: 0.03)
            }
        }
        
        
        let sliders = TwoSliderView(svm1: svm1, svm2: svm2)
        
        self.addNodes(sceneView: sceneViewWrapper.sceneView)
        self.addLineNodes(sceneView: sceneViewWrapper.sceneView)
        
        let hostingController = UIHostingController(rootView: sliders)
        addChildViewController(hostingController, in: slidersReferenceView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
    }
    
    func setupMainView() {
        
        self.svm1 = SlidersViewModel()
        self.svm2 = SlidersViewModel()
        
        if let keyValue = PlaygroundKeyValueStore.current["Two_svm1x"], case .floatingPoint(let number) = keyValue { svm1.x = number }
        if let keyValue = PlaygroundKeyValueStore.current["Two_svm1y"], case .floatingPoint(let number) = keyValue { svm1.y = number }
        if let keyValue = PlaygroundKeyValueStore.current["Two_svm1z"], case .floatingPoint(let number) = keyValue { svm1.z = number }
        if let keyValue = PlaygroundKeyValueStore.current["Two_svm2x"], case .floatingPoint(let number) = keyValue { svm2.x = number }
        if let keyValue = PlaygroundKeyValueStore.current["Two_svm2y"], case .floatingPoint(let number) = keyValue { svm2.y = number }
        if let keyValue = PlaygroundKeyValueStore.current["Two_svm2z"], case .floatingPoint(let number) = keyValue { svm2.z = number }
        
        let value1 = Value(
            x: Float(svm1.x),
            y: Float(svm1.y),
            z: Float(svm1.z)
        )
        let value2 = Value(
            x: Float(svm2.x),
            y: Float(svm2.y),
            z: Float(svm2.z)
        )

        if let (cubeNode, cameraNode) = mainCode?(sceneViewWrapper.sceneView, value1, value2) {
            self.addLineNodes(
                sceneView: sceneViewWrapper.sceneView,
                cubePosition: cubeNode.position,
                cameraPosition: cameraNode.position
            )
        }
        
        
        let text = PlaygroundPage.current.text
        
        let xValue = text.slice(from: "/*#-editable-code X coordinate*/", to: "/*#-end-editable-code*/.x") ?? ""
        let yValue = text.slice(from: "/*#-editable-code Y coordinate*/", to: "/*#-end-editable-code*/.y") ?? ""
        let zValue = text.slice(from: "/*#-editable-code Z coordinate*/", to: "/*#-end-editable-code*/.z") ?? ""
        
        let squareRoot = text.slice(from: "let everythingInsideSquareRoot = pow(/*#-editable-code Number*/", to: "let distance = sqrt(everythingInsideSquareRoot)")
        let splits = squareRoot?.components(separatedBy: "/*#-end-editable-code*/, 2) + pow(/*#-editable-code Number*/") ?? []
        
        let pow1: String
        let pow2: String
        let pow3: String
        
        if
            splits.indices.contains(0),
            splits.indices.contains(1),
            splits.indices.contains(2)
        {
            pow1 = splits[0]
            pow2 = splits[1]
            pow3 = splits[2].replacingOccurrences(of: "/*#-end-editable-code*/, 2)", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else {
            pow1 = "xDifference"
            pow2 = "yDifference"
            pow3 = "zDifference"
        }
        
        
        let mainView = WalkThrough(
            svm1: svm1,
            svm2: svm2,
            xValueLiteral: xValue,
            yValueLiteral: yValue,
            zValueLiteral: zValue,
            pow1Literal: pow1,
            pow2Literal: pow2,
            pow3Literal: pow3,
            showResult: { (passed, message, result) in
                if passed {
                    let oldColor = UIColor.yellow
                    let newColor = UIColor(named: "BaseGreen")!
                    let duration: TimeInterval = 1
                    let act0 = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
                        let percentage = elapsedTime / CGFloat(duration)
                        node.geometry?.firstMaterial?.diffuse.contents = animateColor(from: newColor, to: oldColor, percentage: percentage)
                    })
                    let act1 = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
                        let percentage = elapsedTime / CGFloat(duration)
                        node.geometry?.firstMaterial?.diffuse.contents = animateColor(from: oldColor, to: newColor, percentage: percentage)
                    })

                    let act = SCNAction.repeatForever(SCNAction.sequence([act0, act1]))
                    self.lineNode?.runAction(act)
                    
                    let text = SCNText(string: result, extrusionDepth: 1)
                    text.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor(named: "BaseGreen")
                    text.materials = [material]
                    
                    self.textNode?.geometry = text
                    
                    
                    
                    PlaygroundPage.current.assessmentStatus = .pass(message: message)
                } else {
                    PlaygroundPage.current.assessmentStatus = .fail(hints: [message], solution: nil)
                }
            }
        )
        
        let hostingController = UIHostingController(rootView: mainView)
        addChildViewController(hostingController, in: slidersReferenceView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
        
        
    }
    
    var mainCode: ((SCNView, Value, Value) -> (Node, Node))?
    
    func addNodes(sceneView: SCNView) {
        let cubeNode = Node()
        cubeNode.shape = .cube
        cubeNode.color = UIColor.red
        cubeNode.position = Value(x: 0, y: 0, z: 0)
        sceneView.scene?.addNode(cubeNode)

        self.cubeNode = cubeNode

        let cameraNode = Node()
        cameraNode.shape = .pyramid
        cameraNode.color = UIColor.darkGray
        cameraNode.position = Value(x: 50, y: 25, z: 25)
        sceneView.scene?.addNode(cameraNode)

        self.cameraNode = cameraNode
        
    }
    func addLineNodes(sceneView: SCNView, cubePosition: Value? = nil, cameraPosition: Value? = nil) {
        let value1: Value
        let value2: Value
        
        if
            let cubePosition = cubePosition,
            let cameraPosition = cameraPosition
        {
            value1 = Value(
                x: Float(cubePosition.x) / 100,
                y: Float(cubePosition.y) / 100,
                z: Float(cubePosition.z) / 100
            )
            value2 = Value(
                x: Float(cameraPosition.x) / 100,
                y: Float(cameraPosition.y) / 100,
                z: Float(cameraPosition.z) / 100
            )
        } else {
            
            value1 = Value(
                x: Float(svm1.x) / 100,
                y: Float(svm1.y) / 100,
                z: Float(svm1.z) / 100
            )
            value2 = Value(
                x: Float(svm2.x) / 100,
                y: Float(svm2.y) / 100,
                z: Float(svm2.z) / 100
            )
        }
        
        if let scene = sceneView.scene {
            let line = lineMidBetweenNodes(positionA: value1, positionB: value2, inScene: scene)
            let lineNode = SCNNode()
            updateLineNode(scene: scene, node: lineNode, color: .yellow, distance: line.0, position: line.1, positionB: line.2, lineWorldUp: line.3)
            
            sceneView.scene?.rootNode.addChildNode(lineNode)
            self.lineNode = lineNode
            
            let text = SCNText(string: "?", extrusionDepth: 1)
            text.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(named: "BaseGreen")
            text.materials = [material]
            
            let textNode = SCNNode()
            textNode.geometry = text
            textNode.scale = SCNVector3(0.006, 0.006, 0.006)
            
            let lookAtConstraint = SCNBillboardConstraint()
            textNode.constraints = [lookAtConstraint]
            textNode.position = line.1.offsetZ(by: 0.03)
            
            /// center text node correctly
            /// from https://stackoverflow.com/a/49860463/14351818
            let (min, max) = textNode.boundingBox
            let dx = min.x + 0.5 * (max.x - min.x)
            let dy = min.y + 0.5 * (max.y - min.y)
            let dz = min.z + 0.5 * (max.z - min.z)
            textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
            
            sceneView.scene?.rootNode.addChildNode(textNode)
            self.textNode = textNode
        }
    }
}

extension SCNVector3 {
    func offsetZ(by float: Float) -> SCNVector3 {
        let vector = SCNVector3(self.x, self.y, self.z + float)
        return vector
    }
}

/// from https://stackoverflow.com/a/31727051/14351818
extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
