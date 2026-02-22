import UIKit

public final class ErrorView: UIView {
    private lazy var iconImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        let image = UIImage(systemName: "exclamationmark.triangle.fill",
                            withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .orange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSFonts.titl2eRegular
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = DSFonts.calloutRegular
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = DSFonts.footnoteRegular
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.clockwise")
        button.setImage(image, for: .normal)
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = DSFonts.bodyRegular
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        button.layer.cornerRadius = DSSpacings.medium
        button.contentEdgeInsets = UIEdgeInsets(
            top: DSSpacings.medium,
            left: DSSpacings.xLarge,
            bottom: DSSpacings.medium,
            right: DSSpacings.xLarge
        )
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: -DSSpacings.small,
                                              bottom: 0,
                                              right: DSSpacings.small)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel, codeLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = DSSpacings.medium
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, textStackView, retryButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = DSSpacings.xLarge
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public var retryAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(title: String,
                          message: String,
                          code: String? = nil,
                          buttonText: String? = nil) {
        titleLabel.text = title
        messageLabel.text = message

        if let code {
            codeLabel.text = "code: \(code)"
            codeLabel.isHidden = false
        }

        if let buttonText {
            retryButton.setTitle(buttonText, for: .normal)
        }
    }

    @objc private func retryButtonTapped() {
        retryAction?()
    }
}

extension ErrorView: ViewCode {
    public func buildViewHierarch() {
        addSubview(mainStackView)
    }

    public func setUpConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: DSSpacings.xLarge),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -DSSpacings.xLarge)
        ])
    }
}

#if DEBUG
import SwiftUI

@available(iOS 17.0, *)
#Preview {
    let view = ErrorView()
    view.configure(title: "Failed to load Exchanges",
                   message: "Our server is experiencing problems.\nPlease try again.",
                   code: "500")
    return view
}
#endif
