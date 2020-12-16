//
//  ViewControllerStart.swift
//  WordMatchingGame
//
//  Created by Andrew CP Markham on 6/4/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit
class ViewControllerStart: UIViewController {
    //OUTLETS
    @IBOutlet weak var startGameButton: UIButton!
    
    
    //MAIN FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setButtonImages()
    }
    
    //SETTERS
    func setButtonImages(){
        //Formats the layout butons for use
        startGameButton.layer.borderWidth = 2.0
        startGameButton.layer.cornerRadius = 10.0
        startGameButton.layer.borderColor = UIColor.black.cgColor
    }
    
}
