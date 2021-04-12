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
    var node: SCNNode
    var anchor: ARAnchor
    var radius: Float /// distance from center to the outermost edge
}

//class Marker {
//    var name: String
//    var color: UIColor
//    
//    var hasDescription: Bool /// true if ML detected
//    var box: SCNBox
//    var node: SCNNode
//    var anchor: ARAnchor
//    var radius: Float /// distance from center to the outermost edge
//    
//    init(
//        name: String,
//        color: UIColor,
//        hasDescription: Bool,
//        box: SCNBox,
//        node: SCNNode,
//        anchor: ARAnchor,
//        radius: Float
//    ) {
//        self.name = name
//        self.color = color
//        self.hasDescription = hasDescription
//        self.box = box
//        self.node = node
//        self.anchor = anchor
//        self.radius = radius
//    }
//}

struct Sound: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var filename = ""
}


