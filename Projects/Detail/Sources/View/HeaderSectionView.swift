//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import UIKit
import DesignSystem

final class HeaderSectionView: UITableViewHeaderFooterView {
    // MARK: - UI Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSFonts.title3Emphasized
        label.textColor = .label
        return label
    }()

    lazy var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, loader])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - ViewCode Extension

extension HeaderSectionView: ViewCode {
    func buildViewHierarch() {
        contentView.addSubview(stackView)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: DSSpacings.large.rawValue),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,
                                                constant: -DSSpacings.large.rawValue),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: DSSpacings.medium.rawValue),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -DSSpacings.medium.rawValue)
        ])
    }
}
