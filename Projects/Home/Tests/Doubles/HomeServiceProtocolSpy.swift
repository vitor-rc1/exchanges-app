//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
@testable import Home

@MainActor
final class HomeServiceProtocolSpy: HomeServiceProtocol, Sendable {
    enum Method: Equatable {
        case fetchExchangesList
        case fetchDetailsFor
    }

    var calledMethods: [Method] = []
    var fetchExchangesListResult: Result<[ExchangeSummary], Error>?
    var fetchDetailsForResult: Result<[ExchangeDetail], Error>?

    func fetchExchangesList(page: Int, limit: Int) async throws -> [ExchangeSummary] {
        await MainActor.run {
            calledMethods.append(.fetchExchangesList)
        }

        guard let result = fetchExchangesListResult else {
            fatalError("fetchExchangesListResult not set")
        }

        return try result.get()
    }

    func fetchDetailsFor(ids: [String]) async throws -> [ExchangeDetail] {
        await MainActor.run {
            calledMethods.append(.fetchDetailsFor)
        }

        guard let result = fetchDetailsForResult else {
            fatalError("fetchDetailsForResult not set")
        }

        return try result.get()
    }
}
