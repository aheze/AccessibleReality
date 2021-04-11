//
//  MainVC+SetupViews.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit

extension MainViewController {
    
    func setupViews() {
        
        // MARK: Drawing View
        let drawingView = UIView()
        drawingView.isUserInteractionEnabled = false
        drawingView.backgroundColor = .clear
        view.addSubview(drawingView)
        
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
