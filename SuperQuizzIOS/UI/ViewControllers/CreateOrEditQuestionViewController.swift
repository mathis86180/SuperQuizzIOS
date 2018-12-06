//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizzIOS
//
//  Created by formation 8 on 05/12/2018.
//  Copyright © 2018 formation 8. All rights reserved.
//

import UIKit

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldTitleQuestion: UITextField!
    @IBOutlet weak var textFieldFirstAnswer: UITextField!
    @IBOutlet weak var textFieldSecondAnswer: UITextField!
    @IBOutlet weak var textFieldThirdAnswer: UITextField!
    @IBOutlet weak var textFieldFourthAnswer: UITextField!
    
    @IBOutlet weak var switchFirstAnswer: UISwitch!
    @IBOutlet weak var switchSecondAnswer: UISwitch!
    @IBOutlet weak var switchThirdAnswer: UISwitch!
    @IBOutlet weak var switchFourthAnswer: UISwitch!
    
    
    
    
    var questionToEdit: Question?
    weak var delegate : CreateOrEditQuestionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if questionToEdit != nil {
            textFieldTitleQuestion.text = questionToEdit?.title
            textFieldFirstAnswer.text = questionToEdit?.answers[0]
            textFieldSecondAnswer.text = questionToEdit?.answers[1]
            textFieldThirdAnswer.text = questionToEdit?.answers[2]
            textFieldFourthAnswer.text = questionToEdit?.answers[3]
        }
    }
    
    func createOrEditQuestion () {
        
        var correctAnswer = ""
        var questionAnswers = [String]()
        guard let questionTitle = textFieldTitleQuestion.text else {
            return
        }
        
        guard let answer1 = textFieldFirstAnswer.text else{
            return
        }
        guard let answer2 = textFieldSecondAnswer.text else{
            return
        }
        guard let answer3 = textFieldThirdAnswer.text else{
            return
        }
        guard let answer4 = textFieldFourthAnswer.text else{
            return
        }
        
        if switchFirstAnswer.isOn == true {
            correctAnswer = textFieldFirstAnswer.text!
        } else if switchSecondAnswer.isOn == true{
            correctAnswer = textFieldSecondAnswer.text!
        } else if switchThirdAnswer.isOn == true{
            correctAnswer = textFieldThirdAnswer.text!
        } else if switchFourthAnswer.isOn == true{
            correctAnswer = textFieldFourthAnswer.text!
        }
        
        questionAnswers.append(answer1)
        questionAnswers.append(answer2)
        questionAnswers.append(answer3)
        questionAnswers.append(answer4)
        
        if let question = questionToEdit {
            question.title = questionTitle
            question.answers = questionAnswers
            question.correctAnswer = correctAnswer
            delegate?.userDidEditQuestion(q: question)
        } else {
            let question = Question(title: questionTitle, answers: questionAnswers, correctAnswer: correctAnswer)
            delegate?.userDidCreateQuestion(q: question)
        }
    }
    
    @IBAction func onSwitchTapped(_ sender: UISwitch) {
        let sw = sender
        if sw.isOn {
            switchFirstAnswer.setOn(false, animated: true)
            switchSecondAnswer.setOn(false, animated: true)
            switchThirdAnswer.setOn(false, animated: true)
            switchFourthAnswer.setOn(false, animated: true)
            sw.setOn(true, animated: true)
        }
    }
    
    
    @IBAction func onFinishTapped(_ sender: UIButton) {
        createOrEditQuestion()
    }
}
