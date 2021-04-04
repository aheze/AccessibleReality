//
//  ContentView.swift
//  InterfaceSwiftUI
//
//  Created by Zheng on 4/3/21.
//

import SwiftUI

struct CardsView: View {
    var body: some View {
        CardView()
            .frame(width: 300, height: 400)
    }
}

struct CardView: View {
    @State var color = Color.blue
    
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
    
    
    @State private var selectedSound = Sound(name: "Select a sound")
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                
            }) {
                Text("Add")
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    .padding(.horizontal, 16)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Pencil")
                        .foregroundColor(Color.white)
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                    
                    Spacer()
                }
                
                .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                
                
                HStack {
                    Text("Color")
                        .foregroundColor(.white)
                    
                    
                    Spacer()
                    
                    ColorPicker("Set the background color", selection: $color)
                        .labelsHidden()
                        .scaleEffect(x: 1.2, y: 1.2)
                        .offset(x: -2, y: 0)
                    
                }
                .padding(16)
                .background(Color(#colorLiteral(red: 0.3725216476, green: 0.6794671474, blue: 0.1888703918, alpha: 1)))
                .cornerRadius(12)
                .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                
                
                HStack {
                    Text("Sound")
                        .foregroundColor(.white)
                    
                    Spacer()
                    Picker(selectedSound.name, selection: $selectedSound) {
                        ForEach(sounds, id: \.self) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(Color.white.opacity(0.8))
                    
                }
                .padding(16)
                .background(Color(#colorLiteral(red: 0.3725216476, green: 0.6794671474, blue: 0.1888703918, alpha: 1)))
                .cornerRadius(12)
                .padding(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
            .cornerRadius(16)
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
            
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
