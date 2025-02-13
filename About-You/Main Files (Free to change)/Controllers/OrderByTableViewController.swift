import UIKit

class OrderByTableViewController: UITableViewController {
    
    weak var delegate: OrderByDelegate?
    
    private let options = ["Years", "Coffees", "Bugs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCriterion = options[indexPath.row]
        delegate?.didSelectOrder(by: selectedCriterion) 
        
        dismiss(animated: true, completion: nil)
    }
}
