//
//  GameScene.swift
//  MyGame
//
//  Created by Xcode User on 2020-10-23.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Baddy: UInt32 = 0b1 //1
    static let Spark: UInt32 = 0b10 //2
    static let Hero: UInt32 = 0b100 //4
}

enum gameState {
    case preGame
    case InGame
    case afterGame
}

var score : Int?
var runCount = 60

class GameScene: SKScene,SKPhysicsContactDelegate{
    let Kname = SKLabelNode()
    let tapToStartLable = SKLabelNode()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode(imageNamed: "background.png")
    private var sportNode : SKSpriteNode?
    
    var levelNumber = 0
    
    var livesNumber = 3
    private var livesLable: SKLabelNode!
    
    
    
    let scoreIncrement = 10
    private var lbScore : SKLabelNode!
    
    var timer: Timer?
    
    var currentGameState = gameState.preGame
    
    private var lbTimer: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.alpha = 0.2
       
        addChild(background)
        
        background.physicsBody = SKPhysicsBody(rectangleOf: background.size)
        background.physicsBody?.isDynamic = true;
        background.physicsBody?.categoryBitMask = PhysicsCategory.None
        background.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        background.physicsBody?.collisionBitMask = PhysicsCategory.None

        sportNode = SKSpriteNode(imageNamed: "shuttle")
        sportNode?.setScale(1.5)
        
        sportNode?.position = CGPoint(x: self.size.width/2, y: 0 - (sportNode?.size.height)!)
        sportNode?.zPosition = 2
        addChild(sportNode!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self;
        
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: (sportNode?.size.width)!/2)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Baddy | PhysicsCategory.Spark |  PhysicsCategory.None
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        
        score = 0
        self.lbScore = self.childNode(withName: "//score") as? SKLabelNode
        self.lbScore?.text = "Score: 0"
        self.lbScore?.fontColor = SKColor.white

        
        if let slable =  self.lbScore{
            slable.alpha = 0.0
            slable.run(SKAction.fadeIn(withDuration: 2.0))
            
        }
        
        livesNumber = 3
        self.livesLable = self.childNode(withName: "//livesLable") as? SKLabelNode
        self.livesLable?.text = "Lives: \(livesNumber)"
        self.livesLable?.fontColor = SKColor.white
        
        
        
        if let llable = self.livesLable{
            llable.alpha = 0.0
            llable.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        tapToStartLable.text = "Lets Begin"
        tapToStartLable.fontColor = SKColor.white
        tapToStartLable.fontSize = 110
        tapToStartLable.zPosition = 1
        tapToStartLable.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLable.alpha = 0
        addChild(tapToStartLable)
        
        
        Kname.text = "Krutik parikh"
        Kname.fontSize = 90
        Kname.fontColor = SKColor.white
        Kname.zPosition = 1
        Kname.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.35)
        self.addChild(Kname)
       
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLable.run(fadeInAction)
        
        
        
    }
    
    func startGame(){
        currentGameState = gameState.InGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSeq = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLable.run(deleteSeq)
        Kname.run(deleteSeq)
        
        let moveShip = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startAction = SKAction.run(startNewLevel)
        let startGameSeq = SKAction.sequence([moveShip,startAction])
        sportNode?.run(startGameSeq)
        
        timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.heroNoCollide()
        }
        
        print("Game state1- \(currentGameState)")
        if currentGameState == gameState.InGame{
            
            print("Game state2- \(currentGameState)")
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                runCount -= 1
                
                self.lbTimer = self.childNode(withName: "//timer") as? SKLabelNode
                self.lbTimer?.text = "Time Left: \(runCount)"
                
                if runCount == 0 {
                    timer.invalidate()
                    self.rungameOver()
                }
            }
        }
       // startNewLevel()
    }
    
    func startNewLevel(){
        
        
        
        levelNumber = levelNumber + 1
        
        print("level number -  \(levelNumber)")
        
        if self.action(forKey: "spawingEnemies") != nil{
            self.removeAction(forKey: "spawingEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1:
            levelDuration = 1.2
        case 2:
            levelDuration = 1
        case 3:
            levelDuration = 0.8
        case 4:
            levelDuration = 0.5
        case 5:
            levelDuration = 0.3
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
       //let player = SKAction.run(addPlayer)
        
        let Bspawn = SKAction.run(addBaddy)
        let BwaitTospawn = SKAction.wait(forDuration: levelDuration )
        let BspawnSequence = SKAction.sequence([BwaitTospawn,Bspawn])
        
        let Sspawn = SKAction.run(addSpark)
        let SwaitTospawn = SKAction.wait(forDuration: levelDuration)
        let SspawnSequence = SKAction.sequence([SwaitTospawn,Sspawn])
        
        let spawnfour =  SKAction.repeat(BspawnSequence, count: 4)
        let spawnfive = SKAction.repeat(SspawnSequence, count: 1)
        
        let spawnForever = SKAction.repeatForever(SKAction.sequence([spawnfour,spawnfive]))
        run(spawnForever, withKey: "spawingEnemies")
    }
    
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    
    func addSpark(){
        
        print("Sparky Added")
        let randomXStart = random(min: frame.minX, max: frame.maxX)
        let randomXEnd = random(min: frame.minX, max: frame.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let sparky = SKSpriteNode(imageNamed: "spark.png")
        sparky.name = "Fuel"
        sparky.setScale(0.5)
        sparky.position = startPoint
        sparky.zPosition = 2
        addChild(sparky)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let moveEnemy = SKAction.move(to: endPoint, duration: TimeInterval(actualDuration))
        let deleteEnemy = SKAction.removeFromParent()
        
        sparky.run(SKAction.sequence([moveEnemy,deleteEnemy]))
        
        sparky.physicsBody = SKPhysicsBody(rectangleOf: sparky.size)
        sparky.physicsBody?.isDynamic = true;
        sparky.physicsBody?.categoryBitMask = PhysicsCategory.Spark
        sparky.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        sparky.physicsBody?.collisionBitMask = PhysicsCategory.None

    }
    
    func addBaddy(){
        
        let randomXStart = random(min: frame.minX, max: frame.maxX)
        let randomXEnd = random(min: frame.minX, max: frame.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let baddy = SKSpriteNode(imageNamed: "alien2")
        baddy.name = "Enemy"
        baddy.setScale(1.5)
        baddy.position = startPoint
        baddy.zPosition = 2
        addChild(baddy)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let moveEnemy = SKAction.move(to: endPoint, duration: TimeInterval(actualDuration))
        let deleteEnemy = SKAction.removeFromParent()
//        let loseALifeaction = SKAction.run(loseAlife)
//        baddy.run(SKAction.sequence([moveEnemy,deleteEnemy, loseALifeaction]))
        
        baddy.run(SKAction.sequence([moveEnemy,deleteEnemy]))

//        let dx = endPoint.x - startPoint.x
//        let dy = endPoint.y - startPoint.y
//        let amountToRotate = atan2(dy, dx)
//        baddy.zRotation = amountToRotate
        
        baddy.physicsBody = SKPhysicsBody(rectangleOf: baddy.size)
        baddy.physicsBody?.isDynamic = true;
        baddy.physicsBody?.categoryBitMask = PhysicsCategory.Baddy
        baddy.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        baddy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
    }
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosition.png")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSeq = SKAction.sequence([scaleIn,fadeOut,delete])
        explosion.run(explosionSeq)
    }
    
    
    func heroDidCollideWithBaddy( baddy: SKSpriteNode,hero: SKSpriteNode){
        
        spawnExplosion(spawnPosition: baddy.position)
        
        baddy.removeFromParent()
        hero.removeFromParent()
        
        rungameOver()
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func heroCollideWithSpark(spark: SKSpriteNode , hero: SKSpriteNode){
        score = score! + scoreIncrement
        
        self.lbScore?.text = "Score: \(score!)"
        if let slable =  self.lbScore{
            slable.alpha = 0.0
            slable.run(SKAction.fadeIn(withDuration: 2.0))
            
        }
        
        spark.removeFromParent()
        
        if score! >= 10 || score! >= 25 || score! >= 50 || score! >= 100 || score! >= 200{
            startNewLevel()
        }

        
    }
    func heroNoCollide(){
        
        score = score! + 1
        
        self.lbScore?.text = "Score: \(score!)"
        if let slable =  self.lbScore{
            slable.alpha = 0.0
            slable.run(SKAction.fadeIn(withDuration: 2.0))
            
        }
        
        
        
    }
   
    func rungameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Enemy", using: {
            enemy, stop in
            enemy.removeAllActions()
        })
        
        self.enumerateChildNodes(withName: "Fuel", using: {
            fuel, stop in
            fuel.removeAllActions()
        })
        
        let changeSceneAtAction = SKAction.run(changeScene)
        let waitToChange = SKAction.wait(forDuration: 1)
        let changeSceneSeq = SKAction.sequence([waitToChange,changeSceneAtAction])
        self.run(changeSceneSeq)
     
    }
 
    func changeScene(){
        let sceneToMove = GameOverScene(size: self.size)
        
        sceneToMove.scaleMode = self.scaleMode
        let myTransition =  SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMove, transition: myTransition)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.categoryBitMask == PhysicsCategory.Spark && secondBody.categoryBitMask == PhysicsCategory.Hero)
        {
            heroCollideWithSpark(spark: firstBody.node as! SKSpriteNode, hero: secondBody.node as! SKSpriteNode)
        }
        if(firstBody.categoryBitMask == PhysicsCategory.Baddy && secondBody.categoryBitMask == PhysicsCategory.Hero)
        {
            livesNumber -=  1
            self.livesLable?.text = "Lives: \(livesNumber)"
            
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
            self.livesLable.run(scaleSequence)
            spawnExplosion(spawnPosition: firstBody.node!.position)
            
            if livesNumber == 0{
                heroDidCollideWithBaddy( baddy: firstBody.node as! SKSpriteNode, hero: secondBody.node as! SKSpriteNode)
                
                rungameOver()
            }
            
            
            
        }
        
        if(firstBody.categoryBitMask == PhysicsCategory.None && secondBody.categoryBitMask == PhysicsCategory.Hero)
        {
                //self.heroNoCollide()
            
        }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  //      for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.InGame{
            sportNode?.position.x += amountDragged
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
        }
    }
    
    //    func loseAlife(){
    //        livesNumber -=  1
    //        self.livesLable?.text = "Lives: \(livesNumber)"
    //
    //        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
    //        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
    //        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
    //        self.livesLable.run(scaleSequence)
    //
    //        if livesNumber == 0{
    //            rungameOver()
    //        }
    //    }
   
    
   
}
