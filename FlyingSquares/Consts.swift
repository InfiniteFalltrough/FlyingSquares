//
//  Consts.swift
//  FlyingSquares
//
//  Created by Viktor Golubenkov on 23.03.2022.
//

import SwiftUI

// screen size
let width: CGFloat = UIScreen.main.bounds.width
let height: CGFloat = UIScreen.main.bounds.height

//random X/Y
func randomIntX() -> Int {
    let randomX = Int.random(in: -15..<15)
    return randomX
}
func randomIntY() -> Int {
    let randomY = Int.random(in: -15..<15)
    return randomY
}

