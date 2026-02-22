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
    case requestError(String?)
    case network(Status)
}

final class HomeService: Sendable {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    @concurrent
    private func performRequest<T: Codable>(endpoint: APIEndpointProtocol) async throws(ServiceError) -> T {
        let (data, httpUrlResponse): (Data, HTTPURLResponse)

        do {
            (data, httpUrlResponse) = try await networkService.request(endpoint: endpoint)
        } catch {
            throw ServiceError.requestError(error.localizedDescription)
        }

        switch httpUrlResponse.statusCode {
        case 200...299:
            return try decodeResponse(data)
        default:
            let error: StatusResponse = try decodeResponse(data)
            throw ServiceError.network(error.status)
        }
    }

    func decodeResponse<T: Codable>(_ data: Data) throws(ServiceError) -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ServiceError.decodeFail(error.localizedDescription)
        }

    }
}

extension HomeService: HomeServiceProtocol {
    @concurrent
    func fetchExchangesList(page: Int, limit: Int) async throws(ServiceError) -> [ExchangeSummary] {
        let endpoint = HomeEndpoint.fetchItems(page: page, limit: limit)
        let response: ExchangeResponse<ExchangeSummary> = try await performRequest(endpoint: endpoint)
        return response.data
    }

    @concurrent
    func fetchDetailsFor(ids: [String]) async throws(ServiceError) -> [ExchangeDetail] {
        let endpoint = HomeEndpoint.fetchDetail(ids: ids)
        let response: ExchangeDetailResponse<ExchangeDetail> = try await performRequest(endpoint: endpoint)
        return Array(response.data.values)
    }
}
