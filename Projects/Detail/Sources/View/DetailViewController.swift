//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import UIKit
import DesignSystem

@MainActor
final class DetailViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case assets = 0
    }

    private let viewModel: DetailViewModelProtocol
    private var detailModel: ExchangeDetailModel?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()

    private lazy var headerView: DetailHeaderView = {
        let view = DetailHeaderView()
        return view
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.delegate = self
        viewModel.loadData()
    }

    private func updateTableHeaderView() {
        headerView.frame.size.width = tableView.bounds.width

        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let dynamicSize = headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        if headerView.frame.height != dynamicSize.height {
            headerView.frame.size.height = dynamicSize.height
            tableView.tableHeaderView = headerView
        }
    }

    @objc private func didTapWebsiteButton() {
        viewModel.didTapWebsite()
    }

    @objc private func didTapTwitterButton() {
        viewModel.didTapTwitter()
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if case .loadedAssets = viewModel.state, viewModel.assets.isEmpty {
            return 0
        }

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.assets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InfoCell.identifier,
            for: indexPath
        ) as? InfoCell else {
            return UITableViewCell()
        }

        let asset = viewModel.assets[indexPath.row]
        cell.configure(state: .loaded(.init(
            url: "",
            title: asset.name,
            subtitle: asset.formattedPrice,
            defaultImage: UIImage(systemName: "bitcoinsign.circle.fill"),
            hiddenChevron: true
        )))
        return cell
    }
}

extension DetailViewController: ViewCode {
    func buildViewHierarch() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func additionalConfiguration() {
        view.backgroundColor = .systemBackground

        headerView.websiteButton.addTarget(self, action: #selector(didTapWebsiteButton), for: .touchUpInside)
        headerView.twitterButton.addTarget(self, action: #selector(didTapTwitterButton), for: .touchUpInside)
        errorView.retryAction = { [weak self] in
            self?.viewModel.didTapRetry()
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderSectionView()

        headerView.configure(title: "Assets")
        headerView.loader.startAnimating()

        if case .loadedAssets = viewModel.state {
            headerView.loader.stopAnimating()
            headerView.loader.isHidden = true
        }

        return headerView
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func didUpdateState(_ state: DetailViewState) {
        switch state {
        case .loading:
            tableView.isHidden = true
            errorView.isHidden = true
            loadingIndicator.startAnimating()

        case .loaded(let model):
            loadingIndicator.stopAnimating()
            errorView.isHidden = true
            tableView.isHidden = false
            detailModel = model
            title = model.name
            headerView.configure(with: model)
            updateTableHeaderView()

        case .loadingAssets:
            return
        case .loadedAssets:
            if viewModel.assets.isEmpty {
                tableView.reloadData()
                return
            }
            let indexSet = IndexSet(integer: Section.assets.rawValue)
            tableView.reloadSections(indexSet, with: .fade)

        case .error(let message):
            loadingIndicator.stopAnimating()
            tableView.isHidden = true
            errorView.isHidden = false
            errorView.configure(title: "Error Loading Details", message: message)

        case .errorLoadAssets(let title, let message, _):
            errorView.isHidden = false
            errorView.configure(title: title, message: message)
            errorView.retryAction = { [weak self] in
                self?.viewModel.didTapRetry()
            }
        }
    }
}
