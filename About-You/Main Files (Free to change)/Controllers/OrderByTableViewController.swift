import UIKit



class OrderByTableViewController: UITableViewController {
    
    weak var delegate: OrderByDelegate?
    
    // The sorting options array to make the code more flexible and readable
    private let options = ["Years", "Coffees", "Bugs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count // Use the array count to make this more scalable
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) else {
            return UITableViewCell()
        }
        // Set the cell text based on the options array
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Pass the selected sorting criterion back to the delegate
        let selectedCriterion = options[indexPath.row] // Get the option using indexPath
        delegate?.didSelectOrder(by: selectedCriterion)  // Inform the delegate
        
        // Dismiss the popover
        dismiss(animated: true, completion: nil)
    }
}
