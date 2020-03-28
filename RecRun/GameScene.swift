//
//  GameScene.swift
//  RecRun
//
//  Created by Jakub Iwaszek on 23/03/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var player = SKSpriteNode()
    var cam = SKCameraNode()
    var background = SKSpriteNode()
    var ground = SKSpriteNode()
    var spikes = SKSpriteNode()
    var flyingEnemy = SKSpriteNode()
    var checkpoints = SKSpriteNode()
    
    let playerCategory: UInt32 = 1 << 1
    let groundCategory: UInt32 = 1 << 2
    
    var grounded: Bool = true
    var hurt = false
    
    var animations = Animations(playerColor: "Blue")
    var walkAnimation: SKAction!
    var jumpAnimation: SKAction!
    
    var lastKnownPosition = CGPoint(x: 100, y: 53)
    
    lazy var analogJoystick: TLAnalogJoystick = {
        let js = TLAnalogJoystick(withDiameter: 100)
        js.alpha = 0.5
        let point = CGPoint(x: UIScreen.main.bounds.width * -0.5 + js.radius + 45, y: UIScreen.main.bounds.height * -0.5 + js.radius + 45)
        js.position = point
        js.zPosition = 15
        return js
    }()
    
    lazy var knobJoystick: SKSpriteNode = {
        let js = SKSpriteNode(imageNamed: "outlineDisc")
        let point = CGPoint(x: UIScreen.main.bounds.width * 0.5 - 100, y: UIScreen.main.bounds.height * -0.5 + 100)
        js.name = "knob"
        js.size = CGSize(width: 60, height: 60)
        js.position = point
        js.zPosition = 15
        return js
    }()
    
    override func sceneDidLoad() {
        
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        player = self.childNode(withName: "player") as! SKSpriteNode
        background = self.childNode(withName: "background") as! SKSpriteNode
        ground = self.childNode(withName: "ground") as! SKSpriteNode
        for child in ground.children {
            child.name = "ground"
        }
        spikes = self.childNode(withName: "spikes") as! SKSpriteNode
        for child in spikes.children {
            child.name = "spikes"
        }
        flyingEnemy = self.childNode(withName: "flyingEnemy") as! SKSpriteNode
        checkpoints = self.childNode(withName: "checkpoints") as! SKSpriteNode
        setup()
        
    }
    
    func setup() {
        walkAnimation = animations.setupWalkAnimation()
        jumpAnimation = animations.setupJumpAnimation()
        
        addChild(cam)
        self.camera = cam
        
        cam.addChild(analogJoystick)
        cam.addChild(knobJoystick)
        //parallax? background follow camera
        background.removeFromParent()
        background.zPosition = -2
        cam.addChild(background)
        //
        
        setupEnemyFlyingBehavior()
        
        analogJoystick.on(.begin) { (js) in
            self.player.run(SKAction.repeatForever(self.walkAnimation), withKey: "walk")
        }
        
        analogJoystick.on(.move) { (js) in
            var multiplayerFacing: CGFloat = 0
            if js.angular < 0 {
                multiplayerFacing = 1.0
            } else {
                multiplayerFacing = -1.0
            }
            self.player.xScale = abs(self.player.xScale) * multiplayerFacing
            self.player.position = CGPoint(x: self.player.position.x + (js.velocity.x * 0.12), y: self.player.position.y)
        }
        
        analogJoystick.on(.end) { (js) in
            self.player.removeAction(forKey: "walk")
            self.player.texture = SKTexture(imageNamed: "playerBlue_stand")
            self.background.removeAllActions()
        }
        
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        
        
        /*ground.physicsBody!.categoryBitMask = groundCategory
        ground.physicsBody!.contactTestBitMask = playerCategory
        ground.physicsBody!.collisionBitMask = 0
        
        player.physicsBody!.categoryBitMask = playerCategory
        player.physicsBody!.contactTestBitMask = groundCategory
        player.physicsBody!.collisionBitMask = groundCategory*/
    }
    
   
    
    override func update(_ currentTime: TimeInterval) {
        
        if player.position.x > 0 {
           cam.position.x = player.position.x
        }
        
        if player.position.x < -315 {
            player.position.x = -313
        }
        
        //print(player.position.y)
        
        if player.position.y < -200 {
            wasHurt()
            player.position = lastKnownPosition
        }
        
        for checkpoint in checkpoints.children {
            if player.intersects(checkpoint) {
                lastKnownPosition = player.position
            }
        }
        
        
        
        // Initialize _lastUpdateTime if it has not already been
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "knob" {
                print("knob")
                if grounded == true {
                    self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                    //self.player.run(jumpAnimation)
                    self.player.run(jumpAnimation) {
                        //self.player.texture = SKTexture(imageNamed: "playerBlue_stand")
                    }
                    grounded = false
                }
            }
        }
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        //print("bodyA: \(contact.bodyA.node?.name)")
        //print("bodyB: \(contact.bodyB.node?.name)")
        
        
        if contact.bodyA.node?.name == "player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if firstBody.node?.name == "player" && secondBody.node?.name == "ground" {
            grounded = true
        }
        
        if firstBody.node?.name == "player" && secondBody.node?.name == "spikes" && hurt == false{
            wasHurt()
        }
        
        if firstBody.node?.name == "player" && secondBody.node?.name == "flyingEnemy" && hurt == false{
            wasHurt()
        }
    
    }
    
    func wasHurt() {
        let hurtAnimation = self.animations.hurtAnimation()
        print("animation start")
        self.hurt = true
        //zabrac serce tutaj
        self.player.run(hurtAnimation) {
            print("done")
            self.hurt = false
        }
    }
}

extension GameScene {
    func setupWalkAnimation() {
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "playerBlue_walk\(i)"))
        }
        
        walkAnimation = SKAction.animate(with: textures, timePerFrame: 0.08)
        
        
    }
    
    func setupJumpAnimation() {
        var textures: [SKTexture] = []
        for i in 1...3 {
            textures.append(SKTexture(imageNamed: "playerBlue_up\(i)"))
        }
        
        //textures.append(contentsOf: textures.reversed())
        
        var lastTexture = SKTexture(imageNamed: "playerBlue_stand")
        textures.append(lastTexture)
        
        jumpAnimation = SKAction.animate(with: textures, timePerFrame: 0.20)
        
    }
    
    func setupEnemyFlyingBehavior() {
        for enemy in flyingEnemy.children {
            guard let enemy = enemy as? SKSpriteNode else { return }
            enemy.name = "flyingEnemy"
            let flyingAction = animations.flyingEnemyAnimation(originPosition: enemy.position, flyingEnemy: enemy)
            enemy.run(SKAction.repeatForever(flyingAction), withKey: "flyingAnimation")
        }
    }
}


