//
//  CardsView.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import SwiftUI

class Card: ObservableObject, Identifiable, Hashable {
    let id = UUID()
    
    @Published var added = false
    
    @Published var name: String
    @Published var color: Color
    @Published var sound: Sound
    var marker: Marker?
    
    
    init(name: String, color: Color, sound: Sound) {
        self.name = name
        self.color = color
        self.sound = sound
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}

class CardsViewModel: ObservableObject {
    
    @Published var safeAreaWidth = CGFloat(500)
    @Published var selectedCard: Card?
    @Published var cards = [
        Card(name: "Object", color: .green, sound: Sound(name: "None", filename: ""))
    ]
}

struct CardsView: View {
    
    @ObservedObject var cvm: CardsViewModel
    
    var cardAdded: ((Card) -> Bool)? /// Bool is false if didn't succeed
    var cardRemoved: ((Card) -> Void)?
    var cardSelected: ((Card) -> Void)?
    var soundChanged: ((Card) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                LazyHStack(spacing: 20) {
                    ForEach(Array(cvm.cards.enumerated()), id: \.1) { (index, card) in
                        CardView(selectedCard: $cvm.selectedCard, card: card, addPressed: {
                            
                            if cardAdded?(card) ?? false {
                                let newCard = Card(name: "Object", color: card.color, sound: Sound(name: "None"))
                                cvm.cards.append(newCard)
                                return true
                            }
                            return false
                            
                        }, removePressed: {
                            
                            /// scroll to nearest index
                            var newIndex = index
                            if index == cvm.cards.indices.last {
                                newIndex = index - 1
                            }
                            
                            _ = cvm.cards.remove(at: index)
                            
                            /// refocus if deleted selected card
                            if cvm.selectedCard == card {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        proxy.scrollTo(cvm.cards[newIndex].id, anchor: .center)
                                    }
                                }
                                cvm.selectedCard = cvm.cards[newIndex]
                            }
                            
                            cardRemoved?(card)
                        }, selected: {
                            
                            withAnimation {
                                proxy.scrollTo(card.id, anchor: .center)
                            }
                            
                            cvm.selectedCard = card
                            cardSelected?(card)
                        }, soundChanged: {
                            soundChanged?(card)
                        })
                        .id(card.id)
                        .frame(width: Constants.cardWidth, height: Constants.cardContainerHeight)
                        .offset(x: 0, y: cvm.selectedCard == card ? -20 : 0)
                        .brightness(cvm.selectedCard == card ? 0 : -0.4)
                    }
                }
                .padding(.horizontal, (cvm.safeAreaWidth - Constants.cardWidth) / 2)
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            cvm.selectedCard = cvm.cards.last
        }
    }
}

struct CardView: View {
    
    var sounds = [
        Sound(name: "None"),
        Sound(name: "Calm", filename: "Calm.mp3"),
        Sound(name: "Electro", filename: "Electro.mp3"),
        Sound(name: "Danger", filename: "Danger.mp3"),
        Sound(name: "Chill", filename: "Chill.mp3"),
        Sound(name: "Tea", filename: "Tea.mp3"),
        Sound(name: "Dubs", filename: "Dubs.mp3"),
        Sound(name: "Dance", filename: "Dance.mp3")
    ]
    
    @Binding var selectedCard: Card?
    @ObservedObject var card: Card
    
    var addPressed: (() -> Bool)?
    var removePressed: (() -> Void)?
    var selected: (() -> Void)?
    var soundChanged: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            let _ = Global.configurationChanged?()
            
            Button(action: {
                if card.added == false {
                    if addPressed?() ?? false {
                        card.added = true
                    }
                } else {
                    removePressed?()
                    card.added = false
                }
            }) {
                Text(card.added ? "Remove" : "Hit-Test")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(card.added ? Color.red : Color.green)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    .padding(.horizontal, 16)
            }
            .accessibility(hint: Text("\(card.added ? "Remove" : "Hit-Test and add") this node and its configuration card"))
            
            
            ZStack {
                Button(action: {
                    selected?() /// selected this card
                }) {
                    Color.clear
                }
                .buttonStyle(CardButtonStyle())
                .accessibility(label: Text("Configuration card"))
                .accessibility(hint: Text("Options for the node to be added"))
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(card.name)
                    .foregroundColor(Color.white)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    
                    HStack {
                        Text("Color")
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        ColorPicker("Node color", selection: $card.color)
                            .labelsHidden()
                            .scaleEffect(x: 1.2, y: 1.2)
                            .offset(x: -2, y: 0)
                            .accessibility(label: Text("Color picker"))
                            .accessibility(hint: Text("Color of the node"))
                        
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    
                    
                    HStack {
                        Text("Sound")
                            .foregroundColor(.white)
                        
                        Spacer()
                        Picker(card.sound.name, selection: $card.sound) {
                            ForEach(sounds, id: \.self) {
                                Text($0.name)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color.white.opacity(0.8))
                        .accessibility(label: Text("Sound picker"))
                        .accessibility(hint: Text("Choose a sound that emits from the node"))
                        
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .accessibility(hidden: selectedCard != card)
                
                /// add button to entire card to make active
                if selectedCard != card {
                    Button(action: {
                        selected?() /// selected this card
                    }) {
                        Color.clear
                    }
                    .accessibility(label: Text("Configuration card. Named \(card.name), with color \(UIColor(card.color).hexString), and sound \(card.sound.name)"))
                    .accessibility(hint: Text("Double-tap to select"))
                }
            }
        }
        .onChange(of: card.sound, perform: { _ in
            print("card sound changed")
            soundChanged?()
        })
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .bottom)))
        .animation(.easeOut)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Color(configuration.isPressed ? #colorLiteral(red: 0, green: 0.4430488782, blue: 0.002534600552, alpha: 1) : #colorLiteral(red: 0, green: 0.553125, blue: 0.003164325652, alpha: 1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), lineWidth: 0.75)
            )
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
