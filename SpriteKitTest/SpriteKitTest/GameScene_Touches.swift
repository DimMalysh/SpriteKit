//
//  GameScene_Touches.swift
//  SpriteKitTest
//
//  Created by mac on 03.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heroEmitter.isHidden = false
        
        hero.physicsBody?.velocity = CGVector.zero
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        
        //Flying hero
        heroFlyTexturesArray = [SKTexture(imageNamed: "Fly0.png"), SKTexture(imageNamed: "Fly1.png"), SKTexture(imageNamed: "Fly2.png"), SKTexture(imageNamed: "Fly3.png"), SKTexture(imageNamed: "Fly4.png")]
        let heroFlyAnimation = SKAction.animate(with: heroFlyTexturesArray, timePerFrame: 0.1)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        
        hero.run(flyHero)
    }
    
}
