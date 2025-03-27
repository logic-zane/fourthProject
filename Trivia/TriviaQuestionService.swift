//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by 张劲龙 on 3/26/25.
// TriviaQuestionService.swift
import Foundation


extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
}

class TriviaQuestionService {
    func fetchQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: -2, userInfo: nil))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
                let questions = response.results.map { apiQuestion -> TriviaQuestion in
                    var answers = apiQuestion.incorrect_answers
                    answers.append(apiQuestion.correct_answer)
                    answers.shuffle()
                    let correctIndex = answers.firstIndex(of: apiQuestion.correct_answer)!
                    return TriviaQuestion(
                        category: apiQuestion.category,
                        question: apiQuestion.question.htmlDecoded,
                        answers: answers.map { $0.htmlDecoded },
                        correctAnswerIndex: correctIndex
                    )
                }
                completion(questions, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

struct TriviaAPIResponse: Codable {
    let results: [TriviaAPIQuestion]
}

struct TriviaAPIQuestion: Codable {
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}
