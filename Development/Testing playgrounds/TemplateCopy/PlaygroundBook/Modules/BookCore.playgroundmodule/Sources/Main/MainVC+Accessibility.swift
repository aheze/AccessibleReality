//
//  MainVC+Accessibility.swift
//  BookCore
//
//  Created by Zheng on 4/11/21.
//

import UIKit
import AVFoundation

extension MainViewController {
    func setupAccessibility() {
        drawingView.isAccessibilityElement = true
        drawingView.accessibilityLabel = "AR Viewfinder"
        
        crosshairImageView.isAccessibilityElement = true
        crosshairImageView.accessibilityLabel = "Crosshair"
        crosshairImageView.accessibilityHint = "Double-tap the Add button to add a node here"
        
        
        
        infoView.isAccessibilityElement = false
        
        orientationBlurView.clipsToBounds = true
        orientationBlurView.layer.cornerRadius = 6
        view.bringSubviewToFront(orientationBlurView)
        orientationButton.transform = CGAffineTransform(rotationAngle: -90.degreesToRadians)
        orientationButton.accessibilityLabel = "ML orientation"
        orientationButton.accessibilityHint = "Make sure the orientation matches your iPad's orientation in real life"
        
        let orientationValue: String
        switch currentOrientation {
        case .portrait:
            orientationValue = "Upside down"
        case .portraitUpsideDown:
            orientationValue = "Portrait"
        case .landscapeLeft:
            orientationValue = "Home button right"
        case .landscapeRight:
            orientationValue = "Home button left"
        default:
            orientationValue = "Portrait"
        }
        orientationButton.accessibilityValue = orientationValue
        
        speakMuteBlurView.clipsToBounds = true
        speakMuteBlurView.layer.cornerRadius = 6
        view.bringSubviewToFront(speakMuteBlurView)
        
        updateMuteButton()
        
        speakBlurView.clipsToBounds = true
        speakBlurView.layer.cornerRadius = 6
        view.bringSubviewToFront(speakBlurView)
        
        speakExpandedBlurView.clipsToBounds = true
        speakExpandedBlurView.layer.cornerRadius = 6
        speakExpandedBlurView.alpha = 0
        speakExpandedBlurView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.bringSubviewToFront(speakExpandedBlurView)
        
        speakButton.accessibilityLabel = "Speak current status"
        speakButton.accessibilityHint = "Describe the current status"
        
        speakExpandedLabel.isAccessibilityElement = false
        
        speakCloseButton.accessibilityLabel = "Stop speaking"
        speakCloseButton.accessibilityHint = "Stop describing the current status"
        
        alertExpandedBlurView.clipsToBounds = true
        alertExpandedBlurView.layer.cornerRadius = 6
        alertExpandedBlurView.alpha = 0
        alertExpandedBlurView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.bringSubviewToFront(alertExpandedBlurView)
        
        
        orientationDescriptionBlurView.clipsToBounds = true
        orientationDescriptionBlurView.layer.cornerRadius = 6
        orientationDescriptionBlurView.alpha = 0
        orientationDescriptionBlurView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.bringSubviewToFront(orientationDescriptionBlurView)
        orientationDescriptionBlurView.isAccessibilityElement = false
        
        synthesizer.delegate = self
        alertSynthesizer.delegate = self
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
        
        let orientationValue: String
        switch currentOrientation {
        case .portrait:
            orientationValue = "Upside down"
        case .portraitUpsideDown:
            orientationValue = "Portrait"
        case .landscapeLeft:
            orientationValue = "Home button right"
        case .landscapeRight:
            orientationValue = "Home button left"
        default:
            orientationValue = "Portrait"
        }
        orientationButton.accessibilityValue = orientationValue
    }
    
    func updateMuteButton() {
        let imageName = muted ? "speaker.slash.fill" : "speaker.wave.2.fill"
        if let image = UIImage(systemName: imageName) {
            speakMuteButton.setImage(image, for: .normal)
        }
        
        if muted {
            speakMuteButton.accessibilityLabel = "Muted"
            speakMuteButton.accessibilityHint = "Spoken feedback is muted. Double-tap to unmute."
            synthesizer.stopSpeaking(at: .immediate)
            alertSynthesizer.stopSpeaking(at: .immediate)
        } else {
            speakMuteButton.accessibilityLabel = "Sound on"
            speakMuteButton.accessibilityHint = "Spoken feedback is on. Double-tap to mute."
        }
    }
    func speakStatus() {
        
        let numberOfNodes = placedMarkers.count
        let currentlyOnAddingMode = !(cvm.selectedCard?.added ?? true)
        
        let nodeText: String
        
        if numberOfNodes == 0 {
            nodeText = "No nodes placed, currently in adding mode. Tap the Add button to add a node at the crosshair's location."
        } else {
            if currentlyOnAddingMode {
                nodeText = "Adding mode. Tap the Add button to add a node at the crosshair's location. \(numberOfNodes) total nodes placed."
            } else {
                if let currentCard = cvm.selectedCard {
                    let uiColor = UIColor(currentCard.color)
                    
                    let distanceText = "\(degreesAway) and \(cmAway) away"
                    
                    nodeText = "Selected node named \"\(currentCard.name)\", \(distanceText). Color \(uiColor.hexString), and sound \(currentCard.sound.name). \(numberOfNodes) total nodes placed."
                } else {
                    nodeText = "\(numberOfNodes) nodes placed. No selected node."
                }
            }
        }
        
        alertSynthesizer.stopSpeaking(at: .immediate)
        
        if !muted {
            if UIAccessibility.isVoiceOverRunning {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    UIAccessibility.post(notification: .announcement, argument: nodeText)
                }
            } else {
                let utterance = AVSpeechUtterance(string: nodeText)
                synthesizer.stopSpeaking(at: .word)
                synthesizer.speak(utterance)
            }
        }
        
        speakExpandedLabel.text = nodeText
        
        UIView.animate(withDuration: 0.3) {
            self.speakExpandedBlurView.alpha = 1
            self.speakExpandedBlurView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    func stopSpeaking() {
        UIView.animate(withDuration: 0.3) {
            self.speakExpandedBlurView.alpha = 0
            self.speakExpandedBlurView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { _ in
            self.speakExpandedLabel.text = ""
        }
        synthesizer.stopSpeaking(at: .word)
    }
    
    func speakAlert(text: String) {
        
        if !alertSynthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            
            if !muted {
                if UIAccessibility.isVoiceOverRunning {
                    UIAccessibility.post(notification: .announcement, argument: text)
                } else {
                    let utterance = AVSpeechUtterance(string: text)
                    alertSynthesizer.speak(utterance)
                }
            }
            
            alertExpandedLabel.text = text
            
            UIView.animate(withDuration: 0.3) {
                self.alertExpandedBlurView.alpha = 1
                self.alertExpandedBlurView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    func stopSpeakingAlert() {
        UIView.animate(withDuration: 0.3) {
            self.alertExpandedBlurView.alpha = 0
            self.alertExpandedBlurView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { _ in
            self.alertExpandedLabel.text = ""
        }
        alertSynthesizer.stopSpeaking(at: .word)
    }
    
   
}

extension MainViewController: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if synthesizer == self.synthesizer {
            stopSpeaking()
        } else if synthesizer == self.alertSynthesizer {
            stopSpeakingAlert()
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
