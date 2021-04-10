//
//  Structs.swift
//  MLRealityTest
//
//  Created by Zheng on 4/2/21.
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
    var box: SCNBox
    var node: SCNNode
//    var entity: Entity /// the box
//    var anchorEntity: AnchorEntity /// anchor of the box
}

struct Sound: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var filepath = URL(fileURLWithPath: "")
}


