//
//  Structs.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import ARKit

struct DetectedObject {
    var name: String
    var convertedBoundingBox: CGRect
}

struct Marker {
    var name: String
    var color: UIColor
    
    var hasDescription: Bool /// true if ML detected
    var box: SCNBox
    var anchor: ARAnchor
}

struct Sound: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var filepath = URL(fileURLWithPath: "")
}


