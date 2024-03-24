//
//  ImmersiveView.swift
//  HandTest
//
//  Created by 围发生 on 2024/3/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

let diceMap = [
// +:-
    [5,1],//x
    [4,2],//y
    [3,6]//z
]
struct ImmersiveView: View {
    @State var droppedDice:Bool=false
    var diceData:DiceData
    var body: some View {
        RealityView { content in

            let floor=ModelEntity(mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                massProperties: .default,
                mode: .static
            ))
//            floor.position = SIMD3<Float>(x: 0, y: 0, z: 0)
            content.add(floor)
            
     
//              content.add(dice)
            if let diceModel=try?await Entity(named: "diceModel"),
               let dice1=diceModel.children.first?.children.first,
                  let dice2=dice1.children.first?.children.first,
                     let dice = dice2.children.first?.children.first{

                dice.scale=[0.1,0.1,0.1]
                dice.position.y = 0.5
                dice.position.z = -1
                
                
                dice.generateCollisionShapes(recursive: false)
                dice.components.set(InputTargetComponent())
                dice.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                    massProperties: .default,
                    material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.1),
                    mode: .dynamic
                ))
                dice.components.set(GroundingShadowComponent(castsShadow: true))
                dice.components[PhysicsMotionComponent.self] = .init()
                content.add(dice)
                
                let _=content.subscribe(to: SceneEvents.Update.self){ event in
                    guard droppedDice else {return}
                    guard let diceMotion = dice.components[PhysicsMotionComponent.self] else {return}
                    
                    if simd_length(diceMotion.linearVelocity) < 0.1 && simd_length(diceMotion.angularVelocity) < 0.1 {
                        let xDirection=dice.convert(direction: SIMD3(x: 1,y: 0,z: 0), to: nil)
                        let yDirection=dice.convert(direction: SIMD3(x: 0,y: 1,z: 0), to: nil)
                        let zDirection=dice.convert(direction: SIMD3(x: 0,y: 0,z: 1), to: nil)
                        
//                        print("x:",xDirection.y)
//                        print("y:",yDirection.y)
//                        print("z:",zDirection.y)
                        let greatestDirection = [
                            0:xDirection.y,
                            1:yDirection.y,
                            2:zDirection.y,
                        ]
                            .sorted(by:{abs($0.1)>abs($1.1)})[0]
                        diceData.rolledNumber=diceMap[greatestDirection.key][greatestDirection.value>0 ? 0:1]
                    }
                }
            }
        
        }.gesture(dragGesture)
        
        
    }
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                //print("start gesture")
                value.entity.position = value.convert(value.location3D,from:.local,to:value.entity.parent!)
                value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
            }
            .onEnded { value in
                //print("end drag")
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
                if !droppedDice {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                        droppedDice = true
                    }
                }
            }
    }
    
}
//#Preview {
//        ImmersiveView()
//            .previewLayout(.sizeThatFits)
//    }

