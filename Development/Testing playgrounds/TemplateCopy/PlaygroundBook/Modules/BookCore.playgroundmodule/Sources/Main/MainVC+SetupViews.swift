//
//  MainVC+SetupViews.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import ARKit

extension MainViewController {
    
    func setupViews() {
        
        // MARK: Drawing View
        let drawingView = DrawingView()
        drawingView.backgroundColor = .clear
        view.addSubview(drawingView)
        
        drawingView.checkOverlap = { [weak self] point in
            guard let self = self else { return }
            
            
            
            let results = self.sceneView.hitTest(point, options: [SCNHitTestOption.searchMode : 1])
            let nodes = results.map { $0.node }
            
            print("nodes: \(nodes)")
            
            self.getExtendedBezierOfLine(lineStart: self.crosshairCenter, lineEnd: self.edgePointView?.center ?? .zero)
            
            if let firstNode = nodes.first {
                print("has node!!")
                
                
            }
        }
        
        drawingView.touchUp = { [weak self] point in
            guard let self = self else { return }
            
            let results = self.sceneView.hitTest(point, options: [SCNHitTestOption.searchMode : 1])
            let nodes = results.map { $0.node }
            
            for node in nodes {
                
                if let card = self.cvm.cards.first(where: {$0.marker?.node == node}) {
                    self.cvm.selectedCard = card
                    
                    if card.marker != nil {
                        self.animateCubeOverlayPlaced(placed: true)
                    } else {
                        self.animateCubeOverlayPlaced(placed: false)
                    }
                }
            }
        }
        
        
        /// Positioning constraints
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawingView.topAnchor.constraint(equalTo: view.topAnchor),
            drawingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            drawingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawingView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        self.drawingView = drawingView
        
        // MARK: Cards Reference View
        let cardsReferenceView = UIView()
        cardsReferenceView.backgroundColor = .clear
        view.addSubview(cardsReferenceView)
        
        /// Positioning constraints
        cardsReferenceView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsReferenceHeightC = cardsReferenceView.heightAnchor.constraint(equalToConstant: Positioning.cardContainerHeight + 40)
        
        NSLayoutConstraint.activate([
            cardsReferenceHeightC,
            cardsReferenceView.rightAnchor.constraint(equalTo: view.rightAnchor),
            cardsReferenceView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cardsReferenceView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        self.cardsReferenceView = cardsReferenceView
        
        // MARK: Coaching View
        let coachingReferenceView = UIView()
        coachingReferenceView.backgroundColor = .clear
        coachingReferenceView.isUserInteractionEnabled = false
        view.addSubview(coachingReferenceView)
        
        /// Positioning constraints
        coachingReferenceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingReferenceView.topAnchor.constraint(equalTo: view.topAnchor),
            coachingReferenceView.rightAnchor.constraint(equalTo: view.rightAnchor),
            coachingReferenceView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coachingReferenceView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        self.coachingReferenceView = coachingReferenceView
        
        
    }
    
    
}
