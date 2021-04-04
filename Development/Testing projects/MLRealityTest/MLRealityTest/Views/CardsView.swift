//
//  CardsView.swift
//  MLRealityTest
//
//  Created by Zheng on 4/3/21.
//

import SwiftUI

struct CardsView: View {
    var body: some View {
        CardView()
    }
}

struct CardView: View {
    var body: some View {
        VStack {
            Button(action: {

            }) {
                Text("Add")
            }

            VStack {
                Text("Pencil")
                    .background(Color.white.opacity(0.5))
            }
            .background(Color.green)
        }
    }
}
