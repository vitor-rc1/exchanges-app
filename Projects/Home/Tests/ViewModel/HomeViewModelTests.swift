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

@testable import Home

@MainActor
@Suite
struct HomeViewModelTests {
    @Test("GIVEN empty state WHEN loadData is called THEN fetches exchanges and updates state to empty")
    func testLoadDataSuccess() async throws {
        let (sut, doubles) = makeSut()
        doubles.serviceSpy.fetchExchangesListResult = .success([])

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods == [.fetchExchangesList])
        #expect(sut.numberOfItems == 0)
        #expect(doubles.delegateSpy.calledMethods == [.didUpdateState(.loading),
                                                      .didUpdateState(.empty)])
    }

    @Test("GIVEN empty state WHEN loadData fails THEN updates state to error")
    func testLoadDataError() async throws {
        let (sut, doubles) = makeSut()
        let messageError = "Failed to Load data. Press try again later or check your connection."
        let serviceError = ServiceError.network(.init(timestamp: "",
                                                      errorCode: 1,
                                                      errorMessage: messageError,
                                                      elapsed: 0,
                                                      creditCount: 0))
        doubles.serviceSpy.fetchExchangesListResult = .failure(serviceError)

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods.contains(.fetchExchangesList))
        #expect(sut.numberOfItems == 0)
        #expect(doubles.delegateSpy.calledMethods == [.didUpdateState(.loading),
                                                      .didUpdateState(.error(messageError, "1"))])
    }

    @Test("GIVEN empty state WHEN loadData fails with decodeFail THEN updates state to error with default message")
    func testLoadDataDecodeFailError() async throws {
        let (sut, doubles) = makeSut()
        doubles.serviceSpy.fetchExchangesListResult = .failure(.decodeFail(nil))

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods.contains(.fetchExchangesList))
        #expect(sut.numberOfItems == 0)
        #expect(doubles.delegateSpy.calledMethods == [.didUpdateState(.loading),
                                                      .didUpdateState(.error("Failed to load data. Press try again or check your connection.", nil))])
    }

    @Test("GIVEN empty state WHEN loadData fails with requestError THEN updates state to error with request error message")
    func testLoadDataRequestError() async throws {
        let (sut, doubles) = makeSut()
        let errorMessage = "Request timed out."
        doubles.serviceSpy.fetchExchangesListResult = .failure(.requestError(errorMessage))

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods.contains(.fetchExchangesList))
        #expect(sut.numberOfItems == 0)
        #expect(doubles.delegateSpy.calledMethods == [.didUpdateState(.loading),
                                                      .didUpdateState(.error(errorMessage, nil))])
    }

    @Test("GIVEN empty state WHEN loadData fails with requestError nil message THEN updates state to error with default message")
    func testLoadDataRequestErrorNilMessage() async throws {
        let (sut, doubles) = makeSut()
        doubles.serviceSpy.fetchExchangesListResult = .failure(.requestError(nil))

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods.contains(.fetchExchangesList))
        #expect(sut.numberOfItems == 0)
        #expect(doubles.delegateSpy.calledMethods == [.didUpdateState(.loading),
                                                      .didUpdateState(.error("Failed to load data. Press try again or check your connection.", nil))])
    }

    @Test("GIVEN empty state WHEN loadData returns empty array THEN updates state to empty")
    func testLoadDataEmpty() async throws {
        let (sut, doubles) = makeSut()
        doubles.serviceSpy.fetchExchangesListResult = .success([])

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods == [.fetchExchangesList])
        #expect(sut.numberOfItems == 0)
        #expect(doubles.delegateSpy.calledMethods == [.didUpdateState(.loading),
                                                      .didUpdateState(.empty)])
    }

    @Test("GIVEN valid index WHEN didSelectRow is called THEN notifies coordinator delegate")
    func testDidSelectRow() async throws {
        let (sut, doubles) = makeSut()

        let summaries = [ExchangeSummary(id: 1, name: "Binance")]
        let detail = ExchangeDetail(
            id: 1,
            name: "Binance",
            description: "Binance Exchange",
            logo: "https://logo.url",
            spotVolumeUsd: 1000000.0,
            makerFee: 0.001,
            takerFee: 0.002,
            dateLaunched: "14-07-2017",
            urls: ExchangeURLs(website: ["https://binance.com"], twitter: ["@binance"])
        )
        let exchange = Exchange(id: 1,
                                name: "Binance",
                                description: "Binance Exchange",
                                logo: "https://logo.url",
                                spotVolumeUsd: "$ 1.000.000,00",
                                makerFee: 0.001,
                                takerFee: 0.002,
                                dateLaunched: "Date launched: 14-07-2017",
                                websiteUrl: "https://binance.com",
                                twitterUrl: "@binance"
                            )

        doubles.serviceSpy.fetchExchangesListResult = .success(summaries)
        doubles.serviceSpy.fetchDetailsForResult = .success([detail])

        sut.loadData()
        try await Task.sleep(nanoseconds: 100_000_000)

        sut.didSelectRow(at: 0)

        #expect(doubles.coordinatorDelegateSpy.calledMethods == [.navigateToDetails(exchange)])
    }

    @Test("GIVEN loaded exchanges WHEN item is requested at valid index THEN returns correct exchange")
    func testItemAtIndex() async throws {
        let (sut, doubles) = makeSut()

        let summaries = [
            ExchangeSummary(id: 1, name: "Binance"),
            ExchangeSummary(id: 2, name: "Coinbase")
        ]
        let details = [
            ExchangeDetail(
                id: 1,
                name: "Binance",
                description: "Binance Exchange",
                logo: "https://logo1.url",
                spotVolumeUsd: 1000000.0,
                makerFee: 0.001,
                takerFee: 0.002,
                dateLaunched: "2017-07-14",
                urls: ExchangeURLs(website: ["https://binance.com"], twitter: ["@binance"])
            ),
            ExchangeDetail(
                id: 2,
                name: "Coinbase",
                description: "Coinbase Exchange",
                logo: "https://logo2.url",
                spotVolumeUsd: 2000000.0,
                makerFee: 0.003,
                takerFee: 0.004,
                dateLaunched: "2012-06-01",
                urls: ExchangeURLs(website: ["https://coinbase.com"], twitter: ["@coinbase"])
            )
        ]

        doubles.serviceSpy.fetchExchangesListResult = .success(summaries)
        doubles.serviceSpy.fetchDetailsForResult = .success(details)

        sut.loadData()
        try await Task.sleep(nanoseconds: 100_000_000)

        let firstItem = sut.item(at: 0)
        let secondItem = sut.item(at: 1)

        #expect(firstItem.id == 1)
        #expect(firstItem.name == "Binance")
        #expect(secondItem.id == 2)
        #expect(secondItem.name == "Coinbase")
    }
}

extension HomeViewModelTests {
    typealias SutAndDoubles = (
        sut: HomeViewModel,
        doubles: (
            serviceSpy: HomeServiceProtocolSpy,
            delegateSpy: HomeViewModelDelegateSpy,
            coordinatorDelegateSpy: HomeViewModelCoordinatorDelegateSpy
        )
    )

    func makeSut() -> SutAndDoubles {
        let serviceSpy = HomeServiceProtocolSpy()
        let delegateSpy = HomeViewModelDelegateSpy()
        let coordinatorDelegateSpy = HomeViewModelCoordinatorDelegateSpy()
        let ptBRLocale = Locale(identifier: "pt_BR")
        let sut = HomeViewModel(service: serviceSpy,
                                stringFormatter: .init(locale: ptBRLocale),
                                numbersFormatter: .init(locale: ptBRLocale))
        sut.delegate = delegateSpy
        sut.coordinatorDelegate = coordinatorDelegateSpy

        return (sut, (serviceSpy, delegateSpy, coordinatorDelegateSpy))
    }
}
