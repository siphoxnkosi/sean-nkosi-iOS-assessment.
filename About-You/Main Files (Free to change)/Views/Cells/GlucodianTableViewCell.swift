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
        }
    }
    
    private func setupStyling() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
}
