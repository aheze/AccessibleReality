//
//  ThreeViewController.swift
//  BookCore
//
//  Created by Zheng on 4/15/21.
//

import UIKit
import SwiftUI
import SceneKit
import PlaygroundSupport


@objc(BookCore_ThreeViewController)
public class ThreeViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
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
    var directionNode: Node?
    
    var line1Node: SCNNode?
    var line2Node: SCNNode?
    var textNode: SCNNode? = SCNNode()
    
    var svmV: SlidersViewModel!
    var svm1: SlidersViewModel!
    var svm2R: SlidersViewModel!
    var svm2: ReadOnlySlidersViewModel!
    
    
    @IBOutlet weak var slidersReferenceView: UIView!
    
    var isLive = true
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        isLive ? setupLiveView() : setupMainView()
        sceneViewWrapper.positionZ = 5
    }
    
    func setupLiveView() {
        self.svmV = SlidersViewModel()
        self.svm1 = SlidersViewModel()
        self.svm2R = SlidersViewModel()
        self.svm2 = ReadOnlySlidersViewModel()

        svmV.x = Double(50)
        svmV.y = Double(45)
        svmV.z = Double(30)
        
        svm1.x = Double(0)
        svm1.y = Double(0)
        svm1.z = Double(0)
        
        svm2R.x = Double(50)
        svm2R.y = Double(0)
        svm2R.z = Double(0)
        
        updatePositionStore()

        SlidersViewModel.didChange = { [weak self] in
            guard let self = self else { return }
            
            self.cubeNode?.position = Value(x: Float(self.svm1.x), y: Float(self.svm1.y), z:Float(self.svm1.z))
            self.cameraNode?.position = Value(x: Float(self.svmV.x), y: Float(self.svmV.y), z:Float(self.svmV.z))
            self.cameraNode?.rotation = Value(x: Float(self.svm2R.x), y: Float(self.svm2R.y), z:Float(self.svm2R.z))
            
            let position = combine(self.cameraNode!.transform, with: Value(x: 0, y: -50, z: 0))
            self.directionNode?.position = position
            self.svm2.x = Double(position.x)
            self.svm2.y = Double(position.y)
            self.svm2.z = Double(position.z)
            
            self.updatePositionStore()
            
            if
                let line1Node = self.line1Node,
                let line2Node = self.line2Node,
                let textNode = self.textNode,
                let scene = self.sceneViewWrapper.sceneView.scene
            {
                let valueV = Value(
                    x: Float(self.svmV.x) / 100,
                    y: Float(self.svmV.y) / 100,
                    z: Float(self.svmV.z) / 100
                )
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
                let line1 = lineMidBetweenNodes(positionA: valueV, positionB: value1, inScene: scene)
                let line2 = lineMidBetweenNodes(positionA: valueV, positionB: value2, inScene: scene)
                updateLineNode(scene: scene, node: line1Node, color: .yellow, distance: line1.0, position: line1.1, positionB: line1.2, lineWorldUp: line1.3)
                updateLineNode(scene: scene, node: line2Node, color: .yellow, distance: line2.0, position: line2.1, positionB: line2.2, lineWorldUp: line2.3)
                
//                textNode.position = line.1.offsetZ(by: 0.03)
            }
        }

        let sliderView = FourSliderView(svm1: svm1, svmV: svmV, svm2R: svm2R, svm2: svm2)
        
        let cubeNode = Node()
        let cameraNode = Node()
        let directionNode = Node()
        self.cubeNode = cubeNode
        self.cameraNode = cameraNode
        self.directionNode = directionNode
        
        let position = self.addNodes(cubeNode: cubeNode, cameraNode: cameraNode, directionNode: directionNode)
        
        svm2.x = Double(position.x)
        svm2.y = Double(position.y)
        svm2.z = Double(position.z)
        
        
        let hostingController = UIHostingController(rootView: sliderView)
        addChildViewController(hostingController, in: slidersReferenceView)
        
        self.addLineNodes(sceneView: sceneViewWrapper.sceneView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
    }
    
    func setupMainView() {
        
        self.svmV = SlidersViewModel()
        self.svm1 = SlidersViewModel()
        self.svm2R = SlidersViewModel()
        self.svm2 = ReadOnlySlidersViewModel()
        
        if let keyValue = PlaygroundKeyValueStore.current["Three_svmVx"], case .floatingPoint(let number) = keyValue { svmV.x = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svmVy"], case .floatingPoint(let number) = keyValue { svmV.y = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svmVz"], case .floatingPoint(let number) = keyValue { svmV.z = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svm1x"], case .floatingPoint(let number) = keyValue { svm1.x = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svm1y"], case .floatingPoint(let number) = keyValue { svm1.y = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svm1z"], case .floatingPoint(let number) = keyValue { svm1.z = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svm2Rx"], case .floatingPoint(let number) = keyValue { svm2R.x = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svm2Ry"], case .floatingPoint(let number) = keyValue { svm2R.y = number }
        if let keyValue = PlaygroundKeyValueStore.current["Three_svm2Rz"], case .floatingPoint(let number) = keyValue { svm2R.z = number }
        
        
        let cubeNode = Node()
        let cameraNode = Node()
        let directionNode = Node()
        self.cubeNode = cubeNode
        self.cameraNode = cameraNode
        self.directionNode = directionNode

        let position = self.addNodes(cubeNode: cubeNode, cameraNode: cameraNode, directionNode: directionNode)
        
        svm2.x = Double(position.x)
        svm2.y = Double(position.y)
        svm2.z = Double(position.z)
        
        mainCode?(cameraNode, cubeNode, directionNode)
        
        let text = PlaygroundPage.current.text
        
        let dotProduct = text.slice(from: "let dotProduct = /*#-editable-code Number*/", to: "let vertexToPosition1 = distanceFormula3D")
        let splits = dotProduct?.components(separatedBy: "/*#-end-editable-code*/ + /*#-editable-code Number*/") ?? []
        
        let xProduct: String
        let yProduct: String
        let zProduct: String
        if
            splits.indices.contains(0),
            splits.indices.contains(1),
            splits.indices.contains(2)
        {
            xProduct = splits[0]
            yProduct = splits[1]
            zProduct = splits[2].replacingOccurrences(of: "/*#-end-editable-code*/", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else {
            xProduct = "xProduct"
            yProduct = "yProduct"
            zProduct = "zProduct"
        }
        
        
        let cosineOfAngle = text.slice(from: "let angle = acos(/*#-editable-code Number*/", to: "/*#-end-editable-code*/)") ?? ""
        
        let mainView = AngleWalkThrough(
            svmV: svmV,
            svm1: svm1,
            svm2: svm2,
            xProductLiteral: xProduct,
            yProductLiteral: yProduct,
            zProductLiteral: zProduct,
            acosLiteral: cosineOfAngle
        )
        
        let hostingController = UIHostingController(rootView: mainView)
        addChildViewController(hostingController, in: slidersReferenceView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
        
        
    }
    
    var mainCode: ((Node, Node, Node) -> Void)?
    
    func updatePositionStore() {
        PlaygroundKeyValueStore.current["Three_svmVx"] = .floatingPoint(self.svmV.x)
        PlaygroundKeyValueStore.current["Three_svmVy"] = .floatingPoint(self.svmV.y)
        PlaygroundKeyValueStore.current["Three_svmVz"] = .floatingPoint(self.svmV.z)
        PlaygroundKeyValueStore.current["Three_svm1x"] = .floatingPoint(self.svm1.x)
        PlaygroundKeyValueStore.current["Three_svm1y"] = .floatingPoint(self.svm1.y)
        PlaygroundKeyValueStore.current["Three_svm1z"] = .floatingPoint(self.svm1.z)
        PlaygroundKeyValueStore.current["Three_svm2Rx"] = .floatingPoint(self.svm2R.x)
        PlaygroundKeyValueStore.current["Three_svm2Ry"] = .floatingPoint(self.svm2R.y)
        PlaygroundKeyValueStore.current["Three_svm2Rz"] = .floatingPoint(self.svm2R.z)
        PlaygroundKeyValueStore.current["Three_svm2x"] = .floatingPoint(self.svm2.x)
        PlaygroundKeyValueStore.current["Three_svm2y"] = .floatingPoint(self.svm2.y)
        PlaygroundKeyValueStore.current["Three_svm2z"] = .floatingPoint(self.svm2.z)
        
    }

    func addNodes(cubeNode: Node, cameraNode: Node, directionNode: Node) -> Value {
       
        let cubePosition = Value(
            x: Number(svm1.x),
            y: Number(svm1.y),
            z: Number(svm1.z)
        )
        let cameraPosition = Value(
            x: Number(svmV.x),
            y: Number(svmV.y),
            z: Number(svmV.z)
        )
        let cameraRotation = Value(
            x: Number(svm2R.x),
            y: Number(svm2R.y),
            z: Number(svm2R.z)
        )
        
        cubeNode.color = UIColor.red
        cubeNode.position = cubePosition
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cubeNode)
        
        cameraNode.shape = .pyramid
        cameraNode.color = UIColor.darkGray
        cameraNode.position = cameraPosition
        cameraNode.rotation = cameraRotation
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cameraNode)
        
        let position = combine(self.cameraNode!.transform, with: Value(x: 0, y: -50, z: 0))
        directionNode.shape = .sphere
        directionNode.color = UIColor.systemTeal
        directionNode.position = position
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(directionNode)
        
        return position
    }
    func addLineNodes(sceneView: SCNView) {
        
        let valueV = Value(
            x: Float(svmV.x) / 100,
            y: Float(svmV.y) / 100,
            z: Float(svmV.z) / 100
        )
        let value1 = Value(
            x: Float(svm1.x) / 100,
            y: Float(svm1.y) / 100,
            z: Float(svm1.z) / 100
        )
        let value2 = Value(
            x: Float(svm2.x) / 100,
            y: Float(svm2.y) / 100,
            z: Float(svm2.z) / 100
        )
        
        if let scene = sceneView.scene {
            
            let line1 = lineMidBetweenNodes(positionA: valueV, positionB: value1, inScene: scene)
            let line2 = lineMidBetweenNodes(positionA: valueV, positionB: value2, inScene: scene)
            
            let line1Node = SCNNode()
            let line2Node = SCNNode()
            
            updateLineNode(scene: scene, node: line1Node, color: .yellow, distance: line1.0, position: line1.1, positionB: line1.2, lineWorldUp: line1.3)
            updateLineNode(scene: scene, node: line2Node, color: .yellow, distance: line2.0, position: line2.1, positionB: line2.2, lineWorldUp: line2.3)
            
            sceneView.scene?.rootNode.addChildNode(line1Node)
            sceneView.scene?.rootNode.addChildNode(line2Node)
            self.line1Node = line1Node
            self.line2Node = line2Node
            
//            let text = SCNText(string: "?", extrusionDepth: 1)
//            text.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//
//            let material = SCNMaterial()
//            material.diffuse.contents = UIColor(named: "BaseGreen")
//            text.materials = [material]
//
//            let textNode = SCNNode()
//            textNode.geometry = text
//            textNode.scale = SCNVector3(0.006, 0.006, 0.006)
//
//            let lookAtConstraint = SCNBillboardConstraint()
//            textNode.constraints = [lookAtConstraint]
//            textNode.position = line.1.offsetZ(by: 0.03)
//
//            /// center text node correctly
//            /// from https://stackoverflow.com/a/49860463/14351818
//            let (min, max) = textNode.boundingBox
//            let dx = min.x + 0.5 * (max.x - min.x)
//            let dy = min.y + 0.5 * (max.y - min.y)
//            let dz = min.z + 0.5 * (max.z - min.z)
//            textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
//
//            sceneView.scene?.rootNode.addChildNode(textNode)
//            self.textNode = textNode
        }
    }
}

