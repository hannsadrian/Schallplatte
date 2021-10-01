//
//  SchallplatteGroove.swift
//  SchallplatteGroove
//
//  Created by Adrian Böhme on 25.09.21.
//

import SwiftUI

let white = Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.8)
let lightGray = Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 0.6)
let gray = Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3)
let darkGray = Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.6)
let black = Color(red: 0, green: 0, blue: 0, opacity: 0.8)

struct SchallplatteGroove: View {
    @State private var rotationAmount = 0.0
    
    @State private var vinylBody = [
        Color(red: 0.6, green: 0, blue: 0, opacity: 1), // 0.956 0.994 0.333
        Color(red: 0.45, green: 0.15, blue: 0.15, opacity: 1)
    ]
    @State private var outerGloss = [gray, darkGray, white, gray, darkGray, lightGray, white, darkGray, darkGray]
    @State private var grooves = [darkGray, gray, lightGray, gray, darkGray, white, darkGray, darkGray]
    @State private var shadow = Color(red: 0.6, green: 0, blue: 0, opacity: 0.7)
    
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
            
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: outerGloss),
                        center: .center,
                        angle: .degrees(86)),
                    lineWidth: 1
                )
                .frame(width: 498, height: 498)
            Spiral(innerRadius: 40.0, outerRadius: 190.0, offset: rotationAmount)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: grooves),
                        center: .center,
                        angle: .degrees(0)),
                    style: StrokeStyle(lineWidth: 1)
                )
                .frame(width: 150, height: 150)
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
            
        }
            .scaleEffect(0.65)
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    self.rotationAmount += 360
                }
            }
    }
}

struct Spiral: Shape {
    let innerRadius: Double
    let outerRadius: Double
    var offset: Double
    
    //var animatableData: CGFloat {
    //        get { offset }
    //    set { offset = (3.14/360)*newValue }
    //    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let a = 1.314
        
        for theta in stride(from: innerRadius, through: outerRadius, by: 0.01) {
            var x = a*theta*cos(theta+offset)
            var y = a*theta*sin(theta+offset)
            
            x += rect.width.native / 2
            y += rect.height.native / 2
            
            if theta == innerRadius {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}
