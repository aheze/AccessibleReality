//
//  MainVC+Cards.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import SwiftUI

extension MainViewController {
    
    func setupCardsView() {
        self.vm = CardsViewModel()
        let cardsView = CardsView(vm: self.vm) { [weak self] card in
            guard let self = self else { return }
            
            if card.added {
                if let object = self.currentTargetedObject {
                    if let marker = self.addMarker(
                        at: object.convertedBoundingBox,
                        name: object.name,
                        color: UIColor(card.color)
                    ) {
                        card.marker = marker
                    }
                } else {
                    let middleOfCrossHair = self.crosshairView.center
                    if let marker = self.addMarker(
                        at: middleOfCrossHair,
                        color: UIColor(card.color)
                    ) {
                        card.marker = marker
                    }
                }
            } else {
                
                if let anchor = card.marker?.anchor {
                    self.sceneView.session.remove(anchor: anchor)
                }
                
            }
        } cardSelected: { [weak self] card in
            guard let self = self else { return }
            self.trackCurrentMarker()
        }
        
        let hostingController = UIHostingController(rootView: cardsView)
        addChildViewController(hostingController, in: cardsReferenceView)
        hostingController.view.backgroundColor = .clear
    }
}
