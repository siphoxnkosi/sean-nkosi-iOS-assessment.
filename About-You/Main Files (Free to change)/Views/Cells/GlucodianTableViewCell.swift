import UIKit

class GlucodianTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setUp(with name: String, role: String) {
        nameLabel.text = name
        roleLabel.text = role
    }
    
    func setUp(with engineer: Engineer) {
        nameLabel.text = engineer.name
        roleLabel.text = engineer.role
        configureProfileImage(for: engineer)
    }
    
    private func configureProfileImage(for engineer: Engineer) {
        if let imageData = CoreDataManager.shared.fetchEngineerImage(name: engineer.name),
           let image = UIImage(data: imageData) {
            profileImage.image = image
            return
        } else if !engineer.defaultImageName.isEmpty {
            profileImage.image = UIImage(named: engineer.defaultImageName)
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
            profileImage.image = UIImage(systemName: "person.fill", withConfiguration: config)
            profileImage.tintColor = .systemBlue
            profileImage.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    private func setupStyling() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
}
