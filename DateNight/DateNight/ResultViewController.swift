//
//  ResturantResultViewController.swift
//  DateNight
//
//  Created by Andrew CP Markham on 9/6/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    //OUTLETS
    @IBOutlet weak var resultsAnswerHeading: UILabel!
    @IBOutlet weak var resultsAnswerLabel: UILabel!
    @IBOutlet weak var resultAnswerFitPercent: UILabel!
    @IBOutlet weak var resultAnswerDescription: UILabel!
    @IBOutlet weak var resultAnswerAddress: UILabel!
    @IBOutlet weak var resultAnswerAddressStack: UIStackView!
    @IBOutlet weak var resultAnswerPhone: UILabel!
    @IBOutlet weak var resultAnswerImage: UIImageView!
    @IBOutlet weak var resultAnswerPhoneStack: UIStackView!
    
    //PRIVATE AND COMPUTED PROPERTIES
    var responses: [Answer]!
    
    //LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        calculateRestaurantOrMovieResult()
    }
    
    //CLASS METHODS
    func calculateRestaurantOrMovieResult(){

        
        if let responsesCasted = responses as? [RestaurantAnswer]{
            //As frequencyOfAnswers is a Dictionary, the order isn't guarenteed
            //Meaning the recomendation will change for the same responses when there are >1 Restaurants/Movies with the same # of of times being an answer response.
            var frequencyOfAnswers: [Resturant: Int] = [:]
            let responseTypes = responsesCasted.map { $0.restaurantType }
            
            for responseArray in responseTypes{
                for response in responseArray{
                   frequencyOfAnswers[response] = (frequencyOfAnswers[response] ?? 0) + 1
                }
            }
            
            let frequentAnswersSorted = frequencyOfAnswers.sorted(by:
            { (pair1, pair2) -> Bool in
                return pair1.value > pair2.value
            })
            let mostCommonAnswer = frequentAnswersSorted.first!.key
            
            //Update the data fields
            resultsAnswerHeading.text = "You might like"
            resultsAnswerLabel.text = "\(mostCommonAnswer.definition[0])"
            resultAnswerFitPercent.text = "\(Int( Float(frequentAnswersSorted.first!.value) / 4.0 * 100 ))% match"
            resultAnswerDescription.text = "\(mostCommonAnswer.definition[1])"
            resultAnswerAddress.text = "\(mostCommonAnswer.definition[2])"
            resultAnswerPhone.text = "\(mostCommonAnswer.definition[3])"
            resultAnswerImage.image = UIImage(named: mostCommonAnswer.definition[4])
            
            //View Element Formatting
            resultAnswerImage.layer.borderWidth = 2.0
            resultsAnswerHeading.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 3.0)
            resultAnswerDescription.layer.addBorder(edge: .top, color: .lightGray, thickness: 3.0)
            
        }else if let responsesCasted = responses as? [MovieAnswer]{
            var frequencyOfAnswers: [Movie: Int] = [:]
            let responseTypes = responsesCasted.map { $0.movieType }
            
            
            for responseArray in responseTypes{
                for response in responseArray{
                   frequencyOfAnswers[response] = (frequencyOfAnswers[response] ?? 0) + 1
                }
            }
            
            let frequentAnswersSorted = frequencyOfAnswers.sorted(by:
            { (pair1, pair2) -> Bool in
                return pair1.value > pair2.value
            })
            let mostCommonAnswer = frequentAnswersSorted.first!.key
            
            //Update the data fields
            resultsAnswerHeading.text = "You might like"
            resultsAnswerLabel.text = "\(mostCommonAnswer.definition[0])"
            resultAnswerFitPercent.text = "\(Int( Float(frequentAnswersSorted.first!.value) / 4.0 * 100 ))% match"
            resultAnswerDescription.text = "\(mostCommonAnswer.definition[1])"
            resultAnswerAddress.isHidden = true
            resultAnswerAddressStack.isHidden = true
            resultAnswerPhone.isHidden = true
            resultAnswerPhoneStack.isHidden = true
            resultAnswerImage.image = UIImage(named: mostCommonAnswer.definition[2])
            
            //View Element Formatting
            resultAnswerImage.layer.borderWidth = 2.0
            resultsAnswerHeading.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 3.0)
            resultAnswerDescription.layer.addBorder(edge: .top, color: .lightGray, thickness: 3.0)
        }
    }
}

//VIEW OVERRIDEN METHODS
extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: -4.0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height + 2.0, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }

}
