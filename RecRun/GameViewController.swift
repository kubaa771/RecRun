//
//  GameViewController.swift
//  RecRun
//
//  Created by Jakub Iwaszek on 23/03/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let view = self.view as! SKView? {
            
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = false

            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
