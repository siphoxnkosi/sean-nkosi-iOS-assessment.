import UIKit

class IntroductionViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    private let coreDataManager: CoreDataManaging
    
    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10
        startButton.layer.cornerCurve = .continuous
    }
}

extension IntroductionViewController {
    @IBAction func startButtonTapped(_ sender: Any) {
        UserDefaults.didStartAssignment = true
        let controller = EngineersTableViewController(coreDataManager: coreDataManager)
        
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true)
    }
}
