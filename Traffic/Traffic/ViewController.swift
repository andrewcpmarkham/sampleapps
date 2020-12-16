//
//  ViewController.swift
//  Traffic
//
//  Created by Andrew CP Markham on 8/2/20.
//  Copyright © 2020 Andrew Markham. All rights reserved.
//
// Version 1.0.0
// Tested on iPhone 8*, iPhone XR, iPhone 11*

import UIKit

class ViewController: UIViewController {

    var lighton: Int = 0
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var sideImage: UIImageView!
    @IBOutlet weak var textBlock1: UILabel!
    @IBOutlet weak var textBlock2: UILabel!
    @IBOutlet weak var textBlock3: UILabel!
    @IBAction func buttonPressed(_ sender: Any) {
        lighton = lighton >= 3 ?  1 : lighton + 1
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         updateUI()
    }

    /// Function to update screen elements based on lighton variable
    func updateUI(){
        switch lighton {
        case 1:
            view.backgroundColor = .green
            headerImage.image = UIImage(named: "Header_2")!
            sideImage.image = UIImage(named: "Light_green")!
            bodyImage.image = nil
            textBlock1.text = ""
            textBlock2.textColor = .black //white is hard to see on green
            textBlock2.text = "Click again for next light colour"
            textBlock3.textColor = .black
            textBlock3.text = "Definitely everyone's favorite traffic light. Green means it is safe to drive through the intersection!"
        case 2:
            view.backgroundColor = .orange
            headerImage.image = UIImage(named: "Header_3")!
            sideImage.image = UIImage(named: "Light_amber")!
            textBlock1.text = ""
            textBlock2.textColor = .white
            textBlock2.text = "Click again for next light colour"
            textBlock3.textColor = .white
            textBlock3.text = "Amber is the tricky light. It signals the approach of red, and means you must slow down to a stop before the intersection if safe to do so."
        case 3:
            view.backgroundColor = .red
            headerImage.image = UIImage(named: "Header_4")!
            sideImage.image = UIImage(named: "Light_red")!
            textBlock1.text = ""
            textBlock2.text = "Click again for next light colour"
            textBlock3.text = "Red means stop, you have no right of way to cross the intersection. You must wait until the light turns green."
        default:
            view.backgroundColor = .black
            headerImage.image = UIImage(named: "Header_1")!
            bodyImage.image = UIImage(named: "LightsAsText")!
            textBlock1.text = "Traffic lights are used at road intersections to help drivers know when it is safe (or not) to move onwards. They control the flow of traffic using three colour coded lights."
            textBlock2.text = "Click anywhere on the screen to learn the sequence of traffic lights."
            textBlock3.text = ""
        }
    }
}

