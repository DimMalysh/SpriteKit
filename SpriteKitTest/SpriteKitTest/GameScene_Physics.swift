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
        
        let objectNode = contact.bodyA.categoryBitMask == objectGroup ? contact.bodyA.node : contact.bodyB.node
        
        if Model.sharedInstance.score > Model.sharedInstance.highScore {
            Model.sharedInstance.highScore = Model.sharedInstance.score
        }
        UserDefaults.standard.set(Model.sharedInstance.highScore, forKey: "highScore")
        
        if contact.bodyA.categoryBitMask == objectGroup || contact.bodyB.categoryBitMask == objectGroup {
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if !isActiveShield {
                animations.shakeAndFlashAnimation(view: self.view!)
                
                if Model.sharedInstance.isSound == true {
                    run(electricGateDeadPreload)
                }
                
                Model.sharedInstance.totalScore += Model.sharedInstance.score
                
                hero.physicsBody?.allowsRotation = false
                
                heroEmitterObject.removeAllChildren()
                coinObject.removeAllChildren()
                redCoinObject.removeAllChildren()
                groundObject.removeAllChildren()
                movingObject.removeAllChildren()
                shieldObject.removeAllChildren()
                shieldItemObject.removeAllChildren()
                
                stopGameObjects()
                invalidateTimers()
                
                heroDeathTexturesArray =  [SKTexture(imageNamed: "Dead0.png"), SKTexture(imageNamed: "Dead1.png"), SKTexture(imageNamed: "Dead2.png"), SKTexture(imageNamed: "Dead3.png"), SKTexture(imageNamed: "Dead4.png"), SKTexture(imageNamed: "Dead5.png"), SKTexture(imageNamed: "Dead6.png")]
                let heroDeathAnimation = SKAction.animate(with: heroDeathTexturesArray, timePerFrame: 0.2)
                hero.run(heroDeathAnimation)
                
                showHighScore()
                gameOver = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.scene?.isPaused = true
                    self.heroObject.removeAllChildren()
                    self.showHighScoreText()
                    
                    self.gameViewControllerBridge.reloadGameButton.isHidden = false
                    self.gameViewControllerBridge.menuGameButton.isHidden = false
                    
                    self.stageLabel.isHidden = true
                    
                    if Model.sharedInstance.score > Model.sharedInstance.highScore {
                        Model.sharedInstance.highScore = Model.sharedInstance.score
                    }
                    
                    self.highScoreLabel.isHidden = false
                    self.highScoreTextLabel.isHidden = false
                    self.highScoreLabel.text = "\(Model.sharedInstance.highScore)"
                })
                
                SKTAudio.sharedInstance().pauseBackgroundMusic()
            } else {
                objectNode?.removeFromParent()
                shieldObject.removeAllChildren()
                isActiveShield = !isActiveShield
                if Model.sharedInstance.isSound {
                    run(shieldOffPreload)
                }
            }
        }
        
        if contact.bodyA.categoryBitMask == shieldGroup || contact.bodyB.categoryBitMask == shieldGroup {
            levelUp()
            let shieldNode = contact.bodyA.categoryBitMask == shieldGroup ? contact.bodyA.node : contact.bodyB.node
            
            if !isActiveShield {
                if Model.sharedInstance.isSound {
                    run(pickCoinPreload)
                }
                shieldNode?.removeFromParent()
                addShield()
                isActiveShield = !isActiveShield
            }
        }
        
        if contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup {
            
            if !gameOver {
                heroEmitter.isHidden = true
                
                heroRunTexturesArray =  [SKTexture(imageNamed: "Run0.png"), SKTexture(imageNamed: "Run1.png"), SKTexture(imageNamed: "Run2.png"), SKTexture(imageNamed: "Run3.png"), SKTexture(imageNamed: "Run4.png"), SKTexture(imageNamed: "Run5.png"), SKTexture(imageNamed: "Run6.png")]
                let heroRunAnimation = SKAction.animate(with: heroRunTexturesArray, timePerFrame: 0.1)
                let heroRun = SKAction.repeatForever(heroRunAnimation)
                hero.run(heroRun)
            }
        }
        
        if contact.bodyA.categoryBitMask == coinGroup || contact.bodyB.categoryBitMask == coinGroup {
            levelUp()
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if Model.sharedInstance.isSound {
                run(pickCoinPreload)
            }
            
            switch stageLabel.text! {
            case "Stage 1": Model.sharedInstance.score += 1
            case "Stage 2": Model.sharedInstance.score += 2
            case "Stage 3": Model.sharedInstance.score += 3
            default: break
            }
            
            Model.sharedInstance.score += difficultyChoosing.rawValue
            scoreLabel.text = "\(Model.sharedInstance.score)"
            
            coinNode?.removeFromParent()
        }
        
        if contact.bodyA.categoryBitMask == redCoinGroup || contact.bodyB.categoryBitMask == redCoinGroup {
            levelUp()
            let redCoinNode = contact.bodyA.categoryBitMask == redCoinGroup ? contact.bodyA.node : contact.bodyB.node
            
            if Model.sharedInstance.isSound {
                run(pickCoinPreload)
            }
            
            switch stageLabel.text! {
            case "Stage 1": Model.sharedInstance.score += 2
            case "Stage 2": Model.sharedInstance.score += 3
            case "Stage 3": Model.sharedInstance.score += 4
            default: break
            }
            
            Model.sharedInstance.score += difficultyChoosing.rawValue
            self.scoreLabel.text = "\(Model.sharedInstance.score)"
            
            redCoinNode?.removeFromParent()
        }
        
        UserDefaults.standard.set(Model.sharedInstance.totalScore, forKey: "totalScore")
    }
    
}
