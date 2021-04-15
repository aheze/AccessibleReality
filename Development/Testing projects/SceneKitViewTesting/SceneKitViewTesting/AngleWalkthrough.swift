//
//  AngleWalkthrough.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/15/21.
//

import SwiftUI

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
    var vertex = Value(x: 0, y: 0, z: 0)
    var position1 = Value(x: 0, y: 0, z: 0)
    var position2 = Value(x: 4, y: 25, z: 30)
    
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
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var animationBlocks: [(() -> Void)] = []
    
    @State var currentCodeLine = 0
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading) {
                    CodeLineView(
                        active: currentCodeLine == 0, blocks: [
                            CodeBlock(code: "func ", codeColor: .cMagenta),
                            CodeBlock(code: "angle3D", codeColor: .black),
                            CodeBlock(code: "vertex: ", codeColor: .black),
                            CodeBlock(animated: position1ParameterAnimated, code: "Value", codeColor: .cTeal, replacedCode: position1String),
                            CodeBlock(code: ", position1: ", codeColor: .black),
                            CodeBlock(animated: position2ParameterAnimated, code: "Value", codeColor: .cTeal, replacedCode: position2String),
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
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "        x: ", codeColor: .cMagenta),
                                CodeBlock(code: "position1.x", codeColor: .black, replacedCode: v1x1String),
                                CodeBlock(code: " - ", codeColor: .cMagenta),
                                CodeBlock(code: "vertex.x", codeColor: .black, replacedCode: v1x2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "        y: ", codeColor: .cMagenta),
                                CodeBlock(code: "position1.y", codeColor: .black, replacedCode: v1y1String),
                                CodeBlock(code: " - ", codeColor: .cMagenta),
                                CodeBlock(code: "vertex.y", codeColor: .black, replacedCode: v1y2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "        z: ", codeColor: .cMagenta),
                                CodeBlock(code: "position1.z", codeColor: .black, replacedCode: v1z1String),
                                CodeBlock(code: " - ", codeColor: .cMagenta),
                                CodeBlock(code: "vertex.z", codeColor: .black, replacedCode: v1z2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    )", codeColor: .cMagenta)
                            ]
                        )
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vector2 = ", codeColor: .black),
                                CodeBlock(code: "Value", codeColor: .cTeal),
                                CodeBlock(code: "(", codeColor: .black)
                            ]
                        )
                        
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "        x: ", codeColor: .cMagenta),
                                CodeBlock(code: "\(v2xLiteral).x", codeColor: .black, replacedCode: v2x1String),
                                CodeBlock(code: " - ", codeColor: .cMagenta),
                                CodeBlock(code: "vertex.x", codeColor: .black, replacedCode: v2x2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "        y: ", codeColor: .cMagenta),
                                CodeBlock(code: "\(v2yLiteral).y", codeColor: .black, replacedCode: v2y1String),
                                CodeBlock(code: " - ", codeColor: .cMagenta),
                                CodeBlock(code: "vertex.y", codeColor: .black, replacedCode: v2y2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "        z: ", codeColor: .cMagenta),
                                CodeBlock(code: "\(v2zLiteral).z", codeColor: .black, replacedCode: v2z1String),
                                CodeBlock(code: " - ", codeColor: .cMagenta),
                                CodeBlock(code: "vertex.z", codeColor: .black, replacedCode: v2z2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    )", codeColor: .cMagenta)
                            ]
                        )
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "xProduct = ", codeColor: .black),
                                CodeBlock(code: "vector1.x", codeColor: .black, replacedCode: xProduct1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(code: "vector2.x", codeColor: .black, replacedCode: xProduct2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "yProduct = ", codeColor: .black),
                                CodeBlock(code: "vector1.y", codeColor: .black, replacedCode: yProduct1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(code: "vector2.y", codeColor: .black, replacedCode: yProduct2String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "zProduct = ", codeColor: .black),
                                CodeBlock(code: "vector1.z", codeColor: .black, replacedCode: zProduct1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(code: "vector2.z", codeColor: .black, replacedCode: zProduct2String),
                            ]
                        )
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "dotProduct = ", codeColor: .black),
                                CodeBlock(code: xProductLiteral, codeColor: .black, replacedCode: dotProductXString),
                                CodeBlock(code: " + ", codeColor: .black),
                                CodeBlock(code: yProductLiteral, codeColor: .black, replacedCode: dotProductYString),
                                CodeBlock(code: " + ", codeColor: .black),
                                CodeBlock(code: zProductLiteral, codeColor: .black, replacedCode: dotProductZString),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vertexToPosition1 = ", codeColor: .black),
                                CodeBlock(code: "distanceFormula3D", codeColor: .cTeal),
                                CodeBlock(code: "(position1: ", codeColor: .black),
                                CodeBlock(code: "vertex", codeColor: .black, replacedCode: vertexString),
                                CodeBlock(code: ", position2: ", codeColor: .black),
                                CodeBlock(code: "position1", codeColor: .black, replacedCode: position1String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vertexToPosition2 = ", codeColor: .black),
                                CodeBlock(code: "distanceFormula3D", codeColor: .cTeal),
                                CodeBlock(code: "(position1: ", codeColor: .black),
                                CodeBlock(code: "vertex", codeColor: .black, replacedCode: vertexString),
                                CodeBlock(code: ", position2: ", codeColor: .black),
                                CodeBlock(code: "position2", codeColor: .black, replacedCode: position2String),
                            ]
                        )
                    }
                    
                    Group {
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "cosineOfAngle = ", codeColor: .black),
                                CodeBlock(code: "dotProduct", codeColor: .black, replacedCode: dotProductResult),
                                CodeBlock(code: " / (", codeColor: .black),
                                CodeBlock(code: "vertexToPosition1", codeColor: .black, replacedCode: vertexToPosition1String),
                                CodeBlock(code: " * ", codeColor: .black),
                                CodeBlock(code: "vertexToPosition2", codeColor: .black, replacedCode: vertexToPosition2String),
                                CodeBlock(code: ")", codeColor: .black),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vertexToPosition1 = ", codeColor: .black),
                                CodeBlock(code: "distanceFormula3D", codeColor: .cTeal),
                                CodeBlock(code: "(position1: ", codeColor: .black),
                                CodeBlock(code: "vertex", codeColor: .black, replacedCode: vertexString),
                                CodeBlock(code: ", position2: ", codeColor: .black),
                                CodeBlock(code: "position1", codeColor: .black, replacedCode: position1String),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta),
                                CodeBlock(code: "vertexToPosition2 = ", codeColor: .black),
                                CodeBlock(code: "distanceFormula3D", codeColor: .cTeal),
                                CodeBlock(code: "(position1: ", codeColor: .black),
                                CodeBlock(code: "vertex", codeColor: .black, replacedCode: vertexString),
                                CodeBlock(code: ", position2: ", codeColor: .black),
                                CodeBlock(code: "position2", codeColor: .black, replacedCode: position2String),
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
            self.position1String = "(\(Int(position1.x)) x, \(Int(position1.y)) y, \(Int(position1.z)) z)"
            self.position2String = "(\(Int(position2.x)) x, \(Int(position2.y)) y, \(Int(position2.z)) z)"
            
            var hasError = false
            var hasErrorLiteral: String?
            
            let x1ValueFloat = position1.x
            let y1ValueFloat = position1.y
            let z1ValueFloat = position1.z
            var x2ValueFloat = Float(0)
            var y2ValueFloat = Float(0)
            var z2ValueFloat = Float(0)
            
        }
    }
}





