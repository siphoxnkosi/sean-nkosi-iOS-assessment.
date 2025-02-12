import UIKit

class GlucodianTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    private var coreDataManager: CoreDataManaging?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(systemName: "person.fill")
    }
    
    func setUp(with engineer: Engineer, coreDataManager: CoreDataManaging) {
        nameLabel.text = engineer.name
        roleLabel.text = engineer.role
        self.coreDataManager = coreDataManager
        configureProfileImage(for: engineer)
    }
    
    private func configureProfileImage(for engineer: Engineer) {
        if let imageData = CoreDataManager.shared.fetchEngineerImage(name: engineer.name),
           let image = UIImage(data: imageData) {
            profileImage.image = image
            return
        } else if !engineer.defaultImageName.isEmpty {
            profileImage.image = UIImage(named: engineer.defaultImageName)
        }
    }
    
    private func setupStyling() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
}
