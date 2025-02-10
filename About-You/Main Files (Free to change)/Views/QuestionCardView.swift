import UIKit

class QuestionCardView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionsStackView: UIStackView!
    
    var selectedIndex: Int?
    var currentSelection: SelectableAnswerView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyling()
    }
    
    func setUp(with title: String, options: [String], selectedIndex: Int? = -1) {
        configureTitleLabel(with: title)
        setupConstraints()
        self.selectedIndex = selectedIndex
        addOptions(options, selectedIndex: selectedIndex)
    }
    
    func ensureCorrectSelectionIsSelected() {
        guard let index = selectedIndex,
              let selectionView = optionsStackView.arrangedSubviews[index] as? SelectableAnswerView else { return }
        selectionView.applySelectionStyling()
    }
    
    private func configureTitleLabel(with text: String) {
        titleLabel.text = text
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private func applyStyling() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)

        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        ])
    }
    
    private func addOptions(_ options: [String], selectedIndex: Int?) {
        options.enumerated().forEach { index, optionText in
            let isSelected = index == selectedIndex
            addOption(with: optionText, addSeparator: index < options.count - 1, setSelected: isSelected)
        }
    }
    
    private func addOption(with text: String, addSeparator: Bool, setSelected: Bool) {
        guard let optionView = SelectableAnswerView.loadView() else { return }
        optionView.setUp(with: text, delegate: self)
        
        optionsStackView.addArrangedSubview(optionView)
        if addSeparator {
            createAndAddSeparator()
        }
        
        if setSelected {
            optionView.applySelectionStyling()
            currentSelection = optionView
        }
    }
    
    private func createAndAddSeparator() {
        let separatorView = UIView.seperatorView(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
        optionsStackView.addArrangedSubview(separatorView)
    }
    
    static func loadView() -> Self? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return views?.first as? Self
    }
}

extension QuestionCardView: SelectionViewDelegate {
    func didSelect(selectionView: SelectableAnswerView) {
        currentSelection?.deselect()
        currentSelection = selectionView
    }
}
