//
//  Schallplatte.swift
//  Schallplatte
//
//  Created by Adrian Böhme on 26.09.21.
//

import SwiftUI

let noColor = Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 0)
let highlight = Color(red: 1, green: 1, blue: 1, opacity: 0.1)
let lowlight = Color(red: 1, green: 1, blue: 1, opacity: 0.05)

struct Schallplatte: View {
    @State private var rotationAmount = 0.0
    
    @State private var vinylBody = [
        Color(red: 0, green: 0, blue: 0, opacity: 1),
        Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 1)
    ]
    @State private var shadow = Color(red: 0, green: 0, blue: 0, opacity: 0.7)
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(
                            colors: vinylBody
                        ),
                        center: .center,
                        startRadius: 1,
                        endRadius: 500
                    )
                )
                .frame(width: 500, height: 500)
                .shadow(color: shadow, radius: 40, x: 0, y: 20)
            
            Group {
                Circle()
                    .stroke(lineWidth: 40)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 0.3))
                    .frame(width: 200, height: 200)
                Circle()
                    .stroke(lineWidth: 50)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 0.6))
                    .frame(width: 290, height: 290)
                Circle()
                    .stroke(lineWidth: 20)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 0.5))
                    .frame(width: 360, height: 360)
                Circle()
                    .stroke(lineWidth: 10)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 0.7))
                    .frame(width: 390, height: 390)
                Circle()
                    .stroke(lineWidth: 40)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 0.55))
                    .frame(width: 440, height: 440)
            }
            
            // song breaks
            Group {
                Circle()
                    .stroke(lineWidth: 0.5)
                    .fill(Color(red: 0.05, green: 0.05, blue: 0.05, opacity: 1))
                    .frame(width: 280, height: 280)
                Circle()
                    .stroke(lineWidth: 0.5)
                    .fill(Color(red: 0.05, green: 0.05, blue: 0.05, opacity: 1))
                    .frame(width: 340, height: 340)
                Circle()
                    .stroke(lineWidth: 0.5)
                    .fill(Color(red: 0.05, green: 0.05, blue: 0.05, opacity: 1))
                    .frame(width: 380, height: 380)
                Circle()
                    .stroke(lineWidth: 0.5)
                    .fill(Color(red: 0.05, green: 0.05, blue: 0.05, opacity: 1))
                    .frame(width: 440, height: 440)
            }
            
            Circle()
                .fill(AngularGradient(colors: [noColor, noColor, highlight, noColor, noColor, noColor, lowlight, noColor, noColor], center: .center, angle: .degrees(130)))
            
            Circle()
                .fill(Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                .frame(width: 159, height: 159)
                .overlay(
                    AsyncImage(url: URL(string: "https://images-na.ssl-images-amazon.com/images/I/71GtacY5FQL._SL1400_.jpg"))
                    { image in
                        if (image.image != nil) {
                            image.image!.resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(maxWidth: 160, maxHeight: 160)
                                 .cornerRadius(.greatestFiniteMagnitude)
                                 
                        }
                    }.rotationEffect(.degrees(self.rotationAmount))
                )
            Circle()
                .fill(AngularGradient(colors: [noColor, Color(red: 1, green: 1, blue: 1, opacity: 0.1), noColor, Color(red: 1, green: 1, blue: 1, opacity: 0.05), noColor], center: .center, angle: .degrees(135)))
                .frame(width: 160, height: 160)
            
        }
            .scaleEffect(0.65)
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    self.rotationAmount += 360
                }
            }
    }
}

struct Schallplatte_Previews: PreviewProvider {
    static var previews: some View {
        Schallplatte()
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .previewDisplayName("Default preview")
    }
}
