//
//  Answer.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 4/11/17.
//
//

import Foundation
import RealmSwift

class Answer: Object {
    dynamic var answer: String = ""
    
    var answerDescription: String { // read-only properties are automatically ignored
        return "\(answer)"
    }
}
