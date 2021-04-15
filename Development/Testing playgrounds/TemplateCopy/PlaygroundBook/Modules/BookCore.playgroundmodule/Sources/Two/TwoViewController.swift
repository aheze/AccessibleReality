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
    
    var svm1: SlidersViewModel! /// keep reference to cards
    var svm2: SlidersViewModel! /// keep reference to cards
    @IBOutlet weak var slidersReferenceView: UIView!
    
    var isLive = true
    override public func viewDidLoad() {
        super.viewDidLoad()
        isLive ? setupLiveView() : setupMainView()
        sceneViewWrapper.positionZ = 5

        let text = PlaygroundPage.current.text
        
        let xValue = text.slice(from: "/*#-editable-code X coordinate*/", to: "/*#-end-editable-code*/.x") ?? ""
        let yValue = text.slice(from: "/*#-editable-code Y coordinate*/", to: "/*#-end-editable-code*/.y") ?? ""
        let zValue = text.slice(from: "/*#-editable-code Z coordinate*/", to: "/*#-end-editable-code*/.z") ?? ""
        
        let squareRoot = text.slice(from: "let everythingInsideSquareRoot = pow(/*#-editable-code Number*/", to: "let distance = sqrt(everythingInsideSquareRoot)")
        let splits = squareRoot?.components(separatedBy: "/*#-end-editable-code*/, 2) + pow(/*#-editable-code Number*/") ?? []
        
        if
            splits.indices.contains(0),
            splits.indices.contains(1),
            splits.indices.contains(2)
        {
            let pow1 = splits[0]
            let pow2 = splits[1]
            let pow3 = splits[2].replacingOccurrences(of: "/*#-end-editable-code*/, 2)", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            let textField = UILabel()
//            self.view.addSubview(textField)
//            textField.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                textField.topAnchor.constraint(equalTo: self.view.topAnchor),
//                textField.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//                textField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//                textField.leftAnchor.constraint(equalTo: self.view.leftAnchor)
//            ])
//            textField.numberOfLines = 0
//            textField.text = "xValue: \(xValue)\n\(yValue)\n\(zValue)\nSQ:\(squareRoot)\n\n\n SPLITTTT\(splits.prefix(3))"
//        }
    }
    
    func setupLiveView() {
        self.svm1 = SlidersViewModel()
        self.svm2 = SlidersViewModel()
        
        svm2.x = 50
        svm2.y = 25
        svm2.z = 25
        
        SlidersViewModel.didChange = { [weak self] in
            guard let self = self else { return }
            self.cubeNode?.position = Value(x: Float(self.svm1.x), y: Float(self.svm1.y), z:Float(self.svm1.z))
            self.cameraNode?.position = Value(x: Float(self.svm2.x), y: Float(self.svm2.y), z:Float(self.svm2.z))
        }
        
        
        let sliders = TwoSliderView(svm1: svm1, svm2: svm2)
        
        self.addNodes(sceneView: sceneViewWrapper.sceneView)
        
        let hostingController = UIHostingController(rootView: sliders)
        addChildViewController(hostingController, in: slidersReferenceView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
    }
    
    func setupMainView() {
        mainCode?(sceneViewWrapper.sceneView)
        
        self.svm1 = SlidersViewModel()
        self.svm2 = SlidersViewModel()
        
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
            pow3Literal: pow3
        )
        
        self.addNodes(sceneView: sceneViewWrapper.sceneView)
        
        let hostingController = UIHostingController(rootView: mainView)
        addChildViewController(hostingController, in: slidersReferenceView)
        
        UIScrollView.appearance().alwaysBounceVertical = false
        
        
    }
    
    var mainCode: ((SCNView) -> Void)?
    
    func addNodes(sceneView: SCNView) {
        let cubeNode = Node()
        cubeNode.shape = .cube
        cubeNode.color = UIColor.red
        cubeNode.position = Value(x: 0, y: 0, z: 0)
        sceneView.scene?.addNode(cubeNode)
        
        self.cubeNode = cubeNode
        
        let cameraNode = Node()
        cameraNode.shape = .pyramid
        cameraNode.color = UIColor.black
        cameraNode.position = Value(x: 50, y: 25, z: 25)
        sceneView.scene?.addNode(cameraNode)
        
        self.cameraNode = cameraNode
    }
}

public typealias Number = Float


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
