//
//  Walkthrough.swift
//  BookCore
//
//  Created by Zheng on 4/14/21.
//

import SwiftUI

public typealias Number = Float

struct CodeBlock: Identifiable {
    let id = UUID()
    var animated: Bool?
    var code: String
    var codeColor: Color
    var replacedCode: String?
}

struct CodeLineView: View {
    var active: Bool
    var activeBlock: CodeBlock?
    var blocks = [CodeBlock]()
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(blocks) { block in
                VStack {
                    
                    if
                        let replacedCode = block.replacedCode,
                        let animated = block.animated,
                        animated == true
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
            }
        }
        .padding(.horizontal, 16)
        .background(
            Group {
                if active {
                    Rectangle()
                        .fill(Color.green.opacity(0.3))
                        .cornerRadius(4)
                        .transition(
                            AnyTransition.opacity.combined(
                                with: .asymmetric(
                                    insertion: .move(edge: .top),
                                    removal: .move(edge: .bottom)
                                )
                            )
                        )
                }
            }
        )
    }
}

extension Color {
    static var cMagenta = Color("cMagenta")
    static var cTeal = Color("cTeal")
    static var cPurple = Color("cPurple")
    static var cBlue = Color("cBlue")
}
