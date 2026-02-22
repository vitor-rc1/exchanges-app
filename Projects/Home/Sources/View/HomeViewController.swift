//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import DesignSystem
import UIKit

class HomeViewController: UIViewController {

    private let viewModel: HomeViewModelProtocol

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var footerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Exchanges"
        setupView()

        tableView.tableFooterView = footerSpinner
        viewModel.delegate = self
        viewModel.loadData()
    }
}

extension HomeViewController: ViewCode {
    func buildViewHierarch() {
        view.addSubview(tableView)
        view.addSubview(errorView)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            errorView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func additionalConfiguration() {
        errorView.retryAction = { [weak self] in
            self?.viewModel.loadData()
        }
    }
}

// MARK: - Delegate (Updates)
extension HomeViewController: HomeViewModelDelegate {
    func didUpdateState(_ state: HomeViewState) {
        switch state {
        case .loading:
            tableView.isHidden = false
            errorView.isHidden = true
        case .loadingMore:
            footerSpinner.startAnimating()
        case .loaded:
            footerSpinner.stopAnimating()
            errorView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        case .empty:
            errorView.configure(title: "No exchanges found..",
                                message: "Try again later or check your connection.")
            errorView.isHidden = false
        case let .error(msg, code):
            tableView.isHidden = true
            footerSpinner.stopAnimating()
            if viewModel.numberOfItems == 0 {
                errorView.configure(title: "Failed to load Exchanges",
                                    message: msg,
                                    code: code)
                errorView.isHidden = false
            }
        }
    }
}

// MARK: - TableView (Pagination & Cells)
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .loading:
            return 3
        default:
            return viewModel.numberOfItems
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier,
                                                       for: indexPath) as? InfoCell else {
            return UITableViewCell()
        }

        switch viewModel.state {
        case .loading:
            cell.configure(state: .loading())
        case .loaded:
            let item = viewModel.item(at: indexPath.row)
            if item.isLoadingDetails {
                cell.configure(state: .partialLoaded(.init(title: item.name)))
            } else {
                let volPrice = "Vol: \(viewModel.formatPrice(item.spotVolumeUsd ?? 0.0))"
                let dateLaunched = "Date launched: \(viewModel.formatDate(item.dateLaunched))"
                cell.configure(state: .loaded(.init(url: item.logo,
                                                    title: item.name,
                                                    subtitle: volPrice,
                                                    detail: dateLaunched)))
            }
        default:
            return UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = viewModel.numberOfItems - 3
        if indexPath.row >= threshold {
            viewModel.loadData()
        }
    }
}
