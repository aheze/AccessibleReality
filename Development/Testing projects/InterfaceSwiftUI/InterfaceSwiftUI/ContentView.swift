//
//  ContentView.swift
//  InterfaceSwiftUI
//
//  Created by Zheng on 4/3/21.
//

import SwiftUI

//class Card: ObservableObject, Identifiable {
//    let id = UUID()
//    
//    @Published var added = false
//    @Published var name: String
//    @Published var color: Color
//    @Published var sound: Sound
//    
//    init(name: String, color: Color, sound: Sound) {
//        self.name = name
//        self.color = color
//        self.sound = sound
//    }
//}
//
//
//struct CardsView: View {
//    @State var cards = [
//        Card(name: "Object", color: .green, sound: Sound(name: "Select a sound")),
//    ]
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            ScrollViewReader { proxy in
//                HStack {
//                    ForEach(cards.indices, id: \.self) { index in
//                        CardView(card: cards[index], addPressed: {
//                            withAnimation(.easeOut) {
//                            cards.append(Card(name: "Object", color: .green, sound: Sound(name: "Select a sound")))
//                            }
//                            
//                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                withAnimation {
//                                    proxy.scrollTo(cards.count - 1, anchor: .center)
//                                }
//                            }
//                        }, removePressed: {
//                            withAnimation(.easeOut) {
//                                _ = cards.remove(at: index)
//                            }
//                        })
//                        .frame(width: 300, height: 400)
//                    }
//                }
//                .padding(.horizontal, 20)
//            }
//        }
//    }
//}
//
//struct CardView: View {
//    
//    var sounds = [
//        Sound(name: "Chimes"),
//        Sound(name: "Waves"),
//        Sound(name: "Notes"),
//        Sound(name: "Danger"),
//        Sound(name: "Danger 2"),
//        Sound(name: "J. S. Bach"),
//        Sound(name: "Frédéric Chopin"),
//        Sound(name: "R. Nathaniel Dett"),
//        Sound(name: "Memento")
//    
//    ]
//    
//    @ObservedObject var card: Card
//    
//    var addPressed: (() -> Void)?
//    var removePressed: (() -> Void)?
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            Button(action: {
//                print("press.")
//                card.added.toggle()
//                
//                if card.added {
//                    addPressed?()
//                } else {
//                    removePressed?()
//                }
//            }) {
//                Text(card.added ? "Remove" : "Add")
//                    .foregroundColor(Color.white)
//                    .font(.system(size: 18, weight: .semibold))
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 10)
//                    .background(card.added ? Color.red : Color.green)
//                    .cornerRadius(12, corners: [.topLeft, .topRight])
//                    .padding(.horizontal, 16)
//            }
//            
//            VStack(alignment: .leading, spacing: 0) {
//                TextField("Textfield", text: $card.name)
//                    .foregroundColor(Color.white)
//                    .font(.system(size: 32, weight: .semibold, design: .rounded))
//                    
//                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
//                
//                
//                HStack {
//                    Text("Color")
//                        .foregroundColor(.white)
//                    
//                    
//                    Spacer()
//                    
//                    ColorPicker("Set the background color", selection: $card.color)
//                        .labelsHidden()
//                        .scaleEffect(x: 1.2, y: 1.2)
//                        .offset(x: -2, y: 0)
//                    
//                }
//                .padding(16)
//                .background(Color(#colorLiteral(red: 0.3725216476, green: 0.6794671474, blue: 0.1888703918, alpha: 1)))
//                .cornerRadius(12)
//                .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
//                
//                
//                HStack {
//                    Text("Sound")
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                    Picker(card.sound.name, selection: $card.sound) {
//                        ForEach(sounds, id: \.self) {
//                            Text($0.name)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    .foregroundColor(Color.white.opacity(0.8))
//                    
//                }
//                .padding(16)
//                .background(Color(#colorLiteral(red: 0.3725216476, green: 0.6794671474, blue: 0.1888703918, alpha: 1)))
//                .cornerRadius(12)
//                .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
//                
//            }
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 16)
//            .background(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
//            .cornerRadius(16)
//        }
//        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .bottom)))
//    }
//}
//
//struct CardsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardsView()
//            
//    }
//}
//
//
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape( RoundedCorner(radius: radius, corners: corners) )
//    }
//}
//struct RoundedCorner: Shape {
//
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
