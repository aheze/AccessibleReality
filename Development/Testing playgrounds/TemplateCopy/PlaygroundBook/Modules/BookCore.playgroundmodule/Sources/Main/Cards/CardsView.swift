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
    
    /// if user edited the textfield
    var customizedName = false
    
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


struct CardsView: View {
    
    @State var selectedCard: Card?
    @State var cards = [
        Card(name: "Object", color: .green, sound: Sound(name: "Select a sound"))
    ]
    
    var cardChanged: ((Card) -> Void)?
    var cardSelected: ((Card) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                LazyHStack(spacing: 20) {
                    ForEach(Array(cards.enumerated()), id: \.1) { (index, card) in
                        CardView(selectedCard: $selectedCard, card: card, addPressed: {
                            
                            withAnimation(.easeOut) {
                                
                                let newCard = Card(name: "Object", color: card.color, sound: Sound(name: "Select a sound"))
                                
                                /// keep the same color for now
                                cards.append(newCard)
                                selectedCard = newCard
                                
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    proxy.scrollTo(cards.last?.id ?? card.id, anchor: .center)
                                }
                            }
                            
                            cardChanged?(card)
                        }, removePressed: {
                            
                            /// scroll to nearest index
                            var newIndex = index
                            if index == cards.indices.last {
                                newIndex = index - 1
                            }
                            
                            _ = cards.remove(at: index)
                            
                            /// refocus if deleted selected card
                            if selectedCard == card {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        proxy.scrollTo(cards[newIndex].id, anchor: .center)
                                    }
                                }
                                selectedCard = cards[newIndex]
                            }
                            
                            cardChanged?(card)
                        }, selected: {
                            
                            withAnimation {
                                proxy.scrollTo(card.id, anchor: .center)
                            }
                            
                            selectedCard = card
                            cardSelected?(card)
                        })
                        .id(card.id)
                        .frame(width: Constants.cardWidth, height: Constants.cardContainerHeight)
                        .offset(x: 0, y: selectedCard == card ? -20 : 0)
                        .brightness(selectedCard == card ? 0 : -0.4)
                    }
                }
                .padding(.horizontal, (UIScreen.main.bounds.width - Constants.cardWidth) / 2)
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            selectedCard = cards.last
        }
        
    }
    
    func updateCardName(name: String) {
        print("cards... \(cards) name \(name)")
        
        /// only update name if not customized
        if !(cards.last?.customizedName ?? false) {
            cards.last?.name = name
        }
    }
}

struct CardView: View {
    
    var sounds = [
        Sound(name: "Chimes"),
        Sound(name: "Waves"),
        Sound(name: "Notes"),
        Sound(name: "Danger"),
        Sound(name: "Danger 2"),
        Sound(name: "J. S. Bach"),
        Sound(name: "Frédéric Chopin"),
        Sound(name: "R. Nathaniel Dett"),
        Sound(name: "Memento")
        
    ]
    
    @Binding var selectedCard: Card?
    @ObservedObject var card: Card
    
    var addPressed: (() -> Void)?
    var removePressed: (() -> Void)?
    var selected: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                card.added.toggle()
                
                if card.added {
                    addPressed?()
                } else {
                    removePressed?()
                }
            }) {
                Text(card.added ? "Remove" : "Add")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(card.added ? Color.red : Color.green)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    .padding(.horizontal, 16)
            }
            
            ZStack {
                Button(action: {
                    selected?() /// selected this card
                }) {
                    Color.clear
                }
                .buttonStyle(CardButtonStyle())
                
                VStack(alignment: .leading, spacing: 0) {
                    TextField("Textfield", text: $card.name) { _ in
                        
                        /// started editing
                        card.customizedName = true
                    }
                    .foregroundColor(Color.white)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    
                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    
                    HStack {
                        Text("Color")
                            .foregroundColor(.white)
                        
                        
                        Spacer()
                        
                        ColorPicker("Set the background color", selection: $card.color)
                            .labelsHidden()
                            .scaleEffect(x: 1.2, y: 1.2)
                            .offset(x: -2, y: 0)
                        
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
                        
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                
                /// add button to entire card to make active
                if selectedCard != card {
                    Button(action: {
                        selected?() /// selected this card
                    }) {
                        Color.clear
                    }
                }
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .bottom)))
        .animation(.easeOut)
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
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
