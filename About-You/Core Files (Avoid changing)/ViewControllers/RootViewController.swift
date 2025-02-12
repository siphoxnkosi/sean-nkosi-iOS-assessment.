import UIKit

enum RootScreen {
    case start
    case engineers
}

class RootScreenController {
    private var rootViewController: UIViewController!
    private static let sharedRootScreenController = RootScreenController()
    static var shared: RootScreenController {
        return sharedRootScreenController
    }
    lazy var rootViewFrame: CGRect = {
        return rootViewController.view.frame
    }()

    private init() {
        setRootViewController()
    }

    private func setRootViewController() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        rootViewController = scene.windows.first?.rootViewController
    }

    func presentAppropriateScreenForLaunch() {
        if UserDefaults.didStartAssignment {
            show(screen: .engineers)
        } else {
            show(screen: .start)
        }
    }

    private func show(screen: RootScreen) {
        switch screen {
        case .start:
            showStartScreen()
        case .engineers:
            showEngineerScreen()
        }
    }

    private func showStartScreen() {
        let viewController = IntroductionViewController.init(coreDataManager: CoreDataManager.shared)
        rootViewController.removeAllChildren()
        rootViewController.add(viewController, frame: rootViewFrame)
    }

    private func showEngineerScreen() {
        let controller = EngineersTableViewController(coreDataManager: CoreDataManager.shared)
        let navigationController = UINavigationController(rootViewController: controller)
        rootViewController.removeAllChildren()
        rootViewController.add(navigationController, frame: rootViewFrame)
    }
}
