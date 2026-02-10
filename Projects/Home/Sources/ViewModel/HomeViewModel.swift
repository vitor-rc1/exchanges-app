//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import HomeInterfaces
import Foundation

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    private let service: HomeServiceProtocol

    private var currentPage = 1
    private var isFetching = false
    private var hasMorePages = true

    private(set) var exchanges: [Exchange] = []
    private(set) var state: HomeViewState = .loading {
        didSet { delegate?.didUpdateState(state) }
    }

    var numberOfItems: Int { exchanges.count }

    init(service: HomeServiceProtocol) {
        self.service = service
    }

    func loadData() {
        guard !isFetching && hasMorePages else { return }

        isFetching = true

        if exchanges.isEmpty {
            state = .loading
        } else {
            state = .loadingMore
        }

        Task {
            do {
                let summaries = try await service.fetchExchangesList(page: currentPage, limit: 20)

                if summaries.isEmpty {
                    hasMorePages = false
                    isFetching = false
                    if exchanges.isEmpty {
                        state = .empty
                    } else {
                        state = .loaded
                    }
                    return
                }

                let newItems = summaries.map { Exchange(summary: $0) }
                self.exchanges.append(contentsOf: newItems)

                state = .loaded

                let ids = summaries.map { "\($0.id)" }
                guard !ids.isEmpty else {
                    hasMorePages = false
                    isFetching = false
                    return
                }

                let detailsList = try await service.fetchDetailsFor(ids: ids)

                let detailsMap = Dictionary(uniqueKeysWithValues: detailsList.map { ($0.id, $0) })

                self.exchanges = self.exchanges.map { item in
                    guard let detail = detailsMap[item.id] else { return item }

                    return mapToExchange(item, detail)
                }

                currentPage += 1
                isFetching = false
                state = .loaded

            } catch {
                isFetching = false
                if exchanges.isEmpty {
                    let serviceError = error as? ServiceError
                    let defaultMessage = "Failed to Load data. Press try again later or check your connection."
                    let message: String
                    var code: String?
                    switch serviceError {
                    case .decodeFail, .none:
                        message = defaultMessage
                    case .network(let status):
                        message = status.errorMessage ?? defaultMessage
                        if let statusCode = status.errorCode {
                            code = String(statusCode)
                        }
                    }
                    state = .error(message, code)
                } else {
                    state = .loaded
                }
            }
        }
    }

    func item(at index: Int) -> Exchange {
        exchanges[index]
    }

    func didSelectRow(at index: Int) {
        guard exchanges.indices.contains(index) else { return }
        coordinatorDelegate?.navigateToDetails(of: exchanges[index])
    }

    private func mapToExchange(_ item: Exchange, _ detail: ExchangeDetail) -> Exchange {
        return Exchange(id: item.id,
                        name: item.name,
                        description: detail.description,
                        logo: detail.logo,
                        spotVolumeUsd: detail.spotVolumeUsd,
                        makerFee: detail.makerFee,
                        takerFee: detail.takerFee,
                        dateLaunched: detail.dateLaunched,
                        websiteUrl: detail.urls.website.first,
                        twitterUrl: detail.urls.twitter.first)
    }

    func formatPrice(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","

        formatter.locale = Locale(identifier: "pt_BR")

        return formatter.string(from: NSNumber(value: value)) ?? "$ 0,00"
    }

    func formatDate(_ date: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: date) else {
            return date
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .none
        displayFormatter.locale = Locale.current

        return displayFormatter.string(from: date)
    }
}
