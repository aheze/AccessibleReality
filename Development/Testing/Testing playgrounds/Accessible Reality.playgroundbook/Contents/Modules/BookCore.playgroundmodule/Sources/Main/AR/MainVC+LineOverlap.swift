//
//  MainVC+LineOverlap.swift
//  BookCore
//
//  Created by Zheng on 4/18/21.
//

import UIKit
import ARKit

extension MainViewController {
    func checkLineOverlap() {
        guard let fingerPoint = self.fingerTouchedDownLocation else { return }
        let lineBounds = self.getExtendedBezierOfLine(lineStart: self.crosshairCenter, lineEnd: self.edgePointView?.center ?? .zero)
        if lineBounds.contains(fingerPoint) {
            
            self.makeLineLayerActive(duration: 0.15)
            
            let path = Bundle.main.path(forResource: "Line.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)

            if self.lineSoundPlayer == nil {
                do {
                    self.lineSoundPlayer = try AVAudioPlayer(contentsOf: url)
                    self.lineSoundPlayer?.numberOfLoops = -1
                    self.lineSoundPlayer?.play()
                } catch {
                    // couldn't load file
                }
            } else {
                self.lineSoundPlayer?.setVolume(1, fadeDuration: 0.2)
            }
            
            self.arrivedSoundPlayer?.setVolume(0, fadeDuration: 0.2)
        } else {
            let results = self.sceneView.hitTest(fingerPoint, options: [SCNHitTestOption.searchMode : 1])
            let nodes = results.map { $0.node }
            
            if nodes.first != nil {
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
    }
}
