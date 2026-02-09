//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import UIKit

class HomeViewController: UIViewController {

    private let viewModel: HomeViewModelProtocol

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var footerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
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
        setupLayout()

        tableView.tableFooterView = footerSpinner

        viewModel.delegate = self
        viewModel.loadData()
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Delegate (Updates)
extension HomeViewController: HomeViewModelDelegate {
    func didUpdateState(_ state: HomeViewState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            messageLabel.isHidden = true

        case .loadingMore:
            footerSpinner.startAnimating()

        case .loaded:
            loadingIndicator.stopAnimating()
            footerSpinner.stopAnimating()
            messageLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()

        case .empty:
            loadingIndicator.stopAnimating()
            messageLabel.text = "No exchanges found.."
            messageLabel.isHidden = false

        case .error(let msg):
            loadingIndicator.stopAnimating()
            footerSpinner.stopAnimating()
            if viewModel.numberOfItems == 0 {
                messageLabel.text = msg
                messageLabel.isHidden = false
            } else {
                print(msg)
            }
        }
    }
}

// MARK: - TableView (Pagination & Cells)
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = viewModel.item(at: indexPath.row)

        var content = cell.defaultContentConfiguration()
        content.text = item.name

        if item.isLoadingDetails {
            content.secondaryText = "Loading..."
            content.secondaryTextProperties.color = .systemBlue
        } else {
            content.secondaryText = "See more"
            content.secondaryTextProperties.color = .secondaryLabel
        }

        cell.contentConfiguration = content
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
