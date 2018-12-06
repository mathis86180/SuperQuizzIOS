//
//  Question.swift
//  SuperQuizzIOS
//
//  Created by formation 8 on 04/12/2018.
//  Copyright © 2018 formation 8. All rights reserved.
//

import Foundation

public class Question {
    
    public var id : Int
    public var title : String
    public var answers : [String]
    public var correctAnswer : String

    
    init(id : Int, title : String, answers : [String], correctAnswer : String){
        self.id = id
        self.title = title
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
    
    init(title : String, answers : [String], correctAnswer : String){
        self.id = 0
        self.title = title
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
}
