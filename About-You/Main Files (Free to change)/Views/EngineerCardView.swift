//
//  EngineerCardView.swift
//  About-You
//
//  Created by Sean Nkosi on 2025/02/10.
//

import UIKit
import Photos

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
    private let coreDataManager = CoreDataManager.shared
    private var engineerName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setUp(with engineer: Engineer, parentVC: UIViewController) {
        self.parentViewController = parentVC
        self.engineerName = engineer.name
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
        
        let alert = UIAlertController(
            title: "Photo Library Access",
            message: "Do you allow access to your photo library to upload a profile picture?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
            self.requestPhotoLibraryAccess { granted in
                if granted {
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = .photoLibrary
                        imagePicker.allowsEditing = true
                        parentVC.present(imagePicker, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert()
                    }
                }
            }
        })
        
        parentVC.present(alert, animated: true)
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Permission Denied",
            message: "Please enable photo library access in Settings to upload a profile picture.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        parentViewController?.present(alert, animated: true)
    }
    
    
    private func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        default:
            completion(false) 
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            engineerImageView.image = selectedImage
            
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                coreDataManager.saveEngineerImage(name: engineerName, imageData: imageData)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func configureImage(for engineer: Engineer) {
        if let savedImageData = coreDataManager.fetchEngineerImage(name: engineer.name),
           let savedImage = UIImage(data: savedImageData) {
            engineerImageView.image = savedImage
        } else {
            setDefaultImage(for: engineer)
        }
    }
    
    private func setDefaultImage(for engineer: Engineer) {
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
            engineerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            engineerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            engineerImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            engineerImageView.widthAnchor.constraint(equalTo: engineerImageView.heightAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: engineerImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            roleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            statsContainerView.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 8),
            statsContainerView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statsContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            statsStackView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor, constant: 8),
            statsStackView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor, constant: -8),
            statsStackView.topAnchor.constraint(equalTo: statsContainerView.topAnchor, constant: 4),
            statsStackView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: -4),
            
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
