import UIKit

protocol SelectionViewDelegate {
    func didSelect(selectionView: SelectableAnswerView)
}

class SelectableAnswerView: UIView {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!

    @IBOutlet weak var tapGesture: UITapGestureRecognizer!

    private var delegate: SelectionViewDelegate?

    static func loadView() -> Self? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)
        guard let view = views?.first as? Self else {
            return nil
        }
        return view
    }

    override func awakeFromNib() {
        applyStyling()
    }

    func setUp(with title: String, delegate: SelectionViewDelegate) {
        titleLabel.text = title
        self.delegate = delegate
    }

    func deselect() {
        applyDeselectionStyling()
    }

    private func applyStyling() {
        applyDeselectionStyling()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)

        highlightView.layer.cornerCurve = .continuous
        highlightView.layer.cornerRadius = 10
    }

    func applySelectionStyling() {
        let view = UIView()
        view.backgroundColor = .white
        highlightView.addSubview(view)
        view.pinEdges(to: highlightView)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 10

        titleLabel.textColor = .black
        highlightView.isHidden = false
    }

    func applyDeselectionStyling() {
        titleLabel.textColor = .white
        highlightView.isHidden = true
    }

    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        applySelectionStyling()
        delegate?.didSelect(selectionView: self)
    }
}
