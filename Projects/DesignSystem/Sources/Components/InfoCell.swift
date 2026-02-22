import UIKit

public final class InfoCell: UITableViewCell {

    public static let identifier = "InfoCell"

    // MARK: - Models
    public enum State {
        case loaded(InfoCellModel)
        case partialLoaded(String)
        case loading
    }

    public struct InfoCellModel {
        public let url: String
        public let title: String
        public let subtitle: String
        public let detail: String

        public init(url: String, title: String, subtitle: String, detail: String) {
            self.url = url
            self.title = title
            self.subtitle = subtitle
            self.detail = detail
        }
    }

    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private lazy var iconImageView = makeImageView()
    private lazy var titleLabel = makeLabel(font: DSFonts.bodyRegular,
                                            color: .label)
    private lazy var subtitleLabel = makeLabel(font: DSFonts.subheadlineRegular,
                                               color: .systemGreen)
    private lazy var detailLabel = makeLabel(font: DSFonts.subheadlineRegular,
                                             color: .secondaryLabel)

    private lazy var chevronImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: config))
        imageView.tintColor = .tertiaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { nil }

    public override func prepareForReuse() {
        super.prepareForReuse()
        [iconImageView, titleLabel, subtitleLabel, detailLabel].forEach { $0.setSkeleton(false) }
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        detailLabel.text = nil
    }

    // MARK: - Public Configuration
    public func configure(state: State) {
        [iconImageView, titleLabel, subtitleLabel, detailLabel].forEach { $0.setSkeleton(false) }

        switch state {
        case let .loaded(model):
            titleLabel.text = model.title
            subtitleLabel.text = model.subtitle
            detailLabel.text = model.detail
            iconImageView.image = UIImage(systemName: "bahtsign.bank.building.fill")
            loadImage(from: model.url)

        case let .partialLoaded(title):
            iconImageView.image = UIImage(systemName: "bahtsign.bank.building.fill")
            titleLabel.text = title
            subtitleLabel.text = " "; subtitleLabel.setSkeleton(true)
            detailLabel.text = " "; detailLabel.setSkeleton(true)

        case .loading:
            iconImageView.setSkeleton(true, cornerRadius: 11)
            titleLabel.text = " "
            titleLabel.setSkeleton(true)
            subtitleLabel.text = " "
            subtitleLabel.setSkeleton(true)
            detailLabel.text = " "
            detailLabel.setSkeleton(true)
        }
    }
}

// MARK: - Factory & ViewCode
private extension InfoCell {
    func makeLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .secondarySystemFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run { iconImageView.image = image }
                }
            } catch {}
        }
    }
}

extension InfoCell: ViewCode {
    public func buildViewHierarch() {
        contentView.addSubview(containerView)
        [iconImageView,
         textStackView,
         chevronImageView].forEach { containerView.addSubview($0) }
    }

    public func setUpConstraints() {
        let horizontalPadding = DSSpacings.large.rawValue
        let verticalPadding = DSSpacings.small.rawValue

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 84),

            containerView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor,
                                               constant: verticalPadding),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                  constant: -verticalPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: horizontalPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -horizontalPadding),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                   constant: horizontalPadding),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),

            textStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,
                                                   constant: 12),
            textStackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor,
                                                    constant: -12),
            textStackView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor,
                                               constant: 12),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor,
                                                  constant: -12),

            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                       constant: -horizontalPadding),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14)
        ])
    }

    public func additionalConfiguration() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

#if DEBUG
import SwiftUI

@available(iOS 17.0, *)
#Preview("Loaded") {
    let view = InfoCell()
    view.configure(state: .loaded(.init(
        url: "",
        title: "Binance",
        subtitle: "Vol: $1234.23",
        detail: "Date launched: 12/03/2025"
    )))
    return view
}

@available(iOS 17.0, *)
#Preview("Partial Loaded") {
    let view = InfoCell()
    view.configure(state: .partialLoaded("Binance"))
    return view
}

@available(iOS 17.0, *)
#Preview("Loading") {
    let view = InfoCell()
    view.configure(state: .loading)
    return view
}
#endif
