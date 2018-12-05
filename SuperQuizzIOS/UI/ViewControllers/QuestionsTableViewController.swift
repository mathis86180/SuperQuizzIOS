//
//  QuestionsTableViewController.swift
//  SuperQuizzIOS
//
//  Created by formation 8 on 04/12/2018.
//  Copyright © 2018 formation 8. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {

    
    /*
     les parentheses pour construire le tableau
     */
    var questions = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let question1 = Question(title: "Quelle est la capitale de la france ?", answers: ["Paris","Marseille","Tours","Poitiers"], correctAnswer: "Paris")
        let question2 = Question(title: "Quelle est la capitale de la Chine ?", answers: ["Pekin","Hong-Kong","Tokyo","Kyoto"], correctAnswer: "Pekin")
        
        questions.append(question1)
        questions.append(question2)
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell

        //recuperer les questions et afficher l'intitulé
        
        cell.questionLabelTitle.text = questions[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        vc.question = questions[indexPath.row]
        vc.setOnReponseAnswered { (questionAnswered, result) in
            //TODO mettre a jour la liste
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
        self.show(vc, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrEditQuestionViewController") as! CreateOrEditQuestionViewController
            controller.delegate = self
            controller.questionToEdit = self.questions[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            //TODO: delete question
        }
        return [editAction,deleteAction]
    }
    
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateOrEditViewController" {
            let controller = segue.destination as! CreateOrEditQuestionViewController
            controller.delegate = self
            
        }
    }
}




extension QuestionsTableViewController : CreateOrEditQuestionDelegate {
    func userDidEditQuestion(q: Question) {
        // TODO: Maj de la question
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidCreateQuestion(q: Question) {
        // TODO:  creer la  question
        questions.append(q)
        tableView.reloadData()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
