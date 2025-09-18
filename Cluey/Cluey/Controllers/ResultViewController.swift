//
//  ResultViewController.swift
//  Cluey
//
//  Created by Andrew CP Markham on 7/8/2022.
//

import UIKit
import SafariServices

class ResultViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var standFirstLabel: UILabel!

    var answerCorrect: Bool?
    var quizController: QuizController!
    var correctQuestion: Question!

    override func viewDidLoad() {
        super.viewDidLoad()



        setupView()
    }

    // MARK: - Functions

    func setupView(){
        setUpLabels()
    }

    func setUpLabels() {

        // First Label
        let points = quizController.getScore()

        guard let answerCorrect = answerCorrect else {
            scoreLabel.text = "The correct one was \(correctQuestion.correctAnswerIndex + 1)"
            return
        }

        if answerCorrect {
            scoreLabel.text = "THAT'S RIGHT YOU HAVE \(points) POINTS"
        } else {
            scoreLabel.text = "THATS WRONG YOU HAVE \(points) POINTS"
            scoreLabel.backgroundColor = .red
        }

        // Seond Label
        self.standFirstLabel.text = correctQuestion.standFirst
        
    }

    // MARK: - IBActions

    @IBAction func readArticleButtonTapped(_ sender: UIButton) {
        // MARK: - TO DO: Implement WebView Here

        if let url = URL(string: correctQuestion.storyUrl) {
            let safariVeiwController = SFSafariViewController(url: url)
            present(safariVeiwController, animated: true)
        }
    }
    @IBAction func nextQuestionButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: ClueyViewControllerPropertyKeys.unwindToClueyViewController, sender: self)
    }
    @IBAction func leaderBoardButtonTapped(_ sender: UIButton) {
        // MARK: - TO DO: Implement Leaderboard here
        // Effectively do a web handoff here like in previous action
    }
}
