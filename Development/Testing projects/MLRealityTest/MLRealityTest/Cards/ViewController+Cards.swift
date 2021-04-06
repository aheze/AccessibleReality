//
//  ViewController+Cards.swift
//  MLRealityTest
//
//  Created by Zheng on 4/4/21.
//

import SwiftUI

extension ViewController {
    
    func setupCardsView() {
        let cardsView = CardsView { [weak self] card in
            guard let self = self else { return }
            
            if card.added {
                print("added!")
                if let object = self.currentTargetedObject {
                    if let marker = self.addMarker(at: object.convertedBoundingBox, name: object.name) {
                        card.marker = marker
                    }
                } else {
                    let middleOfCrossHair = self.crosshairView.center
                    if let marker = self.addMarker(at: middleOfCrossHair) {
                        card.marker = marker
                    }
                }
            } else {
                print("removeed!.. \(card.marker)")
                
                card.marker?.anchorEntity.removeFromParent()
                
            }
            
//            print("receiver changed. \(card)")
            
        }
        
        
        let hostingController = UIHostingController(rootView: cardsView)
        addChildViewController(hostingController, in: cardsReferenceView)
        hostingController.view.backgroundColor = .clear
    }
}
