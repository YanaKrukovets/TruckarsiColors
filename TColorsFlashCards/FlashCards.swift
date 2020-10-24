//
//  FlashCards.swift
//  ShapesFlashCards
//
//  Created by Yana  on 2020-09-24.
//  Copyright © 2020 Yana . All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class FlashCards: SKScene {
    
    private var shapeNumber = 0           // number of active card
    var frameWidth: CGFloat = 0.0
    private var languageButton: SKNode!
    private var nameLabel: SKLabelNode!           // shape name label
    public var presentScene: String = ""
    private let swipeLeftRec = UISwipeGestureRecognizer() //left swipe
    private let swipeRightRec = UISwipeGestureRecognizer()  //right swipe
    private var cards: Cards = Cards(width: 0.0, lang: "Russian", presentScene: "")

    func showAndSpeakCardName () { // Show and speak active card name
        let nameCard = cards.getName(card: cards.activeCard)
        
        showCardName (name: nameCard.name, rate: 0.4, pitchMultiplier: 1.5, language: nameCard.language)
    }
    
    // adds language button
    func addLanguageButtonNode (name: String) {
        languageButton = self.childNode(withName: name)
        languageButton.run(SKAction.unhide())
    }
    
    //change language and active/inactive language buttons
    func changeLanguageButton (name: String, touchedNode: SKNode) {
        languageButton.run(SKAction.hide())
        addLanguageButtonNode (name: cards.language + "Button")
        addLanguageButtonNode (name: name + "Active")
        touchedNode.run(SKAction.hide())
        cards.language = name
        showAndSpeakCardName () // speak card name
    }
    
    // returns bool answer for question
    func isActiveCard (name: String) -> Bool {
        var isActive: Bool = true
        for card in cards.arrayQuestions {
            if (name == card.node.name && name != cards.activeCard.node.name) {
                isActive = false
            }
        }
        return isActive
    }
    
    // returns touched name of node
    func getTouchedName (touchedNode: SKNode) -> String {
        var name: String? = touchedNode.name
        
        if (touchedNode.name == nil) {
            name = touchedNode.parent?.name
        }
        return name ?? ""
    }
    
    func changeArrowButton () { //hide/unhide arrow button
        let leftMoveButton: SKNode = self.childNode(withName: "LeftMoveButton") ?? SKNode ()
        let rightMoveButton: SKNode = self.childNode(withName: "RightMoveButton") ?? SKNode ()
        switch shapeNumber {
            case 1:
                leftMoveButton.run(SKAction.unhide())
        case (cards.arrayOfCards.count - 1):
                rightMoveButton.run(SKAction.hide())
        case (cards.arrayOfCards.count - 2):
                rightMoveButton.run(SKAction.unhide())
            case 0:
                leftMoveButton.run(SKAction.hide())
            default:
                leftMoveButton.run(SKAction.unhide())
        }
    }
    
    //question game animations and audio
    func questionGame (name: String) {
        if (name == cards.activeCard.node.name) {
                self.isUserInteractionEnabled = false
                audio.playSound(fileName: "Sound/success", type: "mp3", volume: 1, loop: 0)
                if let particles = SKEmitterNode(fileNamed: "success.sks") {
                    particles.position = cards.activeCard.node.position
                    addChild(particles)
                }
            cards.arrayQuestions[0].node.run(SKAction.wait(forDuration: 4.0), completion:{
                    self.cards.removeQuestions ()
                    self.cards.createQuestionsArray ()
                    self.viewQuestionCards()
                    self.isUserInteractionEnabled = true
                })
                
            } else if (!isActiveCard (name: name)) {
                audio.playSound(fileName: "Sound/fail", type: "mp3", volume: 1, loop: 0)
            }
        }
    
    //detect touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        let name: String! = getTouchedName (touchedNode: touchedNode)
        
        if (presentScene == "Question") {
            questionGame (name: name)
        }
        
        switch name {
            case "RightMoveButton":
                swipeLeft()
            
            case "LeftMoveButton":
                swipeRight()
            
            case "EnglishButton":
                changeLanguageButton (name: "English", touchedNode: touchedNode)
        
            case "RussianButton":
                changeLanguageButton (name: "Russian", touchedNode: touchedNode)
        
            case "FranchButton":
               changeLanguageButton (name: "Franch", touchedNode: touchedNode)
            
            case "HomeButton":
               audio.resumeMusic()
                _ = SKTransition.fade(withDuration: 3.0)
               let nextScene = SKScene(fileNamed: "GameScene")
               nextScene?.scaleMode = .aspectFill
               view?.presentScene(nextScene)
            
            case "AudioButton":
                let nameCard = cards.getName(card: cards.activeCard)
                speakCard (rate: 0.4, pitchMultiplier: 1.5, language: nameCard.language, text: nameCard.name)
            
            case .none:
               return
            case .some(_):
               return
        }
    }
    
    func setPosition () { //set position to questions card
        let width: CGFloat = frameWidth/6
        let height: CGFloat = self.frame.height
        
        cards.arrayQuestions[0].node.position = CGPoint(x: width, y: height/8)
        cards.arrayQuestions[1].node.position = CGPoint(x: -width, y: -height/6 + 5)
        cards.arrayQuestions[2].node.position = CGPoint(x: -width, y: height/8)
        cards.arrayQuestions[3].node.position = CGPoint(x: width, y: -height/6 + 5)
    }
    
    func swipeTargetRight () {
        swipeRightRec.addTarget(self, action: #selector(FlashCards.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
    }
    
    func swipeTargetLeft () {
        swipeLeftRec.addTarget(self, action: #selector(FlashCards.swipedLeft) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
    }
    
    override func didMove(to view: SKView) {
        frameWidth = self.frame.width
        cards = Cards(width: frameWidth, lang: "Russian", presentScene: presentScene)
        cards.activeCard = cards.arrayOfCards[shapeNumber]
        audio.stopMusic()
        languageButton = self.childNode(withName: "RussianActive")
        nameLabel = self.childNode(withName: "CardName") as? SKLabelNode
        if (presentScene == "Cards") {
            swipeTargetRight()
            swipeTargetLeft()
            moveCardToCenter()
        } else {
            self.childNode(withName: "RightMoveButton")?.run(SKAction.hide())
            cards.createQuestionsArray()
            viewQuestionCards()
        }
    }
    
    func viewQuestionCards () {
        setPosition()
        for item in cards.arrayQuestions {
            self.addChild(item.node)
        }
        cards.activeCard = cards.getActiveCard()
        let nameCard = cards.getName(card: cards.activeCard)
        showCardName (name: nameCard.name, rate: 0.4, pitchMultiplier: 1.5, language: nameCard.language)
    }
    
    func swipeRight() {
        if (shapeNumber > 0 ) {
             moveCardOut (x: Int(frameWidth), side: 1)
         }
    }
    
    func swipeLeft() {
        if (shapeNumber < cards.arrayOfCards.count - 1) {
            moveCardOut (x: -Int(frameWidth), side: -1)
        }
    }
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        swipeRight()
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        swipeLeft()
    }

    func showCardName (name: String, rate: Float, pitchMultiplier: Float, language: String) { //speack card name and show label name
        nameLabel.text =  name
        nameLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.unhide()]),
              completion: {
                self.speakCard (rate: rate, pitchMultiplier: pitchMultiplier, language: language, text: name)
        })
    }
    
    func moveCardToCenter () {
        let moveDuration = 1.0
        let moveAction = SKAction.move(to: CGPoint(x: 0.5, y: -10), duration: moveDuration)
        if (!cards.arrayOfCards[shapeNumber].isCreate) {
            self.addChild(cards.arrayOfCards[shapeNumber].node)
            cards.arrayOfCards[shapeNumber].isCreate = true
        }
        cards.arrayOfCards[shapeNumber].node.run(moveAction)
        showAndSpeakCardName()
    }
    
    func iteractionsEnabled (enabled: Bool) {
        self.isUserInteractionEnabled = enabled
        self.swipeLeftRec.isEnabled = enabled
        self.swipeRightRec.isEnabled = enabled
    }
    
    func moveCardOut (x: Int, side: Int) {
        let moveAction = SKAction.move(to: CGPoint(x: x, y: -10), duration: 1.0)
        iteractionsEnabled(enabled: false)
        nameLabel.run(SKAction.hide())
            cards.arrayOfCards[shapeNumber].node.run(moveAction, completion: { [self] in
                self.shapeNumber += (-1 * side)
                self.changeArrowButton () // changebutton
                self.cards.activeCard = self.cards.arrayOfCards[self.shapeNumber] // change active card
                self.moveCardToCenter()   // move card to center
                self.iteractionsEnabled(enabled: true)
            })
    }
    
    func speakCard (rate: Float, pitchMultiplier: Float, language: String, text: String) { // speack card name
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = rate
        speechUtterance.pitchMultiplier = pitchMultiplier
        speechUtterance.volume = 1
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)

         let speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.speak(speechUtterance)
    }
}
