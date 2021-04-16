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

struct InfoCard: View {
    
    var x: Double
    var y: Double
    var z: Double
    
    var parameterName = "position1"
    var compactLayout = false
    let name: String
    let imageType: String
    
    var body: some View {
        
        
        VStack {
            Text(parameterName)
                .font(.system(size: 19, weight: .medium, design: .monospaced))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
            
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
                        .font(.system(size: 28, weight: .medium))
                    
                }
                .padding(20)
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
                .padding(20)
            }
            
            
        }
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 5, x: 0, y: 2)
        
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(
            x: 40,
            y: 20,
            z: 1,
            compactLayout: true,
            name: "cubeNode",
            imageType: "Position"
        )
        .previewLayout(.fixed(width: 300, height: 300))
    }
}
