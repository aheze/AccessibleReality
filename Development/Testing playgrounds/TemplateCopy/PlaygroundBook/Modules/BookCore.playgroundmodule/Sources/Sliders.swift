//
//  Sliders.swift
//  BookCore
//
//  Created by Zheng on 4/12/21.
//

import SwiftUI
struct OneSliderView: View {
    @ObservedObject var svm: SlidersViewModel
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                Sliders(
                    x: $svm.x,
                    y: $svm.y,
                    z: $svm.z,
                    compactLayout: proxy.size.width < 450,
                    name: "cubeNode",
                    min: "-100 cm",
                    max: "100 cm",
                    imageType: "Position"
                )
                .padding()
            }
        }
    }
}

struct TwoSliderView: View {
    @ObservedObject var svm1: SlidersViewModel
    @ObservedObject var svm2: SlidersViewModel
    var canScroll = true
    
    var body: some View {
        if canScroll {
            GeometryReader { proxy in
                ScrollView {
                    HStack {
                        Sliders(
                            x: $svm1.x,
                            y: $svm1.y,
                            z: $svm1.z,
                            compactLayout: proxy.size.width < 900,
                            name: "cubeNode",
                            min: "-100 cm",
                            max: "100 cm",
                            imageType: "Position"
                        )
                        
                        Sliders(
                            x: $svm2.x,
                            y: $svm2.y,
                            z: $svm2.z,
                            compactLayout: proxy.size.width < 900,
                            name: "cameraNode",
                            min: "-100 cm",
                            max: "100 cm",
                            imageType: "Position"
                        )
                    }
                    .padding()
                }
            }
        } else {
            HStack {
                Sliders(
                    x: $svm1.x,
                    y: $svm1.y,
                    z: $svm1.z,
                    compactLayout: true,
                    name: "cubeNode",
                    min: "-100 cm",
                    max: "100 cm",
                    imageType: "Position"
                )
                
                Sliders(
                    x: $svm2.x,
                    y: $svm2.y,
                    z: $svm2.z,
                    compactLayout: true,
                    name: "cameraNode",
                    min: "-100 cm",
                    max: "100 cm",
                    imageType: "Position"
                )
            }
            .padding()
        }
    }
}

struct FourSliderView: View {
    @ObservedObject var svm1: SlidersViewModel
    @ObservedObject var svm2: SlidersViewModel
    @ObservedObject var svm3: SlidersViewModel
    @ObservedObject var svm4: SlidersViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    HStack {
                        Sliders(
                            x: $svm1.x,
                            y: $svm1.y,
                            z: $svm1.z,
                            compactLayout: proxy.size.width < 900,
                            name: "cubeNode",
                            min: "-100 cm",
                            max: "100 cm",
                            imageType: "Position"
                        )
                        
                        Sliders(
                            x: $svm2.x,
                            y: $svm2.y,
                            z: $svm2.z,
                            compactLayout: proxy.size.width < 900,
                            name: "cameraNode",
                            min: "-100 cm",
                            max: "100 cm",
                            imageType: "Position"
                        )
                    }
                    
                    HStack {
                        Sliders(
                            x: $svm3.x,
                            y: $svm3.y,
                            z: $svm3.z,
                            compactLayout: proxy.size.width < 900,
                            name: "cameraNode",
                            min: "-360°",
                            max: "360°",
                            imageType: "Rotation"
                        )
                        
                        Sliders(
                            x: $svm4.x,
                            y: $svm4.y,
                            z: $svm4.z,
                            compactLayout: proxy.size.width < 900,
                            name: "directionNode",
                            min: "-100 cm",
                            max: "100 cm",
                            imageType: "Position"
                        )
                        .brightness(-0.25)
                        .allowsHitTesting(false)
                        
                    }
                }
                .padding()
            }
        }
    }
}

struct Sliders: View {
    
    @Binding var x: Double
    @Binding var y: Double
    @Binding var z: Double
    
    var compactLayout = false
    let name: String
    let min: String
    let max: String
    let imageType: String
    
    
    var body: some View {
        
        
        VStack {
            
            let _ = SlidersViewModel.didChange?()
            
            if compactLayout {
                VStack {
                    
                    HStack {
                        Image(imageType)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(.system(size: 19, weight: .medium, design: .monospaced))
                            Text(imageType)
                        }
                    }
                    
                    Text("(\(Int(x)) x, \(Int(y)) y, \(Int(z)) z)")
                        .font(.system(size: compactLayout ? 21 : 28, weight: .medium))
                    
                }
            } else {
                HStack {
                    
                    
                    Image(imageType)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(.system(size: 19, weight: .medium, design: .monospaced))
                        Text(imageType)
                    }
                    
                    Spacer()
                    
                    Text("(\(Int(x)) x, \(Int(y)) y, \(Int(z)) z)")
                        .font(.system(size: 28, weight: .medium))
                    
                }
            }
            
            
            HStack {
                Text("X")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .medium))
                    .padding()
                    .background(Color.red)
                
                
                Slider(value: $x, in: -100...100)
                    .accentColor(Color.red)
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
                
                Slider(value: $y, in: -100...100)
                    .accentColor(Color.green)
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
                
                
                
                Slider(value: $z, in: -100...100)
                    .accentColor(Color.blue)
                    .padding(.trailing, 12)
            }
            .background(
                Color(.systemBackground)
            )
            .cornerRadius(16)
            
            
            HStack {
                Text(min)
                    .font(.system(size: compactLayout ? 14 : 21, weight: .regular))
                    .offset(x: 50, y: 0)
                
                Spacer()
                
                Text(max)
                    .font(.system(size: compactLayout ? 14 : 21, weight: .regular))
                    .offset(x: -15, y: 0)
            }
            
        }
        .padding(compactLayout ? 14 : 20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        
    }
}
