//
//  Walkthrough.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/14/21.
//

import SwiftUI

struct CodeBlock: Identifiable {
    let id = UUID()
    var animated: Bool?
    var code: String
    var codeColor: Color
    var replacedCode: String?
}

struct WalkThrough: View {
    
    /// parameters
    var position1 = Value(x: 0, y: 0, z: 0)
    var position2 = Value(x: 4, y: 25, z: 30)
    
    /// user entered code literals
    var xValueLiteral = "position2"
    var yValueLiteral = "position2"
    var zValueLiteral = "position2"
    var pow1Literal = "xDifference"
    var pow2Literal = "yDifference"
    var pow3Literal = "zDifference"
    
    
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
    
    @State var showingEnding: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            CodeLineView(
                blocks: [
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
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "xDifference", codeColor: .black, replacedCode: xDifference),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: xValue1Animated, code: "position1.x", codeColor: .black, replacedCode: "\(x1Value)"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(animated: xValue2Animated, code: "\(xValueLiteral).x", codeColor: .black, replacedCode: "\(x2Value)")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "yDifference", codeColor: .black, replacedCode: yDifference),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: yValue1Animated, code: "position1.y", codeColor: .black, replacedCode: "\(y1Value)"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(animated: yValue2Animated, code: "\(yValueLiteral).y", codeColor: .black, replacedCode: "\(y2Value)")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "zDifference", codeColor: .black, replacedCode: zDifference),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: zValue1Animated, code: "position1.z", codeColor: .black, replacedCode: "\(z1Value)"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(animated: zValue2Animated, code: "\(zValueLiteral).z", codeColor: .black, replacedCode: "\(z2Value)")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: "1000"),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: pow1Animated, code: pow1Literal, codeColor: .black, replacedCode: xDifference),
                    CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: pow2Animated, code: pow2Literal, codeColor: .black, replacedCode: yDifference),
                    CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: pow3Animated, code: pow3Literal, codeColor: .black, replacedCode: zDifference),
                    CodeBlock(code: ", 2)", codeColor: .black, replacedCode: nil),
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "distance", codeColor: .black, replacedCode: distanceResult),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "sqrt", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: insideSquareRootAnimated, code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: insideSquareRootResult),
                    CodeBlock(code: ")", codeColor: .cPurple, replacedCode: nil),
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    return ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(animated: distanceAnimated, code: "distance", codeColor: .black, replacedCode: distanceResult)
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "}", codeColor: .black, replacedCode: nil)
                ]
            )
            
            Group {
                if let endingString = showingEnding {
                    Text(endingString)
                        .foregroundColor(Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)))
                        .font(.system(.title))
                }
            }
            .transition(.opacity)
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
            
            if xValueLiteral == "position2" { x2ValueFloat = position2.x } else { hasError = true; hasErrorLiteral = xValueLiteral }
            if yValueLiteral == "position2" { y2ValueFloat = position2.y } else { hasError = true; hasErrorLiteral = yValueLiteral }
            if zValueLiteral == "position2" { z2ValueFloat = position2.z } else { hasError = true; hasErrorLiteral = zValueLiteral }
            
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
            
            if pow1Literal != "xDifference" { hasError = true ; hasErrorLiteral = pow1Literal  }
            if pow2Literal != "yDifference" { hasError = true ; hasErrorLiteral = pow2Literal  }
            if pow3Literal != "zDifference" { hasError = true ; hasErrorLiteral = pow3Literal  }
            
            let insideSquareRoot = pow(xDiff, 2) + pow(yDiff, 2) + pow(zDiff, 2)
            insideSquareRootResult = hasError ? "Error" : "\(Int(insideSquareRoot))"
            distanceResult = hasError ? "Error" : "\(Int(sqrt(insideSquareRoot)))"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation { position1ParameterAnimated = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation { position2ParameterAnimated = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation { xValue1Animated = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation { xValue2Animated = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
                withAnimation { yValue1Animated = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) {
                withAnimation { yValue2Animated = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation { zValue1Animated = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                withAnimation { zValue2Animated = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation { pow1Animated = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.6) {
                withAnimation { pow2Animated = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                withAnimation { pow3Animated = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.3) {
                withAnimation { insideSquareRootAnimated = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.6) {
                withAnimation { distanceAnimated = true }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 9.2) {
                
                if let hasErrorLiteral = hasErrorLiteral {
                    withAnimation {
                        showingEnding = "Hmm... not quite. \"\(hasErrorLiteral)\" might not be correct."
                    }
                } else {
                    withAnimation {
                        showingEnding = "Congratulations! You got \(distanceResult), which is the correct result!"
                    }
                }
            }
        }
    }
}

struct CodeLineView: View {
    var blocks = [CodeBlock]()
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(blocks) { block in
                    Group {
                        
                        if
                            let replacedCode = block.replacedCode,
                            let animated = block.animated,
                            animated
                        {
                            Text(replacedCode)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .medium, design: .monospaced))
                                .padding(4)
                                .background(Color.green.brightness(-0.2))
                                .cornerRadius(6)
                        } else {
                            Text(block.code)
                                .foregroundColor(block.codeColor)
                                .font(.system(size: 18, weight: .regular, design: .monospaced))
                        }
                    }
                    .frame(height: 30)
                    .transition(.opacity)
                }
            }
        }
    }
}

struct WalkThrough_Previews: PreviewProvider {
    static var previews: some View {
        WalkThrough()
            .previewLayout(.fixed(width: 800, height: 600))
    }
}

func asdasd() {
    let cubeNode = Node()
    let cameraNode = Node()

    let xDifference = cubeNode.position.x - cameraNode.position.x
    let yDifference = cubeNode.position.y - cameraNode.position.y
    let zDifference = cubeNode.position.z - cameraNode.position.z

    let everythingInsideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    let distance = sqrt(everythingInsideSquareRoot)
    
}
func dsistanceFormula3D(position1: Value, position2: Value) {
    let xDifference = position1.x - position2.x
    let yDifference = position1.y - position2.y
    let zDifference = position1.z - position2.z

    let everythingInsideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    let distance = sqrt(everythingInsideSquareRoot)
}

//func distanceFormula3D(position1: Value, position2: Value) {
//    let xDifference = position1.x - /*#-editable-code cameraNode x coordinate*/<#T##Value#>/*#-end-editable-code*/.x
//    let yDifference = position1.y - /*#-editable-code cameraNode x coordinate*/<#T##Value#>/*#-end-editable-code*/.y
//    let zDifference = position1.z - /*#-editable-code cameraNode x coordinate*/<#T##Value#>/*#-end-editable-code*/.z
//
//    let everythingInsideSquareRoot = pow(<#T##Number#>, 2) + pow(<#T##Number#>, 2) + pow(<#T##Number#>, 2)
//    let distance = sqrt(everythingInsideSquareRoot)
//}

public typealias Number = Float

extension Color {
    static var cMagenta = Color("cMagenta")
    static var cTeal = Color("cTeal")
    static var cPurple = Color("cPurple")
    static var cBlue = Color("cBlue")
}
