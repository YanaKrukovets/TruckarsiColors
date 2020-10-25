//
//  HalfBird.swift
//  TColorsFlashCards
//
//  Created by Yana  on 2020-10-24.
//  Copyright © 2020 Yana . All rights reserved.
//

import Foundation
import SpriteKit

class HalfBird: SKScene {
    
    private var positionX: CGFloat = 0.0
    private var positionY: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        let rightHand = self.childNode(withName: "RightHand")!
        let leftHand = self.childNode(withName: "LeftHand")!
        audio.resumeMusic()
        positionX = (rightHand.position.x + leftHand.position.x)/2
        positionY = (rightHand.position.y + leftHand.position.y)/2 - 20
        let cropNode = SKCropNode()
        let texture = SKTexture(imageNamed: "Yellow")
        cropNode.position = CGPoint(x: 50, y: 50)
        cropNode.maskNode = SKSpriteNode(texture: texture)
        var childNode = SKSpriteNode()
        childNode = SKSpriteNode(texture: texture)
        childNode.position = CGPoint(x: 0, y: -90)
        childNode.zPosition = 10
        
        cropNode.addChild(childNode)
        cropNode.zPosition = 10
        self.addChild(cropNode)
        //addShape ()
    }
}
