//
//  QuizController.swift
//  Cluey
//
//  Created by Andrew CP Markham on 8/8/2022.
//

import Foundation

struct QuizControllerPropertyKeys {
    static let questionsAnsweredKey = "questionsAnsweredKey"
    static let scoreKey = "scoreKey"
}

class QuizController {
    private var totalQuestions: Int = 0
    private var questionsAnswered = 0
    private var score:Int = 0

    let defaults = UserDefaults.standard

    // MARK: - Initialisers
    
    init() {
        updateFromStoredValue()
    }

    // MARK: - General Function

    /// Reset the app to previous state across user sesstion
    func updateFromStoredValue() {
        // Please note this is not the ideal method for persistance
        // Ideally this would be implemented in a cloud based account storage like Firebase
        // or at the minimum coredata or the like.
        if let questionsAnsweredStored = defaults.integer(forKey: QuizControllerPropertyKeys.questionsAnsweredKey) as? Int {
            self.questionsAnswered = questionsAnsweredStored
        }
        if let scoreStored = defaults.integer(forKey: QuizControllerPropertyKeys.scoreKey) as? Int {
            self.score = scoreStored
        }
    }

    func uppdateScore(correct: Bool?) {
        guard let correct = correct else {
            return
        }
 
        if correct {
            score += 2
        } else if !correct {
            score -= 1
        }
        self.defaults.set(score, forKey: QuizControllerPropertyKeys.scoreKey)
    }

    func setNextQuestionIndex() {
        questionsAnswered += 1
        self.defaults.set(questionsAnswered, forKey: QuizControllerPropertyKeys.questionsAnsweredKey)
    }

    func setTotalQuestions(to totalQuestions: Int) {
        self.totalQuestions = totalQuestions
    }

    func getNextQuestion() -> Int {
        return questionsAnswered
    }

    func getTotalQuestions() -> Int {
        return totalQuestions
    }

    func getScore() -> Int {
        return score
    }
}
