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
    
    var svmV: SlidersViewModel!
    var svm1: SlidersViewModel!
    var svm2R: SlidersViewModel!
    var svm2: ReadOnlySlidersViewModel!
    
    let defaultCubePosition = Value(x: 0, y: 0, z: 0)
    let defaultCameraPosition = Value(x: 50, y: 45, z: 30)
    let defaultCameraRotation = Value(x: 50, y: 0, z: 0)
    
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

        svmV.x = Double(defaultCameraPosition.x)
        svmV.y = Double(defaultCameraPosition.y)
        svmV.z = Double(defaultCameraPosition.z)
        
        svm1.x = Double(defaultCubePosition.x)
        svm1.y = Double(defaultCubePosition.y)
        svm1.z = Double(defaultCubePosition.z)
        
        svm2R.x = Double(defaultCameraRotation.x)
        svm2R.y = Double(defaultCameraRotation.y)
        svm2R.z = Double(defaultCameraRotation.z)
        

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
            
            PlaygroundKeyValueStore.current["Two_svm1x"] = .floatingPoint(self.svm1.x)
            PlaygroundKeyValueStore.current["Two_svm1y"] = .floatingPoint(self.svm1.y)
            PlaygroundKeyValueStore.current["Two_svm1z"] = .floatingPoint(self.svm1.z)
            PlaygroundKeyValueStore.current["Two_svm2x"] = .floatingPoint(self.svm2.x)
            PlaygroundKeyValueStore.current["Two_svm2y"] = .floatingPoint(self.svm2.y)
            PlaygroundKeyValueStore.current["Two_svm2z"] = .floatingPoint(self.svm2.z)
        }
//        
//        func distanceFormula3D(position1: Value, position2: Value) -> Number {
//            let xDifference = position1.x - position2.x
//            let yDifference = position1.y - position2.y
//            let zDifference = position1.z - position2.z
//
//            let everythingInsideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
//            let distance = sqrt(everythingInsideSquareRoot)
//            
//            return Number(distance)
//        }
//
//        func angle3D(vertex: Value, position1: Value, position2: Value) -> Number {
//            let vector1 = Value(
//                x: position1.x - vertex.x,
//                y: position1.y - vertex.y,
//                z: position1.z - vertex.z
//            )
//            let vector2 = Value(
//                x: position2.x - vertex.x,
//                y: position2.y - vertex.y,
//                z: position2.z - vertex.z
//            )
//            
//            let xProduct = vector1.x * vector2.x
//            let yProduct = vector1.y * vector2.y
//            let zProduct = vector1.z * vector2.z
//
//            let dotProduct = xProduct + yProduct + zProduct
//            let vertexToPosition1 = distanceFormula3D(position1: vertex, position2: position1)
//            let vertexToPosition2 = distanceFormula3D(position1: vertex, position2: position2)
//
//            let cosineOfAngle = dotProduct / (vertexToPosition1 * vertexToPosition2)
//            let angle = acos(cosineOfAngle)
//            return angle
//        }
//        
//        

        let sliderView = FourSliderView(svm1: svm1, svmV: svmV, svm2R: svm2R, svm2: svm2)
        
        
        let cubeNode = Node()
        cubeNode.color = UIColor.red
        cubeNode.position = defaultCubePosition
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cubeNode)
        self.cubeNode = cubeNode
        
        let cameraNode = Node()
        cameraNode.shape = .pyramid
        cameraNode.color = UIColor.darkGray
        cameraNode.position = defaultCameraPosition
        cameraNode.rotation = defaultCameraRotation
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cameraNode)
        self.cameraNode = cameraNode
        
        let position = combine(self.cameraNode!.transform, with: Value(x: 0, y: -50, z: 0))
        let directionNode = Node()
        directionNode.shape = .sphere
        directionNode.color = UIColor.systemTeal
        directionNode.position = position
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(directionNode)
        self.directionNode = directionNode
        
        svm2.x = Double(position.x)
        svm2.y = Double(position.y)
        svm2.z = Double(position.z)
        
        
        let hostingController = UIHostingController(rootView: sliderView)
        addChildViewController(hostingController, in: slidersReferenceView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
    }
    
    func setupMainView() {
        
        self.svmV = SlidersViewModel()
        self.svm1 = SlidersViewModel()
        self.svm2R = SlidersViewModel()
        self.svm2 = ReadOnlySlidersViewModel()
        
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

        let cubeNode = Node()
        cubeNode.color = UIColor.red
        cubeNode.position = defaultCubePosition
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cubeNode)
        self.cubeNode = cubeNode
        
        let cameraNode = Node()
        cameraNode.shape = .pyramid
        cameraNode.color = UIColor.darkGray
        cameraNode.position = defaultCameraPosition
        cameraNode.rotation = defaultCameraRotation
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(cameraNode)
        self.cameraNode = cameraNode
        
        let position = combine(self.cameraNode!.transform, with: Value(x: 0, y: -50, z: 0))
        let directionNode = Node()
        directionNode.shape = .sphere
        directionNode.color = UIColor.systemTeal
        directionNode.position = position
        sceneViewWrapper.sceneView.scene?.rootNode.addNode(directionNode)
        self.directionNode = directionNode
        
        mainCode?(cameraNode, cubeNode, directionNode)
        
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
        
//        let mainView = WalkThrough(
//            svm1: svm1,
//            svm2: svm2,
//            xValueLiteral: xValue,
//            yValueLiteral: yValue,
//            zValueLiteral: zValue,
//            pow1Literal: pow1,
//            pow2Literal: pow2,
//            pow3Literal: pow3,
//            showResult: { (passed, message) in
//                if passed {
//                    PlaygroundPage.current.assessmentStatus = .pass(message: message)
//                } else {
//                    PlaygroundPage.current.assessmentStatus = .fail(hints: [message], solution: nil)
//                }
//                
//            }
//        )
//        
//        self.addNodes(sceneView: sceneViewWrapper.sceneView)
//        
//        let hostingController = UIHostingController(rootView: mainView)
//        addChildViewController(hostingController, in: slidersReferenceView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
        
        
    }
    
    var mainCode: ((Node, Node, Node) -> Void)?
    

}
