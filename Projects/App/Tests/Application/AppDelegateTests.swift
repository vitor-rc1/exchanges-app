//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import DependencyInjectionInterfaces
@testable import App

@Suite
@MainActor
struct AppDelegateTests {
    @Test("GIVEN AppDelegate initialize THEN it should set injector")
    func example() async throws {
        #expect(throws: Never.self) {
            _ = SharedContainer.shared.resolver()
        }
    }
}
