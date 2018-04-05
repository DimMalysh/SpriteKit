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
        
        if contact.bodyA.categoryBitMask == objectGroup || contact.bodyB.categoryBitMask == objectGroup {
            hero.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            
            let objectNode = contact.bodyA.categoryBitMask == objectGroup ? contact.bodyA.node : contact.bodyB.node
            
            if !isActiveShield {
                animations.shakeAndFlashAnimation(view: self.view!)
                
                if isSound == true {
                    run(electricGateCreatePreload)
                }
                
                hero.physicsBody?.allowsRotation = false
                
                heroEmitterObject.removeAllChildren()
                coinObject.removeAllChildren()
                redCoinObject.removeAllChildren()
                movingObject.removeAllChildren()
                groundObject.removeAllChildren()
                movingObject.removeAllChildren()
                shieldObject.removeAllChildren()
                shieldItemObject.removeAllChildren()
                
                stopGameObjects()
                invalidateTimers()
                
                //Dying hero
                heroDeathTexturesArray = [SKTexture(imageNamed: "Dead0.png"), SKTexture(imageNamed: "Dead1.png"), SKTexture(imageNamed: "Dead2.png"), SKTexture(imageNamed: "Dead3.png"), SKTexture(imageNamed: "Dead4.png"), SKTexture(imageNamed: "Dead5.png"), SKTexture(imageNamed: "Dead6.png")]
                let heroDeathAnimation = SKAction.animate(with: heroDeathTexturesArray, timePerFrame: 0.2)
                hero.run(heroDeathAnimation)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.scene?.isPaused = true
                    self.heroObject.removeAllChildren()
                    
                    self.gameViewControllerBridge.reloadGameButton.isHidden = false
                })
            } else {
                objectNode?.removeFromParent()
                shieldObject.removeAllChildren()
                
                isActiveShield = !isActiveShield
                
                if isSound {
                    run(shieldOffPreload)
                }
            }
        }
        
        if contact.bodyA.categoryBitMask == shieldGroup || contact.bodyB.categoryBitMask == shieldGroup {
            let shieldNode = contact.bodyA.categoryBitMask == shieldGroup ? contact.bodyA.node : contact.bodyB.node
            
            if !isActiveShield {
                if isSound {
                    run(pickCoinPreload)
                }
                shieldNode?.removeFromParent()
                addShield()
                isActiveShield = !isActiveShield
            }
        }
        
        if contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup {
            heroEmitter.isHidden = true
            
            //Going hero
            heroRunTexturesArray = [SKTexture(imageNamed: "Run0.png"), SKTexture(imageNamed: "Run1.png"), SKTexture(imageNamed: "Run2.png"), SKTexture(imageNamed: "Run3.png"), SKTexture(imageNamed: "Run4.png"), SKTexture(imageNamed: "Run5.png"), SKTexture(imageNamed: "Run6.png")]
            let heroRunAnimation = SKAction.animate(with: heroRunTexturesArray, timePerFrame: 0.1)
            let heroRun = SKAction.repeatForever(heroRunAnimation)
            
            hero.run(heroRun)
        }
        
        if contact.bodyA.categoryBitMask == coinGroup || contact.bodyB.categoryBitMask == coinGroup {
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if isSound == true {
                run(pickCoinPreload)
            }
            
            coinNode?.removeFromParent()
        }
        
        if contact.bodyA.categoryBitMask == redCoinGroup || contact.bodyB.categoryBitMask == redCoinGroup {
            let redCoinNode = contact.bodyA.categoryBitMask == redCoinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if isSound == true {
                run(pickCoinPreload)
            }
            
            redCoinNode?.removeFromParent()
        }
        
    }
    
}
