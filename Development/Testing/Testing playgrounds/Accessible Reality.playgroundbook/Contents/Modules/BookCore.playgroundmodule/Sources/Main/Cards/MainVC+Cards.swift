//
//  MainVC+Cards.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import SwiftUI
import ARKit

extension MainViewController {
    
    func setupCardsView() {
        self.cvm = CardsViewModel()
        let cardsView = CardsView(cvm: self.cvm) { [weak self] addedCard in
            guard let self = self else { return false }
            
            if let object = self.currentTargetedObject {
                if let marker = self.addMarker(
                    at: object.convertedBoundingBox,
                    name: object.name,
                    color: UIColor(addedCard.color),
                    soundFileName: addedCard.sound.filename
                ) {
                    addedCard.marker = marker
                    self.animateCubeOverlayPlaced(placed: true)
                    return true
                }
            } else {
                let middleOfCrossHair = self.crosshairView.center
                if let marker = self.addMarker(
                    at: middleOfCrossHair,
                    color: UIColor(addedCard.color),
                    soundFileName: addedCard.sound.filename
                ) {
                    addedCard.marker = marker
                    self.animateCubeOverlayPlaced(placed: true)
                    return true
                }
            }
            
            return false
        } cardRemoved: { removedCard in
            if let anchor = removedCard.marker?.anchor {
                if let firstIndex = self.placedMarkers.firstIndex(where: { $0.box == removedCard.marker?.box }) {
                    self.placedMarkers.remove(at: firstIndex)
                }
                self.sceneView.session.remove(anchor: anchor)
            }
            
            if self.cvm.selectedCard?.marker == nil {
                self.animateCubeOverlayPlaced(placed: false)
            } else {
                self.animateCubeOverlayPlaced(placed: true)
            }
        } cardSelected: { [weak self] card in
            guard let self = self else { return }
            self.trackCurrentMarker()
            
            if card.marker != nil {
                self.animateCubeOverlayPlaced(placed: true)
            } else {
                self.animateCubeOverlayPlaced(placed: false)
            }
        } soundChanged: { [weak self] card in
            guard let self = self else { return }
            
            
            if let marker =  card.marker {
                if !card.sound.filename.isEmpty {
                    marker.node.removeAllAudioPlayers()
                    marker.node.addAudioPlayer(self.getAudioPlayer(filename: card.sound.filename))
                    
                } else {
                    marker.node.removeAllAudioPlayers()
                }
            }
        }
        
        let hostingController = UIHostingController(rootView: cardsView)
        addChildViewController(hostingController, in: cardsReferenceView)
        hostingController.view.backgroundColor = .clear
        
        Global.configurationChanged = { [weak self] in
            self?.updateColors()
            self?.updateCubeOverlayColor()
            self?.updateSceneViewAccessibility()
        }
    }
}
