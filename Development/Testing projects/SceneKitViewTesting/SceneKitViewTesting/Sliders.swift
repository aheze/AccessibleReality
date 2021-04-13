//
//  Sliders.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/12/21.
//

import SwiftUI

struct Sliders: View {
    
//    var xChanged: ((Double) -> Void)?
//    var yChanged: ((Double) -> Void)?
//    var zChanged: ((Double) -> Void)?
//
//    @State var xValue = Double(0)
//    @State var yValue = Double(0)
//    @State var zValue = Double(0)
    @ObservedObject var svm: SlidersViewModel
    
    var body: some View {
        VStack {
            
            let _ = SlidersViewModel.didChange?()
            
            Text("(\(Int(svm.x)) x, \(Int(svm.y)) y, \(Int(svm.z)) z)")
                .font(.system(size: 28, weight: .medium))
                .padding()
            
            HStack {
                Text("X")
                    .font(.system(size: 21, weight: .medium))
                
                Slider(value: $svm.x, in: -100...100)
            }
            .padding()
            .background(
                Color(.secondarySystemBackground)
                    .cornerRadius(16)
            )
            
            HStack {
                Text("Y")
                    .font(.system(size: 21, weight: .medium))
                Slider(value: $svm.y, in: -100...100)
                
            }
            .padding()
            .background(
                Color(.secondarySystemBackground)
                    .cornerRadius(16)
            )
            
            HStack {
                Text("Z")
                    .font(.system(size: 21, weight: .medium))
                Slider(value: $svm.z, in: -100...100)
            }
            .padding()
            .background(
                Color(.secondarySystemBackground)
                    .cornerRadius(16)
            )
        }
        .padding()
    }
}

struct Sliders_Previews: PreviewProvider {
    static var previews: some View {
        Sliders(svm: SlidersViewModel())
    }
}

