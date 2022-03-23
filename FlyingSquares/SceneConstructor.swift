//
//  SceneConstructor.swift
//  FlyingSquares
//
//  Created by Viktor Golubenkov on 23.03.2022.
//

import SwiftUI
import SpriteKit
import CoreMotion

class SceneConstructor: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    var timer = Timer()
    var nodes =
    [
        SKSpriteNode(imageNamed: "codercat"),
        SKSpriteNode(imageNamed: "codercat"),
        SKSpriteNode(imageNamed: "codercat"),
        SKSpriteNode(imageNamed: "codercat")
    ]
    
    // Collision categories
    let firstCollisionCategory: UInt32 = 1 << 0
    let edgeCollisionCategory: UInt32 = 1 << 31
    
    func setupNodes() {
        for n in nodes {
            n.size = CGSize(width: 75, height: 75)
        }
    }
    // Collisions
    func setUpCollisions() {
        //Assign our category bit masks to our physics bodies
        for n in nodes {
            n.physicsBody?.categoryBitMask = firstCollisionCategory
            n.physicsBody?.collisionBitMask = edgeCollisionCategory ^ firstCollisionCategory
        }
        physicsBody?.categoryBitMask = edgeCollisionCategory
        if nodes.count == 4 {
            nodes[0].physicsBody?.contactTestBitMask = nodes[1].physicsBody!.collisionBitMask
            nodes[1].physicsBody?.contactTestBitMask = nodes[2].physicsBody!.collisionBitMask
            nodes[2].physicsBody?.contactTestBitMask = nodes[3].physicsBody!.collisionBitMask
            nodes[3].physicsBody?.contactTestBitMask = nodes[0].physicsBody!.collisionBitMask
        }
        //Set ourselves as the contact delegate
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case firstCollisionCategory | edgeCollisionCategory:
            let node = contact.bodyA.categoryBitMask == firstCollisionCategory ? contact.bodyA.node : contact.bodyB.node
            node?.physicsBody?.applyImpulse(CGVector(dx: randomIntX(), dy: randomIntY()))
//            print("firstCollisionCategory | edgeCollisionCategory - contact")
        case firstCollisionCategory | firstCollisionCategory:
            let node = contact.bodyA.categoryBitMask == firstCollisionCategory ? contact.bodyA.node : contact.bodyB.node
            node?.physicsBody?.applyImpulse(CGVector(dx: randomIntX(), dy: randomIntY()))
//            print("firstCollisionCategory | firstCollisionCategory - contact")
        default:
            print("Some other contact occurred")
        }
    }
    
    override func didMove(to view: SKView) {
        self.setupNodes()
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.mass = 0.7
        
        nodes.forEach { n in
            if nodes.count == 4 {
                nodes[0].position = CGPoint(x: width / 2.9, y: height / 1.05);
                nodes[1].position = CGPoint(x: width / 1.13, y: height / 1.21);
                nodes[2].position = CGPoint(x: width / 2.75, y: height / 1.55);
                nodes[3].position = CGPoint(x: width / 1.30, y: height / 4.5)
            }
            self.addChild(n)
        }
        view.clipsToBounds = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            for n in self.nodes {
                n.physicsBody = SKPhysicsBody(circleOfRadius: width / 10)
            }
            self.motionManager.gyroUpdateInterval = 0.1 / 60
            self.motionManager.startGyroUpdates()
            self.physicsWorld.speed = 1
            
            self.nodes.forEach { n in
                if self.nodes.count == 3 {
                    self.nodes[0].physicsBody?.applyImpulse(CGVector(dx: 5, dy: 10));
                    self.nodes[1].physicsBody?.applyImpulse(CGVector(dx: 8, dy: -4));
                    self.nodes[2].physicsBody?.applyImpulse(CGVector(dx: -7, dy: 2))
                }
            }
            self.setUpCollisions()
        }
        self.startForcePush()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let gyroData = motionManager.gyroData {
            physicsWorld.gravity = CGVector(dx: gyroData.rotationRate.x, dy: gyroData.rotationRate.y)
        }
    }
    
    func startForcePush() {
        _ = Timer.scheduledTimer(timeInterval: 7.5, target: self, selector: #selector(self.forcePush), userInfo: nil , repeats: true)
    }
    
    @objc func forcePush() {
        for n in nodes {
            n.physicsBody?.applyImpulse(CGVector(dx: randomIntX(), dy: randomIntY()))
        }
        //        self.timer.invalidate()
    }
}
