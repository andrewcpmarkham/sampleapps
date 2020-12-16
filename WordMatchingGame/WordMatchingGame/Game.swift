//
//  Game.swift
//  WordMatchingGame
//
//  Created by Andrew CP Markham on 2/4/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import Foundation

class Game{
    //MAIN VARIABLES
    let listOfAnimals: [String] = ["Cat", "Owl", "Jellyfish", "Dog", "Octopus", "Peacock", "Fish", "Duck", "Frog"]//based off images and needs to match
    var gameWordList: [String]!
    var scoreTotal = 0
    var noOfChoices: Int!
    var currentChoice = 0
    var topScore = 0
    
    //ititialise game with shuffled list of items
    init() {
        self.noOfChoices = listOfAnimals.count
        self.gameWordList =  listOfAnimals.shuffled()
    }
    
    func resetGame(){
        self.gameWordList =  listOfAnimals.shuffled()//Reshuffle of self
        currentChoice = 0
        topScore = topScore < scoreTotal ? scoreTotal : topScore
        scoreTotal = 0
    }
    
}


