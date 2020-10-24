//
//  Puzzle.swift
//  ShapesFlashCards
//
//  Created by Yana  on 2020-09-26.
//  Copyright © 2020 Yana . All rights reserved.
//

import Foundation
import SpriteKit
protocol TransitionDelegate: SKSceneDelegate {
      func returnToMainMenu()
  }

 class Puzzle: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var activeShape: SKSpriteNode!
    private var shadeNode: SKSpriteNode!
    private var shapeNumber: Int = 0
    private var positionX: CGFloat = 0.0
    private var positionY: CGFloat = 0.0
    private var shapes: [String] = ["Yellow", "Purple", "Grey", "Yellow", "Grey", "Purple", "Yellow", "Purple", "Yellow"]
    private var cancelTouches: Bool = false
    private var birdWidth: CGFloat = 0.0
    private var yellow: Int = 0
    private var grey: Int = 0
    private var purple: Int = 0
    private var index: Int = 0
    
    
  
    // add new Shape to Panda's hands
    func addShape () {
        let textureShape = SKTexture(imageNamed: shapes[shapeNumber])
        let shapeSpriteNode = SKSpriteNode(texture: textureShape)
        let name = "\(shapes[shapeNumber])Owl"
        birdWidth = shapeSpriteNode.frame.width/2
        
        shapeSpriteNode.size = CGSize(width: birdWidth, height: shapeSpriteNode.frame.height/2)
              
        shapeSpriteNode.zPosition = 3.0
        shapeSpriteNode.position.x = positionX
        shapeSpriteNode.position.y = positionY
        activeShape = shapeSpriteNode
        self.addChild(shapeSpriteNode)
        shadeNode = self.childNode(withName: name)! as? SKSpriteNode
        index = numberBirds(color: shapes[shapeNumber])
        shapeNumber += 1
    }
    
    func numberBirds (color: String) -> Int {
        if (color == "Yellow") {
            yellow += 1
            return yellow
        }
        if (color == "Purple") {
            purple += 1
            return purple
        }
        if (color == "Grey") {
            grey += 1
            return grey
        }
        return 1
    }
    
    // add stars to the screen
     func winner () {
          if let winnerParticles = SKEmitterNode(fileNamed: "winner.sks") {
          winnerParticles.position = CGPoint(x: size.width/2, y: size.height)
          winnerParticles.name = "rainParticle"
          winnerParticles.targetNode = scene
          
          self.addChild(winnerParticles)
          _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.goToHome), userInfo: nil, repeats: false) // go to the home scene after 10 seconds
         }
      }
      
      // plays winner sound and show star's rain
      func winnerAnimation () {
          if (self.shapeNumber == self.shapes.count) {
              self.activeShape = SKSpriteNode()
              winner()
              audio.playSound(fileName: "Sound/winner", type: "mp3", volume: 1, loop: 0)
              cancelTouches = true
          }
      }
    
    override func didMove(to view: SKView) {
        let rightHand = self.childNode(withName: "RightHand")!
        let leftHand = self.childNode(withName: "LeftHand")!
        audio.resumeMusic()
        positionX = (rightHand.position.x + leftHand.position.x)/2
        positionY = (rightHand.position.y + leftHand.position.y)/2 - 20
        addShape ()
    }
    
    //goes to home screen
    @objc func goToHome () {
        _ = SKTransition.fade(withDuration: 3.0)
        let nextScene = SKScene(fileNamed: "GameScene")
        nextScene?.scaleMode = .aspectFill
        view?.presentScene(nextScene)
    }
    
    //moves shapes on the screen
   /* override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        var touchLocation: CGPoint = touch.location(in: self)
        let touchedNode: SKSpriteNode = self.atPoint(touchLocation) as! SKSpriteNode
        
        if (touchedNode.texture == activeShape.texture || touchedNode.name == "RightHand" || touchedNode.name == "LeftHand") {
            for touch in touches {
                touchLocation = touch.location(in: self)
                    activeShape.zPosition = 9.0 + CGFloat(shapeNumber)
                    activeShape.position.x = touchLocation.x
                    activeShape.position.y = touchLocation.y
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let shadePosition = shadeNode.position
        
        if (activeShape.position.y == shadePosition.y) {
            activeShape.position.x = shadePosition.x - birdWidth
            activeShape.position.y = shadePosition.y - birdWidth
            audio.playSound(fileName: "Sound/success", type: "mp3", volume: 1, loop: 0)
        
            winnerAnimation ()
           if (self.shapeNumber < self.shapes.count && shadePosition == activeShape.position) {
                self.addShape ()
            }
        } else if (self.shapeNumber <= self.shapes.count && !cancelTouches) {
            audio.playSound(fileName: "Sound/fail", type: "mp3", volume: 1, loop: 0)
            activeShape.zPosition = 3.0
            activeShape.position.x = positionX
            activeShape.position.y = positionY
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // touches
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)

        if (touchedNode.name == "HomeButton") {
            cancelTouches = true
            goToHome ()
        }
        if (self.shapeNumber <= self.shapes.count && !cancelTouches) {
            activeShape.zPosition = 3.0
        }
    }*/
    func touch(atPoint pos : CGPoint) {
        activeShape.position = pos
    }
       
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           guard let touch = touches.first else {
               return
           }
           
           let touchLocation = touch.location(in: self)
           let touchedNode = self.atPoint(touchLocation)
        
           if (touchedNode.name == "HomeButton") {
               cancelTouches = true
               goToHome ()
           }
           if (self.shapeNumber <= self.shapes.count && !cancelTouches) {
               activeShape.zPosition = 10.0
           }
  
       }
       
       override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           for t in touches { self.touch(atPoint: t.location(in: self)) }
       }
       
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         let shadePosition = shadeNode.position
        
        if ((shadePosition.y - activeShape.position.y < 50) &&
            (activeShape.position.y - shadePosition.y < 50)) {
            activeShape.position.y = shadePosition.y - 20
            activeShape.position.x = shadePosition.x - (birdWidth * CGFloat(index))
            audio.playSound(fileName: "Sound/success", type: "mp3", volume: 1, loop: 0)
            winnerAnimation ()
            if (self.shapeNumber < self.shapes.count) {
                 self.addShape ()
             }
        } else if (self.shapeNumber <= self.shapes.count && !cancelTouches) {
            audio.playSound(fileName: "Sound/fail", type: "mp3", volume: 1, loop: 0)
            activeShape.zPosition = 3.0
            activeShape.position.x = positionX
            activeShape.position.y = positionY
        }
       }
       
       override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           for t in touches { self.touch(atPoint: t.location(in: self)) }
       }
}

