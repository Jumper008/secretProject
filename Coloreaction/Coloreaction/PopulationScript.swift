//
//  PopulationScript.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 4/11/17.
//
//

import Foundation
import RealmSwift

func populateRealmWithQuestions() {
    DispatchQueue(label: "background").async {
        autoreleasepool {
            let realm = try! Realm()
            let path = Bundle.main.path(forResource: "Questions", ofType: "plist")!
            let questions = getQuestionArray(fromPath: path)
            try! realm.write {
                for question in questions {
                    realm.add(question)
                }
            }
        }
    }
}

func getQuestionArray(fromPath path: String) -> [Question] {
    let resultArray = NSArray(contentsOfFile: path)!
    var array = [Dictionary<String, AnyObject>]()
    for result in resultArray {
        array.append(result as! Dictionary<String, AnyObject>)
    }
    
    var questions = [Question]()
    for item in array {
        let question = Question()
        question.difficulty = item["difficulty"] as! Int
        question.question = item["question"] as! String
        let answer = item["answer"] as! String
        question.answer = Answer()
        question.answer?.answer = answer
        let possibleAnswers = item["possibleAnswers"] as! [String]
        for possibleAnswer in possibleAnswers {
            let answerAux = Answer()
            answerAux.answer = possibleAnswer
            question.possibleAnswers.append(answerAux)
        }
        question.imageData = item["imageData"] as? NSData
        question.score = item["score"] as! Int
        question.topic = item["topic"] as! String
        question.isImageQuestion = item["isImageQuestion"] as! Bool
        questions.append(question)
    }
    
    return questions
}

func isRealmPopulatedWithQuestions() -> Bool {
    let realm = try! Realm()
    if realm.objects(Question.self).count > 0
    {
        return true
    }
    else
    {
        return false
    }
}
