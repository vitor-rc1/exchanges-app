//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces

@MainActor
final class DetailViewModel: DetailViewModelProtocol {
    weak var delegate: DetailViewModelDelegate?
    weak var coordinatorDelegate: DetailViewModelCoordinatorDelegate?

    private let service: DetailServiceProtocol
    private var exchangeId: Int?
    private var exchange: Exchange?
    private(set) var assets: [Asset] = []
    private var detail: ExchangeDetailModel?

    private(set) var state: DetailViewState = .loading {
        didSet { delegate?.didUpdateState(state) }
    }

    init(service: DetailServiceProtocol) {
        self.service = service
    }

    func configure(with exchangeId: Int) {
        self.exchangeId = exchangeId
    }

    func configure(with exchange: Exchange) {
        self.exchange = exchange
    }

    func loadData() {
        if let exchange {
            let model = ExchangeDetailModel(from: exchange)
            self.detail = model
            state = .loaded(model)

            Task {
                do {
                    let assets = try await service.fetchExchangeAssets(id: exchange.id)
                    self.assets = assets
                    state = .loadedAssets
                } catch {
                    state = .errorLoadAssets(
                        title: "Failed to load assets",
                        message: error.localizedDescription,
                        code: 0
                    )
                }
            }
            return
        }

        state = .error("Invalid Exchanges, please try another option")
    }

    func didTapRetry() {
        loadData()
    }

    func didTapWebsite() {
        guard let urlString = detail?.websiteUrl,
              let url = URL(string: urlString) else { return }
        coordinatorDelegate?.didRequestOpenURL(url)
    }

    func didTapTwitter() {
        guard let urlString = detail?.twitterUrl,
              let url = URL(string: urlString) else { return }
        coordinatorDelegate?.didRequestOpenURL(url)
    }
}
