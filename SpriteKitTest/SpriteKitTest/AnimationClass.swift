//
//  AnimationClass.swift
//  SpriteKitTest
//
//  Created by mac on 03.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationClass {

    func scaleZDirection(sprite: SKSpriteNode) {
        sprite.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(by: 2.0, duration: 0.5), SKAction.scale(to: 1.0, duration: 1.0)])))
    }
    
    func redColorAnimation(sprite: SKSpriteNode, duration: TimeInterval) {
        sprite.run(SKAction.repeatForever(SKAction.sequence([SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: duration), SKAction.colorize(withColorBlendFactor: 0.0, duration: duration)])))
    }
    
}
