//
//  Hint.swift
//  BookCore
//
//  Created by Zheng on 4/13/21.
//

import SwiftUI

struct HintView: View {
    var hint = "Tap \"Run My Code\"!"
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            Text(hint)
                .foregroundColor(.green)
                .font(.system(size: 24, weight: .medium))
                .padding(20)
                .background(
                    Color(.systemBackground)
                )
                .cornerRadius(16)
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}
