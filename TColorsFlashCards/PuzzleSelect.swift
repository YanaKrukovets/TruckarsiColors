//
//  PuzzleSelect.swift
//  TColorsFlashCards
//
//  Created by Yana  on 2020-10-24.
//  Copyright © 2020 Yana . All rights reserved.
//

import Foundation
import SpriteKit

 class PuzzleSelect: SKScene {
    
    //goes to home screen
    @objc func goToHome (scene: String) {
        _ = SKTransition.fade(withDuration: 3.0)
        let nextScene = SKScene(fileNamed: scene)
        nextScene?.scaleMode = .aspectFill
        view?.presentScene(nextScene)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          guard let touch = touches.first else {
              return
          }
          
          let touchLocation = touch.location(in: self)
          let touchedNode = self.atPoint(touchLocation)
       
        switch touchedNode.name {
        case "HomeButton":
            goToHome (scene: "GameScene")
        case "Owl":
            goToHome (scene: "Puzzle")
        case "House":
            goToHome (scene: "House")
        case "HalfBird":
            goToHome (scene: "HalfBird")
        case "Car":
            goToHome (scene: "Car")
        case "Remember":
            goToHome (scene: "Remember")
            
        default:
            return
        }
      }
}
      
