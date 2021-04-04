//
//  TestingView.swift
//  InterfaceSwiftUI
//
//  Created by Zheng on 4/4/21.
//

import SwiftUI

//
//struct CapsuleButtonFilled: View {
//
//    // MARK: - PROPERTIES
//
//    var backgroundColor: Color
//
//    // MARK:
//
//    var body: some View {
//        Button(action: {}, label: {
//            Text("The Solid")
//                .foregroundColor(Color.black)
//                .background(backgroundColor)
//                .padding()
//        })
//
//        .background(
//            Capsule(style: .circular)
//                .fill(backgroundColor)
//        )
//    }
//}
//
//struct CapsuleButtonFilled_Previews: PreviewProvider {
//    static var previews: some View {
//        CapsuleButtonFilled(backgroundColor: .orange)
//            .previewLayout(.sizeThatFits)
//    }
//}


//class Card: ObservableObject, Identifiable, Hashable {
//    let id = UUID()
//    @Published var name: String
//
//    init(name: String) {
//        self.name = name
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    static func ==(lhs: Card, rhs: Card) -> Bool {
//        return lhs.id == rhs.id
//    }
//}

//struct ContentView: View {
//    @State var cards = [
//        Card(name: "Apple"),
//        Card(name: "Banana "),
//        Card(name: "Coupon"),
//        Card(name: "Dog"),
//        Card(name: "Eat")
//    ]
//
//    var body: some View {
//        VStack {
//            ScrollView(.horizontal) {
//                ScrollViewReader { proxy in
//                    HStack {
//
//                        ForEach(Array(cards.enumerated()), id: \.1) { (index, card) in
//                            CardView(
//                                card: cards[index],
//                                scrollToEndPressed: {
//                                    proxy.scrollTo(cards.count - 1, anchor: .center)
//                                },
//                                removePressed: {
//
//                                    withAnimation(.easeOut) {
//                                        _ = cards.remove(at: index) /// remove the card
//                                    }
//
//                                }
//                            )
//                            .transition(.scale)
//                        }
//
//                    }
//                }
//            }
//        }
//    }
//}



//
//struct ContentView: View {
//    @State var cards = [
//        Card(name: "Apple"),
//        Card(name: "Banana "),
//        Card(name: "Coupon"),
//        Card(name: "Dog"),
//        Card(name: "Eat")
//    ]
//
//    var body: some View {
//        VStack {
//            ScrollView(.horizontal) {
//                ScrollViewReader { proxy in
//                    HStack {
//
//                        ForEach(Array(cards.enumerated()), id: \.1) { (index, card) in
//                            CardView(card: cards[index], scrollToEndPressed: {
//                                
//                                withAnimation(.easeOut) {
//                                    proxy.scrollTo(cards.last?.id ?? card.id, anchor: .center) /// scroll to the last card's ID
//                                }
//                                
//                            }, removePressed: {
//                                
//                                withAnimation(.easeOut) {
//                                    _ = cards.remove(at: index) /// remove the card
//                                }
//
//                            })
//                            .id(card.id) /// add ID
//                            .transition(.scale)
//                        }
//
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct CardView: View {
//    
//    @ObservedObject var card: Card
//    var scrollToEndPressed: (() -> Void)?
//    var removePressed: (() -> Void)?
//    
//    var body: some View {
//        VStack {
//            Button(action: {
//                scrollToEndPressed?() /// call the remove closure
//            }) {
//                VStack {
//                    Text("Scroll to end")
//                }
//            }
//            
//            Button(action: {
//                removePressed?() /// call the remove closure
//            }) {
//                VStack {
//                    Text("Remove")
//                    Text(card.name)
//                }
//            }
//            .foregroundColor(Color.white)
//            .font(.system(size: 24, weight: .medium))
//            .padding(40)
//            .background(Color.red)
//        }
//    }
//}
