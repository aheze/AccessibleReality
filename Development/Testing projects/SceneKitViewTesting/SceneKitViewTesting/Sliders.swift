//
//  Sliders.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/12/21.
//

import SwiftUI

struct OneSliderView: View {
    @ObservedObject var svm: SlidersViewModel
    var body: some View {
        Sliders(
            x: $svm.x,
            y: $svm.y,
            z: $svm.z,
            min: "-100 cm",
            max: "100 cm"
        )
    }
}

struct Sliders: View {
    
    @Binding var x: Double
    @Binding var y: Double
    @Binding var z: Double
    
    let min: String
    let max: String
    
    var body: some View {
        VStack {
            
            let _ = SlidersViewModel.didChange?()
            
            Text("(\(Int(x)) x, \(Int(y)) y, \(Int(z)) z)")
                .font(.system(size: 28, weight: .medium))
                
            
            HStack {
                Text("X")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .medium))
                    .padding()
                    .background(Color.red)
                
                Text(min)
                Slider(value: $x, in: -100...100)
                    .accentColor(Color.red)
                Text(max)
                    .padding(.trailing, 12)
            }
            .background(
                Color(.systemBackground)
            )
            .cornerRadius(16)
            
            HStack {
                Text("Y")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .medium)).padding()
                    .background(Color.green)
                
                Text(min)
                Slider(value: $y, in: -100...100)
                    .accentColor(Color.green)
                Text(max)
                    .padding(.trailing, 12)
            }
            .background(
                Color(.systemBackground)
            )
            .cornerRadius(16)
            
            HStack {
                Text("Z")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .medium)).padding()
                    .background(Color.blue)
                
                Text(min)
                Slider(value: $z, in: -100...100)
                    .accentColor(Color.blue)
                Text(max)
                    .padding(.trailing, 12)
            }
            .background(
                Color(.systemBackground)
            )
            .cornerRadius(16)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct Sliders_Previews: PreviewProvider {
    static var previews: some View {
//        Sliders(svm: SlidersViewModel())
        Sliders(
            x: .constant(0),
            y: .constant(0),
            z: .constant(0),
            min: "-100 cm",
            max: "100 cm"
        )
    }
}

