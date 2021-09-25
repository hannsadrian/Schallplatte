//
//  Schallplatte.swift
//  Schallplatte
//
//  Created by Adrian Böhme on 25.09.21.
//

import SwiftUI

let darkGray = Color(.sRGB, red: 0.15, green: 0.15, blue: 0.15, opacity: 1)
let lightGray = Color(.sRGB, red: 0.85, green: 0.85, blue: 0.85, opacity: 1)

let blackVinyl = RadialGradient(
    gradient: Gradient(
        colors: [
            Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 1),
            Color(.sRGB, red: 0.15, green: 0.15, blue: 0.15, opacity: 1)
        ]
    ),
    center: .center,
    startRadius: 1,
    endRadius: 500
)
let whiteVinyl = RadialGradient(
    gradient: Gradient(
        colors: [
            Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1),
            Color(.sRGB, red: 0.95, green: 0.95, blue: 0.95, opacity: 1)
        ]
    ),
    center: .center,
    startRadius: 1,
    endRadius: 500
)

let blackVinylTracks = AngularGradient(
    gradient: Gradient(colors: [darkGray, .gray, .gray, darkGray, darkGray, .white, darkGray, darkGray]),
    center: .center,
    angle: .degrees(0))
let whiteVinylTracks = AngularGradient(
    gradient: Gradient(colors: [lightGray, .gray, .gray, lightGray, lightGray, .gray, lightGray, lightGray]),
    center: .center,
    angle: .degrees(0))

let blackVinylOutline = AngularGradient(
    gradient: Gradient(colors: [.gray, darkGray, .white, .gray, darkGray, darkGray, .gray, darkGray, darkGray]),
    center: .center,
    angle: .degrees(86))
let whiteVinylOutline = AngularGradient(
    gradient: Gradient(colors: [.gray, lightGray, .white, lightGray, lightGray, lightGray, lightGray, lightGray, lightGray]),
    center: .center,
    angle: .degrees(86))

struct Schallplatte: View {
    @State private var rotationAmount = 0.0
    
    @State private var vinyl = blackVinyl
    @State private var tracks = blackVinylTracks
    @State private var outline = blackVinylOutline
    @State private var shadow = darkGray
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    vinyl
                )
                .frame(width: 500, height: 500)
                .shadow(color: shadow, radius: 8, x: 0, y: 5)
            
            Circle()
                .stroke(
                    outline,
                    lineWidth: 1
                )
                .frame(width: 498, height: 498)
            Spiral(innerRadius: 40.0, outerRadius: 190.0)
                .stroke(
                    tracks,
                    style: StrokeStyle(lineWidth: 1)
                )
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(rotationAmount))
            Circle()
                .fill(Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1))
                .frame(width: 150, height: 150)
                .overlay(
                    AsyncImage(url: URL(string: "https://media1.jpc.de/image/w600/front/0/0884108001349.jpg"))
                    { image in
                        if (image.image != nil) {
                            image.image!.resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(maxWidth: 150, maxHeight: 150)
                                 .cornerRadius(.greatestFiniteMagnitude)
                                 
                        }
                    }.rotationEffect(.degrees(self.rotationAmount))
                )
            
        }
            .scaleEffect(0.65)
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    //self.rotationAmount += 360
                }
            }
    }
}

struct Spiral: Shape {
    let innerRadius: Double
    let outerRadius: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let a = 1.2
        
        for theta in stride(from: innerRadius, through: outerRadius, by: 0.01) {
            
            var r = 1.5
            var x = pow(a, r)*theta*cos(theta)
            var y = pow(a, r)*theta*sin(theta)
            
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
