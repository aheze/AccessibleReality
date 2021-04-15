//
//  Walkthrough.swift
//  BookCore
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

extension Color {
    static var cMagenta = Color("cMagenta")
    static var cTeal = Color("cTeal")
    static var cPurple = Color("cPurple")
    static var cBlue = Color("cBlue")
}
