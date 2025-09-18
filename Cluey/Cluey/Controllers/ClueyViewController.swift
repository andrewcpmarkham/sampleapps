//
//  ClueyViewController.swift
//  Cluey
//
//  Created by Andrew CP Markham on 6/8/2022.
//

import UIKit

struct ClueyViewControllerPropertyKeys {
    static let Answer1Segue = "Answer1Segue"
    static let Answer2Segue = "Answer2Segue"
    static let Answer3Segue = "Answer3Segue"
    static let SkipSegue = "SkipSegue"
    static let unwindToClueyViewController = "unwindToClueyViewController"
}

class ClueyViewController: UIViewController {

// MARK: - IBOutlets

    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!

    var currentQuestion: Question?
    var requestController: ResquestController!
    var quizController = QuizController()

    // MARK: - TO DO
    // Adjust autolayout for device rotation
    // Adjust for darkmode and Accessibility
    // Unit Testing
    // Implement SWIFTLINT for project


    override func viewDidLoad() {
        super.viewDidLoad()

        requestController = ResquestController(delegate: self)
        requestController.performRequest(for: quizController.getNextQuestion())

        setup()
    }

    // MARK: - Functions

    /// General Interface setup and modifications
    func setup() {
        // MARK: - TO DO
        // Force align button text to centre
        // Format the progress bar track to have a border

        // Image Setting
        headlineImage.layer.cornerRadius = 5
        headlineImage.clipsToBounds = true

        // ProgressBar Setting
        progressView.transform = CGAffineTransform(scaleX: 1, y: 1.2 )

        updatePoints()
    }

    func updatePoints() {
        pointsLabel.text = "\(quizController.getScore())"
    }

    // MARK: - IBActions
    @IBAction func unwindToClueyViewController(__ seg: UIStoryboardSegue) {
        requestController.performRequest(for: quizController.getNextQuestion())
        updatePoints()
    }

    // MARK: - Seque

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Transition to favourite on load means Forecast locaation may not be set
        if  let destination = segue.destination as? ResultViewController {
            switch segue.identifier {
            case ClueyViewControllerPropertyKeys.Answer1Segue:
                destination.answerCorrect = currentQuestion?.correctAnswerIndex == 0
            case ClueyViewControllerPropertyKeys.Answer2Segue:
                destination.answerCorrect = currentQuestion?.correctAnswerIndex == 1
            case ClueyViewControllerPropertyKeys.Answer3Segue:
                destination.answerCorrect = currentQuestion?.correctAnswerIndex == 2
            default:
                destination.answerCorrect = nil
            }
            destination.quizController = quizController
            destination.correctQuestion = currentQuestion
            quizController.setNextQuestionIndex()
            quizController.uppdateScore(correct: destination.answerCorrect)
        }
    }

}

// MARK: - QuizManagerDelegate

extension ClueyViewController: QuizManagerDelegate {
    func didUpdateTotalQuestions(to totalQuestions: Int) {
        quizController.setTotalQuestions(to: totalQuestions)
    }


    func didUpdateQuiz(question: Question) {
        DispatchQueue.main.async {
            self.currentQuestion = question
            self.answer1Button.setTitle(question.headlines[0], for: .normal)
            self.answer2Button.setTitle(question.headlines[1], for: .normal)
            self.answer3Button.setTitle(question.headlines[2], for: .normal)
            self.progressView.progress = Float(self.quizController.getNextQuestion() - 1) / Float(self.quizController.getTotalQuestions())
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }

    func didUpdateQuestionImage(with image: UIImage) {
        DispatchQueue.main.async {
            self.headlineImage.image = image
        }
    }
}

