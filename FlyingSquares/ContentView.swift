//
//  ContentView.swift
//  FlyingSquares
//
//  Created by Viktor Golubenkov on 23.03.2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    // MARK: - Computed Properties
    private var scene: SKScene {
        let scene = SceneConstructor()
        scene.size = CGSize(
            width: Consts.screenWidth, 
            height: Consts.screenHeight
        )
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        return scene
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            SpriteView(
                scene: scene, 
                options: [.allowsTransparency]
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Flying Squares")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                Text("Tilt your device to control gravity")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(radius: 1)
            }
            .padding(.bottom, 50)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
