//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import UIKit
import DesignSystem

final class AssetTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AssetTableViewCell"

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = DSSpacings.medium
        view.clipsToBounds = true
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGray3
        imageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSFonts.bodyRegular
        label.textColor = .label
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DSFonts.subheadlineRegular
        label.textColor = .systemGreen
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DSSpacings.xSmall
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with asset: Asset) {
        nameLabel.text = asset.name
        priceLabel.text = formatPrice(asset.priceUsd)
    }

    private func formatPrice(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","

        return formatter.string(from: NSNumber(value: value)) ?? "$ 0,00"
    }
}

extension AssetTableViewCell: ViewCode {
    func buildViewHierarch() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textStackView)
    }

    func setUpConstraints() {
        let horizontalPadding = DSSpacings.large
        let verticalPadding = DSSpacings.small

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor,
                                               constant: verticalPadding),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                  constant: -verticalPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: horizontalPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -horizontalPadding),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                   constant: horizontalPadding),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 42),
            iconImageView.heightAnchor.constraint(equalToConstant: 42),

            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,
                                                   constant: horizontalPadding),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -horizontalPadding),
            textStackView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                               constant: DSSpacings.small),
            textStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                  constant: -DSSpacings.medium)
        ])
    }

    func additionalConfiguration() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }
}

#if DEBUG
import SwiftUI

@available(iOS 17.0, *)
#Preview {
    let view = AssetTableViewCell()
    view.configure(with: .init(id: 1, name: "opa", symbol: "OPa", priceUsd: 123.4))
    return view
}
#endif
