//
//  GameScene.swift
//  SlotMachine
//
//  Created by Basil on 2017-03-28.
//  Copyright © 2017 Centennial College. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let slotOptions = ["heart","bell","money","cones","star"]
    
    var currentWheelStringValue1:String = ""
    var currentWheelStringValue2:String = ""
    var currentWheelStringValue3:String = ""
    
    var bg = SKSpriteNode()
    var wheelActive:Bool = false
    
    var playerMoney = 1000;
    
    override func didMove(to view: SKView) {
        let bgTexture = SKTexture(imageNamed: "slotmachine.png");
        bg = SKSpriteNode(texture: bgTexture)
        //bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
        bg.size.height = self.frame.height
        bg.size.width = self.frame.width
        bg.zPosition = -1
        self.addChild(bg)
        
        let spin:SKSpriteNode = self.childNode(withName: "spin_bt") as! SKSpriteNode
      //  self.addChild(spin)
        spin.name = "SpinButton"
        spin.isUserInteractionEnabled = false
       
        let reset:SKSpriteNode = self.childNode(withName: "reset") as! SKSpriteNode
        reset.name = "reset"
        reset.isUserInteractionEnabled = false
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let touch:UITouch = touches as UITouch
        let touch:UITouch = touches.first as! UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "SpinButton" {
//                print("Touched")
                
                if(wheelActive == false){
                    print("spinning");
                    
                    let wait:SKAction = SKAction.wait(forDuration: 1)
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
            }
            else if name == "reset" {
                 print("Touched")
            }
        }

    }
    
    func testValues()  {
        let winLabel:SKLabelNode = self.childNode(withName: "winLabel") as! SKLabelNode
        if (currentWheelStringValue1 == currentWheelStringValue2 && currentWheelStringValue2 == currentWheelStringValue3) {
            
            winLabel.text = "WIN"
            
            print("You won")
        }else {
            winLabel.text = "LOSS"
            print("Please play again")
        }
        
    }
    
    func spinWheel(whichWheel:Int)  {
        let randomNum:UInt32 = arc4random_uniform(UInt32(slotOptions.count))
        let wheelPick:String = slotOptions[Int(randomNum)]
        print("Wheel \(wheelPick) spun a value of \(whichWheel)")
        
        if (whichWheel == 1) {
            currentWheelStringValue1 = wheelPick
            
            if (self.childNode(withName: "wheel1") != nil) {
                if let wheel1:SKSpriteNode = self.childNode(withName: "wheel1") as! SKSpriteNode {
                    wheel1.texture = SKTexture(imageNamed:wheelPick)
                }
                //self.childNode(withName: "wheel1").texture = SKTexture(imageNamed:wheelPick)
            }
            
        } else if (whichWheel == 2) {
            currentWheelStringValue2 = wheelPick
           // sprite1.texture = SKTexture(imageNamed:wheelPick)
            if (self.childNode(withName: "wheel2") != nil) {
                if let wheel2:SKSpriteNode = self.childNode(withName: "wheel2") as! SKSpriteNode {
                    wheel2.texture = SKTexture(imageNamed:wheelPick)
                }
                //self.childNode(withName: "wheel1").texture = SKTexture(imageNamed:wheelPick)
            }
            
        } else if (whichWheel == 3) {
            currentWheelStringValue3 = wheelPick
           // sprite1.texture = SKTexture(imageNamed:wheelPick)
            if (self.childNode(withName: "wheel3") != nil) {
                if let wheel1:SKSpriteNode = self.childNode(withName: "wheel3") as! SKSpriteNode {
                    wheel1.texture = SKTexture(imageNamed:wheelPick)
                }
                //self.childNode(withName: "wheel1").texture = SKTexture(imageNamed:wheelPick)
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
