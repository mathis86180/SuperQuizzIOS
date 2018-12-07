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
    var work : DispatchWorkItem!
    
    private var onQuestionAnswered : ((_ question : Question, _ isCorrectAnswer : Bool)->())?
    
    @IBOutlet weak var labelQuestionTitle: UILabel!
    @IBOutlet weak var buttonFirstAnswer: UIButton!
    @IBOutlet weak var buttonSecondAnswer: UIButton!
    @IBOutlet weak var buttonThirdAnswer: UIButton!
    @IBOutlet weak var buttonFourthAnswer: UIButton!
    
    
    @IBOutlet weak var progressTime: UIProgressView!
    
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        labelQuestionTitle.text = question.title
        buttonFirstAnswer.setTitle(question.answers[0], for: .normal)
        buttonSecondAnswer.setTitle(question.answers[1], for: .normal)
        buttonThirdAnswer.setTitle(question.answers[2], for: .normal)
        buttonFourthAnswer.setTitle(question.answers[3], for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        work = DispatchWorkItem {
            var count = 0
            let duration = 60
            while count < duration {
                DispatchQueue.global(qos: .userInitiated).async {
                    Thread.sleep(forTimeInterval: 0.1)
                    if self.work.isCancelled {
                        return
                    }
                    count = count + 1
                    DispatchQueue.main.async {
                        self.progressTime.setProgress(Float(count), animated: true)
                    }
                }
            }
        }
        DispatchQueue.global().async(execute: work)
    }
    
    func userDidChooseAnswer(isCorrectAnswer : Bool){
        if isCorrectAnswer == true {
            question.userChoice = question.correctAnswer
            APIClient.instance.updateQuestionFromTheServer(question: question, onSuccess: { (question) in
                print("success")
            }) { (Error) in
                print(Error)
            }
            print("Bonne réponse")
        }else {
            question.userChoice = ""
            print("Mauvaise réponse")
        }
        work.cancel()
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

