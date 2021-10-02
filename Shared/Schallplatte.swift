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

struct PausableRotation: GeometryEffect {

    // this binding is used to inform the view about the current, system-computed angle value
    @Binding var currentAngle: CGFloat
    private var currentAngleValue: CGFloat = 0.0

    // this tells the system what property should it interpolate and update with the intermediate values it computed
    var animatableData: CGFloat {
        get { currentAngleValue }
        set { currentAngleValue = newValue }
    }

    init(desiredAngle: CGFloat, currentAngle: Binding<CGFloat>) {
        self.currentAngleValue = desiredAngle
        self._currentAngle = currentAngle
    }

    // this is the transform that defines the rotation
    func effectValue(size: CGSize) -> ProjectionTransform {

        // this is the heart of the solution:
        //   reporting the current (system-computed) angle value back to the view
        //
        // thanks to that the view knows the pause position of the animation
        // and where to start when the animation resumes
        //
        // notice that reporting MUST be done in the dispatch main async block to avoid modifying state during view update
        // (because currentAngle is a view state and each change on it will cause the update pass in the SwiftUI)
        DispatchQueue.main.async {
            self.currentAngle = currentAngleValue
        }

        // here I compute the transform itself
        let xOffset = size.width / 2
        let yOffset = size.height / 2
        let transform = CGAffineTransform(translationX: xOffset, y: yOffset)
                .rotated(by: currentAngleValue)
                .translatedBy(x: -xOffset, y: -yOffset)
        return ProjectionTransform(transform)
    }
}

struct Schallplatte: View {
    var vinylColor: Color
    var imgUrl: String
    var gradationIntensity: ColorModificationIntensity
    var showCenter: Bool
    var sections = 4

    @State private var rotationAmount = 0.0

    @State private var vinylBody = [
        Color(red: 0, green: 0, blue: 0, opacity: 1),
        Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 1)
    ]

    @State private var sectionColors: [Color] = []
    @State private var shadow = Color(red: 0, green: 0, blue: 0, opacity: 0.7)


    @State private var isRotating: Bool = false

    // this state keeps the final value of angle (aka value when animation finishes)
    @State private var desiredAngle: CGFloat = 0.0

    // this state keeps the current, intermediate value of angle (reported to the view by the GeometryEffect)
    @State private var currentAngle: CGFloat = 0.0

    var foreverAnimation: Animation {
        Animation.linear(duration: 2)
                .repeatForever(autoreverses: false)
    }


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
                        .fill(calculateGradation(color: UIColor(vinylColor), intensity: .strong, 0.35))
                        .frame(width: 200, height: 200)
                if (sectionColors.count >= sections) {
                    Circle()
                            .stroke(lineWidth: 50)
                            .fill(sectionColors[0])
                            .frame(width: 290, height: 290)
                    Circle()
                            .stroke(lineWidth: 20)
                            .fill(sectionColors[1])
                            .frame(width: 360, height: 360)
                    Circle()
                            .stroke(lineWidth: 10)
                            .fill(sectionColors[2])
                            .frame(width: 390, height: 390)
                    Circle()
                            .stroke(lineWidth: 40)
                            .fill(sectionColors[3])
                            .frame(width: 440, height: 440)
                }
            }

            // song breaks
            Group {
                Circle()
                        .stroke(lineWidth: 0.5)
                        .fill(calculateGradation(color: UIColor(vinylColor), intensity: .minimal))
                        .frame(width: 280, height: 280)
                Circle()
                        .stroke(lineWidth: 0.5)
                        .fill(calculateGradation(color: UIColor(vinylColor), intensity: .minimal))
                        .frame(width: 340, height: 340)
                Circle()
                        .stroke(lineWidth: 0.5)
                        .fill(calculateGradation(color: UIColor(vinylColor), intensity: .minimal))
                        .frame(width: 380, height: 380)
                Circle()
                        .stroke(lineWidth: 0.5)
                        .fill(calculateGradation(color: UIColor(vinylColor), intensity: .minimal))
                        .frame(width: 440, height: 440)
            }

            Circle()
                    .fill(AngularGradient(colors: [noColor, noColor, highlight, noColor, noColor, noColor, lowlight, noColor, noColor], center: .center, angle: .degrees(130)))

            Circle()
                    .fill(Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                    .frame(width: 159, height: 159)
                    .overlay(
                            AsyncImage(url: URL(string: imgUrl)) { image in
                                if (image.image != nil) {
                                    image.image!.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: 160, maxHeight: 160)
                                            .cornerRadius(.greatestFiniteMagnitude)

                                }
                            }.modifier(PausableRotation(desiredAngle: desiredAngle, currentAngle: $currentAngle))
                    )
            Circle()
                    .fill(AngularGradient(colors: [noColor, Color(red: 1, green: 1, blue: 1, opacity: 0.1), noColor, Color(red: 1, green: 1, blue: 1, opacity: 0.05), noColor], center: .center, angle: .degrees(135)))
                    .frame(width: 160, height: 160)

            if (showCenter) {
                Circle()
                        .strokeBorder(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 1), lineWidth: 1)
                        .background(Circle().fill(AngularGradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 1), Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1), Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 1), Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1), Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 1)], center: .center, angle: .degrees(-45))))
                        .frame(width: 15, height: 15)
            }

        }
                .scaleEffect(0.65)
                .onTapGesture {
                    self.isRotating.toggle()
                    // normalize the angle so that we're not in the tens or hundreds of radians
                    let startAngle = currentAngle //.truncatingRemainder(dividingBy: CGFloat.pi * 2)
                    // if rotating, the final value should be one full circle further
                    // if not rotating, the final value is just the current value
                    let angleDelta = isRotating ? CGFloat.pi * 2 : 0.0
                    withAnimation(isRotating ? foreverAnimation : .linear(duration: 0)) {
                        self.desiredAngle = startAngle + angleDelta
                    }
                }
                .onAppear {
                    vinylBody = []
                    vinylBody.append(vinylColor)
                    vinylBody.append(calculateGradation(color: UIColor(vinylColor), intensity: .strong))

                    for _ in 0...sections {
                        sectionColors.append(calculateGradation(color: UIColor(vinylColor), intensity: gradationIntensity, CGFloat.random(in: 0.45...0.75)))
                    }

                    shadow = calculateGradation(color: UIColor(vinylColor), intensity: .minimal, 0.7)
                }
    }
}

func calculateGradation(color: UIColor, intensity: ColorModificationIntensity, _ opacity: CGFloat = 1) -> Color {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    modifyColor(&red, intensity: intensity)
    modifyColor(&green, intensity: intensity)
    modifyColor(&blue, intensity: intensity)
    alpha = opacity


    return Color(red: red, green: green, blue: blue, opacity: alpha)
}

func modifyColor(_ value: UnsafeMutablePointer<CGFloat>, intensity: ColorModificationIntensity) {
    if (value.pointee > 0.5) {
        value.pointee = value.pointee - intensity.doubleValue
    } else {
        value.pointee = value.pointee + intensity.doubleValue
    }
}

enum ColorModificationIntensity: Int {
    case minimal
    case medium
    case semistrong
    case strong
    case heavy

    var doubleValue: Double {
        switch self {
        case .minimal: return 0.05
        case .medium: return 0.10
        case .semistrong: return 0.125
        case .strong: return 0.15
        case .heavy: return 0.20
        }
    }
}

struct Schallplatte_Previews: PreviewProvider {
    static var previews: some View {
        Schallplatte(vinylColor: Color(red: 0, green: 0, blue: 0, opacity: 1), imgUrl: "https://images-na.ssl-images-amazon.com/images/I/61%2Bn7EoDWHL._SL1200_.jpg", gradationIntensity: .strong, showCenter: true)
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Default preview")
    }
}
