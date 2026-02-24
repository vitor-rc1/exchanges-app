//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import Foundation
import HomeInterfaces
@testable import Detail

@MainActor
struct DetailViewModelTests {

    @Test("GIVEN valid exchange WHEN loadData is called THEN fetches assets and updates state to loaded")
    func testLoadDataSuccess() async throws {
        let (sut, doubles) = makeSut()
        let mockAssets = [
            Asset(id: 1, name: "Bitcoin", symbol: "BTC", priceUsd: 50000.0)
        ]
        doubles.serviceSpy.fetchExchangeAssetsResult = .success(mockAssets)

        sut.configure(with: makeExchange())

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        let expectedModel = ExchangeDetailModel(from: makeExchange())
        #expect(doubles.serviceSpy.calledMethods == [.fetchExchangeAssets])
        #expect(doubles.delegateSpy.calledMethods == [
            .didUpdateState(.loaded(expectedModel)),
            .didUpdateState(.loadedAssets)
        ])
        #expect(sut.assets == mockAssets)
    }

    @Test("GIVEN no exchange configured WHEN loadData is called THEN updates state to error")
    func testLoadDataWithoutConfiguredExchange() async throws {
        let (sut, doubles) = makeSut()

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods.isEmpty)
        #expect(doubles.delegateSpy.calledMethods == [
            .didUpdateState(.error("Invalid Exchanges, please try another option"))
        ])
    }

    @Test("GIVEN network error WHEN loadData is called THEN updates state to errorLoadAssets")
    func testLoadDataAssetsError() async throws {
        let (sut, doubles) = makeSut()
        let error = NSError(domain: "test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        doubles.serviceSpy.fetchExchangeAssetsResult = .failure(error)

        sut.configure(with: makeExchange())

        sut.loadData()

        try await Task.sleep(nanoseconds: 100_000_000)

        let expectedModel = ExchangeDetailModel(from: makeExchange())
        #expect(doubles.serviceSpy.calledMethods == [.fetchExchangeAssets])
        #expect(doubles.delegateSpy.calledMethods == [
            .didUpdateState(.loaded(expectedModel)),
            .didUpdateState(.errorLoadAssets(
                title: "Failed to load assets",
                message: "Server error",
                code: 0
            ))
        ])
    }

    @Test("GIVEN loaded state with website URL WHEN didTapWebsite is called THEN notifies coordinator")
    func testDidTapWebsite() async throws {
        let (sut, doubles) = makeSut()
        doubles.serviceSpy.fetchExchangeAssetsResult = .success([])

        sut.configure(with: makeExchange(websiteUrl: "https://binance.com"))
        sut.loadData()
        try await Task.sleep(nanoseconds: 100_000_000)

        sut.didTapWebsite()

        #expect(doubles.coordinatorDelegateSpy.calledMethods == [
            .didRequestOpenURL(URL(string: "https://binance.com")!)
        ])
    }

    @Test("GIVEN loaded state with twitter URL WHEN didTapTwitter is called THEN notifies coordinator")
    func testDidTapTwitter() async throws {
        let (sut, doubles) = makeSut()
        doubles.serviceSpy.fetchExchangeAssetsResult = .success([])

        sut.configure(with: makeExchange(twitterUrl: "https://twitter.com/binance"))
        sut.loadData()
        try await Task.sleep(nanoseconds: 100_000_000)

        sut.didTapTwitter()

        #expect(doubles.coordinatorDelegateSpy.calledMethods == [
            .didRequestOpenURL(URL(string: "https://twitter.com/binance")!)
        ])
    }

    @Test("GIVEN error state WHEN didTapRetry is called THEN retries loading data")
    func testDidTapRetry() async throws {
        let (sut, doubles) = makeSut()
        let error = NSError(domain: "test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        doubles.serviceSpy.fetchExchangeAssetsResult = .failure(error)

        sut.configure(with: makeExchange())
        sut.loadData()
        try await Task.sleep(nanoseconds: 100_000_000)

        let mockAssets = [
            Asset(id: 1, name: "Bitcoin", symbol: "BTC", priceUsd: 50000.0)
        ]
        doubles.serviceSpy.fetchExchangeAssetsResult = .success(mockAssets)

        sut.didTapRetry()
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(doubles.serviceSpy.calledMethods == [.fetchExchangeAssets, .fetchExchangeAssets])
        #expect(doubles.delegateSpy.calledMethods.last == .didUpdateState(.loadedAssets))
        #expect(sut.assets == mockAssets)
    }
}

extension DetailViewModelTests {
    typealias SutAndDoubles = (
        sut: DetailViewModel,
        doubles: (
            serviceSpy: DetailServiceProtocolSpy,
            delegateSpy: DetailViewModelDelegateSpy,
            coordinatorDelegateSpy: DetailViewModelCoordinatorDelegateSpy
        )
    )

    func makeSut() -> SutAndDoubles {
        let serviceSpy = DetailServiceProtocolSpy()
        let delegateSpy = DetailViewModelDelegateSpy()
        let coordinatorDelegateSpy = DetailViewModelCoordinatorDelegateSpy()

        let sut = DetailViewModel(service: serviceSpy)
        sut.delegate = delegateSpy
        sut.coordinatorDelegate = coordinatorDelegateSpy

        return (sut, (serviceSpy, delegateSpy, coordinatorDelegateSpy))
    }

    func makeExchange(
        id: Int = 1,
        name: String = "Binance",
        description: String? = "Binance Exchange",
        logo: String = "https://logo.url",
        spotVolumeUsd: String = "$ 1.000.000,0",
        makerFee: Double = 0.1,
        takerFee: Double = 0.2,
        dateLaunched: String = "2017-07-14",
        websiteUrl: String? = nil,
        twitterUrl: String? = nil
    ) -> Exchange {
        Exchange(
            id: id,
            name: name,
            description: description,
            logo: logo,
            spotVolumeUsd: spotVolumeUsd,
            makerFee: makerFee,
            takerFee: takerFee,
            dateLaunched: dateLaunched,
            websiteUrl: websiteUrl,
            twitterUrl: twitterUrl
        )
    }
}
