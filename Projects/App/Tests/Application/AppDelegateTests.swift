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
import UIKit

@testable import App

@Suite
@MainActor
struct AppDelegateTests {
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
}
