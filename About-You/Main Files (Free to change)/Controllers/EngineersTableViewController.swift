import UIKit

class EngineersTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, OrderByDelegate {
    var engineers: [Engineer] = Engineer.testingData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Engineers at Glucode"
        tableView.backgroundColor = .white
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Order by",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(orderByTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func orderByTapped() {
        guard let from = navigationItem.rightBarButtonItem else { return }
        let controller = OrderByTableViewController(style: .plain)
        controller.delegate = self
        let size = CGSize(width: 200,
                          height: 150)
        
        present(popover: controller,
                from: from,
                size: size,
                arrowDirection: .up)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: String(describing: GlucodianTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GlucodianTableViewCell.self))
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engineers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GlucodianTableViewCell.self)) as? GlucodianTableViewCell
        cell?.setUp(with: engineers[indexPath.row].name, role: engineers[indexPath.row].role)
        cell?.accessoryType = .disclosureIndicator
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = QuestionsViewController.loadController(with: engineers[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didSelectOrder(by criterion: String) {
        // Sort the engineers based on the selected criterion
        switch criterion {
        case "Years":
            engineers.sort { $0.quickStats.years < $1.quickStats.years }
        case "Coffees":
            engineers.sort { $0.quickStats.coffees < $1.quickStats.coffees }
        case "Bugs":
            engineers.sort { $0.quickStats.bugs < $1.quickStats.bugs }
        default:
            break
        }
        
        // Reload the table to reflect the new order
        tableView.reloadData()
    }
}
