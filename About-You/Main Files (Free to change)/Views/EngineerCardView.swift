//
//  EngineerCardView.swift
//  About-You
//
//  Created by Sean Nkosi on 2025/02/10.
//

import UIKit

class EngineerCardView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var engineerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var statsContainerView: UIView!
    @IBOutlet weak var statsStackView: UIStackView!
    @IBOutlet weak var yearsStackView: UIStackView!
    @IBOutlet weak var coffeesStackView: UIStackView!
    @IBOutlet weak var bugsStackView: UIStackView!
    
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var coffeesLabel: UILabel!
    @IBOutlet weak var bugsLabel: UILabel!
    
    private var parentViewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setUp(with engineer: Engineer, parentVC: UIViewController) {
        self.parentViewController = parentVC
        configureImage(for: engineer)
        configureLabels(for: engineer)
    }
    
    private func setupView() {
        applyCardStyling()
        applyImageStyling()
        applyTextStyling()
        applyStatsContainerStyling()
        applyConstraints()
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        engineerImageView.isUserInteractionEnabled = true
        engineerImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapImage() {
        guard let parentVC = parentViewController else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        parentVC.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            engineerImageView.image = selectedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            engineerImageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func configureImage(for engineer: Engineer) {
        if engineer.defaultImageName.isEmpty {
            let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
            engineerImageView.image = UIImage(systemName: "person.fill", withConfiguration: config)
            engineerImageView.tintColor = .white
            engineerImageView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        } else {
            engineerImageView.image = UIImage(named: engineer.defaultImageName)
        }
    }
    
    private func configureLabels(for engineer: Engineer) {
        nameLabel.text = engineer.name
        roleLabel.text = engineer.role
        
        yearsLabel.text = "Years\n\(engineer.quickStats.years)"
        coffeesLabel.text = "Coffees\n\(engineer.quickStats.coffees)"
        bugsLabel.text = "Bugs\n\(engineer.quickStats.bugs)"
    }
    
    private func applyCardStyling() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .black
    }
    
    private func applyImageStyling() {
        engineerImageView.layer.cornerRadius = 10
        engineerImageView.clipsToBounds = true
        engineerImageView.contentMode = .scaleAspectFill
        engineerImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func applyTextStyling() {
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.textColor = .white
        roleLabel.font = .systemFont(ofSize: 14)
        roleLabel.textColor = .lightGray
        
        let statsLabels = [yearsLabel, coffeesLabel, bugsLabel]
        statsLabels.forEach { label in
            label?.font = .systemFont(ofSize: 12)
            label?.numberOfLines = 2
            label?.lineBreakMode = .byWordWrapping
            label?.textAlignment = .center
            label?.textColor = .black
        }
    }
    
    private func applyStatsContainerStyling() {
        statsContainerView.layer.cornerRadius = 10
        statsContainerView.clipsToBounds = true
        statsContainerView.backgroundColor = .white
    }
    
    private func applyConstraints() {
        [self, engineerImageView, nameLabel, roleLabel, statsContainerView, statsStackView, yearsStackView, coffeesStackView, bugsStackView].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Engineer Image Constraints
            engineerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            engineerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            engineerImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            engineerImageView.widthAnchor.constraint(equalTo: engineerImageView.heightAnchor),
            
            
            // Name & Role Stack
            nameLabel.leadingAnchor.constraint(equalTo: engineerImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            roleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            // Stats Container
            statsContainerView.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 8),
            statsContainerView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statsContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            // Stats Stack View
            statsStackView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor, constant: 8),
            statsStackView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor, constant: -8),
            statsStackView.topAnchor.constraint(equalTo: statsContainerView.topAnchor, constant: 4),
            statsStackView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: -4),
            
            // Equal Width for Stats Columns
            yearsStackView.widthAnchor.constraint(equalTo: coffeesStackView.widthAnchor),
            coffeesStackView.widthAnchor.constraint(equalTo: bugsStackView.widthAnchor)
        ])
    }
    
    static func loadView() -> Self? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return views?.first as? Self
    }
}
