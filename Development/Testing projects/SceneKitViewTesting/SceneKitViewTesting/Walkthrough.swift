//
//  Walkthrough.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/14/21.
//

import SwiftUI

struct CodeBlock: Identifiable {
    let id = UUID()
    var code: String
    var codeColor: Color
    var replacedCode: String?
    var replacedCodeColor: Color?
    var showingReplacedCode = false
}

struct WalkThrough: View {
    var body: some View {
        VStack(alignment: .leading) {
            CodeLineView(
                blocks: [
                    CodeBlock(code: "func ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "distanceFormula3D", codeColor: .cTeal, replacedCode: nil),
                    CodeBlock(code: "(position1: ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "Value", codeColor: .cTeal, replacedCode: nil),
                    CodeBlock(code: ", position2: ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: ") {", codeColor: .black, replacedCode: nil),
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "xDifference", codeColor: .black, replacedCode: "100"),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "position1.x", codeColor: .black, replacedCode: "300"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "position2.x", codeColor: .black, replacedCode: "400")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "yDifference", codeColor: .black, replacedCode: "100"),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "position1.y", codeColor: .black, replacedCode: "300"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "position2.y", codeColor: .black, replacedCode: "400")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "zDifference", codeColor: .black, replacedCode: "100"),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "position1.z", codeColor: .black, replacedCode: "300"),
                    CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "position2.z", codeColor: .black, replacedCode: "400")
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: "1000"),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "xDifference", codeColor: .black, replacedCode: "Number"),
                    CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "yDifference", codeColor: .black, replacedCode: "Number"),
                    CodeBlock(code: ", 2) + ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "pow", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "zDifference", codeColor: .black, replacedCode: "Number"),
                    CodeBlock(code: ", 2)", codeColor: .black, replacedCode: nil),
                ]
            )
            CodeLineView(
                blocks: [
                    CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
                    CodeBlock(code: "distance", codeColor: .black, replacedCode: "100"),
                    CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "sqrt", codeColor: .cPurple, replacedCode: nil),
                    CodeBlock(code: "(", codeColor: .black, replacedCode: nil),
                    CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: "10123"),
                    CodeBlock(code: ")", codeColor: .cPurple, replacedCode: nil),
                ]
            )
        }
    }
}

struct CodeLineView: View {
    var blocks = [CodeBlock]()
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(blocks) { block in
                    if
                        let replacedCode = block.replacedCode,
                        let replacedCodeColor = block.replacedCodeColor
                    {
                        Text(block.showingReplacedCode ? replacedCode : block.code)
                            .foregroundColor(block.showingReplacedCode ? replacedCodeColor : block.codeColor)
                    } else {
                        Text(block.code)
                            .foregroundColor(block.codeColor)
                    }
                }
            }
        }
    }
}

struct WalkThrough_Previews: PreviewProvider {
    static var previews: some View {
        WalkThrough()
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
    
    
    CodeLineView(
        blocks: [
            CodeBlock(code: "func ", codeColor: .cMagenta, replacedCode: nil),
            CodeBlock(code: "distanceFormula3D", codeColor: .cTeal, replacedCode: nil),
            CodeBlock(code: "(position1: ", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "Value", codeColor: .cTeal, replacedCode: nil),
            CodeBlock(code: ", position2: ", codeColor: .black, replacedCode: nil),
            CodeBlock(code: ") {", codeColor: .black, replacedCode: nil),
        ]
    )
    CodeLineView(
        blocks: [
            CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
            CodeBlock(code: "xDifference", codeColor: .black, replacedCode: "100"),
            CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "position1.x", codeColor: .black, replacedCode: "300"),
            CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
            CodeBlock(code: "position2.x", codeColor: .black, replacedCode: "400"),
            CodeBlock(code: ") {", codeColor: .black, replacedCode: nil),
        ]
    )
    CodeLineView(
        blocks: [
            CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
            CodeBlock(code: "yDifference", codeColor: .black, replacedCode: "100"),
            CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "position1.z", codeColor: .black, replacedCode: "300"),
            CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
            CodeBlock(code: "position2.z", codeColor: .black, replacedCode: "400"),
            CodeBlock(code: ") {", codeColor: .black, replacedCode: nil),
        ]
    )
    CodeLineView(
        blocks: [
            CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
            CodeBlock(code: "zDifference", codeColor: .black, replacedCode: "100"),
            CodeBlock(code: " = ", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "position1.y", codeColor: .black, replacedCode: "300"),
            CodeBlock(code: " - ", codeColor: .cPurple, replacedCode: nil),
            CodeBlock(code: "position2.y", codeColor: .black, replacedCode: "400"),
            CodeBlock(code: ") {", codeColor: .black, replacedCode: nil),
        ]
    )
    CodeLineView(
        blocks: [
            CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
            CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: "1000"),
            CodeBlock(code: " = pow(", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "Number", codeColor: .cPurple, replacedCode: "Number"),
            CodeBlock(code: ", 2) + pow(", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "Number", codeColor: .cPurple, replacedCode: "Number"),
            CodeBlock(code: ", 2) + pow(", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "Number", codeColor: .cPurple, replacedCode: "Number"),
            CodeBlock(code: ", 2)", codeColor: .black, replacedCode: nil),
        ]
    )
    CodeLineView(
        blocks: [
            CodeBlock(code: "let ", codeColor: .cMagenta, replacedCode: nil),
            CodeBlock(code: "distance", codeColor: .black, replacedCode: "100"),
            CodeBlock(code: " = sqrt(", codeColor: .black, replacedCode: nil),
            CodeBlock(code: "everythingInsideSquareRoot", codeColor: .black, replacedCode: "10123"),
            CodeBlock(code: ")", codeColor: .cPurple, replacedCode: nil),
        ]
    )
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
