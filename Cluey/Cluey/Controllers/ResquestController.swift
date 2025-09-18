//
//  ResquestController.swift
//  Cluey
//
//  Created by Andrew CP Markham on 7/8/2022.
//

import UIKit

protocol QuizManagerDelegate {
    func didUpdateQuiz(question: Question)
    func didUpdateTotalQuestions(to totalQuestions: Int)
    func didFailWithError(error: Error)
    func didUpdateQuestionImage(with image: UIImage)
}

/// The quiz class is responsible for retrieval of data from the cloud storage feed and parsing the data to appropriate storage for use
struct ResquestController {

    // REMEMBER THERE ARE TOKENS HERE TO BE HANDLED
    private let dailyQuizURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/nca-dna-apps-dev.appspot.com/o/game.json")
    private let query: [String : String] = [
        "alt": "media",
        "token": "e36c1a14-25d9-4467-8383-a53f57ba6bfe"
    ]

    private var delegate: QuizManagerDelegate

    init(delegate: QuizManagerDelegate) {
        self.delegate = delegate
    }

    // MARK: - Request Functions

    /// Make the request to the data servicce for quiz data
    func performRequest(for questionIndex: Int) {
        guard let url = dailyQuizURL?.withQueries(query) else {
            fatalError("Query applied to Base URL failed")
        }

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate.didFailWithError(error: error!)
            }

            if let safeData = data {
                if let questionResponse = self.parseJSON(safeData, for: questionIndex) {
                    delegate.didUpdateQuiz(question: questionResponse)
                    getQuizImage(from: questionResponse.imageUrl)
                }
            }
        }
        task.resume()
    }


    /// Process the JSON data recieved into data structure applicable to app
    func parseJSON(_ quizData: Data, for questionIndex: Int) -> Question? {

        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(QuizData.self, from: quizData)
            let totalQuestions = decodedData.resultSize
            let items = decodedData.items

            if questionIndex < totalQuestions {
                // populate the question
                let questionData = items[questionIndex]
                self.delegate.didUpdateTotalQuestions(to: totalQuestions)

                return Question(
                    correctAnswerIndex: questionData.correctAnswerIndex,
                    imageUrl: questionData.imageUrl,
                    standFirst: questionData.standFirst,
                    storyUrl: questionData.storyUrl,
                    section: questionData.section,
                    headlines: questionData.headlines
                )
            }

            return nil

        } catch {
            delegate.didFailWithError(error: error)
            return nil
        }

    }

    /// Make the request for the applicable image to be presented
    func getQuizImage (from imageURL: String) {

        guard let url = URL(string: imageURL) else {
            return
        }
        // Upgrading image transport to secure https
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.scheme = "https"
        guard let httpsURL = urlComponents.url else {
            return
        }
        let task = URLSession.shared.dataTask(
            with: httpsURL, completionHandler: { (data, _, _ ) in
                guard let data = data, let image = UIImage(data: data) else {return}
                delegate.didUpdateQuestionImage(with: image)
        })
        task.resume()
    }
}
