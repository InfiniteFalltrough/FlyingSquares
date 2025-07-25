//
//  Consts.swift
//  FlyingSquares
//
//  Created by Viktor Golubenkov on 23.03.2022.
//

import SwiftUI

struct Consts {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    struct Physics {
        static let impulseRange: ClosedRange<Int> = -15...15
        static let nodeSize: CGSize = CGSize(width: 75, height: 75)
        static let physicsBodyRadius: CGFloat = screenWidth / 10
    }
    
    struct Timing {
        static let gyroUpdateInterval: TimeInterval = 0.1 / 60
        static let initialDelay: TimeInterval = 0.25
        static let forcePushInterval: TimeInterval = 7.5
    }
    
    struct Collision {
        static let firstCategory: UInt32 = 1 << 0
        static let edgeCategory: UInt32 = 1 << 31
    }
}

// MARK: - Random Generation
extension Consts {
    static func randomImpulse() -> CGVector {
        let x = Int.random(in: Physics.impulseRange)
        let y = Int.random(in: Physics.impulseRange)
        return CGVector(dx: x, dy: y)
    }
}

