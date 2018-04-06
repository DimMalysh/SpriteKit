//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by mac on 03.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Animations
    var animations = AnimationClass()
    
    //Variables
    var isActiveShield = false
    var gameOver = false
    var gameViewControllerBridge: GameViewController!
    var moveElectricGateByY = SKAction()
    var difficultyChoosing: DifficultyChoosing!
    var bgChoosing: BgChoosing!
    
    //Textures
    var bgTex: SKTexture!
    var flyHeroTex: SKTexture!
    var runHeroTex: SKTexture!
    var deadHeroTex: SKTexture!
    var coinTex: SKTexture!
    var redCoinTex: SKTexture!
    var coinHeroTex: SKTexture!
    var redCoinHeroTex: SKTexture!
    var electricGateTex: SKTexture!
    var shieldTex: SKTexture!
    var shieldItemTex: SKTexture!
    var mineLightTex: SKTexture!
    var mineHeavyTex: SKTexture!
    
    //Emitters Node
    var heroEmitter = SKEmitterNode()
    
    //Label Nodes
    var tabToPlayLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var highScoreTextLabel = SKLabelNode()
    var stageLabel = SKLabelNode()
    
    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var hero = SKSpriteNode()
    var coin = SKSpriteNode()
    var redCoin = SKSpriteNode()
    var electricGate = SKSpriteNode()
    var shield = SKSpriteNode()
    var shieldItem = SKSpriteNode()
    var mine = SKSpriteNode()
    
    //Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var movingObject = SKNode()
    var heroObject = SKNode()
    var heroEmitterObject = SKNode()
    var coinObject = SKNode()
    var redCoinObject = SKNode()
    var shieldObject = SKNode()
    var shieldItemObject = SKNode()
    var labelObject = SKNode()
    
    //Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    var coinGroup: UInt32 = 0x1 << 3
    var redCoinGroup: UInt32 = 0x1 << 4
    var objectGroup: UInt32 = 0x1 << 5
    var shieldGroup: UInt32 = 0x1 << 6
    
    //Array of Textures for animateWithTextures
    var heroFlyTexturesArray = [SKTexture]()
    var heroRunTexturesArray = [SKTexture]()
    var heroDeathTexturesArray = [SKTexture]()
    var coinTexturesArray = [SKTexture]()
    var electricGateTexturesArray = [SKTexture]()
    
    //Timers
    var timerAddCoin = Timer()
    var timerAddRedCoin = Timer()
    var timerAddElectricGate = Timer()
    var timerAddShieldItem = Timer()
    var timerAddMine = Timer()
    
    //Sounds
    var pickCoinPreload = SKAction()
    var electricGateCreatePreload = SKAction()
    var electricGateDeadPreload = SKAction()
    var shieldOnPreload = SKAction()
    var shieldOffPreload = SKAction()
    
    override func didMove(to view: SKView) {
        //Backgroung texture
        bgTex = SKTexture(imageNamed: "bg01.png")
        
        //Hero textures
        flyHeroTex = SKTexture(imageNamed: "Fly0.png")
        runHeroTex = SKTexture(imageNamed: "Run0.png")
        
        //Coin textures
        coinTex = SKTexture(imageNamed: "coin.jpg")
        redCoinTex = SKTexture(imageNamed: "coin.jpg")
        coinHeroTex = SKTexture(imageNamed: "coin0.png")
        redCoinHeroTex = SKTexture(imageNamed: "coin0.png")
        
        //ElectricGate texture
        electricGateTex = SKTexture(imageNamed: "ElectricGate01.png")
        
        //Shields textures
        shieldTex = SKTexture(imageNamed: "shield.png")
        shieldItemTex = SKTexture(imageNamed: "shieldItem.png")
        
        //Mine textures
        mineLightTex = SKTexture(imageNamed: "mine1.png")
        mineHeavyTex = SKTexture(imageNamed: "mine2.png")
        
        //Emitters
        heroEmitter = SKEmitterNode(fileNamed: "engine.sks")!
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        
        if UserDefaults.standard.object(forKey: "highScore") != nil {
            Model.sharedInstance.highScore = UserDefaults.standard.object(forKey: "highScore") as! Int
            highScoreLabel.text = "\(Model.sharedInstance.highScore)"
        }
        
        if UserDefaults.standard.object(forKey: "totalScore") != nil {
            Model.sharedInstance.totalScore = UserDefaults.standard.object(forKey: "totalScore") as! Int
        }
        
        if !gameOver {
            createGame()
        }
        
        pickCoinPreload = SKAction.playSoundFileNamed("pickCoin.mp3", waitForCompletion: false)
        electricGateCreatePreload = SKAction.playSoundFileNamed("electricCreate.wav", waitForCompletion: false)
        electricGateDeadPreload = SKAction.playSoundFileNamed("electricDead.mp3", waitForCompletion: false)
        shieldOnPreload = SKAction.playSoundFileNamed("shieldOn.mp3", waitForCompletion: false)
        shieldOffPreload = SKAction.playSoundFileNamed("shieldOff.mp3", waitForCompletion: false)
    }
    
    override func didFinishUpdate() {
        heroEmitter.position = hero.position - CGPoint(x: 30.0, y: 5.0)
        shield.position = hero.position + CGPoint(x: 0.0, y: 0.0)
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(movingObject)
        self.addChild(heroObject)
        self.addChild(heroEmitterObject)
        self.addChild(coinObject)
        self.addChild(redCoinObject)
        self.addChild(shieldObject)
        self.addChild(shieldItemObject)
        self.addChild(labelObject)
    }
    
    func createGame() {
        createBg()
        createGround()
        createSky()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.createHero()
            self.createHeroEmitter()
            self.startTimers()
            self.addElectricGate()
        }
        
        showTapToPlay()
        showScore()
        showStage()
        highScoreLabel.isHidden = true
        
        gameViewControllerBridge.reloadGameButton.isHidden = true
        gameViewControllerBridge.menuGameButton.isHidden = true
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
    }
    
    func createBg() {
        var correctHeight: CGFloat = 0.0
        switch bgChoosing.rawValue  {
        case 0:
            bgTex = SKTexture(imageNamed: "bg01.png")
            correctHeight = 2.0
        case 1:
            bgTex = SKTexture(imageNamed: "bg02.png")
            correctHeight = 1.75
        default:
            break
        }
        
        let moveBg = SKAction.moveBy(x: -bgTex.size().width, y: 0.0, duration: 3.0)
        let replaceBg = SKAction.moveBy(x: bgTex.size().width, y: 0.0, duration: 0.0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
        
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTex)
            bg.position = CGPoint(x: size.width / 4 + bgTex.size().width * CGFloat(i), y: size.height / correctHeight)
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
        
        movingObject.addChild(sky)
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
        hero.physicsBody?.contactTestBitMask = groundGroup | coinGroup | redCoinGroup | objectGroup | shieldGroup
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
        coin = SKSpriteNode(texture: coinTex)
        
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
        coin.position = CGPoint(x: self.size.width + 50, y: 0 + coinTex.size().height + 90 + pipeOffset)
        
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
        redCoin = SKSpriteNode(texture: redCoinTex)
        
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
        redCoin.position = CGPoint(x: self.size.width + 50, y: 0 + redCoinTex.size().height + 90 + pipeOffset)
        
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
    
    func addElectricGate() {
        if Model.sharedInstance.isSound == true {
            run(electricGateCreatePreload)
        }
        
        electricGate = SKSpriteNode(texture: electricGateTex)
        
        //Activated electric gate
        electricGateTexturesArray = [SKTexture(imageNamed: "ElectricGate01.png"), SKTexture(imageNamed: "ElectricGate02.png"), SKTexture(imageNamed: "ElectricGate03.png"), SKTexture(imageNamed: "ElectricGate04.png")]
        let electricGateAnimation = SKAction.animate(with: electricGateTexturesArray, timePerFrame: 0.1)
        let activeElectricGate = SKAction.repeatForever(electricGateAnimation)
        
        electricGate.run(activeElectricGate)
        
        let randomPosition = arc4random() % 2
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 5)
        let pipeOffset = self.frame.size.height / 4 + 30 - CGFloat(movementAmount)
        
        if randomPosition == 0 {
            electricGate.position = CGPoint(x: self.size.width + 50, y: 0 + electricGateTex.size().height / 2 + 90 + pipeOffset)
            electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 40, height: electricGate.size.height - 20))
            
        } else {
            electricGate.position = CGPoint(x: self.size.width + 50, y: self.frame.size.height - electricGateTex.size().height / 2 - 90 - pipeOffset)
            electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 40, height: electricGate.size.height - 20))
        }
        
        //Rotation electric gate
        electricGate.run(SKAction.repeatForever(SKAction.sequence([SKAction.run({
            self.electricGate.run(SKAction.rotate(byAngle: CGFloat(M_PI * 2), duration: 0.5))
        }), SKAction.wait(forDuration: 20.0)])))
        
        //Move electric gate
        let moveAction = SKAction.moveBy(x: -self.frame.width - 300, y: 0.0, duration: 6.0)
        electricGate.run(moveAction)
        
        //Scale electric gate
        var scaleValue: CGFloat = 0.3
        
        let scaleRandom = arc4random() % UInt32(5)
        switch scaleRandom {
        case 0: scaleValue = 1.0
        case 1: scaleValue = 0.9
        case 2: scaleValue = 0.6
        case 3: scaleValue = 0.8
        case 4: scaleValue = 0.7
        default: break
        }
        
        electricGate.setScale(scaleValue)
        
        let movementRandom = arc4random() % 9
        switch movementRandom {
        case 0: moveElectricGateByY = SKAction.moveTo(y: self.frame.height / 2 + 220, duration: 4.0)
        case 1: moveElectricGateByY = SKAction.moveTo(y: self.frame.height / 2 - 220, duration: 5.0)
        case 2: moveElectricGateByY = SKAction.moveTo(y: self.frame.height / 2 - 150, duration: 4.0)
        case 3: moveElectricGateByY = SKAction.moveTo(y: self.frame.height / 2 + 150, duration: 5.0)
        case 4: moveElectricGateByY = SKAction.moveTo(y: self.frame.height / 2 + 50, duration: 4.0)
        case 5: moveElectricGateByY = SKAction.moveTo(y: self.frame.height / 2 - 50, duration: 5.0)
        default: moveElectricGateByY = SKAction.moveTo(y: self.frame.height / 2, duration: 4.0)
        }
        
        electricGate.run(moveElectricGateByY)
        
        electricGate.physicsBody?.restitution = 0
        electricGate.physicsBody?.isDynamic = false
        electricGate.physicsBody?.categoryBitMask = objectGroup
        electricGate.zPosition = 1
        
        movingObject.addChild(electricGate)
    }
    
    func addMine() {
        let minesRandom = arc4random() % UInt32(2)
        let mine = minesRandom == 0 ? SKSpriteNode(texture: mineLightTex) : SKSpriteNode(texture: mineHeavyTex)
        let mineMoveToX = SKAction.moveTo(x: -self.frame.size.width / 4, duration: 4.0)
        
        mine.size.width = 70.0
        mine.size.height = 62.0
        mine.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24)
        
        mine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mine.size.width - 40, height: mine.size.height - 30))
        mine.physicsBody?.categoryBitMask = objectGroup
        mine.physicsBody?.isDynamic = false
        
        let removingAction = SKAction.removeFromParent()
        let mineMoveByBgForever = SKAction.repeatForever(SKAction.sequence([mineMoveToX, removingAction]))
        
        animations.rotateAnimation(sprite: mine, duration: 0.2)
        
        mine.run(mineMoveByBgForever)
        mine.zPosition = 1
        movingObject.addChild(mine)
    }
    
    func addShieldItem() {
        shieldItem = SKSpriteNode(texture: shieldItemTex)
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        
        shieldItem.position = CGPoint(x: self.size.width + 50.0, y: shieldItemTex.size().height + self.size.height / 2 + pipeOffset)
    
        shieldItem.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldItem.size.width - 20, height: shieldItem.size.height - 20))
        shieldItem.physicsBody?.restitution = 0
        shieldItem.physicsBody?.isDynamic = false
        shieldItem.physicsBody?.categoryBitMask = shieldGroup
        shieldItem.zPosition = 1
        
        let moveShield = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0.0, duration: 5.0)
        let removeAction = SKAction.removeFromParent()
        let shieldItemMoveByBgForever = SKAction.repeatForever(SKAction.sequence([moveShield, removeAction]))
        
        animations.scaleZDirection(sprite: shieldItem)
        shieldItem.setScale(1.1)
        
        shieldItem.run(shieldItemMoveByBgForever)
        shieldItemObject.addChild(shieldItem)
    }
    
    func addShield() {
        shield = SKSpriteNode(texture: shieldTex)
        
        if Model.sharedInstance.isSound {
            run(shieldOnPreload)
        }
        
        shield.zPosition = 1
        
        shieldObject.addChild(shield)
    }
    
    func showTapToPlay() {
        tabToPlayLabel.text = "Tap to Fly!!!"
        tabToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        tabToPlayLabel.fontSize = 50.0
        tabToPlayLabel.fontColor = UIColor.white
        tabToPlayLabel.fontName = "Chalkduster"
        tabToPlayLabel.zPosition = 1
        self.addChild(tabToPlayLabel)
    }
    
    func showScore() {
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 200)
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
    }
    
    func showHighScore() {
        highScoreLabel = SKLabelNode()
        highScoreLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 210)
        highScoreLabel.fontSize = 50.0
        highScoreLabel.fontName = "Chalkduster"
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.isHidden = true
        highScoreLabel.zPosition = 1
        labelObject.addChild(highScoreLabel)
    }
    
    func showHighScoreText() {
        highScoreTextLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 150)
        highScoreTextLabel.fontSize = 30.0
        highScoreTextLabel.fontName = "Chalkduster"
        highScoreTextLabel.fontColor = UIColor.white
        highScoreTextLabel.text = "HighScore"
        highScoreTextLabel.zPosition = 1
        labelObject.addChild(highScoreTextLabel)
    }
    
    func showStage() {
        stageLabel.position = CGPoint(x: self.frame.maxX - 60, y: self.frame.maxY - 140)
        stageLabel.fontSize = 30.0
        stageLabel.fontName = "Chalkduster"
        stageLabel.fontColor = UIColor.white
        stageLabel.text = "Stage 1"
        stageLabel.zPosition = 1
        self.addChild(stageLabel)
    }
    
    func levelUp() {
        let score = Model.sharedInstance.score
        
        switch score {
        case _ where score >= 1 && score < 20:
            stageLabel.text = "Stage 1"
            coinObject.speed = 1.05
            redCoinObject.speed = 1.1
            movingObject.speed = 1.05
            self.speed = 1.05
        case _ where score >= 20 && score < 36:
            stageLabel.text = "Stage 2"
            coinObject.speed = 1.22
            redCoinObject.speed = 1.32
            movingObject.speed = 1.22
            self.speed = 1.22
        case _ where score >= 36 && score < 56:
            stageLabel.text = "Stage 3"
            coinObject.speed = 1.3
            redCoinObject.speed = 1.35
            movingObject.speed = 1.3
            self.speed = 1.3
        default:
            break
        }
    }
    
    func startTimers() {
        invalidateTimers()
        
        timerAddCoin = Timer.scheduledTimer(timeInterval: 2.64, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
        timerAddRedCoin = Timer.scheduledTimer(timeInterval: 8.246, target: self, selector: #selector(GameScene.addRedCoin), userInfo: nil, repeats: true)
        
        var timeIntervals = Array(repeating: 0.0, count: 3)
        
        switch difficultyChoosing.rawValue {
        case 0: //easy mode
            timeIntervals[0] = 5.234
            timeIntervals[1] = 4.45
            timeIntervals[2] = 20.2
        case 1: //medium mode
            timeIntervals[0] = 3.234
            timeIntervals[1] = 3.45
            timeIntervals[2] = 30.2
        case 2: //hard mode
            timeIntervals[0] = 3.034
            timeIntervals[1] = 2.945
            timeIntervals[2] = 40.2
        default:
            break
        }
        
        timerAddElectricGate = Timer.scheduledTimer(timeInterval: timeIntervals[0], target: self, selector: #selector(GameScene.addElectricGate), userInfo: nil, repeats: true)
        timerAddMine = Timer.scheduledTimer(timeInterval: timeIntervals[1], target: self, selector: #selector(GameScene.addMine), userInfo: nil, repeats: true)
        timerAddShieldItem = Timer.scheduledTimer(timeInterval: timeIntervals[2], target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
    }
    
    func stopGameObjects() {
        coinObject.speed = 0.0
        redCoinObject.speed = 0.0
        movingObject.speed = 0.0
        heroObject.speed = 0.0
    }
    
    func invalidateTimers() {
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        timerAddElectricGate.invalidate()
        timerAddMine.invalidate()
        timerAddShieldItem.invalidate()
    }
    
    func reloadGame() {
        if Model.sharedInstance.isSound {
            SKTAudio.sharedInstance().resumeBackgroundMusic()
        }
        
        coinObject.removeAllChildren()
        redCoinObject.removeAllChildren()
        
        stageLabel.text = "Stage 1"
        gameOver = false
        scene?.isPaused = false
        
        movingObject.removeAllChildren()
        heroObject.removeAllChildren()
        
        coinObject.speed = 1.0
        heroObject.speed = 1.0
        movingObject.speed = 1.0
        self.speed = 1.0
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
        
        createGround()
        createSky()
        createHero()
        createHeroEmitter()
        
        gameViewControllerBridge.menuGameButton.isHidden = true
        
        Model.sharedInstance.score = 0
        scoreLabel.text = "0"
        stageLabel.isHidden = false
        highScoreTextLabel.isHidden = true
        
        showHighScore()
        invalidateTimers()
        startTimers()
    }
    
    func removeAll() {
        Model.sharedInstance.score = 0
        scoreLabel.text = "0"
        
        gameOver = false
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
        
        invalidateTimers()
        
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
        self.view?.removeFromSuperview()
        
        gameViewControllerBridge = nil
    }
}
