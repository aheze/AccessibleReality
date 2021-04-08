//
//  ViewController+CheckOverlap.swift
//  MLRealityTest
//
//  Created by Zheng on 4/3/21.
//

import UIKit
import RealityKit

extension ViewController {
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
                    if self.vm.selectedCard == self.vm.cards[self.vm.cards.count - 1] { /// only change if focused
                        if self.vm.cards[self.vm.cards.count - 1].customizedName == false {
                            self.vm.cards[self.vm.cards.count - 1].name = object.name.capitalized
                        }
                    }
                } else {
                    if self.vm.cards[self.vm.cards.count - 1].customizedName == false {
                        self.vm.cards[self.vm.cards.count - 1].name = "Object"
                    }
                }
            }
            
            self.crosshairBusyCalculating = false
        }
    }
    
}
