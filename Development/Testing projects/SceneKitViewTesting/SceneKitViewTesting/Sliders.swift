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
    
    var body: some View {
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
    }
}

struct FourSliderView: View {
    @ObservedObject var svm1: SlidersViewModel
    @ObservedObject var svmV: SlidersViewModel
    @ObservedObject var svm2R: SlidersViewModel
    @ObservedObject var svm2: ReadOnlySlidersViewModel
    
    @State var popoverPresented = false
    @State var explanation1Presented = false
    @State var explanation2Presented = false
    @State var explanation3Presented = false
    @State var explanation4Presented = false
    
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
                            x: $svmV.x,
                            y: $svmV.y,
                            z: $svmV.z,
                            compactLayout: proxy.size.width < 900,
                            name: "cameraNode",
                            min: "-100 cm",
                            max: "100 cm",
                            imageType: "Position"
                        )
                    }
                    
                    HStack {
                        Sliders(
                            x: $svm2R.x,
                            y: $svm2R.y,
                            z: $svm2R.z,
                            compactLayout: proxy.size.width < 900,
                            name: "cameraNode",
                            min: "-360°",
                            max: "360°",
                            imageType: "Rotation",
                            sliderMin: -360,
                            sliderMax: 360
                        )
                        
                        Sliders(
                            x: $svm2.x,
                            y: $svm2.y,
                            z: $svm2.z,
                            compactLayout: proxy.size.width < 900,
                            name: "directionNode",
                            min: "-100 cm",
                            max: "100 cm",
                            imageType: "Position",
                            slidersEnabled: false,
                            customNameView: AnyView(
                                HStack {
                                    Text("Position (linked)")
                                        .font(.system(size: 19, weight: .medium, design: .monospaced))
                                    
                                    Button(action: {
                                        popoverPresented = true
                                    }) {
                                        Image(systemName: "questionmark.circle.fill")
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundColor(Color.green)
                                    }
                                    .popover(isPresented: $popoverPresented, arrowEdge: .bottom) {
                                        ScrollView {
                                            VStack(alignment: .leading) {
                                                Group {
                                                    Text("Connected to...")
                                                        .font(.headline)
                                                        .foregroundColor(Color.green)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text("cameraNode.position")
                                                            .font(.system(size: 21, weight: .medium, design: .monospaced))
                                                        Text("and")
                                                            .font(.system(size: 21, weight: .medium))
                                                        Text("cameraNode.rotation")
                                                            .font(.system(size: 21, weight: .medium, design: .monospaced))
                                                        
                                                        HStack {
                                                            Text("(together ")
                                                                .font(.system(size: 21, weight: .medium))
                                                            Text("cameraNode.transform")
                                                                .font(.system(size: 21, weight: .medium, design: .monospaced))
                                                            Text(")")
                                                                .font(.system(size: 21, weight: .medium))
                                                        }
                                                    }
                                                    .padding(.bottom, 14)
                                                    
                                                    Text("...with this code:")
                                                        .font(.headline)
                                                        .foregroundColor(Color.green)
                                                }
                                                
                                                Group {
                                                    Text(
                                                        """
                                                func combine(_ transform: SCNMatrix4, with position: Value) -> Value {
                                                """
                                                    )
                                                    
                                                    Button(action: {
                                                        explanation1Presented = true
                                                    }) {
                                                        Text(
                                                            """
                                                        var positionForwardsMatrix = matrix_identity_float4x4
                                                        positionForwardsMatrix.columns.3.x = position.x
                                                        positionForwardsMatrix.columns.3.y = position.y
                                                        positionForwardsMatrix.columns.3.z = position.z
                                                    """
                                                        )
                                                        .foregroundColor(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                                                        .popover(isPresented: $explanation1Presented) {
                                                            VStack(alignment: .leading) {
                                                                Text("Converting a `Value` to a `simd_float4x4` matrix")
                                                                    .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                                                                    .fontWeight(.bold)
                                                                Text("We first start off with an identity matrix, which is like a clean slate. The third column of matrices correspond to positions, which we can access with `columns.3`. We'll set this to our `position`.")
                                                                    .foregroundColor(Color(.label))
                                                            }
                                                            .font(.system(size: 19, weight: .regular))
                                                            .padding()
                                                            .frame(width: 500)
                                                        }
                                                    }
                                                    
                                                    Text(
                                                        """

                                                    let transformMatrix = simd_float4x4(transform)
                                                """
                                                    )
                                                    
                                                    Button(action: {
                                                        explanation2Presented = true
                                                    }) {
                                                        Text(
                                                            """
                                                    let combinedTransform = matrix_multiply(transformMatrix, positionForwardsMatrix)
                                                """
                                                        )
                                                        .foregroundColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                                                        .popover(isPresented: $explanation2Presented) {
                                                            VStack(alignment: .leading) {
                                                                Text("matrix_multiply")
                                                                    .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                                                                    .fontWeight(.bold)
                                                                Text(" lets you combine 2 matrices. In our case, we combined \"transformMatrix\" (cameraNode's transform) with \"positionForwardsMatrix\" (the offset we want to add).")
                                                                    .foregroundColor(Color(.label))
                                                            }
                                                            .font(.system(size: 19, weight: .regular))
                                                            .padding()
                                                            .frame(width: 500)
                                                        }
                                                    }
                                                    
                                                    Button(action: {
                                                        explanation3Presented = true
                                                    }) {
                                                        Text(
                                                            """
                                                        let combinedPosition = Value(
                                                            x: combinedTransform.columns.3.x,
                                                            y: combinedTransform.columns.3.y,
                                                            z: combinedTransform.columns.3.z
                                                        )
                                                    """
                                                        )
                                                        .foregroundColor(Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)))
                                                        .popover(isPresented: $explanation3Presented) {
                                                            VStack(alignment: .leading) {
                                                                Text("Getting the `Value` back")
                                                                    .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                                                                    .fontWeight(.bold)
                                                                Text("We are only interested in the position of the combined transform, so we can fetch it back with `columns.3` once again.")
                                                                    .foregroundColor(Color(.label))
                                                            }
                                                            .font(.system(size: 19, weight: .regular))
                                                            .padding()
                                                            .frame(width: 500)
                                                        }
                                                    }
                                                    
                                                    Text(
                                                        """
                                                
                                                    return combinedPosition
                                                }
                                                let position = combine(cameraNode.transform, with: Value(x: 0, y: -50, z: 0))
                                                directionNode.position = position
                                                """
                                                    )
                                                }
                                                .font(.system(size: 19, weight: .regular, design: .monospaced))
                                            }
                                            .padding(24)
                                        }
                                    }

                                }
                            )
                        )
                        
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
    
    var sliderMin: Double = -100
    var sliderMax: Double = 100
    var slidersEnabled: Bool = true
    var customNameView: AnyView?
    
    var body: some View {
        
        VStack {
            
            if compactLayout {
                VStack {
                    
                    HStack {
                        Image(imageType)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(.system(size: 19, weight: .medium, design: .monospaced))
                            
                            if let customNameView = customNameView {
                                customNameView
                            } else {
                                Text(imageType)
                                    .font(.system(size: 19, weight: .medium, design: .monospaced))
                            }
                        }
                    }
                    
                    Text("(\(Int(x)) x, \(Int(y)) y, \(Int(z)) z)")
                        .font(.system(size: 28, weight: .medium))
                    
                }
            } else {
                HStack {
                    
                    
                    Image(imageType)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(.system(size: 19, weight: .medium, design: .monospaced))
                        
                        if let customNameView = customNameView {
                            customNameView
                        } else {
                            Text(imageType)
                                .font(.system(size: 19, weight: .medium, design: .monospaced))
                        }
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
                
                
                Slider(value: $x, in: sliderMin...sliderMax)
                    .accentColor(Color.red)
                    .padding(.trailing, 12)
            }
            .background(
                Color(.systemBackground)
            )
            .brightness(slidersEnabled ? 0 : -0.25)
            .cornerRadius(16)
            .allowsHitTesting(slidersEnabled)
            
            HStack {
                Text("Y")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .medium)).padding()
                    .background(Color.green)
                
                Slider(value: $y, in: sliderMin...sliderMax)
                    .accentColor(Color.green)
                    .padding(.trailing, 12)
            }
            .background(
                Color(.systemBackground)
            )
            .brightness(slidersEnabled ? 0 : -0.25)
            .cornerRadius(16)
            .allowsHitTesting(slidersEnabled)
            
            HStack {
                Text("Z")
                    .foregroundColor(.white)
                    .font(.system(size: 21, weight: .medium)).padding()
                    .background(Color.blue)
                
                Slider(value: $z, in: sliderMin...sliderMax)
                    .accentColor(Color.blue)
                    .padding(.trailing, 12)
            }
            .background(
                Color(.systemBackground)
            )
            .brightness(slidersEnabled ? 0 : -0.25)
            .cornerRadius(16)
            .allowsHitTesting(slidersEnabled)
            
            
            HStack {
                Text(min)
                    .offset(x: 50, y: 0)
                
                Spacer()
                
                Text(max)
                    .offset(x: -15, y: 0)
            }
            
        }
        .onChange(of: x, perform: { _ in
            SlidersViewModel.didChange?()
        })
        .onChange(of: y, perform: { _ in
            SlidersViewModel.didChange?()
        })
        .onChange(of: z, perform: { _ in
            SlidersViewModel.didChange?()
        })
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        
    }
}


struct Sliders_Previews: PreviewProvider {
    static var previews: some View {
        Sliders(
            x: .constant(0),
            y: .constant(0),
            z: .constant(0),
            name: "cubeNode",
            min: "-100 cm",
            max: "100 cm",
            imageType: "Rotation"
        )
    }
}

struct TwoSliderView_Previews: PreviewProvider {
    static var previews: some View {
        TwoSliderView(svm1: SlidersViewModel(), svm2: SlidersViewModel())
            .previewLayout(.fixed(width: 800, height: 1000))
    }
}

//struct FourSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FourSliderView(
//            svm1: SlidersViewModel(),
//            svm2: SlidersViewModel(),
//            svm3: SlidersViewModel(),
//            svm4: SlidersViewModel()
//        )
//        .previewLayout(.fixed(width: 600, height: 1000))
//    }
//}




