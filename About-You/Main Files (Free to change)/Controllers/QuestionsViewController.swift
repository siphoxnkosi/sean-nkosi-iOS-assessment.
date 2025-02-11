import UIKit

class QuestionsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerStack: UIStackView!
    
    var engineer: Engineer?
    
    static func loadController(with engineer: Engineer) -> QuestionsViewController {
        let viewController = QuestionsViewController.init(nibName: String(describing: self), bundle: Bundle(for: self))
        viewController.loadViewIfNeeded()
        viewController.engineer = engineer
        viewController.setUp(with: engineer.questions)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "About"
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        setupEngineerCard()
    }
    
    func setUp(with questions: [Question]) {
        loadViewIfNeeded()
        
        for question in questions {
            addQuestion(with: question)
        }
    }
    
    private func setupEngineerCard() {
        guard let engineer = engineer else { return }
        
        guard let engineerCardView = EngineerCardView.loadView() else { return }
        
        engineerCardView.setUp(with: engineer)
        
        containerStack.insertArrangedSubview(engineerCardView, at: 0)
        
        engineerCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            engineerCardView.leadingAnchor.constraint(equalTo: containerStack.leadingAnchor, constant: 0),
            engineerCardView.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor, constant: 0),
            engineerCardView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    
    private func addQuestion(with data: Question) {
        guard let cardView = QuestionCardView.loadView() else { return }
        cardView.setUp(with: data.questionText,
                       options: data.answerOptions,
                       selectedIndex: data.answer?.index)
        containerStack.addArrangedSubview(cardView)
    }
}
