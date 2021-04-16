//
//  AngleWalkthrough.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/15/21.
//

import SwiftUI
import SceneKit

struct LineSpace: View {
    var body: some View {
        Color.clear.frame(height: 20)
    }
}
struct AngleWalkThrough: View {
    
    
    /// user entered code literals
    var v2xLiteral: String
    var v2yLiteral: String
    var v2zLiteral: String
    
    var xProductLiteral: String
    var yProductLiteral: String
    var zProductLiteral: String
    
    var acosLiteral: String
    
    
    /// parameters
    var vertex = Value(x: 0, y: 0, z: 5)
    var position1 = Value(x: 3, y: 0, z: 2)
    var position2 = Value(x: 0, y: 7, z: 1)
    
    /// results
    @State var vertexString = ""
    @State var position1String = ""
    @State var position2String = ""

    @State var v1x1String = ""
    @State var v1x2String = ""
    @State var v1y1String = ""
    @State var v1y2String = ""
    @State var v1z1String = ""
    @State var v1z2String = ""
    @State var v2x1String = ""
    @State var v2x2String = ""
    @State var v2y1String = ""
    @State var v2y2String = ""
    @State var v2z1String = ""
    @State var v2z2String = ""
    
    @State var xProduct1String = ""
    @State var xProduct2String = ""
    @State var yProduct1String = ""
    @State var yProduct2String = ""
    @State var zProduct1String = ""
    @State var zProduct2String = ""
    
    @State var dotProductXString = ""
    @State var dotProductYString = ""
    @State var dotProductZString = ""
    @State var dotProductResult = ""
    
    @State var vertexToPosition1String = ""
    @State var vertexToPosition2String = ""
    
    @State var cosineOfAngleString = ""
    @State var angleResultString = ""
    
    
    /// animating
    @State var vertexParameterAnimated = false
    @State var position1ParameterAnimated = false
    @State var position2ParameterAnimated = false
    
    @State var v1x1Animated = false
    @State var v1x2Animated = false
    @State var v1y1Animated = false
    @State var v1y2Animated = false
    @State var v1z1Animated = false
    @State var v1z2Animated = false
    @State var v2x1Animated = false
    @State var v2x2Animated = false
    @State var v2y1Animated = false
    @State var v2y2Animated = false
    @State var v2z1Animated = false
    @State var v2z2Animated = false
    
    @State var product_v1xAnimated = false
    @State var product_v2xAnimated = false
    @State var product_v1yAnimated = false
    @State var product_v2yAnimated = false
    @State var product_v1zAnimated = false
    @State var product_v2zAnimated = false
    
    @State var dotProduct_xAnimated = false
    @State var dotProduct_yAnimated = false
    @State var dotProduct_zAnimated = false
    
    @State var vertexPos1_position1Animated = false
    @State var vertexPos1_position2Animated = false
    
    @State var vertexPos2_position1Animated = false
    @State var vertexPos2_position2Animated = false
    
    @State var cosOfAngle_dotProductAnimated = false
    @State var cosOfAngle_vertexPos1Animated = false
    @State var cosOfAngle_vertexPos2Animated = false
    
    @State var angle_cosOfAngleAnimated = false
    @State var angleResultAnimated = false
    
    
    var showResult: ((String) -> Void)?
    
    @State var timerCounter = 0
    let timer = Timer.publish(every: 0.04, on: .main, in: .common).autoconnect()
    @State var animationBlocks: [(() -> Void)] = []
    
    @State var currentCodeLine = 0
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading) {
                    CodeLineView(
                        active: currentCodeLine == 0, blocks: [
                            CodeBlock(code: "func ", codeColor: .cMagenta),
                            CodeBlock(code: "angle3D(vertex: ", codeColor: .black),
                            CodeBlock(animated: vertexParameterAnimated, code: "Value", codeColor: .cTeal, replacedCode: vertexString),
                            CodeBlock(code: ", position1: ", codeColor: .black),
                            CodeBlock(animated: position1ParameterAnimated, code: "Value", codeColor: .cTeal, replacedCode: position1String),
                            CodeBlock(code: ", position2: ", codeColor: .black),
                            CodeBlock(animated: position2ParameterAnimated, code: "Value", codeColor: .cTeal, replacedCode: position2String),
                            CodeBlock(code: ") -> Number {", codeColor: .black)
                        ]
                    )
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vector1 = ", codeColor: .black),
                                CodeBlock(code: "Value", codeColor: .cTeal),
                                CodeBlock(code: "(", codeColor: .black)
                            ]
                        )
                        
                        CodeLineView(
                            active: currentCodeLine == 2, blocks: [
                                CodeBlock(code: "        x: ", codeColor: .black),
                                CodeBlock(animated: v1x1Animated, code: "position1.x", codeColor: .black, replacedCode: v1x1String),
                                CodeBlock(code: " - ", codeColor: .black),
                                CodeBlock(animated: v1x2Animated, code: "vertex.x", codeColor: .black, replacedCode: v1x2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 3, blocks: [
                                CodeBlock(code: "        y: ", codeColor: .black),
                                CodeBlock(animated: v1y1Animated, code: "position1.y", codeColor: .black, replacedCode: v1y1String),
                                CodeBlock(code: " - ", codeColor: .black),
                                CodeBlock(animated: v1y2Animated, code: "vertex.y", codeColor: .black, replacedCode: v1y2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 4, blocks: [
                                CodeBlock(code: "        z: ", codeColor: .black),
                                CodeBlock(animated: v1z1Animated, code: "position1.z", codeColor: .black, replacedCode: v1z1String),
                                CodeBlock(code: " - ", codeColor: .black),
                                CodeBlock(animated: v1z2Animated, code: "vertex.z", codeColor: .black, replacedCode: v1z2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 5, blocks: [
                                CodeBlock(code: "    )", codeColor: .black)
                            ]
                        )
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 6, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vector2 = ", codeColor: .black),
                                CodeBlock(code: "Value", codeColor: .cTeal),
                                CodeBlock(code: "(", codeColor: .black)
                            ]
                        )
                        
                        CodeLineView(
                            active: currentCodeLine == 7, blocks: [
                                CodeBlock(code: "        x: ", codeColor: .black),
                                CodeBlock(animated: v2x1Animated, code: "\(v2xLiteral).x", codeColor: .black, replacedCode: v2x1String),
                                CodeBlock(code: " - ", codeColor: .black),
                                CodeBlock(animated: v2x2Animated, code: "vertex.x", codeColor: .black, replacedCode: v2x2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 8, blocks: [
                                CodeBlock(code: "        y: ", codeColor: .black),
                                CodeBlock(animated: v2y1Animated, code: "\(v2yLiteral).y", codeColor: .black, replacedCode: v2y1String),
                                CodeBlock(code: " - ", codeColor: .black),
                                CodeBlock(animated: v2y2Animated, code: "vertex.y", codeColor: .black, replacedCode: v2y2String)
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 9, blocks: [
                                CodeBlock(code: "        z: ", codeColor: .black),
                                CodeBlock(animated: v2z1Animated, code: "\(v2zLiteral).z", codeColor: .black, replacedCode: v2z1String),
                                CodeBlock(code: " - ", codeColor: .black),
                                CodeBlock(animated: v2z2Animated, code: "vertex.z", codeColor: .black, replacedCode: v2z2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 10, blocks: [
                                CodeBlock(code: "    )", codeColor: .black)
                            ]
                        )
                        LineSpace()
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 11, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "xProduct = ", codeColor: .black),
                                CodeBlock(animated: product_v1xAnimated, code: "vector1.x", codeColor: .black, replacedCode: xProduct1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(animated: product_v2xAnimated, code: "vector2.x", codeColor: .black, replacedCode: xProduct2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 12, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "yProduct = ", codeColor: .black),
                                CodeBlock(animated: product_v1yAnimated, code: "vector1.y", codeColor: .black, replacedCode: yProduct1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(animated: product_v2yAnimated, code: "vector2.y", codeColor: .black, replacedCode: yProduct2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 13, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "zProduct = ", codeColor: .black),
                                CodeBlock(animated: product_v1zAnimated, code: "vector1.z", codeColor: .black, replacedCode: zProduct1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(animated: product_v2zAnimated, code: "vector2.z", codeColor: .black, replacedCode: zProduct2String),
                            ]
                        )
                        LineSpace()
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 14, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "dotProduct = ", codeColor: .black),
                                CodeBlock(animated: dotProduct_xAnimated, code: xProductLiteral, codeColor: .black, replacedCode: dotProductXString),
                                CodeBlock(code: " + ", codeColor: .black),
                                CodeBlock(animated: dotProduct_yAnimated, code: yProductLiteral, codeColor: .black, replacedCode: dotProductYString),
                                CodeBlock(code: " + ", codeColor: .black),
                                CodeBlock(animated: dotProduct_zAnimated, code: zProductLiteral, codeColor: .black, replacedCode: dotProductZString),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 15, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vertexToPosition1 = ", codeColor: .black),
                                CodeBlock(code: "distanceFormula3D", codeColor: .cTeal),
                                CodeBlock(code: "(position1: ", codeColor: .black),
                                CodeBlock(animated: vertexPos1_position1Animated, code: "vertex", codeColor: .black, replacedCode: vertexString),
                                CodeBlock(code: ", position2: ", codeColor: .black),
                                CodeBlock(animated: vertexPos1_position2Animated, code: "position1", codeColor: .black, replacedCode: position1String),
                                CodeBlock(code: ")", codeColor: .black)
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 16, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vertexToPosition2 = ", codeColor: .black),
                                CodeBlock(code: "distanceFormula3D", codeColor: .cTeal),
                                CodeBlock(code: "(position1: ", codeColor: .black),
                                CodeBlock(animated: vertexPos2_position1Animated, code: "vertex", codeColor: .black, replacedCode: vertexString),
                                CodeBlock(code: ", position2: ", codeColor: .black),
                                CodeBlock(animated: vertexPos2_position2Animated, code: "position2", codeColor: .black, replacedCode: position2String),
                                CodeBlock(code: ")", codeColor: .black)
                            ]
                        )
                        LineSpace()
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 17, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "cosineOfAngle = ", codeColor: .black),
                                CodeBlock(animated: cosOfAngle_dotProductAnimated, code: "dotProduct", codeColor: .black, replacedCode: dotProductResult),
                                CodeBlock(code: " / (", codeColor: .black),
                                CodeBlock(animated: cosOfAngle_vertexPos1Animated, code: "vertexToPosition1", codeColor: .black, replacedCode: vertexToPosition1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(animated: cosOfAngle_vertexPos2Animated, code: "vertexToPosition2", codeColor: .black, replacedCode: vertexToPosition2String),
                                CodeBlock(code: ")", codeColor: .black),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 18, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "angle = ", codeColor: .black),
                                CodeBlock(code: "acos", codeColor: .cPurple),
                                CodeBlock(code: "(", codeColor: .black),
                                CodeBlock(animated: angle_cosOfAngleAnimated, code: acosLiteral, codeColor: .black, replacedCode: cosineOfAngleString),
                                CodeBlock(code: ")", codeColor: .black),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 19, blocks: [
                                CodeBlock(code: "    return ", codeColor: .cMagenta),
                                CodeBlock(animated: angleResultAnimated, code: "angle", codeColor: .black, replacedCode: angleResultString)
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 20, blocks: [
                                CodeBlock(code: "}", codeColor: .black),
                            ]
                        )
                    }
                }
                .padding(20)
                .background(
                    Color.white
                        .cornerRadius(12)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 5, x: 0, y: 2)
                )
                .padding()
            }
        }
        .onReceive(timer) { time in
            
//            func Angle3d(vertex: Value, position1: Value, position2: Value) -> Float {
//                let vector1 = Value(
//                    x: position1.x - vertex.x,
//                    y: position1.y - vertex.y,
//                    z: position1.z - vertex.z
//                )
//                let vector2 = Value(
//                    x: position2.x - vertex.x,
//                    y: position2.y - vertex.y,
//                    z: position2.z - vertex.z
//                )
//
//                let xProduct = vector1.x * vector2.x
//                let yProduct = vector1.y * vector2.y
//                let zProduct = vector1.z * vector2.z
//
//                let dotProduct = xProduct + yProduct + zProduct
//                let vertexToPosition1 = distanceFormula3D(position1: vertex, position2: position1)
//                let vertexToPosition2 = distanceFormula3D(position1: vertex, position2: position2)
//
//                let cosineOfAngle = dotProduct / (vertexToPosition1 * vertexToPosition2)
//                let angle = acos(cosineOfAngle)
//                return angle
//            }
            
            
            if self.timerCounter == animationBlocks.indices.last ?? 0 {
                self.timer.upstream.connect().cancel()
            }
            
            animationBlocks[self.timerCounter]()
            
            self.timerCounter += 1
        }
        .onAppear {
            self.vertexString = "(\(Int(vertex.x)) x, \(Int(vertex.y)) y, \(Int(vertex.z)) z)"
            self.position1String = "(\(Int(position1.x)) x, \(Int(position1.y)) y, \(Int(position1.z)) z)"
            self.position2String = "(\(Int(position2.x)) x, \(Int(position2.y)) y, \(Int(position2.z)) z)"
            
            var hasError: Bool {
                get {
                    hasErrorLiteral != nil
                }
            }
            var hasErrorLiteral: String?

            self.v1x1String = "\(Int(position1.x))"
            self.v1x2String = "\(Int(vertex.x))"
            self.v1y1String = "\(Int(position1.y))"
            self.v1y2String = "\(Int(vertex.y))"
            self.v1z1String = "\(Int(position1.z))"
            self.v1z2String = "\(Int(vertex.z))"
            
            if v2xLiteral != "position2" { hasErrorLiteral = v2xLiteral }
            if v2yLiteral != "position2" { hasErrorLiteral = v2yLiteral }
            if v2zLiteral != "position2" { hasErrorLiteral = v2zLiteral }
            
            self.v2x1String = hasError ? "Error" : "\(Int(position2.x))"
            self.v2x2String = hasError ? "Error" : "\(Int(vertex.x))"
            self.v2y1String = hasError ? "Error" : "\(Int(position2.y))"
            self.v2y2String = hasError ? "Error" : "\(Int(vertex.y))"
            self.v2z1String = hasError ? "Error" : "\(Int(position2.z))"
            self.v2z2String = hasError ? "Error" : "\(Int(vertex.z))"
            
            let vector1 = Value(
                x: position1.x - vertex.x,
                y: position1.y - vertex.y,
                z: position1.z - vertex.z
            )
            let vector2 = Value(
                x: position2.x - vertex.x,
                y: position2.y - vertex.y,
                z: position2.z - vertex.z
            )
            
            let xProduct = vector1.x * vector2.x
            let yProduct = vector1.y * vector2.y
            let zProduct = vector1.z * vector2.z
            
            self.xProduct1String = hasError ? "Error" : "\(Int(vector1.x))"
            self.xProduct2String = hasError ? "Error" : "\(Int(vector2.x))"
            self.yProduct1String = hasError ? "Error" : "\(Int(vector1.y))"
            self.yProduct2String = hasError ? "Error" : "\(Int(vector2.y))"
            self.zProduct1String = hasError ? "Error" : "\(Int(vector1.z))"
            self.zProduct2String = hasError ? "Error" : "\(Int(vector2.z))"
            
            let dotProduct = xProduct + yProduct + zProduct
            self.dotProductXString = hasError ? "Error" : "\(Int(xProduct))"
            self.dotProductYString = hasError ? "Error" : "\(Int(yProduct))"
            self.dotProductZString = hasError ? "Error" : "\(Int(zProduct))"
            
            
            let vertexToPosition1 = distanceFormula3D(position1: vertex, position2: position1)
            let vertexToPosition2 = distanceFormula3D(position1: vertex, position2: position2)
            let cosineOfAngle = dotProduct / (vertexToPosition1 * vertexToPosition2)
            print("COS OF AN \(cosineOfAngle)")
            
            self.dotProductResult = hasError ? "Error" : "\(Int(dotProduct))"
            self.vertexToPosition1String = hasError ? "Error" : "\(Int(vertexToPosition1))"
            self.vertexToPosition2String = hasError ? "Error" : "\(Int(vertexToPosition2))"
            
            if cosineOfAngle.isNaN {
                self.cosineOfAngleString = hasError ? "Error" : "Nan"
            } else {
                self.cosineOfAngleString = hasError ? "Error" : "\(Int(cosineOfAngle))"
            }
            
            
            let angle = acos(cosineOfAngle)
            if angle.isNaN {
                self.angleResultString = hasError ? "Error" : "Nan"
            } else {
                self.angleResultString = hasError ? "Error" : "\(Int(angle))"
            }
            
            animationBlocks = [
                { withAnimation { vertexParameterAnimated = true; currentCodeLine = 0 } },
                { withAnimation { position1ParameterAnimated = true } },
                { withAnimation { position2ParameterAnimated = true } },
                
                { withAnimation { currentCodeLine = 1 } },

                { withAnimation { v1x1Animated = true; currentCodeLine = 2 } },
                { withAnimation { v1x2Animated = true } },
                { withAnimation { v1y1Animated = true; currentCodeLine = 3 } },
                { withAnimation { v1y2Animated = true } },
                { withAnimation { v1z1Animated = true; currentCodeLine = 4 } },
                { withAnimation { v1z2Animated = true } },
                
                { withAnimation { currentCodeLine = 5 } },
                { withAnimation { currentCodeLine = 6 } },
                
                { withAnimation { v2x1Animated = true; currentCodeLine = 7 } },
                { withAnimation { v2x2Animated = true } },
                { withAnimation { v2y1Animated = true; currentCodeLine = 8 } },
                { withAnimation { v2y2Animated = true } },
                { withAnimation { v2z1Animated = true; currentCodeLine = 9 } },
                { withAnimation { v2z2Animated = true } },
                
                { withAnimation { v2z1Animated = true; currentCodeLine = 10 } },
                
                { }, /// spacer
                
                { withAnimation { product_v1xAnimated = true; currentCodeLine = 11 } },
                { withAnimation { product_v2xAnimated = true } },
                { withAnimation { product_v1yAnimated = true; currentCodeLine = 12 } },
                { withAnimation { product_v2yAnimated = true } },
                { withAnimation { product_v1zAnimated = true; currentCodeLine = 13 } },
                { withAnimation { product_v2zAnimated = true } },
                
                { }, /// spacer
                
                { withAnimation { dotProduct_xAnimated = true; currentCodeLine = 14 } },
                { withAnimation { dotProduct_yAnimated = true } },
                { withAnimation { dotProduct_zAnimated = true } },
                
                { withAnimation { vertexPos1_position1Animated = true; currentCodeLine = 15 } },
                { withAnimation { vertexPos1_position2Animated = true } },
                { withAnimation { vertexPos2_position1Animated = true; currentCodeLine = 16 } },
                { withAnimation { vertexPos2_position2Animated = true } },
                
                
                { }, /// spacer
                
                { withAnimation { cosOfAngle_dotProductAnimated = true; currentCodeLine = 17 } },
                { withAnimation { cosOfAngle_vertexPos1Animated = true } },
                { withAnimation { cosOfAngle_vertexPos2Animated = true } },
                
                { withAnimation { angle_cosOfAngleAnimated = true; currentCodeLine = 18 } },
                { withAnimation { angleResultAnimated = true; currentCodeLine = 19 } },
                {
//                    if let hasErrorLiteral = hasErrorLiteral {
//                        showResult?(false, "Hmm... not quite. \n\n\"\(hasErrorLiteral)\" might not be correct.")
//                    } else {
//                        showResult?(true, "Congratulations! \n\nYou got **\(distanceResult)**, which is the correct result! \n\n[**Next Page**](@next)")
//                    }
                }
            ]
        }
    }
}


func distanceFormula3D(position1: Value, position2: Value) -> Number {
    let xDifference = position1.x - position2.x
    let yDifference = position1.y - position2.y
    let zDifference = position1.z - position2.z

    let everythingInsideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    let distance = sqrt(everythingInsideSquareRoot)
    
    return distance
}

public func acos(_ number: Number) -> Number {
    let result = acos(Double(number))
    let degrees = result.radiansToDegrees
    return Number(degrees)
}
public func sqrt(_ number: Number) -> Number {
    let result = sqrt(Double(number))
    let degrees = result.radiansToDegrees
    return Number(degrees)
}



public struct Testing {
    public var config = Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
    public var otherColor = Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
}