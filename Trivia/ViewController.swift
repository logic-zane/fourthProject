//
//  ViewController.swift
//  Trivia
//
//  Created by 张劲龙 on 3/12/25.
//

import UIKit

struct Question {
    let text: String
    let answers: [String]
}

class ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    var currentQuestionIndex = 0
    
    let questions: [Question] = [
        Question(text: "What is the capital of France?", answers: ["Paris", "London", "Berlin", "Madrid"]),
        Question(text: "What is 2 + 2?", answers: ["3", "4", "5", "6"]),
        Question(text: "Which planet is known as the Red Planet?", answers: ["Earth", "Mars", "Jupiter", "Venus"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        let question = questions[currentQuestionIndex]
        questionLabel.text = question.text
        
        answerButton1.setTitle(question.answers[0], for: .normal)
        answerButton2.setTitle(question.answers[1], for: .normal)
        answerButton3.setTitle(question.answers[2], for: .normal)
        answerButton4.setTitle(question.answers[3], for: .normal)
    }
    
    @IBAction func answerTapped(_ sender: UIButton) {
        nextQuestion()
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            currentQuestionIndex = 0 // Restart quiz if at the last question
        }
        updateUI()
    }
}
