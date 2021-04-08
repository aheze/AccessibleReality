//
//  MainVC+Cards.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import SwiftUI

extension MainViewController {
    
    func setupCardsView() {
        let cardsView = CardsView { [weak self] card in
            guard let self = self else { return }
            
            if card.added {
                print("added")
//                if let object = self.currentTargetedObject {
//                    if let marker = self.addMarker(
//                        at: object.convertedBoundingBox,
//                        name: object.name,
//                        color: UIColor(card.color)
//                    ) {
//                        card.marker = marker
//                    }
//                } else {
//                    print("nope")
//                    let middleOfCrossHair = self.crosshairView.center
//                    if let marker = self.addMarker(
//                        at: middleOfCrossHair,
//                        color: UIColor(card.color)
//                    ) {
//                        print("yes")
//                        card.marker = marker
//                    }
//                }
            } else {
                
                card.marker?.anchorEntity.removeFromParent()
                
            }
        } cardSelected: { [weak self] card in
            guard let self = self else { return }
            self.currentTrackingMarker = card.marker
        }
        
        self.cardsView = cardsView
        
        let hostingController = UIHostingController(rootView: cardsView)
        addChildViewController(hostingController, in: cardsReferenceView)
        hostingController.view.backgroundColor = .clear
    }
}
