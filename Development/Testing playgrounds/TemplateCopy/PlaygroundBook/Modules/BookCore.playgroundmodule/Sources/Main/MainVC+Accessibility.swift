//
//  MainVC+Accessibility.swift
//  BookCore
//
//  Created by Zheng on 4/11/21.
//

import UIKit

extension MainViewController {
    func setupAccessibility() {
        crosshairImageView.isAccessibilityElement = true
        crosshairImageView.accessibilityLabel = "Crosshair"
        crosshairImageView.accessibilityHint = "Double-tap the Add button to add a node here"
        
        sceneView.isAccessibilityElement = true
        sceneView.accessibilityLabel = "AR Viewfinder"
        
        infoView.isAccessibilityElement = false
        
        orientationBlurView.clipsToBounds = true
        orientationBlurView.layer.cornerRadius = 6
        view.bringSubviewToFront(orientationBlurView)
        orientationButton.transform = CGAffineTransform(rotationAngle: -90.degreesToRadians)
        
        speakBlurView.clipsToBounds = true
        speakBlurView.layer.cornerRadius = 6
        view.bringSubviewToFront(speakBlurView)
    }
    
    func updateSceneViewAccessibility() {
        let numberOfNodes = placedMarkers.count
        
        let currentlyOnAddingMode = !(cvm.selectedCard?.added ?? true)
        
        crosshairImageView.accessibilityHint = currentlyOnAddingMode ? "Double-tap the Add button to add a node here" : "A line is connected from here to the selected node"
        
        if numberOfNodes == 0 {
            sceneView.accessibilityHint = "No nodes currently. Double-tap the Add button to add a node at the crosshair's location."
        } else {
            if currentlyOnAddingMode {
                sceneView.accessibilityHint = "\(numberOfNodes) nodes placed. Double-tap the Add button to add another node at the crosshair's location."
            } else {
                if let currentCard = cvm.selectedCard {
                    let uiColor = UIColor(currentCard.color)
                    
                    
                    let distanceText = "\(degreesAway) and \(cmAway) away"
                    
                    sceneView.accessibilityHint = "\(numberOfNodes) nodes placed. Selected node named \"\(currentCard.name)\", \(distanceText). Color \(uiColor.hexString), and sound \(currentCard.sound.name)"
                } else {
                    sceneView.accessibilityHint = "\(numberOfNodes) nodes placed."
                }
            }
        }
    }
    
   
}


/// UIColor to hex
/// from https://stackoverflow.com/a/47357277/14351818
extension UIColor {
    var hexString: String {
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha

        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )

        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a * 255)))
        }

        return color
    }
}
