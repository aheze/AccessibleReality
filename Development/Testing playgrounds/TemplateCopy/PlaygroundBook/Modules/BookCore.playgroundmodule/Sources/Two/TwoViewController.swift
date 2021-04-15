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
        
        UIScrollView.appearance().bounces = false
    }
    
    func setupMainView() {
        mainCode?(sceneViewWrapper.sceneView)
    }
    
    var mainCode: ((SCNView) -> Value)?
    
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
