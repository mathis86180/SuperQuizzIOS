//
//  QuestionsTableViewController.swift
//  SuperQuizzIOS
//
//  Created by formation 8 on 04/12/2018.
//  Copyright © 2018 formation 8. All rights reserved.
//

import UIKit
import SwiftIcons

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
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIClient.instance.getAllQuestionsFromServer(onSuccess: { (questionsToReturn) in
            self.questions = questionsToReturn
            
            //retour dans le thread principal pour charler la liste a l'ecran
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (Error) in
            print(Error)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        /*
         par manque de  base données, la réponse de l'utilisateur est stockée sur le serveur
         a supprimer pour stocké localement uniquement la reponse
         */
        if questions[indexPath.row].userChoice == questions[indexPath.row].correctAnswer {
            cell.questionLabelTitle.setIcon(prefixText: "", icon: .fontAwesomeSolid(.thumbsUp), postfixText: " \(questions[indexPath.row].title)", size: 20)
        }else{
            cell.questionLabelTitle.setIcon(prefixText: "", icon: .fontAwesomeSolid(.thumbsDown), postfixText: " \(questions[indexPath.row].title)", size: 20)
        }
        
        //cell.questionLabelTitle.text = questions[indexPath.row].title
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        vc.question = questions[indexPath.row]
        vc.setOnReponseAnswered { (questionAnswered, result) in
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
            APIClient.instance.deleteQuestionFromTheServer(question: self.questions[indexPath.row], onSuccess: { () in
                print("passé ici")
                DispatchQueue.main.async {
                    self.questions.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }, onError: { (Error) in
                print(Error)
            })
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
        APIClient.instance.updateQuestionFromTheServer(question: q, onSuccess: { (q) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (Error) in
            print(Error)
        }
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidCreateQuestion(q: Question) {
        APIClient.instance.addQuestionToTheServer(question: q, onSuccess: { (q) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (Error) in
            print(Error)
        }
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
