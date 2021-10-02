//
//  ContentView.swift
//  Shared
//
//  Created by Adrian Böhme on 25.09.21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Schallplatte(vinylColor: Color(red: 0.49, green: 0, blue: 0, opacity: 1), imgUrl: "https://images-na.ssl-images-amazon.com/images/I/71GtacY5FQL._SL1400_.jpg", gradationIntensity: .strong, showCenter: false)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
