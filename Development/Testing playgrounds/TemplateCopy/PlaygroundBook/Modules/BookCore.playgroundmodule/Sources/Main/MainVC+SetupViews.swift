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
            
            let lineBounds = self.getExtendedBezierOfLine(lineStart: self.crosshairCenter, lineEnd: self.edgePointView?.center ?? .zero)
            
            if lineBounds.contains(point) {
                
                self.makeLineLayerActive(duration: 0.15)
                
                let path = Bundle.main.path(forResource: "Line.mp3", ofType: nil)!
                let url = URL(fileURLWithPath: path)

                if self.lineSoundPlayer == nil {
                    do {
                        self.lineSoundPlayer = try AVAudioPlayer(contentsOf: url)
                        self.lineSoundPlayer?.numberOfLoops = -1
                        self.lineSoundPlayer?.play()
                    } catch {
                        // couldn't load file :(
                    }
                } else {
                    self.lineSoundPlayer?.setVolume(1, fadeDuration: 0.2)
                }
                
                self.arrivedSoundPlayer?.setVolume(0, fadeDuration: 0.2)
            } else if nodes.first != nil {
                self.makeLineLayerInactive(duration: 0.4)
                if self.arrivedSoundPlayer == nil {
                    let path = Bundle.main.path(forResource: "Arrived.mp3", ofType: nil)!
                    let url = URL(fileURLWithPath: path)
                    
                    do {
                        self.arrivedSoundPlayer = try AVAudioPlayer(contentsOf: url)
                        self.arrivedSoundPlayer?.numberOfLoops = -1
                        self.arrivedSoundPlayer?.play()
                    } catch {
                        // couldn't load file :(
                    }
                } else {
                    self.arrivedSoundPlayer?.setVolume(1, fadeDuration: 0.2)
                }
                
                self.lineSoundPlayer?.setVolume(0, fadeDuration: 0.2)
            } else {
                self.makeLineLayerInactive(duration: 0.4)
                self.arrivedSoundPlayer?.setVolume(0, fadeDuration: 0.2)
                self.lineSoundPlayer?.setVolume(0, fadeDuration: 0.2)
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
            
            self.arrivedSoundPlayer?.setVolume(0, fadeDuration: 0.2)
            self.lineSoundPlayer?.setVolume(0, fadeDuration: 0.2)
            self.makeLineLayerInactive(duration: 0.4)
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
    
    func makeLineLayerActive(duration: CGFloat) {
        if let lineLayer = self.lineLayer {
            if let currentValue = lineLayer.presentation()?.value(forKeyPath: #keyPath(CAShapeLayer.lineWidth)) {
                let currentWidth = currentValue as! CGFloat
                lineLayer.borderWidth = currentWidth
                lineLayer.removeAllAnimations()
            }
            
            let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.fromValue = lineLayer.borderWidth
            animation.toValue = 15
            animation.duration = Double(duration)
            lineLayer.lineWidth = 15
            lineLayer.add(animation, forKey: "lineWidth")
        }
        
    }
    func makeLineLayerInactive(duration: CGFloat) {
        if let lineLayer = self.lineLayer {
            if let currentValue = lineLayer.presentation()?.value(forKeyPath: #keyPath(CAShapeLayer.lineWidth)) {
                let currentWidth = currentValue as! CGFloat
                lineLayer.borderWidth = currentWidth
                lineLayer.removeAllAnimations()
            }
            
            let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.fromValue = lineLayer.borderWidth
            animation.toValue = 3
            animation.duration = Double(duration)
            lineLayer.lineWidth = 3
            lineLayer.add(animation, forKey: "lineWidth")
        }
    }
    
}
