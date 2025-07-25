//
//  SceneConstructor.swift
//  FlyingSquares
//
//  Created by Viktor Golubenkov on 23.03.2022.
//

import SwiftUI
import SpriteKit
import CoreMotion

// MARK: - Game Node Protocol
protocol GameNode {
    var spriteNode: SKSpriteNode { get }
    func setupPhysics()
    func applyRandomImpulse()
}

// MARK: - Flying Square Node
class FlyingSquareNode: GameNode {
    let spriteNode: SKSpriteNode
    
    init(imageName: String) {
        self.spriteNode = SKSpriteNode(imageNamed: imageName)
        setupNode()
    }
    
    private func setupNode() {
        spriteNode.size = Consts.Physics.nodeSize
        spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: Consts.Physics.physicsBodyRadius)
        setupPhysics()
    }
    
    func setupPhysics() {
        guard let physicsBody = spriteNode.physicsBody else { return }
        physicsBody.categoryBitMask = Consts.Collision.firstCategory
        physicsBody.collisionBitMask = Consts.Collision.edgeCategory | Consts.Collision.firstCategory
        physicsBody.contactTestBitMask = Consts.Collision.firstCategory
    }
    
    func applyRandomImpulse() {
        spriteNode.physicsBody?.applyImpulse(Consts.randomImpulse())
    }
}

// MARK: - Scene Constructor
class SceneConstructor: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    private var motionManager: CMMotionManager?
    private var forcePushTimer: Timer?
    private var gameNodes: [FlyingSquareNode] = []
    
    // MARK: - Initial Node Positions
    private let initialPositions: [CGPoint] = [
        CGPoint(x: Consts.screenWidth / 2.9, y: Consts.screenHeight / 1.05),
        CGPoint(x: Consts.screenWidth / 1.13, y: Consts.screenHeight / 1.21),
        CGPoint(x: Consts.screenWidth / 2.75, y: Consts.screenHeight / 1.55),
        CGPoint(x: Consts.screenWidth / 1.30, y: Consts.screenHeight / 4.5)
    ]
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        setupScene()
        setupNodes()
        setupPhysicsWorld()
        setupMotionManager()
        startForcePushTimer()
    }
    
    deinit {
        cleanup()
    }
    
    // MARK: - Setup Methods
    private func setupScene() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = Consts.Collision.edgeCategory
        physicsWorld.contactDelegate = self
        view?.clipsToBounds = true
    }
    
    private func setupNodes() {
        for _ in 0..<4 {
            let node = FlyingSquareNode(imageName: "codercat")
            gameNodes.append(node)
        }
        
        for (index, gameNode) in gameNodes.enumerated() {
            if index < initialPositions.count {
                gameNode.spriteNode.position = initialPositions[index]
            }
            addChild(gameNode.spriteNode)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Consts.Timing.initialDelay) { [weak self] in
            self?.applyInitialImpulses()
        }
    }
    
    private func setupPhysicsWorld() {
        physicsWorld.speed = 1.0
    }
    
    private func setupMotionManager() {
        motionManager = CMMotionManager()
        guard let motionManager = motionManager, motionManager.isGyroAvailable else {
            print("Gyroscope not available")
            return
        }
        
        motionManager.gyroUpdateInterval = Consts.Timing.gyroUpdateInterval
        motionManager.startGyroUpdates()
    }
    
    private func applyInitialImpulses() {
        let initialImpulses: [CGVector] = [
            CGVector(dx: 5, dy: 10),
            CGVector(dx: 8, dy: -4),
            CGVector(dx: -7, dy: 2),
            CGVector(dx: 3, dy: -8)
        ]
        
        for (index, gameNode) in gameNodes.enumerated() {
            if index < initialImpulses.count {
                gameNode.spriteNode.physicsBody?.applyImpulse(initialImpulses[index])
            }
        }
    }
    
    // MARK: - Timer Management
    private func startForcePushTimer() {
        forcePushTimer = Timer.scheduledTimer(
            timeInterval: Consts.Timing.forcePushInterval,
            target: self,
            selector: #selector(forcePush),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func forcePush() {
        gameNodes.forEach { $0.applyRandomImpulse() }
    }
    
    // MARK: - Update Loop
    override func update(_ currentTime: TimeInterval) {
        guard let motionManager = motionManager,
              let gyroData = motionManager.gyroData else { return }
        
        physicsWorld.gravity = CGVector(dx: gyroData.rotationRate.x, dy: gyroData.rotationRate.y)
    }
    
    // MARK: - Collision Handling
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case Consts.Collision.firstCategory | Consts.Collision.edgeCategory:
            handleEdgeCollision(contact)
        case Consts.Collision.firstCategory | Consts.Collision.firstCategory:
            handleNodeCollision(contact)
        default:
            print("Unknown collision occurred")
        }
    }
    
    private func handleEdgeCollision(_ contact: SKPhysicsContact) {
        let node = contact.bodyA.categoryBitMask == Consts.Collision.firstCategory 
            ? contact.bodyA.node 
            : contact.bodyB.node
        node?.physicsBody?.applyImpulse(Consts.randomImpulse())
    }
    
    private func handleNodeCollision(_ contact: SKPhysicsContact) {
        let node = contact.bodyA.categoryBitMask == Consts.Collision.firstCategory 
            ? contact.bodyA.node 
            : contact.bodyB.node
        node?.physicsBody?.applyImpulse(Consts.randomImpulse())
    }
    
    // MARK: - Cleanup
    private func cleanup() {
        motionManager?.stopGyroUpdates()
        motionManager = nil
        
        forcePushTimer?.invalidate()
        forcePushTimer = nil
    }
}
