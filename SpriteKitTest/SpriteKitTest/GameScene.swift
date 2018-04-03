//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by mac on 03.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Texture
    var bgTexture: SKTexture!
    var flyHeroTex: SKTexture!
    var runHeroTex: SKTexture!
    
    //Emitters Node
    var heroEmitter = SKEmitterNode()
    
    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var hero = SKSpriteNode()
    
    //Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var skyObject = SKNode()
    var heroObject = SKNode()
    var heroEmitterObject = SKNode()
    
    //Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    
    //Array of Textures for animateWithTextures
    var heroFlyTexturesArray = [SKTexture]()
    var heroRunTexturesArray = [SKTexture]()
    
    override func didMove(to view: SKView) {
        //Backgroung texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        //Hero textures
        flyHeroTex = SKTexture(imageNamed: "Fly0.png")
        runHeroTex = SKTexture(imageNamed: "Run0.png")
        
        //Emitters
        heroEmitter = SKEmitterNode(fileNamed: "engine.sks")!
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        createGame()
    }
    
    override func didFinishUpdate() {
        heroEmitter.position = hero.position - CGPoint(x: 30.0, y: 5.0)
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(skyObject)
        self.addChild(heroObject)
        self.addChild(heroEmitterObject)
    }
    
    func createGame() {
        createBg()
        createGround()
        createSky()
        
        createHero()
        createHeroEmitter()
    }
    
    func createBg() {
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0.0, duration: 3.0)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0.0, duration: 0.0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
        
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: size.width / 4 + bgTexture.size().width * CGFloat(i), y: size.height / 2.0)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            bgObject.addChild(bg)
        }
    }
    
    func createGround() {
        ground = SKSpriteNode()
        ground.position = CGPoint.zero
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height / 4 + self.frame.height / 8))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        
        ground.zPosition = 1
        
        groundObject.addChild(ground)
    }
    
    func createSky() {
        sky = SKSpriteNode()
        sky.position = CGPoint(x: 0.0, y: self.frame.maxX)
        
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width + 100, height: self.frame.size.height - 100))
        sky.physicsBody?.isDynamic = false
        
        sky.zPosition = 1
        
        skyObject.addChild(sky)
    }
    
    func addHero(_ heroNode: SKSpriteNode, atPosition position: CGPoint) {
        hero = SKSpriteNode(texture: flyHeroTex)
        
        //Flying hero
        heroFlyTexturesArray = [SKTexture(imageNamed: "Fly0.png"), SKTexture(imageNamed: "Fly1.png"), SKTexture(imageNamed: "Fly2.png"), SKTexture(imageNamed: "Fly3.png"), SKTexture(imageNamed: "Fly4.png")]
        let heroFlyAnimation = SKAction.animate(with: heroFlyTexturesArray, timePerFrame: 0.1)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        
        hero.run(flyHero)
        hero.position = position
        hero.size.height = 84
        hero.size.width = 120
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
        hero.physicsBody?.categoryBitMask = heroGroup
        hero.physicsBody?.contactTestBitMask = groundGroup
        hero.physicsBody?.collisionBitMask = groundGroup
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        
        hero.zPosition = 1
        
        heroObject.addChild(hero)
    }
    
    func createHero() {
        addHero(hero, atPosition: CGPoint(x: self.size.width / 4, y: 0 + flyHeroTex.size().height + 400))
    }
    
    func createHeroEmitter() {
        heroEmitter = SKEmitterNode(fileNamed: "engine.sks")!
        heroEmitterObject.zPosition = 1
        heroEmitterObject.addChild(heroEmitter)
    }
    
}
