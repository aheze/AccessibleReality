//
//  MainVC+CheckOverlap.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import SwiftUI
import ARKit

extension MainViewController {
    func checkOverlap(at point: CGPoint, completion: @escaping ((DetectedObject?) -> Void)) {
        crosshairBusyCalculating = true
        
        DispatchQueue.global(qos: .utility).async {
            var overlappedObject: DetectedObject?
            
            for object in self.currentDetectedObjects {
                if object.convertedBoundingBox.contains(point) {
                    overlappedObject = object
                    break
                }
            }
            
            
            DispatchQueue.main.async {
                completion(overlappedObject)
                if let object = overlappedObject {
                    if self.cvm.selectedCard == self.cvm.cards[self.cvm.cards.count - 1] { /// only change if focused
                        self.cvm.cards[self.cvm.cards.count - 1].name = object.name.capitalized
                        self.scaleCubeOverlay(up: true)
                    }
                } else {
                    self.cvm.cards[self.cvm.cards.count - 1].name = "Node"
                    
                    self.scaleCubeOverlay(up: false)
                }
            }
            
            self.crosshairBusyCalculating = false
        }
    }
    
    func scaleCubeOverlay(up: Bool) {
        if up {
            let scaleAction = SCNAction.scale(to: 1.5, duration: 0.1)
            let fadeAction = SCNAction.fadeOpacity(to: 0.6, duration: 0.1)
            let group = SCNAction.group([
                scaleAction,
                fadeAction
            ])
            crosshairCubeNode?.runAction(group)
            
            UIView.animate(withDuration: 0.1) {
                self.crosshairCubeParticleView?.alpha = 1
            }
        } else {
            let scaleAction = SCNAction.scale(to: 1, duration: 0.1)
            let fadeAction = SCNAction.fadeOpacity(to: 1, duration: 0.1)
            let group = SCNAction.group([
                scaleAction,
                fadeAction
            ])
            crosshairCubeNode?.runAction(group)
            
            UIView.animate(withDuration: 0.1) {
                self.crosshairCubeParticleView?.alpha = 0
            }
        }
    }
    
    func animateCubeOverlayPlaced(placed: Bool) {
        if placed {
            UIView.animate(withDuration: 0.3) {
                self.crosshairContentView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.crosshairContentView?.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.crosshairContentView?.transform = CGAffineTransform.identity
                self.crosshairContentView?.alpha = 1
            }
        }
        
    }
    
}
