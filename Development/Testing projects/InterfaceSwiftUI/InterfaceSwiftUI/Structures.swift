//
//  Structures.swift
//  InterfaceSwiftUI
//
//  Created by Zheng on 4/3/21.
//

import Foundation

struct Sound: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var filepath = URL(fileURLWithPath: "")
}
