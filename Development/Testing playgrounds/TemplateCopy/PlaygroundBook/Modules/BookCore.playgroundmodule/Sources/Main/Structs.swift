//
//  Structs.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import RealityKit

struct DetectedObject {
    var name: String
    var convertedBoundingBox: CGRect
}

struct Marker {
    var name: String
    var entity: Entity
}

struct Sound: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var filepath = URL(fileURLWithPath: "")
}


