//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces
import NetworkingInterfaces

enum ServiceError: Error, Equatable {
    case decodeFail(String?)
    case network(Status)
}

final class HomeService: Sendable {
    private nonisolated(unsafe) let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    private func performRequest<T: Codable>(endpoint: APIEndpointProtocol) async throws -> T {
        let (data, httpUrlResponse) = try await networkService.request(endpoint: endpoint)

        switch httpUrlResponse.statusCode {
        case 200...299:
            return try decodeResponse(data)
        default:
            let error: Status = try decodeResponse(data)
            throw ServiceError.network(error)
        }
    }

    func decodeResponse<T: Codable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

extension HomeService: HomeServiceProtocol {
    func fetchExchangesList(page: Int, limit: Int) async throws -> [ExchangeSummary] {
        let endpoint = HomeEndpoint.fetchItems(page: page, limit: limit)
        let response: ExchangeResponse<ExchangeSummary> = try await performRequest(endpoint: endpoint)
        return response.data
    }

    func fetchDetailsFor(ids: [String]) async throws -> [ExchangeDetail] {
        let endpoint = HomeEndpoint.fetchDetail(ids: ids)
        let response: ExchangeDetailResponse<ExchangeDetail> = try await performRequest(endpoint: endpoint)
        return Array(response.data.values)
    }
}
