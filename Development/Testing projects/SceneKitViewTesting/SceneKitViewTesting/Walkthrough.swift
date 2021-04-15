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
    var replacedCodeColor = Color.green
//    var showingReplacedCode = false
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
    
    @State var xValue = Value(x: 0, y: 0, z: 0)
    @State var yValue = Value(x: 0, y: 0, z: 0)
    @State var zValue = Value(x: 0, y: 0, z: 0)
    @State var pow1 = Number(0)
    @State var pow2 = Number(0)
    @State var pow3 = Number(0)
    
    /// results
    @State var position1String = ""
    @State var position2String = ""
    
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
    @State var insideSqRootAnimated = false
    @State var distanceAnimated = false
    
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
                    CodeBlock(animated: xValue1Animated, code: "position1.x", codeColor: .black, replacedCode: "300"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(animated: xValue2Animated, code: "\(xValueLiteral).x", codeColor: .black, replacedCode: "\(xValue.x.rounded())")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "yDifference", codeColor: .black, replacedCode: yDifference),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: yValue1Animated, code: "position1.y", codeColor: .black, replacedCode: "300"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(animated: yValue2Animated, code: "\(yValueLiteral).y", codeColor: .black, replacedCode: "\(yValue.y.rounded())")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "zDifference", codeColor: .black, replacedCode: zDifference),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(animated: zValue1Animated, code: "position1.z", codeColor: .black, replacedCode: "300"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(animated: zValue2Animated, code: "\(zValueLiteral).z", codeColor: .black, replacedCode: "\(zValue.z.rounded())")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: "1000"),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: pow1Literal, codeColor: .black, replacedCode: "\(pow1.rounded())"),
                    CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: pow2Literal, codeColor: .black, replacedCode: "\(pow2.rounded())"),
                    CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: pow3Literal, codeColor: .black, replacedCode: "\(pow3.rounded())"),
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
                    CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: insideSquareRootResult),
                    CodeBlock(code: ")", codeColor: .cPurple, replacedCode: nil),
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "    return ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "distance", codeColor: .black, replacedCode: distanceResult)
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "}", codeColor: .black, replacedCode: nil)
                ]
            )
        }
        .onAppear {
            self.position1String = "(\(position1.x) x, \(position1.y) y, \(position1.z) z)"
            self.position2String = "(\(position2.x) x, \(position2.y) y, \(position2.z) z)"
            
            if xValueLiteral == "position2" { xValue = position2 }
            if yValueLiteral == "position2" { yValue = position2 }
            if zValueLiteral == "position2" { zValue = position2 }
            
            let xDiff = position1.x - xValue.x
            let yDiff = position1.y - xValue.y
            let zDiff = position1.z - xValue.z
            
            xDifference = "\(xDiff)"
            yDifference = "\(yDiff)"
            zDifference = "\(zDiff)"
            
            let insideSquareRoot = pow(xDiff, 2) + pow(yDiff, 2) + pow(zDiff, 2)
            insideSquareRootResult = "\(insideSquareRoot)"
            distanceResult = "\(sqrt(insideSquareRoot))"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("animated.. \(position1String)")
                withAnimation { position1ParameterAnimated = true }
                withAnimation { position2ParameterAnimated = true }
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
                            let replacedCodeColor = block.replacedCodeColor,
                            let animated = block.animated,
                            animated
                        {
                            Text(replacedCode)
                                .foregroundColor(replacedCodeColor)
                                .font(.system(size: 18, weight: .regular, design: .monospaced))
                        } else {
                            Text(block.code)
                                .foregroundColor(block.codeColor)
                                .font(.system(size: 18, weight: .regular, design: .monospaced))
                        }
                    }
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
