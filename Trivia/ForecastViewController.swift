//
//  ForecastViewController.swift
//  Trivia
//
//  Created by 张劲龙 on 3/12/25.
//
// ForecastViewController.swift
import UIKit

class ForecastViewController: UIViewController {
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    

    var currentQuestionIndex = 0
    var score = 0
    var questions: [TriviaQuestion] = []
    let triviaQuestionService = TriviaQuestionService()
    
    override func viewDidLoad() {
        // Allow multiple lines and text wrapping
        questionLabel.numberOfLines = 0 // Unlimited lines
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.adjustsFontSizeToFitWidth = true // Optional: shrink font if needed
        super.viewDidLoad()
        for (index, button) in answerButtons.enumerated() {
            button.tag = index 
        }
        fetchQuestions()
    }
    
    func fetchQuestions() {
        triviaQuestionService.fetchQuestions { [weak self] (questions, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(message: error.localizedDescription)
                    return
                }
                guard let questions = questions else { return }
                self?.questions = questions
                self?.currentQuestionIndex = 0
                self?.score = 0
                self?.displayQuestion()
            }
        }
    }
    
    func displayQuestion() {
        guard currentQuestionIndex < questions.count else { return }
        let question = questions[currentQuestionIndex]
        
        questionNumberLabel.text = "Question \(currentQuestionIndex + 1)/\(questions.count)"
        categoryLabel.text = question.category
        questionLabel.text = question.question
        
        for (index, button) in answerButtons.enumerated() {
            if index < question.answers.count {
                button.setTitle(question.answers[index], for: .normal)
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let question = questions[currentQuestionIndex]
        if sender.tag == question.correctAnswerIndex {
            score += 1
        }
        
        currentQuestionIndex += 1
        currentQuestionIndex < questions.count ? displayQuestion() : showScore()
    }
    
    func showScore() {
        let alert = UIAlertController(
            title: "Quiz Finished!",
            message: "Your score: \(score)/\(questions.count)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
            self.fetchQuestions() // Fetch new questions on restart
        })
        present(alert, animated: true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            self.fetchQuestions()
        })
        present(alert, animated: true)
    }
}
