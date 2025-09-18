//
//  QuizData.swift
//  Cluey
//
//  Created by Andrew CP Markham on 7/8/2022.
//

import Foundation

// Main data structure returned by firebase
struct QuizData: Decodable {
    
    let resultSize: Int
    let items: [Question]

}

