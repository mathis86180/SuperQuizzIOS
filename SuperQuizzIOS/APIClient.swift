//
//  APIClient.swift
//  SuperQuizzIOS
//
//  Created by formation 8 on 06/12/2018.
//  Copyright © 2018 formation 8. All rights reserved.
//

import Foundation

class APIClient {
    static let instance = APIClient()
    
    private let urlServer = "http://192.168.10.154:3000"
    private init () {}
    
    
    /*
     Recuperer toutes les questions
     methode GET
     */
    func getAllQuestionsFromServer(onSuccess:@escaping ([Question])->(), onError:@escaping (Error)->())-> URLSessionTask {
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "GET"
        // preparation de la tache de telechargement des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // si j'ai de la donnée
            if let data = data {
                // Je la transforme en Array
                let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                var questionsToreturn = [Question]()
                // pour chaque objet d'ans l'array
                for object in dataArray {
                    
                    var answers = [String]()
                    let objectDictionary = object as! [String:Any]
                    let id = objectDictionary["id"] as! Int
                    let title = objectDictionary["title"] as! String
                    let answer1 = objectDictionary["answer_1"] as! String
                    let answer2 = objectDictionary["answer_2"] as! String
                    let answer3 = objectDictionary["answer_3"] as! String
                    let answer4 = objectDictionary["answer_4"] as! String
                    answers.append(answer1)
                    answers.append(answer2)
                    answers.append(answer3)
                    answers.append(answer4)
                    let correctAnswerInt = objectDictionary["correct_answer"] as! Int
                    var correctAnswer = ""
                    //switch sur correct answer
                    
                    switch correctAnswerInt {
                    case 1 :
                        correctAnswer = answer1
                        break
                    case 2 :
                        correctAnswer = answer2
                        break
                    case 3 :
                        correctAnswer = answer3
                        break
                    case 4 :
                        correctAnswer = answer4
                        break
                    default :
                        break
                    }
                    let userChoice : String
                    if objectDictionary["user_choice"] as? String != nil {
                        userChoice = (objectDictionary["user_choice"] as! String)
                    }else{
                        userChoice = ""
                    }
                    let q  = Question(id: id, title: title, answers: answers, correctAnswer: correctAnswer, userChoice: userChoice)
                    questionsToreturn.append(q)
                }
                onSuccess(questionsToreturn)
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    
    /*
     supprimer une question
     methode DELETE
     */
    
    func deleteQuestionFromTheServer(question: Question, onSuccess:@escaping ()->(), onError:@escaping (Error)->())-> () {
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(question.id)")! )
        
        let json = createJSONObject(question: question)
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpMethod = "DELETE"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                onSuccess()
            }else{
                onError(error!)
            }
        }
        task.resume()

    }
    
    /*
     ajouter une question
     methode POST
     */
    func addQuestionToTheServer(question: Question, onSuccess:@escaping (Question)->(), onError:@escaping (Error)->())-> () {
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        
        let json = createJSONObject(question: question)
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                onSuccess(question)
            }else{
                onError(error!)
            }
        }
        task.resume()
    }
    
    /*
     modifier une question
     methode PUT
     */
    
    func updateQuestionFromTheServer(question: Question, onSuccess:@escaping (Question)->(), onError:@escaping (Error)->())-> () {
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(question.id)")! )
        
        let json = createJSONObject(question: question)
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpMethod = "PUT"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                onSuccess(question)
            }else{
                onError(error!)
            }
        }
        task.resume()
    
    }
    
    func createJSONObject(question : Question)->[String : Any]{
        var json = [String:Any]()
        json["title"] = question.title
        json["answer_1"] = question.answers[0]
        json["answer_2"] = question.answers[1]
        json["answer_3"] = question.answers[2]
        json["answer_4"] = question.answers[3]
        
        if question.correctAnswer == question.answers[0] {
            json["correct_answer"] = 1
        } else if question.correctAnswer == question.answers[1] {
            json["correct_answer"] = 2
        } else if question.correctAnswer == question.answers[2] {
            json["correct_answer"] = 3
        } else if question.correctAnswer == question.answers[3] {
            json["correct_answer"] = 4
        }
        json["user_choice"] = question.userChoice
        return json
    }
    
}
