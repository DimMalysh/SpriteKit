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
    
    func shakeAndFlashAnimation(view: SKView) {
        //White flash
        let tempView = UIView(frame: view.frame)
        tempView.backgroundColor = UIColor.white
        view.addSubview(tempView)
        
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseInOut, animations: {
            tempView.alpha = 0.0
        }) { (done) in
            tempView.removeFromSuperview()
        }
        
        //Shake animation
        let shake = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-15.0, 5.0, 5.0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(15.0, 5.0, 5.0))
        ]
        shake.autoreverses = true
        shake.repeatCount = 2.0
        shake.duration = 7/100
        
        view.layer.add(shake, forKey: nil)
    }
}
