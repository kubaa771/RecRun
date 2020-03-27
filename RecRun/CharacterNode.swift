//
//  CharacterNode.swift
//  RecRun
//
//  Created by Jakub Iwaszek on 23/03/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit
import SpriteKit

class CharacterNode: SKSpriteNode {
    var gameScene: SKScene!
    
    /*init(gameScene: SKScene) {
        //super.init()
        self.gameScene = gameScene
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
