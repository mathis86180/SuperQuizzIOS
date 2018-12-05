//
//  ViewController.swift
//  SuperQuizzIOS
//
//  Created by formation 8 on 04/12/2018.
//  Copyright © 2018 formation 8. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    var question : Question!
    
    private var onQuestionAnswered : ((_ question : Question, _ isCorrectAnswer : Bool)->())?
    
    @IBOutlet weak var labelQuestionTitle: UILabel!
    @IBOutlet weak var buttonFirstAnswer: UIButton!
    @IBOutlet weak var buttonSecondAnswer: UIButton!
    @IBOutlet weak var buttonThirdAnswer: UIButton!
    @IBOutlet weak var buttonFourthAnswer: UIButton!
    
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(question.title)
        labelQuestionTitle.text = question.title
        buttonFirstAnswer.setTitle(question.answers[0], for: .normal)
        buttonSecondAnswer.setTitle(question.answers[1], for: .normal)
        buttonThirdAnswer.setTitle(question.answers[2], for: .normal)
        buttonFourthAnswer.setTitle(question.answers[3], for: .normal) 
    }
    
    func userDidChooseAnswer(isCorrectAnswer : Bool){
        //TODO : animation echec et success
        if isCorrectAnswer == true {
            print("Bonne réponse")
        }else {
            print("Mauvaise réponse")
        }
        
        self.dismiss(animated: true, completion: nil)
        onQuestionAnswered?(question, isCorrectAnswer)
    }

    @IBAction func onButtonChoiceTapped(_ sender: UIButton) {
        var isTrue : Bool
        if sender.titleLabel?.text == question.correctAnswer {
            isTrue = true
        }else {
            isTrue = false
        }
        userDidChooseAnswer(isCorrectAnswer: isTrue)
    }
    
}

