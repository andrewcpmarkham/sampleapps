//
//  ViewController.swift
//  WordMatchingGame
//
//  Created by Andrew CP Markham on 2/4/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //OUTLETS
    //# of outlets needs to match # of images and elements of listOfAnimals array
    @IBOutlet var imageButtons: [UIButton]!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var topScore: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!

    
    //let noOfChoices: Int!
    var currentGame: Game!

    //MAIN FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentGame = Game()
        setButtonImages()
        setGame()
    }
    
    
    //SETTERS
    func setButtonImages(){
        //Formats the layout butons for use
        var imageName: String
        for (imageButton) in self.imageButtons {
            imageName = currentGame.listOfAnimals[imageButton.tag]//has to use tag as Outlet doesn't necessary add to button array in order of linked
            
            //Image Formatting
            imageButton.setImage(UIImage(named: imageName), for: .normal)//array needs to match image names in assets
            //imageButton.setBackgroundImage(UIImage(named: imageName), for: .normal)//array needs to match image names in assets
            imageButton.imageView?.contentMode = .scaleAspectFit
            
            imageButton.layer.borderWidth = 2.0
            imageButton.layer.cornerRadius = 10.0
            imageButton.layer.borderColor = UIColor.black.cgColor
        
        }
        playAgainButton.layer.borderWidth = 2.0
        playAgainButton.layer.cornerRadius = 10.0
        playAgainButton.layer.borderColor = UIColor.black.cgColor
        playAgainButton.isHidden = true
    }
    
    func setScores() {
        //Used to modify the score label outlet
        score.text = "Score: \(currentGame.scoreTotal)"
        topScore.text = "Top Score: \(currentGame.topScore)"
    }
    
    func setWordName(textString: String) {
        //Used to modify the animal label outlet
        animalName.text = textString
        
        animalName.layer.masksToBounds = true
        animalName.layer.borderWidth = 2.0
        animalName.layer.cornerRadius = 10.0
        animalName.layer.borderColor = UIColor.black.cgColor
    }
    
    func setGame(){
        //used to setup the game in one call
        setScores()
        setWordName(textString: currentGame.gameWordList[0])//First One
    }
    
    func setButtonAvailability(buttonsEnabled: Bool){
        //Used to set the buttons of the game
        for imageButton in imageButtons{
            imageButton.isEnabled = buttonsEnabled
        }
        playAgainButton.isHidden = buttonsEnabled
    }
    
    //ACTIONS
    @IBAction func imagePressed(_ sender: UIButton) {
        //Action initiated by pressing a imagebutton.
        //One function for all
        if currentGame.listOfAnimals[sender.tag]  == currentGame.gameWordList[currentGame.currentChoice]{
            currentGame.scoreTotal += 1
            setScores()
        }
        currentGame.currentChoice += 1
        
        //Game Over
        if currentGame.noOfChoices == currentGame.currentChoice{
            setWordName(textString: "Game Over")
            
            //disable all buttonactions
            setButtonAvailability(buttonsEnabled: false)
        }else{
            setWordName(textString: currentGame.gameWordList[currentGame.currentChoice])
        }
    }
    
    @IBAction func tryAgainGame(_ sender: UIButton) {
        //Action to inticiate a new game
        currentGame.resetGame()
        setGame()
        setButtonAvailability(buttonsEnabled: true)
    }
}

