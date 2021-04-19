//
//  MainVC+UpdateColors.swift
//  BookCore
//
//  Created by Zheng on 4/11/21.
//

import SwiftUI
import ARKit

extension MainViewController {
    func updateColors() {
        self.lineLayer?.strokeColor = UIColor(cvm.selectedCard?.color ?? Color.green).cgColor
        
        var cubeColor = UIColor(cvm.selectedCard?.color ?? Color.green)
        
        if cvm.selectedCard?.marker?.hasDescription ?? false {
            cubeColor = cubeColor.withAlphaComponent(0.8)
        }
        let colorMaterial = SCNMaterial()
        colorMaterial.diffuse.contents = cubeColor
        self.cvm.selectedCard?.marker?.box.materials = [colorMaterial]
    }
    
    func updateCubeOverlayColor() {
        var cubeColor = UIColor(cvm.selectedCard?.color ?? Color.green)
        
        if cvm.selectedCard?.marker?.hasDescription ?? false {
            cubeColor = cubeColor.withAlphaComponent(0.8)
        }
        
        let colorMaterial = SCNMaterial()
        colorMaterial.diffuse.contents = cubeColor
        crosshairCube.materials = [colorMaterial]
    }
}
