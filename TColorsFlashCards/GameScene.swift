//
//  GameScene.swift
//  TColorsFlashCards
//
//  Created by Yana  on 2020-10-23.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // private var request : SKProductsRequest!
          var frameWidth: CGFloat = 0.0 //frame width
          var waspOnHead: Bool = false
          var effectSound: SKAudioNode!
          var panda: SKNode!
          var year: String = ""
          var yearLabel: SKLabelNode!
    
    // moves clound on the main screen
          func moveClouds () {
              let cloud: SKNode? = self.childNode(withName: "Clouds") //clouds on the main screen
              let duration: TimeInterval = 70
              
              let moveClouds = SKAction.sequence([
                    SKAction.moveTo(x: frameWidth, duration: duration),
                    SKAction.moveTo(x: -frameWidth, duration: duration)
                ])
              
              cloud?.run(SKAction.repeatForever(moveClouds)) //clouds move forever
          }
          
          // rotates owl-buttons on the main screen
          func rotateOwl (name: String, angleLeft: CGFloat, angleRight: CGFloat) {
              let owl: SKNode? = self.childNode(withName: name)
              let duration: TimeInterval = 1
              
              let moveOwl = SKAction.sequence([
                  SKAction.rotate(toAngle: angleLeft, duration: duration),
                  SKAction.rotate(toAngle: angleRight, duration: duration)
              ])
              
              owl?.run(SKAction.repeatForever(moveOwl)) // rotate ballon forever
          }
          
       override func didMove(to view: SKView) {
           frameWidth = self.frame.width
           panda = self.childNode(withName: "Panda") //panda on the main screen
           moveClouds () // move clouds animations
      
           //owl animations
            rotateOwl (name: "PurpleOwl", angleLeft: -0.01, angleRight: 0.05)
            rotateOwl (name: "PuzzleOwl", angleLeft: 0.1, angleRight: -0.05)
            rotateOwl (name: "CardsOwl", angleLeft: -0.02, angleRight: 0.03)
          // if (GameViewController.appStoreConnector.isRemoveAdsPurchased()) {
            //   self.childNode(withName: "RemoveAds")?.run(SKAction.hide())
           //}
       }
       
      
       //moves wasp on the main screen
    func moveBird (position: CGPoint, bird: SKNode) {
           
           audio.playSound(fileName: "Sound/bird", type: "mp3", volume: 1, loop: 0)
           
           let moveBird = SKAction.move(to: position, duration: 7)
           bird.run(moveBird)
       }
       
       // panda Head Animation
       func movePandaHead (node: SKNode) { // panda head animation
           let head: SKNode? = self.childNode(withName: "PandaHead")
           let duration1 = 0.3
           let duration2 = 0.5
           let moveYUp: CGFloat = -123
           let moveYDown: CGFloat = -133
           
           let moveHead = SKAction.sequence([
               SKAction.moveTo(y: moveYUp, duration: duration1),
               SKAction.moveTo(y: moveYDown, duration: duration2),
               SKAction.moveTo(y: moveYUp, duration: duration1),
               SKAction.moveTo(y: moveYDown, duration: duration2),
           ])
           head?.run(moveHead)
           audio.playSound(fileName: "Sound/laugh", type: "mp3", volume: 1, loop: 0)
       }
           
       func newSceneView (sceneName: String, presentScene: String) { // Create a new scene
           let nextScene = FlashCards (fileNamed: sceneName)
           nextScene?.presentScene = presentScene
           nextScene?.scaleMode = .aspectFill
           view?.presentScene(nextScene)
       }
       
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // touches
           guard let touch = touches.first else {
               return
           }
           
           let touchLocation = touch.location(in: self)
           let touchedNode = self.atPoint(touchLocation)

           if (touchedNode.parent?.name == "Panda" || touchedNode.parent?.name == "PandaHead") {
               movePandaHead(node: touchedNode.parent ?? panda)
           }
           
           switch touchedNode.name {
               case "CardsOwl":
                   newSceneView (sceneName: "FlashCards", presentScene: "Cards")
               
               case "PurpleOwl":
                   newSceneView (sceneName: "FlashCards", presentScene: "Question")
               
               case "PuzzleOwl":
                   let nextScene = SKScene (fileNamed: "PuzzleSelect")
                   nextScene?.scaleMode = .aspectFill
                   view?.presentScene(nextScene)
               
               case "RemoveAds":
                   let validationPopup = self.childNode(withName: "Popup")
                   validationPopup?.run(SKAction.unhide())
                   yearLabel = validationPopup?.childNode(withName: "YearLabel") as! SKLabelNode
              
                case "PinkBird":
                    moveBird(position: CGPoint(x: -frameWidth, y: 10), bird: touchedNode) // move bird
            
               case "GreyBird":
                    moveBird(position: CGPoint(x: -frameWidth, y: 10), bird: touchedNode) // move bird
            
                case "YellowBird":
                    moveBird(position: CGPoint(x: -frameWidth, y: 500), bird: touchedNode) // move bird
            
                case "BlueBird":
                    moveBird(position: CGPoint(x: -frameWidth, y: -100), bird: touchedNode) // move bird
                   
               case "0":
                   setYearLabel(name: touchedNode.name ?? "")
               case "1":
                   setYearLabel(name: touchedNode.name ?? "")
               case "2":
                   setYearLabel(name: touchedNode.name ?? "")
               case "3":
                   setYearLabel(name: touchedNode.name ?? "")
               case "4":
                   setYearLabel(name: touchedNode.name ?? "")
               case "5":
                   setYearLabel(name: touchedNode.name ?? "")
               case "6":
                   setYearLabel(name: touchedNode.name ?? "")
               case "7":
                   setYearLabel(name: touchedNode.name ?? "")
               case "8":
                   setYearLabel(name: touchedNode.name ?? "")
               case "9":
                   setYearLabel(name: touchedNode.name ?? "")
               
               case "Exit":
                   removePopup()
               
               case "Remove":
                   yearLabel.text = ""
               
           case "Done":
               let date = NSDate()
               let newFormatter = DateFormatter()
               newFormatter.dateFormat = "YYYY"
               let currentYear: Int! = Int(newFormatter.string(from: date as Date))

               let year: Int! = Int(yearLabel.text ?? "")
               
               if ((currentYear != nil && year != nil) ) {
                  if ((currentYear - year) > 15 && (currentYear - year) < 105) {
                     /*  GameViewController.appStoreConnector.purchaseAdRemoval()
                       GameViewController.appStoreConnector.restorePurchases()
                       if (GameViewController.appStoreConnector.isRemoveAdsPurchased()) {
                           GameViewController.bannerView.isHidden = true
                           GameViewController.bannerView.removeFromSuperview()
                           self.childNode(withName: "RemoveAds")?.run(SKAction.hide())
                       }*/
                       removePopup()
                       
                   } else {
                       yearLabel.text = ""
                   }
               }
               
               case .none:
                   return
               case .some(_):
                   return
           }
       }
       
       func setYearLabel (name: String) {
           if (yearLabel.text?.count ?? 0 < 4) {
               yearLabel.text! += name
           }
       }
       
       func removePopup () {
           yearLabel.text = ""
           self.childNode(withName: "Popup")?.run(SKAction.hide())
       }

}
