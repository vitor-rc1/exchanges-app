//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import UIKit
import DesignSystem

final class DetailHeaderView: UIView {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = DSSpacings.large.rawValue
        view.clipsToBounds = true
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 11
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGray3
        imageView.image = UIImage(systemName: "bahtsign.bank.building.fill")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 10
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()

    private lazy var topSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemFill
        return view
    }()

    private lazy var dateLaunchedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var makerFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()

    private lazy var takerFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLaunchedLabel, makerFeeLabel, takerFeeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DSSpacings.xSmall.rawValue
        return stackView
    }()

    private lazy var bottomSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemFill
        return view
    }()

    lazy var twitterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 18)
        button.setImage(UIImage(systemName: "bird.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()

    lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 18)
        button.setImage(UIImage(systemName: "globe", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [twitterButton, websiteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = DSSpacings.large.rawValue
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ExchangeDetailModel) {
        titleLabel.text = "\(model.name) - ID \(model.id)"
        descriptionLabel.text = model.description
        dateLaunchedLabel.text = "Date launched: \(model.dateLaunched)"
        makerFeeLabel.text = "Maker: \(formatPercentage(model.makerFee))"
        takerFeeLabel.text = "Taker: \(formatPercentage(model.takerFee))"
        loadImage(from: model.logoUrl)
        websiteButton.isHidden = model.websiteUrl == nil
        twitterButton.isHidden = model.twitterUrl == nil
    }

    private func formatPercentage(_ value: Double) -> String {
        String(format: "%.2f%%", value)
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run { logoImageView.image = image }
                }
            } catch {}
        }
    }
}

extension DetailHeaderView: ViewCode {
    func buildViewHierarch() {
        addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(topSeparator)
        containerView.addSubview(infoStackView)
        containerView.addSubview(bottomSeparator)
        containerView.addSubview(buttonsStackView)
    }

    func setUpConstraints() {
        let padding = DSSpacings.large.rawValue
        let innerPadding = DSSpacings.medium.rawValue

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            logoImageView.widthAnchor.constraint(equalToConstant: 64),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: innerPadding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                  constant: DSSpacings.small.rawValue),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),

            topSeparator.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                              constant: innerPadding),
            topSeparator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                  constant: DSSpacings.xLarge.rawValue),
            topSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                   constant: -DSSpacings.xLarge.rawValue),
            topSeparator.heightAnchor.constraint(equalToConstant: 3.0 / UIScreen.main.scale),

            infoStackView.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: innerPadding),
            infoStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),

            bottomSeparator.topAnchor.constraint(equalTo: infoStackView.bottomAnchor,
                                                 constant: innerPadding),
            bottomSeparator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                     constant: DSSpacings.xLarge.rawValue),
            bottomSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                      constant: -DSSpacings.xLarge.rawValue),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 3.0 / UIScreen.main.scale),

            twitterButton.widthAnchor.constraint(equalToConstant: 36),
            twitterButton.heightAnchor.constraint(equalToConstant: 36),
            websiteButton.widthAnchor.constraint(equalToConstant: 36),
            websiteButton.heightAnchor.constraint(equalToConstant: 36),

            buttonsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor,
                                                  constant: padding),
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding)
        ])
    }
}
