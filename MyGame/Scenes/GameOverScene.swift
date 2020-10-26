//
//  GameOverScene.swift
//  MyGame
//
//  Created by Xcode User on 2020-10-25.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    
    var currentGameState = gameState.afterGame
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLable = SKLabelNode()
        gameOverLable.text = "Game Over"
        gameOverLable.fontSize = 120
        gameOverLable.fontColor = SKColor.white
        gameOverLable.position = CGPoint(x: self.size.width * 0.5 , y: self.size.height * 0.7)
        gameOverLable.zPosition = 1
        self.addChild(gameOverLable)
        
        print(score!)
        let scoreLable = SKLabelNode()
        scoreLable.text = "Score : \(score!)"
        scoreLable.fontSize = 80
        scoreLable.fontColor = SKColor.white
        scoreLable.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        scoreLable.zPosition = 1
        self.addChild(scoreLable)
        
        let defaults = UserDefaults()
        var highScore =  defaults.integer(forKey: "highScoreSaved")
        
        if score! > highScore{
            highScore = score!
            defaults.set(highScore, forKey: "highScoreSaved")
        }
        
        let highScoreLable = SKLabelNode()
        highScoreLable.text = "High Score: \(highScore)"
        highScoreLable.fontSize = 90
        highScoreLable.fontColor = SKColor.white
        highScoreLable.zPosition = 1
        highScoreLable.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
        self.addChild(highScoreLable)
        
        let timeLeft = SKLabelNode()
        timeLeft.text = "Time Left: \(runCount)"
        timeLeft.fontSize = 90
        timeLeft.fontColor = SKColor.white
        timeLeft.zPosition = 1
        timeLeft.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        self.addChild(timeLeft)
        
   
        
    }
    
    
}
