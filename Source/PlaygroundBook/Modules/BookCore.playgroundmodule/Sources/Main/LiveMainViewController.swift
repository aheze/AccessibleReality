//
//  LiveMainViewController.swift
//  BookCore
//
//  Created by Zheng on 4/17/21.
//


import UIKit
import SwiftUI
import SceneKit
import PlaygroundSupport
@objc(BookCore_LiveMainViewController)
public class LiveMainViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
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
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sceneViewWrapper: SceneViewWrapper!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = SCNText(string: "Thank\nYou!", extrusionDepth: 18)
        text.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(named: "BaseGreen")
        text.materials = [material]
        
        let textNode = SCNNode()
        textNode.geometry = text
        textNode.scale = SCNVector3(0.006, 0.006, 0.006)
        textNode.position = SCNVector3(0, 0, 0)
        
        /// center text node correctly
        /// from https://stackoverflow.com/a/49860463/14351818
        let (min, max) = textNode.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        sceneViewWrapper.sceneView.scene?.rootNode.addChildNode(textNode)
        sceneViewWrapper.setCustomOrbit()
        sceneViewWrapper.hideGrid()
        sceneViewWrapper.positionZ = 18
        sceneViewWrapper.backgroundColor = .clear
        sceneViewWrapper.sceneView.backgroundColor = .clear
        
        let action = SCNAction.repeatForever(
            SCNAction.rotate(
                by: .pi,
                around: SCNVector3(0, 0.5, 0),
                duration: 6
            )
        )
        textNode.runAction(action)
        

    }
    
    @IBOutlet weak var colorView: UIView!
    
    var currentColorCount = 0
    let colors: [UIColor] = [
        #colorLiteral(red: 1, green: 0.160998218, blue: 0, alpha: 1),
        #colorLiteral(red: 1, green: 0.7077411882, blue: 0.001607940936, alpha: 1),
        #colorLiteral(red: 0.9696431685, green: 1, blue: 0, alpha: 1),
        #colorLiteral(red: 0.007977302757, green: 1, blue: 0, alpha: 1),
        #colorLiteral(red: 0, green: 0.7879274052, blue: 1, alpha: 1),
        #colorLiteral(red: 0, green: 0.2005294328, blue: 1, alpha: 1),
        #colorLiteral(red: 0.629867968, green: 0, blue: 1, alpha: 1),
        #colorLiteral(red: 1, green: 0, blue: 0.7005294328, alpha: 1),
    ]
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToNextColor()
    }
    
    func animateToNextColor() {
        if currentColorCount == colors.count - 1 {
            currentColorCount = 0
        } else {
            currentColorCount += 1
        }
        let newColor = colors[currentColorCount].withAlphaComponent(0.1)
        UIView.animate(withDuration: 3) {
            self.colorView.backgroundColor = newColor
        } completion: { _ in
            self.animateToNextColor()
        }
    }

}
