//
//  Card.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/15/21.
//

import SwiftUI

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
