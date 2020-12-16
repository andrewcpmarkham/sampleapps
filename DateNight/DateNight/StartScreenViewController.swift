//
//  ViewController.swift
//  DateNight
//
//  Created by Andrew CP Markham on 24/5/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    //OUTLETS
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    
    //LIFESCYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElementStyles()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //tageting Question View Controller for setting element
        let questionNavController = segue.destination as! UINavigationController
        let questionViewController = questionNavController.topViewController as! QuestionViewController
        
        if segue.identifier == "RestaurantSegue"{
            questionViewController.questionTopic = "Restaurant"
        }else{
            questionViewController.questionTopic = "Movie"
        }
    }
    
    //ACTIONS
    @IBAction func restaurantButtonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "restaurant", sender: nil)
    }
    
    @IBAction func barButtonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "bar", sender: nil)
    }
    
    @IBAction func unwindToIntroduction(segue: UIStoryboardSegue){
        
    }
    
    //CLASS METHODS
    func setElementStyles() {

        //set style of buttons
        restaurantButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        restaurantButton.roundedLeftButton()

        movieButton.contentEdgeInsets =  UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 20)
        movieButton.roundedRightButton()

    }
}


//VIEW OVERRIDEN METHODS
extension UIButton{
    func roundedLeftButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft , .bottomLeft],cornerRadii: CGSize(width: 10, height: 10))
    
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedRightButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight , .bottomRight],cornerRadii: CGSize(width: 10, height: 10))
    
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

