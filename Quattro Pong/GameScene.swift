//
//  GameScene.swift
//  Pong
//
//  Created by Steve Sahayadarlin on 7/27/17.
//  Copyright © 2017 Steve Sahayadarlin. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BodyType: UInt32 {
    case ball = 1
    case paddle = 2
}

var timer = Timer()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballSound = SKAction.playSoundFileNamed("pongBounceFinal.mp3", waitForCompletion: false)
    
    var top = SKSpriteNode()
    var bottom = SKSpriteNode()
    var left = SKSpriteNode()
    var right = SKSpriteNode()
    var playButton = UIButton()
    var rewardVideoButton = UIButton()
    var soundButton = UIButton()
    
    var ball = SKSpriteNode()
    var ball2 = SKSpriteNode()
    var ball3 = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.isUserInteractionEnabled = false
        
        scene?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        soundButton = UIButton(frame: CGRect(x: 0, y: 605.75 * heightOffset, width: 375 * widthOffset, height: 90 * heightOffset))
        soundButton.setTitle("DISABLE SOUND EFFECTS", for: .normal)
        soundButton.titleLabel?.textAlignment = .center
        soundButton.setTitleColor(UIColor.lightGray, for: .normal)
        soundButton.titleLabel?.font = UIFont(name: "Avenir", size: CGFloat(15 * widthOffset))
        soundButton.addTarget(self, action:#selector(self.soundButtonClicked(_:)), for: .touchUpInside)
        soundButton.tag = 1
        self.view?.addSubview(soundButton)
        
        playButton = UIButton(frame: CGRect(x: 125 * widthOffset, y: 400 * heightOffset, width: 130 * widthOffset, height: 50 * heightOffset))
        playButton.setTitleColor(UIColor.yellow, for: .normal)
        let playImage = UIImage(named: "playButton.png")
        playButton.setImage(playImage, for: .normal)
        playButton.titleLabel?.font = UIFont(name: "Philly Sans", size: CGFloat(50 * widthOffset))
        playButton.addTarget(self, action:#selector(self.playButtonClicked(_:)), for: .touchUpInside)
        self.view?.addSubview(playButton)
        
        rewardVideoButton = UIButton(frame: CGRect(x: 75 * widthOffset, y: 472.5 * heightOffset, width: 235 * widthOffset, height: 50 * heightOffset))
        rewardVideoButton.setTitleColor(UIColor.yellow, for: .normal)
        let rewardVideoImage = UIImage(named: "rewardVideoImagepng.png")
        rewardVideoButton.setImage(rewardVideoImage, for: .normal)
        rewardVideoButton.titleLabel?.font = UIFont(name: "Philly Sans", size: CGFloat(50 * widthOffset))
        rewardVideoButton.addTarget(self, action:#selector(self.rewardVideoButtonClicked(_:)), for: .touchUpInside)
        self.view?.addSubview(rewardVideoButton)
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.zPosition = 50
        ball.physicsBody?.categoryBitMask = BodyType.ball.rawValue
        ball.physicsBody?.collisionBitMask = BodyType.paddle.rawValue
        ball.physicsBody?.contactTestBitMask = BodyType.paddle.rawValue
        
        ball2 = self.childNode(withName: "ball2") as! SKSpriteNode
        ball2.zPosition = 50
        ball2.physicsBody?.categoryBitMask = BodyType.ball.rawValue
        ball2.physicsBody?.collisionBitMask = BodyType.paddle.rawValue
        ball2.physicsBody?.contactTestBitMask = BodyType.paddle.rawValue
        
        ball3 = self.childNode(withName: "ball3") as! SKSpriteNode
        ball3.zPosition = 50
        ball3.physicsBody?.categoryBitMask = BodyType.ball.rawValue
        ball3.physicsBody?.collisionBitMask = BodyType.paddle.rawValue
        ball3.physicsBody?.contactTestBitMask = BodyType.paddle.rawValue
        
        let topAndBottomTexture = SKTexture(imageNamed: "topAndBottom.png")
        let leftAndRightTexture = SKTexture(imageNamed: "leftAndRight.png")
        
        top = SKSpriteNode(texture: topAndBottomTexture)
        bottom = SKSpriteNode(texture: topAndBottomTexture)
        left = SKSpriteNode(texture: leftAndRightTexture)
        right = SKSpriteNode(texture: leftAndRightTexture)
        
        left.position = CGPoint(x: 100, y: 667)
        right.position = CGPoint(x: 650, y: 667)
        top.position = CGPoint(x: 375, y: 1234)
        bottom.position = CGPoint(x: 375, y: 100)
        
        left.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 56, height: 263))
        left.physicsBody?.isDynamic = false
        left.physicsBody?.allowsRotation = false
        
        right.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 56, height: 263))
        right.physicsBody?.isDynamic = false
        right.physicsBody?.allowsRotation = false
        
        top.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 263, height: 56))
        top.physicsBody?.isDynamic = false
        top.physicsBody?.allowsRotation = false
        
        bottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 263, height: 56))
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.allowsRotation = false
        
        top.physicsBody?.categoryBitMask = BodyType.paddle.rawValue
        bottom.physicsBody?.categoryBitMask = BodyType.paddle.rawValue
        left.physicsBody?.categoryBitMask = BodyType.paddle.rawValue
        right.physicsBody?.categoryBitMask = BodyType.paddle.rawValue
        
        self.addChild(top)
        self.addChild(bottom)
        self.addChild(left)
        self.addChild(right)
        
        ball.position = CGPoint(x: 375, y: 667)
        ball2.position = CGPoint(x: 375, y: 667)
        ball3.position = CGPoint(x: 375, y: 667)
        
        timerLabel = SKLabelNode(text: "0.0")
        timerLabel.fontName = "Avenir"
        timerLabel.fontSize = 50
        timerLabel.fontColor = UIColor.green
        timerLabel.position = CGPoint(x: 375, y: 575)
        timerLabel.zPosition = 101
        self.addChild(timerLabel)
        
        bestScoreTextLabel = SKLabelNode(text: "BEST")
        bestScoreTextLabel.fontName = "Avenir"
        bestScoreTextLabel.fontSize = 50
        bestScoreTextLabel.fontColor = UIColor.cyan
        bestScoreTextLabel.position = CGPoint(x: 375, y: 800)
        bestScoreTextLabel.zPosition = 101
        
        bestScoreNumLabel = SKLabelNode(text: "\(bestScore)")
        bestScoreNumLabel.fontName = "Avenir"
        bestScoreNumLabel.fontSize = 50
        bestScoreNumLabel.fontColor = UIColor.cyan
        bestScoreNumLabel.position = CGPoint(x: 375, y: 740)
        bestScoreNumLabel.zPosition = 101
        
        usedLifeLabel = SKLabelNode(text: "EXTRA LIFE USED!")
        usedLifeLabel.fontName = "Avenir"
        usedLifeLabel.fontSize = 35
        usedLifeLabel.fontColor = UIColor.red
        usedLifeLabel.position = CGPoint(x: 375, y: 800)
        usedLifeLabel.zPosition = 101
    
    }
    
    func rewardVideoButtonClicked(_ sender: UIButton) {
        shouldShowRewardVideo = true
    }
    
    func playButtonClicked(_ sender: UIButton) {
        ball2.isHidden = true
        ball3.isHidden = true
        left.position = CGPoint(x: 100, y: 667)
        right.position = CGPoint(x: 650, y: 667)
        top.position = CGPoint(x: 375, y: 1234)
        bottom.position = CGPoint(x: 375, y: 100)
        self.isUserInteractionEnabled = true
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 7 , dy: 7))
        playButton.isHidden = true
        rewardVideoButton.isHidden = true
        soundButton.isHidden = true
        bestScoreTextLabel.removeFromParent()
        bestScoreNumLabel.removeFromParent()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    var secondCounter = 0
    var tenthSecondCounter = 0
    var timerLabel = SKLabelNode()
    var bestScoreTextLabel = SKLabelNode()
    var bestScoreNumLabel = SKLabelNode()
    var usedLifeLabel = SKLabelNode()
    
    func updateTimer() {
        tenthSecondCounter += 1
        if tenthSecondCounter == 10 {
            tenthSecondCounter = 0
            secondCounter += 1
        }
        
        if (timerLabel.text == "30.0") {
            ball2.isHidden = false
            ball2.physicsBody?.isDynamic = true
            ball2.physicsBody?.applyImpulse(CGVector(dx: 7 , dy: 7))
        }else if (timerLabel.text == "45") {
            ball3.isHidden = false
            ball3.physicsBody?.isDynamic = true
            ball3.physicsBody?.applyImpulse(CGVector(dx: 7 , dy: 7))
        }
        
        timerLabel.text = "\(secondCounter).\(tenthSecondCounter)"
        
        if ((!intersects(ball) || !intersects(ball2) || !intersects(ball3)) && doesHaveExtraLife == false) {
            gameIsOver()
        }else if ((!intersects(ball) || !intersects(ball2) || !intersects(ball3)) && doesHaveExtraLife){
            doesHaveExtraLife = false
            self.addChild(usedLifeLabel)
            ball.position = CGPoint(x: 375, y: 667)
            ball.physicsBody?.isDynamic = false
            
            if (ball2.isHidden == false) {
                ball2.position = CGPoint(x: 375, y: 667)
                ball2.physicsBody?.isDynamic = false
            }
            
            if (ball3.isHidden == false) {
                ball3.position = CGPoint(x: 375, y: 667)
                ball3.physicsBody?.isDynamic = false
            }
            
            self.isUserInteractionEnabled = false
            delay(1.5, closure: {
                self.usedLifeLabel.removeFromParent()
                self.ball.physicsBody?.isDynamic = true
                self.ball.physicsBody?.applyImpulse(CGVector(dx: 7 , dy: 7))
                
                if (self.ball2.isHidden == false) {
                    self.ball2.physicsBody?.isDynamic = true
                    self.ball2.physicsBody?.applyImpulse(CGVector(dx: 7, dy: 7))
                }
                
                if (self.ball3.isHidden == false) {
                    self.ball3.physicsBody?.isDynamic = true
                    self.ball3.physicsBody?.applyImpulse(CGVector(dx: 7 , dy: 7))
                }
                
                self.isUserInteractionEnabled = true
            })
        }
        
        if didCloseGame {
            didCloseGame = false
            gameIsOver()
        }
    }
    
    func gameIsOver() {
        timer.invalidate()
        if didWatchVideo {
            doesHaveExtraLife = true
        }
        numOfTurns += 1
        shouldShowInterstitial = true
        secondCounter = 0
        tenthSecondCounter = 0
        playButton.isHidden = false
        soundButton.isHidden = false
        if didWatchVideo == false && adDidClose == false {
            rewardVideoButton.isHidden = false
        }
        ball.position = CGPoint(x: 375, y: 667)
        ball.physicsBody?.isDynamic = false
        ball2.position = CGPoint(x: 375, y: 667)
        ball2.physicsBody?.isDynamic = false
        ball3.position = CGPoint(x: 375, y: 667)
        ball3.physicsBody?.isDynamic = false
        self.addChild(bestScoreTextLabel)
        self.addChild(bestScoreNumLabel)
        if Double(timerLabel.text!)! > bestScore {
            bestScore = Double(timerLabel.text!)!
            bestScoreNumLabel.text = "\(bestScore)"
        }
        self.isUserInteractionEnabled = false
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch in touches {
            let location = touch.location(in: self)
            
            if top.contains(location) {
                top.position.x = location.x
                
            } else if bottom.contains(location) {
                bottom.position.x = location.x
                
            } else if left.contains(location) {
                left.position.y = location.y
                
            } else if right.contains(location) {
                right.position.y = location.y
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if top.contains(location) {
                top.position.x = location.x
                
            } else if bottom.contains(location) {
                bottom.position.x = location.x
                
            } else if left.contains(location) {
                left.position.y = location.y
                
            } else if right.contains(location) {
                right.position.y = location.y
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if soundButton.tag == 1 {
            run(ballSound)
        }
        
        let index1 = arc4random_uniform(20)
        let index2 = arc4random_uniform(20)
        let index3 = arc4random_uniform(20)
        ball.color = ballColors[Int(index1)]
        ball2.color = ballColors[Int(index2)]
        ball3.color = ballColors[Int(index3)]
    }
    
    func soundButtonClicked(_ sender: UIButton) {
        if soundButton.tag == 0 {
            soundButton.tag = 1
            soundButton.setTitle("DISABLE SOUND EFFECTS", for: .normal)
        }else{
            soundButton.tag = 0
            soundButton.setTitle("ENABLE SOUND EFFECTS", for: .normal)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
