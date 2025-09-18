//
//  Question.swift
//  Cluey
//
//  Created by Andrew CP Markham on 7/8/2022.
//

import Foundation

// Main structure important to app
struct Question: Codable {

    let correctAnswerIndex: Int
    let imageUrl: String
    let standFirst: String
    let storyUrl: String
    let section: String
    let headlines: [String]
    
}
