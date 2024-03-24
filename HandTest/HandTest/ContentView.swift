//
//  ContentView.swift
//  HandTest
//
//  Created by 围发生 on 2024/3/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var diceData:DiceData
    @State private var enlarge = false
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
   
            Text(diceData.rolledNumber>0 ? "\(diceData.rolledNumber)" : "🎲")
                .font(.custom("Menlo", size: 80))
                .bold()

        }
        .task {
              
            await openImmersiveSpace(id:"ImmersiveSpace")
     }
        
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView(diceData:DiceData())
}
