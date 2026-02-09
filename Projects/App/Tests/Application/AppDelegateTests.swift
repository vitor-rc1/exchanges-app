//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import DependencyInjectionInterfaces
import DetailInterfaces
import HomeInterfaces
import NavigationInterfaces
import NavigationTesting
import NetworkingInterfaces
import UIKit

@testable import App

@Suite
@MainActor
struct AppDelegateTests {
    init() {
        _ = AppDelegate()
    }

    @Test("GIVEN AppDelegate initialize THEN it should set injector")
    func setInjectot() async throws {
        #expect(throws: Never.self) {
            _ = SharedContainer.shared.resolver()
        }
    }

    @Test("GIVEN AppDelegate initialize THEN it SHOULD register DI Network")
    func networkRegister() async throws {
        #expect(throws: Never.self) {
            let _: NetworkServiceProtocol = SharedContainer.shared.resolver().resolve()
        }
    }

    @Test("GIVEN AppDelegate initialize THEN it SHOULD register DI Network")
    func appCoordinatorRegister() async throws {
        #expect(throws: Never.self) {
            let navigation = UINavigationController()
            _ = SharedContainer
                .shared
                .resolver()
                .resolve(AppCoordinating.self, argument: navigation)
        }
    }

    @Test("GIVEN AppDelegate initialize THEN it SHOULD register DI AppCoordinating")
    func appCoordinatingRegister() async throws {
        #expect(throws: Never.self) {
            let navigation = UINavigationController()
            _ = SharedContainer
                .shared
                .resolver()
                .resolve(AppCoordinating.self, argument: navigation)
        }
    }

    @Test("GIVEN AppDelegate initialize THEN it SHOULD register DI HomeCoordinating")
    func homeCoordinatorRegister() async throws {
        #expect(throws: Never.self) {
            let navigation = UINavigationController()
            let parentCoordinator: Coordinator? = CoordinatorSpy(children: [],
                                                                 navigationController: navigation)

            _ = SharedContainer
                .shared
                .resolver()
                .resolve(HomeCoordinating.self, argument: (navigation, parentCoordinator))
        }
    }

    @Test("GIVEN AppDelegate initialize THEN it SHOULD register DI DetailCoordinating with Exchange")
    func detailCoordinatorRegister() async throws {
        #expect(throws: Never.self) {
            let navigation = UINavigationController()
            let exchange = Exchange(summary: .init(id: 0, name: "exchange"))

            let parentCoordinator: Coordinator? = CoordinatorSpy(children: [],
                                                                 navigationController: navigation)

            _ = SharedContainer
                .shared
                .resolver()
                .resolve(DetailCoordinating.self, argument: (navigation, parentCoordinator, exchange))
        }
    }

    @Test("GIVEN AppDelegate initialize THEN it SHOULD register DI DetailCoordinating with Exchange identifier")
    func detailWithIdentifierCoordinatorRegister() async throws {
        #expect(throws: Never.self) {
            let navigation = UINavigationController()
            let exchangeId: Int = 21

            let parentCoordinator: Coordinator? = CoordinatorSpy(children: [],
                                                                 navigationController: navigation)

            _ = SharedContainer
                .shared
                .resolver()
                .resolve(DetailCoordinating.self, argument: (navigation, parentCoordinator, exchangeId))
        }
    }
}
