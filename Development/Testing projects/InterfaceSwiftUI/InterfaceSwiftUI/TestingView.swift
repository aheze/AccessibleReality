//
//  TestingView.swift
//  InterfaceSwiftUI
//
//  Created by Zheng on 4/4/21.
//

import SwiftUI

/// Ran into this problem: "SwiftUI ForEach index out of range error when removing row"
/// `ObservableObject` solution from https://stackoverflow.com/a/62796050/14351818
class Card: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String

    init(name: String) {
        self.name = name
    }
}

struct ContentView: View {
    @State var cards = [
        Card(name: "Apple"),
        Card(name: "Banana "),
        Card(name: "Coupon"),
        Card(name: "Dog"),
        Card(name: "Eat")
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                
                ForEach(cards.indices, id: \.self) { index in
                    CardView(card: cards[index], removePressed: {
                        
                        withAnimation(.easeOut) {
                            _ = cards.remove(at: index) /// remove the card
                        }
                        
                    })
                    .transition(.scale)
                }
                
            }
        }
    }
}

struct CardView: View {
    
    @ObservedObject var card: Card
    var removePressed: (() -> Void)?
    
    var body: some View {
        Button(action: {
            removePressed?() /// call the remove closure
        }) {
            VStack {
                Text("Remove")
                Text(card.name)
            }
        }
        .foregroundColor(Color.white)
        .font(.system(size: 24, weight: .medium))
        .padding(40)
        .background(Color.red)
    }
}
