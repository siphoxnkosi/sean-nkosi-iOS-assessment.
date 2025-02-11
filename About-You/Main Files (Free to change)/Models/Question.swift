import Foundation

struct Question: Codable {
    let questionText: String
    let answerOptions: [String]
    let questionType: String
    let answer: Answer?

    enum CodingKeys: String, CodingKey {
        case questionText = "question_text"
        case answerOptions = "answer_options"
        case questionType = "question_type"
        case answer
    }
}

struct Answer: Codable {
    let text: String?
    let index: Int?
}

class MainQuestions {
    static func questionOne(answer: Answer) -> Question {
        return Question(questionText: "When do you have the most energy?",
                        answerOptions: ["6am", "12pm", "6pm", "Midnight"],
                        questionType: "SELECTION",
                        answer: answer)
    }

    static func questionTwo(answer: Answer) -> Question {
        return Question(questionText: "How old were you when you wrote your first line of code?",
                        answerOptions: ["Younger than 10 years",
                                        "10 to 15 years old",
                                        "16 to 20 years old",
                                        "21 to 25 years old",
                                        "26 years old or older"],
                        questionType: "SELECTION",
                        answer: answer)
    }

    static func questionThree(answer: Answer) -> Question {
        return Question(questionText: "Which new programming language would you want to learn?",
                        answerOptions: ["Python",
                                        "Kotlin",
                                        "Swift",
                                        "Ruby",
                                        "C#",
                                        "C++",
                                        "Rust",
                                        "None"],
                        questionType: "SELECTION",
                        answer: answer)
    }

    static func questionFour(answer: Answer) -> Question {
        return Question(questionText: "How often do you learn a new framework or language?",
                        answerOptions: ["Every few months",
                                        "Once a year",
                                        "Once every few years"],
                        questionType: "SELECTION",
                        answer: answer)
    }

    static func questionFive(answer: Answer) -> Question {
        return Question(questionText: "What do you do when you get stuck on a problem?",
                        answerOptions: ["Visit Stack Overflow",
                                        "Do other work and come back later",
                                        "Call a coworker or friend",
                                        "Watch or read a tutorial",
                                        "Go down a google rabbit hole",
                                        "Panic"],
                        questionType: "SELECTION",
                        answer: answer)
    }
}
