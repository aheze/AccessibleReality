//
//  OneViewController.swift
//  BookCore
//
//  Created by Zheng on 4/12/21.
//

import UIKit
import SwiftUI
import SceneKit
import PlaygroundSupport

class SlidersViewModel: ObservableObject {
    @Published var x = Double(0)
    @Published var y = Double(0)
    @Published var z = Double(0)
    
    static var didChange: (() -> Void)?
}

@objc(BookCore_OneViewController)
public class OneViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
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
    
    
    
    var svm: SlidersViewModel! /// keep reference to cards
    
    var isLive = true
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sceneViewWrapper: SceneViewWrapper!
    @IBOutlet weak var crosshairView: UIView!
    @IBOutlet weak var crosshairImageView: UIImageView!
    
    @IBOutlet var panGestures: UIPanGestureRecognizer!
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if isLive == false {
            if sender.state == .changed {
                let translation = sender.translation(in: containerView)
                crosshairView.frame.origin.x += translation.x
                crosshairView.frame.origin.y += translation.y
                
                if crosshairView.center.x > containerView.frame.width {
                    crosshairView.center.x = containerView.frame.width
                } else if crosshairView.center.x < 0 {
                    crosshairView.center.x = 0
                }
                
                if crosshairView.center.y > containerView.frame.height {
                    crosshairView.center.y = containerView.frame.height
                } else if crosshairView.center.y < 0 {
                    crosshairView.center.y = 0
                }
                
                coordinateLabel.text = "crosshairPoint: (\(Int(crosshairView.center.x)) x, \(Int(crosshairView.center.y)) y)"
            }
            sender.setTranslation(.zero, in: containerView)
        }
    }
    
    @IBOutlet weak var hitScrollView: UIScrollView!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var hitTestButton: UIButton!
    @IBOutlet weak var hitResultDownImageView: UIImageView!
    @IBOutlet weak var hitResultLabel: UILabel!
    
    
    var hitTest: ((SCNView, CGPoint) -> Value?)?
    @IBAction func hitTestPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4) {
            self.crosshairImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        } completion: { _ in
            
            let center = CGPoint(
                x: Int(self.crosshairView.center.x),
                y: Int(self.crosshairView.center.y)
            )
            
            if let value = self.hitTest?(self.sceneViewWrapper.sceneView, center) {
                self.hitResultLabel.text = "hitPosition: (\(Int(value.x)) x, \(Int(value.y)) y, \(Int(value.z)) z)"
            } else {
                self.hitResultLabel.text = "hitPosition: Out of bounds"
            }
            
            
            UIView.animate(withDuration: 0.4) {
                self.crosshairImageView.transform = CGAffineTransform.identity
                self.hitResultDownImageView.tintColor = .systemGreen
                self.hitResultLabel.textColor = .systemGreen
            }
        }
        
    }
    
    
    
    var cubeNode: Node?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        isLive ? setupLiveView() : setupMainView()
    }
    
    @IBOutlet weak var slidersReferenceView: UIView!
    
    
    func setupLiveView() {
        self.svm = SlidersViewModel()
        
        SlidersViewModel.didChange = { [weak self] in
            guard let self = self else { return }
            self.cubeNode?.position = Value(x: Float(self.svm.x), y: Float(self.svm.y), z:Float(self.svm.z))
        }
        
        crosshairView.isHidden = true
        hitScrollView.isHidden = true
        
        let sliders = OneSliderView(svm: self.svm)
        
        self.addNodes(sceneView: sceneViewWrapper.sceneView)
        
        let hostingController = UIHostingController(rootView: sliders)
        addChildViewController(hostingController, in: slidersReferenceView)
    }
    
    func setupMainView() {
        crosshairImageView.layer.shadowRadius = 3
        crosshairImageView.layer.shadowColor = UIColor.systemBlue.cgColor
        crosshairImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        crosshairImageView.layer.shadowOpacity = 0.9
        
        crosshairView.center = CGPoint(x: 50, y: 50)
        coordinateLabel.text = "crosshairPoint: (\(Int(crosshairView.center.x)) x, \(Int(crosshairView.center.y)) y)"
        
        hitTestButton.layer.cornerRadius = 16
        hitResultDownImageView.tintColor = .placeholderText
        hitResultLabel.textColor = .placeholderText
    }
    
    func addNodes(sceneView: SCNView) {
        let cubeNode = Node()
        cubeNode.shape = .cube
        cubeNode.color = UIColor.red
        cubeNode.position = Value(x: 0, y: 0, z: 0)
        sceneView.scene?.addNode(cubeNode)
        
        self.cubeNode = cubeNode
        
    }
    
}

public extension SCNScene {
    func addNode(_ node: Node) {
        self.rootNode.addNode(node)
    }
}

public extension SCNView {
    func hitTest(at location: CGPoint) -> Value? {
        
        let results = self.hitTest(location, options: [SCNHitTestOption.searchMode : 1])

        if let first = results.first(where: {$0.node.name == "PlaneNode"}) {
            let coords = first.worldCoordinates
            let value = Value(position: coords)

            return value
        }
        
        return nil
    }
}

