//
//  Question.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 3/21/17.
//
//

import Foundation
import RealmSwift

class Question: Object {
    /*
     - Difficulty code signing is as follows:
     - Easy = 0
     - Medium = 1
     - Hard = 2
     */
    dynamic var difficulty: Int = 0
    dynamic var question: String = ""
    dynamic var answer: Answer?
    let possibleAnswers = List<Answer>()
    dynamic var imageData: NSData?
    dynamic var score: Int = 0
    dynamic var topic: String = ""
    dynamic var isImageQuestion: Bool = false
    
    var questionDescription: String { // read-only properties are automatically ignored
        let difficultyDescription = "Difficulty: \(difficulty)\n"
        let questionDescription = "Question: \(question)\n"
        let answerDescription = "Answer: \(answer)\n"
        let possibleAnswersDescription = "Possible Answers: \(possibleAnswers)\n"
        let imageDataDescription = "Image Data: \(imageData)\n"
        let scoreDescription = "Score: \(score)\n"
        let topicDescription = "Topic: \(topic)\n"
        let isImageQuestionDescription = "Is Image Question: \(isImageQuestion)\n"
        return "Question information:\n\(difficultyDescription)\(questionDescription)\(answerDescription)\(possibleAnswersDescription)\(imageDataDescription)\(scoreDescription)\(topicDescription)\(isImageQuestionDescription)\n"
    }
}
