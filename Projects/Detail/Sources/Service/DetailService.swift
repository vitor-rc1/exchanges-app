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

enum DetailServiceError: Error, Equatable {
    case decodeFail(String?)
    case network(Status)
}

final class DetailService: Sendable {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    private func performRequest<T: Codable>(endpoint: APIEndpointProtocol) async throws -> T {
        let (data, httpUrlResponse) = try await networkService.request(endpoint: endpoint)

        switch httpUrlResponse.statusCode {
        case 200...299:
            return try decodeResponse(data)
        default:
            let error: StatusResponse = try decodeResponse(data)
            throw DetailServiceError.network(error.status)
        }
    }

    private func decodeResponse<T: Codable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

extension DetailService: DetailServiceProtocol {
    func fetchExchangeAssets(id: Int) async throws -> [Asset] {
        let endpoint = DetailEndpoint.fetchAssets(id: id)

        let response: ExchangeAssetsResponse = try await performRequest(endpoint: endpoint)

        return response
            .data
            .map { asset in
            Asset(id: asset.currency.cryptoId,
                  name: asset.currency.name,
                  symbol: asset.currency.symbol,
                  priceUsd: asset.currency.priceUsd)
        }
    }
}
