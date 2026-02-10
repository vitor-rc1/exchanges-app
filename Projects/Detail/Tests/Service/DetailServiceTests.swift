//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces
import Testing

@testable import Detail

struct DetailServiceTests {
    @Test("GIVEN successful response WHEN fetchExchangeAssets is called THEN returns mapped assets")
    func testFetchExchangeAssetsSuccess() async throws {
        let (sut, networkSpy) = makeSut()
        let mockResponse = """
        {
            "status": {
                "timestamp": "2024-01-01T00:00:00.000Z",
                "error_code": null,
                "error_message": null,
                "elapsed": 10,
                "credit_count": 1
            },
            "data": [
                {
                    "wallet_address": "0x123",
                    "balance": 100.0,
                    "currency": {
                        "crypto_id": 1,
                        "price_usd": 50000.0,
                        "symbol": "BTC",
                        "name": "Bitcoin"
                    }
                },
                {
                    "wallet_address": "0x456",
                    "balance": 200.0,
                    "currency": {
                        "crypto_id": 2,
                        "price_usd": 3000.0,
                        "symbol": "ETH",
                        "name": "Ethereum"
                    }
                }
            ]
        }
        """
        let data = try #require(mockResponse.data(using: .utf8))
        let url = try #require(URL(string: "https://api.example.com"))
        let httpResponse = try #require(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))

        networkSpy.requestResult = .success((data, httpResponse))

        let result = try await sut.fetchExchangeAssets(id: 1)

        #expect(networkSpy.calledMethods == [.request])
        #expect(result.count == 2)
        #expect(result[0] == Asset(id: 1, name: "Bitcoin", symbol: "BTC", priceUsd: 50000.0))
        #expect(result[1] == Asset(id: 2, name: "Ethereum", symbol: "ETH", priceUsd: 3000.0))
    }

    @Test("GIVEN error response WHEN fetchExchangeAssets is called THEN throws network error")
    func testFetchExchangeAssetsNetworkError() async throws {
        let (sut, networkSpy) = makeSut()
        let mockResponse = """
        { 
            "status": {
                "timestamp": "2024-01-01T00:00:00.000Z",
                "error_code": 404,
                "error_message": "Exchange not found",
                "elapsed": 10,
                "credit_count": 1
            }
        }
        """
        let data = try #require(mockResponse.data(using: .utf8))
        let url = try #require(URL(string: "https://api.example.com"))
        let httpResponse = try #require(HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        ))

        networkSpy.requestResult = .success((data, httpResponse))

        do {
            _ = try await sut.fetchExchangeAssets(id: 999)
            Issue.record("Expected error to be thrown")
        } catch let error as DetailServiceError {
            #expect(error == .network(Status(
                timestamp: "2024-01-01T00:00:00.000Z",
                errorCode: 404,
                errorMessage: "Exchange not found",
                elapsed: 10,
                creditCount: 1
            )))
            #expect(networkSpy.calledMethods == [.request])
        }
    }

    @Test("GIVEN decode failure WHEN fetchExchangeAssets is called THEN throws error")
    func testFetchExchangeAssetsDecodeFail() async throws {
        let (sut, networkSpy) = makeSut()
        let mockResponse = """
        { "invalid": "json" }
        """
        let data = try #require(mockResponse.data(using: .utf8))
        let url = try #require(URL(string: "https://api.example.com"))
        let httpResponse = try #require(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))

        networkSpy.requestResult = .success((data, httpResponse))

        do {
            _ = try await sut.fetchExchangeAssets(id: 1)
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(networkSpy.calledMethods == [.request])
        }
    }
}

extension DetailServiceTests {
    typealias SutAndDoubles = (
        sut: DetailService,
        networkSpy: NetworkServiceProtocolSpy
    )

    func makeSut() -> SutAndDoubles {
        let networkSpy = NetworkServiceProtocolSpy()
        let sut = DetailService(networkService: networkSpy)
        return (sut, networkSpy)
    }
}
