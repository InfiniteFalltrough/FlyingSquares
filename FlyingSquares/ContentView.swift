//
//  ContentView.swift
//  FlyingSquares
//
//  Created by Viktor Golubenkov on 23.03.2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var scene: SKScene {
        let scene = SceneConstructor()
        scene.size = CGSize(width: width, height: height)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene, options: .allowsTransparency)
            Text("Hello World!")
        }
    }
}
