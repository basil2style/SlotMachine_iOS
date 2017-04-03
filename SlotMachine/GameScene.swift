//
//  GameScene.swift
//  SlotMachine
//
//  Created by Basil (300919992) & Luis (300869199) on 2017-03-28.
//  Copyright © 2017 Centennial College. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let slotOptions = ["heart","bell","money","cones","star"]
   // let slotOptions = ["heart"]
    
    var currentWheelStringValue1:String = ""
    var currentWheelStringValue2:String = ""
    var currentWheelStringValue3:String = ""
    
    var bg = SKSpriteNode()
    var wheelActive:Bool = false
    
    var playerMoney = 1000;
    var jackpot = 5000;
    var playerBet = 100;
    
    let spinBt = SKAction.playSoundFileNamed("Pickup-coin 11.wav", waitForCompletion: false)
    let jackpotAudio = SKAction.playSoundFileNamed("pacman.wav", waitForCompletion: false)
    
    
    override func didMove(to view: SKView) {
        
        //Background slot machine
        let bgTexture = SKTexture(imageNamed: "slotmachine.png");
        bg = SKSpriteNode(texture: bgTexture)
        //bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
        bg.size.height = self.frame.height
        bg.size.width = self.frame.width
        bg.zPosition = -1
        self.addChild(bg)
        
        //spritenode declaration for spin button
        let spin:SKSpriteNode = self.childNode(withName: "spin_bt") as! SKSpriteNode
      //  self.addChild(spin)
        spin.name = "SpinButton"
        spin.isUserInteractionEnabled = false
       
        //spritenode declaration for reset button
        let reset:SKSpriteNode = self.childNode(withName: "reset") as! SKSpriteNode
        reset.name = "reset"
        reset.isUserInteractionEnabled = false
        
        //spritenode declaration for bet100 button
        let bet100:SKSpriteNode = self.childNode(withName: "bet100") as! SKSpriteNode
        bet100.name = "bet100"
        bet100.isUserInteractionEnabled = false
        
        //spritenode declaration for labels
        let totalCredits:SKLabelNode = self.childNode(withName: "totalCredits") as! SKLabelNode
        let bet:SKLabelNode = self.childNode(withName: "bet") as! SKLabelNode
        
        totalCredits.text = "\(playerMoney)"
        bet.text = "\(playerBet)"
        
        let winLabel:SKLabelNode = self.childNode(withName: "winLabel") as! SKLabelNode
        winLabel.text = "PLAY!!"
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let touch:UITouch = touches as UITouch
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        let bet:SKLabelNode = self.childNode(withName: "bet") as! SKLabelNode
        let totalCredits:SKLabelNode = self.childNode(withName: "totalCredits") as! SKLabelNode
        let winLabel:SKLabelNode = self.childNode(withName: "winLabel") as! SKLabelNode
        let winnerPaid:SKLabelNode = self.childNode(withName: "winnerPaid") as! SKLabelNode
        
        //touch sprite button
        if let name = touchedNode.name
        {
            //Spin Button
            if name == "SpinButton" {
//                print("Touched")
                run(spinBt)
                if(wheelActive == false && playerMoney > 0){
                    print("spinning");
                    //playerMoney -= playerBet
                    totalCredits.text = "\(playerMoney)"
                    let wait:SKAction = SKAction.wait(forDuration: 0.5)
                    let spinWheel1:SKAction = SKAction.run({
                        self.spinWheel(whichWheel: 1)
                    })
                    let spinWheel2:SKAction = SKAction.run({
                        self.spinWheel(whichWheel: 2)
                    })
                    let spinWheel3:SKAction = SKAction.run({
                        self.spinWheel(whichWheel: 3)
                    })
                    let testWheelValues:SKAction = SKAction.run({
                        self.testValues()
                    })
                    
                    self.run(SKAction.sequence([wait,spinWheel1,wait,spinWheel2,wait,spinWheel3,wait,testWheelValues]))
                    
                }
                else {
                    winLabel.text = "Recharge"
                }
            }
                //Rset Button
            else if name == "reset" {
                 print("Touched")
                playerMoney = 1000;
                playerBet = 100
                
                bet.text = "\(playerBet)"
                winnerPaid.text = "0"
                totalCredits.text = "\(playerMoney)"
                
            }
                //Bet100 button
            else if name == "bet100" {
                if(playerMoney > 0) {
                    print("+100")
                    playerBet += 100
                    playerMoney -= 100
                    bet.text = "\(playerBet)"
                    totalCredits.text = "\(playerMoney)"
                    
                }
                
            }
            
        }

    }
    
    //This is the outcome function 
    func testValues()  {
        let winLabel:SKLabelNode = self.childNode(withName: "winLabel") as! SKLabelNode
        //let totalCredits:SKLabelNode = self.childNode(withName: "totalCredits") as! SKLabelNode
        //let bet:SKLabelNode = self.childNode(withName: "bet") as! SKLabelNode
        let winnerPaid:SKLabelNode = self.childNode(withName: "winnerPaid") as! SKLabelNode
        
        //JackPot
        if (currentWheelStringValue1 == currentWheelStringValue2 && currentWheelStringValue2 == currentWheelStringValue3) {
            run(jackpotAudio)
            winLabel.text = "WIN"
            playerMoney += jackpot;
            
            winnerPaid.text = "\(playerMoney)"
            print("You won")
        }else {
            //Loss
            winLabel.text = "LOSS"
            print("Please play again")
            playerMoney -= playerBet;
            winnerPaid.text = "0"
            
        }
        
        
    }
    //Function for spinning reel
    func spinWheel(whichWheel:Int)  {
        let randomNum:UInt32 = arc4random_uniform(UInt32(slotOptions.count))
        let wheelPick:String = slotOptions[Int(randomNum)]
        print("Wheel \(wheelPick) spun a value of \(whichWheel)")
        
        if (whichWheel == 1) {
            currentWheelStringValue1 = wheelPick
            
            if (self.childNode(withName: "wheel1") != nil) {
                if let wheel1:SKSpriteNode = self.childNode(withName: "wheel1") as? SKSpriteNode {
                    wheel1.texture = SKTexture(imageNamed:wheelPick)
                }
                //self.childNode(withName: "wheel1").texture = SKTexture(imageNamed:wheelPick)
            }
            
        } else if (whichWheel == 2) {
            currentWheelStringValue2 = wheelPick
           // sprite1.texture = SKTexture(imageNamed:wheelPick)
            if (self.childNode(withName: "wheel2") != nil) {
                if let wheel2:SKSpriteNode = self.childNode(withName: "wheel2") as? SKSpriteNode {
                    wheel2.texture = SKTexture(imageNamed:wheelPick)
                }
                //self.childNode(withName: "wheel1").texture = SKTexture(imageNamed:wheelPick)
            }
            
        } else if (whichWheel == 3) {
            currentWheelStringValue3 = wheelPick
           // sprite1.texture = SKTexture(imageNamed:wheelPick)
            if (self.childNode(withName: "wheel3") != nil) {
                if let wheel1:SKSpriteNode = self.childNode(withName: "wheel3") as? SKSpriteNode {
                    wheel1.texture = SKTexture(imageNamed:wheelPick)
                }
                //self.childNode(withName: "wheel1").texture = SKTexture(imageNamed:wheelPick)
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func detemineWinnings()  {
    
        
    }
    
    
}
