//
//  Question.swift
//  SuperQuizzIOS
//
//  Created by formation 8 on 04/12/2018.
//  Copyright © 2018 formation 8. All rights reserved.
//

import Foundation

public class Question {
    
    //public var id : Int
    public var title : String
    var answers : [String]
    var correctAnswer : String
    
    init(title : String, answers : [String], correctAnswer : String){
        self.title = title
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
}
