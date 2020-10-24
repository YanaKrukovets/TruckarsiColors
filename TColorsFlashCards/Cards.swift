//
//  Cards.swift
//  AShapesFlashCards
//
//  Created by Yana  on 2020-10-15.
//  Copyright © 2020 Yana . All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

public class Cards {
        
    struct SpeakCard  {               // Card Name for different languages
        var name: String!
        var language: String!
    }
    
    public struct Card  {               // Card
        var node: SKNode
        var nameEng: String!
        var nameFr: String!
        var nameRus: String!
        var isCreate: Bool!
    }
    
    private var scene: String = ""   //cards or question scene
    public var language: String = ""
    public var arrayOfCards: [Card] = []    // all cards
    private var frameWidth: CGFloat = 0.0
    public var arrayQuestions: [Card] = []     // question cards for single question
    public var activeCard: Card = Card(node: SKNode(), nameEng: "", nameFr: "", nameRus: "", isCreate: false)    //active card on the screen or right answer
    
    init (width: CGFloat, lang: String, presentScene: String) {
        
        language = lang
        frameWidth = width
        scene = presentScene
        arrayOfCards = [Card(node: getCard(nameCard: "White"), nameEng: "White", nameFr: "Blanche", nameRus: "Белый", isCreate: false),
                        Card(node: getCard(nameCard: "Red"), nameEng: "Red", nameFr: "Rouge", nameRus: "Красный", isCreate: false),
                        Card(node: getCard(nameCard: "Blue"), nameEng: "Blue", nameFr: "Bleue", nameRus: "Синий", isCreate: false),
                        Card(node: getCard(nameCard: "Grey"), nameEng: "Grey", nameFr: "Grise", nameRus: "Серый", isCreate: false),
                        Card(node: getCard(nameCard: "Green"), nameEng: "Green", nameFr: "Verte", nameRus: "Зеленый", isCreate: false),
                        Card(node: getCard(nameCard: "Pink"), nameEng: "Pink", nameFr: "Rose", nameRus: "Розовый", isCreate: false),
                        Card(node: getCard(nameCard: "Purple"), nameEng: "Purple", nameFr: "Violette", nameRus: "Фиолетовый", isCreate: false),
                        Card(node: getCard(nameCard: "Brown"), nameEng: "Brown", nameFr: "Marron", nameRus: "Коричневый", isCreate: false),
                        Card(node: getCard(nameCard: "Black"), nameEng: "Black", nameFr: "Noire", nameRus: "Черный", isCreate: false),
                        Card(node: getCard(nameCard: "Yellow"), nameEng: "Yellow", nameFr: "Jaune", nameRus: "Желтый", isCreate: false),
                        Card(node: getCard(nameCard: "Orange"), nameEng: "Orange", nameFr: "Orange", nameRus: "Оранжевый", isCreate: false)]
    }
   
    func getCard (nameCard: String) -> SKNode { // create and return cardNode
        let node: SKNode = SKNode()
        let textureCard = SKTexture(imageNamed: "Card")
        let textureShape = SKTexture(imageNamed: nameCard)
        let cardSpriteNode = getSpriteNode(texture: textureCard, len: -15)
        let shapeSpriteNode = getSpriteNode(texture: textureShape, len: 70)
        
        cardSpriteNode.zPosition = 1.0
        shapeSpriteNode.zPosition = 3.0
        node.addChild(cardSpriteNode)
        node.addChild(shapeSpriteNode)
        node.position = CGPoint(x: frameWidth, y: -10)
        return node
    }
    
    //creates card size
    func getSpriteNode (texture: SKTexture, len: CGFloat) -> SKSpriteNode {
        let spriteNode = SKSpriteNode(texture: texture)
        let width: CGFloat = spriteNode.frame.width
        let height: CGFloat = spriteNode.frame.height
    
        if (scene == "Cards") {
            spriteNode.size = CGSize(width: width + len, height: height + len)
        }
        else {
            spriteNode.size = CGSize(width: (width + len)/2, height: (height + len)/2)
        }
        return spriteNode
    }
    
    func getName (card: Card) -> SpeakCard {       // return name of card and language speak for different languages
        var languageCard = SpeakCard(name: "", language: "")
       
        switch language {
            case "Russian":
                languageCard = getLanguageCard (name: card.nameRus, language: "ru-RU")
            case "English":
                languageCard = getLanguageCard (name: card.nameEng, language: "en-IE")
            case "Franch":
                 languageCard = getLanguageCard (name: card.nameFr, language: "fr-CA")
            default:
                languageCard = getLanguageCard (name: card.nameRus, language: "ru-RU")
        }
        return languageCard
    }
    
    func getLanguageCard (name: String, language: String) -> SpeakCard { // return name and language of the card
        var languageCard = SpeakCard(name: "", language: "")
        
        languageCard.name = name
        languageCard.language = language
        return languageCard
    }
    
    // create random 4 cards for question
    func createQuestionsArray () {
        var index: Int = 0
        arrayOfCards.shuffle()

        while (index < 4) {
            arrayQuestions.append(arrayOfCards[index])
            arrayQuestions[index].node.name = arrayOfCards[index].nameEng
            index += 1
        }
    }
    
    //return active card, answer card for question
    func getActiveCard () -> Card {
        let name = activeCard.node.name
        let count = arrayQuestions.count
        var randomNumber = Int.random(in: 0..<count)
        
        if (name != arrayQuestions[randomNumber].node.name) {
            return arrayQuestions[randomNumber]
        } else {
            if (randomNumber == count - 1) {
                randomNumber = 0
            }
            return arrayQuestions[randomNumber + 1]
        }
    }
    
    // clean question cards
    func removeQuestions () {
        for item in arrayQuestions {
            item.node.removeFromParent()
        }
        arrayQuestions.removeAll()
    }
}


