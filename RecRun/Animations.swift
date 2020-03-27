//
//  Animations.swift
//  RecRun
//
//  Created by Jakub Iwaszek on 27/03/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation
import SpriteKit

class Animations {
    var playerColor: String
    
    init(playerColor: String){
        self.playerColor = playerColor
    }
    
    
    func setupWalkAnimation() -> SKAction{
        var walkAnimation: SKAction
        
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "playerBlue_walk\(i)"))
        }
        
        walkAnimation = SKAction.animate(with: textures, timePerFrame: 0.08)
        
        return walkAnimation
        
    }
    
    func setupJumpAnimation() -> SKAction {
        var jumpAnimation: SKAction
        var textures: [SKTexture] = []
        for i in 1...3 {
            textures.append(SKTexture(imageNamed: "playerBlue_up\(i)"))
        }
           
        let lastTexture = SKTexture(imageNamed: "playerBlue_stand")
        textures.append(lastTexture)
           
        jumpAnimation = SKAction.animate(with: textures, timePerFrame: 0.20)
        
        return jumpAnimation
    }
    
    func hurtAnimation() -> SKAction {
        let pulsedRed = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.15),
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.15)
        ])
        
        
        
        return SKAction.repeat(pulsedRed, count: 10)
    }
    
    func flyingEnemyAnimation(originPosition: CGPoint, flyingEnemy: SKSpriteNode) -> SKAction {
        var textures: [SKTexture] = []
        for i in 1...3 {
            textures.append(SKTexture(imageNamed: "enemyFlying_\(i)"))
        }
        
        let flyingEnemyAnimation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.12))
        
        let moveSequence = SKAction.repeatForever(SKAction.sequence([
            SKAction.move(to: CGPoint(x: originPosition.x - 200, y: originPosition.y), duration: 5.0),
            SKAction.scaleX(to: abs(flyingEnemy.xScale) * (1.0), duration: 0.1),
            SKAction.move(to: CGPoint(x: originPosition.x + 200, y: originPosition.y), duration: 5.0),
            SKAction.scaleX(to: abs(flyingEnemy.xScale) * (-1.0), duration: 0.1)
        ]))
        
        let fullAction = SKAction.group([flyingEnemyAnimation, moveSequence])
        
        return fullAction
        
    }
    
}
