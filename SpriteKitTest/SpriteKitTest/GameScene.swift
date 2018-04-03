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
    
    //Animations
    var animations = AnimationClass()
    
    //Variables
    var isSound = true
    
    //Textures
    var bgTexture: SKTexture!
    var flyHeroTex: SKTexture!
    var runHeroTex: SKTexture!
    var coinTexture: SKTexture!
    var redCoinTexture: SKTexture!
    var coinHeroTex: SKTexture!
    var redCoinHeroTex: SKTexture!
    
    //Emitters Node
    var heroEmitter = SKEmitterNode()
    
    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var hero = SKSpriteNode()
    var coin = SKSpriteNode()
    var redCoin = SKSpriteNode()
    
    //Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var skyObject = SKNode()
    var heroObject = SKNode()
    var heroEmitterObject = SKNode()
    var coinObject = SKNode()
    var redCoinObject = SKNode()
    
    //Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    var coinGroup: UInt32 = 0x1 << 3
    var redCoinGroup: UInt32 = 0x1 << 4
    
    //Array of Textures for animateWithTextures
    var heroFlyTexturesArray = [SKTexture]()
    var heroRunTexturesArray = [SKTexture]()
    var coinTexturesArray = [SKTexture]()
    
    //Timers
    var timerAddCoin = Timer()
    var timerAddRedCoin = Timer()
    
    //Sounds
    var pickCoinPreload = SKAction()
    
    override func didMove(to view: SKView) {
        //Backgroung texture
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        //Hero textures
        flyHeroTex = SKTexture(imageNamed: "Fly0.png")
        runHeroTex = SKTexture(imageNamed: "Run0.png")
        
        //Coin textures
        coinTexture = SKTexture(imageNamed: "coin.jpg")
        redCoinTexture = SKTexture(imageNamed: "coin.jpg")
        coinHeroTex = SKTexture(imageNamed: "coin0.png")
        redCoinHeroTex = SKTexture(imageNamed: "coin0.png")
        
        //Emitters
        heroEmitter = SKEmitterNode(fileNamed: "engine.sks")!
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        createGame()
        
        pickCoinPreload = SKAction.playSoundFileNamed("pickCoin.mp3", waitForCompletion: false)
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
        self.addChild(coinObject)
        self.addChild(redCoinObject)
    }
    
    func createGame() {
        createBg()
        createGround()
        createSky()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.createHero()
            self.createHeroEmitter()
            self.startTimers()
        }
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
        hero.physicsBody?.contactTestBitMask = groundGroup | coinGroup | redCoinGroup
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
    
    func addCoin() {
        coin = SKSpriteNode(texture: coinTexture)
        
        //Twisting coin
        coinTexturesArray = [SKTexture(imageNamed: "Coin0.png"), SKTexture(imageNamed: "Coin1.png"), SKTexture(imageNamed: "Coin2.png"), SKTexture(imageNamed: "Coin3.png")]
        let coinAnimation = SKAction.animate(with: coinTexturesArray, timePerFrame: 0.1)
        let twistCoin = SKAction.repeatForever(coinAnimation)
        
        coin.run(twistCoin)
        coin.size.width = 40.0
        coin.size.height = 40.0
        
        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width - 20, height: coin.size.height - 20))
        coin.physicsBody?.restitution = 0.0
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        coin.position = CGPoint(x: self.size.width + 50, y: 0 + coinTexture.size().height + 90 + pipeOffset)
        
        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0.0, duration: 5.0)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveCoin, removeAction]))
        coin.run(coinMoveBgForever)
        
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = coinGroup
        coin.zPosition = 1
        
        coinObject.addChild(coin)
    }
    
    func addRedCoin() {
        redCoin = SKSpriteNode(texture: redCoinTexture)
        
        //Twisting red coin
        coinTexturesArray = [SKTexture(imageNamed: "Coin0.png"), SKTexture(imageNamed: "Coin1.png"), SKTexture(imageNamed: "Coin2.png"), SKTexture(imageNamed: "Coin3.png")]
        let redCoinAnimation = SKAction.animate(with: coinTexturesArray, timePerFrame: 0.1)
        let twistRedCoin = SKAction.repeatForever(redCoinAnimation)
        
        redCoin.run(twistRedCoin)
        redCoin.size.width = 40.0
        redCoin.size.height = 40.0
        
        redCoin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: redCoin.size.width - 10, height: redCoin.size.height - 10))
        redCoin.physicsBody?.restitution = 0.0
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        redCoin.position = CGPoint(x: self.size.width + 50, y: 0 + redCoinTexture.size().height + 90 + pipeOffset)
        
        let moveRedCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0.0, duration: 5.0)
        let removeAction = SKAction.removeFromParent()
        let redCoinMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveRedCoin, removeAction]))
        redCoin.run(redCoinMoveBgForever)
        
        animations.scaleZDirection(sprite: redCoin)
        animations.redColorAnimation(sprite: redCoin, duration: 0.5)
        
        redCoin.setScale(1.3)
        redCoin.physicsBody?.isDynamic = false
        redCoin.physicsBody?.categoryBitMask = redCoinGroup
        redCoin.zPosition = 1
        
        coinObject.addChild(redCoin)

    }
    
    func startTimers() {
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        
        timerAddCoin = Timer.scheduledTimer(timeInterval: 2.64, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
        timerAddRedCoin = Timer.scheduledTimer(timeInterval: 8.246, target: self, selector: #selector(GameScene.addRedCoin), userInfo: nil, repeats: true)
    }
}
