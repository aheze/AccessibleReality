//
//  Objects.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import UIKit
import RealityKit

class CustomBox: Entity, HasModel, HasAnchoring, HasCollision {
    
    required init(color: UIColor) {
        super.init()
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateBox(size: 0.1),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    init(color: UIColor, width: Float, height: Float) {
        super.init()
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateBox(width: width, height: height, depth: height),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
