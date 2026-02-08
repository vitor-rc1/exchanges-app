//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import DependencyInjectionInterfaces
import NetworkingInterfaces
import HomeInterfaces
import NavigationInterfaces
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
            let parentCoordinator: Coordinator? = SharedContainer
                .shared
                .resolver()
                .resolve(AppCoordinating.self, argument: navigation)
            
            _ = SharedContainer
                .shared
                .resolver()
                .resolve(HomeCoordinating.self, argument: (navigation, parentCoordinator))
        }
    }
}
