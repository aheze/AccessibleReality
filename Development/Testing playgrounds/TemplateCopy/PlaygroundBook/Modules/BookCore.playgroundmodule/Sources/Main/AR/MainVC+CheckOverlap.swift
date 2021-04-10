//
//  MainVC+CheckOverlap.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
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
                    if self.vm.selectedCard == self.vm.cards[self.vm.cards.count - 1] { /// only change if focused
                        self.vm.cards[self.vm.cards.count - 1].name = object.name.capitalized
                    }
                } else {
                    self.vm.cards[self.vm.cards.count - 1].name = "Marker"
                }
            }
            
            self.crosshairBusyCalculating = false
        }
    }
}
