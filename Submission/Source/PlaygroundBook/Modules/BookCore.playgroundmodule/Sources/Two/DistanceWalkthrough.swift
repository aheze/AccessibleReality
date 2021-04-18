//
//  DistanceWalkthrough.swift
//  BookCore
//
//  Created by Zheng on 4/14/21.
//

import SwiftUI

struct WalkThrough: View {
    
    @ObservedObject var svm1: SlidersViewModel
    @ObservedObject var svm2: SlidersViewModel
    
    
    /// user entered code literals
    var xValueLiteral: String
    var yValueLiteral: String
    var zValueLiteral: String
    
    var showResult: ((Bool, String, String) -> Void)?
    
    /// results
    @State var position1String = ""
    @State var position2String = ""
    
    @State var x1Value = ""
    @State var y1Value = ""
    @State var z1Value = ""
    @State var x2Value = ""
    @State var y2Value = ""
    @State var z2Value = ""
    
    @State var xDifference = "Error"
    @State var yDifference = "Error"
    @State var zDifference = "Error"
    
    @State var insideSquareRootResult = "Error"
    @State var distanceResult = "Error"
    
    /// animating
    @State var position1ParameterAnimated = false
    @State var position2ParameterAnimated = false
    
    @State var xValue1Animated = false
    @State var yValue1Animated = false
    @State var zValue1Animated = false
    @State var xValue2Animated = false
    @State var yValue2Animated = false
    @State var zValue2Animated = false
    
    @State var pow1Animated = false
    @State var pow2Animated = false
    @State var pow3Animated = false
    @State var insideSquareRootAnimated = false
    @State var distanceAnimated = false
    
    @State var timerCounter = 0
    @State var timerStarted = false
    @State var timer = Timer.publish(every: 0.5, on: .main, in: .common)
    @State var animationBlocks: [(() -> Void)] = []
    
    @State var currentCodeLine = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                Text("Parameters")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.green)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 6, trailing: 20))
                
                HStack(spacing: 16) {
                    InfoCard(
                        x: svm1.x,
                        y: svm1.y,
                        z: svm1.z,
                        parameterName: "position1",
                        layout: .compact,
                        name: "cubeNode",
                        imageType: "Position"
                    )
                    InfoCard(
                        x: svm2.x,
                        y: svm2.y,
                        z: svm2.z,
                        parameterName: "position2",
                        layout: .compact,
                        name: "cameraNode",
                        imageType: "Position"
                    )
                }
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                
                HStack(spacing: 16) {
                    Text("Code walkthrough")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(Color.green)
                    
                    if !timerStarted {
                        Button(action: {
                            withAnimation(.spring()) {
                                timerStarted = true
                            }
                            self.timer = Timer.publish(every: 0.5, on: .main, in: .common)
                            _ = self.timer.connect()
                        }) {
                            Text("Start")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(Color.green)
                                .cornerRadius(16)
                        }
                        .transition(.scale)
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 12, trailing: 20))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        CodeLineView(
                            active: currentCodeLine == 0, blocks: [
                                CodeBlock(code: "func ", codeColor: .cMagenta, replacedCode: nil),
                                CodeBlock(code: "distanceFormula3D", codeColor: .black, replacedCode: nil),
                                CodeBlock(code: "(position1: ", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: position1ParameterAnimated, code: "Value", codeColor: .cTeal, replacedCode: position1String),
                                CodeBlock(code: ", position2: ", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: position2ParameterAnimated, code: "Value", codeColor: .cTeal, replacedCode: position2String),
                                CodeBlock(code: ") -> Number {", codeColor: .black, replacedCode: nil),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 1, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                                CodeBlock(code: "xDifference", codeColor: .black, replacedCode: xDifference),
                                CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: xValue1Animated, code: "position1.x", codeColor: .black, replacedCode: "\(x1Value)"),
                                CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                                CodeBlock(animated: xValue2Animated, code: "\(xValueLiteral).x", codeColor: .black, replacedCode: "\(x2Value)")
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 2, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                                CodeBlock(code: "yDifference", codeColor: .black, replacedCode: yDifference),
                                CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: yValue1Animated, code: "position1.y", codeColor: .black, replacedCode: "\(y1Value)"),
                                CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                                CodeBlock(animated: yValue2Animated, code: "\(yValueLiteral).y", codeColor: .black, replacedCode: "\(y2Value)")
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 3, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                                CodeBlock(code: "zDifference", codeColor: .black, replacedCode: zDifference),
                                CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: zValue1Animated, code: "position1.z", codeColor: .black, replacedCode: "\(z1Value)"),
                                CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                                CodeBlock(animated: zValue2Animated, code: "\(zValueLiteral).z", codeColor: .black, replacedCode: "\(z2Value)")
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 4, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                                CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: "1000"),
                                CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                                CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                                CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: pow1Animated, code: "xDifference", codeColor: .black, replacedCode: xDifference),
                                CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                                CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                                CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: pow2Animated, code: "yDifference", codeColor: .black, replacedCode: yDifference),
                                CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                                CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                                CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: pow3Animated, code: "zDifference", codeColor: .black, replacedCode: zDifference),
                                CodeBlock(code: ", 2)", codeColor: .black, replacedCode: nil),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 5, blocks: [
                                CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                                CodeBlock(code: "distance", codeColor: .black, replacedCode: distanceResult),
                                CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                                CodeBlock(code: "sqrt", codeColor: .cPurple, replacedCode: nil),
                                CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                                CodeBlock(animated: insideSquareRootAnimated, code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: insideSquareRootResult),
                                CodeBlock(code: ")", codeColor: .black, replacedCode: nil),
                            ]
                        )
                        CodeLineView(
                            active: currentCodeLine == 6, blocks: [
                                CodeBlock(code: "    return ", codeColor: .cMagenta, replacedCode: nil),
                                CodeBlock(animated: distanceAnimated, code: "distance", codeColor: .black, replacedCode: distanceResult)
                            ]
                        )
                        CodeLineView(
                            active: false, blocks: [
                                CodeBlock(code: "}", codeColor: .black, replacedCode: nil)
                            ]
                        )
                    }
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 12, trailing: 20))
                }
                .padding()
                .background(
                    Color.white
                        .cornerRadius(12)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 5, x: 0, y: 2)
                        
                )
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 160, trailing: 20))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onReceive(timer) { time in
            if self.timerCounter == animationBlocks.indices.last ?? 0 {
                self.timer.connect().cancel()
            }
            
            animationBlocks[self.timerCounter]()
            
            self.timerCounter += 1
        }
        .onAppear {
            self.position1String = "(\(Int(svm1.x)) x, \(Int(svm1.y)) y, \(Int(svm1.z)) z)"
            self.position2String = "(\(Int(svm2.x)) x, \(Int(svm2.y)) y, \(Int(svm2.z)) z)"
            
            var hasError = false
            var hasErrorLiteral: String?
            
            let x1ValueFloat = Float(svm1.x)
            let y1ValueFloat = Float(svm1.y)
            let z1ValueFloat = Float(svm1.z)
            var x2ValueFloat = Float(0)
            var y2ValueFloat = Float(0)
            var z2ValueFloat = Float(0)
            
            if xValueLiteral == "position2" { x2ValueFloat = Float(svm2.x) } else { hasError = true; hasErrorLiteral = xValueLiteral }
            if yValueLiteral == "position2" { y2ValueFloat = Float(svm2.y) } else { hasError = true; hasErrorLiteral = yValueLiteral }
            if zValueLiteral == "position2" { z2ValueFloat = Float(svm2.z) } else { hasError = true; hasErrorLiteral = zValueLiteral }
            
            let xDiff = x1ValueFloat - x2ValueFloat
            let yDiff = y1ValueFloat - y2ValueFloat
            let zDiff = z1ValueFloat - z2ValueFloat
            
            self.x1Value = hasError ? "Error" : "\(Int(x1ValueFloat))"
            self.y1Value = hasError ? "Error" : "\(Int(y1ValueFloat))"
            self.z1Value = hasError ? "Error" : "\(Int(z1ValueFloat))"
            self.x2Value = hasError ? "Error" : "\(Int(x2ValueFloat))"
            self.y2Value = hasError ? "Error" : "\(Int(y2ValueFloat))"
            self.z2Value = hasError ? "Error" : "\(Int(z2ValueFloat))"
            
            xDifference = hasError ? "Error" : "\(Int(xDiff))"
            yDifference = hasError ? "Error" : "\(Int(yDiff))"
            zDifference = hasError ? "Error" : "\(Int(zDiff))"
            
            let insideSquareRoot = pow(xDiff, 2) + pow(yDiff, 2) + pow(zDiff, 2)
            let distResult = sqrt(insideSquareRoot)
            
            insideSquareRootResult = hasError ? "Error" : "\(Int(insideSquareRoot))"
            distanceResult = hasError ? "Error" : "\(Int(distResult))"
            
            
            animationBlocks = [
                { withAnimation { position1ParameterAnimated = true; currentCodeLine = 0 } },
                { withAnimation { position2ParameterAnimated = true } },
                
                { }, /// spacer
                
                { withAnimation { xValue1Animated = true; currentCodeLine = 1 } },
                { withAnimation { xValue2Animated = true } },
                
                { }, /// spacer
                
                { withAnimation { yValue1Animated = true; currentCodeLine = 2 } },
                { withAnimation { yValue2Animated = true } },
                
                { }, /// spacer
                
                { withAnimation { zValue1Animated = true; currentCodeLine = 3 } },
                { withAnimation { zValue2Animated = true } },
                
                { }, /// spacer
                
                { withAnimation { pow1Animated = true; currentCodeLine = 4 } },
                { withAnimation { pow2Animated = true } },
                { withAnimation { pow3Animated = true } },
                
                { }, /// spacer
                
                { withAnimation { insideSquareRootAnimated = true; currentCodeLine = 5 } },
                { withAnimation { distanceAnimated = true; currentCodeLine = 6 } },
                
                { }, /// spacer
                
                {
                    if let hasErrorLiteral = hasErrorLiteral {
                        showResult?(false, "Hmm… not quite. \"\(hasErrorLiteral)\" might not be correct.", "")
                    } else {
                        showResult?(true, "Congratulations! \n\nYou got \(distanceResult)cm, which is the correct distance! \n\n[**Next Page**](@next)", distanceResult)
                    }
                }
            ]
        }
    }
}
