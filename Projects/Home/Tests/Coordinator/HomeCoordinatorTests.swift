//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import DependencyInjectionInterfaces
import DependencyInjectionTesting
import DetailInterfaces
import DetailTesting
import HomeInterfaces
import NavigationInterfaces
import NavigationTesting
import NetworkingInterfaces
import Testing
import UIKit

@testable import Home

@MainActor
@Suite
struct HomeCoordinatorTestsTests {

    // MARK: - Start Tests

    @Test("GIVEN HomeCoordinator WHEN start is called THEN push home")
    func startNavigateToHome() {
        let (sut, doubles) = makeSut()
        doubles.injectorSpy
            .register(NetworkServiceProtocol.self) { _ in
                doubles.networkSpy
        }

        sut.start()

        #expect(doubles.injectorSpy.calledMethods == [.resolve])
        #expect(doubles.navigationController.calledMethods == [.pushViewController])
    }

    @Test("GIVEN HomeCoordinator WHEN navigateToDetails is called THEN start details")
    func avigateToDetailsNavitageToDetails() {
        let (sut, doubles) = makeSut()
        let navigationController = doubles.navigationController
        let detailsCoordinatingSpy = DetailCoordinatingSpy(children: [],
                                                           navigationController: navigationController)

        doubles.injectorSpy
            .register(DetailCoordinating.self) { (_, arg: (UINavigationController, Coordinator?, Exchange)) in
                detailsCoordinatingSpy
        }

        sut.navigateToDetails(of: .init(summary: .init(id: 1, name: "")) )

        #expect(doubles.injectorSpy.calledMethods == [.resolveWithArgument])
        #expect(detailsCoordinatingSpy.calledMethods == [.start])
    }
}

extension HomeCoordinatorTestsTests {
    typealias SutAndDoubles = (
        sut: HomeCoordinator,
        doubles: (
            networkSpy: NetworkServiceProtocolSpy,
            coordinatorSpy: CoordinatorSpy,
            navigationController: NavigationControllerSpy,
            injectorSpy: DependencyInjectorSpy
        )
    )

    func makeSut() -> SutAndDoubles {
        let navigationController = NavigationControllerSpy()
        let coordinatorSpy = CoordinatorSpy(navigationController: navigationController)
        let network = NetworkServiceProtocolSpy()
        let injectorSpy = DependencyInjectorSpy()
        SharedContainer.shared.setInjector(injectorSpy)

        let sut = HomeCoordinator(parentCoordinator: coordinatorSpy,
                                  navigationController: navigationController)

        return (sut, (network,
                      coordinatorSpy,
                      navigationController,
                      injectorSpy))
    }
}
