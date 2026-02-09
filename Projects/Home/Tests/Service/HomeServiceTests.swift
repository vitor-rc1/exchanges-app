//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import Foundation
@testable import Home

@Suite
struct HomeServiceTests {
    @Test("GIVEN successful response WHEN fetchExchangesList is called THEN returns exchange summaries")
    func testFetchExchangesListSuccess() async throws {
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
                {"id": 1, "name": "Binance"},
                {"id": 2, "name": "Coinbase"}
            ]
        }
        """
        let data = mockResponse.data(using: .utf8)!
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        networkSpy.requestResult = .success((data, httpResponse))

        let result = try await sut.fetchExchangesList(page: 1, limit: 20)

        #expect(networkSpy.calledMethods == [.request])
        #expect(result.count == 2)
        #expect(result[0].id == 1)
        #expect(result[0].name == "Binance")
        #expect(result[1].id == 2)
        #expect(result[1].name == "Coinbase")
    }

    @Test("GIVEN error response WHEN fetchExchangesList is called THEN throws network error")
    func testFetchExchangesListNetworkError() async throws {
        let (sut, networkSpy) = makeSut()
        let expectedError = ServiceError.network(Status(
            timestamp: "2024-01-01T00:00:00.000Z",
            errorCode: 401,
            errorMessage: "Invalid API Key",
            elapsed: 10,
            creditCount: 1
        ))
        let mockResponse = """
        {
            "timestamp": "2024-01-01T00:00:00.000Z",
            "error_code": 401,
            "error_message": "Invalid API Key",
            "elapsed": 10,
            "credit_count": 1
        }
        """
        let data = mockResponse.data(using: .utf8)!
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )!

        networkSpy.requestResult = .success((data, httpResponse))

        await #expect(throws: expectedError) {
            _ = try await sut.fetchDetailsFor(ids: ["1"])
        }
        #expect(networkSpy.calledMethods == [.request])
    }

    @Test("GIVEN successful response WHEN fetchDetailsFor is called THEN returns exchange details")
    func testFetchDetailsForSuccess() async throws {
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
            "data": {
                "1": {
                    "id": 1,
                    "name": "Binance",
                    "description": "Binance Exchange",
                    "logo": "https://logo.url",
                    "spot_volume_usd": 1000000.0,
                    "maker_fee": 0.001,
                    "taker_fee": 0.002,
                    "date_launched": "2017-07-14",
                    "urls": {
                        "website": ["https://binance.com"],
                        "twitter": ["https://twitter.com/binance"]
                    }
                }
            }
        }
        """
        let data = mockResponse.data(using: .utf8)!
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        networkSpy.requestResult = .success((data, httpResponse))

        let result = try await sut.fetchDetailsFor(ids: ["1"])

        #expect(networkSpy.calledMethods == [.request])
        #expect(result.count == 1)
        #expect(result[0].id == 1)
        #expect(result[0].name == "Binance")
        #expect(result[0].description == "Binance Exchange")
    }

    @Test("GIVEN error response WHEN fetchDetailsFor is called THEN throws network error")
    func testFetchDetailsForNetworkError() async throws {
        let (sut, networkSpy) = makeSut()
        let expectedError = ServiceError.network(Status(
            timestamp: "2024-01-01T00:00:00.000Z",
            errorCode: 500,
            errorMessage: "Internal Server Error",
            elapsed: 10,
            creditCount: 1
        ))

        let mockResponse = """
        {
            "timestamp": "2024-01-01T00:00:00.000Z",
            "error_code": 500,
            "error_message": "Internal Server Error",
            "elapsed": 10,
            "credit_count": 1
        }
        """
        let data = mockResponse.data(using: .utf8)!
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        networkSpy.requestResult = .success((data, httpResponse))

        await #expect(throws: expectedError) {
            _ = try await sut.fetchDetailsFor(ids: ["1"])
        }
        #expect(networkSpy.calledMethods == [.request])
    }
}

extension HomeServiceTests {
    typealias SutAndDoubles = (
        sut: HomeService,
        networkSpy: NetworkServiceProtocolSpy
    )

    func makeSut() -> SutAndDoubles {
        let networkSpy = NetworkServiceProtocolSpy()
        let sut = HomeService(networkService: networkSpy)
        return (sut, networkSpy)
    }
}
