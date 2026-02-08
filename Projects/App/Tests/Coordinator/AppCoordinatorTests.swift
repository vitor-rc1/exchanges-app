//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
//
import DependencyInjectionInterfaces
import DependencyInjectionTesting
import HomeInterfaces
import HomeTesting
import NavigationInterfaces
import NavigationTesting
import Testing
import UIKit

@testable import App

@MainActor
@Suite("AppCoordinator Tests")
struct AppCoordinatorTests {

    // MARK: - Start Tests

    @Test("Start resolves HomeCoordinating from container")
    func startResolvesHomeCoordinator() {
        // Given
        let navigationController = UINavigationController()
        let sut = AppCoordinator(navigationController: navigationController)

        let injectorSpy = DependencyInjectorSpy()
        let homeCoordinatorSpy = HomeCoordinatingSpy(
            children: [],
            navigationController: navigationController
        )

        injectorSpy
            .register(HomeCoordinating.self) { (_, arg: (UINavigationController, Coordinator?)) in
            homeCoordinatorSpy
        }

        SharedContainer.shared.setInjector(injectorSpy)

        sut.start()

        #expect(injectorSpy.calledMethods.contains(.resolveWithArgument))
        #expect(homeCoordinatorSpy.calledMethods.contains(.start))
    }
}
