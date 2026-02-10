//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import DependencyInjectionInterfaces
import DependencyInjectionTesting
import HomeInterfaces
import NavigationInterfaces
import NavigationTesting
import NetworkingInterfaces
import Testing
import UIKit

@testable import Detail

@MainActor
@Suite
struct DetailCoordinatorTests {

    // MARK: - Start Tests

    @Test("GIVEN DetailCoordinator with exchange WHEN start is called THEN pushes detail view controller")
    func startWithExchangePushesDetailViewController() {
        let (sut, doubles) = makeSut(exchange: makeExchange())
        doubles.injectorSpy
            .register(NetworkServiceProtocol.self) { _ in
                doubles.networkSpy
            }

        sut.start()

        #expect(doubles.injectorSpy.calledMethods == [.resolve])
        #expect(doubles.navigationController.calledMethods == [.pushViewController])
    }

    @Test("GIVEN DetailCoordinator with exchangeId WHEN start is called THEN pushes detail view controller")
    func startWithExchangeIdPushesDetailViewController() {
        let (sut, doubles) = makeSut(exchangeId: 1)
        doubles.injectorSpy
            .register(NetworkServiceProtocol.self) { _ in
                doubles.networkSpy
            }

        sut.start()

        #expect(doubles.injectorSpy.calledMethods == [.resolve])
        #expect(doubles.navigationController.calledMethods == [.pushViewController])
    }
}

extension DetailCoordinatorTests {
    typealias SutAndDoubles = (
        sut: DetailCoordinator,
        doubles: (
            networkSpy: NetworkServiceProtocolSpy,
            coordinatorSpy: CoordinatorSpy,
            navigationController: NavigationControllerSpy,
            injectorSpy: DependencyInjectorSpy
        )
    )

    func makeSut(
        exchange: Exchange? = nil,
        exchangeId: Int = 0
    ) -> SutAndDoubles {

        let navigationController = NavigationControllerSpy()
        let coordinatorSpy = CoordinatorSpy(navigationController: navigationController)
        let networkSpy = NetworkServiceProtocolSpy()
        let injectorSpy = DependencyInjectorSpy()
        SharedContainer.shared.setInjector(injectorSpy)


        let sut: DetailCoordinator

        if let exchange = exchange {
            sut = DetailCoordinator(
                parentCoordinator: coordinatorSpy,
                navigationController: navigationController,
                exchange: exchange
            )
        } else {
            sut = DetailCoordinator(
                parentCoordinator: coordinatorSpy,
                navigationController: navigationController,
                exchangeId: exchangeId
            )
        }

        return (sut, (networkSpy, coordinatorSpy, navigationController, injectorSpy))
    }

    func makeExchange() -> Exchange {
        Exchange(
            id: 1,
            name: "Binance",
            description: "Binance Exchange",
            logo: "https://logo.url",
            spotVolumeUsd: 1000000.0,
            makerFee: 0.1,
            takerFee: 0.2,
            dateLaunched: "2017-07-14",
            websiteUrl: "https://binance.com",
            twitterUrl: "https://twitter.com/binance"
        )
    }
}
