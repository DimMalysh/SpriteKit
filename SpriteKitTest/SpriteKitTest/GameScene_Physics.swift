//
//  GameScene_Physics.swift
//  SpriteKitTest
//
//  Created by mac on 03.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup {
            heroEmitter.isHidden = true
            
            //Going hero
            heroRunTexturesArray = [SKTexture(imageNamed: "Run0.png"), SKTexture(imageNamed: "Run1.png"), SKTexture(imageNamed: "Run2.png"), SKTexture(imageNamed: "Run3.png"), SKTexture(imageNamed: "Run4.png"), SKTexture(imageNamed: "Run5.png"), SKTexture(imageNamed: "Run6.png")]
            let heroRunAnimation = SKAction.animate(with: heroRunTexturesArray, timePerFrame: 0.1)
            let heroRun = SKAction.repeatForever(heroRunAnimation)
            
            hero.run(heroRun)
        }
        
    }
    
}
