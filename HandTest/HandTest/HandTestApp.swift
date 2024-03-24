//
//  HandTestApp.swift
//  HandTest
//
//  Created by 围发生 on 2024/3/23.
//

import SwiftUI

@Observable
class DiceData{
    var rolledNumber=0
}

@main
struct HandTestApp: App {
    var diceData:DiceData=DiceData()
    
    var body: some Scene {
        WindowGroup {
            ContentView(diceData: diceData)
        }.defaultSize(width: 100, height:100)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(diceData: diceData)
        }
    }
}
